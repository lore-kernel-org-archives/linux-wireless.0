Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f52.google.com ([209.85.214.52]:57401 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1BOTrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 14:47:19 -0500
Received: by bwz4 with SMTP id 4so762811bwz.11
        for <linux-wireless@vger.kernel.org>; Tue, 15 Feb 2011 11:47:18 -0800 (PST)
Message-ID: <4D5AD6A6.8090505@gmail.com>
Date: Tue, 15 Feb 2011 20:40:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nikolay Ledovskikh <nledovskikh@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	lrodriguez@atheros.com, mickflemm@gmail.com, me@bobcopeland.com
Subject: Re: [PATCH] ath5k: Use mips generic dma-mapping functions to avoid
 seqfault on AHB chips
References: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
In-Reply-To: <20110215220929.1cc6e9d4.nledovskikh@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2011 08:09 PM, Nikolay Ledovskikh wrote:
> This patch fixes seqfault on ar2316 and other AHB based chips.

You need to spare few more words on the changelog.

> Signed-off-by: Nikolay Ledovskikh <nledovskikh@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index 707cde1..35d5273 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
...
> @@ -92,7 +92,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		goto err_out;
>  	}
>  
> -	mem = ioremap_nocache(res->start, res->end - res->start + 1);
> +	mem = res->start;

Looking into the code which fills this, I still don't get the change.
res->start is a physical address which should be remapped. Care to
elaborate?

>  	if (mem == NULL) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
>  		ret = -ENOMEM;
> @@ -114,10 +114,11 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		ret = -ENOMEM;
>  		goto err_out;
>  	}
> +	SET_IEEE80211_DEV(hw, &pdev->dev);
>  
>  	sc = hw->priv;
>  	sc->hw = hw;
> -	sc->dev = &pdev->dev;
> +	sc->dev = NULL;

This I don't understand too. Maybe because of missing changelog...

regards,
-- 
js
