Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55525 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2DRDqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 23:46:18 -0400
Message-ID: <4F8E3905.70900@candelatech.com> (sfid-20120418_054621_143331_804D180B)
Date: Tue, 17 Apr 2012 20:46:13 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/6] mac80211: Support getting sta_info stats via ethtool.
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>  <1334684807-14026-3-git-send-email-greearb@candelatech.com>  (sfid-20120417_194716_243783_5644375D) <1334713070.3725.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334713070.3725.14.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/17/2012 06:37 PM, Johannes Berg wrote:
> On Tue, 2012-04-17 at 10:46 -0700, greearb@candelatech.com wrote:
>
>> +static void ieee80211_get_et_stats(struct wiphy *wiphy,
>> +				   struct net_device *dev,
>> +				   struct ethtool_stats *stats,
>> +				   u64 *data)
>> +{
>> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +	struct sta_info *sta;
>> +	struct ieee80211_local *local = sdata->local;
>> +
>> +	memset(data, 0, sizeof(u64) * STA_STATS_LEN);
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(sta,&local->sta_list, list) {
>
> This doesn't seem right -- shouldn't it look up the BSSID or something
> and only work on managed interfaces? What if there really are two
> stations on this interface -- then it'll just overwrite it and return a
> random station's data? That's useless.

Well, its weird at least.

But, if there are multiple stations, like for APs??, then it will
add the station's stats together.  Perhaps not horribly useful, but better
than nothing.

For managed interface, I *think* they don't have more than one station, right?

And, as for the underlying driver stats and survey stats (in later patches),
that is only probed once.  I guess if you somehow had two
stations on different channels on the same network device,
the survey stats would be a bit dodgy, but it does return
the freq for the stats in question, so at least you know
what you are getting.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
