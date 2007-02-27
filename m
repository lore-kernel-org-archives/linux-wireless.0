Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:46206 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810AbXB0MCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 07:02:06 -0500
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id B597F8D124
	for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2007 12:48:47 +0100 (CET)
Received: from flatcat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 83A00FAFC
	for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2007 11:49:43 +0000 (UTC)
Received: from [127.0.0.1] (flatcat.home.warmcat.com [127.0.0.1])
	by flatcat.home.warmcat.com (Postfix) with ESMTP id B3D801310212
	for <linux-wireless@vger.kernel.org>; Tue, 27 Feb 2007 11:48:46 +0000 (GMT)
Message-ID: <45E41A9E.2020908@warmcat.com>
Date: Tue, 27 Feb 2007 11:48:46 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC] Penumbra - Enabling unencrypted broadcasts alongside normal  traffic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

Introduction
------------

I have been working on a GPL project called Penumbra

http://penumbra.warmcat.com

The idea is simple, to allow unencrypted wireless broadcast packets to 
be generated and received in userspace, while the normal traffic remains 
privately encrypted as before.  This allows direct intercommunication 
between boxes on differently protected private networks (on the same 
channel) while not disturbing or reducing security of a normal encrypted 
association.

Due to the broadcast nature of the protocol, there are no station 
identities at all.  All broadcast packets use the same MAC and there is 
no concept of addressability, at least not at the protocol level.  There 
are no retries at the transport protocol level either since there may be 
many listeners --  situations where there are multiple listeners in 
range of the broadcasts are very well served.  Higher levels on protocol 
can implement tunneling other protocols and retransmission requests, but 
that is out of scope of what is needed in the 80211 stack.

We have a userspace daemon that allows anonymous filesharing using the 
protocol, but there are many other applications possible for machines to 
be able to remain secure and private for normal traffic, yet be able to 
also communicate locally unencrypted when they choose without going 
through the Internet, an ISP or other paid -- and metered -- gateway.

There is a start on a formal RFC for the broadcast transport protocol here:

http://penumbra.warmcat.com/penumbra-rfc-0.0.3.txt


Status
------

Currently I have this working for several wireless devices using the old 
stack (IPW2200, IPW3945, and ZD1211RW -- BCM43XX is also done but does 
not always receive for reasons I didn't discover), and I have it working 
on the new stack for iwlwifi and RT73USB (RT2571 chipset) too now.  The 
old stack drivers are patched without any changes to the old stack, but 
for the new 80211 stack, the additional code is mostly tucked away in 
the stack.  You can see examples of the patching required in both the 
stack and the driver for the rt73usb case here:

http://penumbra.warmcat.com/rt2x00-cvs-2007021403-penumbra-0.0.3.patch

There is a related userspace daemon also available which communicates 
via an embedded https server with the user and allows arbitrary files to 
be shared around using the broadcast protocol.  The daemon bridges 
traffic between multiple wireless devices on different channels seamlessly.

All patches and the penumbrad daemon are available here:

http://penumbra.warmcat.com/_twk/tiki-index.php?page=Downloads

Performance at the moment for a iwlwifi <-> IPW2200 testcase is between 
100KBytes/sec and 200KBytes/sec transfer, tested while downloading 
simultaneously at 1MByte/sec using a WPA encrypted association to a 
Belkin AP.  So any questions about whether it is possible, or can work 
on a range of devices, or can operate simultaneously with WPA are 
answered: it works great.


Implementation
--------------

The unencrypted broadcast packets are indicated by having a "Magic MAC" 
address in their IEEE80211 Header Addr<n> fields.  The Magic MAC for 
Penumbra is 13:22:33:44:55:66 (the IEEE had something to say about our 
original choice of 11:22.. :-O ).

Here is the path for a packet using the new stack patched to support the 
protocol.

  - Userspace transmits by creating a PF_PACKET / SOCK_RAW socket and 
prepending an Ethernet header with the Magic MAC in it and send()ing it. 
  Reed-Solomon coding is optionally used in userspace in case the 
receiver allows to see damaged packets.

  - The stack detects the magic MAC, and prepends a fixed IEEE80211 
header to the skb, basically addr1-> FF:FF:FF:FF:FF:FF, addr2 and addr3 
-> 13:22:33:44:55:66 and encryption is turned off.

  - The wireless driver gets the packet for transmission, recognizes the 
Magic MAC, disables retries and sets the transmission rate (currently 
fixed 54Mbps, but this will change) and transmits the packet as a broadcast

For receive:

  - The wireless device is set to hardware promiscuous

  - When an incoming packet is seen with the magic MAC it has a fake 
fixed Ethernet, IP and UDP header prepended to it.  IP and UDP checksums 
are inserted so the packet is clean.  The packet always looks like it is 
coming from UDP 0.0.0.0:61441 (port 0xF001) and is directed to 
255.255.255.255:61442 (port 0xF002).  The packet is subject to iptables 
rules as usual.

  - Userspace listens on the right interface at UDP 61442 with a normal 
socket and receives the packets as usual.

There is some more detail and information here (it is about the old 
stack implementation currently though)

http://penumbra.warmcat.com/_twk/tiki-index.php?page=Implementation


Issues
------

I hope there is some interest in this new capability for wireless 
devices in Linux.  To get any kind of widespread use, the capability 
needs to be already available in stock kernels and drivers so that the 
user only needs to open iptables and run a userspace daemon rather than 
patch his wireless drivers and stack.  So this is my reason for 
presenting this Request For Comments, to see if it can be considered.

Some of the issues that need working on/consensus if there is interest:

  - Hardware promisc is needed to catch the packets because they are not 
tagged as coming from the local AP.  All the devices I looked at can do 
hardware promisc separately from the logical promisc for Monitor mode. 
But perhaps this needs to be enabled and disabled in some modal way.

  - The way the packets are captured does not integrate at the moment 
with the rx handler list concept, because it needs access to args that 
do not come to the "pre" rx handlers where it has to capture.  No doubt 
there are multiple other implementation issues that can be hammered out 
easily enough if there is interest.

  - Right this second there are two patches, one for the iwlwifi case 
and one for rt2x00, since they are using different versions of the new 
80211 stack.

  - The first byte of the payload is reserved for holding the desired TX 
rate sent up from userspace, as well as indications about any ECC coding 
that is present.  But today only a fixed 54Mbps packet rate is 
implemented.  Despite all the stations are anonymous, the upper levels 
of the protocol can guess the best rate to send a particular packet 
depending on what has been going on, and so allow the system to work 
over larger distances than 54Mbps only will allow.

...  no doubt there will be more assuming there is any interest ;-)

Thanks for reading this far and I hope it will be possible by adding 
these relatively small changes to the stack to enable some cool 
additional uses for existing wireless devices.

-Andy
