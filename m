Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42576 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKL1h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:27:37 -0500
Message-ID: <1512991648.26976.71.camel@sipsolutions.net> (sfid-20171211_122845_008159_7C089531)
Subject: Re: [PATCH v3 31/36] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, keescook@chromium.org,
        Christoph Hellwig <hch@lst.de>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 11 Dec 2017 12:27:28 +0100
In-Reply-To: <20171129153101.27297-32-anna-maria@linutronix.de>
References: <20171129153101.27297-1-anna-maria@linutronix.de>
         <20171129153101.27297-32-anna-maria@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-29 at 16:30 +0100, Anna-Maria Gleixner wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Switch the timer to HRTIMER_MODE_SOFT, which executed the timer
> callback in softirq context and remove the hrtimer_tasklet.

You didn't change the commit log to HRTIMER_MODE_REL_SOFT, but
otherwise looks good to me.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net

johannes
