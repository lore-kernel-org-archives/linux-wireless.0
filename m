Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:60754 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab2LSKDm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 05:03:42 -0500
Received: from mailout-de.gmx.net ([10.1.76.37]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LwCie-1T2gRh2cYw-0185Xr for
 <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2012 10:50:59 +0100
Message-ID: <50D18E01.7080502@gmx.net> (sfid-20121219_110345_922445_64874B58)
Date: Wed, 19 Dec 2012 10:50:57 +0100
From: George News <george.news@gmx.net>
MIME-Version: 1.0
To: Linux Wireless mailing list <linux-wireless@vger.kernel.org>
Subject: Change adhoc network speed not working
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm using Ubuntu 12.04.1 64bit with a TPLink TL-WN821 v3. The driver 
used is ath9k_htc. I'm creating an adhoc/ibss network and want to change 
the bitrate of the network.

First of all I disable wireless from the network manager in order to be 
able to execute my commands.

These are the commands I execute on both ends:

         master$ sudo ifconfig wlan0 down
	master$ sudo rfkill unblock wifi
	master$ sudo iw dev wlan0 set type ibss
	master$ sudo iw dev wlan0 set bitrates legacy-2.4 1
	master$ sudo ifconfig wlan0 up
	master$ sudo iw dev wlan0 ibss join adhoc_linux 2462
	master$ sudo ifconfig wlan0 1.2.3.4 up
	master$ iperf -s -u -l 1472

	slave$ sudo ifconfig wlan0 down
	slave$ sudo rfkill unblock wifi
	slave$ sudo iw dev wlan0 set type ibss
	slave$ sudo iw dev wlan0 set bitrates legacy-2.4 1
	slave$ sudo ifconfig wlan0 up
	slave$ sudo iw dev wlan0 scan | less
	slave$ sudo iw dev wlan0 ibss join adhoc_linux 2462
	slave$ sudo ifconfig wlan0 1.2.3.5 up
	slave$ iperf -c 1.2.3.4 -u -b 100M -l 1472 -t 25 -i 1

As you can see I want to set the speed to 1 Mbps. However I don't know 
why I get 25Mbps from iperf which is more or less the maximun speed for 
802.11g (theoretically 54Mbps but in reality is something like 30Mbps).

The output of `iw dev wlan0 station dump` reports that both nodes are 
attached to the same network at 54Mbps.

After testing that I have also tried with another command:

$ sudo iw dev wlan0 ibss join adhoc_linux 2462 basic-rates 1

But I got the same result.

I have tried many many things, putting the iface up, down, leaving the 
ibss net, setting the speed while iface up, etc. I'm just stuck.

Any help is more than welcome.

Jorge


P.S.: Please include my email address in the reply as I'm not subscribed 
to the list and otherwise I won't be receiving the answer.
