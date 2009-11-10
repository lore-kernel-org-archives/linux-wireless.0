Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:51444 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297AbZKJVn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 16:43:27 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so527736ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 13:43:32 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Initialize rf302x RF values properly for rt2800pci.
Date: Tue, 10 Nov 2009 22:43:31 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257889360-388-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257889360-388-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911102243.31272.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10 November 2009, Gertjan van Wingerde wrote:
> Ensure RF302x and RF2020 chipsets are handled properly in rt2800lib for the rt3090 chipset.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> Rebased to apply on top of Bart's second series of unification patches.
> 
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   31 +++++++++++++------------------
>  1 files changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index a848cf5..75d3d00 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -1,5 +1,6 @@
>  /*
>  	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> +	Copyright (C) 2009 Gertjan van Wingerde <gwingerde@gmail.com>
>  
>  	Based on the original rt2800pci.c and rt2800usb.c.
>  	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
> @@ -806,8 +807,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>  	unsigned int tx_pin;
>  	u8 bbp;
>  
> -	if (rt2x00_rt(&rt2x00dev->chip, RT3070) &&	
> -           (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> +	if ((rt2x00_rt(&rt2x00dev->chip, RT3070) ||
> +	     rt2x00_rt(&rt2x00dev->chip, RT3090)) &&
> +	    (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3020) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3021) ||
>  	     rt2x00_rf(&rt2x00dev->chip, RF3022)))
> @@ -1989,7 +1991,7 @@ static const struct rf_channel rf_vals[] = {
>   * RF value list for rt3070
>   * Supports: 2.4 GHz
>   */
> -static const struct rf_channel rf_vals_3070[] = {
> +static const struct rf_channel rf_vals_302x[] = {
>  	{1,  241, 2, 2 },
>  	{2,  241, 2, 7 },
>  	{3,  242, 2, 2 },
> @@ -2046,26 +2048,19 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  
>  	if (rt2x00_rf(chip, RF2820) ||
>  	    rt2x00_rf(chip, RF2720) ||
> -	    (rt2x00_intf_is_pci(rt2x00dev) &&
> -	     (rt2x00_rf(chip, RF3020) ||
> -	      rt2x00_rf(chip, RF3021) ||
> -	      rt2x00_rf(chip, RF3022) ||
> -	      rt2x00_rf(chip, RF2020) ||
> -	      rt2x00_rf(chip, RF3052)))) {
> +	    (rt2x00_intf_is_pci(rt2x00dev) && rt2x00_rf(chip, RF3052))) {
>  		spec->num_channels = 14;
>  		spec->channels = rf_vals;
> -	} else if (rt2x00_rf(chip, RF2850) ||
> -		   rt2x00_rf(chip, RF2750)) {
> +	} else if (rt2x00_rf(chip, RF2850) || rt2x00_rf(chip, RF2750)) {
>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>  		spec->channels = rf_vals;
> -	} else if (rt2x00_intf_is_usb(rt2x00dev) &&
> -		    (rt2x00_rf(chip, RF3020) ||
> -		     rt2x00_rf(chip, RF2020) ||
> -		     rt2x00_rf(chip, RF3021) ||
> -		     rt2x00_rf(chip, RF3022))) {
> -		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
> -		spec->channels = rf_vals_3070;
> +	} else if (rt2x00_rf(chip, RF3020) ||
> +		   rt2x00_rf(chip, RF2020) ||
> +		   rt2x00_rf(chip, RF3021) ||
> +		   rt2x00_rf(chip, RF3022)) {
> +		spec->num_channels = ARRAY_SIZE(rf_vals_302x);
> +		spec->channels = rf_vals_302x;
>  	}
>  
>  	/*


