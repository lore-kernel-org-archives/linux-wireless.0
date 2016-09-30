Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42000 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752314AbcI3K1I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 06:27:08 -0400
Message-ID: <1475231220.17481.32.camel@sipsolutions.net> (sfid-20160930_122712_532538_48157CB8)
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
 after TXQ dequeue
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 12:27:00 +0200
In-Reply-To: <20160922170420.5193-3-toke@toke.dk> (sfid-20160922_190458_746453_8124AE7E)
References: <20160922170420.5193-1-toke@toke.dk>
         <20160922170420.5193-3-toke@toke.dk> (sfid-20160922_190458_746453_8124AE7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,

Sorry for the delay reviewing this.

I think I still have a few comments/questions.

> +static inline bool txq_has_queue(struct ieee80211_txq *txq)
> +{
> +	struct txq_info *txqi = to_txq_info(txq);
> +	return !(skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets);
> +}

Tiny nit - there should probably be a blank line between the two lines
here, but I could just fix that when I apply if you don't resend anyway
for some other reason.

[snip helper stuff that looks fine]

> -	if (!tx->sta->sta.txq[0])
> -		hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);
> +	hdr->seq_ctrl = ieee80211_tx_next_seq(tx->sta, tid);

Just to make sure I get this right - this is because the handler is now
run on dequeue, so the special case is no longer needed?

>  #define CALL_TXH(txh) \
> @@ -1656,6 +1684,31 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
>  	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
>  		CALL_TXH(ieee80211_tx_h_rate_ctrl);

Just for reference - the code block here that's unchanged contains
this:

        CALL_TXH(ieee80211_tx_h_dynamic_ps);
        CALL_TXH(ieee80211_tx_h_check_assoc);
        CALL_TXH(ieee80211_tx_h_ps_buf);
        CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
        CALL_TXH(ieee80211_tx_h_select_key);
        if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
                CALL_TXH(ieee80211_tx_h_rate_ctrl);

> +static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
> +	ieee80211_tx_result res = TX_CONTINUE;
> +
>  	if (unlikely(info->flags &
> IEEE80211_TX_INTFL_RETRANSMISSION)) {
>  		__skb_queue_tail(&tx->skbs, tx->skb);
>  		tx->skb = NULL;

And this code here is also unchanged from the original TX handler
invocation, so contains this:

        if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
                __skb_queue_tail(&tx->skbs, tx->skb);
                tx->skb = NULL;
                goto txh_done;
        }

        CALL_TXH(ieee80211_tx_h_michael_mic_add);
        CALL_TXH(ieee80211_tx_h_sequence);
        CALL_TXH(ieee80211_tx_h_fragment);
        /* handlers after fragment must be aware of tx info fragmentation! */
        CALL_TXH(ieee80211_tx_h_stats);
        CALL_TXH(ieee80211_tx_h_encrypt);
        if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
                CALL_TXH(ieee80211_tx_h_calculate_duration);

But now you have a problem (that you solved) that the key pointer can
be invalidated while you have the packet queued between the two points,
and then the tx_h_michael_mic_add and/or tx_h_encrypt would crash.

You solve this by re-running tx_h_select_key() on dequeue, but it's not
clear to me why you didn't move that to the late handlers instead?

I *think* it should commute with the rate control handler, but even so,
wouldn't it make more sense to have rate control late? Assuming the
packets are queued for some amount of time, having rate control
information queued with them would get stale.

Similarly, it seems to me that checking the control port protocol later
(or perhaps duplicating that?) would be a good idea?


> +/*
> + * Can be called while the sta lock is held. Anything that can cause
> packets to
> + * be generated will cause deadlock!
> + */
> +static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data
> *sdata,
> +				       struct sta_info *sta, u8
> pn_offs,
> +				       struct ieee80211_key *key,
> +				       struct sk_buff *skb)

That should be a void function now, you never check the return value
and only return true anyway.

> +	struct ieee80211_tx_info *info;
> +	struct ieee80211_tx_data tx;
> +	ieee80211_tx_result r;
> +

nit: extra blank line

>  	spin_lock_bh(&fq->lock);
>  
>  	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
>  		goto out;
>  
> +	/* Make sure fragments stay together. */
> +	skb = __skb_dequeue(&txqi->frags);
> +	if (skb)
> +		goto out;
> +
> +begin:

I guess now that you introduced that anyway, we should consider making
the skb_linearize() failure go there. Should be a follow-up patch
though.

> +	/*
> +	 * The key can be removed while the packet was queued, so
> need to call
> +	 * this here to get the current key.
> +	 */
> +	r = ieee80211_tx_h_select_key(&tx);
> +	if (r != TX_CONTINUE) {
> +		ieee80211_free_txskb(&local->hw, skb);
> +		goto begin;
> +	}
> +
> +	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {

It's a bit unfortunate that you lose fast-xmit here completely for the
key stuff, but I don't see a good way to avoid that, other than
completely rejiggering all the (possibly affected) queues when keys
change... might be very complex to do that, certainly a follow-up patch
if it's desired.

This check seems a bit weird though - how could fast-xmit be set
without a TXQ station?

> +++ b/net/mac80211/util.c
> @@ -3393,11 +3393,18 @@ void ieee80211_txq_get_depth(struct
> ieee80211_txq *txq,
>  			     unsigned long *byte_cnt)
>  {
>  	struct txq_info *txqi = to_txq_info(txq);
> +	u32 frag_cnt = 0, frag_bytes = 0;
> +	struct sk_buff *skb;
> +
> +	skb_queue_walk(&txqi->frags, skb) {
> +		frag_cnt++;
> +		frag_bytes += skb->len;
> +	}

I hope this is called infrequently :)

johannes
