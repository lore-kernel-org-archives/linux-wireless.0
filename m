Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59468 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750704AbdIEHDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 03:03:35 -0400
Message-ID: <1504594996.6667.2.camel@sipsolutions.net> (sfid-20170905_090351_628521_BA842A12)
Subject: Re: [PATCH 20/25] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.org>, keescook@chromium.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Tue, 05 Sep 2017 09:03:16 +0200
In-Reply-To: <20170831105827.172599262@linutronix.de>
References: <20170831105725.809317030@linutronix.de>
         <20170831105827.172599262@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-08-31 at 12:23 +0000, Anna-Maria Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Switch the timer to CLOCK_MONOTONIC_SOFT, which executed the timer
> callback in softirq context and remove the hrtimer_tasklet.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> 
This looks fine to me,

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Are you planning to integrate all patches in the series through some
other tree, perhaps to be able to get rid of the tasklet_hrtimer API,
or should I apply this?

johannes
