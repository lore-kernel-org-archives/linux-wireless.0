Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:53257 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZEHJHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 05:07:51 -0400
Message-ID: <4A03F67B.1000101@shockfish.com>
Date: Fri, 08 May 2009 11:08:11 +0200
From: Alexandre Becholey <alexandre@shockfish.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Ivo van Doorn <ivdoorn@gmail.com>
Subject: [rt73usb] Master Mode almost done; problem with ARP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As the subject says, the master mode for rt73usb is almost fixed. Here 
is my setup:
- An access point running hostapd with an ethernet interface (eth0) and 
a wireless interface (wlan0, the wifi usb dongle) which are bridge 
together (br0)
- a computer directly (or through a switch with other computer) 
connected to the AP's eth0
- two computers associated to wlan0
(they all are on Linux)

Here is what I can do:
- Stations can associate with the wifi usb dongle
- Stations can ping, ssh,... the AP
- Stations can ping, ssh,... any other stations
- Stations can ping, ssh,... any computers on the LAN
- AP can ping any computers on the LAN
- Computers on the LAN can ping the AP

And what I can't do:
- Computers on the LAN can't ping the stations (Destination Host 
Unreachable)
- AP can't ping the stations

I ran wireshark on a computer on the LAN, on the AP (here I used tcpdump 
on all interfaces because I don't have the possibility to have X) and on 
a stations. I would say that's a problem with ARP packets.
When I try to ping a station from the AP or a LAN computer, ARP requests 
arrive to the AP (I see them on eth0, wlan0 and br0), but they don't 
arrive to the stations (I can't see any ARP packets in the air and I use 
a different wireless interface to monitor than the one that is 
associated with the AP).
When with that station I ping the AP (or the lan computer, it doesn't 
matter), the first ping (from AP or lan) works until I stop the ping 
started on the station.

I was wondering if the fix I did (the one we were discussing the 5th 
March) on the rt73 driver may be the cause of that problem.

Best regards,

Alexandre Becholey

