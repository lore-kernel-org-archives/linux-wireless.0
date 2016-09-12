Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:46713 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932858AbcILNJH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 09:09:07 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8] mac80211: Move reorder-sensitive TX handlers to after
        TXQ dequeue.
References: <20160905113042.22271-1-toke@toke.dk>
        <20160906114426.25520-1-toke@toke.dk>
        <1473683716.29016.37.camel@sipsolutions.net>
Date: Mon, 12 Sep 2016 15:08:58 +0200
In-Reply-To: <1473683716.29016.37.camel@sipsolutions.net> (Johannes Berg's
        message of "Mon, 12 Sep 2016 14:35:16 +0200")
Message-ID: <87wpihe045.fsf@toke.dk> (sfid-20160912_150911_157829_1560DFD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> +static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx);
>> +static bool ieee80211_xmit_fast_finish(struct ieee80211_sub_if_data *sd=
ata,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sta_info *sta, u8 =
pn_offs,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct ieee80211_key_conf=
 *key_conf,
>> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sk_buff *skb);
>> +
>
> I'm not very happy with this - I think you should do some
> refactoring/code move in a separate prior patch to avoid this.

Noted, will do.

>> +	if (txq->sta && info->control.flags & IEEE80211_TX_CTRL_FAST_XMIT) {
>> =C2=A0		struct sta_info *sta =3D container_of(txq->sta, struct sta_info,
>> =C2=A0						=C2=A0=C2=A0=C2=A0=C2=A0sta);
>> -		struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
>> +		u8 pn_offs =3D 0;
>> =C2=A0
>> -		hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, txq->tid);
>> -		if (test_bit(IEEE80211_TXQ_AMPDU, &txqi->flags))
>> -			info->flags |=3D IEEE80211_TX_CTL_AMPDU;
>> -		else
>> -			info->flags &=3D ~IEEE80211_TX_CTL_AMPDU;
>> +		if (info->control.hw_key)
>> +			pn_offs =3D ieee80211_hdrlen(hdr->frame_control);
>
> Not very happy with this either - the fast-xmit path explicitly tries
> to avoid all these calculations.

Well, the TXQ already adds a lot of other overhead (hashing on the
packet header, for one), so my guess would be that this would be
negligible compared to all that?=20

> I suppose I don't have to care all that much about the TXQs, but ...
>
> Then again, adding a field in the skb->cb for the sake of this? No,
> not really either.

So that's a "keep it", then? :)

>> +		ieee80211_xmit_fast_finish(sta->sdata, sta, pn_offs,
>> +					=C2=A0=C2=A0=C2=A0info->control.hw_key, skb);
>
> I don't see how keeping the info->control.hw_key pointer across the
> TXQ/FQ/Codel queueing isn't a potential bug? Probably one that already
> exists in your code today, before this patch, of course.

You mean the key could get removed from the hardware while the packet
was queued? Can certainly add a check for that. Under what conditions
does that happen? Does it make sense to try to recover from it (I guess
by calling tx_h_select_key), or is it rare enough that giving up and
dropping the packet makes more sense?

>> +	} else {
>> +		struct ieee80211_tx_data tx =3D { };
>> +
>> +		__skb_queue_head_init(&tx.skbs);
>> +		tx.local =3D local;
>> +		tx.skb =3D skb;
>
> an empty initializer is weird - why not at least move local/skb
> initializations into it? Even txq->sta, I guess, since you can assign
> txq->sta either way.

Yup, makes sense. Noted.

>> -	CALL_TXH(ieee80211_tx_h_select_key);
>> +
>> =C2=A0	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
>> =C2=A0		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> [...]
>> 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
>> =C2=A0		__skb_queue_tail(&tx->skbs, tx->skb);
>> =C2=A0		tx->skb =3D NULL;
>> =C2=A0		goto txh_done;
>> =C2=A0	}
>>=20
>> +	CALL_TXH(ieee80211_tx_h_select_key);
>
> What happens for the=C2=A0IEEE80211_TX_INTFL_RETRANSMISSION packets wrt.
> key selection? Why is it OK to change this?

You're right, that's an oversight on my part. Will fix.

-Toke
