Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36215 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755559AbcJUOiJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 10:38:09 -0400
Received: by mail-pf0-f194.google.com with SMTP id r16so8823826pfg.3
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2016 07:38:09 -0700 (PDT)
Subject: Re: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
References: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com>
 <1477038639.4068.28.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <580A2438.7030106@gmail.com> (sfid-20161021_163813_225963_1857B138)
Date: Fri, 21 Oct 2016 09:20:40 -0500
MIME-Version: 1.0
In-Reply-To: <1477038639.4068.28.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 10/21/2016 03:30 AM, Johannes Berg wrote:
> Hi,
>
>> Userspace tends to display a wifi icon with the rssi shown as a
>> number of "signal bars", usually 4, 5, or 6.
>
> It's actually not clear to me that this is really how it should be.
> There's a point to be made that taking a more holistic "link quality"
> would be a better choice. That's related, but maybe can be a separate
> discussion.
>

Can you elaborate on this 'link quality' idea?

>> and a hysteresis value to be used in the same way as with the
>> NL80211_ATTR_CQM_RSSI_THOLD attribute, or even modify it to allow
>> multiple thresholds to be given but that would need a problematic
>> driver api change.  What would be the best way to do that?
>
> So ... I don't think there's a good way to do this at all.
>
> The problem is that you really want this to be offloaded to the device,
> *especially* if you care about low power usage, because you absolutely
> don't want to be processing each beacon (which is typically what we
> derive the data from today) in the host CPU - you want those to be
> filtered by the device so you don't wake up the host CPU every ~102ms.

Yes, this would be ideal.

>
> Without offloading to the device, your patch is actually fairly much
> pointless, because you've already woken up the host CPU, at which point
> punting to userspace probably isn't all that much more expensive over
> the cost of waking up the CPU in the first place.

Requiring user space application to process every beacon seems like a 
cop-out to me.  Kernel should provide a proper API for this.  That way 
if the hardware / drivers add offloading support for this in the future, 
userspace can be blissfully ignorant.

Not to mention that the cost of waking up the process, sending a netlink 
message, having userspace process the beacon, etc is not insignificant.

>
> Looking at the code, it seems like only a single driver could support
> this in a pseudo-offloaded fashion (iwlmvm), where all the others that
> offload it today would not be able to support this API at all, unless
> they fall back to complete software processing which, as I wrote above,
> will have far worse power consumption consequences.
>
>
> Therefore, adding this API just for mac80211 seems pretty pointless,
> especially since you're targeting this for IoT, where I expect people
> will be using full-MAC chips rather than soft-MAC, with the consequence
> of not even using mac80211-based drivers. Oops.
>

The scope is not limited to IoT devices.  This has to work everywhere. 
So we need a proper solution to report signal strength / signal quality 
without resorting to polling or having userspace process every packet on 
the WiFi device.  Suggestions?

>> The assumption is that you can't simulate the same behavior with just
>> the current NL80211_ATTR_CQM_RSSI_THOLD attribute.
>
> Is that true? Technically, it seems that perhaps if you wanted to have
> a few ranges, you could always pick one that's currently active, and
> program that into the driver/device, with a hysteresis big enough to
> extend to the edges of the next range, or something?
>
> Let's say you're currently sitting at -50dBm, and want your ranges to
> be -100..-80..-60..-40..-20. Then you could program -50dBm with
> hysteresis of 10dBm, and it'd tell you when you move below/above?
>
> This probably won't really work, the hysteresis probably won't be
> honoured precisely enough by all drivers. Or we can just fix the
> drivers, I guess. However, if you're just at the edge of your range,
> e.g. when your current signal strength is -60dBm, you'd still flip-flop
> in and out of that range continuously, although userspace could just
> program a different threshold/hysteresis for those cases as well.
>
> Anyway, not sure this can be made to work, and drivers would play ball.

This sounds really brittle.  Furthermore, we also need a facility to 
know when signal strength is getting low to trigger roaming logic.  This 
would mean sharing CQM facility between roaming & signal strength 
notifications.  As you wrote above, things become quite impractical.

Regards,
-Denis
