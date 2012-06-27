Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2F0PZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:25:38 -0400
Message-ID: <1340810735.11012.44.camel@jlt3.sipsolutions.net> (sfid-20120627_172717_899467_DB02BF0A)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 27 Jun 2012 17:25:35 +0200
In-Reply-To: <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com> (sfid-20120627_172101_975306_3DA213AA)
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	 <1340707305.14634.9.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
	 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
	 <1340795869.11012.12.camel@jlt3.sipsolutions.net>
	 <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
	 <1340807890.11012.43.camel@jlt3.sipsolutions.net>
	 <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com>
	 (sfid-20120627_172101_975306_3DA213AA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-27 at 18:20 +0300, Arik Nemtsov wrote:

> > It'll depend on the driver I guess? If you're going to set a flag "give
> > this vif priority now" on the first invocation, then you probably
> > wouldn't care about the timing. It looks like our implementation would
> > actually start some "give me the channel" operation and when the
> > firmware says "ok you have the channel now" we'd return and rely on
> > getting the TX right after.
> >
> > Wrt. the race, this isn't going to be something that happens within less
> > than a millisecond or so, it's going to give us maybe 50ms at least of
> > channel time (WFA mandates replying within 30ms), so that doesn't seem
> > like a problem?
> 
> It's probably not an issue. Just seems simpler to just give the skb to
> the driver so it can do whatever it wants before/during/after. Bypass
> op_tx completely for these.

Yeah, that was one of the other options I considered in my original
email ... but this call must be able to sleep, and the TX processing in
mac80211 cannot sleep, so unless we bypass all processing (which seems
wrong) that would be rather difficult to implement.

johannes

