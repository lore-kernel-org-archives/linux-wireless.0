Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbdAROo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jan 2017 09:44:26 -0500
Date: Wed, 18 Jan 2017 15:30:02 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 13/14] rt2x00: rt2800lib: add support for RT3352 with
 20MHz crystal
Message-ID: <20170118142958.GA14573@redhat.com> (sfid-20170118_154429_400615_7C575D77)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031541.GA32313@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116031541.GA32313@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:15:56AM +0100, Daniel Golle wrote:
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Mathias Kresin <dev@kresin.me>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 50 +++++++++++++++++++++++++-
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  2 ++
>  2 files changed, 51 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 93c97eade334..cb1457595f05 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -36,6 +36,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/clk.h>
>  
>  #include "rt2x00.h"
>  #include "rt2800lib.h"
> @@ -7675,6 +7676,27 @@ static const struct rf_channel rf_vals_5592_xtal40[] = {
>  	{196, 83, 0, 12, 1},
>  };
>  
> +/*
> + * RF value list for rt3xxx with Xtal20MHz
> + * Supports: 2.4 GHz (all) (RF3322)
> + */
> +static const struct rf_channel rf_vals_xtal20mhz_3x[] = {
Please locate this values in alphabetical order (i.e. after _3x and 
before _5592 ).

>  	struct hw_mode_spec *spec = &rt2x00dev->spec;
> @@ -7764,7 +7786,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	case RF5390:
>  	case RF5392:
>  		spec->num_channels = 14;
> -		spec->channels = rf_vals_3x;
> +		if (spec->clk_is_20mhz)
> +			spec->channels = rf_vals_xtal20mhz_3x;
> +		else
> +			spec->channels = rf_vals_3x;
>  		break;

How does vendor drivers recognize xtal (I assume rf_vals_xtal20mhz_3x 
values were taken from vendor driver) ? It should be possible to get
clock frequency from device register like is is done on RF5592, without
adding additional clock recognition code. But if such code is needed
I prefer that low level board/platform routines do it and place clock
frequency for rt2x00 in rt2x00dev->dev->platform_data.

Stanislaw
