Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:47705 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbcHZIyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:54:53 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Taht <dave.taht@gmail.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH v2] mac80211: Move crypto IV generation
        to after TXQ dequeue.
References: <20160817125800.19154-1-toke@toke.dk>
        <20160817144531.4285-1-toke@toke.dk>
        <1471463348.5173.16.camel@sipsolutions.net>
        <CAA93jw4+WTiFAdUJkPaf5aRDy81vMW34TPQt7xSgv95tsXU=cA@mail.gmail.com>
        <1471466600.5173.21.camel@sipsolutions.net> <87oa4k508r.fsf@toke.dk>
        <1472200706.390.29.camel@sipsolutions.net>
Date: Fri, 26 Aug 2016 10:54:47 +0200
In-Reply-To: <1472200706.390.29.camel@sipsolutions.net> (Johannes Berg's
        message of "Fri, 26 Aug 2016 10:38:26 +0200")
Message-ID: <87d1kvzz8o.fsf@toke.dk> (sfid-20160826_105507_391212_EFC43138)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2016-08-22 at 16:47 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=C2=A0
>> I suppose that could be a way to do it (i.e. have
>> ieee80211_tx_dequeue call all the TX hooks etc), but am not sure
>> whether there would be problems doing all this work in the loop
>> that's building aggregates (which is what would happen for ath9k at
>> least).
>
> I don't know, but it seems that it's worth trying.
>
>> An alternative could be to split the process up in two: An "early"
>> and "late" stage, where the early stage does everything that is not
>> sensitive to reordering and the occasional drop, and the late stage
>> is everything that is. Then the queueing step could happen in-between=20
>> the two stages, and the non-queueing path could just call both stages
>> at once. In effect, this would just make the current work-arounds be
>> more explicit in the structure, rather than being marked as
>> exceptions.
>
> I'm not sure that works the way you think it does.
>
> What you did works for fast-xmit, but *only* because that doesn't do
> software crypto. If, for some reason, the TXQ stuff combines with
> software crypto, which doesn't seem impossible (ath9k even has a module
> parameter, iirc), then you have no way for this to work.

Yeah, I realised that when I started reviewing the slow path (sorry for
not realising that straight away). The v3 takes the "split handlers"
approach for this reason. That saved having to deal with fragmentation
on TXQ dequeue, and it means that some of the processing can be done
before queueing (such as GSO splitting; having packets be as small as
possible before applying FQ to them is a good thing if we want to
realise the full potential).

It seems there are still some bugs to work out with that patch, but I'd
be grateful if you could glance at it and comment on whether you think
this is a viable way forward (provided we can work out all the bugs, of
course).

>> > Now, it's unlikely to be that simple - fragmentation, for example,
>> > might mess this up.
>> >=20
>> > Overall though, I'm definitely wondering if it should be this way,
>> > since all the special cases just add complexity.
>>=20
>> I agree that the work-arounds are iffy, but I do also think it's
>> important to keep in mind that we are improving latency by orders of
>> magnitude here. A few special cases is worth it to achieve that, IMO.
>> And then iterating towards a design that don't need them, of course
>> :)
>
> I don't really agree, I'm not going to treat this unlike any other
> feature, which gets merged when it's ready for that.
>
> Right now, your code here obviously isn't, since it doesn't even
> address the cases that ath9k could run into, so either ath9k shouldn't
> use this mac80211 feature, or the mac80211 feature needs to be fixed
> before ath9k can use it.

Yeah, I agree now that I've looked at it some more :)

> I have no problems with documenting that the TXQ stuff can only be
> used with full hardware crypto, but then we should add some checks and
> warnings in mac80211 to ensure that, i.e. not allow software keys when
> TXQ stuff is used, nor allow keys with mac80211 PN assignment, etc.

I'd much rather fix things so it works in all cases. My patch to ath9k
to use this stuff completely removes the old TX path, and things like
the airtime fairness scheduler needs the intermediate queues to work.

-Toke
