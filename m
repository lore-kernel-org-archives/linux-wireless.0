Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41485 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0KLVvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 16:51:15 -0500
Message-ID: <4CDDB6C9.1010602@candelatech.com>
Date: Fri, 12 Nov 2010 13:51:05 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1289596096.3736.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 01:08 PM, Johannes Berg wrote:
> On Fri, 2010-11-12 at 12:57 -0800, Ben Greear wrote:
>
>>> However, I also don't think it should be necessary to do this.
>>> sdata->work is always queued on local->workqueue, which is created using
>>> alloc_ordered_workqueue(), and there is no work on this workqueue that
>>> uses the RTNL. Therefore, even flushing the entire workqueue must work,
>>> unless alloc_ordered_workqueue() has no such guarantee any more -- which
>>> I would consider to be a bug in the new workqueue framework.
>>
>> The problem appears (to me) to be that the flush_work() attempts
>> to wait for the worker to complete it's current task.  The worker can
>> be doing a completely separate task (ie, wireless_nlevent_process),
>> but that task can never complete because do_stop() holds rtnl
>> and the task-in-progress may block on acquiring rtnl.
>>
>> So, flush_work() cannot make any progress.
>>
>> The stack-traces for hung programs I originally posted seem
>> to agree with this analysis.
>>
>> So far, I reproduced the bug around 20 times in a row witout the patch,
>> and since I added this patch, I have two good runs in a row, so it definitely
>> has an affect.
>>
>> If my assumptions are correct, it would seem to unsafe to EVER
>> call flush_work() while holding rtnl (or indeed, any other lock
>> that any other work could possibly require).
>
> Well then in that case all I'm saying is that we have a bug in the
> workqueue code, because it used to be allowed to flush a workqueue that
> never had any work items on it that grabbed the RTNL themselves. I
> actually added lockdep detection for the case where you _did_, but since
> I'm sure we don't have anything that grabs the RTNL on our workqueue,
> this should be OK.

You may well be right.  The current behaviour makes
flush_work() pretty tricky to use correctly.

I'll let the folks that know work-queues better be
the judge.

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

