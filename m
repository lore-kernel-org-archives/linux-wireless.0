Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44097 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbbKEQV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 11:21:27 -0500
Subject: Re: Configurable scan dwell time?
To: Johannes Berg <johannes@sipsolutions.net>,
	Michal Kazior <michal.kazior@tieto.com>
References: <563A9B8C.3060503@candelatech.com>
 <CA+BoTQnYrFSLkdBgcMgnuJPvPeSjuu9oB68KkU7jRMEH5iFE2A@mail.gmail.com>
 <1446710205.2540.1.camel@sipsolutions.net> <563B7D63.1010203@candelatech.com>
 <1446739615.2540.6.camel@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <563B8206.1040807@candelatech.com> (sfid-20151105_172131_747677_B73747D3)
Date: Thu, 5 Nov 2015 08:21:26 -0800
MIME-Version: 1.0
In-Reply-To: <1446739615.2540.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2015 08:06 AM, Johannes Berg wrote:
> On Thu, 2015-11-05 at 08:01 -0800, Ben Greear wrote:
>
>> My issue is that APs can be set to beacon at longer beacon times, and
>> then passive scanning at ~110ms intervals is not going to find the APs
>> very often (and with bad luck, technically it could *never* find the AP
>> due to scanning at unlucky periodic intervals).
>
> Which is probably why hardly anyone ever uses longer beacon intervals
> (also the added latency with powersave, of course)
>
>> So, when I know that I am doing passive scan, I would like the option
>> to set the dwell time larger.
>>
>> And, for active scanning, maybe 33ms is a lot longer that is actually
>> needed?
>
> There are some (WFA?) requirements to answer within 30ms, but not
> faster, so I think that's the reason for this value.

An AP could (and in my experience, does) answer probes much faster.

(With ath9k and ath10k AP, I see probe response within 1ms in a sniff I just did).

So, doing active scans you could *often* do an entire spectrum
scan 10 times faster than what we see today.

A supplicant could request a fast time, and then if that didn't find anything,
the next scan could be slower as needed.

>> I read through some of your comments from before.  I think we could
>> treat this as a hint to the driver, and it could ignore it as needed.
>>
>> Firmware implementations I'm aware of are already limited in a million
>> different ways, and of course if someone cared, they could propagate
>> the dwell time into the firmware if they cared.
>>
>
> The thing though is that there are now use cases in the standard(s)
> that want/require doing this. So just adding it as a hint will run the
> risk of userspace (like wpa_s) using this "hint" for implementing newer
> spec functionality, testing on ath9k and hwsim and declaring that it
> works :-) And then we're stuck with this feature being used/advertised
> on older devices where it doesn't actually work.

Scanning is already best effort.  Someone implementing this new hint
can just be aware of the limitations.  If nothing else, start a scan on
a known number of channels (or single channel), see how long it takes..then you know if the
driver is ignoring your hint or not.

> Now, having those standard use cases is actually a good argument *for*
> adding them in the standard API, but I think we need to be more careful
> around these issues - perhaps having drivers indicate that they support
> it, maybe even with valid ranges, etc.

I think that is vastly over-engineering the problem, but truth is, it
can always be added later if there is an actual need for that knowledge.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

