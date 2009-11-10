Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:8638 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757515AbZKJSdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:33:08 -0500
Received: by ey-out-2122.google.com with SMTP id 9so70931eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:33:12 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix rt2800lib RF chip programming selection.
Date: Tue, 10 Nov 2009 19:33:09 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257803998-5412-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257803998-5412-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911101933.09747.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009, Gertjan van Wingerde wrote:
> Mirror the legacy Ralink driver with respect to rt2800 RF register programming. Execute
> rt2800_config_channel_rt3x for all RF2020, RF3020, RF3021 & RF3022 chipsets when operating on RT3070
> devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 2c91c44..446087e 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -806,10 +806,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>  	unsigned int tx_pin;
>  	u8 bbp;
>  
> -	if (rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
> -		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
> -	else
> +	if (rt2x00_rt(&rt2x00dev->chip, RT3070) &&	
> +           (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> +	     rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> +	     rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> +	     rt2x00_rf(&rt2x00dev->chip, RF3022)))
>  		rt2800_config_channel_rt3x(rt2x00dev, conf, rf, info);
> +	else
> +		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
>  
>  	/*
>  	 * Change BBP settings


