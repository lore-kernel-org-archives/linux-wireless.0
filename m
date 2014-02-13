Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38024 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBMOrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:47:03 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: implement sta_rc_update()
References: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com>
	<1392042915-11648-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Feb 2014 16:46:46 +0200
In-Reply-To: <1392042915-11648-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 10 Feb 2014 15:35:15 +0100")
Message-ID: <8738jn9ijt.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_154707_134642_9DAE3D34)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This allows dynamic changes of bandwidth/nss/smps,
> e.g. via ht/vht operation mode change
> notification.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -228,6 +228,17 @@ struct ath10k_peer {
>  	struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
>  };
>  
> +struct ath10k_sta {
> +	struct ath10k_vif *arvif;
> +
> +	u32 changed; /* IEEE80211_RC_* */
> +	u32 bw;
> +	u32 nss;
> +	u32 smps;
> +
> +	struct work_struct update_wk;
> +};

Apparently this structure is protected with data_lock, but it would be
good to document that in the code to make it clear.

> +static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
> +				 struct ieee80211_vif *vif,
> +				 struct ieee80211_sta *sta,
> +				 u32 changed)
> +{
> +	struct ath10k *ar = hw->priv;
> +	struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
> +	u32 bw, smps;
> +
> +	spin_lock_bh(&ar->data_lock);
> +
> +	if (changed & IEEE80211_RC_BW_CHANGED) {
> +		bw = WMI_PEER_CHWIDTH_20MHZ;
> +
> +		switch (sta->bandwidth) {
> +		case IEEE80211_STA_RX_BW_20:
> +			bw = WMI_PEER_CHWIDTH_20MHZ;
> +			break;
> +		case IEEE80211_STA_RX_BW_40:
> +			bw = WMI_PEER_CHWIDTH_40MHZ;
> +			break;
> +		case IEEE80211_STA_RX_BW_80:
> +			bw = WMI_PEER_CHWIDTH_80MHZ;
> +			break;
> +		case IEEE80211_STA_RX_BW_160:
> +			ath10k_warn("unsupported STA BW: %d\n", sta->bandwidth);
> +			bw = WMI_PEER_CHWIDTH_20MHZ;
> +			break;

I think it would be also useful to print STA's address in the warning.

> +	if (changed & IEEE80211_RC_SMPS_CHANGED) {
> +		smps = WMI_PEER_SMPS_PS_NONE;
> +
> +		switch (sta->smps_mode) {
> +		case IEEE80211_SMPS_AUTOMATIC:
> +		case IEEE80211_SMPS_OFF:
> +			smps = WMI_PEER_SMPS_PS_NONE;
> +			break;
> +		case IEEE80211_SMPS_STATIC:
> +			smps = WMI_PEER_SMPS_STATIC;
> +			break;
> +		case IEEE80211_SMPS_DYNAMIC:
> +			smps = WMI_PEER_SMPS_DYNAMIC;
> +			break;
> +		case IEEE80211_SMPS_NUM_MODES:
> +			ath10k_warn("invalid smps mode: %d\n", sta->smps_mode);
> +			smps = WMI_PEER_SMPS_PS_NONE;
> +			break;

Maybe here as well?

-- 
Kalle Valo
