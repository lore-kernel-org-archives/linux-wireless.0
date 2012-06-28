Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778Ab2F1KLA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 06:11:00 -0400
Message-ID: <1340878254.4491.36.camel@jlt3.sipsolutions.net> (sfid-20120628_121112_064161_ADAF7CE3)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 28 Jun 2012 12:10:54 +0200
In-Reply-To: <CA+XVXfc9F9-FMZyBytDT-5D4KxSFfTSwbhFd2g3oxdLPNFWWxg@mail.gmail.com> (sfid-20120628_120208_348993_6A166C7D)
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
	 <1340875996.4491.29.camel@jlt3.sipsolutions.net>
	 <CA+XVXfc9F9-FMZyBytDT-5D4KxSFfTSwbhFd2g3oxdLPNFWWxg@mail.gmail.com>
	 (sfid-20120628_120208_348993_6A166C7D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-28 at 13:01 +0300, Arik Nemtsov wrote:

> >> How about somehow requiring a multi channel driver to give always
> >> Tx-ack? That will mean we can abandon the retry timers, and rely on
> >> the driver to give an answer within a reasonable time.
> >
> > That doesn't mean we can abandon the retry timers though? Then again,
> > maybe it does, we could start the timer only when we get the status
> > information I guess?
> 
> I'm not really sure why the assoc timers are there now. If it's
> because we want to be sure we gave the peer a chance to respond, well
> the Tx-ack already gives us that. Waiting any longer won't help.
> Or does waiting in general before the next Tx help with something?
> (clear temporary congestion etc).

Well the only timer there is is retrying the frame. Arguably that isn't
needed as the frame has been retried on the air already multiple times
by the hardware, but sometimes temporary channel conditions exist so
waiting 100ms until the next retry can make sense.

If we actually receive a response, we cancel all timers right away.

> > I'm not sure I'd want to *require* this, but it sounds like a good thing
> > we could do to address this possible race for drivers that do support
> > reliable status reports?
> 
> Yea. And then, if all current multi-channel drivers support Tx-ack, we
> can skip implemeting tx_sync.

We could, but I'm not sure I'd go there? It would mean that the driver
has to buffer the frame, schedule a work to do whatever it needs to sync
up, and then at the end of the work TX the frame. Since this only comes
in from contexts in mac80211 that can sleep, from a whole system
complexity POV it seems much simpler to give the driver a chance to do
whatever it needs to do before the TX even happens?

johannes

