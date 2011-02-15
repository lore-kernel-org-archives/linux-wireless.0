Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48275 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1BOVJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 16:09:03 -0500
Received: by bwz15 with SMTP id 15so69398bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 13:09:01 -0800 (PST)
Message-ID: <4D5AEA3C.4090502@gmail.com>
Date: Tue, 15 Feb 2011 22:03:56 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>	<4D5AD6A6.8090505@gmail.com>	<AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>	<4D5AE52B.80002@gmail.com> <AANLkTikyneyczm=+XRfjUEVJU-i4d6d=7yF4Lh=8Do_=@mail.gmail.com>
In-Reply-To: <AANLkTikyneyczm=+XRfjUEVJU-i4d6d=7yF4Lh=8Do_=@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

On 02/15/2011 09:57 PM, Nikolay Ledovskikh wrote:
> Madwifi is a crap, but
>        #define KSEG1ADDR(addr) (addr)
> and only difference is in pointer type cast
>       sc->aps_sc.sc_iobase = (void __iomem *) dev->mem_start;
> in my case it would be something like this:
>       sc->aps_sc.sc_iobase = dev->mem_start;
> and it works.

In that case yes, but KSEG1ADDR should write as:
#define KSEG1ADDR(a) (CPHYSADDR(a) | KSEG1)

As I wrote, this needs some mips expert. But it definitely shouldn't be
a plain assignment.

regards,
-- 
js
