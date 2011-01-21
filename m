Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51140 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1AUOAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 09:00:00 -0500
Message-ID: <4D39915C.9080405@candelatech.com>
Date: Fri, 21 Jan 2011 05:59:56 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Optimize scans on current operating channel.
References: <1295588389-10860-1-git-send-email-greearb@candelatech.com> <201101210919.13673.helmut.schaa@googlemail.com>
In-Reply-To: <201101210919.13673.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/21/2011 12:19 AM, Helmut Schaa wrote:
> Am Freitag, 21. Januar 2011 schrieb greearb@candelatech.com:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This should decrease un-necessary flushes, on/off channel work,
>> and channel changes in cases where the only scanned channel is
>> the current operating channel.

>>   	/* scanning finished during invoking of handlers */
>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> index 3e660db..5804fbb 100644
>> --- a/net/mac80211/scan.c
>> +++ b/net/mac80211/scan.c
>> @@ -293,11 +293,14 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>>   {
>>   	struct ieee80211_local *local = hw_to_local(hw);
>>
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> +	if (test_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning) || was_hw_scan)
>> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> +
>
> Why not
>
> if (!test_bit(SCAN_OFF_CHANNEL,&local->scanning) || was_hw_scan)
>
> instead? If the last scanned channel was a off channel scan this bit will
> still be set. And that way you don't need this new flag.

If the last channel scanned is the oper-channel, I'm not sure we
call the return-to-oper-channel logic in the scan code.  I can
double check that, and either way, your suggestion would probably
be OK.

>
>>   	if (!was_hw_scan) {
>>   		ieee80211_configure_filter(local);
>>   		drv_sw_scan_complete(local);
>> -		ieee80211_offchannel_return(local, true);
>> +		if (test_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning))
>> +			ieee80211_offchannel_return(local, true);
>
> Same here.

What if the last channel to scan was the operating channel?  We are now
back on channel, but if we earlier scanned something that was not the
operating channel, we would have called the offchannel stop beacon
stuff, and just returning to the oper channel in the scan code doesn't
call the offchannel_return logic if I recall correctly.

>
>>   	}
>>
>>   	mutex_lock(&local->mtx);
>> @@ -397,13 +400,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
>>
>>   	drv_sw_scan_start(local);
>>
>> -	ieee80211_offchannel_stop_beaconing(local);
>> -
>
> You could split that out in a second patch since this change might also make sense
> on its own.

Maybe, but it's pretty inter-related to what I'm trying to accomplish...

>
>>   	local->leave_oper_channel_time = 0;
>>   	local->next_scan_state = SCAN_DECISION;
>>   	local->scan_channel_idx = 0;
>> -
>> -	drv_flush(local, false);
>> +	__clear_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning);
>>
>>   	ieee80211_configure_filter(local);
>>
>> @@ -543,7 +543,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>>   	}
>>   	mutex_unlock(&local->iflist_mtx);
>>
>> -	if (local->scan_channel) {
>> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
>> +
>> +	if (local->oper_channel == local->hw.conf.channel) {
>
> Isn't that equivalent to !test_bit(SCAN_OFF_CHANNEL, ...)?

It probably should be, but if I can compare channels directly,
that seems less likely to break than depending on having a flag
set correctly in all cases...especially border cases where oper-channel
is first, last, or only channel to be scanned.

Thanks for the review.  I'll try to post a revised patch
later today.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
