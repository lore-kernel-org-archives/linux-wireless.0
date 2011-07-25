Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35705 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1GYT4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 15:56:39 -0400
Message-ID: <4E2DCA73.3050103@candelatech.com> (sfid-20110725_215643_023615_6A6DC34E)
Date: Mon, 25 Jul 2011 12:56:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>	<1311607763-12603-3-git-send-email-eliad@wizery.com>	<4E2DA564.5070305@candelatech.com> <CAB3XZEcu68SZ0-cAt5-ZAvmp31mafcx856p26BRRcNOSs3Lt1A@mail.gmail.com>
In-Reply-To: <CAB3XZEcu68SZ0-cAt5-ZAvmp31mafcx856p26BRRcNOSs3Lt1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 12:16 PM, Eliad Peller wrote:
> hi Ben,
>
> On Mon, Jul 25, 2011 at 8:18 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>>
>>> The hw is currently not configured when going
>>> back on-channel.
>>
>> I am less sure about this patch.  With the existing code,
>> I think it should catch going from on channel to off
>> and do the hw config properly.
>>
> IIUC, this code is responsible for going back on-channel (if there is
> no started work on the tmp_channel).
>
>> With your change it will also reconfig the hardware, but it will
>> reconfig even if we were already on-channel (if, for instance,
>> local->tmp_channel is oper-channel), right?
>>
>> Can you please explain in more detail how this code is
>> broken?
>>
> we should reconfigure the hardware iff the hardware is not configured
> to the operational channel.
> the current code doesn't handle it (e.g. oper_channel=1,
> tmp_channel=11, hw_channel=11. since
> ieee80211_cfg_on_oper_channel(local) == 0, the hw won't go back
> on-channel).

If we are off-channel when entering that block of code, then tmp_channel
!= NULL, and on_oper_chan will be false.

Then, we set tmp_channel to NULL, which should make ieee80211_cfg_on_oper_channel
true.

So, the hw_config will happen.

Or am I missing something?

Thanks,
Ben

>
> i don't think it will reconfig if we are already on-channel, as in
> this case oper_channel == hw_channel.
>
> thanks for your review!
> Eliad.


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

