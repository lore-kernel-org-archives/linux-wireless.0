Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47358 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbdBXP0m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 10:26:42 -0500
Subject: Re: [PATCH 161/306] mac80211-hwsim: Improve logging.
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
 <1487896109-23851-6-git-send-email-greearb@candelatech.com>
 <1487918553.2540.9.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <690c2294-67c7-f87b-2c6f-a3f1446c3be8@candelatech.com> (sfid-20170224_162726_735961_00E72279)
Date: Fri, 24 Feb 2017 07:26:40 -0800
MIME-Version: 1.0
In-Reply-To: <1487918553.2540.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/23/2017 10:42 PM, Johannes Berg wrote:
>
>> +		static unsigned int cnt = 0;
>> +		/* This is fairly common, and usually not a
>> bug.  So, print errors
>> +		   rarely. */
>> +		if (((cnt++ & 0x3FF) == 0x3FF) && net_ratelimit())
>> +			printk(KERN_DEBUG " hwsim rx-nl: radio %pM
>> idle: %d or not started: %d cnt: %d\n",
>> +			       dst, data2->idle, !data2->started,
>> cnt);
>>  		goto out;
>>  	}
>
> You just added that in the previous patch...
>
> Please take a bit more care, or I'll eventually stop looking at your
> patches since things like that seem to happen over and over again. I
> don't get a feeling that you actually care about getting things
> upstream much anyway.

I wrote these patches over a long period of time.  Some, like the binary
API things I already knew you did not want, but I posted them since
it seems several people are looking at this sort of thing and maybe
they will have a good idea how to add similar behaviour in an efficient
manner.  I think your previous suggestion was that I should map each
flag in some translate code and/or bloat up netlink API, and neither
of those options seemed like an efficient use of CPU time.

I'll work to fix the cosmetic problems and squash these logging patches
and re-submit those.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
