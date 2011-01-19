Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53465 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab1ASAnX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 19:43:23 -0500
Message-ID: <4D36339F.3020506@candelatech.com>
Date: Tue, 18 Jan 2011 16:43:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: try more than one tid when scheduling a new
 aggregate
References: <1295098215-98910-1-git-send-email-nbd@openwrt.org> <4D362FC5.3090003@candelatech.com> <4D363165.1010306@openwrt.org>
In-Reply-To: <4D363165.1010306@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2011 04:33 PM, Felix Fietkau wrote:
> On 2011-01-19 1:26 AM, Ben Greear wrote:
>> On 01/15/2011 05:30 AM, Felix Fietkau wrote:
>>> Sometimes the first TID in the first AC's list is not available for forming
>>> a new aggregate (the BAW might not allow it), however other TIDs may have
>>> data available for sending.
>>> Prevent a slowdown of other TIDs by going through multiple entries until
>>> we've either hit the last one or enough AMPDUs are pending in the hardware
>>> queue.
>>
>> I had attempted a similar patch, but I was thinking we should iterate
>> through all of the txq->axq_acq entries, not just use the first one?
>>
>> If you agree, I can merge my patch with your patch below
>> and re-post.
> My patch was merged, how about sending an incremental patch on top of it
> for review?

Right...I just wanted to make sure that it was a sane thing to do
before making the effort.

I'll try to get something posted soonish.

Thanks,
Ben

>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

