Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40222 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab0EFLMM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 07:12:12 -0400
Received: by wyb35 with SMTP id 35so1061331wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 May 2010 04:12:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005061301.22323.IvDoorn@gmail.com>
References: <201005061301.22323.IvDoorn@gmail.com>
Date: Thu, 6 May 2010 13:12:10 +0200
Message-ID: <s2o14add3d11005060412xf64df988x239517f049930d58@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Add 5GHz support for RF3052 devices
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 6, 2010 at 1:01 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> According to the Ralink drivers, the RF3052 chipset
> supports the 5GHz band. Update channel initialization
> to add the corresponding channels for this chip.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Actually, I believe that this is not correct (sorry I don't have the
Ralink driver at hand at the moment, nor the rt2x00 tree).
AFAIK the RF3052 needs the same initialization as for RF3020, RF3021,
RF3022, etc extended with the correct values for
5GHz band.

So, NAK for this patch.

Also, please keep in mind that for proper RT3572 support more needs to
be done, also in the register, BPP, and RFCSR initializations.

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index e7a61a3..0d6f715 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2223,7 +2223,7 @@ EXPORT_SYMBOL_GPL(rt2800_init_eeprom);
>
>  /*
>  * RF value list for rt28x0
> - * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850 & RF2750)
> + * Supports: 2.4 GHz (all) & 5.2 GHz (RF2850, RF2750 & RF3052)
>  */
>  static const struct rf_channel rf_vals[] = {
>        { 1,  0x18402ecc, 0x184c0786, 0x1816b455, 0x1800510b },
> @@ -2355,11 +2355,12 @@ int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>        spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
>
>        if (rt2x00_rf(rt2x00dev, RF2820) ||
> -           rt2x00_rf(rt2x00dev, RF2720) ||
> -           rt2x00_rf(rt2x00dev, RF3052)) {
> +           rt2x00_rf(rt2x00dev, RF2720)) {
>                spec->num_channels = 14;
>                spec->channels = rf_vals;
> -       } else if (rt2x00_rf(rt2x00dev, RF2850) || rt2x00_rf(rt2x00dev, RF2750)) {
> +       } else if (rt2x00_rf(rt2x00dev, RF2850) ||
> +                  rt2x00_rf(rt2x00dev, RF2750) ||
> +                  rt2x00_rf(rt2x00dev, RF3052)) {
>                spec->supported_bands |= SUPPORT_BAND_5GHZ;
>                spec->num_channels = ARRAY_SIZE(rf_vals);
>                spec->channels = rf_vals;
> --
> 1.6.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
