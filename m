Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36699 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbcGSH0R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 03:26:17 -0400
Date: Tue, 19 Jul 2016 00:26:13 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	"open list:MEMORY TECHNOLOGY DEVICES (MTD)"
	<linux-mtd@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: add arch dependency for MTD_BCM47XXSFLASH symbol
Message-ID: <20160719072613.GA96986@google.com> (sfid-20160719_092637_961746_6E20284B)
References: <1468912123-14899-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1468912123-14899-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 09:08:32AM +0200, Rafał Miłecki wrote:
> We dropped strict MIPS dependency for bcm47xxsflash driver in:
> commit 5651d6aaf489 ("mtd: bcm47xxsflash: use ioremap_cache() instead of
> KSEG0ADDR()") but using ioremap_cache still limits building it to few
> selected architectures only.
> 
> A recent commit 57d8f7dd2132 ("bcma: allow enabling serial flash support
> on non-MIPS SoCs") automatically dropped MIPS dependency for
> MTD_BCM47XXSFLASH which broke building e.g. on powerpc and cris.
> 
> The bcma change is alright as it doesn't break building bcma code in any
> way. MTD_BCM47XXSFLASH on the other hand should be limited to archs
> which need it and can build it (by providing ioremap_cache).
> 
> Fixes: 57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Brian Norris <computersforpeace@gmail.com>

While I might prefer we have a better consistent set of portable I/O
accessors (it's really a mess), it seems quite reasonable to restrict
the damage to ARM and MIPS here if it saves some short-term hassle:

Acked-by: Brian Norris <computersforpeace@gmail.com>

> ---
> That bcma commit breaking building landed in the wireless-drivers-next.
> Is that possible to get this patch through the same tree?

That's fine with me.

Regards,
Brian

> ---
>  drivers/mtd/devices/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> index f73c416..64a2485 100644
> --- a/drivers/mtd/devices/Kconfig
> +++ b/drivers/mtd/devices/Kconfig
> @@ -114,7 +114,7 @@ config MTD_SST25L
>  
>  config MTD_BCM47XXSFLASH
>  	tristate "R/O support for serial flash on BCMA bus"
> -	depends on BCMA_SFLASH
> +	depends on BCMA_SFLASH && (MIPS || ARM)
>  	help
>  	  BCMA bus can have various flash memories attached, they are
>  	  registered by bcma as platform devices. This enables driver for
> -- 
> 1.8.4.5
> 
