Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:48218 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab0KZJ53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:57:29 -0500
Subject: Re: [PATCH ] wl12xx: BA receiver support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
References: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 11:56:57 +0200
Message-ID: <1290765417.4284.101.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 18:33 +0200, ext Shahar Levi wrote:
>  
> +int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +			   enum ieee80211_ampdu_mlme_action action,
> +			   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
> +{
> +	struct wl1271 *wl = hw->priv;
> +	int ret;
> +
> +	ret = wl1271_ps_elp_wakeup(wl, false);
> +	if (ret < 0)
> +		goto out;
> +
> +	switch (action) {
> +	case IEEE80211_AMPDU_RX_START:
> +		if (wl->ba_allowed) {
> +			ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn,
> +								 true);
> +			if (!ret)
> +				wl->ba_rx_bitmap |= (u8)(BIT(0) << tid);
> +		} else
> +			ret = -EPERM;
> +		break;
> +
> +	case IEEE80211_AMPDU_RX_STOP:
> +		ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn, false);
> +		if (!ret)
> +			wl->ba_rx_bitmap &= ~(u8)(BIT(0) << tid);
> +		break;
> +
> +	/*

These "BIT(0) << tid" thingies look weird. Why not BIT(tid) ?

-Juuso

