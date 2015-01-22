Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40534 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbAVSNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 13:13:06 -0500
Received: by mail-wg0-f51.google.com with SMTP id l18so3252306wgh.10
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2015 10:13:04 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: p54: add handling of the signal case
Date: Thu, 22 Jan 2015 19:13:01 +0100
Message-ID: <12702639.FEnIjGW6UW@debian64> (sfid-20150122_191310_360243_372E35F4)
In-Reply-To: <1421731543-13290-1-git-send-email-der.herr@hofr.at>
References: <1421731543-13290-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 20, 2015 06:25:43 AM Nicholas Mc Guire wrote:
> if(!wait_for_completion_interruptible_timeout(...))
> only handles the timeout case - this patch adds handling the
> signal case the same as timeout.
> 
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

> diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
> index bc065e8..5367d51 100644
> --- a/drivers/net/wireless/p54/fwio.c
> +++ b/drivers/net/wireless/p54/fwio.c
> @@ -249,9 +250,11 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
>  
>  	p54_tx(priv, skb);
>  
> -	if (!wait_for_completion_interruptible_timeout(
> -	     &priv->eeprom_comp, HZ)) {
> -		wiphy_err(priv->hw->wiphy, "device does not respond!\n");
> +	timeout = wait_for_completion_interruptible_timeout(
> +			&priv->eeprom_comp, HZ);
> +	if (timeout <= 0) {
> +		wiphy_err(priv->hw->wiphy,
> +			"device does not respond or signal received!\n");
>  		ret = -EBUSY;
>  	}
>  	priv->eeprom = NULL;
> 

CHECK: Alignment should match open parenthesis
#98: FILE: drivers/net/wireless/p54/fwio.c:257:
+               wiphy_err(priv->hw->wiphy,
+                       "device does not respond or signal received!\n");

total: 0 errors, 0 warnings, 1 checks, 21 lines checked

