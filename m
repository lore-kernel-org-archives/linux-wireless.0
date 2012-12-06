Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.compro.net ([12.186.155.4]:3843 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710Ab2LFOYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 09:24:19 -0500
Message-ID: <50C0A743.3000305@compro.net> (sfid-20121206_152423_356618_ADE5D3BC)
Date: Thu, 06 Dec 2012 09:10:11 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Mark Hounschell <dmarkh@cfl.rr.com>
Subject: Wireless network problem with Access Point selection using ifup
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a wireless-N Linksys router centrally located in my home. I also 
have 2 each Linksys E1000 range extenders located at each end of the 
house. I have Desktop computers in fixed locations around the house. 
Using Network Manager all is well with all of them. I can see all the 
Access Points and select the one with the best signal. However network 
manager doesn't seem to be a valid option for all of them and I'm using 
traditional ifup with static configurations.

When using ifup, wrong Access Points are being chosen by whatever the 
underlying userland/kernel process is that is supposed to select it. And 
I admit I do not know what that process is. It seems it wants to select 
the one with the weakest signal instead of the strongest.  Most of the 
time, the AP furthest away is selected. Often the router in the middle 
of the house is selected. Very very rarely is the closest AP chosen. 
When the furthest is chosen, I am unable to use the network. When the 
router in the middle of the home is selected, the connection comes to a 
crawl and often disassociates in the middle of use. When it does choose 
the correct AP, all is well until I reboot the machine.

I'm being told that when using ifup and WPA, as opposed to WEP, that 
userland has no choice in the selection of an Access Point by MAC 
address, only by SSID. All my APs have the same SSID.

I am using SuSE 12.2 Linux and 3.6.6 kernels on all these machines and 
the wireless hardware I am using on all these is are ASUS USB-300N adapters.

lsusb output: Bus 001 Device 004: ID 0b05:17ab ASUSTek Computer, Inc.

The kernel driver being used is rtl8192cu.


Some sample dmesg and iwconfig output when the AP at the other end of 
the house was selected:


[   19.876977] wlan0: authenticate with c8:d7:19:7a:ab:1e
[   19.901616] wlan0: send auth to c8:d7:19:7a:ab:1e (try 1/3)
[   19.904099] wlan0: authenticated
[   19.916679] wlan0: associate with c8:d7:19:7a:ab:1e (try 1/3)
[   19.925839] wlan0: RX AssocResp from c8:d7:19:7a:ab:1e (capab=0x411 
status=0 aid=2)
[   19.925975] wlan0: associated
[   19.925988] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready



wlan0     IEEE 802.11bgn  ESSID:"hounschell-1"
               Mode:Managed  Frequency:2.437 GHz  Access Point: 
C8:D7:19:7A:AB:1E
               Bit Rate=150 Mb/s   Tx-Power=20 dBm
               Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
               Encryption key:off
               Power Management:off
               Link Quality=66/70  Signal level=-44 dBm
               Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
               Tx excessive retries:0  Invalid misc:9   Missed beacon:0

This AP is at the other end of the house. The network was unusable after 
this boot.

Is this likely a kernel issue? If so, I would be willing to file a BUG 
report and even help with it if I can with my configuration.

Regards
Mark

