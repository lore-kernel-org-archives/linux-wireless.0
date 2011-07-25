Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54515 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1GYUHh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:07:37 -0400
Received: by yia27 with SMTP id 27so2471045yia.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 13:07:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2DCA73.3050103@candelatech.com>
References: <1311607763-12603-1-git-send-email-eliad@wizery.com>
	<1311607763-12603-3-git-send-email-eliad@wizery.com>
	<4E2DA564.5070305@candelatech.com>
	<CAB3XZEcu68SZ0-cAt5-ZAvmp31mafcx856p26BRRcNOSs3Lt1A@mail.gmail.com>
	<4E2DCA73.3050103@candelatech.com>
Date: Mon, 25 Jul 2011 23:07:37 +0300
Message-ID: <CAB3XZEdR+oT1AFW6qN88or9XG5DFazN_BgJREC77MnroEkHBcQ@mail.gmail.com> (sfid-20110725_220741_115972_2E99EAC1)
Subject: Re: [RFC 2/2] mac80211: config hw when going back on-channel
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2011 at 10:56 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 07/25/2011 12:16 PM, Eliad Peller wrote:
>>
>> hi Ben,
>>
>> On Mon, Jul 25, 2011 at 8:18 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> On 07/25/2011 08:29 AM, Eliad Peller wrote:
>>>>
>>>> The hw is currently not configured when going
>>>> back on-channel.
>>>
>>> I am less sure about this patch.  With the existing code,
>>> I think it should catch going from on channel to off
>>> and do the hw config properly.
>>>
>> IIUC, this code is responsible for going back on-channel (if there is
>> no started work on the tmp_channel).
>>
>>> With your change it will also reconfig the hardware, but it will
>>> reconfig even if we were already on-channel (if, for instance,
>>> local->tmp_channel is oper-channel), right?
>>>
>>> Can you please explain in more detail how this code is
>>> broken?
>>>
>> we should reconfigure the hardware iff the hardware is not configured
>> to the operational channel.
>> the current code doesn't handle it (e.g. oper_channel=1,
>> tmp_channel=11, hw_channel=11. since
>> ieee80211_cfg_on_oper_channel(local) == 0, the hw won't go back
>> on-channel).
>
> If we are off-channel when entering that block of code, then tmp_channel
> != NULL, and on_oper_chan will be false.
>
right.

> Then, we set tmp_channel to NULL, which should make
> ieee80211_cfg_on_oper_channel
> true.
>
tmp_channel is NULL, but ieee80211_cfg_on_oper_channel() also checks for:

	/* Check current hardware-config against oper_channel. */
	if ((local->oper_channel != local->hw.conf.channel) ||
	    (local->_oper_channel_type != local->hw.conf.channel_type))
		return false;


so it will return false, and hw_config won't happen.

Eliad.
