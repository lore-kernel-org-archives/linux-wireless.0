Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47862 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2F0RFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 13:05:50 -0400
Received: by dady13 with SMTP id y13so1658395dad.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 10:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340810735.11012.44.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
 <1340707305.14634.9.camel@jlt3.sipsolutions.net> <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
 <1340795869.11012.12.camel@jlt3.sipsolutions.net> <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
 <1340807890.11012.43.camel@jlt3.sipsolutions.net> <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com>
 <1340810735.11012.44.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 27 Jun 2012 20:05:34 +0300
Message-ID: <CA+XVXffKSEL6ZQPQ98x-zO-NL2=TNF1uN==mprRyUmAaRn254g@mail.gmail.com> (sfid-20120627_190554_408564_49718279)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 6:25 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-27 at 18:20 +0300, Arik Nemtsov wrote:
>
>> > It'll depend on the driver I guess? If you're going to set a flag "give
>> > this vif priority now" on the first invocation, then you probably
>> > wouldn't care about the timing. It looks like our implementation would
>> > actually start some "give me the channel" operation and when the
>> > firmware says "ok you have the channel now" we'd return and rely on
>> > getting the TX right after.
>> >
>> > Wrt. the race, this isn't going to be something that happens within less
>> > than a millisecond or so, it's going to give us maybe 50ms at least of
>> > channel time (WFA mandates replying within 30ms), so that doesn't seem
>> > like a problem?
>>
>> It's probably not an issue. Just seems simpler to just give the skb to
>> the driver so it can do whatever it wants before/during/after. Bypass
>> op_tx completely for these.
>
> Yeah, that was one of the other options I considered in my original
> email ... but this call must be able to sleep, and the TX processing in
> mac80211 cannot sleep, so unless we bypass all processing (which seems
> wrong) that would be rather difficult to implement.

Good point. But another race to consider the the
multi-channel/multi-vif scenario, where the driver already has a lot
of packets queued up, so the time will expire before we get a chance
to Tx. Again this is not a problem in practice (since it's the VO ac).

How about somehow requiring a multi channel driver to give always
Tx-ack? That will mean we can abandon the retry timers, and rely on
the driver to give an answer within a reasonable time.
