Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756608AbdJKIqg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:46:36 -0400
Message-ID: <1507711593.1998.20.camel@sipsolutions.net> (sfid-20171011_104646_396385_39FCCCBA)
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 11 Oct 2017 10:46:33 +0200
In-Reply-To: <87k2027uxp.fsf@toke.dk>
References: <20171010140208.1515-1-toke@toke.dk>
         <1507650823.26041.70.camel@sipsolutions.net> <87k2027uxp.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 19:51 +0200, Toke Høiland-Jørgensen wrote:

> > > +	struct list_head active_txqs;
> > > +	spinlock_t active_txq_lock;
> > 
> > Is there much point in having a separate lock? We probably need the
> > fq lock in most places related to this anyway?
> 
> Well, once the scheduler gets a bit smarter it may be necessary to
> much with the order of TXQs on there without touching any of the
> queues (e.g., when calculating airtime usage on TX and RX
> completion). Not sure if that is enough to warrant a separate lock,
> though; I hadn't thought about just grabbing fq->lock...

Ok, dunno. It seemed sort of related but perhaps it's not really.


> > Also maybe you should only do that if the TXQ isn't *empty*, so the
> > driver could call this unconditionally?
> 
> There can be cases where the driver wants the queue to be scheduled
> even though it looks empty from mac80211's point of view. For ath9k,
> the driver keeps its retry queue in the drv_priv part of the txq
> structure, so it will check if that is empty before deciding to call
> the schedule function.
> 
> This is also related to the PS behaviour, so guess this could be
> changed once that is all TXQ-based...

Interesting. I guess scheduling an empty queue doesn't really matter
for mac80211 anyway though - just some extra work if we try to get
frames from it.

johannes
