Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57614 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1KGRpH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:45:07 -0500
Message-ID: <4EB81920.7000408@candelatech.com> (sfid-20111107_184511_752452_084E20C8)
Date: Mon, 07 Nov 2011 09:45:04 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320437440-6463-1-git-send-email-greearb@candelatech.com>  (sfid-20111104_211056_032573_0C709B20) <1320656776.3993.21.camel@jlt3.sipsolutions.net>  <4EB81817.9060300@candelatech.com> <1320687773.3993.53.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320687773.3993.53.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2011 09:42 AM, Johannes Berg wrote:
> On Mon, 2011-11-07 at 09:40 -0800, Ben Greear wrote:
>> On 11/07/2011 01:06 AM, Johannes Berg wrote:
>>
>>>> @@ -537,6 +539,12 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
>>>>    	memcpy(&req.crypto, crypt, sizeof(req.crypto));
>>>>    	req.use_mfp = use_mfp;
>>>>    	req.prev_bssid = prev_bssid;
>>>> +	req.flags = assoc_flags;
>>>> +	if (ht_capa)
>>>> +		memcpy(&req.ht_capa, ht_capa, sizeof(req.ht_capa));
>>>> +	if (ht_capa_mask)
>>>> +		memcpy(&req.ht_capa_mask, ht_capa_mask,
>>>> +		       sizeof(req.ht_capa_mask));
>>>
>>> I think somewhere here you should mask this mask with the
>>> ht_capa_mod_mask. That way, you force drivers to advertise a correct
>>> ht_capa_mod_mask, if you don't do that we will certainly see drivers use
>>> more of ht_capa than contained in ht_capa_mod_mask. Probably should be a
>>> helper function since I think you might need it in more places.
>>
>> This goes back to how hard we want to be on user-space.  If we are lax,
>> and just ignore settings that are not (yet?) supported by the kernel,
>> then user-space becomes much easier to make backwards/forwards
>> compat.  That is my preferred approach.
>
> No, not really -- I'm not saying reject it, I'm just saying don't let
> userspace configure more than the driver said it could configure. if you
> just do essentially "configured_masked&= advertised_mask" you still
> keep this property you want, but you force drivers to advertise
> everything users will be able to change otherwise it just doesn't take
> effect.

Ok, I think I understand, and that sounds fine to me.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

