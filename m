Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:47647 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732387AbeGKLU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 07:20:29 -0400
Date: Wed, 11 Jul 2018 13:16:26 +0200
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
        David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 04/24] mtd: rawnand: s3c2410: Allow selection of this
 driver when COMPILE_TEST=y
Message-ID: <20180711131626.732967be@bbrezillon> (sfid-20180711_131642_320064_D647598D)
In-Reply-To: <20180709200945.30116-5-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
        <20180709200945.30116-5-boris.brezillon@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon,  9 Jul 2018 22:09:25 +0200
Boris Brezillon <boris.brezillon@bootlin.com> wrote:

> It just makes NAND maintainers' life easier by allowing them to
> compile-test this driver without having ARCH_S3C24XX or ARCH_S3C64XX
> enabled.
> 
> We add a dependency on HAS_IOMEM to make sure the driver compiles
> correctly, and a dependency on !IA64 because the {read,write}s{bwl}()
> accessors are not defined for this architecture.

I see that SPARC does not define those accessors either. So I guess we
should add depends on !SPARC.

Arnd, any other way to know when the platform implements
{read,write}s{bwl}() accessors?

> 
> Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
> ---
>  drivers/mtd/nand/raw/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
> index 1488ad0a0199..e01b3da726c0 100644
> --- a/drivers/mtd/nand/raw/Kconfig
> +++ b/drivers/mtd/nand/raw/Kconfig
> @@ -119,7 +119,8 @@ config MTD_NAND_AU1550
>  
>  config MTD_NAND_S3C2410
>  	tristate "NAND Flash support for Samsung S3C SoCs"
> -	depends on ARCH_S3C24XX || ARCH_S3C64XX
> +	depends on ARCH_S3C24XX || ARCH_S3C64XX || COMPILE_TEST
> +	depends on HAS_IOMEM && !IA64
>  	help
>  	  This enables the NAND flash controller on the S3C24xx and S3C64xx
>  	  SoCs
