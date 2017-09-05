Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:44407 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750703AbdIEIts (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 04:49:48 -0400
Date: Tue, 5 Sep 2017 10:49:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.org>, keescook@chromium.org,
        John Stultz <john.stultz@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 20/25] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
In-Reply-To: <1504594996.6667.2.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.20.1709051047360.1900@nanos> (sfid-20170905_105003_742428_D03C9E73)
References: <20170831105725.809317030@linutronix.de>  <20170831105827.172599262@linutronix.de> <1504594996.6667.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 5 Sep 2017, Johannes Berg wrote:
> On Thu, 2017-08-31 at 12:23 +0000, Anna-Maria Gleixner wrote:
> > From: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Switch the timer to CLOCK_MONOTONIC_SOFT, which executed the timer
> > callback in softirq context and remove the hrtimer_tasklet.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> > Cc: Johannes Berg <johannes@sipsolutions.net>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: linux-wireless@vger.kernel.org
> > 
> This looks fine to me,
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Are you planning to integrate all patches in the series through some
> other tree, perhaps to be able to get rid of the tasklet_hrtimer API,
> or should I apply this?

The patch depends on the hrtimer core changes, so we either delay the
removal for a release cycle or just take the whole lot through
tip:timers/core and get rid of it in one go.

Thanks,

	tglx
