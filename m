Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55704 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab1KGQTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 11:19:46 -0500
Message-ID: <4EB8051D.5010704@candelatech.com> (sfid-20111107_171955_875512_C4EAFF7F)
Date: Mon, 07 Nov 2011 08:19:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mac80211:  Support ht-cap over-rides.
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>  <1320437440-6463-2-git-send-email-greearb@candelatech.com>  (sfid-20111104_211114_679516_4CC16ABF) <1320657208.3993.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320657208.3993.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 01:13 AM, Johannes Berg wrote:
> On Fri, 2011-11-04 at 13:10 -0700, greearb@candelatech.com wrote:
>
>> +/*
>> + * Stations supporting 802.11n are required to support
>> + * at least the first 8 MCS rates.  See section 7.3.2.56.4
>> + * and 20.1.1 of the 802.11n spec.
>> + */
>> +#define IEEE80211_HT_MCS_REQ_RATES_STA		8
>
> I'd prefer if this was a validation on the input from userspace directly
> in cfg80211, that way other drivers that want to implement this don't
> have to bother.
>
> That probably goes well with the validation of the supported mask that I
> asked for.

It is valid to request that the station use a lesser rate, it just
needs to advertise that it supports the first 8 rates.  So, for the
rate-control logic, we use exactly what is passed in from user-space,
but when generating the HT-caps objects, we set a minimum of 8 MCS
rates.

So, if you want validation, then I'm going to have to add a second
mcs argument and mask to distinguish between what we should advertise
v/s what we should use to over-ride the local rate-control mechanism.

I will do this if you ask, but in my opinion, the current functionality
is good enough.

>> +	/* mac80211 allows over-riding some of the ht-capabilities */
>> +	local->hw.wiphy->ht_capa_mod_mask =
>> +		kzalloc(sizeof(*local->hw.wiphy->ht_capa_mod_mask),
>> +			GFP_KERNEL);
>> +	if (local->hw.wiphy->ht_capa_mod_mask) {
>> +		struct ieee80211_ht_cap *cm = local->hw.wiphy->ht_capa_mod_mask;
>> +		u8 *r = (u8 *)(&cm->mcs.rx_mask);
>> +		memset(r, 0xff, IEEE80211_HT_MCS_MASK_LEN);
>> +		cm->cap_info |= IEEE80211_HT_CAP_MAX_AMSDU;
>> +		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_FACTOR;
>> +		cm->ampdu_params_info |= IEEE80211_HT_AMPDU_PARM_DENSITY;
>> +	}
>
> Why is this not just a static const that you fill manually? There's
> nothing that's not constant here. So e.g.
>
> static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
> 	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
> 			     IEEE80211_HT_AMPDU_PARM_DENSITY,
> 	.mcs = {
> 		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
> 			     0xff, 0xff, 0xff, 0xff, 0xff, },
> 	},
> 	/* etc */
> };

Well, you suggested a pointer in the wiphy struct that was null
for non mac80211 interfaces.  I'm not sure how to distinguish between
mac80211 and other wiphys when reporting the capabilities if I use
this global static.  I also like that the non-static logic lets
us tweak this for individual drivers if that becomes an issue.

>> @@ -988,6 +1001,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
>>    fail_wiphy_register:
>>   	if (local->wiphy_ciphers_allocated)
>>   		kfree(local->hw.wiphy->cipher_suites);
>> +	kfree(local->hw.wiphy->ht_capa_mod_mask);
>> +	local->hw.wiphy->ht_capa_mod_mask = NULL;
>
> No need for this then obviously.
>
>
> Looks pretty good overall. This is _much_ more readable than the
> previous series. :-)

Thanks...making progress :)

Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
