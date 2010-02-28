Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51547 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935173Ab0B1S6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 13:58:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
Date: Sun, 28 Feb 2010 19:58:11 +0100
Cc: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	=?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com> <b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com> <69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>
In-Reply-To: <69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002281958.12607.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 February 2010 19:52:53 Gábor Stefanik wrote:
> 2010/2/28 Rafał Miłecki <zajec5@gmail.com>:
> > 2010/2/28 Gábor Stefanik <netrolller.3d@gmail.com>:
> >> On Sun, Feb 28, 2010 at 7:00 PM, William Bourque
> >> <william.bourque@polymtl.ca> wrote:
> >>> I confirm, it still crashes on my notebook as well. However the new
> >>> "fallback to PIO" behavior introduced earlier do a fine job getting it back
> >>> on track.
> >>>
> >>> Btw, you are often refering to some documentation that document the register
> >>> for this device, where could I find it? I probably won't be able to do much,
> >>> but I'm curious to see...
> >>>
> >> New test patch attached.
> >
> > Patch adds this /incorrect/ ssb_write32 to 0x280a, right? By incorrect
> > I mean over range.
> >
> > Would be nice to see if dumping tool generates same log about 0x280a
> > now (for wl and b43 patched).
> 
> I added both the "incorrect" 0x280a and the "correct" 0x80a here - it
> is possible that the 0x280a one takes advantage of an undocumented
> feature in PhoenixBIOS.

Hell, it is pure luck that this does not blow up the whole machine.

Please check the memory region of your wireless card with lspci -vvnn:

0001:10:12.0 Network controller [0280]: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
        Subsystem: Apple Computer Inc. AirPort Extreme [106b:004e]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 16
        Interrupt: pin A routed to IRQ 52
        Region 0: Memory at a0006000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: <access denied>
        Kernel driver in use: b43-pci-bridge
        Kernel modules: ssb

It says 8k for all of my devices there. So an MMIO write to 0x2000 and above
writes to completely random memory.

-- 
Greetings, Michael.
