Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54064 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760860Ab2COTD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:03:58 -0400
Message-ID: <4F623D19.7090105@candelatech.com> (sfid-20120315_200402_520674_3895BA22)
Date: Thu, 15 Mar 2012 12:03:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>  <1331833159-12694-2-git-send-email-greearb@candelatech.com>  (sfid-20120315_183942_222982_FD61EFBD) <1331837740.3432.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331837740.3432.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2012 11:55 AM, Johannes Berg wrote:
> Ok more technical look ...
>
>
> It doesn't look like NUM_STA_INFO_STATS gets used at all, or am I
> missing it?
>
>> +static int ieee80211_get_et_sset_count(struct wiphy *wiphy,
>> +				       struct net_device *dev,
>> +				       int sset)
>> +{
>> +	switch (sset) {
>> +	case ETH_SS_STATS:
>> +		return STA_STATS_LEN;
>
> Are there different "s* sets" that could be used to return different
> types of stats, or how does this work?

Yes, there are diag strings too, I think..but I wasn't
planning to add support for that, though perhaps someone
else might know how to do that.

>> +	mutex_lock(&sdata->local->sta_mtx);
>
> Why not use RCU? The mutex doesn't really protect anything useful here
> except for the list iteration.

No reason.  I'll try to make it RCU instead.

>> +	list_for_each_entry(sta,&sdata->local->sta_list, list) {
>
> That's not right -- these stats are per netdev so you should only
> aggregate for the netdev, no?

Ummm, maybe so.  I had trouble figuring out how to find
the sta entries that are associated with a netdev, and I'd
like to sum up all station entries for an AP interfaces.

If you know of any code that uses this, a pointer would
be welcome.

>> +		BUG_ON(i != STA_STATS_LEN);
>
> That I really don't like much.

Ok, I'll remove it from a final patch.  It catches bugs
in the meantime (miss a comma between strings and
it blows up spectacularly :P).

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

