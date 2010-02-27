Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:34444 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770Ab0B0UPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 15:15:15 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NlT44-0000BB-BR
	for linux-wireless@vger.kernel.org; Sat, 27 Feb 2010 21:15:04 +0100
Received: from ip174-71-103-175.om.om.cox.net ([174.71.103.175])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 21:15:04 +0100
Received: from reklipz by ip174-71-103-175.om.om.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 21:15:04 +0100
To: linux-wireless@vger.kernel.org
From: Nathan Schulte <reklipz@gmail.com>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal DMA errors
Date: Sat, 27 Feb 2010 20:12:54 +0000 (UTC)
Message-ID: <loom.20100227T210822-109@post.gmane.org>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <201002262120.37438.mb@bu3sch.de> <alpine.LFD.2.00.1002261231320.4513@localhost.localdomain> <201002271836.04673.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@...> writes:
> Please check if the following patch makes any difference.
> Also please show me the result of the printks.

I applied your modifications to 2.6.33 vanilla and they did not resolve the
issue for me.  My logs are as follows:

[   63.831811] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 19 (level, low) ->
IRQ 19
[   63.832210] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
[   63.840750] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x16, vendor 0x4243)
[   63.840776] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0F, vendor 0x4243)
[   63.840800] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x0A, vendor 0x4243)
[   63.840823] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x09, vendor 0x4243)
[   63.848426] PMU res init 4312/4322
[   63.865510] ssb: Sonics Silicon Backplane found on PCI device 0000:06:00.0
[   63.891491] b43-phy0: Broadcom 4312 WLAN found (core revision 15)
[   63.920485] phy0: Selected rate control algorithm 'minstrel'
[   63.923025] Registered led device: b43-phy0::tx
[   63.923624] Registered led device: b43-phy0::rx
[   63.924105] Registered led device: b43-phy0::radio
[   63.924749] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
[   68.014700] b43 ssb0:0: firmware: requesting b43/ucode15.fw
[   68.101055] b43 ssb0:0: firmware: requesting b43/lp0initvals15.fw
[   68.116067] b43 ssb0:0: firmware: requesting b43/lp0bsinitvals15.fw
[   68.359461] b43-phy0: Loading firmware version 478.104 (2008-07-01 00:50:23)
[   68.363765] Set LDO 4312
[   68.363878] Set LDO paref
[   69.775354] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   70.363498] b43-phy0 ERROR: Fatal DMA error: 0x00000800, 0x00000000,
0x00000000, 0x00000000, 0x00000000, 0x00000000
[   70.363514] b43-phy0 ERROR: This device does not support DMA on your system.
Please use PIO instead.
[   70.363522] b43-phy0 ERROR: CONFIG_B43_FORCE_PIO must be set in your kernel
configuration.
[   77.437270] wlan0: direct probe to AP 00:1c:f0:e8:e2:13 (try 1)
[   77.637152] wlan0: direct probe to AP 00:1c:f0:e8:e2:13 (try 2)
[   77.837166] wlan0: direct probe to AP 00:1c:f0:e8:e2:13 (try 3)
[   78.037074] wlan0: direct probe to AP 00:1c:f0:e8:e2:13 timed out
[  101.047357] b43-pci-bridge 0000:06:00.0: PCI INT A disabled

-Nate

