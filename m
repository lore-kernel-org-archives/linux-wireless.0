Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44777 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1J1QN3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 12:13:29 -0400
Message-ID: <4EAAD4A5.3070308@candelatech.com> (sfid-20111028_181334_527189_74B6FF3B)
Date: Fri, 28 Oct 2011 09:13:25 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 4/5] wifi: Warn if cannot add station debugfs
 entries.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  <1319778680-11405-4-git-send-email-greearb@candelatech.com>  (sfid-20111028_071154_398499_47BB01A2) <1319789588.3914.16.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319789588.3914.16.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 01:13 AM, Johannes Berg wrote:
> On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>> :100644 100644 c5f3417... 1ceec86... M	net/mac80211/debugfs_sta.c
>>   net/mac80211/debugfs_sta.c |   10 ++++++++--
>>   1 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
>> index c5f3417..1ceec86 100644
>> --- a/net/mac80211/debugfs_sta.c
>> +++ b/net/mac80211/debugfs_sta.c
>> @@ -337,8 +337,11 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
>>
>>   	sta->debugfs.add_has_run = true;
>>
>> -	if (!stations_dir)
>> +	if (!stations_dir) {
>> +		printk(KERN_DEBUG "%s: sta_debugfs_add: stations_dir is NULL\n",
>> +			sta->sdata->name);
>>   		return;
>> +	}
>
> I honestly don't see any point in this.

Ok, I wasn't sure if this was wanted, so please just
drop it.  I did see a case where the debugfs files didn't
exist, and was trying to figure out why..but never reproduced
the problem after this printk was in, so not sure if this
was the issue or not.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

