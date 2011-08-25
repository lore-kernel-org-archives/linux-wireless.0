Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58064 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495Ab1HYRsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 13:48:11 -0400
Received: by mail-bw0-f49.google.com with SMTP id 17so3011999bke.22
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 10:48:10 -0700 (PDT)
Subject: Re: [PATCH 4/5] wl12xx: add config_hangover command
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314288270-22380-4-git-send-email-eliad@wizery.com>
References: <1314288270-22380-1-git-send-email-eliad@wizery.com>
	 <1314288270-22380-4-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 20:48:06 +0300
Message-ID: <1314294486.2296.306.camel@cumari> (sfid-20110825_194817_795940_8CBECB92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 19:04 +0300, Eliad Peller wrote: 
> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index f2838ae..a325dba 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1687,3 +1687,43 @@ out:
>  	kfree(acx);
>  	return ret;
>  }
> +
> +int wl12xx_acx_config_hangover(struct wl1271 *wl)
> +{
> +	struct wl12xx_acx_config_hangover *acx;
> +	struct conf_hangover_settings *conf = &wl->conf.hangover;
> +	int ret;
> +
> +	wl1271_debug(DEBUG_ACX, "acx config hangover");
> +
> +	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
> +	if (!acx) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	acx->recover_time = cpu_to_le32(conf->recover_time);
> +	acx->hangover_period = conf->hangover_period;
> +	acx->dynamic_mode = conf->dynamic_mode;
> +	acx->early_termination_mode = conf->early_termination_mode;
> +	acx->max_period = conf->max_period;
> +	acx->min_period = conf->min_period;
> +	acx->increase_delta = conf->increase_delta;
> +	acx->decrease_delta = conf->decrease_delta;
> +	acx->quiet_time = conf->quiet_time;
> +	acx->increase_delta = conf->increase_time;

Typo, this should be acx->increase_time.


-- 
Cheers,
Luca.

