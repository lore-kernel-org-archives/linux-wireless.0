Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44387 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161598AbbKEQnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 11:43:00 -0500
Subject: Re: Configurable scan dwell time?
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
References: <563A9B8C.3060503@candelatech.com>
 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
 <1446710205.2540.1.camel@sipsolutions.net> <563B7D63.1010203@candelatech.com>
 <1446739615.2540.6.camel@sipsolutions.net> <563B8206.1040807@candelatech.com>
 <1446740733.2540.9.camel@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <563B8713.6000401@candelatech.com> (sfid-20151105_174304_430777_B5DB4972)
Date: Thu, 5 Nov 2015 08:42:59 -0800
MIME-Version: 1.0
In-Reply-To: <1446740733.2540.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2015 08:25 AM, Johannes Berg wrote:
>
>>> The thing though is that there are now use cases in the standard(s)
>>> that want/require doing this. So just adding it as a hint will run the
>>> risk of userspace (like wpa_s) using this "hint" for implementing newer
>>> spec functionality, testing on ath9k and hwsim and declaring that it
>>> works :-) And then we're stuck with this feature being used/advertised
>>> on older devices where it doesn't actually work.
>>
>> Scanning is already best effort.  Someone implementing this new hint
>> can just be aware of the limitations.  If nothing else, start a scan on
>> a known number of channels (or single channel), see how long it takes..then you know if the
>> driver is ignoring your hint or not.
>
> But if you were asked to measure something on that channel, for a given
> amount of time while scanning, you could reasonably implement it that
> way. If you don't really know how long the device is *actually* going
> to do this, then you can't rightfully say you implement that spec.
>
> You can't really start a scan and measure the time either since there's
> no guarantee the scan will start right away.

Grep for 'dwell_time' in ath10k driver dir...it is already using different
values (active 50, passive 150) than what mac80211 does, so anyone assuming scan time is exactly some
duration is already confused.

>>> Now, having those standard use cases is actually a good argument *for*
>>> adding them in the standard API, but I think we need to be more careful
>>> around these issues - perhaps having drivers indicate that they support
>>> it, maybe even with valid ranges, etc.
>>
>> I think that is vastly over-engineering the problem, but truth is, it
>> can always be added later if there is an actual need for that knowledge.
>>
>
> Well, not really. The only way for this to work would be to outright
> reject requests that weren't within the advertised ranges; doing this
> after already having the API would break existing clients thereof.

It wouldn't break clients if the value is known to just be a hint
from the beginning..ie clients cannot ever expect that this value
is guaranteed to be used.

But, if it would help this feature get upstream, then I will work on
adding a driver flag.  Would that make it acceptable for upstream?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

