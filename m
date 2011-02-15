Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33543 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1BOU5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 15:57:51 -0500
Received: by qwa26 with SMTP id 26so473719qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 12:57:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D5AE52B.80002@gmail.com>
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
	<4D5AD6A6.8090505@gmail.com>
	<AANLkTiks9rG2CzM2LabNerK3zgJ+R+weytQgvXxDbNe7@mail.gmail.com>
	<4D5AE52B.80002@gmail.com>
Date: Tue, 15 Feb 2011 23:57:49 +0300
Message-ID: <AANLkTikyneyczm=+XRfjUEVJU-i4d6d=7yF4Lh=8Do_=@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
From: Nikolay Ledovskikh <nledovskikh@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	mickflemm@gmail.com, me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Madwifi is a crap, but
       #define KSEG1ADDR(addr) (addr)
and only difference is in pointer type cast
      sc->aps_sc.sc_iobase = (void __iomem *) dev->mem_start;
in my case it would be something like this:
      sc->aps_sc.sc_iobase = dev->mem_start;
and it works.

2011/2/15 Jiri Slaby <jirislaby@gmail.com>:
> Please don't prune CCs.
>
> On 02/15/2011 09:12 PM, Nikolay Ledovskikh wrote:
>> Dear Jiri,
>>
>> Should I resubmit the patch with another changelog?
>
> Yes, definitely.
>
>> 1. mem = res->start;
>>     That is what madwifi driver does
>>
>>     dev->mem_start = KSEG1ADDR(res->start);
>>     dev->mem_end = KSEG1ADDR(res->end);
>>     sc->aps_sc.sc_iobase = (void __iomem *) dev->mem_start;
>
> That's something completely different to what you did. This assignment
> makes sense to me. But still prefer ioremap. Doesn't it work for you?
>
> I'm no mips guy, sorry.
>
>> 2.
>>     I set sc->dev to NULL and setup save pointer to real device
>> structure using SET_IEEE80211_DEV.
>>     Now it's saved in wiphy structure and then used to get
>> platform_device pointer.
>>     I set sc->dev to NULL according to madwifi sources which look following
>>         sc->aps_sc.sc_bdev = NULL; (if_ath_ahb.c)
>>     and use this value in dma mapping functions.
>
> Don't get inspired by madwifi sources, it's crap. The question is if you
> have to do that to avoid the oops.
>
>>     Looks like addresses mapped already and we shouldn't do ioremap once
>> more?!
>
> Maybe the address you got from the platform side was already ored by
> KSEG1...
>
> regards,
> --
> js
>



--
Best regards, Nikolay Ledovskikh.
