Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52097 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752505AbcJUIam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 04:30:42 -0400
Message-ID: <1477038639.4068.28.camel@sipsolutions.net> (sfid-20161021_103046_727647_0EBAC171)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Fri, 21 Oct 2016 10:30:39 +0200
In-Reply-To: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com> (sfid-20161021_024924_244249_6C67A54C)
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
         (sfid-20161021_024924_244249_6C67A54C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Userspace tends to display a wifi icon with the rssi shown as a
> number of "signal bars", usually 4, 5, or 6.

It's actually not clear to me that this is really how it should be.
There's a point to be made that taking a more holistic "link quality"
would be a better choice. That's related, but maybe can be a separate
discussion.

> and a hysteresis value to be used in the same way as with the
> NL80211_ATTR_CQM_RSSI_THOLD attribute, or even modify it to allow
> multiple thresholds to be given but that would need a problematic
> driver api change.  What would be the best way to do that?

So ... I don't think there's a good way to do this at all.

The problem is that you really want this to be offloaded to the device,
*especially* if you care about low power usage, because you absolutely
don't want to be processing each beacon (which is typically what we
derive the data from today) in the host CPU - you want those to be
filtered by the device so you don't wake up the host CPU every ~102ms.

Without offloading to the device, your patch is actually fairly much
pointless, because you've already woken up the host CPU, at which point
punting to userspace probably isn't all that much more expensive over
the cost of waking up the CPU in the first place.

Looking at the code, it seems like only a single driver could support
this in a pseudo-offloaded fashion (iwlmvm), where all the others that
offload it today would not be able to support this API at all, unless
they fall back to complete software processing which, as I wrote above,
will have far worse power consumption consequences.


Therefore, adding this API just for mac80211 seems pretty pointless,
especially since you're targeting this for IoT, where I expect people
will be using full-MAC chips rather than soft-MAC, with the consequence
of not even using mac80211-based drivers. Oops.

> The assumption is that you can't simulate the same behavior with just
> the current NL80211_ATTR_CQM_RSSI_THOLD attribute.

Is that true? Technically, it seems that perhaps if you wanted to have
a few ranges, you could always pick one that's currently active, and
program that into the driver/device, with a hysteresis big enough to
extend to the edges of the next range, or something?

Let's say you're currently sitting at -50dBm, and want your ranges to
be -100..-80..-60..-40..-20. Then you could program -50dBm with
hysteresis of 10dBm, and it'd tell you when you move below/above?

This probably won't really work, the hysteresis probably won't be
honoured precisely enough by all drivers. Or we can just fix the
drivers, I guess. However, if you're just at the edge of your range,
e.g. when your current signal strength is -60dBm, you'd still flip-flop 
in and out of that range continuously, although userspace could just
program a different threshold/hysteresis for those cases as well.

Anyway, not sure this can be made to work, and drivers would play ball.

Nevertheless, somewhere along these lines we could probably make things
work better than hard-coding the kind of assumptions you have in your
patch. Perhaps by extending this to know about low/medium/high, which a
number of drivers seem to support, so that you can program -60,-40
(with some appropriate hysteresis) and then get a signal when you move
out of that range towards low or towards high. When that's stable
enough, you can then dynamically reconfigure to the next range.

johannes
