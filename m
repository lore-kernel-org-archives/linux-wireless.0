Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dd24806.kasserver.com ([85.13.129.11]:58666 "EHLO
	dd24806.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab0DVLqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 07:46:05 -0400
Received: from rambo.localnet (dslb-084-057-102-201.pools.arcor-ip.net [84.57.102.201])
	by dd24806.kasserver.com (Postfix) with ESMTPSA id 8F786BA21CA
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 13:39:49 +0200 (CEST)
From: Antonio Weber <antonio.weber@msys-gmbh.de>
To: linux-wireless@vger.kernel.org
Subject: p54usb - AP degenerates (Kernel 2.6.31.13)
Date: Thu, 22 Apr 2010 13:39:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201004221339.47788.antonio.weber@msys-gmbh.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi List,

I try to set up a Accesspoint with a Netgear WG111v2 USB Stick which is 
supported by the p54 driver. 
I'm working on a small evaluation board with a i.mx27 ARM cpu which is 
currently not supported via the mainline kernel. For that the vendor provides 
a kernel patch to support it. I allready tried to port it to the 2.6.33 Kernel 
- it compiles without bigger troubles but the Kernel was unable to boot (gets 
not even uncompressed - litte bit strange - so what... :) - have to stay at 
2.6.31 line)

The startup with hostapd works fine. At the moment i have encryption disabled 
so it is easy to connect because it is only for demostration purpose (even a 
handy or ipod should be able to connect) and works in a closed environment for 
max. an hour or so.

Some debug output here

---------
usb 1-1: new high speed USB device using mxc-ehci and address 2
usb 1-1: New USB device found, idVendor=0846, idProduct=4240
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: NETGEAR WG111
usb 1-1: Manufacturer: GlobespanVirata
usb 1-1: SerialNumber: 3887-0000
usb 1-1: configuration #1 chosen from 1 choice
cfg80211: Calling CRDA to update world regulatory domain
usb 1-1: firmware: requesting isl3887usb
phy0: p54 detected a LM87 firmware
p54: rx_mtu reduced from 3240 to 2384
phy0: FW rev 2.13.24.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:0f:b5:02:2e:64, MAC:isl3887 RF:Frisbee
phy0: Selected rate control algorithm 'minstrel'
usb 1-1: is registered as 'phy0'
usbcore: registered new interface driver p54usb
eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
phy0: device now idle
in p54_set_ps: 2
phy0: device no longer idle - in use
in p54_set_ps: 2
cfg80211: Calling CRDA for country: DE
phy0: Allocated STA f8:1e:df:d1:df:8e
phy0: Inserted STA f8:1e:df:d1:df:8e
----------

up to here - everything works fine. A device gets an IP address via dhcp after 
connecting, can ping etc.
after some minutes lots of that messages apear

-----------

wlan0: STA f8:1e:df:d1:df:8e aid 1 enters power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 exits power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 sending 0 filtered/0 PS frames since STA 
not sleeping anymore
wlan0: STA f8:1e:df:d1:df:8e aid 1 enters power save mode
STA f8:1e:df:d1:df:8e aid 1: PS buffer (entries before 0)
STA f8:1e:df:d1:df:8e aid 1: PS buffer (entries before 1)
wlan0: STA f8:1e:df:d1:df:8e aid 1 exits power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 sending 0 filtered/2 PS frames since STA 
not sleeping anymore
wlan0: STA f8:1e:df:d1:df:8e aid 1 enters power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 exits power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 sending 0 filtered/0 PS frames since STA 
not sleeping anymore
wlan0: STA f8:1e:df:d1:df:8e aid 1 enters power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 exits power save mode
wlan0: STA f8:1e:df:d1:df:8e aid 1 sending 0 filtered/0 PS frames since STA 
not sleeping anymore
.....

------------
(btw weird mac address, isn't it?)

and then it refuses to work. No futher devices can connect. Even the connected 
devices can not be ping anymore because ARP packets are no longer answered.

On my laptop I get that kernel-messages when trying to connect to the ap

------------

wlan0: deauthenticating from 00:0f:b5:02:2e:64 by local choice (reason=3)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 1)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 2)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 3)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 timed out
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 1)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 2)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 (try 3)
wlan0: direct probe to AP 00:0f:b5:02:2e:64 timed out

--------------

Its probably a problem with the power management in station mode (which seems 
to be an issue to more drivers as I found out reading some entries on this 
list).

So my questions are:
Is it perhaps possible to disable that powersave mode for AP completly in an 
'easy' way? (btw. 'enable powersave by default' is disabled in kernel config 
but thats only for managed mode right?).

If not - could it be allready fixed in a newer version of the kernel? If so it 
would be great if someone out there could give me some pointer where to look 
at in special - so I can try to fix it myself (somehow :) )

Thanks in advance

greetings,
Antonio
