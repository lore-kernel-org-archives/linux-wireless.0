Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39954 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1CGH2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 02:28:53 -0500
Received: by fxm17 with SMTP id 17so3803487fxm.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 23:28:52 -0800 (PST)
Message-ID: <4D748930.90906@gmail.com>
Date: Mon, 07 Mar 2011 08:28:48 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Shan Wei <shanwei@cn.fujitsu.com>
CC: mickflemm@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com,
	"John W. Linville" <linville@tuxdriver.com>, jmalinen@atheros.com,
	vasanth@atheros.com, senthilkumar@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH ] wireless:ath: use resource_size() help function
References: <4D7486B3.3090507@cn.fujitsu.com>
In-Reply-To: <4D7486B3.3090507@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2011 08:18 AM, Shan Wei wrote:
> 
> 
> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>

ACK.

> ---
>  drivers/net/wireless/ath/ath5k/ahb.c |    2 +-
>  drivers/net/wireless/ath/ath9k/ahb.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
> index ae84b86..82324e9 100644
> --- a/drivers/net/wireless/ath/ath5k/ahb.c
> +++ b/drivers/net/wireless/ath/ath5k/ahb.c
> @@ -93,7 +93,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		goto err_out;
>  	}
>  
> -	mem = ioremap_nocache(res->start, res->end - res->start + 1);
> +	mem = ioremap_nocache(res->start, resource_size(res));
>  	if (mem == NULL) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
>  		ret = -ENOMEM;
> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
> index 9936721..9cb0efa 100644
> --- a/drivers/net/wireless/ath/ath9k/ahb.c
> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
> @@ -75,7 +75,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
>  		goto err_out;
>  	}
>  
> -	mem = ioremap_nocache(res->start, res->end - res->start + 1);
> +	mem = ioremap_nocache(res->start, resource_size(res));
>  	if (mem == NULL) {
>  		dev_err(&pdev->dev, "ioremap failed\n");
>  		ret = -ENOMEM;

thanks,
-- 
js
