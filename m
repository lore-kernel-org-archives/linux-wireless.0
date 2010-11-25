Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:38375 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab0KYJxH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 04:53:07 -0500
Subject: Re: [PATCH ] wl12xx: BA receiver support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
References: <1290616392-16532-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 11:52:56 +0200
Message-ID: <1290678776.4284.67.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 18:33 +0200, ext Shahar Levi wrote:
> Add new ampdu_action ops to support receiver BA.
> The BA initiator session management in FW independently.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---
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
> +	 * The BA initiator session management in FW independently.
> +	 * Falling break here on purpose for all TX APDU commands.
> +	 */
> +	case IEEE80211_AMPDU_TX_START:
> +	case IEEE80211_AMPDU_TX_STOP:
> +	case IEEE80211_AMPDU_TX_OPERATIONAL:
> +		ret = -EINVAL;
> +		break;
> +
> +	default:
> +		wl1271_error("Incorrect ampdu action id=%x\n", action);
> +		ret = -ENODEV;
> +	}
> +
> +	wl1271_ps_elp_sleep(wl);
> +
> +out:
> +	return ret;
> +}
> +

Seems to me that locking of the wl1271 mutex is missing here.

Also, I think it would be good to add checking for interface status
(wl->state == WL1271_STATE_OFF) here too. In normal cases this would not
be needed, but there are at least some hardware recovery scenarios where
this could be called while the firmware is off, causing all types of odd
behavior.

-Juuso

