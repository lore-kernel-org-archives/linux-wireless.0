Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:46419 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0JLOSV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:18:21 -0400
Subject: Re: [PATCH v3 03/03] wl1271: 11n Support, functionality and
 configuration ability
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286812038-19013-4-git-send-email-shahar_levi@ti.com>
References: <1286812038-19013-1-git-send-email-shahar_levi@ti.com>
	 <1286812038-19013-4-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Oct 2010 17:18:15 +0300
Message-ID: <1286893095.12528.75.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 17:47 +0200, ext Shahar Levi wrote:
> Add 11n ability in scan, connection and using MCS rates.
> The configuration is temporary due to the code incomplete and
> still in testing process. That plans to be remove in the future.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

...

> @@ -1709,6 +1721,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  {
>  	enum wl1271_cmd_ps_mode mode;
>  	struct wl1271 *wl = hw->priv;
> +	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
>  	bool do_join = false;
>  	bool set_assoc = false;
>  	int ret;
> @@ -1927,6 +1940,45 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>  		}
>  	}
>  
> +	if (sta) {
> +		/*
> +		 * Takes care of: New association with HT enable,
> +		 *                HT information change in beacon.
> +		 */
> +		if ((changed & BSS_CHANGED_HT) &&
> +		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {

You could move the if (sta) into the same if, as I proposed before:

	if (sta && changed & BSS_CHANGED_HT) &&
	    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {



> +			ret = wl1271_acx_set_ht_capabilities(wl,
> +					&sta->ht_cap,
> +					true);

...then you don't need to break this line so much...


> +			if (ret < 0) {
> +				wl1271_warning("Set ht cap true failed %d",
> +						ret);

...nor this...

> +				goto out_sleep;
> +			}
> +
> +			ret = wl1271_acx_set_ht_information(wl,
> +					bss_conf->ht_operation_mode);
> +			if (ret < 0) {
> +				wl1271_warning("Set ht information failed %d",
> +						ret);

...nor this...


> +		/*
> +		 * Takes care of: New association without HT,
> +		 *                Disassociate.
> +		 */

Disassociation.


> +		else if (changed & BSS_CHANGED_ASSOC) {

Same in this block about the if (sta) thingy:

	if (sta && changed & BSS_CHANGED_ASSOC) {


> @@ -2107,14 +2158,14 @@ static struct ieee80211_channel wl1271_channels[] = {
>  /* mapping to indexes for wl1271_rates */
>  static const u8 wl1271_rate_to_idx_2ghz[] = {
>  	/* MCS rates are used only with 11n */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS7 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS6 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS5 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS4 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS3 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS2 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS1 */
> -	CONF_HW_RXTX_RATE_UNSUPPORTED, /* CONF_HW_RXTX_RATE_MCS0 */
> +	7,                            /* CONF_HW_RXTX_RATE_MCS7 */
> +	6,                            /* CONF_HW_RXTX_RATE_MCS6 */
> +	5,                            /* CONF_HW_RXTX_RATE_MCS5 */
> +	4,                            /* CONF_HW_RXTX_RATE_MCS4 */
> +	3,                            /* CONF_HW_RXTX_RATE_MCS3 */
> +	2,                            /* CONF_HW_RXTX_RATE_MCS2 */
> +	1,                            /* CONF_HW_RXTX_RATE_MCS1 */
> +	0,                            /* CONF_HW_RXTX_RATE_MCS0 */
>  
>  	11,                            /* CONF_HW_RXTX_RATE_54   */
>  	10,                            /* CONF_HW_RXTX_RATE_48   */
> @@ -2137,6 +2188,7 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>  /* 11n STA capabilities */
>  #define HW_RX_HIGHEST_RATE	65
>  
> +#ifdef CONFIG_WL1271_HT
>  #define WL1271_HT_CAP { \
>  	.cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20, \
>  	.ht_supported = true, \
> @@ -2148,6 +2200,11 @@ static const u8 wl1271_rate_to_idx_2ghz[] = {
>  		.tx_params = IEEE80211_HT_MCS_TX_DEFINED, \
>  		}, \
>  }
> +#else
> +#define WL1271_HT_CAP { \
> +	.ht_supported = false, \
> +}
> +#endif

Would be nicer to have the ifdefs already when you create this macro
(ie. patch 01/03), but you don't have the CONFIG flag at that point
yet... but well, never mind.  No need to change it.


-- 
Cheers,
Luca.

