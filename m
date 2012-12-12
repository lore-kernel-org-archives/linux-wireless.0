Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43311 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab2LLWIc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:08:32 -0500
Message-ID: <50C9005A.4000805@candelatech.com> (sfid-20121212_230835_864883_7AF17847)
Date: Wed, 12 Dec 2012 14:08:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/6] mac80211: Allow disabling SGI-20.
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>  <1355349295-30960-4-git-send-email-greearb@candelatech.com>  (sfid-20121212_225648_739548_AE867F17) <1355349972.9708.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355349972.9708.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/2012 02:06 PM, Johannes Berg wrote:
> On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This allows user-space (wpa_supplicant) to disable
>> short guard interval (SGI) for 20Mhz.  The SGI-40
>> disable option is already handled.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   net/mac80211/ht.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
>> index a71d891..8a6d68f 100644
>> --- a/net/mac80211/ht.c
>> +++ b/net/mac80211/ht.c
>> @@ -62,6 +62,9 @@ void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
>>   	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
>>   	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
>>
>> +	/* Allow user to disable SGI-20 (SGI-40 is handled above) */
>> +	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_20);
>
> And you tested this? And it actually did something, despite
> mac80211_ht_capa_mod_mask not including it??

I thought it was working, but perhaps I was wrong.  I will re-test.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

