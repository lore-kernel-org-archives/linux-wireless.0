Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47247 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728127AbeIJTyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 15:54:43 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536591110.3224.76.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk> <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk> <1536583587.3224.71.camel@sipsolutions.net> <87wortjy8n.fsf@toke.dk> <1536585051.3224.72.camel@sipsolutions.net> <87r2i1jxse.fsf@toke.dk> <1536591110.3224.76.camel@sipsolutions.net>
Date: Mon, 10 Sep 2018 17:00:11 +0200
Message-ID: <87muspjt38.fsf@toke.dk> (sfid-20180910_170019_192210_479CD83B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-09-10 at 15:18 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> If we have the start_schedule() / end_schedule() pair anyway, the latter
>> could notify any TXQs that became eligible during the scheduling round.
>
> Do we even need end_schedule()? It's hard to pass multiple things to a
> single call (do you build a list?), so having
>
> 	start_schedule(), get_txq(), return_txq()
>
> would be sufficient?

Well, start_schedule() / end_schedule() would be needed if we are going
to add locking in mac80211?

>> Also, instead of having the three different API functions
>> (next_txq()/may_tx()/schedule_txq()), we could  have get_txq(txq)/put_tx=
q(txq)
>> which would always need to be paired; but the argument to get_txq()
>> could be optional, and if the driver passes NULL it means "give me the
>> next available TXQ".
>
> I can't say I like this. It makes the meaning totally different:
>
>  * with NULL: use the internal scheduler to determine which one is good
>    to use next
>  * non-NULL: essentially equivalent to may_tx()

Yeah, it'll be two completely different uses for the same function; but
there wouldn't be two different APIs to keep track of. I'm fine with
keeping them as separately named functions. :)

>> So for ath9k it would be:
>>=20
>>=20
>> start_schedule(ac);
>> while ((txq =3D get_txq(NULL)) {
>>   queue_aggregate(txq);
>>   put_txq(txq);
>> }
>> end_schedule(ac);
>>=20
>> And for ath10k/iwlwifi it would be:
>>=20
>> on_hw_notify(txq) {
>>  start_schedule(ac);
>>  if (txq =3D get_txq(txq)) {
>>    queue_packets(txq);
>>    put_txq(txq);
>>  }
>>  end_schedule(ac);
>> }
>>=20
>>=20
>> I think that would be simpler, API-wise?
>
> I can't say I see much point in overloading get_txq() that way. You'd
> never use it the same way.
>
> Also, would you really start_schedule(ac) in the hw-managed case?

If we decide mac80211 needs to do locking to prevent two threads from
scheduling the same ac, that would also be needed for the hw-managed
case?

> It seems like not? Basically it seems to me that in the hw-managed
> case all you need is may_tx()? And in fact, once you opt in you don't
> even really need *that* since mac80211 can just return NULL from
> get_skb()?

Yeah, we could just throttle in get_skb(); the separate call was to
avoid the overhead of the check for every packet. Typically, you'll pick
a TXQ, then dequeue multiple packets from it in succession; with a
separate call to may_tx(), you only do the check once, not for every
packet...

-Toke
