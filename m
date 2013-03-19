Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52060 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3CSU7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 16:59:24 -0400
Message-ID: <5148D1A4.3090703@candelatech.com> (sfid-20130319_215930_393512_AD48177D)
Date: Tue, 19 Mar 2013 13:59:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Optimize sta lookup for many VIFs
References: <1363381993-31496-1-git-send-email-greearb@candelatech.com>  <1363381993-31496-2-git-send-email-greearb@candelatech.com>  (sfid-20130315_221333_293041_95169062) <1363723948.8336.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1363723948.8336.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2013 01:12 PM, Johannes Berg wrote:
> On Fri, 2013-03-15 at 14:13 -0700, greearb@candelatech.com wrote:
>
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -669,6 +669,12 @@ struct ieee80211_sub_if_data {
>>   	/* count for keys needing tailroom space allocation */
>>   	int crypto_tx_tailroom_needed_cnt;
>>
>> +	/* A pointer to some station associated with this interface, or
>> +	 * NULL.  This aids oportunistic lookup for sta_info objects when
>
> typo: opportunistic. Also it should probably say "allows opportunistic
> lookup" :-)
>
>> +	/* Shortcut for finding station entries when sdata is a station */
>> +	some_sta = rcu_dereference(sdata->some_sta);
>> +	if (some_sta) {
>> +		if (WARN_ON(some_sta->sdata != sdata))
>> +			rcu_assign_pointer(sdata->some_sta, NULL);
>> +		else
>> +			if (ether_addr_equal(some_sta->sta.addr, addr))
>> +				return some_sta;
>
> I worry a little bit about the overhead in the "always cache miss" case.
> Is this really helpful for AP interfaces? Maybe it should be limited to
> managed virtual interfaces.

This was a quick fix that resolved the issue I was seeing, but
I am now thinking that maybe a full hash based on local MAC instead
of remote MAC should be added.  In some code (station TX) we can use
that hash, and we could also use it on RX when trying to find the
sdata that a non-multicast packet is destined for.

For other uses, the existing hash on the remote MAC address would
remain the preferred lookup.

The RX logic might still be tricky...not sure if we really need to pass
all packets to PROMISC interfaces, nor sure when we could safely not
fan-out non-data packets.

>>   	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
>> +	some_sta = rcu_dereference(sta->sdata->some_sta);
>> +	if (some_sta == sta)
>> +		rcu_assign_pointer(sta->sdata->some_sta, NULL);
>
> This clearing is WAY too late. You can look up the station way after you
> must be allowed to, this will invariably crash eventually. It absolutely
> must be when the station is unhashed, not when it's freed.
>
>> @@ -373,6 +387,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
>>   	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
>>   		sta->last_seq_ctrl[i] = cpu_to_le16(USHRT_MAX);
>>
>> +	rcu_assign_pointer(sta->sdata->some_sta, sta);
>
> This is too early, the station might not even be used, this must only be
> done when the station is hashed.

Ok, I'll work on that.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

