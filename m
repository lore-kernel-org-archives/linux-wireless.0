Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:32731 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbbC3NLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:11:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] ath10k: implement chanctx API
References: <1427200993-7550-1-git-send-email-michal.kazior@tieto.com>
	<1427200993-7550-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 30 Mar 2015 16:10:56 +0300
In-Reply-To: <1427200993-7550-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 24 Mar 2015 12:43:08 +0000")
Message-ID: <87mw2u4om7.fsf@kamboji.qca.qualcomm.com> (sfid-20150330_151112_970579_C7BC32E8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The chanctx API will allow ath10k to support
> multi-channel operation.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -1754,13 +1945,19 @@ static void ath10k_peer_assoc_h_crypto(struct ath10k *ar,
>  				       struct wmi_peer_assoc_complete_arg *arg)
>  {
>  	struct ieee80211_bss_conf *info = &vif->bss_conf;
> +	struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
> +	struct ath10k_chanctx *arctx;
>  	struct cfg80211_bss *bss;
>  	const u8 *rsnie = NULL;
>  	const u8 *wpaie = NULL;
>  
>  	lockdep_assert_held(&ar->conf_mutex);
>  
> -	bss = cfg80211_get_bss(ar->hw->wiphy, ar->hw->conf.chandef.chan,
> +	arctx = ath10k_mac_vif_ctx(arvif);
> +	if (WARN_ON(!arctx))
> +		return;
> +
> +	bss = cfg80211_get_bss(ar->hw->wiphy, arctx->conf.def.chan,
>  			       info->bssid, NULL, 0, 0, 0);

As I had to pull mac80211-next for TDLS there was a conflict here.
Please check the pending branch for my conflict resolution.

-- 
Kalle Valo
