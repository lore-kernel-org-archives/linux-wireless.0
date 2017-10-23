Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45756 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdJWKPE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Oct 2017 06:15:04 -0400
Message-ID: <1508753691.2639.10.camel@sipsolutions.net> (sfid-20171023_121532_382776_F790FAE0)
Subject: Re: [PATCH v2 31/37] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Mon, 23 Oct 2017 12:14:51 +0200
In-Reply-To: <20171022214053.576969587@linutronix.de>
References: <20171022213938.940451689@linutronix.de>
         <20171022214053.576969587@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-10-22 at 23:40 +0200, Anna-Maria Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> callback in softirq context and remove the hrtimer_tasklet.

This doesn't build on my tree, due to HRTIMER_MODE_REL_SOFT not
existing. Neither does HRTIMER_MODE_SOFT mentioned above, but that's
just a commit log mistake.

(It also didn't apply on my tree, but that was a trivial context
change.)

I don't understand why you initialize it with HRTIMER_MODE_ABS_SOFT
either though:

> +       hrtimer_init(&data->beacon_timer, CLOCK_MONOTONIC,
> +                    HRTIMER_MODE_ABS_SOFT);

shouldn't that already be REL?

johannes
