Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51755 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbeHUPoc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 11:44:32 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [RFC 3/3] mac80211: add ieee80211_reorder_txq
In-Reply-To: <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org>
References: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org> <1534202011-13101-4-git-send-email-rmanohar@codeaurora.org>
Date: Tue, 21 Aug 2018 14:24:33 +0200
Message-ID: <87a7pfaovy.fsf@toke.dk> (sfid-20180821_142442_191223_58F9162D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> This allows the driver to refill airtime fairness deficit
> where the driver will not access txqs by ieee80211_next_txq.
> In tx push mode data path, high priority txqs will be scheduled
> for data transmission by ieee80211_next_txq and driver will not
> prioritize txqs whereas in push-pull mode, the drivers can
> prioritize txqs and access them directly. In such mode, airtime
> deficit can not filled by ieee80211_next_txq.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> ---
>  include/net/mac80211.h | 15 +++++++++++++
>  net/mac80211/tx.c      | 59 +++++++++++++++++++++++++++++++++++---------------
>  2 files changed, 57 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index cc16847bd52d..a2f0b6800100 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -6033,6 +6033,21 @@ bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac);
>  
>  /**
> + * ieee80211_reorder_txq - change txq position in scheduling loop
> + *
> + * This function is used to reorder txq's position in scheduling loop.
> + * The txq fairness deficit will be refilled. The drivers calling this
> + * function should ensure the txq won't be accessed by ieee80211_next_txq
> + * in the same path.
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from station or virtual interface
> + *
> + */
> +void ieee80211_reorder_txq(struct ieee80211_hw *hw,
> +			   struct ieee80211_txq *txq);
> +
> +/**
>   * ieee80211_txq_get_depth - get pending frame/byte count of given txq
>   *
>   * The values are not guaranteed to be coherent with regard to each other, i.e.
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 0af35c08e0d9..b7b2f93152f8 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -3634,10 +3634,38 @@ static inline struct txq_info *find_txqi(struct ieee80211_local *local, s8 ac)
>  	return txqi;
>  }
>  
> +static bool ieee80211_txq_refill_deficit(struct ieee80211_local *local,
> +					 struct txq_info *txqi)
> +{
> +	struct fq *fq = &local->fq;
> +	struct sta_info *sta;
> +
> +	lockdep_assert_held(&local->active_txq_lock);
> +
> +	if (!txqi->txq.sta)
> +		return false;
> +
> +	sta = container_of(txqi->txq.sta, struct sta_info, sta);
> +
> +	if (sta->airtime.deficit[txqi->txq.ac] > 0)
> +		return false;
> +
> +	sta->airtime.deficit[txqi->txq.ac] +=
> +		IEEE80211_AIRTIME_QUANTUM * sta->airtime.weight;
> +	list_move_tail(&txqi->schedule_order,
> +		       &local->active_txqs[txqi->txq.ac]);

This needs to check that the txq is currently at the head of
local->active_txqs[txqi->txq.ac]; otherwise fairness enforcement doesn't
work. And with this check I'm not sure the reorder function is terribly
useful for what you want to use it for?

-Toke
