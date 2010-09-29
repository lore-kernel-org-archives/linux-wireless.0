Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59146 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0I2Q7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 12:59:01 -0400
Message-ID: <4CA3704E.1070702@candelatech.com>
Date: Wed, 29 Sep 2010 09:58:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com>	 <1285743733.3756.3.camel@jlt3.sipsolutions.net>	 <4CA35BAB.8090701@candelatech.com> <1285778901.3756.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285778901.3756.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 09:48 AM, Johannes Berg wrote:
> On Wed, 2010-09-29 at 08:30 -0700, Ben Greear wrote:
>
>> Does this portion seem useful as a stand-alone patch?  It does not
>> depend on the other scan-one logic.
>
> Somewhat, but it seems a bit buggy?
>
>> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
>> index ae344d1..1bfc1e0 100644
>> --- a/net/mac80211/work.c
>> +++ b/net/mac80211/work.c
>> @@ -910,12 +910,17 @@ static void ieee80211_work_work(struct work_struct *work)
>>    			 *	 happen to be on the same channel as
>>    			 *	 the requested channel
>>    			 */
>> -			ieee80211_offchannel_stop_beaconing(local);
>> -			ieee80211_offchannel_stop_station(local);
>> -
>> -			local->tmp_channel = wk->chan;
>> -			local->tmp_channel_type = wk->chan_type;
>> -			ieee80211_hw_config(local, 0);
>> +			if (!(wk->chan == local->scan_channel ||
>> +			      (wk->chan == local->oper_channel&&
>
> I don't think work items will ever run while scanning? And also, this
> might need to check the channel type as well, which isn't quite
> necessary right now (since no works requires HT channels) but would seem
> cleaner.

Just in case work ever does happen when scanning, I think we should
leave this check in.

I'll add a check for channel_type being the same as well.

>> +			       !local->scan_channel))) {
>> +				/* Only change channels if we need to */
>> +				ieee80211_offchannel_stop_beaconing(local);
>> +				ieee80211_offchannel_stop_station(local);
>> +
>> +				local->tmp_channel = wk->chan;
>> +				local->tmp_channel_type = wk->chan_type;
>> +				ieee80211_hw_config(local, 0);
>> +			}
>>    			started = true;
>>    			wk->timeout = jiffies;
>
> Also, I believe it needs matching code to not do all the return stuff
> since we never left the channel, and I think it still needs to set
> tmp_channel so that nothing will switch away underneath or so... not
> quite sure.

Ok, that sounds good.  I'll work on a revised patch when I get a chance.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

