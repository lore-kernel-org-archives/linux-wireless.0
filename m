Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55691 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab1KGQ1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 11:27:07 -0500
Message-ID: <4EB806D7.6050104@candelatech.com> (sfid-20111107_172712_086033_BF4D8A55)
Date: Mon, 07 Nov 2011 08:27:03 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>  (sfid-20111104_211056_032573_0C709B20) <1320656776.3993.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320656776.3993.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 01:06 AM, Johannes Berg wrote:
> On Fri, 2011-11-04 at 13:10 -0700, greearb@candelatech.com wrote:
>
>> + * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
>> + *      this feature.
>
> I can see this, but
>
>> + * @NL80211_ATTR_DISABLE_HT40:  Disable HT-40 even if AP and hardware
>> + *      support it.
>> + * @NL80211_ATTR_HT_CAPABILITY_MASK: Specify which bits of the HT_CAPs
>> + *      to pay attention to.
>
> if you have the mask why do you still need the HT40? Isn't HT40 a flag
> in the mask? Or do you want this to affect TX/RX separately? You should
> spell that out more explicitly then.

I think it would work to just use the mask & ht-cap overrides to disable HT40.
I'll see if I can get that working properly.

>
>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -704,6 +704,9 @@ void wiphy_unregister(struct wiphy *wiphy)
>>   	flush_work(&rdev->scan_done_wk);
>>   	cancel_work_sync(&rdev->conn_work);
>>   	flush_work(&rdev->event_work);
>> +
>> +	kfree(rdev->wiphy.ht_capa_mod_mask);
>> +	rdev->wiphy.ht_capa_mod_mask = NULL;
>
> That doesn't seem right -- drivers should typically assign a static
> const variable to this pointer that can't be freed.

Earlier I think you argued that all of mac80211 drivers automatically supported
these features as long as I put in the limitations that certain values
could only be increased and certain only decreased, etc.

So, I put it in the mac80211 code instead of down in the drivers.
But, I can move it into ath9k if you prefer.

>> @@ -537,6 +539,12 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
>>   	memcpy(&req.crypto, crypt, sizeof(req.crypto));
>>   	req.use_mfp = use_mfp;
>>   	req.prev_bssid = prev_bssid;
>> +	req.flags = assoc_flags;
>> +	if (ht_capa)
>> +		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
>> +	if (ht_capa_mask)
>> +		memcpy(&req.ht_capa_mask, ht_capa_mask,
>> +		       sizeof(req.ht_capa_mask));
>
> I think somewhere here you should mask this mask with the
> ht_capa_mod_mask. That way, you force drivers to advertise a correct
> ht_capa_mod_mask, if you don't do that we will certainly see drivers use
> more of ht_capa than contained in ht_capa_mod_mask. Probably should be a
> helper function since I think you might need it in more places.

Sure, I can add that.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
