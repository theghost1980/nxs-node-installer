#!/bin/bash

# size of swapfile in megabytes
swapsize=1024

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo 'swapfile not found. Adding swapfile.'
	fallocate -l ${swapsize}M /swapfile
	chmod 600 /swapfile
	mkswap /swapfile
	swapon /swapfile
	echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
	echo 'swapfile found. No changes made.'
fi

# output results to terminal
#cat /proc/swaps
#cat /proc/meminfo | grep Swap

#install required Dependancies and compile
cd ~/
sudo apt-get update && sudo apt-get install -y git build-essential libboost-all-dev libssl-dev libminiupnpc-dev unzip libdb-dev libdb++-dev
git clone https://github.com/Nexusoft/Nexus.git Nexus
cd ~/Nexus
make -f makefile.unix USE_LLD=1

#download DB bootstrap, extract and create nexus.conf
cd ~/
wget http://nexusminingpool.com/downloads/LLD100117.zip
mkdir .Nexus
unzip LLD100117.zip
cd .Nexus
cat > nexus.conf <<- "EOF"
rpcuser=rpcserver
rpcpassword=12345678+originalSEXYone
daemon=1
server=1
unified=1
addnode=52.63.26.48
addnode=52.68.138.229
addnode=54.169.106.238
addnode=52.78.170.114
addnode=52.64.203.106
addnode=52.66.23.129
addnode=52.67.182.108
addnode=54.173.118.111
EOF

#Launch the wallet daemon
cd ~/Nexus
./nexus
