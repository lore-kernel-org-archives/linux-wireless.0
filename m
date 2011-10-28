Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33157 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1J1Qdi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 12:33:38 -0400
Message-ID: <4EAAD95E.1030001@candelatech.com> (sfid-20111028_183341_942256_664FE0B1)
Date: Fri, 28 Oct 2011 09:33:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH 3/5] wifi: Allow overriding some HT information.
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>  <1319778680-11405-3-git-send-email-greearb@candelatech.com>  (sfid-20111028_071147_787476_DBCC8CCF) <1319789573.3914.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319789573.3914.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2011 01:12 AM, Johannes Berg wrote:
> On Thu, 2011-10-27 at 22:11 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> * Allow configuring the mcs (/n) rates available.
>> * Allow configuration of MAX-A-MSDU
>> * Allow configuration of A-MPDU factor&  density.
>>
>> Users can only remove existing rates.  The MSDU and MPDU
>> values can be set to any value allowed by the 802.11n
>> specification.
>
> That can't work -- the device might not support it.

The device would always support removing rates, right?

As for the MSDU and MPDU stuff, I would need to add capabilities
flags and then enable each driver as they are tested?

> I also don't really like the way you pass in some binary "mask" when
> it's not really a binary masking operation.

I found the mask to work very well.  It's easy enough to
deal with in user-space, and easily allows us to add override features
(the additional bits to support the MPDU stuff once the
HT rates logic was in is a very small bit of code).

Otherwise, I'll need to add new netlink commands for each new
feature.  That is going to bloat hostapd as well as the
kernel.

>
>>   struct vif_params {
>>   	int use_4addr;
>>   	int disable_11n;
>>   	int disable_ht40;
>> +	struct ieee80211_ht_cap *ht_capa;
>> +	struct ieee80211_ht_cap *ht_capa_mask;
>
> Same comments as before again -- this is per connection right?

I meant it to be per interface.  I'm using lots of virtual stations,
and want some to act like /abg radios, and others to be ht-20 only,
and others to be capable of only up to mcs7, etc.

>> @@ -114,6 +115,19 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
>>   	if (ht_info_ie[1]<  sizeof(struct ieee80211_ht_info))
>>   		return;
>>
>> +	memcpy(&ht_cap,&sband->ht_cap, sizeof(ht_cap));
>> +	/*
>> +	 * This is for an association attempt, and we must
>> +	 * advert at least the first 8 rates, even if we
>> +	 * will later force the rate control to a lower rate.
>> +	 */
>> +	ieee80211_apply_htcap_overrides(sdata,&ht_cap, 8);
>
> Yuck, why, why hard-code 8, etc.

I can make a define that involves MCS7.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

