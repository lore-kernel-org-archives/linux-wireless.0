Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60452 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303AbZKKWPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 17:15:18 -0500
Date: Wed, 11 Nov 2009 17:07:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix rt2800lib RF chip programming selection.
Message-ID: <20091111220755.GN4392@tuxdriver.com>
References: <1257803998-5412-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1257803998-5412-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 09, 2009 at 10:59:58PM +0100, Gertjan van Wingerde wrote:
> Mirror the legacy Ralink driver with respect to rt2800 RF register programming. Execute
> rt2800_config_channel_rt3x for all RF2020, RF3020, RF3021 & RF3022 chipsets when operating on RT3070
> devices.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
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

  CC [M]  drivers/net/wireless/rt2x00/rt2800lib.o
drivers/net/wireless/rt2x00/rt2800lib.c: In function ‘rt2800_config_channel’:
drivers/net/wireless/rt2x00/rt2800lib.c:809: error: ‘RF3070’ undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2800lib.c:809: error: (Each undeclared identifier is reported only once
drivers/net/wireless/rt2x00/rt2800lib.c:809: error: for each function it appears in.)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
