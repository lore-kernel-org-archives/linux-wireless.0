Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:55455 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753268AbZDYUbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 16:31:03 -0400
To: linux-wireless@vger.kernel.org
Subject: Problems with ADM8211 driver
From: Alf <alf@mypals.org>
Date: Sat, 25 Apr 2009 14:31:02 -0600
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200904251431.02196.alf@mypals.org> (sfid-20090425_223111_564390_281380D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a D-Link PCI card with a ADM8211 driver:

  00:07.0 Network controller: ADMtek ADM8211 802.11b Wireless Interface
    (rev 11)

A few years ago I used it in Linux with the out-of-tree driver without any 
problems.  I now have need of the card again in Linux, but the card doesn't 
want to associate with the AP.  I tried the card under Windows and it worked 
well, so I know it's not hardware or configuration issues.

I am using kernel 2.6.29.1 with version 29 of the wireless_tools package and 
wpa_supplicant 0.6.9.  I have disabled wpa_supplicant and have tried 
configuring the card directly with iwconfig:

  iwconfig wlan0 essid (ssid) channel 1 mode managed \
    key (some hex junk)

In the end, iwconfig reports:

 wlan0     IEEE 802.11b  ESSID:"(ssid)"
           Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated
           Tx-Power=27 dBm
           Retry min limit:7   RTS thr:off   Fragment thr=2352 B
           Encryption key:(some hex junk)   Security mode:open
           Power Management:off
           Link Quality:0  Signal level:0  Noise level:0
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:0   Missed beacon:0

There are a few weird things I'm observing:

- The signal level and noise level are both at 0.

- Even when scanning, the signal strength is very low even though the AP is 
4 feet away (Quality=0/100  Signal level:19/100).  Windows reports a strong 
signal.  

- The kernel log only reports the following problems:

 Apr 25 11:22:17 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44 try 1
 Apr 25 11:22:17 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44 try 2
 Apr 25 11:22:18 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44 try 3
 Apr 25 11:22:18 xyz wlan0: direct probe to AP 00:30:bd:60:d3:44 timed out

 (the AP mac address is correct)

- When the card is loaded, there is a significant pause (about 15 seconds) 
when I first try to do something with the card.  For example, if I load the 
module and use iwconfig as outlined above and then run iwconfig again to see 
the configuration, it takes about 15 or 16 seconds for it to display.  Also, 
if any services (like ssh) want to bind the address when it first comes up, 
sshd takes about 15 seconds to start.  But, once this delay has happened, 
everything else works fine.  For example, if I run iwconfig again, it 
displays the information immediately.

Would any of you have any pointers on how to debug the problem with this 
card and fix it?  I'm running a custom kernel, so I can reconfigure or patch 
as necessary.  (Distribution is Linux From Scratch;  all other similar 
systems with wireless networking work just fine.)

Thanks in advance.

-- 
Alf
@

