Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:39727 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753381AbeGEKZy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 06:25:54 -0400
Received: by mail-ua0-f193.google.com with SMTP id n4-v6so5077081uad.6
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 03:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Jul 2018 12:25:42 +0200
Message-ID: <CAMuHMdU2pFmhWvR6ZvvjmL6FdTWKQysJ31SW-FEvcdbi5mQhGA@mail.gmail.com> (sfid-20180705_122558_991146_98DF7327)
Subject: Re: [PATCH 00/27] mtd: rawnand: Improve compile-test coverage
To: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Boris,

On Thu, Jul 5, 2018 at 12:09 PM Boris Brezillon
<boris.brezillon@bootlin.com> wrote:
> This is an attempt at adding "depends || COMPILE_TEST" to all NAND
> drivers that have no compile-time dependencies on arch
> features/headers.
>
> This will hopefully help us (NAND/MTD maintainers) in detecting build
> issues earlier. Unfortunately we still have a few drivers that can't
> easily be modified to be arch independent.
>
> I tried to put all patches that only touch the NAND subsystem first,
> so that they can be applied even if other patches are being discussed.
>
> Don't hesitate to point any missing dependencies when compiled with
> COMPILE_TEST. I didn't have any problem when compiling, but that might
> be because the dependencies were already selected.
>
> I have Question for Geert. I know you worked on HAS_DMA removal when
> combined with COMPILE_TEST, do you plan to do something similar with
> HAS_IOMEM?

No plans for that.

NO_IOMEM is Richard's itch, now s390 has gained PCI support.
NO_DMA matters for UML and Sun-3.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
