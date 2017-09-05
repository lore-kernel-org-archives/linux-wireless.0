Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60754 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdIEIwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 04:52:05 -0400
Message-ID: <1504601504.6667.4.camel@sipsolutions.net> (sfid-20170905_105321_249204_0113841D)
Subject: Re: [PATCH 20/25] mac80211_hwsim: Replace hrtimer tasklet with
 softirq hrtimer
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Anna-Maria Gleixner <anna-maria@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.org>, keescook@chromium.org,
        John Stultz <john.stultz@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Date: Tue, 05 Sep 2017 10:51:44 +0200
In-Reply-To: <alpine.DEB.2.20.1709051047360.1900@nanos>
References: <20170831105725.809317030@linutronix.de>
          <20170831105827.172599262@linutronix.de>
         <1504594996.6667.2.camel@sipsolutions.net>
         <alpine.DEB.2.20.1709051047360.1900@nanos>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-09-05 at 10:49 +0200, Thomas Gleixner wrote:
> 
> > Are you planning to integrate all patches in the series through
> > some other tree, perhaps to be able to get rid of the
> > tasklet_hrtimer API, or should I apply this?
> 
> The patch depends on the hrtimer core changes, so we either delay the
> removal for a release cycle or just take the whole lot through
> tip:timers/core and get rid of it in one go.

Ok. For now then I'll assume that it'll go through tip; if not please
resend when it's appropriate.

Thanks,
johannes
