Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54686 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1GZFsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 01:48:45 -0400
Received: by gxk21 with SMTP id 21so44636gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 22:48:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2E44F1.7040405@candelatech.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	<1311607763-12603-3-git-send-email-eliad@wizery.com>
	<4E2DA564.5070305@candelatech.com>
	<CAB3XZEcu68SZ0-cAt5-ZAvmp31mafcx856p26BRRcNOSs3Lt1A@mail.gmail.com>
	<4E2DCA73.3050103@candelatech.com>
	<CAB3XZEdR+oT1AFW6qN88or9XG5DFazN_BgJREC77MnroEkHBcQ@mail.gmail.com>
	<4E2E44F1.7040405@candelatech.com>
Date: Tue, 26 Jul 2011 08:48:45 +0300
Message-ID: <CAB3XZEciK573a-xC3up0WP_jwkoOhG0h+ADjxNe-K4PUs8ZbHQ@mail.gmail.com> (sfid-20110726_074855_647471_5B8550B3)
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>>>> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>>>>>
>>>>>> The hw is currently not configured when going
>>>>>> back on-channel.
>>>>>
>>>>> I am less sure about this patch.  With the existing code,
>>>>> I think it should catch going from on channel to off
>>>>> and do the hw config properly.
>>>>>
>>>> IIUC, this code is responsible for going back on-channel (if there is
>>>> no started work on the tmp_channel).
>>>>
>>>>> With your change it will also reconfig the hardware, but it will
>>>>> reconfig even if we were already on-channel (if, for instance,
>>>>> local->tmp_channel is oper-channel), right?
>>>>>
>>>>> Can you please explain in more detail how this code is
>>>>> broken?
>>>>>
>>>> we should reconfigure the hardware iff the hardware is not configured
>>>> to the operational channel.
>>>> the current code doesn't handle it (e.g. oper_channel=1,
>>>> tmp_channel=11, hw_channel=11. since
>>>> ieee80211_cfg_on_oper_channel(local) == 0, the hw won't go back
>>>> on-channel).
>>>
>>> If we are off-channel when entering that block of code, then tmp_channel
>>> != NULL, and on_oper_chan will be false.
>>>
>> right.
>>
>>> Then, we set tmp_channel to NULL, which should make
>>> ieee80211_cfg_on_oper_channel
>>> true.
>>>
>> tmp_channel is NULL, but ieee80211_cfg_on_oper_channel() also checks for:
>>
>>        /* Check current hardware-config against oper_channel. */
>>        if ((local->oper_channel != local->hw.conf.channel) ||
>>            (local->_oper_channel_type != local->hw.conf.channel_type))
>>                return false;
>>
>>
>> so it will return false, and hw_config won't happen.
>
> Ahh, ok, I see your point.
>
> Your fix should be more correct than the current code, but
> I think it might still could cause hardware config when not needed.
> That isn't really a bug, just less efficient.  And, I'd have to
> look at the code in detail to be certain.  I'm trying to be on
> vacation this week, but will poke at it when I get a chance.
>
> In the meantime, your patch is probably worth applying, and
> should probably go to stable.  Hopefully Johannes can review
> it as well, as I obviously didn't get it all right the first time!
>

as i'm not sure in this patch either, i guess we should better wait
for Johannes' review.

thanks,
Eliad.
