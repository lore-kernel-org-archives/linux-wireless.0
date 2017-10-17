Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58348 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932780AbdJQGjo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 02:39:44 -0400
Message-ID: <1508222380.10607.55.camel@sipsolutions.net> (sfid-20171017_083947_988697_57C3BBF5)
Subject: Re: [PATCH 1/2] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Tue, 17 Oct 2017 08:39:40 +0200
In-Reply-To: <20171016160902.8970-1-toke@toke.dk> (sfid-20171016_180931_557642_CDEF1515)
References: <20171016160902.8970-1-toke@toke.dk>
         (sfid-20171016_180931_557642_CDEF1515)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>  	/* protects shared structure data */
>  	spinlock_t data_lock;
> -	/* protects: ar->txqs, artxq->list */
> -	spinlock_t txqs_lock;
>  
> -	struct list_head txqs;

I don't see you removing the artxq->list member, but surely it can't be
used any more now, without a list?

[snip] that's about all I can comment on ath*k :)

> +/**
> + * ieee80211_schedule_txq - add txq to scheduling loop
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + * @txq: pointer obtained from station or virtual interface

or more likely next_txq()? :)

> + * Returns true if the txq was actually added to the scheduling,
> + * false otherwise.

Perhaps use %true/%false.

>  	if (sta->sta.txq[0]) {
> +		bool wake = false;

please add a blank line after this new line

>  		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
>  			if (!txq_has_queue(sta->sta.txq[i]))
>  				continue;
>  
> -			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
> +			wake = wake || ieee80211_schedule_txq(&local->hw, sta->sta.txq[i]);
>  		}
> +		if (wake)
> +			drv_wake_tx_queue(local);
>  	}

Are you sure you want to skip the call to ieee80211_schedule_txq() if
wake is true? I think you don't, but boolean short-circuit evaluation
would lead to that, afaict?

So it better be written as

  if (ieee80211_schedule_txq(...))
    wake = true;

No need to even check wake anyway, since it can only ever go from false
to true.

(Also, that line is getting a bit long)

>  	skb_queue_head_init(&pending);
> diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
> index 3d9ac17af407..531c0e7f2358 100644
> --- a/net/mac80211/trace.h
> +++ b/net/mac80211/trace.h
> @@ -2550,33 +2550,20 @@ TRACE_EVENT(drv_tdls_recv_channel_switch,
>  );
>  
>  TRACE_EVENT(drv_wake_tx_queue,
> -	TP_PROTO(struct ieee80211_local *local,
> -		 struct ieee80211_sub_if_data *sdata,
> -		 struct txq_info *txq),
> +	TP_PROTO(struct ieee80211_local *local),

You should just replace all of this with

DEFINE_EVENT(local_only_evt, drv_wake_tx_queue,
        TP_PROTO(struct ieee80211_local *local),
        TP_ARGS(local)
);

now.

> +bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
> +			     struct ieee80211_txq *txq)
> +{
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct txq_info *txqi = to_txq_info(txq);
> +	int ret = 0;

bool/false/true please.

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
> +	txqi = list_first_entry(&local->active_txqs, struct txq_info, schedule_order);

that line seems pretty long, but I haven't counted :)

johannes
