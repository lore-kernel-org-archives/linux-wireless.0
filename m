Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46822 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab1KHRoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:44:02 -0500
Message-ID: <4EB96A5C.8040606@candelatech.com> (sfid-20111108_184410_734869_01E6FE3D)
Date: Tue, 08 Nov 2011 09:43:56 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320707676-17255-1-git-send-email-greearb@candelatech.com>  (sfid-20111108_001449_233997_95FF19FA) <1320740099.4304.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320740099.4304.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 12:14 AM, Johannes Berg wrote:
> On Mon, 2011-11-07 at 15:14 -0800, greearb@candelatech.com wrote:
>
>> +++ b/net/wireless/mlme.c
>> @@ -501,13 +501,32 @@ int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>>   	return err;
>>   }
>>
>> +/*  Do a logical ht_capa&= ht_capa_mask.  */
>> +static void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
>> +			const struct ieee80211_ht_cap *ht_capa_mask)
>> +{
>> +	int i;
>> +	u8 *p1, *p2;
>> +	if (!ht_capa_mask) {
>> +		memset(ht_capa, 0, sizeof(*ht_capa));
>> +		return;
>> +	}
>> +
>> +	p1 = (u8*)(ht_capa);
>> +	p2 = (u8*)(ht_capa_mask);
>> +	for (i = 0; i<sizeof(*ht_capa); i++)
>> +		p1[i]&= p2[i];
>> +}
>
> I think you also need to call this in the cfg80211_connect() path.

I'll double check that...for some reason I thought everything
eventually went through this code path.

>
> Also, maybe we should reject this configuration if the device didn't
> support it at all, ie. ht_capa_mask was NULL? It also seems a bit odd to
> allow this on a device that doesn't even support HT.

I really don't like that.  It would mean that supplicant will
have to selectively not add certain netlink attributes based on the
driver and/or kernel version.  That means either probing
to determine what the phy supports (and returning errors on
up to user if they configure it for something not supported?)
or just forcing the user to make all the decisions when writing
the supplicant config file.

The truth is, my app auto-generates the supplicant config files,
and I know what wifi driver I'm using etc, so it would be easy enough
for me to live with this.  But, it seems like it will make life
painful for anyone with less knowledge of the system.

> Also how would you feel about rejecting, instead of silently ignoring,
> things that we do look at but don't support, e.g. a wrong A-MSDU
> setting? Alternatively, cfg80211 could modify the settings in a way that
> drivers don't have to worry about the "downgrade only" part.

I dislike that as well, for similar reasons.  Getting an -EINVAL back
from a netlink call gives very little info to the user anyway...who
knows what exactly was invalid?  Perhaps a printk warning coming out
of mac80211 when it checks for the restrictions against what the
driver supports would be more useful?

> Finally, I think we need a tad more documentation about how this is
> supposed to work in case somebody wants to implement it on non-mac80211.
> The way it's done right now it seems fairly error prone, with all
> restrictions that the driver needs to implement like not allowing the
> a-MSDU size to be increased.

Well, who knows...in their driver maybe the restrictions are not
the same.  I think that adding more info about what fields are
currently supported for mac80211 might be useful, but trying to
generalize restrictions for drivers that have not even implemented
any of this seems like useless overhead.

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

