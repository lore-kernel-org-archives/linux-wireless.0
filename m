Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33018 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964989AbcJ0SV5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Oct 2016 14:21:57 -0400
Received: by mail-pf0-f176.google.com with SMTP id 197so22210392pfu.0
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2016 11:21:56 -0700 (PDT)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        "Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
 <1477038639.4068.28.camel@sipsolutions.net>
 <F1E72F916E15444E976109681700BEE23F6AF7D9@IRSMSX102.ger.corp.intel.com>
 <1477487137.4059.43.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <581243A0.3070907@gmail.com> (sfid-20161027_202219_657859_2F875B49)
Date: Thu, 27 Oct 2016 13:12:48 -0500
MIME-Version: 1.0
In-Reply-To: <1477487137.4059.43.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

 > Huh? No, beacon filtering is implemented by a lot of drivers today.

Pardon a dumb question, but can filtering be turned off?  I doubt anyone 
would want to, but just wondering.

>
>> The userspace switches count too and are the main motivation for this
>> patch.  Eventually, as you say, things will depend on specific
>> drivers and you will want to optimise whatever you can assuming the
>> hardware you're constrained to.
>
> Yes and no. I think we can probably define a reasonable subset that
> you'd expect more devices to implement. I don't really see the
> requirement to do the "banding" that you did here offloaded - doing it
> in mac80211 won't help much, and won't work in cases where you have
> beacon filtering already anyway.

Is there anything you have in mind?  Our goal is to minimize 
hardware-kernel-userspace wakeups.  With the nl80211 API as it is today, 
it doesn't seem feasible to do anything besides polling.  Whatever we 
come up with will surely be better than that.

> Well, ok, technically the API can be implemented on top of drivers with
> low/high thresholds, by doing the configuration according to the
> current range you're in.

So you're thinking of having high and low threshold.  So we'd get an 
event when we're higher than the high threshold and lower than the low 
threshold, right?  Then we'd need to bootstrap our current rssi somehow, 
or do we get another event?  I'm guessing we're going to have some race 
condition issues?

>
> I would argue though that it makes more sense to expose a simpler
> capability (e.g. two instead of the current single threshold) and do
> the reprogramming from higher layers. That ends up being more flexible,
> since you can then, for example, also have ranges that aren't all
> identical - which makes some sense because above a certain level you
> don't really care at all.

It seems like we'd be limiting ourselves here.  Couple reasons that come 
to mind:
- This would still require user space to keep re-setting the new 
thresholds.  While the wakeups are much less frequent than with polling 
for example, they still add up.  Scheduling userspace, processing 
nl80211 messages, etc is still a cost.
- It feels like we're exposing a lowest-common-denominator API with no 
possibility of offload / optimization in the future.  E.g. even drivers 
that can support arbitrary number of thresholds will be boxed in.

Would using an n-threshold API be possible?  That way user space can 
program in whatever threholds once, and then the kernel would figure out 
how to support that given the relevant hardware capabilities.

>
>> In short a nl80211 change would be needed regardless of the mechanism
>> chosen.
>
> Agree. I'm just not convinced that the banding mechanism you propose is
> the most reasonable choice for new API.
>

Understood, but it was just a stab in the dark to get this discussion 
started.

Regards,
-Denis
