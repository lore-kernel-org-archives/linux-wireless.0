Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48852 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbdJKOey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 10:34:54 -0400
Message-ID: <1507732491.1998.39.camel@sipsolutions.net> (sfid-20171011_163628_809756_63E24AA4)
Subject: Re: [RFC 1/3] mac80211: Add TXQ scheduling API
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 11 Oct 2017 16:34:51 +0200
In-Reply-To: <87fuapbvws.fsf@toke.dk>
References: <20171010140208.1515-1-toke@toke.dk>
         <1507651555.26041.81.camel@sipsolutions.net> <87fuaq7ubo.fsf@toke.dk>
         <1507711498.1998.18.camel@sipsolutions.net> <87tvz5pymm.fsf@toke.dk>
         <1507731344.1998.36.camel@sipsolutions.net> <87fuapbvws.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-11 at 16:29 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Wed, 2017-10-11 at 16:06 +0200, Toke Høiland-Jørgensen wrote:
> > 
> > > > Hmm, not sure. We really want this to be scheduled pretty much
> > > > immediately because the other side will be waiting for the
> > > > frames,
> > > > and
> > > > if we don't get an answer out quickly it'll have to assume
> > > > we're
> > > > broken. I don't know what the limit here is for our firmware,
> > > > but
> > > > we
> > > > should really get this out as soon as possible in this case.
> > > 
> > > OK. But presumably it can't preempt packets already pushed to the
> > > hardware, right? 
> > 
> > True. If there are still packets scheduled then it needs even more
> > driver tricks to drop those back to tx_pending first ...
> 
> Only for packets to the same station, right?

Yes, but they need to be somehow taken off the queue to avoid
reordering. Usually the firmware will filter them, but synchronisation
is difficult, since what might happen is that some frames are already
filtered, others aren't, and then the later ones actually need to go
out while the earlier ones don't ... if that's not done, you get
reordering and the state machines get out of sync.

> What part of the standard do I have to read to learn how this is
> supposed to work, BTW? Or even better, is there a resource that
> describes how PS works that is more accessible than the standard
> itself?

Hmm. I don't think the standard will actually help you much here, it
just describes the over-the-air behaviour.

Most of the complexity here comes from having to deal with driver
buffering, mac80211 buffering, addressing the reordering problem
(described above) from queuing frames for multiple stations on the same
hw queue.

johannes
