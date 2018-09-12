Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42143 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbeILQOY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 12:14:24 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 2/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <e90d3540e3c92c6e894217982cd77ff1@codeaurora.org>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897061.14170.17999956909203163571.stgit@alrua-x1> <1536567496.3224.36.camel@sipsolutions.net> <87h8ixli4s.fsf@toke.dk> <e90d3540e3c92c6e894217982cd77ff1@codeaurora.org>
Date: Wed, 12 Sep 2018 13:10:19 +0200
Message-ID: <87o9d3hsys.fsf@toke.dk> (sfid-20180912_131024_619142_7FB78354)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-10 04:13, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>>> -			       txqi->flags & (1<<IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>>>> -			       txqi->flags & (1<<IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>>>> -			       txqi->flags & (1<<IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU" :=20
>>>> "");
>>>> +			       txqi->flags & (1 << IEEE80211_TXQ_STOP) ? "STOP" : "RUN",
>>>> +			       txqi->flags & (1 << IEEE80211_TXQ_AMPDU) ? " AMPDU" : "",
>>>> +			       txqi->flags & (1 << IEEE80211_TXQ_NO_AMSDU) ? " NO-AMSDU"=20
>>>> : "");
>>>=20
>>> consider BIT() instead as a cleanup? :)
>>>=20
>>> (or maybe this is just a leftover from merging some other patches?)
>>=20
>> Yeah, this is a merging artifact; Rajkumar's patch added another flag,
>> that I removed again. Didn't notice that there was still a whitespace
>> change in this patch...
>>=20
> I added the flag based on our last discussion. The driver needs to check
> txq status for each tx_dequeue(). One time txq check is not sufficient
> as it allows the driver to dequeue all frames from txq.
>
> drv_func() {
>        while (ieee80211_airtime_may_transmit(txq) &&
>                hw_has_space() &&
>               (pkt =3D ieee80211_tx_dequeue(hw, txq)))
>            push_to_hw(pkt);
> }

Yeah, but with airtime only being recorded on TX completion, the odds of
the value changing within that loop are quite low; so it's not going to
work, which is why I removed it.

However, after reading Kan's patches I get where you're coming from; a
check in tx_dequeue() is needed for the BQL-style queue limiting. Will
try to incorporate a version of that in the next series so you can see
what I mean when I say it should be orthogonal; and I'm still not sure
it needs a flag :)

>>>> +bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>>>> +				struct ieee80211_txq *txq)
>>>> +{
>>>> +	struct ieee80211_local *local =3D hw_to_local(hw);
>>>> +	struct txq_info *txqi =3D to_txq_info(txq);
>>>> +	bool may_tx =3D false;
>>>> +
>>>> +	spin_lock_bh(&local->active_txq_lock);
>>>> +
>>>> +	if (ieee80211_txq_check_deficit(local, txqi)) {
>>>> +		may_tx =3D true;
>>>> +		list_del_init(&txqi->schedule_order);
>>>=20
>
> To handle above case, may_transmit should remove the node only
> when it is in list.
>
> if (list_empty(&txqi->schedule_order))
>         list_del_init(&txqi->schedule_order);

I assume you missed a ! in that if, right? :)

> So that it can be used to determine whether txq is running negative.

But still not sure what you mean here?

-Toke
