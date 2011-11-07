Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36729 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab1KGRkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 12:40:45 -0500
Message-ID: <4EB81817.9060300@candelatech.com> (sfid-20111107_184048_516868_05856B41)
Date: Mon, 07 Nov 2011 09:40:39 -0800
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

This goes back to how hard we want to be on user-space.  If we are lax,
and just ignore settings that are not (yet?) supported by the kernel,
then user-space becomes much easier to make backwards/forwards
compat.  That is my preferred approach.

In order for drivers (I assume you mean mac80211 as a driver)
to support more stuff, then we will have to explicitly add
more code there.  At that point, the ht-capa-mod-mask
will need to be updated to stay in sync.  The mod-mask is going
to live in mac80211 as far as I can tell, it seems valid
to just keep them up to date in that manner and let user-space
be oblivious to the mask *if it prefers*.

If you feel strongly that we need to be very strict with
user-space in this case, then please say so, and I'll quite arguing
and code it up.  It is going to make the hostapd code
more complex, however.


Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

