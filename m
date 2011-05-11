Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45451 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1EKRKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 13:10:20 -0400
Message-ID: <4DCAC2F0.7090308@candelatech.com> (sfid-20110511_191025_414416_8C583A41)
Date: Wed, 11 May 2011 10:10:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?QmrDtnJuIFNtZWRtYW4=?= <bjorn.smedman@venatech.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>	 <4DC81A61.9080101@candelatech.com>	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>	 <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>	 (sfid-20110511_175913_191261_9D02A924) <1305132500.17892.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1305132500.17892.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2011 09:48 AM, Johannes Berg wrote:
> On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:
>
>>> Yes, in theory that's possible, but apparently no driver actually did
>>> this correctly. Also, it didn't seem like anyone really cares, and we
>>> need to enforce some restrictions because otherwise drivers will end up
>>> doing it wrong, and you'll end up having a beacon interval of 200 while
>>> advertising 150 for example, which will totally throw off powersaving
>>> clients.
>>
>> I'm very interested in having multiple AP vifs with different beacon
>> intervals. If we're going to just fail anyway in this case can't we do
>> that from the drivers instead? I would also prefer that from an
>> aesthetic point of view, instead of having broken logic in the drivers
>> "protected" by extra verification in cfg80211.
>
> We can't fail from the drivers, they don't have a failure path.

Maybe we could treat the beacon interval setting as a requested
value, and give the caller some way to know the actual value
that is used by the hardware?

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

