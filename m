Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:40611 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdJKNuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 09:50:22 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add airtime fairness accounting
In-Reply-To: <1507712135.1998.27.camel@sipsolutions.net>
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk> <1507533328.26041.12.camel@sipsolutions.net> <878tgkd5d1.fsf@toke.dk> <1507549222.26041.38.camel@sipsolutions.net> <87zi90binm.fsf@toke.dk> <1507575007.26041.59.camel@sipsolutions.net> <87376sqda9.fsf@toke.dk> <1507712135.1998.27.camel@sipsolutions.net>
Date: Wed, 11 Oct 2017 15:50:17 +0200
Message-ID: <87zi8xpzdy.fsf@toke.dk> (sfid-20171011_155038_004571_2415E073)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Yeah, ath9k certainly gets that as part of the RX information from
>> the chip.
>
> Yeah, though there are more complex cases, e.g. with hardware A-MSDU
> deaggregation like in ath10k.

Here be dragons; noted :)

>> Well, some of the tests I did while porting ath9k to the iTXQs
>> indicated that for voice-like traffic we can get very close to the
>> same actual end-to-end latency for BE-marked traffic that we do with
>> VO-marked traffic. This is in part because the FQ sparse flow
>> prioritisation makes sure that such flows get queueing priority.
>
> That really depends on medium saturation - if that's low, then yeah,
> the difference is in the EDCA parameters and the minimum backoff,
> which isn't a huge difference if you measure end-to-end.
>
> Given saturation/congestion though, and I think we have to take this
> into account since not everyone will be using this code, there are
> measurable advantages to using VO - like in the test I mentioned where
> you can block out BE "forever".

Yup, when the medium is saturated the tradeoff might be different. My
hope is that it is possible to dynamically detect when it might be
beneficial and change behaviour based on this. I know this is maybe a
bit hand-wavy for now, but otherwise it wouldn't be research... ;)
>
>> Now obviously, there are going to be tradeoffs, and scenarios where
>> latency will suffer. But I would at least like to be able to explore
>> this, and I think with the API we are currently discussing that will
>> be possible. 
>
> I'm not sure how you envision this working with the API, since you
> still have to pull from multiple TXQs, but I have no objection to the
> API as is - I'm just not convinced that actually demoting traffic is a
> good idea :)

Sure, I realise I have some convincing to do on this point...

>> Another thing I want to explore is doing soft admission
>> control; i.e., if someone sends bulk traffic marked as VO, it will be
>> automatically demoted to BE traffic rather than locking everyone else
>> out. We've tested that with some success in the Cake scheduler, and
>> it may be applicable to WiFi as well.
>
> It seems pretty strange to do that at this level - we control what TID
> (and AC) is selected for the traffic? So why not just change at that
> level for this type of thing?
>
> You can probably even already do that with TC by re-marking the traffic
> depending on type or throughput or whatever else TC can classify on.

Mostly because I am expecting that the current queue state is an
important input variable. It's quite straight forward to (e.g.) remark
VO packets if they exceed a fixed rate. But what I want to do is demote
packets if they exceed what the network can currently handle. It may be
that visibility into the queueing is enough, though. I have yet to
actually experiment with this...

-Toke
