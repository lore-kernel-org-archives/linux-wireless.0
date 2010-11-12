Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35902 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0KLSex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:34:53 -0500
Message-ID: <4CDD88C9.3090901@candelatech.com>
Date: Fri, 12 Nov 2010 10:34:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com> <4CDC354C.2060503@candelatech.com> <4CDC7860.3070307@candelatech.com> <4CDD12BD.7030208@kernel.org> <4CDD13D1.9070608@kernel.org> <4CDD8241.8000302@candelatech.com> <4CDD83BC.1090207@kernel.org>
In-Reply-To: <4CDD83BC.1090207@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 10:13 AM, Tejun Heo wrote:
> Hello,
>
> On 11/12/2010 07:06 PM, Ben Greear wrote:
>> On 11/12/2010 02:15 AM, Tejun Heo wrote:
>>> Please note that under those circumstances, what's guaranteed is
>>> forward-progress for workqueues which are used during memory reclaim.
>>> Continuously scheduling works which will in turn pile up on rtnl_lock
>>> is akin to constantly allocating memory while something holding
>>> rtnl_lock is blocked due to memory pressure.  Correctness-wise, it
>>> isn't necessarily deadlock but the only possible recourse is OOM.
>>
>>  From looking at the wireless code, since sdata is stopped, the
>> 'work' isn't going to actually do anything anyway.
>>
>> Is there a way to clear the work from the work-queue w/out
>> requiring any locks that a running worker thread might hold?
>> (So instead of flush_work, we could call something like "remove_all_work"
>> and not block on the worker thread that may currently be trying to
>> acquire rtnl?)
>
> Hmmm... there's cancel_work_sync().  It'll cancel if the work is
> pending and wait for completion if it's already running.  BTW, which

That would help, but it *might* be possible that the worker thread is
currently active.  That work shouldn't be asking for rtnl, as far as I can
tell, so maybe that's OK.  I'll give that a try in a bit.

> part of code are we talking about?  Can you please attach full thread
> dump at deadlock?

The problem code seems to be flush_work() call in ieee80211_do_stop()
in net/mac80211/iface.c.  RTNL is held when the flush_work() method
is called.

I've seen this apparently deadlock with a worker process trying to
call the wireless_nlevent_process method in net/wireless/wext-core.c
(it acquires rtnl).

Please let me know if you saw the previous thread dumps I sent in this thread.
Those were only for processes blocked > 120secs.  I can probably get
a full sysrq dump if you want that instead.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

