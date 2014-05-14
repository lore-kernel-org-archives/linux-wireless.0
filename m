Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:10810 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaENS61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 14:58:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/5] ath10k: dont configure bssid for ap mode
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1399637749-13489-6-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 21:58:19 +0300
In-Reply-To: <1399637749-13489-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 9 May 2014 14:15:49 +0200")
Message-ID: <87tx8schmc.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_205830_955268_FDD0A2FF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> FW creates self-peer for AP internally.
>
> This prevents ath10k from trying to create
> explicit self-peer during hw recovery and thus
> prevents a timeout and a warning during teardown:
>
>   ath10k: removing stale peer $AP_BSSID from vdev_id 0
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2953,7 +2953,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
>  		arvif->u.ap.hidden_ssid = info->hidden_ssid;
>  	}
>  
> -	if (changed & BSS_CHANGED_BSSID) {
> +	if (changed & BSS_CHANGED_BSSID &&
> +	    vif->type != NL80211_IFTYPE_AP) {
>  		if (!is_zero_ether_addr(info->bssid)) {
>  			ath10k_dbg(ATH10K_DBG_MAC,
>  				   "mac vdev %d create peer %pM\n",

I think this deserves a comment, at least "Firmware creates self-peer in
AP mode automatically" or something like that.

-- 
Kalle Valo
