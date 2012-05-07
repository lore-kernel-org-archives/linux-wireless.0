Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37513 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2EGR51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 13:57:27 -0400
Message-ID: <4FA80D02.404@candelatech.com> (sfid-20120507_195729_749339_8F7579D1)
Date: Mon, 07 May 2012 10:57:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Support ethtool getstats api.
References: <1336411437-16653-1-git-send-email-greearb@candelatech.com> <1336412033.20924.6.camel@joe2Laptop>
In-Reply-To: <1336412033.20924.6.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2012 10:33 AM, Joe Perches wrote:
> On Mon, 2012-05-07 at 10:23 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This returns many of the values that formerly could
>> only be obtained from debugfs.  This should be an
>> improvement when trying to access these counters
>> programatically.  Currently this support is only
>> enabled when DEBUGFS is enabled because otherwise
>> these stats are not accumulated.
>
> trivia:
>
> []
>> +#define ATH9K_SSTATS_LEN ARRAY_SIZE(ath9k_gstrings_stats)
>
> I think there's not much value in this #define
>
>> +static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
>> +				   struct ieee80211_vif *vif, int sset)
>> +{
>> +	if (sset == ETH_SS_STATS)
>> +		return ATH9K_SSTATS_LEN;
>> +	return 0;
>> +}
>
> Is this the only use?

No, there is a check later that does a BUG_ON if our
we have screwed up the indexing of the stats.

That helps catch trivial problems with adding a stat
but not the string, or vice versa.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

