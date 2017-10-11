Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45174 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757325AbdJKIzi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:55:38 -0400
Message-ID: <1507712135.1998.27.camel@sipsolutions.net> (sfid-20171011_105620_878880_38BB3401)
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Date: Wed, 11 Oct 2017 10:55:35 +0200
In-Reply-To: <87376sqda9.fsf@toke.dk>
References: <20171006115232.28688-1-toke@toke.dk>
         <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk>
         <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk>
         <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk>
         <1507549222.26041.38.camel@sipsolutions.net> <87zi90binm.fsf@toke.dk>
         <1507575007.26041.59.camel@sipsolutions.net> <87376sqda9.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-09 at 22:25 +0200, Toke Høiland-Jørgensen wrote:

> > Well, the case that we did find is that sometimes U-APSD kills
> > aggregation, so then you'd have a lot of single frames and
> > significantly under-estimate air-time usage in this case. Thus,
> > this
> > station would get far more than its fair share of air time, because
> > of
> > a bug that makes it not use aggregation... That doesn't sound very
> > good to me.
> > 
> > Perhaps at least taking aggregation into account would be doable -
> > we _should_ know this, at least partially.
> 
> Yeah, ath9k certainly gets that as part of the RX information from
> the chip.

Yeah, though there are more complex cases, e.g. with hardware A-MSDU
deaggregation like in ath10k.

> Well, some of the tests I did while porting ath9k to the iTXQs
> indicated that for voice-like traffic we can get very close to the
> same actual end-to-end latency for BE-marked traffic that we do with
> VO-marked traffic. This is in part because the FQ sparse flow
> prioritisation makes sure that such flows get queueing priority.

That really depends on medium saturation - if that's low, then yeah,
the difference is in the EDCA parameters and the minimum backoff, which
isn't a huge difference if you measure end-to-end.

Given saturation/congestion though, and I think we have to take this
into account since not everyone will be using this code, there are
measurable advantages to using VO - like in the test I mentioned where
you can block out BE "forever".

> Now obviously, there are going to be tradeoffs, and scenarios where
> latency will suffer. But I would at least like to be able to explore
> this, and I think with the API we are currently discussing that will
> be possible. 

I'm not sure how you envision this working with the API, since you
still have to pull from multiple TXQs, but I have no objection to the
API as is - I'm just not convinced that actually demoting traffic is a
good idea :)

> Another thing I want to explore is doing soft admission
> control; i.e., if someone sends bulk traffic marked as VO, it will be
> automatically demoted to BE traffic rather than locking everyone else
> out. We've tested that with some success in the Cake scheduler, and
> it may be applicable to WiFi as well.

It seems pretty strange to do that at this level - we control what TID
(and AC) is selected for the traffic? So why not just change at that
level for this type of thing?

You can probably even already do that with TC by re-marking the traffic
depending on type or throughput or whatever else TC can classify on.

johannes
