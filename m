Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38891 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2LMSV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:21:29 -0500
Message-ID: <50CA1C44.5030300@candelatech.com> (sfid-20121213_192132_610903_5258188D)
Date: Thu, 13 Dec 2012 10:19:48 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Add a new work-queue for destructing stations?
References: <50CA1470.4030107@candelatech.com>  (sfid-20121213_184629_945929_240FAE82) <1355421541.9463.8.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355421541.9463.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/13/2012 09:59 AM, Johannes Berg wrote:
> On Thu, 2012-12-13 at 09:46 -0800, Ben Greear wrote:
>> As previously posted, there can be cases where the RTNL is held for a
>> very long time when trying to do the:  flush_workqueue(local->workqueue);
>> in mac80211_do_stop because there are lots of 'slow' work-items queued up.
>>
>> I'd like to work on making this faster...
>>
>> My first idea is to add a second work-queue to the 'local' for high-priority
>> items that can be executed independently from the current local->workqueue,
>> and put the free_sta_rcu work() in that queue.
>>
>> I'm guessing that to be safe, the do_stop() code would need to selectively
>> purge any work items in the local->workqueue that relate to the sdata
>> being destroyed, as well.  I'm not sure how possible that would be...
>
> I don't think that's easy, but you're welcome to try. The
> free_sta_work() function references the sdata so it absolutely must run
> at this point.
>
> The only/easiest thing that seems vaguely safe would be a per-vif
> workqueue for this? But that's really annoying too, since it needs an
> extra thread etc.

So, cancel_work_sync(&sdata->work) would appear to remove
all pending sdata->work items from the work-queue.  As long as
there are no other different work items that reference
sdata (and maybe there are..I haven't looked at all of them),
then we should be safe to execute the free_sta_work()
on a different work-queue safely, I think....

I'll go look at the other work items and see what I can see.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

