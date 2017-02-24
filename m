Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47710 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdBXPdi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 10:33:38 -0500
Subject: Re: [PATCH 160/306] mac80211-hwsim: add rate-limited debugging for
 rx-netlink
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
 <1487896109-23851-5-git-send-email-greearb@candelatech.com>
 <1487918388.2540.6.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <c014eb8c-7f93-3831-3375-07f6f6325a6a@candelatech.com> (sfid-20170224_163356_962734_34CF95D1)
Date: Fri, 24 Feb 2017 07:27:29 -0800
MIME-Version: 1.0
In-Reply-To: <1487918388.2540.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/23/2017 10:39 PM, Johannes Berg wrote:
>
>> +	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
>> +		if (net_ratelimit())
>> +			printk(KERN_DEBUG " hwsim rx-nl: Missing
>> required attribute\n");
>
> I'm not convinced net_ratelimit() is a good idea, that's a global rate
> limiter.

Is there a better rate-limiter w/out hand-crafting something?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
