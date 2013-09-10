Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:50369 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3IJHTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 03:19:19 -0400
Message-ID: <1378797585.4799.54.camel@porter.coelho.fi> (sfid-20130910_091923_833030_44B486DA)
Subject: Re: [PATCH 07/12] wlcore: cleanup scan debug prints
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 10:19:45 +0300
In-Reply-To: <1378218848-7853-7-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:34 +0300, Eliad Peller wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> Remove scan debug dumps which are rarely used.
> Make scan debug prints more clear and short.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

This is fine, these dumps were used when the firmware scan APIs were
changing all the time and we were having lots of problems following it.
It can be removed now to reduce excessive output.

Some nitpicks below.

[...]
> diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
> index f407101..bbe0bc4 100644
> --- a/drivers/net/wireless/ti/wlcore/scan.c
> +++ b/drivers/net/wireless/ti/wlcore/scan.c
> @@ -174,17 +174,7 @@ wlcore_scan_get_channels(struct wl1271 *wl,
>  		    /* if radar is set, we ignore the passive flag */
>  		    (radar ||
>  		     !!(flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive)) {
> -			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
> -				     req_channels[i]->band,
> -				     req_channels[i]->center_freq);
> -			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
> -				     req_channels[i]->hw_value,
> -				     req_channels[i]->flags);
> -			wl1271_debug(DEBUG_SCAN, "max_power %d",
> -				     req_channels[i]->max_power);
> -			wl1271_debug(DEBUG_SCAN, "min_dwell_time %d max dwell time %d",
> -				     min_dwell_time_active,
> -				     max_dwell_time_active);
> +
>  

Unnecessary extra line here.

[...]
> @@ -222,6 +212,18 @@ wlcore_scan_get_channels(struct wl1271 *wl,
>  					     *n_pactive_ch);
>  			}
>  
> +			wl1271_debug(DEBUG_SCAN, "freq %04d, ch. %03d, flags 0x%02X, power %02d, min/max_dwell %02d/%02d%s%s",

Left-padding with zeros is quite ugly with the decimals here.

--
Luca.

