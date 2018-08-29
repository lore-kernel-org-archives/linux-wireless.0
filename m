Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:35377 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbeH2OaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 10:30:12 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <1535537670.5215.26.camel@sipsolutions.net>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422499.7447.2570671473822724496.stgit@alrua-x1> <1535528658.5215.19.camel@sipsolutions.net> <877ek94j66.fsf@toke.dk> <1535537670.5215.26.camel@sipsolutions.net>
Date: Wed, 29 Aug 2018 12:33:55 +0200
Message-ID: <87y3cp31ik.fsf@toke.dk> (sfid-20180829_123359_940395_AEC77A72)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-08-29 at 11:27 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> Hmm, the problem with a higher weight is that weight*quantum becomes the
>> time each station is scheduled, so having a higher value means higher
>> latency. This could be fixed by replacing the station weights with
>> per-station quantums, but I felt that this was exposing an
>> implementation detail in the API; if we ever change the enforcement
>> mechanism to not be quantum-based (as may be necessary for MU-MIMO for
>> instance), we'll have to convert values in the kernel. Whereas weights
>> are a conceptual measure that is not tied to any particular
>> implementation.
>
> Ok, but that's also an effect you should describe in the API for it.

What's the right place to put that? In the netlink header file?

> Perhaps then it should just be fractional? i.e. 8.8 bits or so?, so
> the default would be 1.0 (0x0100) and then you could scale down to 0.5
> (0x0080) etc?

Hmm, that's an interesting idea. I'll have to run some numbers to see
how the precision holds up on various examples; but that would allow us
to get rid of the quantum in the userspace API entirely, which is a good
thing as far as I'm concerned!

>> For the drivers that get airtime as part of TX completion, sure; but as
>> I understand it, at least ath10k gets airtime information in out of band
>> status reports, so there would need to be a callback for that in any
>> case...
>
> Hmm, ok, but perhaps then we should also tie those to the existing
> airtime things?

Eh? Tie what to which existing airtime things?

-Toke
