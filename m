Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36393 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbdEaJnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 05:43:40 -0400
Received: by mail-qk0-f174.google.com with SMTP id u75so7251616qka.3
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 02:43:40 -0700 (PDT)
Subject: Re: [PATCH] bcm47xx: fix build regression
To: Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
References: <20170530112027.3983554-1-arnd@arndb.de>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <7b6903a2-ce54-44f9-18ed-a14bd32069ce@broadcom.com> (sfid-20170531_114421_219447_7616D6D0)
Date: Wed, 31 May 2017 11:43:36 +0200
MIME-Version: 1.0
In-Reply-To: <20170530112027.3983554-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/30/2017 1:20 PM, Arnd Bergmann wrote:
> An unknown change in the kernel headers caused a build regression
> in an MTD partition driver:
> 
> In file included from drivers/mtd/bcm47xxpart.c:12:0:
> include/linux/bcm47xx_nvram.h: In function 'bcm47xx_nvram_init_from_mem':
> include/linux/bcm47xx_nvram.h:27:10: error: 'ENOTSUPP' undeclared (first use in this function)
> 
> Clearly we want to include linux/errno.h here.

unfortunate that you did not find the commit that caused this build 
regression. You could produce preprocessor output when it was working to 
see where errno.h got implicitly included and start looking there for 
git history.

Regards,
Arend

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   include/linux/bcm47xx_nvram.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
> index 2793652fbf66..a414a2b53e41 100644
> --- a/include/linux/bcm47xx_nvram.h
> +++ b/include/linux/bcm47xx_nvram.h
> @@ -8,6 +8,7 @@
>   #ifndef __BCM47XX_NVRAM_H
>   #define __BCM47XX_NVRAM_H
>   
> +#include <linux/errno.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
>   #include <linux/vmalloc.h>
> 
