Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46920 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdBOPLP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 10:11:15 -0500
Message-ID: <58A46F91.6090707@candelatech.com> (sfid-20170215_161142_488440_531EB44B)
Date: Wed, 15 Feb 2017 07:11:13 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  allow overriding station bandwidth.
References: <1487106095-23287-1-git-send-email-greearb@candelatech.com>  (sfid-20170214_220143_477541_65E9EEB9) <1487144841.4026.1.camel@sipsolutions.net>
In-Reply-To: <1487144841.4026.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2017 11:47 PM, Johannes Berg wrote:
> On Tue, 2017-02-14 at 13:01 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This allows one to disable VHT160 (or 80+80) on hardware
>> that might otherwise try to use it.  One potential reason
>> to do this is that at least some 160Mhz/80+80 hardware can
>> only do 2x2 at 160Mhz, but can do 4x4 at 80Mhz.  And, due to
>> driver and firmware issues, it may effectively be limitted
>> to 1x1 at 160Mhz for some NICs.
>
> I think the feature is acceptable and don't mind adding that (though
> perhaps we should start thinking about making some of these things
> debug-only features), but I think the description of why you might want
> to do this is misleading - those issues you're describing really should
> be solved differently, and I posted the basis for that yesterday.

Likely for some time remote third-party peers will not update with your patches
to advertise the proper IEs, even if the local system does?

Either way, I suspect that 4x4 VHT80 may perform quite well vs 2x2 VHT160 if
there is any sort of interference on the secondary 80Mhz band...

But, I can just remove the 'why' part of the description entirely if you prefer?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
