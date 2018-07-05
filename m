Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44028 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753068AbeGEJtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:49:33 -0400
Date: Thu, 5 Jul 2018 11:49:21 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/27] mtd: rawnand: Improve compile-test coverage
Message-ID: <20180705114921.4bb66185@bbrezillon> (sfid-20180705_114937_274764_5CB0DA42)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Geert since I have a question for you

On Thu,  5 Jul 2018 11:44:55 +0200
Boris Brezillon <boris.brezillon@bootlin.com> wrote:

> Hello,
> 
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

just here :).

> 
> Regards,
> 
> Boris
> 
> Boris Brezillon (27):
>   mtd: rawnand: gpmi: Remove useless dependency on MTD_NAND
>   mtd: rawnand: Add 'depends on HAS_IOMEM' where missing
>   mtd: rawnand: atmel: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: omap2: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: s3c2410: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: sharpsl: Remove inclusion of mach and asm headers
>   mtd: rawnand: sharpsl: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: lpc32xx: Allow selection of these drivers when
>     COMPILE_TEST=y
>   mtd: rawnand: brcmnand: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: orion: Avoid direct inclusion of asm headers
>   mtd: rawnand: orion: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: mxc: Avoid inclusion of asm/mach headers
>   mtd: rawnand: mxc: Allow selection of this driver when COMPILE_TEST=y
>   mtd: rawnand: davinci: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: sunxi: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: qcom: Allow selection of this driver when COMPILE_TEST=y
>   mtd: rawnand: fsmc: Allow selection of this driver when COMPILE_TEST=y
>   mtd: rawnand: nuc900: Allow selection of this driver when
>     COMPILE_TEST=y
>   memory: fsl_ifc: Allow selection of this driver when COMPILE_TEST=y
>   mtd: rawnand: fsl_ifc: Allow selection of this driver when
>     COMPILE_TEST=y
>   bcma: Allow selection of this driver when COMPILE_TEST=y
>   MIPS: txx9: Move the ndfc.h header to include/linux/platform_data/txx9
>   mtd: rawnand: txx9ndfmc: Allow selection of this driver when
>     COMPILE_TEST=y
>   MIPS: jz4740: Move jz4740_nand.h header to
>     include/linux/platform_data/jz4740
>   mtd: rawnand: jz4740: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: jz4780: Drop the dependency on MACH_JZ4780
>   memory: jz4780-nemc: Allow selection of this driver when
>     COMPILE_TEST=y
> 
>  arch/mips/jz4740/board-qi_lb60.c                   |  3 +-
>  arch/mips/txx9/generic/setup.c                     |  2 +-
>  arch/mips/txx9/generic/setup_tx4938.c              |  2 +-
>  arch/mips/txx9/generic/setup_tx4939.c              |  2 +-
>  drivers/bcma/Kconfig                               |  3 +-
>  drivers/memory/Kconfig                             |  6 ++-
>  drivers/mtd/nand/raw/Kconfig                       | 61 +++++++++++++++-------
>  drivers/mtd/nand/raw/jz4740_nand.c                 |  2 +-
>  drivers/mtd/nand/raw/mxc_nand.c                    |  2 -
>  drivers/mtd/nand/raw/orion_nand.c                  |  2 +-
>  drivers/mtd/nand/raw/sharpsl.c                     |  5 +-
>  drivers/mtd/nand/raw/txx9ndfmc.c                   |  2 +-
>  .../linux/platform_data/jz4740}/jz4740_nand.h      |  4 +-
>  .../linux/platform_data}/txx9/ndfmc.h              |  6 +--
>  14 files changed, 61 insertions(+), 41 deletions(-)
>  rename {arch/mips/include/asm/mach-jz4740 => include/linux/platform_data/jz4740}/jz4740_nand.h (91%)
>  rename {arch/mips/include/asm => include/linux/platform_data}/txx9/ndfmc.h (91%)
> 
