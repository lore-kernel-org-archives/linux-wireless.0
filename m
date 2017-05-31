Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:34291 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750966AbdEaJPo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 05:15:44 -0400
Date: Wed, 31 May 2017 11:15:41 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH] bcm47xx: fix build regression
Message-ID: <20170531111541.0ce9a99d@bbrezillon> (sfid-20170531_111627_380499_4A37CA9F)
In-Reply-To: <20170530112027.3983554-1-arnd@arndb.de>
References: <20170530112027.3983554-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 May 2017 13:20:12 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> An unknown change in the kernel headers caused a build regression
> in an MTD partition driver:
> 
> In file included from drivers/mtd/bcm47xxpart.c:12:0:
> include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
> include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first use in this function)
> 
> Clearly we want to include linux/errno.h here.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
>  include/linux/bcm47xx_nvram.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
> index 2793652fbf66..a414a2b53e41 100644
> --- a/include/linux/bcm47xx_nvram.h
> +++ b/include/linux/bcm47xx_nvram.h
> @@ -8,6 +8,7 @@
>  #ifndef __BCM47XX_NVRAM_H
>  #define __BCM47XX_NVRAM_H
>  
> +#include <linux/errno.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
>  #include <linux/vmalloc.h>
