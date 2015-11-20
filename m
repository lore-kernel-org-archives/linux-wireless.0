Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58375 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbbKTQE4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2015 11:04:56 -0500
Message-ID: <564F44A7.10900@candelatech.com> (sfid-20151120_170459_879915_535E5D04)
Date: Fri, 20 Nov 2015 08:04:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Configurable scan dwell time?
References: <563A9B8C.3060503@candelatech.com>	 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>	 <1446710205.2540.1.camel@sipsolutions.net>	 <563B7D63.1010203@candelatech.com>	 <1446739615.2540.6.camel@sipsolutions.net>	 <563B8206.1040807@candelatech.com>	 <1446740733.2540.9.camel@sipsolutions.net>	 <563B8713.6000401@candelatech.com> <1448021125.3141.37.camel@sipsolutions.net>
In-Reply-To: <1448021125.3141.37.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/20/2015 04:05 AM, Johannes Berg wrote:
> On Thu, 2015-11-05 at 08:42 -0800, Ben Greear wrote:
>
>> Grep for 'dwell_time' in ath10k driver dir...it is already using
>> different values (active 50, passive 150) than what mac80211 does, so
>> anyone assuming scan time is exactly some duration is already
>> confused.
>
> Sure, you can even grep more carefully and notice that in certain cases
> iwlwifi/mvm doesn't even have control over the dwell times as they're
> handled entirely in firmware, and the firmware might do stranger things
> still.
>
> In the future, with FILS, scanning is going to get more complicated and
> will likely have to jump around channels, hitting each one two or more
> times.
>
> But that's kinda my point - we have lots of different ways to do
> scanning today. Assuming anything about it, other than that'll
> eventually return scan results, is pointless.
>
> You're arguing though that dwell time should be controllable. This can
> be a problem:
>
>> It wouldn't break clients if the value is known to just be a hint
>> from the beginning..ie clients cannot ever expect that this value
>> is guaranteed to be used.
>
> Then I fail to see the use-case for this. If there's an actual
> requirement to do scanning with a changed dwell time, then you really
> will need to know that it is going to work/has worked. If you don't
> really care, why would you specify a hint?

What about this for a use case:

Goal is to scan very quickly and get onto a network much faster than today's
scan allows.

Implementation:  If supplicant is so configured, do first scan with
the configured scan time (assume it is short, maybe 3-5ms).

If no scan results are found, scan at default rates.  Supplicant
could alternate between fast and slow as desired.

For any driver that can implement fast scanning, and for APs that
can answer probes quickly, then we are likely to get onto the
network with the first fast scan.

And if not, then the subsequent slower scans should do the trick.

Second use case is with passive scanning when the user knows or suspects APs
may be configured with longer than normal beacon times.  Implementation
is to configure longer-than-default scan dwell times in order to
more likely see the beacons on the first scan attempt.


> This isn't really an optimisation that you can safely ignore. It has
> massive impact on the scan scheduling/timing.
>
>> But, if it would help this feature get upstream, then I will work on
>> adding a driver flag.  Would that make it acceptable for upstream?
>
> I think you really should more clearly define the use case for this
> first. If it's just a debug (or similar) thing, why even bother, we can
> just put it into ath10k debugfs?
>
> I'll agree that many of the software implementation are pretty simple
> today and could implement this fairly easily, but I don't want us to
> cut off the path towards other things like FILS in the future by using
> something like this. Especially without a well-defined use-case.
>
> Jouni mentioned once to me that there is actually a spec use case for
> something like that, but I'm not sure if it's really scanning or
> measurement? In any case, even if that's scanning, it should really be
> understood to apply to those use cases only, and not be used
> indiscriminately, since using it will cut off the ability of using
> current and future optimisations.

To be honest, I am having a hard time figuring out any real downside
to my suggestion.  If you need to implement something different in
the future, then just do that and deprecate configurable dwell time
(or just configure it to defaults in supplicant) if that conflicts
with your new and better feature.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
