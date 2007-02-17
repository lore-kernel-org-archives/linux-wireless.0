Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40454
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992465AbXBQQ4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 11:56:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: More breakage in wireless-dev.git
Date: Sat, 17 Feb 2007 17:55:35 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <1171690868.31103.17.camel@dv> <200702171402.24593.mb@bu3sch.de> <20070217114436.jhcgs4soo4sgo8sk@webmail.spamcop.net>
In-Reply-To: <20070217114436.jhcgs4soo4sgo8sk@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702171755.36291.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 February 2007 17:44, Pavel Roskin wrote:
> Quoting Michael Buesch <mb@bu3sch.de>:
> 
> > On Saturday 17 February 2007 09:06, Pavel Roskin wrote:
> > > I'm still getting "bcm43xx_d80211: FOUND UNSUPPORTED PHY (Analog 4, Type
> > > 0, Revision 7)" from bcm43xx_d80211 for a card that used to work.  That
> > > must be a separate problem.
> >
> > More info about your device, please.
> 
> It's the same PCIe module with PCI ID 14e4:4312.
> 
> # lspci -v -s 0c:00.0
> 0c:00.0 Network controller: Broadcom Corporation BCM4310 UART (rev 01)
>         Subsystem: Dell Unknown device 0007
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at efdfc000 (32-bit, non-prefetchable) [size=16K]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/0
> Enable-
>         Capabilities: [d0] Express Legacy Endpoint IRQ 0
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [13c] Virtual Channel
> 
> As it turns out, I'm getting the same problems with your (mb) branch, which
> doesn't have the latest wireless-dev.git changes yet.
> 
> That's loading the device and bringing it up:
> 
> ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:0c:00.0 to 64
> ssb: Sonics Silicon Backplane found on PCI device 0000:0c:00.0
> ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
> ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
> ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
> ssb: Switching to ChipCommon core, index 0
> ssb: Switching to PCI-E core, index 3
> bcm43xx_d80211: Broadcom 4311 WLAN found
> ssb: Switching to IEEE 802.11 core, index 1
> wmaster0: Selected rate control algorithm 'simple'
> bcm43xx_d80211: Adding Interface type 2
> bcm43xx_d80211: Found PHY: Analog 4, Type 2, Revision 8
> bcm43xx_d80211: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> ssb: Switching to PCI-E core, index 3
> ssb: Switching to IEEE 802.11 core, index 1
> bcm43xx_d80211: Loading firmware version 371.1122 (2006-11-08 22:02:13)
> ssb: Switching to ChipCommon core, index 0
> ssb: Switching to IEEE 802.11 core, index 1
> bcm43xx_d80211: Radio turned on
> bcm43xx_d80211: Radio enabled by hardware
> bcm43xx_d80211: Chip initialized
> bcm43xx_d80211: 32-bit DMA initialized
> bcm43xx_d80211: Wireless interface started
> wmaster0: Does not support passive scan, disabled
> bcm43xx_d80211: Using hardware based encryption for keyidx: 0, mac:
> ff:ff:ff:ff:ff:ff
> 
> Then I do scanning.  I didn't need to bring the interface down, but it's
> possible that some userspace utility tried to do it:
> 
> wlan0: starting scan
> bcm43xx_d80211: Reconfiguring PHYmode to A-PHY

Oh, heh. Well. Does your device have an A-PHY?
If not, it's related to a bug I am fixing at the moment. ;)


-- 
Greetings Michael.
