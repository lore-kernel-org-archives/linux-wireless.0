Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:25295 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaKQMDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 07:03:24 -0500
Message-ID: <5469E3F7.7020303@broadcom.com> (sfid-20141117_130328_100301_966CBE91)
Date: Mon, 17 Nov 2014 13:03:03 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
CC: <luca@coelho.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211: allow drivers to provide any statistics
References: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1416221286-23126-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17-11-14 11:48, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In many cases, drivers can filter things like beacons that will
> skew statistics reported by mac80211. To get correct statistics
> in these cases, call drivers to obtain statistics and let them
> override all values, filling values from mac80211 if the driver
> didn't provide them.
> 
> Note that this doesn't currently allow a driver to say "I know
> this value is wrong, don't report it at all", or to sum it up
> with a mac80211 value (as could be useful for "dropped misc"),
> that can be added if it turns out to be needed.
> 
> This also gets rid of the get_rssi() method as is can now be
> implemented using sta_statistics().
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 22 ++++----
>  include/net/mac80211.h                | 14 +++--
>  net/mac80211/driver-ops.h             | 30 +++++------
>  net/mac80211/sta_info.c               | 97 +++++++++++++++++++++++------------
>  net/mac80211/trace.h                  | 33 +++---------
>  5 files changed, 108 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> index 6ad3fcedab9b..f3d4adb54d6e 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5375,16 +5375,17 @@ static void wlcore_op_sta_rc_update(struct ieee80211_hw *hw,
>  	wlcore_hw_sta_rc_update(wl, wlvif, sta, changed);
>  }
>  
> -static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
> -			       struct ieee80211_vif *vif,
> -			       struct ieee80211_sta *sta,
> -			       s8 *rssi_dbm)
> +static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     struct ieee80211_sta *sta,
> +				     struct station_info *sinfo)
>  {
>  	struct wl1271 *wl = hw->priv;
>  	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
> -	int ret = 0;
> +	int ret;
> +	s8 rssi_dbm;
>  
> -	wl1271_debug(DEBUG_MAC80211, "mac80211 get_rssi");
> +	wl1271_debug(DEBUG_MAC80211, "mac80211 sta_statistics");
>  
>  	mutex_lock(&wl->mutex);
>  
> @@ -5395,17 +5396,18 @@ static int wlcore_op_get_rssi(struct ieee80211_hw *hw,
>  	if (ret < 0)
>  		goto out_sleep;
>  
> -	ret = wlcore_acx_average_rssi(wl, wlvif, rssi_dbm);
> +	ret = wlcore_acx_average_rssi(wl, wlvif, &rssi_dbm);
>  	if (ret < 0)
>  		goto out_sleep;
>  
> +	sinfo->filled |= STATION_INFO_SIGNAL;
> +	sinfo->signal = rssi_dbm;
> +
>  out_sleep:
>  	wl1271_ps_elp_sleep(wl);
>  
>  out:
>  	mutex_unlock(&wl->mutex);
> -
> -	return ret;
>  }
>  
>  static bool wl1271_tx_frames_pending(struct ieee80211_hw *hw)
> @@ -5605,7 +5607,7 @@ static const struct ieee80211_ops wl1271_ops = {
>  	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
>  	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
>  	.sta_rc_update = wlcore_op_sta_rc_update,
> -	.get_rssi = wlcore_op_get_rssi,
> +	.sta_statistics = wlcore_op_sta_statistics,
>  	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
>  };
>  
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 83232aa2f077..ab7b4bde4661 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2669,6 +2669,11 @@ enum ieee80211_reconfig_type {
>   *	otherwise the rate control algorithm is notified directly.
>   *	Must be atomic.
>   *
> + * @sta_statistics: Get statistics for this station. For example with beacon
> + *	filtering, the statistics kept by mac80211 might not be accurate, so
> + *	let the driver pre-fill the statistics. Any statistics that the driver
> + *	doesn't fill will be filled by mac80211. The callback can sleep.
> + *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
>   *	bursting) for a hardware TX queue.
>   *	Returns a negative error code on failure.
> @@ -2829,9 +2834,6 @@ enum ieee80211_reconfig_type {
>   * @get_et_strings:  Ethtool API to get a set of strings to describe stats
>   *	and perhaps other supported types of ethtool data-sets.
>   *
> - * @get_rssi: Get current signal strength in dBm, the function is optional
> - *	and can sleep.
> - *
>   * @mgd_prepare_tx: Prepare for transmitting a management frame for association
>   *	before associated. In multi-channel scenarios, a virtual interface is
>   *	bound to a channel before it is associated, but as it isn't associated
> @@ -3009,6 +3011,10 @@ struct ieee80211_ops {
>  			      struct ieee80211_vif *vif,
>  			      struct ieee80211_sta *sta,
>  			      u32 changed);
> +	void (*sta_statistics)(struct ieee80211_hw *hw,
> +			       struct ieee80211_vif *vif,
> +			       struct ieee80211_sta *sta,
> +			       struct station_info *sinfo);

Could consider exposing station_info through ieee80211_sta struct.

Regards,
Arend

