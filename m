Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:49545 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752158AbcHVOrj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 10:47:39 -0400
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
        <1471466600.5173.21.camel@sipsolutions.net>
Date: Mon, 22 Aug 2016 16:47:32 +0200
In-Reply-To: <1471466600.5173.21.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 17 Aug 2016 22:43:20 +0200")
Message-ID: <87oa4k508r.fsf@toke.dk> (sfid-20160822_164743_605580_58FEFC93)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> well, we're getting there. the results of both patch attempts were
>> really nice, and brought encrypted performance with fq back into line
>> with unencrypted. Still running crypted tests as I write...
>> 
>> So fixing TKIP would be next, forcing the AP to use that? What other
>> scenarios do we have to worry about? WDS?
>> 
>
> I don't think there's anything else, I just don't really feel it's
> getting anywhere. This is a mere symptom of the design.
>
> Felix had worked around the SN assignment in a similar way, but I feel
> that perhaps the whole thing isn't quite the right architecture. Why
> are we applying FQ after the wifi conversion, when clearly that doesn't
> work well? Seems to me that it would make more sense to let the frames
> sit on the queues as they come in, and do most of the wifi handling
> only when needed (obviously, things like control port would still have
> to be done).

I suppose that could be a way to do it (i.e. have ieee80211_tx_dequeue
call all the TX hooks etc), but am not sure whether there would be
problems doing all this work in the loop that's building aggregates
(which is what would happen for ath9k at least).

An alternative could be to split the process up in two: An "early" and
"late" stage, where the early stage does everything that is not
sensitive to reordering and the occasional drop, and the late stage is
everything that is. Then the queueing step could happen in-between the
two stages, and the non-queueing path could just call both stages at
once. In effect, this would just make the current work-arounds be more
explicit in the structure, rather than being marked as exceptions.

> We even count those packets that are dropped for TX statistics, which
> would seem to be a big behavioural difference vs. applying a qdisc.

While you're right in principle, in practice I don't think this has too
big of an impact. In normal operation, CoDel drops (at most) dozens of
packets per *minute*, so it's not going to skew the statistics too much.

> Now, it's unlikely to be that simple - fragmentation, for example,
> might mess this up.
>
> Overall though, I'm definitely wondering if it should be this way,
> since all the special cases just add complexity.

I agree that the work-arounds are iffy, but I do also think it's
important to keep in mind that we are improving latency by orders of
magnitude here. A few special cases is worth it to achieve that, IMO.
And then iterating towards a design that don't need them, of course :)

-Toke
