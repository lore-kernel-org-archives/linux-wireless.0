Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34520 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754153AbeGHNGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jul 2018 09:06:33 -0400
Date: Sun, 8 Jul 2018 15:06:30 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 17/27] mtd: rawnand: fsmc: Allow selection of this
 driver when COMPILE_TEST=y
Message-ID: <20180708150630.06367498@bbrezillon> (sfid-20180708_150746_997533_307A02EE)
In-Reply-To: <20180705094522.12138-18-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
        <20180705094522.12138-18-boris.brezillon@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu,  5 Jul 2018 11:45:12 +0200
Boris Brezillon <boris.brezillon@bootlin.com> wrote:

> It just makes NAND maintainers' life easier by allowing them to
> compile-test this driver without having PLAT_SPEAR, ARCH_NOMADIK,
> ARCH_U8500 or MACH_U300 enabled.
> 
> We also need to add a dependency on HAS_IOMEM to make sure the driver
> compiles correctly.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> ---
>  drivers/mtd/nand/raw/Kconfig | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
> index b89bd94a654c..245f1b56b94f 100644
> --- a/drivers/mtd/nand/raw/Kconfig
> +++ b/drivers/mtd/nand/raw/Kconfig
> @@ -502,8 +502,9 @@ config MTD_NAND_JZ4780
>  
>  config MTD_NAND_FSMC
>  	tristate "Support for NAND on ST Micros FSMC"
> -	depends on OF
> -	depends on PLAT_SPEAR || ARCH_NOMADIK || ARCH_U8500 || MACH_U300
> +	depends on OF && HAS_IOMEM
> +	depends on PLAT_SPEAR || ARCH_NOMADIK || ARCH_U8500 || MACH_U300 || \
> +		   COMPILE_TEST

Looks like we have a conflict on the PC definition when compiling a
MIPS kernel. I'll add a patch suffixing PC with FSMC_ to avoid that.
Please don't apply this patch yet. 

>  	help
>  	  Enables support for NAND Flash chips on the ST Microelectronics
>  	  Flexible Static Memory Controller (FSMC)
