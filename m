Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44258 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbYKURmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 12:42:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: BCM4312 Fails when xdm is started
Date: Fri, 21 Nov 2008 18:42:12 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>,
	Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <20081115174623.27321.qmail@stuge.se> <4926E0F2.5060200@lwfinger.net>
In-Reply-To: <4926E0F2.5060200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811211842.13099.mb@bu3sch.de> (sfid-20081121_184246_501493_2DD66E7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 November 2008 17:25:22 Larry Finger wrote:
> A problem was recently posted to the bcm43xx mailing list that I am unable to
> solve. The machine in question is an HP Mini 2133 (HP product number FU346EA)
> with a BCM4312 PCIe wireless card. This card is known to work with the b43
> driver (I have one.) and it does work on this machine - at least initially.
> 
> A problem occurs when xdm/kde is started. Suddenly a read operation on device
> hardware returns all ones as though the register does not exist, or if it were
> suddenly mismapped. If the OP doesn't try to run xdm, the same problem will
> eventually occur, it just takes longer.

Can you dump PCI config space and SSB registers (TMSLOW, maybe others, too).
It looks like a random bus write disabled the device.

> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000000 -> 0x00001000
> [    0.000000]   Normal   0x00001000 -> 0x000373fe
> [    0.000000]   HighMem  0x000373fe -> 0x0006feb0
> 
> On my 64-bit HP machine, I see:
> 
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   DMA32    0x00001000 -> 0x00100000
>   Normal   0x00100000 -> 0x00100000
> 
> Is it "normal" for there not to be a DMA32 range with a 32-bit version of Linux?

Yeah, I think so.

-- 
Greetings Michael.
