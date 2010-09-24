Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33675 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab0IXWhN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 18:37:13 -0400
Message-ID: <4C9D280F.1080509@candelatech.com>
Date: Fri, 24 Sep 2010 15:37:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>	 <1285362170.11036.1.camel@jlt3.sipsolutions.net>	 <4C9D13AC.4080308@candelatech.com>	 <1285363135.11036.7.camel@jlt3.sipsolutions.net>	 <4C9D1760.3040103@candelatech.com>	 <1285363861.11036.8.camel@jlt3.sipsolutions.net>	 <4C9D2487.5040202@candelatech.com> <1285367144.11036.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285367144.11036.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/24/2010 03:25 PM, Johannes Berg wrote:
> On Fri, 2010-09-24 at 15:21 -0700, Ben Greear wrote:
>
>> Here's a patch for consideration.  It's on top of my other patch,
>> but I can re-do it against a tree with that reverted if you prefer.
>
> You also want to remove the restriction on renaming to phy%d now.

Same patch, or a second one?

>> +	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx)))
>> +		goto too_many_devs;
>> +
>>    	/* 64k wiphy devices is enough for anyone! */
>>    	for (i = 0; i<  0xFFFF; i++) {
>
> why limit yourself to this? You're guaranteed to find a free index if
> you don't, so error handling could be easier?

It's an N^2 loop, and if we are unlikely to ever need more than 512 STAs, I figure
64k phys is probably enough. :)

But, will change it if you want.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

