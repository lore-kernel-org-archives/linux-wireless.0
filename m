Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49912 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab1AUO1Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 09:27:16 -0500
Message-ID: <4D3997C1.6090008@candelatech.com>
Date: Fri, 21 Jan 2011 06:27:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Optimize scans on current operating channel.
References: <1295588389-10860-1-git-send-email-greearb@candelatech.com> <201101210919.13673.helmut.schaa@googlemail.com> <4D39915C.9080405@candelatech.com>
In-Reply-To: <4D39915C.9080405@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2011 05:59 AM, Ben Greear wrote:
> On 01/21/2011 12:19 AM, Helmut Schaa wrote:
>> Am Freitag, 21. Januar 2011 schrieb greearb@candelatech.com:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> This should decrease un-necessary flushes, on/off channel work,
>>> and channel changes in cases where the only scanned channel is
>>> the current operating channel.
>
>>> /* scanning finished during invoking of handlers */
>>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>>> index 3e660db..5804fbb 100644
>>> --- a/net/mac80211/scan.c
>>> +++ b/net/mac80211/scan.c
>>> @@ -293,11 +293,14 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>>> {
>>> struct ieee80211_local *local = hw_to_local(hw);
>>>
>>> - ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>> + if (test_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning) || was_hw_scan)
>>> + ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>> +
>>
>> Why not
>>
>> if (!test_bit(SCAN_OFF_CHANNEL,&local->scanning) || was_hw_scan)
>>
>> instead? If the last scanned channel was a off channel scan this bit will
>> still be set. And that way you don't need this new flag.
>
> If the last channel scanned is the oper-channel, I'm not sure we
> call the return-to-oper-channel logic in the scan code. I can
> double check that, and either way, your suggestion would probably
> be OK.

>>
>>> if (!was_hw_scan) {
>>> ieee80211_configure_filter(local);
>>> drv_sw_scan_complete(local);
>>> - ieee80211_offchannel_return(local, true);
>>> + if (test_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning))
>>> + ieee80211_offchannel_return(local, true);
>>
>> Same here.
>
> What if the last channel to scan was the operating channel? We are now
> back on channel, but if we earlier scanned something that was not the
> operating channel, we would have called the offchannel stop beacon
> stuff, and just returning to the oper channel in the scan code doesn't
> call the offchannel_return logic if I recall correctly.

Ok, I looked at this more, and if the oper-channel is not the first
channel in the scan list, we can be scanning on the oper channel without
having called the enter_oper_channel logic.  This means that the SCAN_OFF_CHANNEL
flag can be TRUE, and yet we can be configured for the oper-channel.

If the oper-channel is the one and only channel to scan, then SCAN_OFF_CHANNEL
will not be set.

It's also possible we temporarily flipped back to the oper-channel state
in the state_decision method.

And maybe then the scan is canceled half way through?

I can imagine someone wanting to call the enter-oper-channel logic if we start
scanning on the oper-channel, which would break the offchannel_return logic
in the patch snippet above if we only test for SCAN_OFF_CHANNEL.

It is too much for me to follow, so I think a new flag specifying only that we
need to call the offchannel_return logic is the most straight-forward way
to go.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
