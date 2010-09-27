Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41600 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab0I0QkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:40:06 -0400
Message-ID: <4CA0C8DF.7050609@candelatech.com>
Date: Mon, 27 Sep 2010 09:39:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: greearb@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] wireless: Use first phyX name available when registering
 phy devices.
References: <1285603646-7710-1-git-send-email-greearb@candelatech.com>	 <1285603646-7710-2-git-send-email-greearb@candelatech.com> <1285604243.4043.25.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285604243.4043.25.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2010 09:17 AM, Johannes Berg wrote:
> On Mon, 2010-09-27 at 09:07 -0700, greearb@gmail.com wrote:
>
>> @@ -346,16 +332,36 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
>>
>>   	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
>>   		wiphy_counter--;
>> +		goto too_many_devs;
>> +	}
>
> I believe the other path can also reduce the counter again, since it's
> another failure case? Not that I'm really worried about it though.
>
>> +	/* 64k wiphy devices is enough for anyone! */
>> +	for (i = 0; i<  0xFFFF; i++) {
>
> Come to think of it, this could be "i<= wiphy_counter", since in N
> devices, only N different names can be in use, so checking N+1 names
> will be sufficient, right?

I think it doesn't matter so much either way.  If we want to get really
paranoid about this, then we need to hash lookup of phy by index and name
and probably allow some reuse of phy indexes in case someone wants to reload
a module 4 billion times.

But, since current use is probably < 2 phys in most cases, and less than 500 in
all cases, I think we could just leave the code as is.  I'd guess the only reason
to change this is if we ever get usable virtual phys (netdev had the same migration
when VLANs started being useful and suddenly it was OK to have several thousand
interfaces.)

That said, I'll redo the patch if you want these changes.

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
