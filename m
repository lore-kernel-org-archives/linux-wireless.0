Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33063 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbZETQg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 12:36:58 -0400
Received: by ewy24 with SMTP id 24so640229ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 09:36:59 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] wireless: beyond ARRAY_SIZE of intf->crypto_stats
Date: Wed, 20 May 2009 18:36:55 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linville@tuxdriver.com
References: <4A134B08.3080803@gmail.com>
In-Reply-To: <4A134B08.3080803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905201836.56071.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 May 2009, Roel Kluin wrote:
> Do not go beyond ARRAY_SIZE of intf->crypto_stats
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

I really hope the previous code never resulted in a crash,
since then I would have to look into strange values coming
from the hardware. ;)

Thanks.

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index 07d378e..7b3ee8c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -138,7 +138,7 @@ void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
>  
>  	if (cipher == CIPHER_TKIP_NO_MIC)
>  		cipher = CIPHER_TKIP;
> -	if (cipher == CIPHER_NONE || cipher > CIPHER_MAX)
> +	if (cipher == CIPHER_NONE || cipher >= CIPHER_MAX)
>  		return;
>  
>  	/* Remove CIPHER_NONE index */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


