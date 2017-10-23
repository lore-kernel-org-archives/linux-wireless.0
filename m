Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47389 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbdJWKdl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 06:33:41 -0400
Date: Mon, 23 Oct 2017 12:33:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 31/37] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
In-Reply-To: <1508754350.2639.12.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.20.1710231227050.4241@nanos> (sfid-20171023_123356_469312_4009999F)
References: <20171022213938.940451689@linutronix.de>   <20171022214053.576969587@linutronix.de>  <1508753691.2639.10.camel@sipsolutions.net>  <alpine.DEB.2.20.1710231221520.4241@nanos> <1508754350.2639.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Oct 2017, Johannes Berg wrote:
> On Mon, 2017-10-23 at 12:23 +0200, Thomas Gleixner wrote:
> > On Mon, 23 Oct 2017, Johannes Berg wrote:
> > 
> > > On Sun, 2017-10-22 at 23:40 +0200, Anna-Maria Gleixner wrote:
> > > > From: Thomas Gleixner <tglx@linutronix.de>
> > > > 
> > > > Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> > > > callback in softirq context and remove the hrtimer_tasklet.
> > 
> > I can't build as its part of the whole hrtimer rework series.
> 
> I guess you mean you *can* build it? Surely you're introducing the new
> HR timer modes in some patch that I didn't see? :-)

Sorry, we did not want to expose you to 30 patches fiddling with the core
code. They are on LKML though.

> > > > +       hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
> > > > +                    HRTIMER_MODE_ABS_SOFT);
> > 
> > Sure, though it does not matter in that case. Will fix that up.
> 
> Right. Then again, why even pass it to init() and start()? Can you
> start without going through start()?

There is a subtle magic with CLOCK_REALTIME timers.

CLOCK_REALTIME timers differentiate between ABS and REL modes. ABS timers
are exposed to clock modifications (settimeofday() ...), REL timers are
not. We solve that by associating them to different clock bases, which has
to be done at init time, but the start function needs the REL/ABS
information as well.

For CLOCK_MONOTONIC this is not really required, but the function is used
for all clock bases, so we require the mode bits for all.

Thanks,

	tglx
