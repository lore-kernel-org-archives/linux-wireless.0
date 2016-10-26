Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52396 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941563AbcJZNYO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 09:24:14 -0400
Message-ID: <1477487137.4059.43.camel@sipsolutions.net> (sfid-20161026_152427_620248_34887B6E)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Oct 2016 15:05:37 +0200
In-Reply-To: <F1E72F916E15444E976109681700BEE23F6AF7D9@IRSMSX102.ger.corp.intel.com>
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
         (sfid-20161021_024924_244249_6C67A54C),<1477038639.4068.28.camel@sipsolutions.net>
         <F1E72F916E15444E976109681700BEE23F6AF7D9@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 19:03 +0000, Zaborowski, Andrew wrote:

> > The problem is that you really want this to be offloaded to the
> > device, *especially* if you care about low power usage, because you
> > absolutely don't want to be processing each beacon (which is
> > typically what we derive the data from today) in the host CPU - you
> > want those to be filtered by the device so you don't wake up the
> > host CPU every ~102ms.
> 
> Right, that would be a separate optimisation but it probably won't
> arrive until there's an API that the drivers can implement, so I
> think this is a prerequisite.

Huh? No, beacon filtering is implemented by a lot of drivers today.

> The userspace switches count too and are the main motivation for this
> patch.  Eventually, as you say, things will depend on specific
> drivers and you will want to optimise whatever you can assuming the
> hardware you're constrained to.

Yes and no. I think we can probably define a reasonable subset that
you'd expect more devices to implement. I don't really see the
requirement to do the "banding" that you did here offloaded - doing it
in mac80211 won't help much, and won't work in cases where you have
beacon filtering already anyway.

Drivers like iwlwifi would be able to implement the banding in
software, since they get a notification on every change above a
configurable threshold, but other drivers like one I looked at actually
do have a low and high threshold today, and program them to be the same
value with our current CQM API definitions.

> It seems like any mechanism you choose can be implemented on top of
> hardware that supports a low and a high threshold by setting the next
> values while handling the event related to the previous threshold
> crossing event.  If the thresholds are specified by a middle value
> and a hysteresis or distance, that would work equally well.
> The API I added in the patch also allows offloading to such hardware.

Well, ok, technically the API can be implemented on top of drivers with
low/high thresholds, by doing the configuration according to the
current range you're in.

I would argue though that it makes more sense to expose a simpler
capability (e.g. two instead of the current single threshold) and do
the reprogramming from higher layers. That ends up being more flexible,
since you can then, for example, also have ranges that aren't all
identical - which makes some sense because above a certain level you
don't really care at all.

> In short a nl80211 change would be needed regardless of the mechanism
> chosen.

Agree. I'm just not convinced that the banding mechanism you propose is
the most reasonable choice for new API.

johannes
