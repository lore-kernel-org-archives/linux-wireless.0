Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60832 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab0KQIzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 03:55:51 -0500
Message-ID: <4CE39892.2070306@kernel.org>
Date: Wed, 17 Nov 2010 09:55:46 +0100
From: Tejun Heo <tj@kernel.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com> <4CE292F7.4090200@kernel.org> <4CE2B6A0.8020709@candelatech.com>
In-Reply-To: <4CE2B6A0.8020709@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On 11/16/2010 05:51 PM, Ben Greear wrote:
>> 1. Try to capture the full dump.  Usually serial console works best.
> 
> This was from serial console, and I grabbed everything it printed
> to the screen.  I'll look in /var/log/messages in case there is more
> there.

Yeah, weird.  It doesn't look like it's missing random lines but it
definitely doesn't contain all the tasks.

> If you have a system with an ath5k nic, I should be able to show you
> how to reproduce it, if you're interested.

Unfortunately, I don't have ath5k.  I can order one if it's not too
expensive.  Anything you can recommend?

>> 2. Does adding WQ_MEM_RECLAIM to alloc_ordered_workqueue() call in
>>     ieee80211_register_hw() make any difference?
>>
>> 3. What if you replace it with the following?
>>
>>     alloc_workqueue(wiphy_name(local->hw.wiphy), WQ_NON_REENTRANT, 0)
> 
> I can try these things..hopefully today.
> 
> Can you explain briefly how this is supposed to work?  I'm certain that some
> workers can be blocked attempting to get rtnl.  When we call flush_work(),
> how is a worker chosen/created to flush that work?

They might not be solutions themselves but they should point where the
problem is.  flush_work() only flushes the target work.  It waits the
currently pending or executing work to finish execution.  Ordered
workqueue can execute only single work at any given time, so if
another work is taking a long time to finish, everything queued to the
workqueue will be delayed.  This is why I asked for the full dump so
that we can find out who's holding the queue.  The other reason a work
execution can be delayed is if there is no execution resource
available due to high memory pressure.  This again will be
distinguishible from task dump as rescue workers would be active and
manager worker would be in worker creation path.

The two suggested changes modify the workqueue behavior such that each
resolves one of the two issues.  If you set WQ_MEM_RECLAIM, workqueue
allocates a dedicated worker to use under memory pressure, so
execution resource is guaranteed to be there.  If you use
WQ_NON_REENTRANT, workqueue would execute multiple works in parallel
and a single work which takes a long time to finish won't delay other
works queued to the same workqueue.

Thanks.

-- 
tejun
