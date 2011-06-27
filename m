Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36457 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab1F0OJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 10:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	<BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
Date: Mon, 27 Jun 2011 16:09:21 +0200
Message-ID: <BANLkTintpOOnu-DCGkvOYPizu9ZigHfbVg@mail.gmail.com> (sfid-20110627_160952_413347_9AC94A3E)
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-next@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/27 Rafał Miłecki <zajec5@gmail.com>:
> 2011/6/26 Geert Uytterhoeven <geert@linux-m68k.org>:
>> m68k allmodconfig:
>>
>> drivers/bcma/main.c: In function ‘bcma_release_core_dev’:
>> drivers/bcma/main.c:68: error: implicit declaration of function ‘kfree’
>
> We already include slab.h in:
> host_pci.c
> scan.c
> sprom.c
>
> Maybe we can just include this in bcma.h as a better solution? We
> could drop other includes then.
> Can you submit patch for this?

If bcma.h doesn't use linux/slab.h, IMHO it should not include linux/slab.h.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
