Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34073 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab1J1Szk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 14:55:40 -0400
Message-ID: <4EAAFAA7.8090403@candelatech.com> (sfid-20111028_205543_472872_4928ADE0)
Date: Fri, 28 Oct 2011 11:55:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319789318.3914.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 01:08 AM, Johannes Berg wrote:
> On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:

>> +++ b/net/wireless/nl80211.c
>> @@ -1641,6 +1641,13 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
>>   		change = true;
>>   	}
>>
>> +	if (info->attrs[NL80211_ATTR_DISABLE_11N]) {
>> +		params.disable_11n = !!nla_get_u8(info->attrs[NL80211_ATTR_DISABLE_11N]);
>> +		change = true;
>> +	} else {
>> +		params.disable_11n = -1;
>> +	}
>
> This should be a parameter to connect() and assoc(), not a generic
> netdev parameter, since it applies to the connection.
>
> Also, it would be good to have a capability check for it etc. since a
> lot of fullmac drivers will likely never implement this.

The existing code always sets the IEEE80211_STA_DISABLE_11N flag in u.mgd if
WEP or TKIP is configured, without any capability checks, and my patch
sets that flag in the same location.

So, maybe it is OK as is?

If not, I will add a new capability bit and just enable
it in ath9k (and let others enable it in their drivers as they wish).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

