Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:37980 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbeGRHvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 03:51:38 -0400
Date: Wed, 18 Jul 2018 09:15:02 +0200
From: Miquel Raynal <miquel.raynal@bootlin.com>
To: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/24] mtd: rawnand: Improve compile-test coverage
Message-ID: <20180718091502.46c39fc7@xps13> (sfid-20180718_091516_232754_65D82426)
In-Reply-To: <20180718091332.53da4898@xps13>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
        <20180718091332.53da4898@xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Miquel,

Miquel Raynal <miquel.raynal@bootlin.com> wrote on Wed, 18 Jul 2018
09:13:32 +0200:

> Hi Boris,
> 
> Boris Brezillon <boris.brezillon@bootlin.com> wrote on Mon,  9 Jul 2018
> 22:09:21 +0200:
> 
> > Hello,
> > 
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
> > In this v2, I tried to fix all warnings/errors reported by kbuild/0day
> > robots. The only remaining ones are those in omap_elm.c which seems to
> > do some weird cpu_to_be32() conversions. I guess I could replace those
> > by iowrite32be() calls (or just add (__force __u32)), but I don't want
> > to risk a regression on this driver, so I'm just leaving it for someone
> > else to fix :P.
> > 
> > Regards,
> > 
> > Boris
> > 
> > Changes in v2:
> > - Fix a few problems reported by kbuild robots and Stephen Rothwell
> > 
> > Boris Brezillon (24):
> >   mtd: rawnand: atmel: Use uintptr_t casts instead of unsigned int
> >   mtd: rawnand: atmel: Add an __iomem cast on gen_pool_dma_alloc() call
> >   mtd: rawnand: atmel: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: s3c2410: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: orion: Avoid direct inclusion of asm headers
> >   mtd: rawnand: orion: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: davinci: Stop doing iomem pointer <-> u32 conversions
> >   mtd: rawnand: davinci: Use uintptr_t casts instead of unsigned ones
> >   mtd: rawnand: davinci: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: sunxi: Add an U suffix to NFC_PAGE_OP definition
> >   mtd: rawnand: sunxi: Make sure ret is initialized in
> >     sunxi_nfc_read_byte()
> >   mtd: rawnand: sunxi: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: fscm: Avoid collision on PC def when compiling for MIPS
> >   mtd: rawnand: fsmc: Use uintptr_t casts instead of unsigned ones
> >   mtd: rawnand: fsmc: Allow selection of this driver when COMPILE_TEST=y
> >   memory: fsl_ifc: Allow selection of this driver when COMPILE_TEST=y
> >   mtd: rawnand: fsl_ifc: Add an __iomem specifier on eccstat_regs
> >   mtd: rawnand: fsl_ifc: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   MIPS: txx9: Move the ndfc.h header to include/linux/platform_data/txx9
> >   mtd: rawnand: txx9ndfmc: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   MIPS: jz4740: Move jz4740_nand.h header to
> >     include/linux/platform_data/jz4740
> >   mtd: rawnand: jz4740: Allow selection of this driver when
> >     COMPILE_TEST=y
> >   mtd: rawnand: jz4780: Drop the dependency on MACH_JZ4780
> >   memory: jz4780-nemc: Allow selection of this driver when
> >     COMPILE_TEST=y
> > 
> >  arch/mips/jz4740/board-qi_lb60.c                   |  3 +-
> >  arch/mips/txx9/generic/setup.c                     |  2 +-
> >  arch/mips/txx9/generic/setup_tx4938.c              |  2 +-
> >  arch/mips/txx9/generic/setup_tx4939.c              |  2 +-
> >  drivers/memory/Kconfig                             |  6 ++--
> >  drivers/mtd/nand/raw/Kconfig                       | 33 ++++++++++++++--------
> >  drivers/mtd/nand/raw/atmel/nand-controller.c       |  8 +++---
> >  drivers/mtd/nand/raw/davinci_nand.c                | 33 ++++++++++------------
> >  drivers/mtd/nand/raw/fsl_ifc_nand.c                |  2 +-
> >  drivers/mtd/nand/raw/fsmc_nand.c                   | 33 +++++++++++-----------
> >  drivers/mtd/nand/raw/jz4740_nand.c                 |  2 +-
> >  drivers/mtd/nand/raw/orion_nand.c                  |  2 +-
> >  drivers/mtd/nand/raw/sunxi_nand.c                  |  4 +--
> >  drivers/mtd/nand/raw/txx9ndfmc.c                   |  2 +-
> >  .../linux/platform_data/jz4740}/jz4740_nand.h      |  4 +--
> >  .../linux/platform_data}/txx9/ndfmc.h              |  6 ++--
> >  16 files changed, 77 insertions(+), 67 deletions(-)
> >  rename {arch/mips/include/asm/mach-jz4740 => include/linux/platform_data/jz4740}/jz4740_nand.h (91%)
> >  rename {arch/mips/include/asm => include/linux/platform_data}/txx9/ndfmc.h (91%)
> >   
> 
> Series applied with some typo fixes in the commit log as well as a
> proper indentation forced in drivers/mtd/nand/raw/Kconfig.

Forgot to mention: minus orion and s3c patches that will need a v3.

> 
> Thanks,
> Miquèl
