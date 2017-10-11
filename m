Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:52653 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752497AbdJKNyh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 09:54:37 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <1507711593.1998.20.camel@sipsolutions.net>
References: <20171010140208.1515-1-toke@toke.dk> <1507650823.26041.70.camel@sipsolutions.net> <87k2027uxp.fsf@toke.dk> <1507711593.1998.20.camel@sipsolutions.net>
Date: Wed, 11 Oct 2017 15:54:33 +0200
Message-ID: <87wp41pz6u.fsf@toke.dk> (sfid-20171011_155724_642065_790380A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2017-10-10 at 19:51 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > > +	struct list_head active_txqs;
>> > > +	spinlock_t active_txq_lock;
>> >=20
>> > Is there much point in having a separate lock? We probably need the
>> > fq lock in most places related to this anyway?
>>=20
>> Well, once the scheduler gets a bit smarter it may be necessary to
>> much with the order of TXQs on there without touching any of the
>> queues (e.g., when calculating airtime usage on TX and RX
>> completion). Not sure if that is enough to warrant a separate lock,
>> though; I hadn't thought about just grabbing fq->lock...
>
> Ok, dunno. It seemed sort of related but perhaps it's not really.

Yeah. I'll keep this in mind when I implement the airtime fairness
accounting.

>> > Also maybe you should only do that if the TXQ isn't *empty*, so the
>> > driver could call this unconditionally?
>>=20
>> There can be cases where the driver wants the queue to be scheduled
>> even though it looks empty from mac80211's point of view. For ath9k,
>> the driver keeps its retry queue in the drv_priv part of the txq
>> structure, so it will check if that is empty before deciding to call
>> the schedule function.
>>=20
>> This is also related to the PS behaviour, so guess this could be
>> changed once that is all TXQ-based...
>
> Interesting. I guess scheduling an empty queue doesn't really matter
> for mac80211 anyway though - just some extra work if we try to get
> frames from it.

Yes, and I figure giving the driver that option might be a good way to
have some flexibility.

-Toke
