Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdJFRSm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 13:18:42 -0400
Message-ID: <1507310319.19300.28.camel@sipsolutions.net> (sfid-20171006_191921_152379_2DFDE1A2)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Fri, 06 Oct 2017 19:18:39 +0200
In-Reply-To: <87lgkoqrhs.fsf@toke.dk>
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-06 at 16:29 +0200, Toke Høiland-Jørgensen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Fri, 2017-10-06 at 13:52 +0200, Toke Høiland-Jørgensen wrote:
> > > This adds accounting of each station's airtime usage to mac80211.
> > > On
> > > the RX side, airtime is calculated from the packet length and
> > > duration.
> > 
> > I think you should probably try to get something here from the
> > driver?
> > Doing the calculations is really awkward, because you have to take
> > into account aggregation, etc.
> 
> Well, calculating the duration from the rate and size is what ath9k
> is currently doing, and that has all the information available to do
> so (I did verify that the airtime was almost identical on the TX and
> RX side for the same traffic).

It's still iffy - with aggregation you might have a better idea of the
total airtime, but not really see - in the higher layers - all the
padding that comes between A-MPDUs etc. I think many drivers could do
better by exposing the total airtime from the device/firmware, whereas
exposing _all_ the little details that you need to calculate it post-
facto will be really difficult, and make the calculation really hard.

> But yeah, I guess that is not necessarily the case for all drivers?
> Maybe having a field that the driver can fill in is better (that also
> has the nice property that a driver that doesn't supply any airtime
> information won't get the scheduling; which is probably desirable).

I think that'd be better, yes. Perhaps for some simple cases a helper
function can be provided, but I'd want to actually know about those
drivers before adding that.

> You're right that it does nothing for one-way UDP, of course. But not
> a lot of traffic is actually one-way (most is either TCP or something
> like Quic that also has a feedback loop). So in most of our tests we
> saw a pretty nice effect from TCP back-pressure.

Yeah that makes some sense. I'm a bit concerned about pathological
corner cases, you don't really know about the protocol used on top. Can
a client starve itself by sending things? And perhaps, if it has a dumb
higher layer protocol, it'll retransmit rather than back off, if it
doesn't get the higher layer ACK?

> > Then again, I'm not even sure yet why you care about the AC at all?
> > Should fairness really be something that's within an AC?
> 
> No, ideally it shouldn't. This is mostly an artifact of how ath9k
> schedules TXQs independently for each AC. This means that if (say)
> three stations are back-logged on the BE queue, and one of those also
> has the occasional packet on the VO queue, if the deficit is shared
> between all levels, every time a VO packet arrives that station
> effectively gets its deficit reset to zero, meaning it will get too
> much airtime.
> 
> Having a separate deficit for each AC level is a crude workaround for
> this, which is what we went with for the initial version in ath9k;
> and this patch is just a straight-forward port of that. But I guess
> this is a good opportunity to figure out how to solve this properly;
> I'll think about how to do that (ideas welcome!)...

So ... no, I don't understand. You have a TXQ per _TID_, so splitting
up this per _AC_ still doesn't make sense since you have two TXQs for
each AC?

But then again I'm not sure I've sufficiently wrapped my head around
the whole algorithm, so ...

johannes
