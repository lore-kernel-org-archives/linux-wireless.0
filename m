Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36911 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3LTKVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 05:21:17 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: implement sta_rc_update()
References: <87li09ga42.fsf@kamboji.qca.qualcomm.com>
	<1387361479-21289-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 20 Dec 2013 12:21:11 +0200
In-Reply-To: <1387361479-21289-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Dec 2013 11:11:19 +0100")
Message-ID: <8761qj3js8.fsf@kamboji.qca.qualcomm.com> (sfid-20131220_112127_418698_5E0F54C1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This should fix possible connectivity issues upon
> changes of channel width, number of streams or
> SMPS on connected stations.
>
> An example trigger would be an action frame with
> operation mode change notification.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
> +				 struct ieee80211_vif *vif,
> +				 struct ieee80211_sta *sta,
> +				 u32 changed)
> +{
> +	struct ath10k *ar = hw->priv;
> +	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
> +	u32 chwidth, smps;
> +	int ret;
> +

[...]

> +		ret = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
> +						WMI_PEER_CHAN_WIDTH, chwidth);

Johannes pointed out (danke!) that sta_rc_update() must be atomic, but
all these WMI calls can sleep.

-- 
Kalle Valo
