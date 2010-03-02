Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60927 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0CBV6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 16:58:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Nathan Schulte <reklipz@gmail.com>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Date: Tue, 2 Mar 2010 22:57:51 +0100
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com> <201003010122.51341.mb@bu3sch.de>
In-Reply-To: <201003010122.51341.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <201003022257.51878.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 March 2010 01:22:50 Michael Buesch wrote:
> Well, you are confusing address spaces here.
>
> On a PCI based SSB device all host-side MMIO transfers go into
> the PCI device's address space first. The core-switching moves the window of
> the SSB address space that is mapped into 0-0xFFF of the PCI address space.
> So if you write to anything above 0xFFF on the PCI device, the write will
> not (directly) map to the SSB bus or any device on it.
> On the PCI device there is more stuff mapped on top of the SSB sliding
> window. For example the SPROM is mapped right on top of it.
> 
> So it might be the case that on a PCI-E device the PCI-E-core's registers
> are permanently mapped into 0x2000 of the PCI address apace. This is to
> avoid sliding the SSB address space window when accessing the PCI-E core.
> This can have several reasons: For one speed (unlikely) and for another
> to avoid concurrency and ugly races when we need to access the PCI-E core
> while the wireless core is already running and generating interrupts.
> Note that this is a GUESS, but it would make sense to me.
> It would be cool if somebody could compare more registers of the PCI-E
> core using the sliding window and the 0x2000 + reg method to check my theory.
> 

So what's the status on this? I think the fact that the testing patch showed some
improvement is a clear indicator that something in the PCI-E core init is wrong.
It's also not surprising that something is going wrong there. The whole PCI-E core
code basically is undebugged. I wrote most of it long time ago, but I still
don't have a device that tests it (and probably won't get one anytime soon).
So I'm really not surprised that there are bugs. There also are missing parts.

A bug in the PCI-E core code is able to show such behavior, because all memory
transfers (MMIO and DMA) from the PCI device to the wireless core are translated
by the PCI-E core.
I think the whole PCI-E core code has to be audited (also the specs, probably).

-- 
Greetings, Michael.
