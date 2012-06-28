Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab2F1JdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:33:18 -0400
Message-ID: <1340875996.4491.29.camel@jlt3.sipsolutions.net> (sfid-20120628_113322_586754_1877B532)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 11:33:16 +0200
In-Reply-To: <CA+XVXffKSEL6ZQPQ98x-zO-NL2=TNF1uN==mprRyUmAaRn254g@mail.gmail.com> (sfid-20120627_190553_569348_1D8F81B7)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 <1340795869.11012.12.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
	 <1340807890.11012.43.camel@jlt3.sipsolutions.net>
	 <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com>
	 <1340810735.11012.44.camel@jlt3.sipsolutions.net>
	 <CA+XVXffKSEL6ZQPQ98x-zO-NL2=TNF1uN==mprRyUmAaRn254g@mail.gmail.com>
	 (sfid-20120627_190553_569348_1D8F81B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 20:05 +0300, Arik Nemtsov wrote:

> > Yeah, that was one of the other options I considered in my original
> > email ... but this call must be able to sleep, and the TX processing in
> > mac80211 cannot sleep, so unless we bypass all processing (which seems
> > wrong) that would be rather difficult to implement.
> 
> Good point. But another race to consider the the
> multi-channel/multi-vif scenario, where the driver already has a lot
> of packets queued up, so the time will expire before we get a chance
> to Tx. Again this is not a problem in practice (since it's the VO ac).

If the vif is on a different channel, the driver really should assign it
different queues and then there shouldn't be much queued up, right?
Also, if you really have >100ms latency on your queues, you have a major
problem anyway I'd think?

> How about somehow requiring a multi channel driver to give always
> Tx-ack? That will mean we can abandon the retry timers, and rely on
> the driver to give an answer within a reasonable time.

That doesn't mean we can abandon the retry timers though? Then again,
maybe it does, we could start the timer only when we get the status
information I guess?

I'm not sure I'd want to *require* this, but it sounds like a good thing
we could do to address this possible race for drivers that do support
reliable status reports?

johannes

