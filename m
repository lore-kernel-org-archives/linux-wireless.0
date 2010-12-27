Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:17880 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0L0NeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 08:34:23 -0500
Subject: Re: [PATCH v2 12/18] wl1271: AP mode - add STA add/remove ops
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1293028057-6212-13-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-13-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Dec 2010 15:34:19 +0200
Message-ID: <1293456859.19215.3072.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> Allocate and free host link IDs (HLIDs) for each link. A per-STA
> data structure keeps the HLID of each STA.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

[...]

> +static int wl1271_op_sta_add(struct ieee80211_hw *hw,
> +			     struct ieee80211_vif *vif,
> +			     struct ieee80211_sta *sta)
> +{
> +	struct wl1271 *wl = hw->priv;
> +	int ret = 0;
> +	u8 hlid;
> +
> +	mutex_lock(&wl->mutex);
> +
> +	if (unlikely(wl->state == WL1271_STATE_OFF))
> +		goto out;
> +
> +	if (wl->bss_type != BSS_TYPE_AP_BSS)
> +		goto out;

Should we ever bump into these two conditions? Shouldn't we warn or
return errors?


> +static int wl1271_op_sta_remove(struct ieee80211_hw *hw,
> +				struct ieee80211_vif *vif,
> +				struct ieee80211_sta *sta)
> +{
> +	struct wl1271 *wl = hw->priv;
> +	struct wl1271_station *wl_sta;
> +	int ret = 0;
> +
> +	mutex_lock(&wl->mutex);
> +
> +	if (unlikely(wl->state == WL1271_STATE_OFF))
> +		goto out;
> +
> +	if (wl->bss_type != BSS_TYPE_AP_BSS)
> +		goto out;

Same here...


> +	wl1271_debug(DEBUG_MAC80211, "mac80211 remove sta %d", (int)sta->aid);
> +
> +	ret = wl1271_ps_elp_wakeup(wl, false);
> +	if (ret < 0)
> +		goto out;
> +
> +	wl_sta = (struct wl1271_station *)sta->drv_priv;
> +	ret = wl1271_cmd_remove_sta(wl, wl_sta->hlid);
> +	if (ret < 0)
> +		goto out_sleep;

Would it make sense to check if the sta is really in use (ie. it is
marked in the ap_sta_map) before trying to remove it?


-- 
Cheers,
Luca.

