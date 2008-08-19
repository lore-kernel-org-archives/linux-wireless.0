Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:57127 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYHSSDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 14:03:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so67155fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2008 11:03:48 -0700 (PDT)
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: rt2500pci: rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
Date: Tue, 19 Aug 2008 20:03:44 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
References: <20080819173524.GA4708@steel.home>
In-Reply-To: <20080819173524.GA4708@steel.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808192003.45072.IvDoorn@gmail.com> (sfid-20080819_200354_418517_1019742C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
> produces a lot of this messages in log (slowdown quite noticable):
> 
>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>     last message repeated 40 times
>     kernel: phy0 -> rt2500pci_rf_write: Error - RFCSR register busy. Write failed.
>     last message repeated 7 times
>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.

This is a bad sign, the slowdown is expected since the driver is continuously looping
waiting for the registers to become available. Did this PCI card work in the past, and
if so with what driver?

Does this card work on another PC, or does the windows or legacy driver work with
this card?

(Yes, all suggestions above imply suspicion about the hardware itself rather then the driver)

Ivo

> The card is a RaLink RT2500 PCI (not mini-PCI, it is a normal desktop
> system, Gigabyte GA-8IPE1000 motherboard):
> 
>     02:04.0 Ethernet controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 	    Subsystem: Micro-Star International Co., Ltd. Unknown device 6834
> 	    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR+
> 	    Latency: 32, Cache Line Size: 32 bytes
> 	    Interrupt: pin A routed to IRQ 11
> 	    Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=8K]
> 	    Capabilities: [40] Power Management version 2
> 		    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		    Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> The system is a P4 with HT enabled (and active). The .config is below:
