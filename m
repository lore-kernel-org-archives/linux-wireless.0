Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:13315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747AbZKIWEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 17:04:48 -0500
Received: by fg-out-1718.google.com with SMTP id e12so1421667fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 14:04:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1257803976-5378-1-git-send-email-gwingerde@gmail.com>
References: <1257803976-5378-1-git-send-email-gwingerde@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 9 Nov 2009 23:04:30 +0100
Message-ID: <69e28c910911091404i18e4e4b8ydd9d334bc833de3b@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Properly detect Ralink RT3070 devices.
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 9, 2009 at 10:59 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> Allow rt2800usb to properly detect RT307X based devices, and set the appropriate chipset values.
>
> Signed-off-by: Gertjan van Wingede <gwingerde@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |   21 ++++++++++++++-------
>  drivers/net/wireless/rt2x00/rt2x00.h    |    1 +
>  2 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
> index d22ab64..bd2f6e6 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -790,16 +790,19 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>         */
>        value = rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RF_TYPE);
>        rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
> -       rt2x00_set_chip(rt2x00dev, RT2870, value, reg);
> +       rt2x00_set_chip_rf(rt2x00dev, value, reg);
>
>        /*
>         * The check for rt2860 is not a typo, some rt2870 hardware
>         * identifies itself as rt2860 in the CSR register.
>         */
> -       if (!rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) &&
> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) &&
> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000) &&
> -           !rt2x00_check_rev(&rt2x00dev->chip, 0xffff0000, 0x30700000)) {
> +       if (rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28600000) ||
> +           rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28700000) ||
> +           rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x28800000)) {
> +               rt2x00_set_chip_rt(rt2x00dev, RT3070);

Typo?

> +       } else if (rt2x00_check_rev(&rt2x00dev->chip, 0xfff00000, 0x30700000)) {
> +               rt2x00_set_chip_rt(rt2x00dev, RT3070);
> +       } else {
>                ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
>                return -ENODEV;
>        }
> @@ -809,7 +812,9 @@ static int rt2800usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
>            !rt2x00_rf(&rt2x00dev->chip, RF2720) &&
>            !rt2x00_rf(&rt2x00dev->chip, RF2750) &&
>            !rt2x00_rf(&rt2x00dev->chip, RF3020) &&
> -           !rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +           !rt2x00_rf(&rt2x00dev->chip, RF2020) &&
> +           !rt2x00_rf(&rt2x00dev->chip, RF3021) &&
> +           !rt2x00_rf(&rt2x00dev->chip, RF3022)) {
>                ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
>                return -ENODEV;
>        }
> @@ -1028,7 +1033,9 @@ static int rt2800usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>                spec->num_channels = ARRAY_SIZE(rf_vals);
>                spec->channels = rf_vals;
>        } else if (rt2x00_rf(&rt2x00dev->chip, RF3020) ||
> -                  rt2x00_rf(&rt2x00dev->chip, RF2020)) {
> +                  rt2x00_rf(&rt2x00dev->chip, RF2020) ||
> +                  rt2x00_rf(&rt2x00dev->chip, RF3021) ||
> +                  rt2x00_rf(&rt2x00dev->chip, RF3022)) {
>                spec->num_channels = ARRAY_SIZE(rf_vals_3070);
>                spec->channels = rf_vals_3070;
>        }
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index fd13264..181496e 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -172,6 +172,7 @@ struct rt2x00_chip {
>  #define RT3052         0x3052  /* WSOC */
>  #define RT3090         0x3090  /* 2.4GHz PCIe */
>  #define RT2870         0x1600
> +#define RT3070         0x1800
>
>        u16 rf;
>        u32 rev;
> --
> 1.6.5.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
