Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21474 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBMO3e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:29:34 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix SMPS support
References: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 13 Feb 2014 16:29:29 +0200
In-Reply-To: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 6 Feb 2014 08:59:51 +0100")
Message-ID: <87eh379jcm.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_152937_600119_F4AF9CE4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware ignores SMPS flags in peer assoc command.
>
> For SMPS to work it is necessary to set peer
> parameter after peer assoc command so that tx
> chainmask is setup properly.
>
> This should fix packet loss and improve throughput
> with stations that have SMPS enabled upon
> association.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +static const u32 ath10k_smps_map[] = {
> +	[WLAN_HT_CAP_SM_PS_STATIC] = WMI_PEER_SMPS_STATIC,
> +	[WLAN_HT_CAP_SM_PS_DYNAMIC] = WMI_PEER_SMPS_DYNAMIC,
> +	[WLAN_HT_CAP_SM_PS_INVALID] = WMI_PEER_SMPS_PS_NONE,
> +	[WLAN_HT_CAP_SM_PS_DISABLED] = WMI_PEER_SMPS_PS_NONE,
> +};
> +
> +static int ath10k_setup_peer_smps(struct ath10k *ar, struct ath10k_vif *arvif,
> +				  const u8 *addr,
> +				  const struct ieee80211_sta_ht_cap *ht_cap)
> +{
> +	int smps;
> +
> +	if (!ht_cap->ht_supported)
> +		return 0;
> +
> +	smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
> +	smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
> +
> +	if (smps >= ARRAY_SIZE(ath10k_smps_map))
> +		return -EINVAL;
> +
> +	return ath10k_wmi_peer_set_param(ar, arvif->vdev_id, addr,
> +					 WMI_PEER_SMPS_STATE,
> +					 ath10k_smps_map[smps]);
> +}

ath10k_smps_map looks overkill (and fragile), wouldn't a switch
statement be simpler?

> @@ -1370,6 +1385,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
>  {
>  	struct ath10k *ar = hw->priv;
>  	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
> +	struct ieee80211_sta_ht_cap ht_cap;
>  	struct wmi_peer_assoc_complete_arg peer_arg;
>  	struct ieee80211_sta *ap_sta;
>  	int ret;
> @@ -1386,6 +1402,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
>  		return;
>  	}
>  
> +	ht_cap = ap_sta->ht_cap;

Why do you copy ht_cap? I can't figure out the reason.

-- 
Kalle Valo
