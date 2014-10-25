Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:55416 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaJYUhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 16:37:10 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.82)
	(envelope-from <linux@roeck-us.net>)
	id 1Xi85G-000LSi-49
	for linux-wireless@vger.kernel.org; Sat, 25 Oct 2014 20:37:10 +0000
Date: Sat, 25 Oct 2014 13:36:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, arend@broadcom.com, arnd@arndb.de,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: fix build when CONFIG_OF_ADDRESS is not set
Message-ID: <20141025203653.GA10716@roeck-us.net> (sfid-20141025_223716_132652_411D8D0B)
References: <5436D3CF.2030506@hauke-m.de>
 <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 09, 2014 at 11:39:41PM +0200, Hauke Mehrtens wrote:
> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> introduces a hard dependency on OF_ADDRESS into the bcma driver.
> OF_ADDRESS is specifically disabled for the sparc architecture.
> This results in the following error when building sparc64:allmodconfig.
> 
> drivers/bcma/main.c: In function 'bcma_of_find_child_device':
> drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'
> 
> Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

The upstream kernel still does not include this patch, and the sparc64 build
is still broken.

Is this patch on its way upstream ?

Guenter

> ---
>  drivers/bcma/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index d1656c2..1000955 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -132,7 +132,7 @@ static bool bcma_is_core_needed_early(u16 core_id)
>  	return false;
>  }
>  
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
>  static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
>  						     struct bcma_device *core)
>  {
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
