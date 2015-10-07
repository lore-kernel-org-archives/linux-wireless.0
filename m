Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44693 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbbJGQxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 12:53:00 -0400
Message-ID: <56154DE5.4040300@codeaurora.org> (sfid-20151007_185305_188590_D112DA9C)
Date: Wed, 07 Oct 2015 09:52:53 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: c_traja@qti.qualcomm.com, johannes@sipsolutions.net,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Revert "mac80211: remove exposing 'mfp' to drivers"
References: <1444194604-12637-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1444194604-12637-1-git-send-email-c_traja@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 10/06/2015 10:10 PM, c_traja@qti.qualcomm.com wrote:
> From: Tamizh chelvam <c_traja@qti.qualcomm.com>
>
> This reverts commit 5c48f1201744233d4f235c7dd916d5196ed20716.
>
> Some device drivers (ath10k) offload part of aggregation including
> AddBA/DelBA
> negotiations to firmware. In such scenario, the PMF
Is it typo of MFP or abbreviation of something else?
>   configuration of
> the station needs to be provided to driver to enable encryption of
> AddBA/DelBA action frames.
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
> ---
> Notes:
> 	> ath10k change using this mfp configuration will follow.
>
>   include/net/mac80211.h |    2 ++
>   net/mac80211/cfg.c     |    1 +
>   net/mac80211/mlme.c    |    6 +++++-
>   3 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4ec6fed..1bb2a2b 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1683,6 +1683,7 @@ struct ieee80211_sta_rates {
>    * @tdls: indicates whether the STA is a TDLS peer
>    * @tdls_initiator: indicates the STA is an initiator of the TDLS link.
> Only
>    *	valid if the STA is a TDLS peer in the first place.
> + * @mfp: indicates whether the STA uses management frame protection or
> not.
>    * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
>    */
>   struct ieee80211_sta {
> @@ -1700,6 +1701,7 @@ struct ieee80211_sta {
>   	struct ieee80211_sta_rates __rcu *rates;
>   	bool tdls;
>   	bool tdls_initiator;
> +	bool mfp;
>   
>   	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
>   
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 68e551e..63d03da 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1138,6 +1138,7 @@ static int sta_apply_parameters(struct
> ieee80211_local *local,
>   	}
>   
>   	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
> +		sta->sta.mfp = !!(set & BIT(NL80211_STA_FLAG_MFP));
>   		if (set & BIT(NL80211_STA_FLAG_MFP))
>   			set_sta_flag(sta, WLAN_STA_MFP);
>   		else
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 56ef9a8..9c450ff 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3044,8 +3044,12 @@ static bool ieee80211_assoc_success(struct
> ieee80211_sub_if_data *sdata,
>   
>   	rate_control_rate_init(sta);
>   
> -	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED)
> +	if (ifmgd->flags & IEEE80211_STA_MFP_ENABLED) {
>   		set_sta_flag(sta, WLAN_STA_MFP);
> +		sta->sta.mfp = true;
> +	} else {
> +		sta->sta.mfp = false;
> +	}
>   
>   	sta->sta.wme = elems.wmm_param && local->hw.queues >=
> IEEE80211_NUM_ACS;
>   

