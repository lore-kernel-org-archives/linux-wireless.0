Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:35172 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1HINTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 09:19:39 -0400
Received: by mail-ew0-f41.google.com with SMTP id 9so1059768ewy.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 06:19:38 -0700 (PDT)
Subject: Re: [PATCH 05/40] wl12xx: remove rx filtering stuff
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-6-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-6-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 16:19:34 +0300
Message-ID: <1312895974.2407.185.camel@cumari> (sfid-20110809_151943_211100_B793FBF1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> The new fw doesn't support rx_filtering configuration (as a
> stand-alone command. the rx filtering is done automatically
> according to the active role).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  drivers/net/wireless/wl12xx/acx.c     |   28 --------
>  drivers/net/wireless/wl12xx/acx.h     |  118 ---------------------------------
>  drivers/net/wireless/wl12xx/boot.c    |    3 -
>  drivers/net/wireless/wl12xx/cmd.c     |    4 -
>  drivers/net/wireless/wl12xx/debugfs.c |    3 -
>  drivers/net/wireless/wl12xx/init.c    |   12 +---
>  drivers/net/wireless/wl12xx/io.h      |    1 -
>  drivers/net/wireless/wl12xx/main.c    |   62 ++----------------
>  drivers/net/wireless/wl12xx/reg.h     |   75 ---------------------
>  drivers/net/wireless/wl12xx/rx.c      |   11 ---
>  drivers/net/wireless/wl12xx/rx.h      |    1 -
>  drivers/net/wireless/wl12xx/scan.c    |    3 -
>  drivers/net/wireless/wl12xx/tx.c      |    4 +-
>  drivers/net/wireless/wl12xx/wl12xx.h  |   22 ------
>  14 files changed, 8 insertions(+), 339 deletions(-)

Yay! This looks good, lots of code could be removed! This filtering
things were a bit messy before. :)


> diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
> index c3e9a2e..7aa8fc7 100644
> --- a/drivers/net/wireless/wl12xx/init.c
> +++ b/drivers/net/wireless/wl12xx/init.c
> @@ -224,24 +224,20 @@ static int wl1271_ap_init_templates_config(struct wl1271 *wl)
>  	if (ret < 0)
>  		return ret;
>  
>  	return 0;
>  }
>  
> -static int wl1271_init_rx_config(struct wl1271 *wl, u32 config, u32 filter)
> +static int wl1271_init_rx_config(struct wl1271 *wl)

Could you change the wl1271_init_rx_config() to wl12xx_init_rx_config()?
We more or less agreed that we would start converting wl1271 to wl12xx
slowly, each time we need to change the function declaration.  It gets a
bit inconsistent, but at least we don't screw up git-blame by doing this
in one go with a huge patch.


> @@ -2425,24 +2385,17 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
>  							   fp->mc_list,
>  							   fp->mc_list_length);
>  		if (ret < 0)
>  			goto out_sleep;
>  	}
>  
> -	/* determine, whether supported filter values have changed */
> -	if (changed == 0)
> -		goto out_sleep;
> -
> -	/* configure filters */
> -	wl->filters = *total;
> -	wl1271_configure_filters(wl, 0);
> -
> -	/* apply configured filters */
> -	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
> -	if (ret < 0)
> -		goto out_sleep;
> +	/*
> +	 * the fw doesn't provide an api to configure the filters. instead,
> +	 * the filters configuration is based on the active roles / ROC
> +	 * state.
> +	 */

Is this really safe? I guess we should trust the firmware to set the
filters correctly, but isn't there *any* other reason why mac80211 would
want to change the filters? Just want to be sure. ;)

BTW, this patch could be before 04.  If we really include those #if 0's,
we should try to keep them for as few commits as possible.

-- 
Cheers,
Luca.

