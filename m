Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43883 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbeITVyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 17:54:37 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Anilkumar Kolli <akolli@codeaurora.org>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: Re: [RFCv3 1/2] mac80211: implement ieee80211_tx_rate_update to update rate
In-Reply-To: <1537445116-10780-2-git-send-email-akolli@codeaurora.org>
References: <1537445116-10780-1-git-send-email-akolli@codeaurora.org> <1537445116-10780-2-git-send-email-akolli@codeaurora.org>
Date: Thu, 20 Sep 2018 18:10:24 +0200
Message-ID: <87va706tfz.fsf@toke.dk> (sfid-20180920_181031_103696_9B4F0B06)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anilkumar Kolli <akolli@codeaurora.org> writes:

> Current mac80211 has provision to update tx status through
> ieee80211_tx_status() and ieee80211_tx_status_ext(). But
> drivers like ath10k updates the tx status from the skb except
> txrate, txrate will be updated from a different path, peer stats.
>
> Using ieee80211_tx_status_ext() in two different paths
>   - (one for the stats, one for the tx rate) will duplicate the stats.
>
> To avoid this stats duplication, ieee80211_tx_rate_update() is implemented.
>
> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> ---
> V3:
>   - Added new API in mac80211 to update tx rate(Johannes)
>
>  include/net/mac80211.h |   14 ++++++++++++++
>  net/mac80211/status.c  |   24 ++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 8c26d2d36cbe..042186a21770 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -4331,6 +4331,20 @@ void ieee80211_sta_set_expected_throughput(struct ieee80211_sta *pubsta,
>  					   u32 thr);
>  
>  /**
> + * ieee80211_tx_rate_update - transmit rate update callback
> + *
> + * This function can be used in drivers that does not have provision
> + * in updating the tx rate in data path.
> + *
> + * @hw: the hardware the frame was transmitted by
> + * @status: tx status information
> + * @pubsta: the station to update the tx rate for.
> + */
> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
> +			      struct ieee80211_sta *pubsta,
> +			      struct ieee80211_tx_info *info);
> +
> +/**
>   * ieee80211_tx_status - transmit status callback
>   *
>   * Call this function for all transmitted frames after they have been
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 9a6d7208bf4f..232297ddaa02 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -988,6 +988,30 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
>  }
>  EXPORT_SYMBOL(ieee80211_tx_status_ext);
>  
> +void ieee80211_tx_rate_update(struct ieee80211_hw *hw,
> +			      struct ieee80211_sta *pubsta,
> +			      struct ieee80211_tx_info *info)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct ieee80211_supported_band *sband;
> +	struct sta_info *sta;
> +	struct ieee80211_tx_status status;
> +
> +	sband = hw->wiphy->bands[info->band];
> +
> +	if (pubsta) {

The function does nothing if pubsta is NULL; wouldn't it make more sense
to just mandate that it isn't NULL rather than have this check?

-Toke
