Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:39077 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933018AbcI3MjL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:39:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v9 2/2] mac80211: Move reorder-sensitive TX handlers to
        after TXQ dequeue
References: <20160922170420.5193-1-toke@toke.dk>
        <20160922170420.5193-3-toke@toke.dk>
        <1475231220.17481.32.camel@sipsolutions.net>
Date: Fri, 30 Sep 2016 14:39:05 +0200
In-Reply-To: <1475231220.17481.32.camel@sipsolutions.net> (Johannes Berg's
        message of "Fri, 30 Sep 2016 12:27:00 +0200")
Message-ID: <87y4295zpy.fsf@toke.dk> (sfid-20160930_143931_460683_DCAD2C15)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi Toke,
>
> Sorry for the delay reviewing this.
>
> I think I still have a few comments/questions.

No worries. And not terribly surprised ;)

>> +static inline bool txq_has_queue(struct ieee80211_txq *txq)
>> +{
>> +	struct txq_info *txqi =3D to_txq_info(txq);
>> +	return !(skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets);
>> +}
>
> Tiny nit - there should probably be a blank line between the two lines
> here, but I could just fix that when I apply if you don't resend anyway
> for some other reason.

Noted.

> [snip helper stuff that looks fine]
>
>> -	if (!tx->sta->sta.txq[0])
>> -		hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
>> +	hdr->seq_ctrl =3D ieee80211_tx_next_seq(tx->sta, tid);
>
> Just to make sure I get this right - this is because the handler is now
> run on dequeue, so the special case is no longer needed?

Yup. The same change is made in xmit_fast (but obscured by the moving of
the surrounding code into _finish()).

>> =C2=A0#define CALL_TXH(txh) \
>> @@ -1656,6 +1684,31 @@ static int invoke_tx_handlers(struct ieee80211_tx=
_data *tx)
>> =C2=A0	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
>> =C2=A0		CALL_TXH(ieee80211_tx_h_rate_ctrl);
>
> Just for reference - the code block here that's unchanged contains
> this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 CALL_TXH(ieee80211_tx_h_dynamic_ps);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_c=
heck_assoc);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_p=
s_buf);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_c=
heck_control_port_protocol);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_s=
elect_key);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ieee80211_hw_check(&=
tx->local->hw, HAS_RATE_CONTROL))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_rate_ctrl);
>
>> +static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
>> +{
>> +	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
>> +	ieee80211_tx_result res =3D TX_CONTINUE;
>> +
>> =C2=A0	if (unlikely(info->flags &
>> IEEE80211_TX_INTFL_RETRANSMISSION)) {
>> =C2=A0		__skb_queue_tail(&tx->skbs, tx->skb);
>> =C2=A0		tx->skb =3D NULL;
>
> And this code here is also unchanged from the original TX handler
> invocation, so contains this:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(info->flags & IEEE80211_TX_INTFL=
_RETRANSMISSION)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0__skb_queue_tail(&tx->skbs, tx->skb);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0tx->skb =3D NULL;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0goto txh_done;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_m=
ichael_mic_add);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_s=
equence);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_f=
ragment);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* handlers after fragmen=
t must be aware of tx info fragmentation! */
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_s=
tats);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_e=
ncrypt);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!ieee80211_hw_check(&=
tx->local->hw, HAS_RATE_CONTROL))
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0CALL_TXH(ieee80211_tx_h_calculate_duration);
>
> But now you have a problem (that you solved) that the key pointer can
> be invalidated while you have the packet queued between the two points,
> and then the tx_h_michael_mic_add and/or tx_h_encrypt would crash.
>
> You solve this by re-running tx_h_select_key() on dequeue, but it's not
> clear to me why you didn't move that to the late handlers instead?

Because I need to run it anyway for the xmit_fast path on dequeue. I
thought doing it this way simplifies the code (at the cost of the
handler getting called twice when xmit_fast is not active).

> I *think* it should commute with the rate control handler, but even
> so, wouldn't it make more sense to have rate control late? Assuming
> the packets are queued for some amount of time, having rate control
> information queued with them would get stale.

Yes, having rate control run at dequeue would be good, and that's what I
did initially. However, I found that this would lead to a deadlock
because the rate control handler would send out packets in some cases (I
forget the details but can go back and check if needed). And since the
dequeue function is called with the driver TXQ lock held, that would
lead to a deadlock when those packets made it to the driver TX path.

So I decided to just keep it this way for now; I plan to go poking into
the rate controller later anyway, so moving the handler to later could
be part of that.

> Similarly, it seems to me that checking the control port protocol later
> (or perhaps duplicating that?) would be a good idea?

But that handler only sets a few flags? Is
tx->sdata->control_port_protocol likely to change while the packet is
queued?

>> +/*
>> + * Can be called while the sta lock is held. Anything that can cause
>> packets to
>> + * be generated will cause deadlock!
>> + */
>> +static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data
>> *sdata,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sta_info *sta, u8
>> pn_offs,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ieee80211_key *key,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sk_buff *skb)
>
> That should be a void function now, you never check the return value
> and only return true anyway.

Noted.

>> +	struct ieee80211_tx_info *info;
>> +	struct ieee80211_tx_data tx;
>> +	ieee80211_tx_result r;
>> +
>
> nit: extra blank line

The horror ;) (thought I got rid of all those; ah well, will fix)
>
>> =C2=A0	spin_lock_bh(&fq->lock);
>> =C2=A0
>> =C2=A0	if (test_bit(IEEE80211_TXQ_STOP, &txqi->flags))
>> =C2=A0		goto out;
>> =C2=A0
>> +	/* Make sure fragments stay together. */
>> +	skb =3D __skb_dequeue(&txqi->frags);
>> +	if (skb)
>> +		goto out;
>> +
>> +begin:
>
> I guess now that you introduced that anyway, we should consider making
> the skb_linearize() failure go there. Should be a follow-up patch
> though.

Can do.

>
>> +	/*
>> +	=C2=A0* The key can be removed while the packet was queued, so
>> need to call
>> +	=C2=A0* this here to get the current key.
>> +	=C2=A0*/
>> +	r =3D ieee80211_tx_h_select_key(&tx);
>> +	if (r !=3D TX_CONTINUE) {
>> +		ieee80211_free_txskb(&local->hw, skb);
>> +		goto begin;
>> +	}
>> +
>> +	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
>
> It's a bit unfortunate that you lose fast-xmit here completely for the
> key stuff, but I don't see a good way to avoid that, other than
> completely rejiggering all the (possibly affected) queues when keys
> change... might be very complex to do that, certainly a follow-up
> patch if it's desired.

Yeah, figured it was better to have something that's correct and then go
back and change it if the performance hit turns out to be too high.

> This check seems a bit weird though - how could fast-xmit be set
> without a TXQ station?

I think that is probably just left over from before I introduced the
control flag. Should be fine to remove it.

>> +++ b/net/mac80211/util.c
>> @@ -3393,11 +3393,18 @@ void ieee80211_txq_get_depth(struct
>> ieee80211_txq *txq,
>> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long *byte_cnt)
>> =C2=A0{
>> =C2=A0	struct txq_info *txqi =3D to_txq_info(txq);
>> +	u32 frag_cnt =3D 0, frag_bytes =3D 0;
>> +	struct sk_buff *skb;
>> +
>> +	skb_queue_walk(&txqi->frags, skb) {
>> +		frag_cnt++;
>> +		frag_bytes +=3D skb->len;
>> +	}
>
> I hope this is called infrequently :)

Well, ath10k is the only user. It does get called on each wake_tx_queue,
though, so not that infrequently. My reasoning was that since the frags
queue is never going to have more than a fairly small number of packets
in it (those produced from a single split packet), counting this way is
acceptable instead of keeping a state variable up to date. Can change it
if you disagree :)


Not sure if you want a v10, or if you're satisfied with the above
comments and will just fix up the nits on merging?

-Toke
