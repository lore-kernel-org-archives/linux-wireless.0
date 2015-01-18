Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:33012 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbbARS0Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 13:26:25 -0500
Message-ID: <54BBFACA.9010609@hauke-m.de> (sfid-20150118_192704_774590_B4F0D84B)
Date: Sun, 18 Jan 2015 19:26:18 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
CC: "Saul St. John" <saul.stjohn@gmail.com>
Subject: Re: [PATCH RFC] bcma: simplify freeing cores (internal devices structs)
References: <1421444828-32616-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1421444828-32616-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2015 10:47 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This code was introduced by Saul in
> ee91592711ed90a1abfbb1b2ceadded11d685164
> bcma: don't leak memory for PCIE, MIPS, GBIT cores
> 
> I don't really see reason for making it in so complicated way.
> I tested my patch for crashes, but didn't really try kmemleak.
> Is my simple solution OK? Or am I missing something? Anyone?

Are you sure no device driver accesses the chipcommon, pcie or mips core
in the unregister part? If some device driver does something in his
remove function with e.g. chipcommon it will cause problems when the
chipcommon core was already freed.

Hauke

> ---
>  drivers/bcma/main.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index c3c5e0a..58dd582 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -371,6 +371,8 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
>  		list_del(&core->list);
>  		if (core->dev_registered)
>  			device_unregister(&core->dev);
> +		else
> +			kfree(core);
>  	}
>  	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
>  		platform_device_unregister(bus->drv_cc.watchdog);
> @@ -467,7 +469,6 @@ int bcma_bus_register(struct bcma_bus *bus)
>  
>  void bcma_bus_unregister(struct bcma_bus *bus)
>  {
> -	struct bcma_device *cores[3];
>  	int err;
>  
>  	err = bcma_gpio_unregister(&bus->drv_cc);
> @@ -478,15 +479,7 @@ void bcma_bus_unregister(struct bcma_bus *bus)
>  
>  	bcma_core_chipcommon_b_free(&bus->drv_cc_b);
>  
> -	cores[0] = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
> -	cores[1] = bcma_find_core(bus, BCMA_CORE_PCIE);
> -	cores[2] = bcma_find_core(bus, BCMA_CORE_4706_MAC_GBIT_COMMON);
> -
>  	bcma_unregister_cores(bus);
> -
> -	kfree(cores[2]);
> -	kfree(cores[1]);
> -	kfree(cores[0]);
>  }
>  
>  /*
> 

