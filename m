Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52476 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbbLNRtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 12:49:10 -0500
Date: Mon, 14 Dec 2015 18:49:07 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: <linux-mtd@lists.infradead.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mtd: bcm47xxnflash: really unregister NAND on device
 removal
Message-ID: <20151214184907.3460eb71@bbrezillon> (sfid-20151214_184920_963451_7F0C4A1F)
In-Reply-To: <1449623099-21634-1-git-send-email-computersforpeace@gmail.com>
References: <1449623099-21634-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue,  8 Dec 2015 17:04:59 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> The field bcma_nflash::mtd is never set to be non-zero anywhere, but we
> test for it in the removal path. So the MTD is never unregistered.
> 
> Also, we should use nand_release(), not mtd_device_unregister().
> 
> Finally, we don't need to use the 'platdata' for stashing/retrieving our
> *driver* data -- that's what *_{get,set}_drvdata() are for.
> 
> So, kill off bcm_nflash::mtd, and stash the struct bcm47xxnflash in
> drvdata instead. Also move the forward declaration of mtd_info up a bit,
> since struct bcma_sflash should be using it.
> 
> Caught while inspecting other changes being made to this driver. Compile
> tested only.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: "Rafał Miłecki" <zajec5@gmail.com>
> Cc: linux-wireless@vger.kernel.org

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

> ---
> Might have some small conflict with Boris' NAND/MTD refactoring patch set. I
> can rebase this small one if his gets in proper shape. Just wanted to get this
> out there.
> 
>  drivers/mtd/nand/bcm47xxnflash/main.c       | 7 ++++---
>  include/linux/bcma/bcma_driver_chipcommon.h | 6 ++----
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/bcm47xxnflash/main.c b/drivers/mtd/nand/bcm47xxnflash/main.c
> index 9ba0c0f2cd9b..0b3acc439181 100644
> --- a/drivers/mtd/nand/bcm47xxnflash/main.c
> +++ b/drivers/mtd/nand/bcm47xxnflash/main.c
> @@ -49,6 +49,8 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
>  		return err;
>  	}
>  
> +	platform_set_drvdata(pdev, b47n);
> +
>  	err = mtd_device_parse_register(&b47n->mtd, probes, NULL, NULL, 0);
>  	if (err) {
>  		pr_err("Failed to register MTD device: %d\n", err);
> @@ -60,10 +62,9 @@ static int bcm47xxnflash_probe(struct platform_device *pdev)
>  
>  static int bcm47xxnflash_remove(struct platform_device *pdev)
>  {
> -	struct bcma_nflash *nflash = dev_get_platdata(&pdev->dev);
> +	struct bcm47xxnflash *nflash = platform_get_drvdata(pdev);
>  
> -	if (nflash->mtd)
> -		mtd_device_unregister(nflash->mtd);
> +	nand_release(&nflash->mtd);
>  
>  	return 0;
>  }
> diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
> index cf038431a5cc..db51a6ffb7d6 100644
> --- a/include/linux/bcma/bcma_driver_chipcommon.h
> +++ b/include/linux/bcma/bcma_driver_chipcommon.h
> @@ -579,6 +579,8 @@ struct bcma_pflash {
>  };
>  
>  #ifdef CONFIG_BCMA_SFLASH
> +struct mtd_info;
> +
>  struct bcma_sflash {
>  	bool present;
>  	u32 window;
> @@ -592,13 +594,9 @@ struct bcma_sflash {
>  #endif
>  
>  #ifdef CONFIG_BCMA_NFLASH
> -struct mtd_info;
> -
>  struct bcma_nflash {
>  	bool present;
>  	bool boot;		/* This is the flash the SoC boots from */
> -
> -	struct mtd_info *mtd;
>  };
>  #endif
>  



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
