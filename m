Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58141 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758598AbcILMfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:35:21 -0400
Message-ID: <1473683716.29016.37.camel@sipsolutions.net> (sfid-20160912_143539_757269_9D6BAC2F)
Subject: Re: [PATCH v8] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue.
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 12 Sep 2016 14:35:16 +0200
In-Reply-To: <20160906114426.25520-1-toke@toke.dk> (sfid-20160906_134448_323258_743B2762)
References: <20160905113042.22271-1-toke@toke.dk>
         <20160906114426.25520-1-toke@toke.dk>
         (sfid-20160906_134448_323258_743B2762)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx);
> +static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sdata,
> +				       struct sta_info *sta, u8 pn_offs,
> +				       struct ieee80211_key_conf *key_conf,
> +				       struct sk_buff *skb);
> +

I'm not very happy with this - I think you should do some
refactoring/code move in a separate prior patch to avoid this.

> +	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
>  		struct sta_info *sta = container_of(txq->sta, struct sta_info,
>  						    sta);
> -		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +		u8 pn_offs = 0;
>  
> -		hdr->seq_ctrl = ieee80211_tx_next_seq(sta, txq->tid);
> -		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
> -			info->flags |= IEEE80211_TX_CTL_AMPDU;
> -		else
> -			info->flags &= ~IEEE80211_TX_CTL_AMPDU;
> +		if (info->control.hw_key)
> +			pn_offs = ieee80211_hdrlen(hdr->frame_control);

Not very happy with this either - the fast-xmit path explicitly tries
to avoid all these calculations.

I suppose I don't have to care all that much about the TXQs, but ...

Then again, adding a field in the skb->cb for the sake of this? No, not really either.


> +		ieee80211_xmit_fast_finish(sta->sdata, sta, pn_offs,
> +					   info->control.hw_key, skb);

I don't see how keeping the info->control.hw_key pointer across the
TXQ/FQ/Codel queueing isn't a potential bug? Probably one that already
exists in your code today, before this patch, of course.


> +	} else {
> +		struct ieee80211_tx_data tx = { };
> +
> +		__skb_queue_head_init(&tx.skbs);
> +		tx.local = local;
> +		tx.skb = skb;

an empty initializer is weird - why not at least move local/skb
initializations into it? Even txq->sta, I guess, since you can assign
txq->sta either way.

> -	CALL_TXH(ieee80211_tx_h_select_key);
> +
>  	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
>  		CALL_TXH(ieee80211_tx_h_rate_ctrl);
[...]
> 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
>  		__skb_queue_tail(&tx->skbs, tx->skb);
>  		tx->skb = NULL;
>  		goto txh_done;
>  	}
> 
> +	CALL_TXH(ieee80211_tx_h_select_key);

What happens for the IEEE80211_TX_INTFL_RETRANSMISSION packets wrt. key
selection? Why is it OK to change this?

johannes
