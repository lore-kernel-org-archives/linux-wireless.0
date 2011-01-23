Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57419 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1AWPtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 10:49:43 -0500
Message-ID: <4D3C4E10.8070005@candelatech.com>
Date: Sun, 23 Jan 2011 07:49:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating channel.
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com> <1295774293.3639.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295774293.3639.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2011 01:18 AM, Johannes Berg wrote:
> On Fri, 2011-01-21 at 10:05 -0800, greearb@candelatech.com wrote:
>
>> + * @SCAN_LEFT_OPER_CHANNEL:  Set this flag if the scan process leaves the
>> + *      operating channel at any time.  If scanning ONLY the current operating
>> + *      channel this flag should not be set, and this will allow fewer
>> + *      offchannel changes.
>
> Why does this make sense? In the code below, you do
>
>
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> +	if ((local->oper_channel != local->hw.conf.channel) || was_hw_scan)
>> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> +
>>   	if (!was_hw_scan) {
>>   		ieee80211_configure_filter(local);
>>   		drv_sw_scan_complete(local);
>> -		ieee80211_offchannel_return(local, true);
>> +		if (test_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning))
>> +			ieee80211_offchannel_return(local, true);
>
> so you could just as well use a local variable (the first if you add is
> exactly this test).

I'm sorry, but I don't understand your comments.  I need some way to track
whether we ever called the offchannel-stop-beaconing code so that it can
be selectively re-enabled in the code above.  I was using a flag
instead of adding another boolean to the local struct.

The flag could be called 'SCAN_STOPPED_BEACONING' instead if that makes more
sense?

>>   static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>>   						    unsigned long *next_delay)
>>   {
>> +	ieee80211_offchannel_stop_beaconing(local);
>> +
>
> Won't that confuse drivers that expect not to be beaconing between
> sw_scan_start and sw_scan_end?

I didn't know that any would care.  Maybe we need a phy_features set of
flags and let each driver enable this optimization as it is tested/verified?
Seems to work fine for ath9k with multiple VIFs, for what that's worth.

> Also, are you sure the filter configuration works correctly this way? If
> you can, I'd like to look at a binary trace of the commands going to the
> device with this change: "trace-cmd record -e mac80211".

I'll try to run this soon and post the results.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
