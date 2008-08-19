Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40691 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbYHSWSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 18:18:25 -0400
Message-ID: <48AB46AC.3090703@lwfinger.net> (sfid-20080820_001829_940545_B953A0FA)
Date: Tue, 19 Aug 2008 17:18:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Niklas Wulf <niklas@wulf-home.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on
 4311
References: <48AB5D89.5090705@wulf-home.de>
In-Reply-To: <48AB5D89.5090705@wulf-home.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Wulf wrote:
> I tested this one on my Macbook Pro (3,1).
> 
> # lspci -v
> 0b:00.0 Network controller: Broadcom Corporation BCM4328 802.11a/b/g/n
> (rev 05)
> Subsystem: Apple Computer Inc. Device 008c
> Flags: bus master, fast devsel, latency 0, IRQ 16
> Memory at 97300000 (64-bit, non-prefetchable) [size=16K]
> Capabilities: [40] Power Management version 3
> Capabilities: [58] Vendor Specific Information <?>
> Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable-
> Capabilities: [d0] Express Endpoint, MSI 00
> Kernel driver in use: b43-pci-bridge
> Kernel modules: ssb
> 
> It is not recognized by the driver... should it? I don't get a wireless
> device listed in ifconfig nor does dmesg show any device.

No, the driver is not loading correctly because the N PHY is not yet 
supported. The reverse engineering for that device is barely started.

> # ifconfig
> eth0 [...]
> lo [...]
> 
> # dmesg
> [...]
> Broadcom 43xx driver loaded [ Features: PMLR, Firmware-ID: FW13 ]
> [...]
> 
> I'm kind of new to all this wireless stuff. Linuxwireless.org tells me
> 4328 does not work because of missing N Phys support, so I hoped this
> patch would make some difference.

No, that patch is just preparation for what will happen in the future 
when both LP and N PHYs are supported.

> A problem could be the wrong firmware version. OS X says the Chip has
> 4.150.10.__6__ but I can only find 4.150.10.5. Is this important?

Driver 4.150.10.5 is a MIPS driver for Linux. Obviously 4.150.10.6 is 
an OS X driver. I wouldn't expect any difference in the embedded 
firmware between them.

Larry

