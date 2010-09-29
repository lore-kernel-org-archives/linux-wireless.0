Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36392 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0I2RpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:45:04 -0400
Message-ID: <4CA37B16.2040002@candelatech.com>
Date: Wed, 29 Sep 2010 10:44:54 -0700
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

Doesn't the remain_off_channel logic later in that method
take care of not calling the return to channel logic?
(Assuming I set the tmp_channel and tmp_channel_type as you suggest)?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

