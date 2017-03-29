Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50554 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754027AbdC2Pj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 11:39:29 -0400
Subject: Re: [PATCH v3 3/4] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1490311578-18926-1-git-send-email-greearb@candelatech.com>
 <1490311578-18926-3-git-send-email-greearb@candelatech.com>
 <1490777219.7948.11.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5c86dcbe-7a7b-47cd-4c77-d56e249369e0@candelatech.com> (sfid-20170329_173944_574357_AEB321DE)
Date: Wed, 29 Mar 2017 08:39:22 -0700
MIME-Version: 1.0
In-Reply-To: <1490777219.7948.11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2017 01:46 AM, Johannes Berg wrote:
> On Thu, 2017-03-23 at 16:26 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This makes it easier to understand why wmediumd (or similar)
>> is getting errors when sending frames to the kernel.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/mac80211_hwsim.c | 55
>> +++++++++++++++++++++++++++--------
>>  1 file changed, 43 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mac80211_hwsim.c
>> b/drivers/net/wireless/mac80211_hwsim.c
>> index 234df8c..84dcddf 100644
>> --- a/drivers/net/wireless/mac80211_hwsim.c
>> +++ b/drivers/net/wireless/mac80211_hwsim.c
>> @@ -137,6 +137,12 @@ static int regtest = HWSIM_REGTEST_DISABLED;
>>  module_param(regtest, int, 0444);
>>  MODULE_PARM_DESC(regtest, "The type of regulatory test we want to
>> run");
>>
>> +DEFINE_RATELIMIT_STATE(hwsim_ratelimit_state, 5 * HZ, 10);
>> +int hwsim_ratelimit(void)
>> +{
>> +	return __ratelimit(&hwsim_ratelimit_state);
>> +}
>> +
>>  static const char *hwsim_alpha2s[] = {
>>  	"FI",
>>  	"AL",
>> @@ -1649,7 +1655,7 @@ static int mac80211_hwsim_config(struct
>> ieee80211_hw *hw, u32 changed)
>>
>>  	if (conf->chandef.chan)
>>  		wiphy_debug(hw->wiphy,
>> -			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d
>> smps=%s)\n",
>> +			    "%s (chandef-chan freq=%d(%d - %d)/%s
>> idle=%d ps=%d smps=%s)\n",
>>  			    __func__,
>>  			    conf->chandef.chan->center_freq,
>>  			    conf->chandef.center_freq1,
>> @@ -1660,7 +1666,7 @@ static int mac80211_hwsim_config(struct
>> ieee80211_hw *hw, u32 changed)
>>  			    smps_modes[conf->smps_mode]);
>>  	else
>>  		wiphy_debug(hw->wiphy,
>> -			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
>> +			    "%s (no-chandef-chan freq=0 idle=%d
>> ps=%d smps=%s)\n",
>
> This seems unrelated?

It can be cut out of the patch.  Want me to re-send?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
