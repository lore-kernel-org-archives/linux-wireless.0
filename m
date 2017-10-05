Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:33963 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751381AbdJEVwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 17:52:13 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: nbd <nbd@nbd.name>
Subject: Re: converting mac80211 to TXQs entirely
In-Reply-To: <1507221836.2387.66.camel@sipsolutions.net>
References: <1507205618.2387.19.camel@sipsolutions.net> <1507217947.2387.60.camel@sipsolutions.net> <87efqhsgni.fsf@toke.dk> <1507221836.2387.66.camel@sipsolutions.net>
Date: Thu, 05 Oct 2017 23:52:08 +0200
Message-ID: <878tgps1o7.fsf@toke.dk> (sfid-20171005_235218_581507_7ABE9F83)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2017-10-05 at 18:28 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> I'm been thinking about how to move the airtime fairness scheduler
>> out of ath9k and into mac80211 (so more drivers can take advantage of
>> it). This will require some changes to the TXQ API that drivers speak
>> to, so wanted to add my thoughts here to make sure it's compatible
>> with your thinking.
>>=20
>> I think the easiest way to have mac80211 handle airtime fairness is
>> to add a way for ieee80211_tx_dequeue() to return some sort of DEFER
>> signal which semantically means "there is no packet for this queue
>> right now, but please keep scheduling it" (which would be the result
>> of a TXQ belonging to a station that has used its airtime quota but
>> still has packets pending). This is different from the current
>> meaning of NULL, which will make the driver stop scheduling that TXQ
>> until it gets a new wake signal.
>
> I think that's reasonable. I'm not really sure it's *necessary*
> though? Couldn't mac80211 return NULL, and then simply call
> wake_tx_queue again when the TXQ becomes eligible for scheduling
> again? Otherwise the driver might end up doing a lot of polling for it
> to become eligible again?

Theoretically, but then there would have to be some kind of callback or
another mechanism to figure out when the queue is ready again. The neat
thing about DRR scheduling is that we just use the fact that there was
an attempt to schedule the queue as an opportunity to increase that
queue's deficit by one quantum. This does give a bit of "polling
overhead" as you say, but it has been hidden in the measurement noise in
all my tests.

The obvious alternative is to do a token-based airtime scheduler, where
the airtime used by one station is immediately divided out to all active
stations. But that requires walking over all active stations on every TX
completion, and there's a lot of housekeeping to make sure we don't
accidentally starve everyone. So I'd prefer to stick with the DRR
scheduler :)

>> And I'm wondering if this "is queue stopped" API could be the same
>> one used for the airtime DEFER case?
>
> I think these are two completely different cases.
>
> The "is queue stopped" I was thinking of would be basically checking
> the variable local->queue_stop_reasons, so that the driver could still
> use the stop_queue API(s). Yeah, this would be very roundabout, but as
> a conversion step I think that'd not be a bad thing.

Ah, I see. Yeah, these are different, and the existing packet/NULL
return is probably sufficient, then :)

>> Oh, and BTW: I see this is on the list of topics for the wireless
>> summit in Seoul. How do I go about signing up for that? I'll be at
>> netdev talking about some of this stuff anyway[1] :)
>
> Just show up there, or you can add yourself to the list on the wiki
> page :)

Cool, I did. See you in Seoul :)

-Toke
