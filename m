Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42548 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934208AbcJ0Smy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 14:42:54 -0400
Message-ID: <1477593768.4534.26.camel@sipsolutions.net> (sfid-20161027_204257_996379_95A611F4)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        "Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 27 Oct 2016 20:42:48 +0200
In-Reply-To: <581243A0.3070907@gmail.com> (sfid-20161027_201251_959616_3727A6AF)
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
         <1477038639.4068.28.camel@sipsolutions.net>
         <F1E72F916E15444E976109681700BEE23F6AF7D9@IRSMSX102.ger.corp.intel.com>
         <1477487137.4059.43.camel@sipsolutions.net> <581243A0.3070907@gmail.com>
         (sfid-20161027_201251_959616_3727A6AF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Pardon a dumb question, but can filtering be turned off?  I doubt
> anyone would want to, but just wondering.

Generally I assume that a typical device/firmware will be able to turn
it off (I know ours can), but we don't think we even provide a knob for
it for anyone to request it, so you'd have to modify the driver.

> Is there anything you have in mind?  Our goal is to minimize 
> hardware-kernel-userspace wakeups.  With the nl80211 API as it is
> today, it doesn't seem feasible to do anything besides
> polling.  Whatever we come up with will surely be better than that.

I was thinking of just providing two thresholds, since you should be
able to emulate more of them with that, without much cost.

> So you're thinking of having high and low threshold.  So we'd get an 
> event when we're higher than the high threshold and lower than the
> low threshold, right?  

I'm mostly handwaving, but yes.

> Then we'd need to bootstrap our current rssi somehow, or do we get
> another event?  I'm guessing we're going to have some race condition
> issues?

Generally, with CQM, when you initially program it you get an event
telling you where you're at right now - so hopefully you'd get "middle"
(rather than "low"/"high") with the actual signal falling squarely into
your range, and from there on you're pretty much good to go.

> Would using an n-threshold API be possible?  That way user space can 
> program in whatever threholds once, and then the kernel would figure
> out how to support that given the relevant hardware capabilities.

That seems like a reasonable idea. We'd want to have code in cfg80211
that does the emulation as we discussed above, so that from a userspace
POV an "arbitrary" number of thresholds is supported (if the capability
is supported at all, which would depend on the device doing >=2
thresholds).

johannes
