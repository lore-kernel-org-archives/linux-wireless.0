Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45192 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1BOUmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:42:25 -0500
Received: by bwz15 with SMTP id 15so50466bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 12:42:23 -0800 (PST)
Message-ID: <4D5AE52B.80002@gmail.com>
Date: Tue, 15 Feb 2011 21:42:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>	<4D5AD6A6.8090505@gmail.com> <AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>
In-Reply-To: <AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please don't prune CCs.

On 02/15/2011 09:12 PM, Nikolay Ledovskikh wrote:
> Dear Jiri,
> 
> Should I resubmit the patch with another changelog?

Yes, definitely.

> 1. mem = res->start;
>     That is what madwifi driver does
> 
>     dev->mem_start = KSEG1ADDR(res->start);
>     dev->mem_end = KSEG1ADDR(res->end);
>     sc->aps_sc.sc_iobase = (void __iomem *) dev->mem_start;

That's something completely different to what you did. This assignment
makes sense to me. But still prefer ioremap. Doesn't it work for you?

I'm no mips guy, sorry.

> 2.
>     I set sc->dev to NULL and setup save pointer to real device
> structure using SET_IEEE80211_DEV.
>     Now it's saved in wiphy structure and then used to get
> platform_device pointer.
>     I set sc->dev to NULL according to madwifi sources which look following
>         sc->aps_sc.sc_bdev = NULL; (if_ath_ahb.c)
>     and use this value in dma mapping functions.

Don't get inspired by madwifi sources, it's crap. The question is if you
have to do that to avoid the oops.

>     Looks like addresses mapped already and we shouldn't do ioremap once
> more?!

Maybe the address you got from the platform side was already ored by
KSEG1...

regards,
-- 
js
