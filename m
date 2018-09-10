Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49730 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbeIJNLR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 09:11:17 -0400
Message-ID: <1536567496.3224.36.camel@sipsolutions.net> (sfid-20180910_101830_548530_67D03D8A)
Subject: Re: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and
 scheduling to TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 10:18:16 +0200
In-Reply-To: <153635897061.14170.17999956909203163571.stgit@alrua-x1> (sfid-20180908_002305_131598_05A63919)
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897061.14170.17999956909203163571.stgit@alrua-x1>
         (sfid-20180908_002305_131598_05A63919)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:
> 
> +/**
> + * ieee80211_airtime_may_transmit - check whether TXQ is allowed to transmit
> + *
> + * This function is used to check whether given txq is allowed to transmit by
> + * the airtime scheduler, and can be used by drivers to access the airtime
> + * fairness accounting without going using the scheduling order enfored by
> + * next_txq().
> + *
> + * Returns %true if the airtime scheduler does not think the TXQ should be
> + * throttled. This function can also have the side effect of rotating the TXQ in
> + * the scheduler rotation, which will eventually bring the deficit to positive
> + * and allow the station to transmit again.
> + *
> + * If this function returns %true, the TXQ will have been removed from the
> + * scheduling. It is the driver's responsibility to add it back (by calling
> + * ieee80211_schedule_txq()) if needed.
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from station or virtual interface
> + *
> + */

Spurious newline there at the end.

(As an aside from the review, perhaps this would be what we could use in
iwlwifi, but I'll need to think about _when_ to add it back to the
scheduling later).

> + * @NL80211_EXT_FEATURE_AIRTIME_FAIRNESS: Driver supports airtime fairness
> + *      scheduling.
> + *
>   * @NUM_NL80211_EXT_FEATURES: number of extended features.
>   * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
>   */
> @@ -5269,6 +5272,7 @@ enum nl80211_ext_feature_index {
>  	NL80211_EXT_FEATURE_SCAN_RANDOM_SN,
>  	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
>  	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
> +	NL80211_EXT_FEATURE_AIRTIME_FAIRNESS,

Why is this necessary in this patch?

I think that this should probably come with more documentation too,
particularly what's expected of the driver here.

I'd prefer you reorder patches 2 and 3, and define everything in
cfg80211 first. That also makes it easier to reason about what happens
when the feature is not supported (since it will not be supported
anywhere). Then this can be included in the cfg80211 patch instead,
which places it better, and the mac80211 bits from the cfg80211 patch 
can be included here, which also places those better.

> -			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
> -			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
> -			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");
> +			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
> +			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
> +			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" : "");

consider BIT() instead as a cleanup? :)

(or maybe this is just a leftover from merging some other patches?)

> +static bool ieee80211_txq_check_deficit(struct ieee80211_local *local,
> +					struct txq_info *txqi)

Maybe this should be called "has_deficit" or so - the polarity isn't
immediately clear to me.

> +{
> +	struct sta_info *sta;
> +
> +	lockdep_assert_held(&local->active_txq_lock);
> +
> +	if (!txqi->txq.sta)
> +		return true;
> +
> +	sta = container_of(txqi->txq.sta, struct sta_info, sta);
> +
> +	if (sta->airtime.deficit[txqi->txq.ac] > 0)
> +		return true;
> +
> +	if (txqi == list_first_entry_or_null(&local->active_txqs[txqi->txq.ac],

nit: I don't think you need _or_null here, since list_first_entry() will
"return" the head itself if the list is empty, which cannot match txqi?
Doesn't matter that much though, and if you think this is easier to
understand then that's fine.

> +					     struct txq_info,
> +					     schedule_order)) {
> +		sta->airtime.deficit[txqi->txq.ac] += sta->airtime.weight;
> +		list_move_tail(&txqi->schedule_order,
> +			       &local->active_txqs[txqi->txq.ac]);
> +	}
> +
> +	return false;
> +}
> +
>  struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  					 bool first)
>  {
> @@ -3659,6 +3701,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  	if (first)
>  		local->schedule_round[ac]++;
>  
> + begin:
>  	if (list_empty(&local->active_txqs[ac]))
>  		goto out;
>  
> @@ -3666,6 +3709,9 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  				struct txq_info,
>  				schedule_order);
>  
> +	if (!ieee80211_txq_check_deficit(local, txqi))
> +		goto begin;

This code isn't so badly indented - you could use a do { } while () loop
instead?

>  	if (txqi->schedule_round == local->schedule_round[ac])
>  		txqi = NULL;

and maybe you want this check first, it's much cheaper?

do {
...
} while (txqi->schedule_round != local->schedule_round[ac] &&
         !has_deficit())

or so?

That is to say, I'm not sure why you'd want to abort if you find a queue
that has no deficit but is part of the next round? Or is that the abort
condition for having gone around the whole list once? Hmm. But
check_deficit() also moves them to the end, so you don't really get that
anyway?



> @@ -3681,6 +3727,25 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
>  }
>  EXPORT_SYMBOL(ieee80211_next_txq);
>  
> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
> +				struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +	bool may_tx = false;
> +
> +	spin_lock_bh(&local->active_txq_lock);
> +
> +	if (ieee80211_txq_check_deficit(local, txqi)) {
> +		may_tx = true;
> +		list_del_init(&txqi->schedule_order);

Manipulating the list twice like this here seems slightly odd ...
perhaps move the list manipulation out of txq_check_deficit() entirely?
Clearly it's logically fine, but seems harder than necessary to
understand.

Also, if the check_deficit() function just returns a value, the renaming
I suggested is easier to accept :)

johannes
