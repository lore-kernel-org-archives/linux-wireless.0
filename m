Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47329 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdJWKXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 06:23:23 -0400
Date: Mon, 23 Oct 2017 12:23:13 +0200 (CEST)
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
In-Reply-To: <1508753691.2639.10.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.20.1710231221520.4241@nanos> (sfid-20171023_122341_241227_7098C84B)
References: <20171022213938.940451689@linutronix.de>  <20171022214053.576969587@linutronix.de> <1508753691.2639.10.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 23 Oct 2017, Johannes Berg wrote:

> On Sun, 2017-10-22 at 23:40 +0200, Anna-Maria Gleixner wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> > callback in softirq context and remove the hrtimer_tasklet.

I can't build as its part of the whole hrtimer rework series.

> This doesn't build on my tree, due to HRTIMER_MODE_REL_SOFT not
> existing. Neither does HRTIMER_MODE_SOFT mentioned above, but that's
> just a commit log mistake.

Oops.

> (It also didn't apply on my tree, but that was a trivial context
> change.)
> 
> I don't understand why you initialize it with HRTIMER_MODE_ABS_SOFT
> either though:
> 
> > +       hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
> > +                    HRTIMER_MODE_ABS_SOFT);

Sure, though it does not matter in that case. Will fix that up.

Thanks,

	tglx
