Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 06:33:00 -0400
Message-ID: <1366021975.8361.10.camel@jlt4.sipsolutions.net> (sfid-20130415_123306_268186_A1ACBB12)
Subject: Re: vht off-by-one nss
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 15 Apr 2013 12:32:55 +0200
In-Reply-To: <20130415100909.GA29924@magnum.frso.rivierawaves.com> (sfid-20130415_121332_868132_5F297E84)
References: <20130415100909.GA29924@magnum.frso.rivierawaves.com>
	 (sfid-20130415_121332_868132_5F297E84)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-15 at 12:09 +0200, Karl Beldan wrote:
> It seems to me we have to perform one of the following, otherwise one
> driver may set negative rate indexes and iw et.al will report VHT NSSes
> starting at 0.

Hmm, yeah, this does seem inconsistent.

> {
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 0dde213..2317ca9 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -601,8 +601,8 @@ static inline void ieee80211_rate_set_vht(struct ieee80211_tx_rate *rate,
>  					  u8 mcs, u8 nss)
>  {
>  	WARN_ON(mcs & ~0xF);
> -	WARN_ON(nss & ~0x7);
> -	rate->idx = (nss << 4) | mcs;
> +	WARN_ON((nss - 1) & ~0x7);
> +	rate->idx = ((nss - 1) << 4) | mcs;
>  }
>  
>  static inline u8
> @@ -614,7 +614,7 @@ ieee80211_rate_get_vht_mcs(const struct ieee80211_tx_rate *rate)
>  static inline u8
>  ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
>  {
> -	return rate->idx >> 4;
> +	return (rate->idx >> 4) + 1;
>  }
>  
>  /**
> }

I think this is nicer? But it should probably have some comments.

> diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
> index 56df249..9631391 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
> @@ -545,7 +545,7 @@ static void iwl_mvm_hwrate_to_tx_control(u32 rate_n_flags,
>  		ieee80211_rate_set_vht(
>  			r, rate_n_flags & RATE_VHT_MCS_RATE_CODE_MSK,
>  			((rate_n_flags & RATE_VHT_MCS_NSS_MSK) >>
> -						RATE_VHT_MCS_NSS_POS) + 1);
> +						RATE_VHT_MCS_NSS_POS));
>  		r->flags |= IEEE80211_TX_RC_VHT_MCS;
>  	} else {
>  		r->idx = iwl_mvm_legacy_rate_to_mac80211_idx(rate_n_flags,
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index fdd95bd..358d93c 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -389,7 +389,7 @@ void sta_set_rate_info_tx(struct sta_info *sta,
>  	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
>  		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
>  		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
> -		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
> +		rinfo->nss = ieee80211_rate_get_vht_nss(rate) + 1;
>  	} else {
>  		struct ieee80211_supported_band *sband;
>  		sband = sta->local->hw.wiphy->bands[
> }


Wouldn't this one also require an update for VHT radiotap in
net/mac80211/rx.c around line 320 (RX_FLAG_VHT)?

johannes

