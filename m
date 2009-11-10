Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58070 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538AbZKJSeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:34:16 -0500
Received: by ewy3 with SMTP id 3so329626ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:34:21 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Properly detect Ralink RT3070 devices.
Date: Tue, 10 Nov 2009 19:34:19 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257804992-7882-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257804992-7882-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911101934.19300.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009, Gertjan van Wingerde wrote:
> Allow rt2800usb to properly detect RT307X based devices, and set the appropriate chipset values.
> 
> Signed-off-by: Gertjan van Wingede <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> Fix the typo found by Gábor Stefanik.
> 
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   21 ++++++++++++++-------
>  drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index d22ab64..bd2f6e6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -790,16 +790,19 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
>  	rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
> -	rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
> +	rt2x00_set_chip_rf(rt2x00dev, value, reg);
>  
>  	/*
>  	 * The check for rt2860 is not a typo, some rt2870 hardware
>  	 * identifies itself as rt2860 in the CSR register.
>  	 */
> -	if (!rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000) &&
> -	    !rt2x00_check_rev(&rt2x00dev->chip, 0xffff0000, 0x30700000)) {
> +	if (rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) ||
> +	    rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) ||
> +	    rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000)) {
> +		rt2x00_set_chip_rt(rt2x00dev, RT2870);
> +	} else if (rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x30700000)) {
> +		rt2x00_set_chip_rt(rt2x00dev, RT3070);
> +	} else {
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>  		return -ENODEV;
>  	}
> @@ -809,7 +812,9 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
>  	    !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
> -	    !rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +	    !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
> +	    !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
> +	    !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
>  		ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
>  		return -ENODEV;
>  	}
> @@ -1028,7 +1033,9 @@ static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		spec->num_channels = ARRAY_SIZE(rf_vals);
>  		spec->channels = rf_vals;
>  	} else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> -		   rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +		   rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> +		   rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> +		   rt2x00_rf(&rt2x00dev->chip, RF3022)) {
>  		spec->num_channels = ARRAY_SIZE(rf_vals_3070);
>  		spec->channels = rf_vals_3070;
>  	}
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index fd13264..181496e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -172,6 +172,7 @@ struct rt2x00_chip {
>  #define RT3052		0x3052	/* WSOC */
>  #define RT3090		0x3090	/* 2.4GHz PCIe */
>  #define RT2870		0x1600
> +#define RT3070		0x1800
>  
>  	u16 rf;
>  	u32 rev;


