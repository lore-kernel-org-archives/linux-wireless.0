Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33760 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932142AbdJJPxr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 11:53:47 -0400
Message-ID: <1507650823.26041.70.camel@sipsolutions.net> (sfid-20171010_175419_415790_D5268F23)
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 10 Oct 2017 17:53:43 +0200
In-Reply-To: <20171010140208.1515-1-toke@toke.dk> (sfid-20171010_160341_258014_BDC1BDA8)
References: <20171010140208.1515-1-toke@toke.dk>
         (sfid-20171010_160341_258014_BDC1BDA8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 16:02 +0200, Toke Høiland-Jørgensen wrote:

> +++ b/net/mac80211/agg-tx.c
> @@ -226,9 +226,11 @@ ieee80211_agg_start_txq(struct sta_info *sta,
> int tid, bool enable)
>  		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
>  
>  	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
> +	ieee80211_schedule_txq(&sta->sdata->local->hw, txq);
> +
>  	local_bh_disable();
>  	rcu_read_lock();
> -	drv_wake_tx_queue(sta->sdata->local, txqi);
> +	drv_wake_tx_queue(sta->sdata->local);
>  	rcu_read_unlock();
>  	local_bh_enable();

It seems like there could be some sort of TX batching here - maybe only
call the driver if the queue was actually scheduled?

Return true/false from ieee80211_schedule_txq() depending on whether it
was added or not, and then call the driver only if it was added just
now? That way, we can save a bunch of driver calls, batching the TX.
 
> @@ -1121,6 +1122,9 @@ struct ieee80211_local {
>  	struct codel_vars *cvars;
>  	struct codel_params cparams;
>  
> +	struct list_head active_txqs;
> +	spinlock_t active_txq_lock;

Is there much point in having a separate lock? We probably need the fq
lock in most places related to this anyway?

> +++ b/net/mac80211/sta_info.c
> @@ -1250,8 +1250,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct
> sta_info *sta)
>  			if (!txq_has_queue(sta->sta.txq[i]))
>  				continue;
>  
> -			drv_wake_tx_queue(local, to_txq_info(sta-
> >sta.txq[i]));
> +			ieee80211_schedule_txq(&local->hw, sta-
> >sta.txq[i]);
>  		}
> +		drv_wake_tx_queue(local);

Again, calling the driver could be conditional on having done any
interesting work.

> @@ -1524,7 +1526,8 @@ static bool ieee80211_queue_skb(struct
> ieee80211_local *local,
>  	ieee80211_txq_enqueue(local, txqi, skb);
>  	spin_unlock_bh(&fq->lock);
>  
> -	drv_wake_tx_queue(local, txqi);
> +	ieee80211_schedule_txq(&local->hw, &txqi->txq);
> +	drv_wake_tx_queue(local);

ditto

> +void ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			     struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +
> +	spin_lock_bh(&local->active_txq_lock);
> +
> +	if (!list_empty(&txqi->schedule_order))
> +		list_add_tail(&txqi->schedule_order, &local-
> >active_txqs);

What's with the !list_empty()? Seems inverted to me? You need to add it
if it's empty?

Also maybe you should only do that if the TXQ isn't *empty*, so the
driver could call this unconditionally?

> +struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = NULL;
> +
> +	spin_lock_bh(&local->active_txq_lock);
> +
> +	if (list_empty(&local->active_txqs))
> +		goto out;
> +
> +	txqi = list_first_entry(&local->active_txqs, struct
> txq_info, schedule_order);
> +	list_del_init(&txqi->schedule_order);
> +
> +out:
> +	spin_unlock_bh(&local->active_txq_lock);
> +
> +	return &txqi->txq;

You forgot
	if (!txqi)
		return NULL;

johannes
