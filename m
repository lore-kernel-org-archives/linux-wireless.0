Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46028 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdJWKZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 06:25:58 -0400
Message-ID: <1508754350.2639.12.camel@sipsolutions.net> (sfid-20171023_122614_120625_C43F8889)
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
Date: Mon, 23 Oct 2017 12:25:50 +0200
In-Reply-To: <alpine.DEB.2.20.1710231221520.4241@nanos>
References: <20171022213938.940451689@linutronix.de>
          <20171022214053.576969587@linutronix.de>
         <1508753691.2639.10.camel@sipsolutions.net>
         <alpine.DEB.2.20.1710231221520.4241@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-10-23 at 12:23 +0200, Thomas Gleixner wrote:
> On Mon, 23 Oct 2017, Johannes Berg wrote:
> 
> > On Sun, 2017-10-22 at 23:40 +0200, Anna-Maria Gleixner wrote:
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > > 
> > > Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> > > callback in softirq context and remove the hrtimer_tasklet.
> 
> I can't build as its part of the whole hrtimer rework series.

I guess you mean you *can* build it? Surely you're introducing the new
HR timer modes in some patch that I didn't see? :-)

> > > +       hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
> > > +                    HRTIMER_MODE_ABS_SOFT);
> 
> Sure, though it does not matter in that case. Will fix that up.

Right. Then again, why even pass it to init() and start()? Can you
start without going through start()?

johannes
