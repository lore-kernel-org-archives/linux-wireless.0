Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58921 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab2KSSO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 13:14:58 -0500
Message-ID: <1353348860.10872.131.camel@cumari.coelho.fi> (sfid-20121119_191530_560630_A59F36D2)
Subject: Re: [PATCH 01/15] wlcore: start sta role on CHANGED_BSSID
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Mon, 19 Nov 2012 20:14:20 +0200
In-Reply-To: <1353343170-26516-2-git-send-email-eliad@wizery.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	 <1353343170-26516-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
> Make the connection flow simpler by starting
> sta role on bssid change.
> 
> Currently, we start dev role when going idle-off,
> and start the sta role only after association
> indication. This complicates the connection
> flow with some possible intermediate states.
> 
> Make it simpler by starting sta role on bssid change,
> which now happens *before* auth req get sent.
> 
> Update the handling of mac80211's notifications
> and change wl1271_join/unjoin accordingly -
> * Split wl1271_join() into wlcore_join (tuning on
>   a channel/bssid) and wlcore_set_assoc (configure
>   sta after association).
> * Rename wl1271_unjoin() to wlcore_disconnect(), as
>   it is no longer the inversion of wl1271_join()
>   (now it's only used to disconnect associated sta /
>   joined ibss, without stopping the role).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

[...]

> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 41ed1d5..41a8502 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -2468,8 +2468,7 @@ static int wl12xx_op_change_interface(struct ieee80211_hw *hw,

[...]

> -static int wl1271_unjoin(struct wl1271 *wl, struct wl12xx_vif *wlvif)
> +static void wlcore_disconnect(struct wl1271 *wl, struct wl12xx_vif *wlvif)

Why not wlcore_unset_assoc()? Or change the wlcore_set_assoc() to
wlcore_connect()?

[...]

> @@ -3921,15 +3850,63 @@ sta_not_found:
>  			wlvif->basic_rate =
>  				wl1271_tx_min_rate_get(wl,
>  						       wlvif->basic_rate_set);
> +
>  			if (sta_rate_set)
>  				wlvif->rate_set =
>  					wl1271_tx_enabled_rates_get(wl,
>  								sta_rate_set,
>  								wlvif->band);
> +
> +			/* we only supports sched_scan while not connected */

s/supports/support/

> +			if (wl->sched_scanning) {
> +				wl1271_scan_sched_scan_stop(wl, wlvif);
> +				ieee80211_sched_scan_stopped(wl->hw);
> +			}
> +
>  			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
>  			if (ret < 0)
>  				goto out;
>  
> +			ret = wl12xx_cmd_build_null_data(wl, wlvif);
> +			if (ret < 0)
> +				goto out;
> +
> +			ret = wl1271_build_qos_null_data(wl, vif);
> +			if (ret < 0)
> +				goto out;
> +
> +			/* Need to update the BSSID (for filtering etc) */
> +			set_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
> +			do_join = true;
> +		} else {
> +			/* revert back to minimum rates for the current band */
> +			wl1271_set_band_rate(wl, wlvif);
> +			wlvif->basic_rate =
> +				wl1271_tx_min_rate_get(wl,
> +						       wlvif->basic_rate_set);
> +			ret = wl1271_acx_sta_rate_policies(wl, wlvif);
> +			if (ret < 0)
> +				goto out;
> +
> +			if (!is_ibss &&
> +			    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags)) {
> +				ret = wl12xx_cmd_role_stop_sta(wl, wlvif);
> +				if (ret < 0)
> +					goto out;
> +			}
> +			clear_bit(WLVIF_FLAG_IN_USE, &wlvif->flags);
> +		}
> +	}

It would be nice to keep all this stuff in a separate function instead
of bringing it back into this already-huge wl1271_bss_info_changed_sta()
function.


> +	if ((changed & BSS_CHANGED_ASSOC)) {

Same thing for this if, but you already did a great job removing things
from here. ;)

> +		if (bss_conf->assoc) {
> +			int ieoffset;
> +			wlvif->aid = bss_conf->aid;
> +			wlvif->channel_type = bss_conf->channel_type;
> +			wlvif->beacon_int = bss_conf->beacon_int;
> +
> +			set_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags);

Wouldn't it be better to put this in the set_assoc() function?

--
Luca.

