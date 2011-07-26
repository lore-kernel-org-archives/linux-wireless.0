Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33539 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GZEjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 00:39:20 -0400
Message-ID: <4E2E44F1.7040405@candelatech.com> (sfid-20110726_063930_219878_9F96AC0B)
Date: Mon, 25 Jul 2011 21:39:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>	<1311607763-12603-3-git-send-email-eliad@wizery.com>	<4E2DA564.5070305@candelatech.com>	<CAB3XZEcu68SZ0-cAt5-ZAvmp31mafcx856p26BRRcNOSs3Lt1A@mail.gmail.com>	<4E2DCA73.3050103@candelatech.com> <CAB3XZEdR+oT1AFW6qN88or9XG5DFazN_BgJREC77MnroEkHBcQ@mail.gmail.com>
In-Reply-To: <CAB3XZEdR+oT1AFW6qN88or9XG5DFazN_BgJREC77MnroEkHBcQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 01:07 PM, Eliad Peller wrote:
> On Mon, Jul 25, 2011 at 10:56 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> On 07/25/2011 12:16 PM, Eliad Peller wrote:
>>>
>>> hi Ben,
>>>
>>> On Mon, Jul 25, 2011 at 8:18 PM, Ben Greear<greearb@candelatech.com>
>>>   wrote:
>>>>
>>>> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>>>>
>>>>> The hw is currently not configured when going
>>>>> back on-channel.
>>>>
>>>> I am less sure about this patch.  With the existing code,
>>>> I think it should catch going from on channel to off
>>>> and do the hw config properly.
>>>>
>>> IIUC, this code is responsible for going back on-channel (if there is
>>> no started work on the tmp_channel).
>>>
>>>> With your change it will also reconfig the hardware, but it will
>>>> reconfig even if we were already on-channel (if, for instance,
>>>> local->tmp_channel is oper-channel), right?
>>>>
>>>> Can you please explain in more detail how this code is
>>>> broken?
>>>>
>>> we should reconfigure the hardware iff the hardware is not configured
>>> to the operational channel.
>>> the current code doesn't handle it (e.g. oper_channel=1,
>>> tmp_channel=11, hw_channel=11. since
>>> ieee80211_cfg_on_oper_channel(local) == 0, the hw won't go back
>>> on-channel).
>>
>> If we are off-channel when entering that block of code, then tmp_channel
>> != NULL, and on_oper_chan will be false.
>>
> right.
>
>> Then, we set tmp_channel to NULL, which should make
>> ieee80211_cfg_on_oper_channel
>> true.
>>
> tmp_channel is NULL, but ieee80211_cfg_on_oper_channel() also checks for:
>
> 	/* Check current hardware-config against oper_channel. */
> 	if ((local->oper_channel != local->hw.conf.channel) ||
> 	    (local->_oper_channel_type != local->hw.conf.channel_type))
> 		return false;
>
>
> so it will return false, and hw_config won't happen.

Ahh, ok, I see your point.

Your fix should be more correct than the current code, but
I think it might still could cause hardware config when not needed.
That isn't really a bug, just less efficient.  And, I'd have to
look at the code in detail to be certain.  I'm trying to be on
vacation this week, but will poke at it when I get a chance.

In the meantime, your patch is probably worth applying, and
should probably go to stable.  Hopefully Johannes can review
it as well, as I obviously didn't get it all right the first time!

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
