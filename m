Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34484 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdJIHPb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 03:15:31 -0400
Message-ID: <1507533328.26041.12.camel@sipsolutions.net> (sfid-20171009_091535_278850_AD486372)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Mon, 09 Oct 2017 09:15:28 +0200
In-Reply-To: <87infrqk28.fsf@toke.dk>
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk>
         <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-10-07 at 13:22 +0200, Toke Høiland-Jørgensen wrote:

> Guess you are right that it will be difficult to get a completely
> accurate number. But as David Lang notes, as long as we are off by
> the same amount for all stations, that is fine - we're just
> interested in relative numbers.

That's not quite true though, you'd overestimate most on stations that
are using aggregation, assuming you take into account the whole frame
exchange sequence time. But maybe giving less than their fair share to
fast stations isn't really that much of a problem.

> > So ... no, I don't understand. You have a TXQ per _TID_, so
> > splitting up this per _AC_ still doesn't make sense since you have
> > two TXQs for each AC?
> 
> Yeah, but ath9k schedules all TIDs on the same AC together. So if
> station A has two TIDs active and station B one, the scheduling order
> will be A1, A2, B1, basically. This is fine as long as they are all
> on the same AC and scheduled together (in which case A1 and A2 will
> just share the same deficit).

Huh, I'm confused. Can you elaborate on this? How does it schedule two
TIDs for _different_ ACs then?

It seems to me that to actually get the right QoS behaviour you have to
schedule *stations*, and then while you're looking at a station, you
need to select the highest-priority TXQ that has data? Otherwise, don't
you end up doing fairness on a STA/AC rather than just on a STA, so
that a station that uses two ACs gets twice as much airtime as one
using just a single AC?

> But if there is only one TXQ active, every time that queue is
> scheduled, the scheduler will loop until its deficit becomes positive
> (which is generally good; that is how we make sure the scheduler is
> work-conserving). However, if the deficit is shared with another
> scheduling group (which in ath9k is another AC), the station in the
> group by itself will not be limited to its fair share, because every
> time it is scheduled by itself, its deficit is "reset".
> 
> Ideally, I would prefer the scheduling to be "two-pass": First,
> decide which physical station to send to, then decide which TID on
> that station to service. 

Yeah, that would make more sense.

> But because everything is done at the TID/TXQ level, that is not
> quite trivial to achieve I think...

Well you can group the TXQs, I guess. They all have a STA pointer, so
you could put a one- or two-bit "schedule color" field into each
station and if you find a TXQ with the same station color you just skip
it or something like that?

johannes
