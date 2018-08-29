Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40231 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727190AbeH2NkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 09:40:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [RFC v2 2/2] mac80211: manage txq transmission based on airtime deficit
In-Reply-To: <1535503594-32051-2-git-send-email-rmanohar@codeaurora.org>
References: <1535503594-32051-1-git-send-email-rmanohar@codeaurora.org> <1535503594-32051-2-git-send-email-rmanohar@codeaurora.org>
Date: Wed, 29 Aug 2018 11:44:13 +0200
Message-ID: <874lfd4idu.fsf@toke.dk> (sfid-20180829_114418_573013_BC290C7C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> Once a txq is selected for transmission by next_txq(), all data from
> txq are dequeued by driver till hardware descriptors are drained.
> i.e the driver is still allowed to dequeue frames from txq even when
> its fairness deficit goes negative during transmission. This breaks
> fairness and also cause inefficient fq-codel in mac80211 when data
> queues are maintained in driver/firmware. To address this problem,
> pause txq transmission immediately upon driver airtime report.

Hmm, interesting observation about the queues moving to mac80211. Not
sure it will actually work that way; depends on how timely the ath10k
airtime report is, I guess. But would be interesting to test! :)

Just one comment on your patch, below.

> +static bool ieee80211_txq_requeued(struct ieee80211_local *local,
> +				   struct txq_info *txqi)
> +{
> +	struct sta_info *sta;
> +
> +	lockdep_assert_held(&local->active_txq_lock);
> +
> +	if (!txqi->txq.sta)
> +		return false;
> +
> +	sta = container_of(txqi->txq.sta, struct sta_info, sta);
> +
> +	if (sta->airtime.deficit[txqi->txq.ac] > 0) {
> +		clear_bit(IEEE80211_TXQ_PAUSE, &txqi->flags);
> +		return false;
> +	}
> +
> +	sta->airtime.deficit[txqi->txq.ac] +=
> +		local->airtime_quantum * sta->airtime.weight;
> +	list_move_tail(&txqi->schedule_order,
> +		       &local->active_txqs[txqi->txq.ac]);
> +
> +	return true;
> +}
> +
>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  					 bool inc_seqno)
>  {
> @@ -3655,18 +3682,8 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  	if (!txqi)
>  		goto out;
>  
> -	if (txqi->txq.sta) {
> -		struct sta_info *sta = container_of(txqi->txq.sta,
> -						struct sta_info, sta);
> -
> -		if (sta->airtime.deficit[txqi->txq.ac] < 0) {
> -			sta->airtime.deficit[txqi->txq.ac] +=
> -				local->airtime_quantum * sta->airtime.weight;
> -			list_move_tail(&txqi->schedule_order,
> -				       &local->active_txqs[txqi->txq.ac]);
> -			goto begin;
> -		}
> -	}
> +	if (ieee80211_txq_requeued(local, txqi))
> +		goto begin;
>  
>  	/* If seqnos are equal, we've seen this txqi before in this scheduling
>  	 * round, so abort.
> @@ -3687,6 +3704,39 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  }
>  EXPORT_SYMBOL(ieee80211_next_txq);
>  
> +bool ieee80211_txq_can_transmit(struct ieee80211_hw *hw,
> +				struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi, *f_txqi;
> +	bool can_tx;
> +
> +	txqi = to_txq_info(txq);
> +	/* Check whether txq is paused or not */
> +	if (test_bit(IEEE80211_TXQ_PAUSE, &txqi->flags))
> +		return false;
> +
> +	can_tx = false;
> +	spin_lock_bh(&local->active_txq_lock);
> +	f_txqi = find_txqi(local, txq->ac);
> +	if (!f_txqi)
> +		goto out;
> +
> +	/* Allow only head node to ensure fairness */
> +	if (f_txqi != txqi)
> +		goto out;
> +
> +	/* Check if txq is in negative deficit */
> +	if (!ieee80211_txq_requeued(local, txqi))
> +		can_tx = true;
> +
> +	list_del_init(&txqi->schedule_order);

Why are you removing the txq from the list here, and how do you expect
it to get added back?

-Toke
