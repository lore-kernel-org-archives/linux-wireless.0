Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49393 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0CAAXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 19:23:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Nathan Schulte <reklipz@gmail.com>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Date: Mon, 1 Mar 2010 01:22:50 +0100
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <69e28c911002281503l7259c897hafa26171adeaf0b1@mail.gmail.com> <a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com>
In-Reply-To: <a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003010122.51341.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 March 2010 00:38:16 Nathan Schulte wrote:
> 2010/2/28 Gábor Stefanik <netrolller.3d@gmail.com>:
> > The latest patch, which is a partial success according to some
> > testers, writes to core 1 (PCI-E) instead of core 0 (ChipCommon).
> Then either I am misinterpreting the logs, or the last patch in this
> thread is not the patch you are referring to.
> 
> A successful write/read to PCI config register 0x80 indicates that any
> following MMIO read/writes will be done on that core, correct?
> 
> With the lpphy-test.patch you posted earlier, I see the following
> output from b43:
> Wrote 0x18003000 to pos 0x80
> Read 0x18003000 from pos 0x80
> MAP 1 0xf4000000 0xffffc900225b8000 0x4000 0x0 0
> [snip some mmio read/writes and some PCI config read/writes]
> Wrote 0x18000000 to pos 0x80
> Read 0x18000000 from pos 0x80
> R 4 1 0xf400280a 0x6dbe 0x0 0
> W 4 1 0xf400280a 0xedbe 0x0 0
> 
> This first maps core 3, does some read/writes with it, then maps core
> 0, and sets bit 0x8000, correct?
> 
> Also, is the address space limited to the 4k range?  wl maps core 1,
> but sets bit 0x8000 at address 0x280a, which when added to 0x18001000
> is 0x1800380a, right in the PCIE cores address space (for address
> 0x100a).

Well, you are confusing address spaces here.

On a PCI based SSB device all host-side MMIO transfers go into
the PCI device's address space first. The core-switching moves the window of
the SSB address space that is mapped into 0-0xFFF of the PCI address space.
So if you write to anything above 0xFFF on the PCI device, the write will
not (directly) map to the SSB bus or any device on it.
On the PCI device there is more stuff mapped on top of the SSB sliding
window. For example the SPROM is mapped right on top of it.

So it might be the case that on a PCI-E device the PCI-E-core's registers
are permanently mapped into 0x2000 of the PCI address apace. This is to
avoid sliding the SSB address space window when accessing the PCI-E core.
This can have several reasons: For one speed (unlikely) and for another
to avoid concurrency and ugly races when we need to access the PCI-E core
while the wireless core is already running and generating interrupts.
Note that this is a GUESS, but it would make sense to me.
It would be cool if somebody could compare more registers of the PCI-E
core using the sliding window and the 0x2000 + reg method to check my theory.

-- 
Greetings, Michael.
