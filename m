Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:44644 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131Ab2BBIjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 03:39:48 -0500
Received: by lahl5 with SMTP id l5so1762737lah.17
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 00:39:46 -0800 (PST)
Subject: Re: [PATCH v2 6/7] wl12xx: add RX data filters management functions
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328021048-8944-7-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
	 <1328021048-8944-7-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 10:39:41 +0200
Message-ID: <1328171981.3626.274.camel@cumari> (sfid-20120202_093952_005883_D51E8640)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> From: Eyal Shapira <eyal@wizery.com>
> 
> (based on Pontus' patch)
> 
> More prep work for supporting RX data filters
> in FW. These functions use a driver saved state
> of the enabled filters to prevent actions (enable/disable)
> which don't match the FW status.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]


> diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
> index 4fbd2a7..d025db6 100644
> --- a/drivers/net/wireless/wl12xx/rx.c
> +++ b/drivers/net/wireless/wl12xx/rx.c
> @@ -282,3 +282,64 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
>  
>  	wl12xx_rearm_rx_streaming(wl, active_hlids);
>  }
> +
> +/*
> + * Global on / off for RX packet filtering in firmware
> + */
> +int wl1271_rx_data_filtering_enable(struct wl1271 *wl, bool enable,
> +				    enum rx_data_filter_action policy)
> +{
> +	int ret;
> +
> +	if (policy < FILTER_DROP || policy > FILTER_FW_HANDLE) {
> +		wl1271_warning("filter policy value is not in valid range");
> +		return -ERANGE;
> +	}

Again, this is only called internally, so we either use a BUG_ON or we
don't check the values here at all.


> +	if (enable < 0 || enable > 1) {
> +		wl1271_warning("filter enable value is not in valid range");
> +		return -ERANGE;
> +	}

No need to check the validity of the bool here.


> +	ret = wl1271_acx_toggle_rx_data_filter(wl, enable, policy);

If you want to be really sure the boolean is really a boolean, you
should use !!enable here, though I don't think it's necessary.


> +int wl1271_rx_data_filter_enable(struct wl1271 *wl,
> +				 int index,
> +				 bool enable,
> +				 struct wl12xx_rx_data_filter *filter)
> +{
> +	int ret;
> +
> +	if (wl->rx_data_filters_status[index] == enable) {
> +		wl1271_debug(DEBUG_ACX, "Request to enable an already "
> +			     "enabled rx filter %d", index);
> +		return 0;
> +	}

Maybe DEBUG_RX? Or something else? It's definitely not DEBUG_ACX,
though.


> +void wl1271_rx_data_filters_clear_all(struct wl1271 *wl);
>  #endif
> diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
> index c18ad0a..720ea82 100644
> --- a/drivers/net/wireless/wl12xx/wl12xx.h
> +++ b/drivers/net/wireless/wl12xx/wl12xx.h
> @@ -509,6 +509,9 @@ struct wl1271 {
>  
>  	/* last wlvif we transmitted from */
>  	struct wl12xx_vif *last_wlvif;
> +
> +	/* RX Data filter rule status - enabled/disabled */
> +	bool rx_data_filters_status[WL1271_MAX_RX_DATA_FILTERS];

Maybe s/_status/_enabled/? Also I think for all the code we should
s/rx_data_filter/rx_filter/ so we can reduce the length of the symbols.

-- 
Cheers,
Luca.

