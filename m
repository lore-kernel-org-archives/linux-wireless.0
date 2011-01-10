Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39926 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1AJPoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 10:44:08 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0AFi8HF024070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 09:44:08 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p0AFi79Y012636
	for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 09:44:07 -0600 (CST)
Subject: Re: [PATCH v3 2/2] wl12xx: BA receiver support
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294062164-3459-3-git-send-email-shahar_levi@ti.com>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	 <1294062164-3459-3-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 17:44:16 +0200
Message-ID: <1294674256.1992.141.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-03 at 14:42 +0100, Shahar Levi wrote:
> Add new ampdu_action ops to support receiver BA.
> The BA initiator session management in FW independently.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Some comments.



> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
> index 54fd68d..f33ab50 100644
> --- a/drivers/net/wireless/wl12xx/acx.c
> +++ b/drivers/net/wireless/wl12xx/acx.c
> @@ -1359,6 +1359,42 @@ out:
>  	return ret;
>  }
>  
> +/* setup BA session receiver setting in the FW. */
> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
> +				       u16 *ssn, u8 policy)

You don't modify ssn here, so why pass it as a pointer? Use u16 directly
here instead.

Actually it's even worse.  As stated in mac80211.h, ssn can be NULL
here, so you would be accessing a NULL pointer in that case.

I see that you check "policy", which indicates whether ssn is valid or
not, but why not make it cleaner by checking if ssn is NULL and setting
it to zero before passing instead?


> +       acx->enable = policy;

Also, because of this, it would make more sense if policy was a boolean
and was called "enable" instead.


> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index c44462d..04b69ab 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -2251,6 +2251,64 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
>  	return 0;
>  }
>  
> +int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +			   enum ieee80211_ampdu_mlme_action action,
> +			   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
> +{
> +	struct wl1271 *wl = hw->priv;
> +	int ret;
> +
> +	mutex_lock(&wl->mutex);
> +
> +	if (unlikely(wl->state == WL1271_STATE_OFF)) {
> +		ret = -EAGAIN;
> +		goto out;
> +	}
> +
> +	ret = wl1271_ps_elp_wakeup(wl, false);
> +	if (ret < 0)
> +		goto out;
> +
> +	switch (action) {
> +	case IEEE80211_AMPDU_RX_START:
> +		if ((wl->ba_allowed) && (wl->ba_support)) {

I'm a bit confused.  What is ba_allowed, actually? In the previous patch
you always call wl1271_set_ba_policies() which always sets it to true.
So it seems quite useless.


> +			ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn,
> +								 true);
> +			if (!ret)
> +				wl->ba_rx_bitmap |= BIT(tid);
> +		} else
> +			ret = -EPERM;

The indentation is wrong here.  And -EPERM is definitely not the right
return code for this.  It should probably -ENOTSUPP or something like
that.

> +	/*
> +	 * The BA initiator session management in FW independently.
> +	 * Falling break here on purpose for all TX APDU commands.
> +	 */
> +	case IEEE80211_AMPDU_TX_START:
> +	case IEEE80211_AMPDU_TX_STOP:
> +	case IEEE80211_AMPDU_TX_OPERATIONAL:
> +		ret = -EINVAL;
> +		break;

-EINVAL? Actually, should mac80211 even call us with these actions? I
don't remember now, did you implement the way to prevent mac80211 from
trying to to AMPDU_TX by itself?


> +
> +	default:
> +		wl1271_error("Incorrect ampdu action id=%x\n", action);
> +		ret = -ENODEV;

-ENODEV? All these error codes look quite random to me.  Can you explain
your choices?
 

-- 
Cheers,
Luca.

