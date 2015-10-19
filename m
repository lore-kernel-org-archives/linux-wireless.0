Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:56502 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbbJSCtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 22:49:02 -0400
Received: from webmail.webfaction.com (wf5.webfaction.com [75.126.149.3])
	by smtp.webfaction.com (Postfix) with ESMTP id C20F859A4423
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 02:49:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 18 Oct 2015 19:49:01 -0700
From: Matt Keveney <matt@keveney.com>
To: linux-wireless@vger.kernel.org
Subject: Troubles with Ralink 3070 USB device.
Message-ID: <56a338958a4bec4e0ab3a79522c05b73@webmail.webfaction.com> (sfid-20151019_044907_465588_C4675FB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I need a hand getting a USB Wifi device going.

The device is a "Legaung LG-N120 outdoor ethernet wifi adapter" which is 
a cheap USB device with a patch antenna I found on eBay.   It's based on 
the Ralink 3070 chip and works great under OSX Mavericks 10.9.5, once I 
found and installed the Ralink software.

I'm now setting up a Gigabyte Brix GB-BXBT-2807 (Celeron) using the 
latest Arch Linux (uname -r reports: 4.2.2-1-ARCH).  The Brix comes with 
a Realtek wifi card installed. (lspci says: RTL8723BE PCIe Wireless 
Network Adapter).  This scans and connects just fine using 
iw/wpa_supplicant or simply wifi-menu.

I've been using these docs as a starting point: 
https://wiki.archlinux.org/index.php/Wireless_network_configuration.

To test, I first shut off the internal wifi with 'ip link set <devname> 
down'
Then I plug in the USB Ralink device
     it shows up in lsusb,
     it can be activated via 'ip link set <devname> up',
     it shows up in 'iw dev'
     it fails 'iw dev <devname> scan' with the terse message 'scan 
aborted'
         this also deactivates the device... 'iw dev' says it's no longer 
'UP'

In more detail:
     I run dmesg -w and open a new pane (using tmux)
     I plug in the device
     dmesg says:
         usb 1-1: new high-speed USB device number 4 using xhci_hcd
         usb 1-1: reset high-speed USB device number 4 using xhci_hcd
         ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 3070, rev 201 
detected
         ieee80211 phy1: rt2x00_set_rt: Info - RT chipset 0005 detected
         ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
         usbcore: registered new interface driver rt2800usb
         rt2800usb: 1-1:1.0 wlp0s20u1: renamed from wlan0
     I run 'lsusb'
     It says, among other things:
         ...
         Bus 001 Device 004: ID 148f:3070 Ralnk Technology, Corp. 
Rt2800/RT3070 Wireless Adapter
         ...
     I run 'ip link'
     The new device is now there:
         ...
         4: wlp0s20u1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state 
DOWN mode DEFAULT group default qlen 1000
             link/ether hh:hh:... ff:ff:ff:ff:ff:ff
     I run 'ip link set wlp0s20u1 up'
     dmesg says:
         ieee80211 phy1: rt2x00lib_request_firmware: Info - Loading 
firmware file 'rt2870.bin'
         ieee80211 phy1: rt2x00lib_request_firmware: Info - Firmware 
detected - version: 0.29
         IPv6: ADDRCONF(NETDEV_UP): wlp0s20u1: link is not ready
     I note that the firmware filename doesn't seem to be the expected 
rt3070.bin, but I press on.
     I run 'ip link'
     It reports the new device activated:
         ...
         4: wlp0s20u1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc 
mq state DOWN mode DEFAULT group default qlen 1000
             link/ether hh:hh:... ff:ff:ff:ff:ff:ff
     I run 'iw dev wlp0s20u1 scan'
     It says:
         scan aborted!
     demsg says:
         usb 1-1: USB disconnect, device number 4
         usb 1-1: new high-speed USB device number 5 using xhci_hcd
         usb 1-1: reset high-speed USB device number 5 using xhci_hcd
         ieee80211 phy2: rt2x00_set_rt: Info - RT chipset 3070, rev 0201 
detected
         ieee80211 phy2: rt2x00_set_rt: Info - RT chipset 0005 detected
         ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
         rt2800usb 1-1:1.0 wlp0s20u1: renamed from wlan0

     ...so it seems that the 'scan' caused the usb driver to 
disconnect/reconnect the device.

The same steps with 'iw event -t -f' running in extra pane give these 
messages:

     <plug in>
     ...: phy #1: renamed to phy1
     <remaining steps ending with scan>
     ...: wlp0s20u1 (phy #1): scan sarted
     ...:  (phy #1): scan aborted: 2412 2417 2422 2427 ...

I've also tried skipping the scan, and connecting to a known access 
point with wpa_supplicant.  I get similar results.  I can post details 
if it will help.

In researching the surprising firmware filename issue, I find that 
/usr/lib/firmware/rt3070.bin
is merely a link to rt2870.bin.  A bit of research revealed that this is 
normal and correct:

     https://wireless.wiki.kernel.org/en/users/drivers/rt2800usb
     
http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/commit/?id=ae524638c277301a83daf126aaaf880738e2474b

Here, I would expect dmesg to show me the name of the link instead of 
the link target, but I'm not too worried about this.  That commit was 
four years ago; perhaps the parent driver now knows enough to directly 
load rt2070.bin for the 3070.

Just to be sure the firmware file is okay, I cloned the latest 
linux-firmware git repo and confirmed that rt2070.bin is a binary match 
for what I have.  I also checked this against the mediatek source code 
(url below), and found that it differed, so I tried the mediatek version 
too.  It fails as before, except that dmesg reports firmware version 
0.32, which is slightly newer than above.

So, next I thought about trying to compile the 'latest' driver code from 
MediaTek (who now owns Ralink), but comments in the readme say it's for 
2.4-2.6 kernels:

   
http://mediatek.com/en/downloads1/downloads/rt8070-rt3070-rt3370-rt3572-rt5370-rt5372-rt5572-usb-usb/

   ...of course it's possible that the code is current and the _comment_ 
is out-of-date :).
   Should I give it a try?

Before resorting to that I reviewed everything I could find in 
https://wireless.wiki.kernel.org/, and thought I'd post here first.

Any tips for further troubleshooting?  What logs should I be looking at?

-Matt

