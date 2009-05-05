Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:60075 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbZEERlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 13:41:25 -0400
Received: by ewy24 with SMTP id 24so5195337ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2009 10:41:24 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rt2x00: Simplify rt2x00_check_rev
Date: Tue, 5 May 2009 19:41:18 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <200905050925.42406.IvDoorn@gmail.com>
In-Reply-To: <200905050925.42406.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905051941.18637.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 May 2009, Ivo van Doorn wrote:
> rt2x00_check_rev() was too specific for rt2500usb and rt73usb,
> by adding the mask argument (instead of hardcoding it into the
> function itself) we can use the function in rt2800usb as well.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---

Please drop this patch. I'll send the correct version in a few minutes.

>  drivers/net/wireless/rt2x00/rt2500usb.c |    2 +-
>  drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++---
>  drivers/net/wireless/rt2x00/rt2x00.h    |    7 +++----
>  drivers/net/wireless/rt2x00/rt73usb.c   |    3 ++-
>  4 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index 9e630e7..8efb2d7 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1559,7 +1559,7 @@ static int rt2500usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	rt2500usb_register_read(rt2x00dev, MAC_CSR0, &reg);
>  	rt2x00_set_chip(rt2x00dev, RT2570, value, reg);
>  
> -	if (!rt2x00_check_rev(&rt2x00dev->chip, 0)) {
> +	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0)) {
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>  		return -ENODEV;
>  	}
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index 7cb3653..8dd1489 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -2348,9 +2348,10 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	 * The check for rt2860 is not a typo, some rt2870 hardware
>  	 * identifies itself as rt2860 in the CSR register.
>  	 */
> -	if ((rt2x00_get_field32(reg, MAC_CSR0_ASIC_VER) != 0x2860) &&
> -	    (rt2x00_get_field32(reg, MAC_CSR0_ASIC_VER) != 0x2870) &&
> -	    (rt2x00_get_field32(reg, MAC_CSR0_ASIC_VER) != 0x3070)) {
> +	if (!rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x286) &&
> +	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x287) &&
> +	    !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x288) &&
> +	    !rt2x00_check_rev(&rt2x00dev->chip, 0xffff0000, 0x3070)) {
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>  		return -ENODEV;
>  	}
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index 998dc93..6999ebd 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -921,11 +921,10 @@ static inline u32 rt2x00_rev(const struct rt2x00_chip *chipset)
>  	return chipset->rev;
>  }
>  
> -static inline u16 rt2x00_check_rev(const struct rt2x00_chip *chipset,
> -				   const u32 rev)
> +static inline bool rt2x00_check_rev(const struct rt2x00_chip *chipset,
> +				    const u32 mask, const u32 rev)
>  {
> -	return (((chipset->rev & 0xffff0) == rev) &&
> -		!!(chipset->rev & 0x0000f));
> +	return ((chipset->rev & mask) == rev);
>  }
>  
>  /**
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
> index 853b2b2..4f94a61 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -1846,7 +1846,8 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>  	rt2x00usb_register_read(rt2x00dev, MAC_CSR0, &reg);
>  	rt2x00_set_chip(rt2x00dev, RT2571, value, reg);
>  
> -	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x25730)) {
> +	if (!rt2x00_check_rev(&rt2x00dev->chip, 0x000ffff0, 0x25730) ||
> +	    !rt2x00_check_rev(&rt2x00dev->chip, 0x0000000f, 0)) {
>  		ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>  		return -ENODEV;
>  	}


