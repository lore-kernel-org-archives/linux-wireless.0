Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57528 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668Ab3DCNSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 09:18:30 -0400
Message-ID: <515C2C1F.4000804@candelatech.com> (sfid-20130403_151833_130844_6A6268E5)
Date: Wed, 03 Apr 2013 06:18:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211:  Optimize sta lookup for many VIFs
References: <1364572823-28071-1-git-send-email-greearb@candelatech.com>  (sfid-20130329_170033_026763_9F6C74DD) <1364993882.8351.39.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364993882.8351.39.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 05:58 AM, Johannes Berg wrote:
> On Fri, 2013-03-29 at 09:00 -0700, greearb@candelatech.com wrote:
>
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -1287,6 +1287,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>>   	if (params->vlan && params->vlan != sta->sdata->dev) {
>>   		bool prev_4addr = false;
>>   		bool new_4addr = false;
>> +		struct sta_info *some_sta;
>>
>>   		vlansdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
>>
>> @@ -1312,7 +1313,12 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>>   			prev_4addr = true;
>>   		}
>>
>> +		some_sta = rcu_dereference_protected(sta->sdata->some_sta,
>> +					lockdep_is_held(&local->sta_mtx));
>> +		if (some_sta == sta)
>> +			rcu_assign_pointer(sta->sdata->some_sta, NULL);
>>   		sta->sdata = vlansdata;
>> +		rcu_assign_pointer(sta->sdata->some_sta, sta);
>>
>>   		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
>>   		    prev_4addr != new_4addr) {
>
> I think you can drop all this code since you don't allow this for
> non-station interfaces, and stations here can only be reassigned between
> AP/AP_VLAN, no?

Well, it seems more fragile to skip this code.  If someone ever changes
how reassignment can happen it may be a while before anyone notices
the bug.  This code is not in any sort of hot path, so there isn't much
overhead...

But, if you still prefer this code removed then I'll make the change.

>> @@ -278,6 +297,8 @@ static void sta_info_hash_add(struct ieee80211_local *local,
>>   	lockdep_assert_held(&local->sta_mtx);
>>   	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
>>   	rcu_assign_pointer(local->sta_hash[STA_HASH(sta->sta.addr)], sta);
>> +
>> +	rcu_assign_pointer(sta->sdata->some_sta, sta);
>
> Maybe also assign it only for station to start with?

That sounds fine, though I doubt it matters any performance wise.

Let me know on the point above and I'll re-spin the patch.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

