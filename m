Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:54743 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0AWWWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 17:22:24 -0500
Received: by ywh6 with SMTP id 6so2123916ywh.4
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 14:22:23 -0800 (PST)
Subject: Re: b43 driver hang with bcm4318
From: Eric Volker <evolker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 16:22:21 -0600
Message-ID: <1264285341.3547.8.camel@fwdell4550>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-01-20 at 04:15 +0100, Gábor Stefanik wrote:

> Please post the logs here for analysis. That's specifically the reason
> I asked you to load b43 with debugging enabled.
> 

I finally got the b43 module to load at boot with the verbose=3
parameter. To keep things to a minimum, I'm going to post the output of
"dmesg | grep -e b43".

[    0.000000] Kernel command line:
root=UUID=360e77ce-b2ed-4318-93c6-96a1a1dad60d b43.verbose=3 ro quiet
splash 
[    0.000000] Unknown boot option `b43.verbose=3': ignoring
[    1.704798] b43-pci-bridge 0000:02:02.0: PCI INT A -> GSI 18 (level,
low) -> IRQ 18
[   29.676541] b43-phy0: Broadcom 4318 WLAN found (core revision 9)
[   29.732395] b43-phy0 debug: Found PHY: Analog 3, Type 2, Revision 7
[   29.732420] b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050,
Revision 8
[   30.617172] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[   30.707565] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[   30.736709] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[   30.779077] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[   31.141260] b43-phy0: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[   31.156124] b43-phy0 debug: Chip initialized
[   31.156363] b43-phy0 debug: 32-bit DMA initialized
[   31.178664] Registered led device: b43-phy0::tx
[   31.178704] Registered led device: b43-phy0::rx
[   31.178729] Registered led device: b43-phy0::radio
[   31.178761] b43-phy0 debug: Wireless interface started
[   31.178772] b43-phy0 debug: Adding Interface type 2
[   32.992131] b43-phy0 debug: Removing Interface type 2
[   32.992275] b43-phy0 debug: Wireless interface stopped
[   33.192028] b43-phy0: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[   33.212972] b43-phy0 debug: Chip initialized
[   33.213223] b43-phy0 debug: 32-bit DMA initialized
[   33.232438] Registered led device: b43-phy0::tx
[   33.232464] Registered led device: b43-phy0::rx
[   33.232489] Registered led device: b43-phy0::radio
[   33.232520] b43-phy0 debug: Wireless interface started
[   33.232955] b43-phy0 debug: Adding Interface type 3
[   33.252727] b43-phy0 debug: Set beacon interval to 100
[   33.280161] b43-phy0 debug: Updated beacon template at 0x68
[   33.280254] b43-phy0 debug: Updated beacon template at 0x468
[   33.288995] b43-phy0 debug: Updated beacon template at 0x468
[   33.290010] b43-phy0 debug: Updated beacon template at 0x468
[  585.629118] b43-phy0 debug: Using hardware based encryption for
keyidx: 0, mac: 00:1c:26:40:ad:2e
[  633.300744] b43-phy0 debug: Updated beacon template at 0x68
[  633.775873] b43-phy0 debug: Updated beacon template at 0x468
[  747.470833] b43-phy0 debug: Disabling hardware based encryption for
keyidx: 0, mac: 00:1c:26:40:ad:2e
[  747.471333] b43-phy0 debug: Updated beacon template at 0x68
[  747.768123] b43-phy0 debug: Removing Interface type 3
[  747.768310] b43-phy0 debug: Wireless interface stopped
[  755.816036] b43-phy0: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[  755.836056] b43-phy0 debug: Chip initialized
[  755.836279] b43-phy0 debug: 32-bit DMA initialized
[  755.856438] Registered led device: b43-phy0::tx
[  755.856465] Registered led device: b43-phy0::rx
[  755.856490] Registered led device: b43-phy0::radio
[  755.856521] b43-phy0 debug: Wireless interface started
[  755.856931] b43-phy0 debug: Adding Interface type 3
[  755.900155] b43-phy0 debug: Updated beacon template at 0x68
[  755.900250] b43-phy0 debug: Updated beacon template at 0x468
[  755.904893] b43-phy0 debug: Updated beacon template at 0x468
[  755.908442] b43-phy0 debug: Updated beacon template at 0x468
[  793.908533] b43-phy0 debug: Using hardware based encryption for
keyidx: 0, mac: <AP MAC edited>
[  823.137165] b43-phy0 debug: Updated beacon template at 0x68
[  856.499792] b43-phy0 debug: Updated beacon template at 0x468
[ 1359.028638] b43-phy0 debug: Disabling hardware based encryption for
keyidx: 0, mac: <AP MAC edited>
[ 1524.184117] b43-phy0 debug: Removing Interface type 3
[ 1524.184318] b43-phy0 debug: Wireless interface stopped
[ 1532.220026] b43-phy0: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[ 1532.236049] b43-phy0 debug: Chip initialized
[ 1532.236282] b43-phy0 debug: 32-bit DMA initialized
[ 1532.256431] Registered led device: b43-phy0::tx
[ 1532.256457] Registered led device: b43-phy0::rx
[ 1532.256483] Registered led device: b43-phy0::radio
[ 1532.256515] b43-phy0 debug: Wireless interface started
[ 1532.256923] b43-phy0 debug: Adding Interface type 3
[ 1532.286366] b43-phy0 debug: Updated beacon template at 0x68
[ 1532.286458] b43-phy0 debug: Updated beacon template at 0x468
[ 1532.288415] b43-phy0 debug: Updated beacon template at 0x468
[ 1532.292458] b43-phy0 debug: Updated beacon template at 0x468
[ 1539.299091] b43-phy0 debug: Using hardware based encryption for
keyidx: 0, mac: 00:1c:26:40:ad:2e
[ 1566.745361] b43-phy0 debug: Updated beacon template at 0x68
[ 1590.000351] b43-phy0 debug: Updated beacon template at 0x468

At 823.137165 an associated client is unable to ping temporarily, but
the IP connection resumes in a few seconds. At 1359.028638, the AP stops
beaconing. hostapd is restarted at 1524.184117, and the AP resumes
beaconing, though the client has to reassociate. Need anything else?

I found some references to older versions of b43 dropping hardware
encryption. Is Ubuntu 9.10 outdated already?

Thanks,

Eric Volker



