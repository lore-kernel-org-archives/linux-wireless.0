Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2706 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab1CLSMP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 13:12:15 -0500
From: Frans Leerink <f.leerink@xs4all.nl>
Date: Sat, 12 Mar 2011 20:11:38 +0100
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Wireless Network, openSUSE11.4 and my Network Controller Intersil Corporation ISL3890 [Prim GT / Prism Duette] [1260:3890] and its (prism)driver
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201103122011.38936.f.leerink@xs4all.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am still hapilly using my Medion MD41300 Notebook from june 2004. This 
Notebook is equipped with a 3,06GHz Mobile Intel Pentium 4 processor + 
Hyper Threading Technology,  1MB of memory and Intersil's Corporation 
ISL3890 [Prim GT / Prism Duette] [1260:3890] Network Controller [0280].

This Notebook was running openSUSE  10.3 and used the prism54 driver 
successfully for the wireless network interface. Unfortunately this 10.3 
openSUSE release is no longer supported, so I tried the openSUSE 11.4 / 
KDE4 prerelease RC2 (build 0012) on it and that runs very well with 
wired network. For the wireless Network I found the following URL:

	http://wireless.kernel.org/en/users/Drivers/p54

and tried to use the new p54pci driver in combination KNetwork Manager
without success up to now. Since the referenced URL asks for information 
if for whatever reason the new  p54pci cannot be used, I send you the 
following info. 
So let me point wise state what I have done/experienced sofar.:

0	Installation of the latest prerelease of openSUSE 11.4 / KDE4 went
	well and works fine including wired networking via KNetworkmanager.
	Start up less 2 minitues, sleep functionality worked out of the box,
	great.   

1 	Identify the type of Intersil/Conexant chipset you have.
   	Using Identifying via  "lspci -nn" route:

MD41300-openSUSE:/home/frans # lspci -nn   ----->
03:06.0 Network controller [0280]: Intersil Corporation ISL3890 [Prism 
GT/Prism Duette]/ISL3886 [Prism Javelin/Prism Xbow] [1260:3890] (rev 01)
MD41300-openSUSE:/home/frans # 

	What should I look for by pasting  [1260:3890] in Google ???

2	Identify your kernel version, this can be done via: uname -r

MD41300-openSUSE:/home/frans # uname -r
2.6.37.1-1.2-default
MD41300-openSUSE:/home/frans #


3	Find the correct firmware for your device

	According to the URL, table and the kernel version I should
	download and rename the firmware as required

	for 2.6.29 kernels and above:
    	card type    		required filename    recommended image
    	PCI / PCMCIA		isl3886pci    		    download 2.13.25.0.arm
 
	I have renamed the downloaded firmware file to isl3886 and copied
	it into the existing  /lib/firmware directory.

	I have unloaded the diver with command  modprobe -r p54pci ??? and 	
	than reload the driver via modprobe p54pci  
	In both cases the system accepted the commands without comment.
	What happens if original an other driver was loaded ??

4	I have configured KNetworkmanager for the Wireless-Home connection
	with a fixed IP-address 192.168.2.156, mask 255.255.255.0 , Gateway
	/ DNS server both 192.168.2.138 and the required wireless security 		
	data and started the Wireless-Home connection after I had 
	disconnected the network cable.
	KNetworkmanager showed the Wireless-Home connection as connecting
	and waiting on security. But checking/confirming a number of times
	the security pop-up screen does not change the situation-noconnection
 
	The output of dmesg is as follows: 

MD41300-openSUSE:/home/frans # dmesg
.......
........
[24802.479679] eth0: link down
[25751.328409] cfg80211: Calling CRDA to update world regulatory domain
[25751.668892] cfg80211: World regulatory domain updated:
[25751.668898]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[25751.668902]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[25751.668905]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[25751.668909]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 
2000 mBm)
[25751.668912]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[25751.668916]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 
2000 mBm)
[25751.672598] p54pci 0000:03:06.0: PCI INT A -> GSI 18 (level, low) -> 
IRQ 18
[25751.700051] ieee80211 phy0: p54 detected a LM86 firmware
[25751.700062] p54: rx_mtu reduced from 3240 to 2376
[25751.700068] ieee80211 phy0: FW rev 2.13.25.0 - Softmac protocol 5.9
[25751.700074] ieee80211 phy0: cryptographic accelerator WEP:YES, 
TKIP:YES, CCMP:YES
[25752.553120] ieee80211 phy0: hwaddr 00:60:b3:1e:5a:fd, MAC:isl3890 
RF:Frisbee
[25752.732041] ieee80211 phy0: Selected rate control algorithm 
'minstrel_ht'
[25752.738619] Registered led device: p54-phy0::assoc
[25752.739294] Registered led device: p54-phy0::tx
[25752.739867] Registered led device: p54-phy0::rx
[25752.740040] Registered led device: p54-phy0::radio
[25752.740040] p54pci 0000:03:06.0: is registered as 'phy0'
[25753.778369] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[26679.493804] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[26679.692041] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[26679.892119] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[26680.092327] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
[26689.630424] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[26689.828929] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[26690.028297] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[26690.228041] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[26699.764302] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[26699.962465] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[26700.160040] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[26700.360075] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
[26724.737189] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[26724.936414] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[26725.136088] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[26725.336102] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[26734.896072] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[26735.092351] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[26735.292048] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[26735.492238] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
[26745.036877] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[26745.236040] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[26745.436060] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[26745.636097] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[28103.089697] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[28103.289332] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[28103.488109] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[28103.688040] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[28113.225844] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[28113.424040] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[28113.624066] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[28113.824183] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
[28123.360901] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[28123.560040] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[28123.760043] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[28123.960040] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[28498.821799] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[28499.020106] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[28499.220041] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[28499.420337] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
[28508.960879] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 1)
[28509.160087] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 2)
[28509.360040] wlan0: direct probe to 00:0a:e9:0f:0f:c7 (try 3)
[28509.560025] wlan0: direct probe to 00:0a:e9:0f:0f:c7 timed out
[28519.092895] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 1)
[28519.293939] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 2)
[28519.492266] wlan0: direct probe to 00:0a:e9:0f:0d:99 (try 3)
[28519.692104] wlan0: direct probe to 00:0a:e9:0f:0d:99 timed out
MD41300-openSUSE:/home/frans #


What can I do to help the resolutionof this problem. I am on ski 
vacation from tomorrow to saturday 19 march.

At least I will try the install of the final openSUSE 11.4 release that
I have just downloaded and burned on a DVD

Awaiting your reply
-- 
Regards / Groeten,
	
	Frans
