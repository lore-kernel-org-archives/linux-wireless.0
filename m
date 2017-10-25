Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45870 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdJYOnN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 10:43:13 -0400
Subject: Re: A good way to get CSI info to user-space?
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <6f9182c4-cff9-066c-173a-00d09af7c903@candelatech.com>
 <1508790635.2639.24.camel@sipsolutions.net>
 <76d6a1ad-2dc4-0542-808f-4be459c3508a@candelatech.com>
 <1508824462.2639.25.camel@sipsolutions.net>
 <d1746cd6-d889-a253-3638-8011d1ebd4fb@candelatech.com>
 <1508852310.2639.29.camel@sipsolutions.net>
 <b52bbc61-f0b5-5e9a-cce3-011fd43e6c8d@candelatech.com>
 <1508853316.2639.31.camel@sipsolutions.net>
 <4e1f9cc5-5689-93fb-0c02-115e03268c1d@neratec.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <73fbd13f-50bb-b8c1-657b-ab2cfe015dc8@candelatech.com> (sfid-20171025_164316_994755_AF0540EA)
Date: Wed, 25 Oct 2017 07:43:05 -0700
MIME-Version: 1.0
In-Reply-To: <4e1f9cc5-5689-93fb-0c02-115e03268c1d@neratec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 10/25/2017 07:30 AM, Zefir Kurtisi wrote:
> Hi Ben,
>
> On 10/24/2017 03:55 PM, Johannes Berg wrote:
>> On Tue, 2017-10-24 at 06:50 -0700, Ben Greear wrote:
>> [...]
>>> Anyone know if there is a useful way to stream events from debugfs
>>> and/or sysfs w/out having to busy-poll on it?
>>
>> There's relayfs, which is kinda built for that. You could even use
>> netlink vendor events, but I don't really think netlink is appropriate
>> here.
>>
> This is what I would also suggest, alas it is not clear if the events need to be
> processed realtime.
>
> The relayfs is used to stream the spectral data from ath9k (and afaik also from
> ath10k) to userspace. Very easy to implement: kernel pushes TLVs into the relayfs,
> userspace pulls them.
>
> It is 'realtime-enough' to display realtime spectral graphs, but since you are
> reading the stream in buffer-slices, you have to wait for a slice to fill up
> before it is available at userspace (or you flush every TLV at kernel side, which
> kills efficiency).
>
> That is: if you need to immediately process events, relayfs is maybe not the right
> choice, if you can process them in bulk, that's the most efficient way to go.

The netlink vendor API seems to do exactly what I was hoping for earlier,
so I have started poking at that.

There is at least one other set of 'per-peer tx-beamforming' data that might be worth
exporting via the same mechanism.

Any particular reason why relayfs would be better than netlink?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
