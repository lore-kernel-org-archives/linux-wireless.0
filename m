Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2ACOYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 09:24:52 -0500
Subject: Re: [PATCH 2/2] mac80211: add support for mcs masks
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1324304099-18327-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1324304099-18327-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jan 2012 15:24:50 +0100
Message-ID: <1325600690.3316.12.camel@jlt3.sipsolutions.net> (sfid-20120103_152455_830224_3123214D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-19 at 15:14 +0100, Simon Wunderlich wrote:

> +++ b/net/mac80211/iface.c
> @@ -1180,6 +1180,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>  		sband = local->hw.wiphy->bands[i];
>  		sdata->rc_rateidx_mask[i] =
>  			sband ? (1 << sband->n_bitrates) - 1 : 0;
> +		memset(sdata->rc_rateidx_mcs_mask[i], sband ? 0xff : 0,
> +		       sizeof(sdata->rc_rateidx_mcs_mask[i]));
> +
>  	}

Similar comment as before; there's also a spurious blank line here.

> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -267,10 +267,10 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
>  
>  	if (!sta || !priv_sta || rc_no_data_or_no_ack_use_min(txrc)) {
>  		if ((sband->band != IEEE80211_BAND_2GHZ) ||
> -		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
> +		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE)) {
>  			info->control.rates[0].idx =
>  				rate_lowest_index(txrc->sband, sta);
> -		else
> +		} else
>  			info->control.rates[0].idx =
>  				rate_lowest_non_cck_index(txrc->sband, sta);
>  		info->control.rates[0].count =

Hmm? I see no change here?

> @@ -293,25 +293,128 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
>  }
>  EXPORT_SYMBOL(rate_control_send_low);
>  
> -static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
> -				int n_bitrates, u32 mask)
> +static bool rate_idx_match_legacy_mask(struct ieee80211_tx_rate *rate,
> +				       int n_bitrates, u32 mask)
>  {
>  	int j;
>  
> -	/* See whether the selected rate or anything below it is allowed. */
> +	/* See whether the selected rate or anything below
> +	 * it is allowed. */

why change the comment format (and do it wrong while at it)?

>  		}
>  	}
> -
>  	/* Try to find a higher rate that would be allowed */

?

> @@ -358,10 +462,14 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
>  	 * the common case.
>  	 */
>  	mask = sdata->rc_rateidx_mask[info->band];
> +	memcpy(mcs_mask, sdata->rc_rateidx_mcs_mask[info->band],
> +	       sizeof(mcs_mask));

Do we really have to do this? Might not a pointer be better?

>  	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
>  		if (sta) {
>  			/* Filter out rates that the STA does not support */
>  			mask &= sta->sta.supp_rates[info->band];
> +			for (i = 0; i < sizeof(mcs_mask); i++)
> +				mcs_mask[i] &= sta->sta.ht_cap.mcs.rx_mask[i];

Oh, so it's filtered by station ... hm ok I guess unless we tie
lifetimes together we have to do this.

Maybe we could update all stations in the slow-path (changes in the HT
mask) and then just use the already masked version in the sta entry in
the fastpath here?

johannes

