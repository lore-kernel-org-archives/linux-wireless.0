Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33304 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbbLCXMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 18:12:38 -0500
Subject: Re: Can we increase IEEE80211_MAX_QUEUES
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <5660A31E.3010507@candelatech.com>
 <1449174081.31265.3.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5660CC65.3000507@candelatech.com> (sfid-20151204_001241_766898_5E0B338C)
Date: Thu, 3 Dec 2015 15:12:37 -0800
MIME-Version: 1.0
In-Reply-To: <1449174081.31265.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/03/2015 12:21 PM, Johannes Berg wrote:
> On Thu, 2015-12-03 at 12:16 -0800, Ben Greear wrote:
>> ath10k wants to use vdev-id as a queue-id, and I want to support up
>> to
>> 64 vdevs.  In the 4.2 kernel, this is causing splats when using lots
>> of
>> vdevs because then queue is out of range.
>>
>> Can we just increase IEEE80211_MAX_QUEUES to 64?
>>
>
> I think not, that would likely cause a lot of data structures to grow
> too much. We'd have to do more dynamic things in that case, I suppose.
>
> Does the original premise even make sense though? A single queue for
> each vdev seems a bit strange.

Comments in ath10k claim that the approach makes per-vif tx locking
much easier and that is why that code was added....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

