Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63388 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2F1KCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:02:01 -0400
Received: by dady13 with SMTP id y13so2661889dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 03:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340875996.4491.29.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
 <1340707305.14634.9.camel@jlt3.sipsolutions.net> <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
 <1340795869.11012.12.camel@jlt3.sipsolutions.net> <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
 <1340807890.11012.43.camel@jlt3.sipsolutions.net> <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com>
 <1340810735.11012.44.camel@jlt3.sipsolutions.net> <CA+XVXffKSEL6ZQPQ98x-zO-NL2=TNF1uN==mprRyUmAaRn254g@mail.gmail.com>
 <1340875996.4491.29.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 28 Jun 2012 13:01:45 +0300
Message-ID: <CA+XVXfc9F9-FMZyBytDT-5D4KxSFfTSwbhFd2g3oxdLPNFWWxg@mail.gmail.com> (sfid-20120628_120209_201034_5B199F3C)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 12:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-27 at 20:05 +0300, Arik Nemtsov wrote:
>
>> > Yeah, that was one of the other options I considered in my original
>> > email ... but this call must be able to sleep, and the TX processing in
>> > mac80211 cannot sleep, so unless we bypass all processing (which seems
>> > wrong) that would be rather difficult to implement.
>>
>> Good point. But another race to consider the the
>> multi-channel/multi-vif scenario, where the driver already has a lot
>> of packets queued up, so the time will expire before we get a chance
>> to Tx. Again this is not a problem in practice (since it's the VO ac).
>
> If the vif is on a different channel, the driver really should assign it
> different queues and then there shouldn't be much queued up, right?
> Also, if you really have >100ms latency on your queues, you have a major
> problem anyway I'd think?

Yea. It's all only theoretical :)

>
>> How about somehow requiring a multi channel driver to give always
>> Tx-ack? That will mean we can abandon the retry timers, and rely on
>> the driver to give an answer within a reasonable time.
>
> That doesn't mean we can abandon the retry timers though? Then again,
> maybe it does, we could start the timer only when we get the status
> information I guess?

I'm not really sure why the assoc timers are there now. If it's
because we want to be sure we gave the peer a chance to respond, well
the Tx-ack already gives us that. Waiting any longer won't help.
Or does waiting in general before the next Tx help with something?
(clear temporary congestion etc).

>
> I'm not sure I'd want to *require* this, but it sounds like a good thing
> we could do to address this possible race for drivers that do support
> reliable status reports?

Yea. And then, if all current multi-channel drivers support Tx-ack, we
can skip implemeting tx_sync.
