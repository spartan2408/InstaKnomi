pragma solidity ^0.5.0;

contract Decentragram{
  string public name = "Decentragram";

  //store images
  uint public imageCount =0;
  mapping(uint => Image) public images;


  struct Image{
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
    );
  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
    );

    //create images
  function uploadImage(string memory _imagehash, string memory _description) public{
        

        //make sure image hash exists
        require(bytes(_imagehash).length >0);

        //make sure image description exists
    require(bytes(_description).length >0);

    //make sure uploader description exists
    require(msg.sender != address(0x0));


    //increment image id
    imageCount++;
    
    //add image to the contract
    images[imageCount]= Image(imageCount,_imagehash,_description,0,msg.sender);

    //trigger the event

    emit ImageCreated(imageCount, _imagehash, _description, 0 , msg.sender);
  }  

  function tipImage(uint _id)public payable{
    //make sure the id is valid
    require(_id > 0 && _id<= imageCount);

    //fetch the image
    Image memory _image = images[_id];

    //fetch the author
    address payable _author = _image.author;

    //pay the author by sending them ether
    address(_author).transfer(msg.value);

    //increment the tip amount
    _image.tipAmount= _image.tipAmount + msg.value;

    //update the image
    images[_id] = _image;
    
    //trigger an event

    emit ImageTipped(_id, _image.hash, _image.description,_image.tipAmount, _author);
  } 
}