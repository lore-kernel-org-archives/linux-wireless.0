Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:54718 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1GZIOr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 04:14:47 -0400
Received: by pzk37 with SMTP id 37so448642pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 01:14:47 -0700 (PDT)
Date: Tue, 26 Jul 2011 11:12:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 09/29] staging: brcm80211: remove code for unsupported
 chip
Message-ID: <20110726081248.GB3824@shale.localdomain> (sfid-20110726_101456_020200_272FA6C7)
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
 <1311361036-3175-10-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311361036-3175-10-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 22, 2011 at 08:56:56PM +0200, Arend van Spriel wrote:
> From: Franky Lin <frankyl@broadcom.com>
> 
> Currently fullmac only support bcm4329. Remove dead code for
> unsupported chip.

This description doesn't match the code at all.

Sorry that I'm looking at this so long after you sent it...

regards,
dan carpenter

> 
> Cc: devel@linuxdriverproject.org
> Cc: linux-wireless@vger.kernel.org
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> index 16ea6e8..2a9efc3 100644
> --- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> +++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> @@ -980,6 +980,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
>  			return -ENOMEM;
>  		sdiodev->func1 = func;
>  		dev_set_drvdata(&func->card->dev, sdiodev);
> +
> +		atomic_set(&brcmf_mmc_suspend, false);
>  	}
>  
>  	gInstance->func[func->num] = func;
> -- 
> 1.7.4.1
> 
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
