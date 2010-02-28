Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:21177 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032075Ab0B1WTR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 17:19:17 -0500
Received: by qw-out-2122.google.com with SMTP id 8so379409qwh.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 14:19:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911002280814v56f2f553x847c8bae94e6aaab@mail.gmail.com>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	 <201002271620.31410.mb@bu3sch.de> <4B8942D5.5020502@lwfinger.net>
	 <201002271708.29817.mb@bu3sch.de> <4B894A61.1070302@lwfinger.net>
	 <69e28c911002271145s590df31en9d2f8b2c47932451@mail.gmail.com>
	 <4B899DA3.4030100@lwfinger.net>
	 <a221c0101002271703p3f344ec4t78d5c8b77c6d1290@mail.gmail.com>
	 <a221c0101002271828ye265d72y774320c08a4a15da@mail.gmail.com>
	 <69e28c911002280814v56f2f553x847c8bae94e6aaab@mail.gmail.com>
Date: Sun, 28 Feb 2010 16:19:16 -0600
Message-ID: <a221c0101002281419t5401a571rcd60e6f87edbb6c@mail.gmail.com>
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
> OK, this dump shows the 0x280a write happening with core 3, i.e. PCIE,
> active. So, it is indeed probably the "PCIE misc configuration"
> routine. Why it's 0x280a is still a mystery to me, it should be 0x100a
> according to the specs.
Unless I'm reading the logs wrong, isn't wl setting bit 0x8000 when
core 1 is mapped (0 indexed cores, 0x18001000 mapped to space 0)?
And b43 appears to do it when core 0 is mapped (0x18000000 mapped to
space 0).  b43 also reads from 0x100a after writing to 0x280a, and it
reads as 0x8000 not set (while the 0x280a check show it is set).

This is when comparing the wl_cold and b43_cold logs.

-Nate
