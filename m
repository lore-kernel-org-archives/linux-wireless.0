Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:49600 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbeIJM5X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 08:57:23 -0400
Message-ID: <1536566666.3224.24.camel@sipsolutions.net> (sfid-20180910_100440_040093_60E6D1C8)
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Date: Mon, 10 Sep 2018 10:04:26 +0200
In-Reply-To: <153635897010.14170.2992498632345986102.stgit@alrua-x1> (sfid-20180908_002306_367985_5D6D7759)
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1>
         <153635897010.14170.2992498632345986102.stgit@alrua-x1>
         (sfid-20180908_002306_367985_5D6D7759)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-09-08 at 00:22 +0200, Toke Høiland-Jørgensen wrote:

> +/**
> + * ieee80211_next_txq - get next tx queue to pull packets from
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @ac: AC number to return packets from.
> + * @first: Setting this to true signifies the start of a new scheduling round.
> + *         Each TXQ will only be returned at most exactly once in each round.
> + *
> + * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
> + * is returned, it will have been removed from the scheduler queue and needs to
> + * be re-scheduled with ieee80211_schedule_txq() to continue to be active. Note
> + * that the driver is responsible for locking to ensuring two different threads
> + * don't schedule the same AC simultaneously.

"Note that [...] to ensure [...]" would seem better to me?

> + */
> +struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
> +					 bool first);

Why should "ac" be signed? Is there some (undocumented) behaviour that
allows for passing -1 for "don't care" or "pick highest with frames"?

You said "optionally" in the commit message, but I don't think that's
true, since you just use ac to index the array in the code.

> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			    struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +	bool ret = false;
> +
> +	spin_lock_bh(&local->active_txq_lock);
> +
> +	if (list_empty(&txqi->schedule_order)) {

Is there a case where it's allowed to call this while *not* empty? At
least for the drivers it seems not, so perhaps when called from the
driver it should WARN() here or so?

I'm just a bit worried that drivers will get this a bit wrong, and we'll
never know, but things won't work properly in some weird way.

> +		list_add_tail(&txqi->schedule_order,
> +			      &local->active_txqs[txq->ac]);
> +		ret = true;
> +	}
> +
> +	spin_unlock_bh(&local->active_txq_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(ieee80211_schedule_txq);

I'd remove the return value - the driver has no need to know that it
raced with potential rescheduling in mac80211 due to a new packet, and
you don't use the return value in mac80211 either.

It also seems to me that you forgot to say when it should be
rescheduled? As is, following the documentation would sort of makes it
seem you should take the queue and put it back at the end (without any
conditions), and that could lead to "scheduling loops" since empty
queues would always be put back when they shouldn't be?

Also, come to think of it, but I guess the next patch(es) solve(s) that
- if mac80211 adds a packet while you have this queue scheduled then you
would take that packet even if it's questionable it belongs to this
round?

>From a driver perspective, I think I'd prefer an API called e.g.

	ieee80211_return_txq()

that does the check internally if we need to schedule the queue (i.e.
there are packets on it). I was going to say we could even annotate with
sparse, but no - we can't because ieee80211_next_txq() may return NULL.
Still, it's easier to ensure that all cleanup paths call
ieee80211_return_txq() if it's not conditional, IMHO.


> +struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
> +					 bool first)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = NULL;
> +
> +	spin_lock_bh(&local->active_txq_lock);
> +
> +	if (first)
> +		local->schedule_round[ac]++;

(here - clearly ac must be 0 <= ac < IEEE80211_NUM_ACS)

> +	if (list_empty(&local->active_txqs[ac]))
> +		goto out;
> +
> +	txqi = list_first_entry(&local->active_txqs[ac],
> +				struct txq_info,
> +				schedule_order);
> +
> +	if (txqi->schedule_round == local->schedule_round[ac])
> +		txqi = NULL;

that assigment seems unnecessary? txqi defaults to NULL.

> +	else
> +		list_del_init(&txqi->schedule_order);
> + out:
> +	spin_unlock_bh(&local->active_txq_lock);
> +
> +	if (!txqi)
> +		return NULL;
> +
> +	txqi->schedule_round = local->schedule_round[ac];
> +	return &txqi->txq;
> +}
> +EXPORT_SYMBOL(ieee80211_next_txq);

johannes
