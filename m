Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35035 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1AZSKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 13:10:34 -0500
Message-ID: <4D406396.2090407@candelatech.com>
Date: Wed, 26 Jan 2011 10:10:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating channel.
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com> <1296056188.3635.36.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296056188.3635.36.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2011 07:36 AM, Johannes Berg wrote:
> On Fri, 2011-01-21 at 10:05 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This should decrease un-necessary flushes, on/off channel work,
>> and channel changes in cases where the only scanned channel is
>> the current operating channel.
>>
>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>> ---
>>
>> v2:  Check channels instead of flag when determining if we should
>>    do a channel change in scan_completed_finish.
>
> Can you look at work.c -- where we call
> ieee80211_offchannel_stop_beaconing etc.
>
> In this patch, you're moving the call to
> ieee80211_offchannel_stop_beaconing next to
> ieee80211_offchannel_stop_station in scan.c.
>
> Therefore, you can combine those two into one function.
>
> However, I guess it'd also be nice to also address the TODO in work.c
> and move the "don't do so much if not really off-channel" logic into
> that function? You must run into that when trying to associate on one
> vif and the others get stopped etc. unnecessarily to do that.

I think you are right about this, but due to the tricky nature
of this code, maybe save that for a second patch?

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

