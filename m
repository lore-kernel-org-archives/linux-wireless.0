Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:53670 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0B1XiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 18:38:17 -0500
Received: by qw-out-2122.google.com with SMTP id 8so387699qwh.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 15:38:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911002281503l7259c897hafa26171adeaf0b1@mail.gmail.com>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	 <201002271708.29817.mb@bu3sch.de> <4B894A61.1070302@lwfinger.net>
	 <69e28c911002271145s590df31en9d2f8b2c47932451@mail.gmail.com>
	 <4B899DA3.4030100@lwfinger.net>
	 <a221c0101002271703p3f344ec4t78d5c8b77c6d1290@mail.gmail.com>
	 <a221c0101002271828ye265d72y774320c08a4a15da@mail.gmail.com>
	 <69e28c911002280814v56f2f553x847c8bae94e6aaab@mail.gmail.com>
	 <a221c0101002281419t5401a571rcd60e6f87edbb6c@mail.gmail.com>
	 <69e28c911002281503l7259c897hafa26171adeaf0b1@mail.gmail.com>
Date: Sun, 28 Feb 2010 17:38:16 -0600
Message-ID: <a221c0101002281538p717a3b5v16b14d251cdcc1dc@mail.gmail.com>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
From: Nathan Schulte <reklipz@gmail.com>
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/28 Gábor Stefanik <netrolller.3d@gmail.com>:
> The latest patch, which is a partial success according to some
> testers, writes to core 1 (PCI-E) instead of core 0 (ChipCommon).
Then either I am misinterpreting the logs, or the last patch in this
thread is not the patch you are referring to.

A successful write/read to PCI config register 0x80 indicates that any
following MMIO read/writes will be done on that core, correct?

With the lpphy-test.patch you posted earlier, I see the following
output from b43:
Wrote 0x18003000 to pos 0x80
Read 0x18003000 from pos 0x80
MAP 1 0xf4000000 0xffffc900225b8000 0x4000 0x0 0
[snip some mmio read/writes and some PCI config read/writes]
Wrote 0x18000000 to pos 0x80
Read 0x18000000 from pos 0x80
R 4 1 0xf400280a 0x6dbe 0x0 0
W 4 1 0xf400280a 0xedbe 0x0 0

This first maps core 3, does some read/writes with it, then maps core
0, and sets bit 0x8000, correct?

Also, is the address space limited to the 4k range?  wl maps core 1,
but sets bit 0x8000 at address 0x280a, which when added to 0x18001000
is 0x1800380a, right in the PCIE cores address space (for address
0x100a).

And finally, unless the linux-wireless@vger.kernel.org mailing list is
currently down as well, I think gmail may be the one causing my
messages to not be delivered to the list, as my last message isn't
showing up on the linux-wireless list either.

-Nate
