Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lithops.sigma-star.at ([195.201.40.130]:32912 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932782AbeGFOkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 10:40:52 -0400
From: Richard Weinberger <richard@nod.at>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Boris Brezillon <boris.brezillon@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/27] mtd: rawnand: Improve compile-test coverage
Date: Fri, 06 Jul 2018 16:40:43 +0200
Message-ID: <7117646.l97x2Qa6kB@blindfold> (sfid-20180706_164056_822994_1992B231)
In-Reply-To: <CAMuHMdU2pFmhWvR6ZvvjmL6FdTWKQysJ31SW-FEvcdbi5mQhGA@mail.gmail.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com> <CAMuHMdU2pFmhWvR6ZvvjmL6FdTWKQysJ31SW-FEvcdbi5mQhGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 5. Juli 2018, 12:25:42 CEST schrieb Geert Uytterhoeven:
> Hi Boris,
> 
> On Thu, Jul 5, 2018 at 12:09 PM Boris Brezillon
> <boris.brezillon@bootlin.com> wrote:
> > This is an attempt at adding "depends || COMPILE_TEST" to all NAND
> > drivers that have no compile-time dependencies on arch
> > features/headers.
> >
> > This will hopefully help us (NAND/MTD maintainers) in detecting build
> > issues earlier. Unfortunately we still have a few drivers that can't
> > easily be modified to be arch independent.
> >
> > I tried to put all patches that only touch the NAND subsystem first,
> > so that they can be applied even if other patches are being discussed.
> >
> > Don't hesitate to point any missing dependencies when compiled with
> > COMPILE_TEST. I didn't have any problem when compiling, but that might
> > be because the dependencies were already selected.
> >
> > I have Question for Geert. I know you worked on HAS_DMA removal when
> > combined with COMPILE_TEST, do you plan to do something similar with
> > HAS_IOMEM?
> 
> No plans for that.
> 
> NO_IOMEM is Richard's itch, now s390 has gained PCI support.

Since COMPILE_TEST depends on !UML not so much anymore :-)

> NO_DMA matters for UML and Sun-3.

Yeah.

Thanks,
//richard
