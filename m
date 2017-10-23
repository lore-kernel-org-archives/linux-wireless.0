Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46384 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdJWKmw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 06:42:52 -0400
Message-ID: <1508755364.2639.19.camel@sipsolutions.net> (sfid-20171023_124315_029605_AF820EA1)
Subject: Re: [PATCH v2 31/37] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Mon, 23 Oct 2017 12:42:44 +0200
In-Reply-To: <alpine.DEB.2.20.1710231227050.4241@nanos>
References: <20171022213938.940451689@linutronix.de>
           <20171022214053.576969587@linutronix.de>
          <1508753691.2639.10.camel@sipsolutions.net>
          <alpine.DEB.2.20.1710231221520.4241@nanos>
         <1508754350.2639.12.camel@sipsolutions.net>
         <alpine.DEB.2.20.1710231227050.4241@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I guess you mean you *can* build it? Surely you're introducing the new
> > HR timer modes in some patch that I didn't see? :-)
> 
> Sorry, we did not want to expose you to 30 patches fiddling with the core
> code. They are on LKML though.

Sure, no worries. I just didn't even realize I shouldn't be applying
the patch (myself) :-)

> > Right. Then again, why even pass it to init() and start()? Can you
> > start without going through start()?
> 
> There is a subtle magic with CLOCK_REALTIME timers.
> 
> CLOCK_REALTIME timers differentiate between ABS and REL modes. ABS timers
> are exposed to clock modifications (settimeofday() ...), REL timers are
> not. We solve that by associating them to different clock bases, which has
> to be done at init time, but the start function needs the REL/ABS
> information as well.
> 
> For CLOCK_MONOTONIC this is not really required, but the function is used
> for all clock bases, so we require the mode bits for all.

Hmm. Couldn't you just store that then from init to use in start?

If you don't store it, yet don't verify that you passed the same 
thing, do you at least check that it's compatible? Sounds like
something will totally go wrong if I pass CLOCK_REALTIME/ABS first and
then use REL for start, or vice versa?

Also, in the code I see only checking

if (mode != HRTIMER_MODE_ABS) {
	// change clock ID:
	// realtime -> monotonic
	// realtime_soft -> monotonic_soft
}

but you're passing HRTIMER_MODE_ABS_SOFT too, isn't that considered an
ABS mode?

But then, looking at the code again, I don't even see
HRTIMER_MODE_ABS_SOFT existing, it sounds like it should be

hrtimer_init(..., CLOCK_REALTIME_SOFT, HRTIMER_MODE_REL);

then?

At least then the code I mentioned above makes sense, but it still
feels pretty dangerous to not just store the mode and use it in start,
but to require passing it again. You even just introduced the same bug,
it just happened to not matter in this case since the clock isn't
realtime.

Or am I completely confused now?

johannes
