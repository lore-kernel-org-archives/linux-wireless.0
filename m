Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47487 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0IUMFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 08:05:09 -0400
Message-ID: <4C989F6B.30600@candelatech.com>
Date: Tue, 21 Sep 2010 05:04:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: greearb@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285042903-19189-1-git-send-email-greearb@candelatech.com> <1285051701.3710.9.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285051701.3710.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2010 11:48 PM, Johannes Berg wrote:
> On Mon, 2010-09-20 at 21:21 -0700, greearb@gmail.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> MAC address of AP isn't unique..need to add the device
>> name as well.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> :100644 100644 76839d4... 4cf451c... M	net/mac80211/debugfs_sta.c
>>   net/mac80211/debugfs_sta.c |    8 ++++++--
>>   1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
>> index 76839d4..4cf451c 100644
>> --- a/net/mac80211/debugfs_sta.c
>> +++ b/net/mac80211/debugfs_sta.c
>> @@ -301,14 +301,18 @@ STA_OPS(ht_capa);
>>   void ieee80211_sta_debugfs_add(struct sta_info *sta)
>>   {
>>   	struct dentry *stations_dir = sta->local->debugfs.stations;
>> -	u8 mac[3*ETH_ALEN];
>> +	u8 mac[3*ETH_ALEN + IFNAMSIZ + 2];
>>
>>   	sta->debugfs.add_has_run = true;
>>
>>   	if (!stations_dir)
>>   		return;
>>
>> -	snprintf(mac, sizeof(mac), "%pM", sta->sta.addr);
>> +	if (sta->sdata)
>> +		snprintf(mac, sizeof(mac), "%pM-%s",
>> +			 sta->sta.addr, sta->sdata->name);
>> +	else
>> +		snprintf(mac, sizeof(mac), "%pM-NULL", sta->sta.addr);
>
> Does that NULL case really happen? I don't think it can, because we
> shouldn't be adding this to debugfs before we assign it to an interface?

I haven't seen it be NULL...just was a bit paranoid.  I'll re-spin w/out
that NULL check.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
