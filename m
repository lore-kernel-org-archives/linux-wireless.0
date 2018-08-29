Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:38318 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbeH2Og1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 10:36:27 -0400
Message-ID: <1535539202.5215.32.camel@sipsolutions.net> (sfid-20180829_124014_408563_6A82F543)
Subject: Re: [RFC v2 2/4] mac80211: Add airtime accounting and scheduling to
 TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Wed, 29 Aug 2018 12:40:02 +0200
In-Reply-To: <87y3cp31ik.fsf@toke.dk>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
         <153115422499.7447.2570671473822724496.stgit@alrua-x1>
         <1535528658.5215.19.camel@sipsolutions.net> <877ek94j66.fsf@toke.dk>
         <1535537670.5215.26.camel@sipsolutions.net> <87y3cp31ik.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-29 at 12:33 +0200, Toke Høiland-Jørgensen wrote:

> > > Hmm, the problem with a higher weight is that weight*quantum becomes the
> > > time each station is scheduled, so having a higher value means higher
> > > latency. This could be fixed by replacing the station weights with
> > > per-station quantums, but I felt that this was exposing an
> > > implementation detail in the API; if we ever change the enforcement
> > > mechanism to not be quantum-based (as may be necessary for MU-MIMO for
> > > instance), we'll have to convert values in the kernel. Whereas weights
> > > are a conceptual measure that is not tied to any particular
> > > implementation.
> > 
> > Ok, but that's also an effect you should describe in the API for it.
> 
> What's the right place to put that? In the netlink header file?

Right.

> > Perhaps then it should just be fractional? i.e. 8.8 bits or so?, so
> > the default would be 1.0 (0x0100) and then you could scale down to 0.5
> > (0x0080) etc?
> 
> Hmm, that's an interesting idea. I'll have to run some numbers to see
> how the precision holds up on various examples; but that would allow us
> to get rid of the quantum in the userspace API entirely, which is a good
> thing as far as I'm concerned!

:-)

We can always go to 32 bits and then we have lots to play with? It's 16
bits right now so I picked 8.8 for no real reason - in fact that seems
quite pointless since dividing 300us by 256 gives you only just over 1us
which is really short.

So perhaps 12.4 (minimum 18 usec) is more appropriate?

But perhaps I'm just completely mistaken and you don't really want to be
able to scale the quantum down further at all, and so you have to play
with all the stations anyway?

No idea, really, how you'd use this.

> > > For the drivers that get airtime as part of TX completion, sure; but as
> > > I understand it, at least ath10k gets airtime information in out of band
> > > status reports, so there would need to be a callback for that in any
> > > case...
> > 
> > Hmm, ok, but perhaps then we should also tie those to the existing
> > airtime things?
> 
> Eh? Tie what to which existing airtime things?

At least WMM-AC: ieee80211_sta_tx_wmm_ac_notify().

johannes
