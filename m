Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52193 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1BOWQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 17:16:33 -0500
Received: by bwz15 with SMTP id 15so38557bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 14:16:32 -0800 (PST)
Message-ID: <4D5AFB3B.6080407@gmail.com>
Date: Tue, 15 Feb 2011 23:16:27 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>	<4D5AD6A6.8090505@gmail.com>	<AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>	<4D5AE52B.80002@gmail.com> <AANLkTinnCOEXF835yhNeJDfBdKjx_dss6TFeUmjL-Yk2@mail.gmail.com>
In-Reply-To: <AANLkTinnCOEXF835yhNeJDfBdKjx_dss6TFeUmjL-Yk2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 10:39 PM, Nikolay Ledovskikh wrote:
>> Maybe the address you got from the platform side was already ored by
>> KSEG1...
> 
> I took a look at openwrt atheros platform code and suppose you are right.
> So what we should do for now? Add pointer cast (void __iomem *)?
> Because ioremap_nocache doesn't work as expected. I think it's better
> to rewrote the openwrt
> code, but not now.

So I've found:
http://www.google.com/codesearch/p?hl=en#sayuPQDVf4c/trunk/openwrt/target/linux/atheros/patches-2.6.32/100-board.patch&q=ar231x-wmac&sa=N&cd=4&ct=rc

There, the res->start may be either of the following:
AR531X_WLAN0 .. 0x18000000
AR531X_WLAN1 .. 0x18500000
AR2315_WLAN0 .. 0xB0000000

I suppose you have the 3rd otherwise it should die without ORing KSEG1?

Or maybe MIPS guys will correct me? (The problem is that ioremap of one
of the addresses above kills the box. If Nikolaj removes the ioremap and
uses the address directly, it works for him. I'm saying it will die for
the first 2 addresses if we remove ioremap completely -- from what I
found in MIPS specs.)

I _think_ there should be (instead of ioremap):
sc->iobase = (void __iomem *)KSEG1ADDR(res->start);

Then we do readl(sc->iobase) et al. in ath5k.

thanks,
-- 
js
