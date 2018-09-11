Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35907 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbeIKOrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 10:47:11 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net
Cc: Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH RFC v3 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <1536657605.3224.122.camel@sipsolutions.net>
References: <153635803319.14170.10011969968767927187.stgit@alrua-x1> <153635897010.14170.2992498632345986102.stgit@alrua-x1> <1536565717.3224.12.camel@sipsolutions.net> <87musplivy.fsf@toke.dk> <1536577419.3224.50.camel@sipsolutions.net> <87zhwpjzme.fsf@toke.dk> <1536583587.3224.71.camel@sipsolutions.net> <87wortjy8n.fsf@toke.dk> <1536585051.3224.72.camel@sipsolutions.net> <87r2i1jxse.fsf@toke.dk> <1536591110.3224.76.camel@sipsolutions.net> <87muspjt38.fsf@toke.dk> <1536657605.3224.122.camel@sipsolutions.net>
Date: Tue, 11 Sep 2018 11:48:37 +0200
Message-ID: <87d0tkjrey.fsf@toke.dk> (sfid-20180911_114843_026263_9BD032C5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2018-09-10 at 17:00 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > Do we even need end_schedule()? It's hard to pass multiple things to a
>> > single call (do you build a list?), so having
>> >=20
>> > 	start_schedule(), get_txq(), return_txq()
>> >=20
>> > would be sufficient?
>>=20
>> Well, start_schedule() / end_schedule() would be needed if we are going
>> to add locking in mac80211?
>
> [...]
>
>> If we decide mac80211 needs to do locking to prevent two threads from
>> scheduling the same ac, that would also be needed for the hw-managed
>> case?
>
> Yes, good point.
>
>> > It seems like not? Basically it seems to me that in the hw-managed
>> > case all you need is may_tx()? And in fact, once you opt in you don't
>> > even really need *that* since mac80211 can just return NULL from
>> > get_skb()?
>>=20
>> Yeah, we could just throttle in get_skb(); the separate call was to
>> avoid the overhead of the check for every packet. Typically, you'll pick
>> a TXQ, then dequeue multiple packets from it in succession; with a
>> separate call to may_tx(), you only do the check once, not for every
>> packet...
>
> Yeah, also a good point.
>
> Still, txq =3D get_txq(txq) doesn't feel right, so better to keep that
> separate I think.

Right, will do :)

-Toke
