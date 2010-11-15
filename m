Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58239 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab0KOVRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 16:17:09 -0500
Message-ID: <4CE1A344.7040201@candelatech.com>
Date: Mon, 15 Nov 2010 13:16:52 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>	 <4CDDAA3B.9090007@candelatech.com> <1289596096.3736.13.camel@jlt3.sipsolutions.net> <4CDE699B.70401@kernel.org>
In-Reply-To: <4CDE699B.70401@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/13/2010 02:34 AM, Tejun Heo wrote:
> Hello,
>
> On 11/12/2010 10:08 PM, Johannes Berg wrote:
>> On Fri, 2010-11-12 at 12:57 -0800, Ben Greear wrote:
>>
>>>> However, I also don't think it should be necessary to do this.
>>>> sdata->work is always queued on local->workqueue, which is created using
>>>> alloc_ordered_workqueue(), and there is no work on this workqueue that
>>>> uses the RTNL. Therefore, even flushing the entire workqueue must work,
>>>> unless alloc_ordered_workqueue() has no such guarantee any more -- which
>>>> I would consider to be a bug in the new workqueue framework.
>
> alloc_ordered_workqueue() itself doesn't have forward progress
> guarantee under memory pressure.  You'll need to add WQ_MEM_RECLAIM
> for that, but I don't really think that's the problem here as it isn't
> in the memory reclaim path.
>
>>> The problem appears (to me) to be that the flush_work() attempts
>>> to wait for the worker to complete it's current task.  The worker can
>>> be doing a completely separate task (ie, wireless_nlevent_process),
>>> but that task can never complete because do_stop() holds rtnl
>>> and the task-in-progress may block on acquiring rtnl.
>>>
>>> So, flush_work() cannot make any progress.
>>>
>>> The stack-traces for hung programs I originally posted seem
>>> to agree with this analysis.
>
> Can you please attach the whole thing?
>
>>> So far, I reproduced the bug around 20 times in a row witout the patch,
>>> and since I added this patch, I have two good runs in a row, so it definitely
>>> has an affect.
>>>
>>> If my assumptions are correct, it would seem to unsafe to EVER
>>> call flush_work() while holding rtnl (or indeed, any other lock
>>> that any other work could possibly require).
>>
>> Well then in that case all I'm saying is that we have a bug in the
>> workqueue code, because it used to be allowed to flush a workqueue that
>> never had any work items on it that grabbed the RTNL themselves. I
>> actually added lockdep detection for the case where you _did_, but since
>> I'm sure we don't have anything that grabs the RTNL on our workqueue,
>> this should be OK.
>
> Yeah, that would be a pretty big flaw in the workqueue code and we
> would be seeing the system collapsing in whole lot more places.  It's
> likely a more subtle issue which is livelocking or fork-bombing
> workqueue.  New workqueue code maintains compatibility with the old
> implementation but sometimes does triggers problems which were masked
> due to the statically allocated execution resource before.  So, there
> are few cases where the user code needs to be adjusted (e.g. xfs
> needed some tweaking).
>
> Anyways, let's look into what's going on.
>
> Thanks.

Here's the full trace of sysrq-t output:




SysRq : Show State
Nov 15 13:11:57 localhost kernel: x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213bea0     0  1494      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea80dda0 00000046 00000007 f213bea0 c0449a1d 00000004 78a02380 f213bea0
Nov 15 13:11:57 localhost kernel: 78a02380 f213c11c f213c118 f213c118 78a02380 78a02380 001928f3 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213bea0 ea80dd98 ea80ddd0 ea80dda8 f213bea0 ea80ddc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213c910     0  1495      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea80fda0 00000046 00000007 f213c910 c044d2ef 00000004 78a02380 f213c910
Nov 15 13:11:57 localhost kernel: 78a02380 f213cb8c f213cb88 f213cb88 78a02380 78a02380 0018849a 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213c910 ea80fd98 ea80fdd0 ea80fda8 f213c910 ea80fdc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213d380     0  1496      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea819da0 00000046 00000007 f213d380 c0450974 00000004 78a02380 f213d380
Nov 15 13:11:57 localhost kernel: 78a02380 f213d5fc f213d5f8 f213d5f8 78a02380 78a02380 0017c399 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213d380 ea819d98 ea819dd0 ea819da8 f213d380 ea819dc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213ddf0     0  1497      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea81bda0 00000046 00000007 f213ddf0 c04540a0 00000004 78a02380 f213ddf0
Nov 15 13:11:57 localhost kernel: 78a02380 f213e06c f213e068 f213e068 78a02380 78a02380 00165f6c 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213ddf0 ea81bd98 ea81bdd0 ea81bda8 f213ddf0 ea81bdc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213e860     0  1498      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea81dda0 00000046 00000007 f213e860 c045b33e 00000004 78a02380 f213e860
Nov 15 13:11:57 localhost kernel: 78a02380 f213eadc f213ead8 f213ead8 78a02380 78a02380 0015c042 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213e860 ea81dd98 ea81ddd0 ea81dda8 f213e860 ea81ddc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S f213f2d0     0  1499      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea81fda0 00000046 00000007 f213f2d0 c04579ac 00000004 78a02380 f213f2d0
Nov 15 13:11:57 localhost kernel: 78a02380 f213f54c f213f548 f213f548 78a02380 78a02380 00175ca3 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 f213f2d0 ea81fd98 ea81fdd0 ea81fda8 f213f2d0 ea81fdc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<78492e93>] ? __alloc_pages_nodemask+0x136/0x668
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<784a3100>] ? handle_mm_fault+0x725/0x825
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: console-kit-d S ea820000     0  1500      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea829da0 00000046 00000007 ea820000 c04b62d9 00000004 78a02380 ea820000
Nov 15 13:11:57 localhost kernel: 78a02380 ea82027c ea820278 ea820278 78a02380 78a02380 000ee894 00000000
Nov 15 13:11:57 localhost kernel: f45e7400 00000004 ea820000 ea829d98 ea829dd0 ea829da8 ea820000 ea829dc8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<78613bd9>] vt_event_wait+0x9d/0xd8
Nov 15 13:11:57 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:57 localhost kernel: [<78613c39>] vt_waitactive+0x25/0x40
Nov 15 13:11:57 localhost kernel: [<7856192c>] ? security_capable+0x25/0x29
Nov 15 13:11:57 localhost kernel: [<78614e7e>] vt_ioctl+0xfe4/0x167e
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:11:57 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:11:57 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<78613e9a>] ? vt_ioctl+0x0/0x167e
Nov 15 13:11:57 localhost kernel: [<7860d20c>] tty_ioctl+0x894/0x8f8
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<78427eb6>] ? cpuacct_charge+0x50/0x57
Nov 15 13:11:57 localhost kernel: [<78428600>] ? update_curr+0x15a/0x172
Nov 15 13:11:57 localhost kernel: [<7860c978>] ? tty_ioctl+0x0/0x8f8
Nov 15 13:11:57 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:57 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:57 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 15 13:11:57 localhost kernel: [<78430309>] ? finish_task_switch+0x72/0xd4
Nov 15 13:11:57 localhost kernel: [<784c13e2>] ? fget_light+0xa6/0xb0
Nov 15 13:11:57 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:11:57 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: hald-runner   S ea8e5b03     0  1438   1434 0x00000080
Nov 15 13:11:57 localhost kernel: ea8e5b70 00000046 00000001 ea8e5b03 d746a760 00000007 78a02380 f21d4910
Nov 15 13:11:57 localhost kernel: 78a02380 f21d4b8c f21d4b88 f21d4b88 78a02380 78a02380 000f9f28 00000000
Nov 15 13:11:57 localhost kernel: eabd9680 00000007 f21d4910 ea8e5b70 00000000 00000000 00000000 ea8e5bb8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:11:57 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:11:57 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:57 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:57 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:11:57 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:57 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:57 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:11:57 localhost kernel: [<78427185>] ? check_preempt_curr+0x18/0x2e
Nov 15 13:11:57 localhost kernel: [<7845991e>] ? trace_hardirqs_off+0xb/0xd
Nov 15 13:11:57 localhost kernel: [<7878e274>] ? _raw_spin_unlock_irqrestore+0x35/0x48
Nov 15 13:11:57 localhost kernel: [<784320d1>] ? try_to_wake_up+0x1ff/0x209
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<784320e6>] ? default_wake_function+0xb/0xd
Nov 15 13:11:57 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:11:57 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:11:57 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:57 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:57 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:11:57 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:11:57 localhost kernel: [<787651b4>] ? unix_stream_sendmsg+0x1d7/0x23c
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<786e5fe4>] ? __sock_sendmsg+0x54/0x5b
Nov 15 13:11:57 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:11:57 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:11:57 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:11:57 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:11:57 localhost kernel: [<784c0e16>] ? do_readv_writev+0xe8/0xf5
Nov 15 13:11:57 localhost kernel: [<786e7ebd>] ? sock_aio_write+0x0/0xdf
Nov 15 13:11:57 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:11:57 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: hald-addon-rf S ea82bb03     0  1529   1438 0x00000080
Nov 15 13:11:57 localhost kernel: ea82bb70 00000046 00000001 ea82bb03 dcd243d5 00000004 78a02380 ea820a70
Nov 15 13:11:57 localhost kernel: 78a02380 ea820cec ea820ce8 ea820ce8 78a02380 78a02380 0030bb3a 00000000
Nov 15 13:11:57 localhost kernel: f3c58f00 00000004 ea820a70 ea82bb70 00000000 00000000 00000000 ea82bbb8
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:11:57 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:11:57 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:57 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:57 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:57 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:57 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<7845a500>] ? trace_hardirqs_on_caller+0xbf/0x125
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:11:57 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:11:57 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:11:57 localhost kernel: [<787651b4>] ? unix_stream_sendmsg+0x1d7/0x23c
Nov 15 13:11:57 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:57 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:57 localhost kernel: [<786e5fe4>] ? __sock_sendmsg+0x54/0x5b
Nov 15 13:11:57 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:11:57 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:11:57 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:11:57 localhost kernel: [<784c0e16>] ? do_readv_writev+0xe8/0xf5
Nov 15 13:11:57 localhost kernel: [<786e7ebd>] ? sock_aio_write+0x0/0xdf
Nov 15 13:11:57 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:11:57 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:11:57 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:57 localhost kernel: sshd          S ea8214e0     0  1577      1 0x00000080
Nov 15 13:11:57 localhost kernel: ea881ad4 00000046 00000000 ea8214e0 fa510975 00000005 78a02380 ea8214e0
Nov 15 13:11:57 localhost kernel: 78a02380 ea82175c ea821758 ea821758 78a02380 78a02380 00007980 00000000
Nov 15 13:11:57 localhost kernel: eaa42f00 00000005 ea8214e0 ea881c0c 00000000 00000000 00000004 ea881b1c
Nov 15 13:11:57 localhost kernel: Call Trace:
Nov 15 13:11:57 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:11:57 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:57 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:11:57 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:11:58 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:58 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:58 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:11:58 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:11:58 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<784223b5>] ? __change_page_attr_set_clr+0x261/0x6ac
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:11:58 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:58 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:11:58 localhost kernel: [<784cca98>] ? copy_from_user+0x8/0xa
Nov 15 13:11:58 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:11:58 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:11:58 localhost kernel: [<784b4df9>] ? add_partial+0x11/0x3b
Nov 15 13:11:58 localhost kernel: [<7878e2a4>] ? _raw_spin_unlock+0x1d/0x20
Nov 15 13:11:58 localhost kernel: [<784b6a51>] ? kmem_cache_free+0xa4/0xb5
Nov 15 13:11:58 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:58 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:58 localhost kernel: [<784ce2cb>] ? __d_free+0x39/0x3c
Nov 15 13:11:58 localhost kernel: [<784ce2cb>] ? __d_free+0x39/0x3c
Nov 15 13:11:58 localhost kernel: [<784ce2cb>] ? __d_free+0x39/0x3c
Nov 15 13:11:58 localhost kernel: [<784ce30e>] ? d_free+0x40/0x50
Nov 15 13:11:58 localhost kernel: [<784ce3f0>] ? d_kill+0x2b/0x31
Nov 15 13:11:58 localhost kernel: [<784cfb5b>] ? dput+0x39/0x102
Nov 15 13:11:58 localhost kernel: [<784c16f4>] ? fput+0x182/0x18a
Nov 15 13:11:58 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: ntpd          D 7845a0d5     0  1592      1 0x00000080
Nov 15 13:11:58 localhost kernel: f2171e04 00200046 f2171dd4 7845a0d5 680863df 00000019 78a02380 ea825df0
Nov 15 13:11:58 localhost kernel: 78a02380 ea82606c ea826068 ea826068 78a02380 78a02380 00734a25 00000000
Nov 15 13:11:58 localhost kernel: e38c3180 00000019 ea825df0 789826b4 789826b4 ea825df0 789826b8 f2171e50
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:11:58 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:11:58 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:11:58 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:11:58 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:11:58 localhost kernel: [<786f716a>] dev_ioctl+0x21/0x53f
Nov 15 13:11:58 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:58 localhost kernel: [<785a4926>] ? __raw_spin_lock_init+0x2d/0x4f
Nov 15 13:11:58 localhost kernel: [<7873d321>] ? udp_ioctl+0x0/0x5f
Nov 15 13:11:58 localhost kernel: [<786e5f15>] sock_ioctl+0x1f6/0x202
Nov 15 13:11:58 localhost kernel: [<784bec9b>] ? fd_install+0x27/0xa9
Nov 15 13:11:58 localhost kernel: [<786e5d1f>] ? sock_ioctl+0x0/0x202
Nov 15 13:11:58 localhost kernel: [<784cc071>] do_vfs_ioctl+0x56d/0x5c3
Nov 15 13:11:58 localhost kernel: [<7878e2a4>] ? _raw_spin_unlock+0x1d/0x20
Nov 15 13:11:58 localhost kernel: [<784bed16>] ? fd_install+0xa2/0xa9
Nov 15 13:11:58 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:11:58 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:11:58 localhost kernel: [<784cc10a>] sys_ioctl+0x43/0x62
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: vsftpd        S 0000313b     0  1603      1 0x00000080
Nov 15 13:11:58 localhost kernel: f2389e2c 00200046 78ba3cac 0000313b ed59ce9e 00000004 78a02380 ea825380
Nov 15 13:11:58 localhost kernel: 78a02380 ea8255fc ea8255f8 ea8255f8 78a02380 78a02380 0008ea9e 00000000
Nov 15 13:11:58 localhost kernel: f45e7680 00000004 ea825380 f2389e2c f465f840 7fffffff ea825380 f2389e70
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:58 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:11:58 localhost kernel: [<7843c1ef>] ? _local_bh_enable_ip+0x9d/0xa6
Nov 15 13:11:58 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:11:58 localhost kernel: [<7878e211>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 15 13:11:58 localhost kernel: [<786e8eaf>] ? release_sock+0x118/0x11f
Nov 15 13:11:58 localhost kernel: [<78727484>] inet_csk_accept+0x9e/0x19c
Nov 15 13:11:58 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:11:58 localhost kernel: [<78745230>] inet_accept+0x20/0x9b
Nov 15 13:11:58 localhost kernel: [<786e7531>] sys_accept4+0xb4/0x155
Nov 15 13:11:58 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:58 localhost kernel: [<7843c1ef>] ? _local_bh_enable_ip+0x9d/0xa6
Nov 15 13:11:58 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<786e7caa>] sys_socketcall+0x27b/0x289
Nov 15 13:11:58 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: httpd         S ea821f50     0  1611      1 0x00000080
Nov 15 13:11:58 localhost kernel: f23b9ad4 00000046 00000000 ea821f50 f553f9ea 0000001b 78a02380 ea821f50
Nov 15 13:11:58 localhost kernel: 78a02380 ea8221cc ea8221c8 ea8221c8 78a02380 78a02380 000063b9 00000000
Nov 15 13:11:58 localhost kernel: e38c2780 0000001b ea821f50 00000000 f23b9e24 00000000 f23b9ae4 f23b9b1c
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:58 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:11:58 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:11:58 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:58 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:58 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:11:58 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:11:58 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:58 localhost kernel: [<7854d094>] ? jbd2_journal_cancel_revoke+0x119/0x155
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7844b46a>] ? wake_up_bit+0x57/0x5b
Nov 15 13:11:58 localhost kernel: [<784b52b7>] ? slab_pad_check+0x1e/0xf6
Nov 15 13:11:58 localhost kernel: [<784b4e3f>] ? check_valid_pointer+0x1c/0x48
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<78548840>] ? jbd2_journal_stop+0x2a3/0x30e
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7840c55a>] ? p6_pmu_enable_all+0x29/0x2f
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7840d742>] ? x86_pmu_enable+0x1a1/0x21f
Nov 15 13:11:58 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:58 localhost kernel: [<784894f8>] ? perf_event_task_tick+0x189/0x1b8
Nov 15 13:11:58 localhost kernel: [<7844dd00>] ? hrtimer_forward+0x5d/0x139
Nov 15 13:11:58 localhost kernel: [<784197d8>] ? lapic_next_event+0x16/0x1a
Nov 15 13:11:58 localhost kernel: [<784567da>] ? clockevents_program_event+0xcb/0xdd
Nov 15 13:11:58 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:11:58 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<78561d55>] ? security_task_wait+0xf/0x11
Nov 15 13:11:58 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:58 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:58 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:58 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:11:58 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: crond         S 78b8c9dc     0  1622      1 0x00000080
Nov 15 13:11:58 localhost kernel: f23c9f24 00000046 00000000 78b8c9dc 1493cfc7 0000000f 78a02380 ea826860
Nov 15 13:11:58 localhost kernel: 78a02380 ea826adc ea826ad8 ea826ad8 78a02380 78a02380 0007c313 00000000
Nov 15 13:11:58 localhost kernel: e6d03680 0000000f ea826860 00000001 f23c9f5c ea826860 ea826860 f23c9f3c
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:58 localhost kernel: [<7878d41f>] do_nanosleep+0x4f/0x83
Nov 15 13:11:58 localhost kernel: [<7844e9e0>] hrtimer_nanosleep+0x68/0xc0
Nov 15 13:11:58 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:11:58 localhost kernel: [<7844ea81>] sys_nanosleep+0x49/0x56
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: httpd         S 00000003     0  1632   1611 0x00000080
Nov 15 13:11:58 localhost kernel: f23c7b70 00000046 00000001 00000003 aca9648d 0000000e 78a02380 ea823430
Nov 15 13:11:58 localhost kernel: 78a02380 ea8236ac ea8236a8 ea8236a8 78a02380 78a02380 001cf94c 00000000
Nov 15 13:11:58 localhost kernel: f45e6000 0000000e ea823430 f23c7c7c 00000000 00000000 00000000 f23c7bb8
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:58 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:11:58 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:58 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:11:58 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:11:58 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:58 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:58 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:11:58 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:11:58 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:58 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:11:58 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:11:58 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:58 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:58 localhost kernel: [<7843b4ca>] ? current_fs_time+0x16/0x19
Nov 15 13:11:58 localhost kernel: [<784d0a19>] ? touch_atime+0x73/0xe6
Nov 15 13:11:58 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:11:58 localhost kernel: [<784c004d>] ? fsnotify_access+0x65/0x6d
Nov 15 13:11:58 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:11:58 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:11:58 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:58 localhost kernel: httpd         S 78ba562c     0  1633   1611 0x00000080
Nov 15 13:11:58 localhost kernel: ea90bee4 00000046 00000000 78ba562c 15a1100a 0000001a 78a02380 f21d0a70
Nov 15 13:11:58 localhost kernel: 78a02380 f21d0cec f21d0ce8 f21d0ce8 78a02380 78a02380 0b532fe2 00000000
Nov 15 13:11:58 localhost kernel: 00000000 0000001a f21d0a70 00000000 ea90bf8c 00000000 ea90bef4 ea90bf2c
Nov 15 13:11:58 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:11:59 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:11:59 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:59 localhost kernel: [<784ea31f>] sys_epoll_wait+0x1dd/0x27f
Nov 15 13:11:59 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:11:59 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1634   1611 0x00000080
Nov 15 13:11:59 localhost kernel: ea92bd7c 00000046 00000000 78555cfd 1c4817e9 00000005 78a02380 f21d14e0
Nov 15 13:11:59 localhost kernel: 78a02380 f21d175c f21d1758 f21d1758 78a02380 78a02380 0041cb94 00000000
Nov 15 13:11:59 localhost kernel: f45e7900 00000005 f21d14e0 ea92bd74 f23bf180 00000001 f23bf0f8 ea92bf70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1635   1611 0x00000080
Nov 15 13:11:59 localhost kernel: ea94fd7c 00000046 00000000 78555cfd 1cb47eb6 00000005 78a02380 f21d3430
Nov 15 13:11:59 localhost kernel: 78a02380 f21d36ac f21d36a8 f21d36a8 78a02380 78a02380 0043644f 00000000
Nov 15 13:11:59 localhost kernel: f45e7900 00000005 f21d3430 ea94fd74 ea92bf24 00000001 f23bf0f8 ea94ff70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1636   1611 0x00000080
Nov 15 13:11:59 localhost kernel: ea991d7c 00000046 00000000 78555cfd 1d1fc80d 00000005 78a02380 f21d1f50
Nov 15 13:11:59 localhost kernel: 78a02380 f21d21cc f21d21c8 f21d21c8 78a02380 78a02380 0043e5ec 00000000
Nov 15 13:11:59 localhost kernel: f45e7900 00000005 f21d1f50 ea991d74 ea94ff24 00000001 f23bf0f8 ea991f70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1637   1611 0x00000080
Nov 15 13:11:59 localhost kernel: ea9b5d7c 00000046 00000000 78555cfd 1d5b772a 00000005 78a02380 ea9b8000
Nov 15 13:11:59 localhost kernel: 78a02380 ea9b827c ea9b8278 ea9b8278 78a02380 78a02380 0051bccc 00000000
Nov 15 13:11:59 localhost kernel: f20c8c80 00000005 ea9b8000 ea9b5d74 ea991f24 00000001 f23bf0f8 ea9b5f70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1638   1611 0x00000080
Nov 15 13:11:59 localhost kernel: ea9dfd7c 00000046 00000000 78555cfd 1db85ba4 00000005 78a02380 ea9b8a70
Nov 15 13:11:59 localhost kernel: 78a02380 ea9b8cec ea9b8ce8 ea9b8ce8 78a02380 78a02380 00348b5c 00000000
Nov 15 13:11:59 localhost kernel: f20c8c80 00000005 ea9b8a70 ea9dfd74 ea9b5f24 00000001 f23bf0f8 ea9dff70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1639   1611 0x00000080
Nov 15 13:11:59 localhost kernel: eaa01d7c 00000046 00000000 78555cfd 1df452b2 00000005 78a02380 ea9b94e0
Nov 15 13:11:59 localhost kernel: 78a02380 ea9b975c ea9b9758 ea9b9758 78a02380 78a02380 00520796 00000000
Nov 15 13:11:59 localhost kernel: f45e7900 00000005 ea9b94e0 eaa01d74 ea9dff24 00000001 f23bf0f8 eaa01f70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: httpd         S 78555cfd     0  1640   1611 0x00000080
Nov 15 13:11:59 localhost kernel: eaa41d7c 00000046 00000000 78555cfd 1e5f5b6d 00000005 78a02380 ea9b9f50
Nov 15 13:11:59 localhost kernel: 78a02380 ea9ba1cc ea9ba1c8 ea9ba1c8 78a02380 78a02380 00153231 00000000
Nov 15 13:11:59 localhost kernel: f20c8c80 00000005 ea9b9f50 eaa41d74 eaa01f24 00000001 f23bf0f8 eaa41f70
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<78555cfd>] ? ipc_lock+0x30/0x5c
Nov 15 13:11:59 localhost kernel: [<78558b96>] sys_semtimedop+0x496/0x563
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:11:59 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:11:59 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:11:59 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:11:59 localhost kernel: [<78559e72>] sys_ipc+0x5a/0x1ac
Nov 15 13:11:59 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: munin-node    S ea9ba9c0     0  1641      1 0x00000080
Nov 15 13:11:59 localhost kernel: eaa67ad4 00000046 00000000 ea9ba9c0 a0b21822 0000001b 78a02380 ea9ba9c0
Nov 15 13:11:59 localhost kernel: 78a02380 ea9bac3c ea9bac38 ea9bac38 78a02380 78a02380 005da24f 00000000
Nov 15 13:11:59 localhost kernel: e38c3180 0000001b ea9ba9c0 00000000 eaa67e24 00000000 eaa67ae4 eaa67b1c
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:11:59 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:11:59 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:59 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:59 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:11:59 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:11:59 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:11:59 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:59 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:59 localhost kernel: [<7878dc00>] ? _raw_spin_lock_nested+0x34/0x3e
Nov 15 13:11:59 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:59 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:11:59 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:11:59 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:59 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:11:59 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:11:59 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:11:59 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:59 localhost kernel: [<784894f8>] ? perf_event_task_tick+0x189/0x1b8
Nov 15 13:11:59 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:11:59 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:11:59 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:11:59 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:11:59 localhost kernel: sshd          S ea824910     0  1791   1577 0x00000080
Nov 15 13:11:59 localhost kernel: eaa95ad4 00000046 00000007 ea824910 f5dffa2f 0000001a 78a02380 ea824910
Nov 15 13:11:59 localhost kernel: 78a02380 ea824b8c ea824b88 ea824b88 78a02380 78a02380 004ff2f1 00000000
Nov 15 13:11:59 localhost kernel: e38c2f00 0000001a ea824910 f220d35c 00000000 00000000 00000004 eaa95b1c
Nov 15 13:11:59 localhost kernel: Call Trace:
Nov 15 13:11:59 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:11:59 localhost kernel: [<78611a5d>] ? put_ldisc+0x8b/0x97
Nov 15 13:11:59 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:11:59 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:11:59 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:11:59 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:11:59 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:00 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<787073da>] ? sch_direct_xmit+0x7c/0x123
Nov 15 13:12:00 localhost kernel: [<786f569b>] ? dev_queue_xmit+0x35e/0x369
Nov 15 13:12:00 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:00 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<78735666>] ? tcp_write_xmit+0x779/0x849
Nov 15 13:12:00 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:00 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:00 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:00 localhost kernel: [<7843c1ef>] ? _local_bh_enable_ip+0x9d/0xa6
Nov 15 13:12:00 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:12:00 localhost kernel: [<7878e211>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:00 localhost kernel: [<784cca98>] ? copy_from_user+0x8/0xa
Nov 15 13:12:00 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:00 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:00 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:00 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:12:00 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:12:00 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:12:00 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:00 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:00 localhost kernel: Xvnc          S 00000001     0  1797      1 0x00000080
Nov 15 13:12:00 localhost kernel: eaabbad4 00200046 00000000 00000001 114299e1 0000001c 78a02380 ea9be860
Nov 15 13:12:00 localhost kernel: 78a02380 ea9beadc ea9bead8 ea9bead8 78a02380 78a02380 0000c571 00000000
Nov 15 13:12:00 localhost kernel: e38c2f00 0000001c ea9be860 00000000 eaabbe24 00000000 eaabbae4 eaabbb1c
Nov 15 13:12:00 localhost kernel: Call Trace:
Nov 15 13:12:00 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:00 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:00 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:00 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:00 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:00 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:00 localhost kernel: [<78428610>] ? update_curr+0x16a/0x172
Nov 15 13:12:00 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:00 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:00 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:00 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:00 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:00 localhost kernel: [<7878007b>] ? serial8250_probe+0x2/0x143
Nov 15 13:12:00 localhost kernel: bash          S eaae94e0     0  1819   1791 0x00000080
Nov 15 13:12:00 localhost kernel: eaab9f1c 00000046 78931990 eaae94e0 63562b57 00000008 78a02380 eaae94e0
Nov 15 13:12:00 localhost kernel: 78a02380 eaae975c eaae9758 eaae9758 78a02380 78a02380 0004d646 00000000
Nov 15 13:12:00 localhost kernel: 00000000 00000008 eaae94e0 78931980 eaab9f58 eaab9f58 eaae94e0 eaab9f4c
Nov 15 13:12:00 localhost kernel: Call Trace:
Nov 15 13:12:00 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:00 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:00 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:00 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:00 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:00 localhost kernel: ck-xinit-sess S eaae9f50     0  1853      1 0x00000080
Nov 15 13:12:00 localhost kernel: eab09f1c 00000046 78931990 eaae9f50 3bd78aa7 00000006 78a02380 eaae9f50
Nov 15 13:12:00 localhost kernel: 78a02380 eaaea1cc eaaea1c8 eaaea1c8 78a02380 78a02380 00045016 00000000
Nov 15 13:12:00 localhost kernel: f3c59400 00000006 eaae9f50 78931980 eab09f58 eab09f58 eaae9f50 eab09f4c
Nov 15 13:12:00 localhost kernel: Call Trace:
Nov 15 13:12:00 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:00 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:00 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:00 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:00 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:00 localhost kernel: vncconfig     S eaaea9c0     0  1856   1853 0x00000080
Nov 15 13:12:00 localhost kernel: ea863ad4 00000046 00000000 eaaea9c0 731061a5 0000000d 78a02380 eaaea9c0
Nov 15 13:12:00 localhost kernel: 78a02380 eaaeac3c eaaeac38 eaaeac38 78a02380 78a02380 00012791 00000000
Nov 15 13:12:00 localhost kernel: f4488c80 0000000d eaaea9c0 ea863ad4 00000000 00000000 00000004 ea863b1c
Nov 15 13:12:00 localhost kernel: Call Trace:
Nov 15 13:12:00 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:00 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:00 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:00 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:00 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:00 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:00 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:00 localhost kernel: [<78428610>] ? update_curr+0x16a/0x172
Nov 15 13:12:00 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:12:00 localhost kernel: [<78427185>] ? check_preempt_curr+0x18/0x2e
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:00 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:00 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:00 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:00 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:00 localhost kernel: [<784cca98>] ? copy_from_user+0x8/0xa
Nov 15 13:12:00 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:00 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:00 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:00 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:00 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:00 localhost kernel: dbus-launch   S eaaef2d0     0  1869      1 0x00000080
Nov 15 13:12:00 localhost kernel: eab1bad4 00000046 00000000 eaaef2d0 1561aa28 00000006 78a02380 eaaef2d0
Nov 15 13:12:00 localhost kernel: 78a02380 eaaef54c eaaef548 eaaef548 78a02380 78a02380 00007f80 00000000
Nov 15 13:12:00 localhost kernel: eaa43400 00000006 eaaef2d0 eab1bad4 00000000 00000000 00000004 eab1bb1c
Nov 15 13:12:00 localhost kernel: Call Trace:
Nov 15 13:12:00 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:00 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:00 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:00 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:00 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:00 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:00 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:00 localhost kernel: [<78428610>] ? update_curr+0x16a/0x172
Nov 15 13:12:00 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:00 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:00 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:12:00 localhost kernel: [<78427185>] ? check_preempt_curr+0x18/0x2e
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:00 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:00 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:00 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:00 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:00 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:00 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:00 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:00 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:00 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:00 localhost kernel: [<784cca98>] ? copy_from_user+0x8/0xa
Nov 15 13:12:00 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:00 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:00 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:00 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:00 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: dbus-daemon   S eab1fb80     0  1870      1 0x00000080
Nov 15 13:12:01 localhost kernel: eab1fb70 00000046 00000000 eab1fb80 157782c3 00000008 78a02380 ea9bbea0
Nov 15 13:12:01 localhost kernel: 78a02380 ea9bc11c ea9bc118 ea9bc118 78a02380 78a02380 0008afe9 00000000
Nov 15 13:12:01 localhost kernel: eaa43400 00000008 ea9bbea0 00000000 eab1ff74 00000000 eab1fb80 eab1fbb8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:01 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:01 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:01 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:01 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:01 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: atd           S 78b8c9dc     0  1881      1 0x00000080
Nov 15 13:12:01 localhost kernel: eaafbf24 00000046 00000000 78b8c9dc 206e30ff 00000006 78a02380 ea8229c0
Nov 15 13:12:01 localhost kernel: 78a02380 ea822c3c ea822c38 ea822c38 78a02380 78a02380 0004680f 00000000
Nov 15 13:12:01 localhost kernel: eab1d180 00000006 ea8229c0 00000001 eaafbf5c ea8229c0 ea8229c0 eaafbf3c
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878d41f>] do_nanosleep+0x4f/0x83
Nov 15 13:12:01 localhost kernel: [<7844e9e0>] hrtimer_nanosleep+0x68/0xc0
Nov 15 13:12:01 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:01 localhost kernel: [<7844ea81>] sys_nanosleep+0x49/0x56
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: smartd        S 78b8c9dc     0  1919      1 0x00000080
Nov 15 13:12:01 localhost kernel: eaa93f24 00000046 00000000 78b8c9dc 23d0579c 00000006 78a02380 eaaec910
Nov 15 13:12:01 localhost kernel: 78a02380 eaaecb8c eaaecb88 eaaecb88 78a02380 78a02380 00013bda 00000000
Nov 15 13:12:01 localhost kernel: eab1ca00 00000006 eaaec910 00000001 eaa93f5c eaaec910 eaaec910 eaa93f3c
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878d41f>] do_nanosleep+0x4f/0x83
Nov 15 13:12:01 localhost kernel: [<7844e9e0>] hrtimer_nanosleep+0x68/0xc0
Nov 15 13:12:01 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:01 localhost kernel: [<7844ea81>] sys_nanosleep+0x49/0x56
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1939      1 0x00000080
Nov 15 13:12:01 localhost kernel: eaadde84 00000046 eaa85b50 00000000 288466ea 00000006 78a02380 ea9bf2d0
Nov 15 13:12:01 localhost kernel: 78a02380 ea9bf54c ea9bf548 ea9bf548 78a02380 78a02380 004e8390 00000000
Nov 15 13:12:01 localhost kernel: f3c58280 00000006 ea9bf2d0 eaa85b70 eaa85a10 7fffffff 7fffffff eaaddec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1940      1 0x00000080
Nov 15 13:12:01 localhost kernel: eab4de84 00000046 f438e380 00000000 286e7073 00000006 78a02380 ea9bc910
Nov 15 13:12:01 localhost kernel: 78a02380 ea9bcb8c ea9bcb88 ea9bcb88 78a02380 78a02380 002020ce 00000000
Nov 15 13:12:01 localhost kernel: eab1c280 00000006 ea9bc910 f438e3a0 f438e240 7fffffff 7fffffff eab4dec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1941      1 0x00000080
Nov 15 13:12:01 localhost kernel: eab41e84 00000046 f438db50 00000000 283fbc56 00000006 78a02380 ea823ea0
Nov 15 13:12:01 localhost kernel: 78a02380 ea82411c ea824118 ea824118 78a02380 78a02380 001f00d9 00000000
Nov 15 13:12:01 localhost kernel: eab1c280 00000006 ea823ea0 f438db70 f438da10 7fffffff 7fffffff eab41ec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1942      1 0x00000080
Nov 15 13:12:01 localhost kernel: eab45e84 00000046 eab25320 00000000 287b21e2 00000006 78a02380 ea8272d0
Nov 15 13:12:01 localhost kernel: 78a02380 ea82754c ea827548 ea827548 78a02380 78a02380 00081b28 00000000
Nov 15 13:12:01 localhost kernel: f20c9180 00000006 ea8272d0 eab25340 eab251e0 7fffffff 7fffffff eab45ec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1943      1 0x00000080
Nov 15 13:12:01 localhost kernel: eab3be84 00000046 f21f8140 00000000 2872ec2b 00000006 78a02380 f3de0a70
Nov 15 13:12:01 localhost kernel: 78a02380 f3de0cec f3de0ce8 f3de0ce8 78a02380 78a02380 0023b9ab 00000000
Nov 15 13:12:01 localhost kernel: eab1d680 00000006 f3de0a70 f21f8160 f21f8000 7fffffff 7fffffff eab3bec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: mingetty      S 00000000     0  1944      1 0x00000080
Nov 15 13:12:01 localhost kernel: f215be84 00000046 f220f3e0 00000000 281f8ab3 00000006 78a02380 eaae8a70
Nov 15 13:12:01 localhost kernel: 78a02380 eaae8cec eaae8ce8 eaae8ce8 78a02380 78a02380 0021c61a 00000000
Nov 15 13:12:01 localhost kernel: eab1db80 00000006 eaae8a70 f220f400 f220f2a0 7fffffff 7fffffff f215bec8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:01 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:01 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:01 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:01 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:01 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:01 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:01 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:01 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:01 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:01 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:01 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:01 localhost kernel: gnome-session S 00000003     0  1981   1853 0x00000080
Nov 15 13:12:01 localhost kernel: eaac5b70 00000046 00000001 00000003 8fcbfb82 00000013 78a02380 f47394e0
Nov 15 13:12:01 localhost kernel: 78a02380 f473975c f4739758 f4739758 78a02380 78a02380 00032c6c 00000000
Nov 15 13:12:01 localhost kernel: f4489400 00000013 f47394e0 eaac5b70 00000000 00000000 00000000 eaac5bb8
Nov 15 13:12:01 localhost kernel: Call Trace:
Nov 15 13:12:01 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:01 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:01 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:01 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:01 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:01 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:01 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:01 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:02 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:02 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:02 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:02 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:02 localhost kernel: gnome-session S f4738a70     0  2001   1853 0x00000080
Nov 15 13:12:02 localhost kernel: f44fde58 00000046 00000007 f4738a70 b18abb07 00000007 78a02380 f4738a70
Nov 15 13:12:02 localhost kernel: 78a02380 f4738cec f4738ce8 f4738ce8 78a02380 78a02380 0000a338 00000000
Nov 15 13:12:02 localhost kernel: eab1c500 00000007 f4738a70 f44fde50 f44fde60 f4b18510 f44fde74 f44fde80
Nov 15 13:12:02 localhost kernel: Call Trace:
Nov 15 13:12:02 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:02 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:02 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:02 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:02 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:02 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:02 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:02 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:02 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:12:02 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:02 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:02 localhost kernel: ssh-agent     S f473a9c0     0  1983   1981 0x00000080
Nov 15 13:12:02 localhost kernel: f3c7dad4 00000046 00000000 f473a9c0 36d4f2b8 0000001b 78a02380 f473a9c0
Nov 15 13:12:02 localhost kernel: 78a02380 f473ac3c f473ac38 f473ac38 78a02380 78a02380 0a8d19a7 00000000
Nov 15 13:12:02 localhost kernel: 00000000 0000001b f473a9c0 00000000 f3c7de24 00000000 f3c7dae4 f3c7db1c
Nov 15 13:12:02 localhost kernel: Call Trace:
Nov 15 13:12:02 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:02 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:02 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:02 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:02 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:02 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:02 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:02 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:02 localhost kernel: [<78422800>] ? kernel_map_pages+0x0/0xfe
Nov 15 13:12:02 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:02 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:02 localhost kernel: [<784223b5>] ? __change_page_attr_set_clr+0x261/0x6ac
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:02 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:02 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:02 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:02 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:02 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:02 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:02 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:02 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:02 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:02 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:02 localhost kernel: [<78441bc1>] ? check_kill_permission+0x162/0x181
Nov 15 13:12:02 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:02 localhost kernel: [<78441bf7>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:02 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:02 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:02 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:02 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:02 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:02 localhost kernel: login         S f473bea0     0  1998      1 0x00000080
Nov 15 13:12:02 localhost kernel: f4b33f34 00000046 78931990 f473bea0 bbca1f19 00000007 78a02380 f473bea0
Nov 15 13:12:02 localhost kernel: 78a02380 f473c11c f473c118 f473c118 78a02380 78a02380 000f98a6 00000000
Nov 15 13:12:02 localhost kernel: f45e7400 00000007 f473bea0 78931980 f4b33f70 f4b33f70 f473bea0 f4b33f64
Nov 15 13:12:02 localhost kernel: Call Trace:
Nov 15 13:12:02 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:02 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:02 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:02 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:02 localhost kernel: gconfd-2      S f4b59b80     0  1999      1 0x00000080
Nov 15 13:12:02 localhost kernel: f4b59b70 00000046 00000000 f4b59b80 b70c2a3b 0000001b 78a02380 f473d380
Nov 15 13:12:02 localhost kernel: 78a02380 f473d5fc f473d5f8 f473d5f8 78a02380 78a02380 00002db2 00000000
Nov 15 13:12:02 localhost kernel: eabd8500 0000001b f473d380 00000000 f4b59f74 00000000 f4b59b80 f4b59bb8
Nov 15 13:12:02 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:03 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:03 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:03 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:03 localhost kernel: metacity      S 00000003     0  2000   1981 0x00000080
Nov 15 13:12:03 localhost kernel: f3cadb70 00000046 00000001 00000003 de526b6a 00000012 78a02380 f473b430
Nov 15 13:12:03 localhost kernel: 78a02380 f473b6ac f473b6a8 f473b6a8 78a02380 78a02380 0002128b 00000000
Nov 15 13:12:03 localhost kernel: eab1d180 00000012 f473b430 f3cadb70 00000000 00000000 00000000 f3cadbb8
Nov 15 13:12:03 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:03 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:03 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:03 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:03 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:03 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:03 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:03 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:03 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:03 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:03 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:03 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:03 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:03 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:03 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:03 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:03 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:03 localhost kernel: gnome-panel   S 00000001     0  2002   1981 0x00000080
Nov 15 13:12:03 localhost kernel: f4b13b70 00000046 00000000 00000001 3fd8f4da 0000001b 78a02380 f4739f50
Nov 15 13:12:03 localhost kernel: 78a02380 f473a1cc f473a1c8 f473a1c8 78a02380 78a02380 0004564c 00000000
Nov 15 13:12:03 localhost kernel: f45e6500 0000001b f4739f50 00000000 f4b13f74 00000000 f4b13b80 f4b13bb8
Nov 15 13:12:03 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:03 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:03 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:03 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:03 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:03 localhost kernel: gvfsd         S 00000003     0  2004      1 0x00000080
Nov 15 13:12:03 localhost kernel: f475db70 00000046 00000001 00000003 148f5f5c 00000008 78a02380 f473c910
Nov 15 13:12:03 localhost kernel: 78a02380 f473cb8c f473cb88 f473cb88 78a02380 78a02380 0007a2f7 00000000
Nov 15 13:12:03 localhost kernel: f4488c80 00000008 f473c910 f475db70 00000000 00000000 00000000 f475dbb8
Nov 15 13:12:03 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:03 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<78429353>] ? task_rq_lock+0x41/0x6b
Nov 15 13:12:03 localhost kernel: [<7878dc44>] ? _raw_spin_lock+0x3a/0x40
Nov 15 13:12:03 localhost kernel: [<7845991e>] ? trace_hardirqs_off+0xb/0xd
Nov 15 13:12:03 localhost kernel: [<7878e274>] ? _raw_spin_unlock_irqrestore+0x35/0x48
Nov 15 13:12:03 localhost kernel: [<784320d1>] ? try_to_wake_up+0x1ff/0x209
Nov 15 13:12:03 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:03 localhost kernel: [<784320e6>] ? default_wake_function+0xb/0xd
Nov 15 13:12:03 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:03 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:03 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:03 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:03 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:03 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:03 localhost kernel: [<787651b4>] ? unix_stream_sendmsg+0x1d7/0x23c
Nov 15 13:12:03 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:03 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:03 localhost kernel: [<786e5fe4>] ? __sock_sendmsg+0x54/0x5b
Nov 15 13:12:03 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:12:03 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:12:03 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:12:03 localhost kernel: [<784c0e16>] ? do_readv_writev+0xe8/0xf5
Nov 15 13:12:03 localhost kernel: [<786e7ebd>] ? sock_aio_write+0x0/0xdf
Nov 15 13:12:03 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:03 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:03 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:03 localhost kernel: nautilus      S f4005b03     0  2009   1981 0x00000080
Nov 15 13:12:03 localhost kernel: f4005b70 00000046 00000001 f4005b03 e49c36af 00000019 78a02380 f473f2d0
Nov 15 13:12:03 localhost kernel: 78a02380 f473f54c f473f548 f473f548 78a02380 78a02380 0001eaa9 00000000
Nov 15 13:12:03 localhost kernel: e38c3180 00000019 f473f2d0 f44d3c78 00000000 00000000 00000000 f4005bb8
Nov 15 13:12:03 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:03 localhost kernel: [<7878ce0b>] ? __mutex_unlock_slowpath+0xf2/0xff
Nov 15 13:12:03 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:03 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:03 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:03 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:03 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:03 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:03 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:03 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:03 localhost kernel: [<78780000>] ? cn_init+0x1f/0x98
Nov 15 13:12:03 localhost kernel: bonobo-activa S 00000003     0  2011      1 0x00000080
Nov 15 13:12:03 localhost kernel: f44cbb70 00200046 00000001 00000003 92883a41 00000006 78a02380 eaaeddf0
Nov 15 13:12:03 localhost kernel: 78a02380 eaaee06c eaaee068 eaaee068 78a02380 78a02380 001f116f 00000000
Nov 15 13:12:03 localhost kernel: eab1cf00 00000006 eaaeddf0 f44cbb70 00000000 00000000 00000000 f44cbbb8
Nov 15 13:12:03 localhost kernel: Call Trace:
Nov 15 13:12:03 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:03 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:03 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:03 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:03 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:03 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:03 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:03 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:04 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:04 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:04 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:04 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:12:04 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:12:04 localhost kernel: [<784c9467>] ? putname+0x25/0x2e
Nov 15 13:12:04 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:12:04 localhost kernel: [<7860978a>] ? write_null+0x0/0x7
Nov 15 13:12:04 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: bonobo-activa S 7845a503     0  2019      1 0x00000080
Nov 15 13:12:04 localhost kernel: f4ba5b70 00200046 00000001 7845a503 b1ac1fd5 00000007 78a02380 eaaee860
Nov 15 13:12:04 localhost kernel: 78a02380 eaaeeadc eaaeead8 eaaeead8 78a02380 78a02380 000aaf5d 00000000
Nov 15 13:12:04 localhost kernel: f4488c80 00000007 eaaee860 f4ba5b70 00000000 00000000 00000000 f4ba5bb8
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7845a503>] ? trace_hardirqs_on_caller+0xc2/0x125
Nov 15 13:12:04 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:04 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:04 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:04 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:04 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:12:04 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:04 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:04 localhost kernel: [<784c7de9>] ? path_put+0x15/0x18
Nov 15 13:12:04 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gvfs-fuse-dae S 00000000     0  2020      1 0x00000080
Nov 15 13:12:04 localhost kernel: f4003e28 00000046 00000000 00000000 7b504157 00000006 78a02380 eaae8000
Nov 15 13:12:04 localhost kernel: 78a02380 eaae827c eaae8278 eaae8278 78a02380 78a02380 00052a32 00000000
Nov 15 13:12:04 localhost kernel: f20c9900 00000006 eaae8000 f4003e28 00000000 f4003e6c 00000000 f4003e44
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7845cbd2>] futex_wait_queue_me+0x74/0x87
Nov 15 13:12:04 localhost kernel: [<7845d95e>] futex_wait+0xff/0x1fe
Nov 15 13:12:04 localhost kernel: [<7845e7aa>] do_futex+0x80/0x77d
Nov 15 13:12:04 localhost kernel: [<787912c8>] ? do_page_fault+0x357/0x382
Nov 15 13:12:04 localhost kernel: [<7845efab>] sys_futex+0x104/0x115
Nov 15 13:12:04 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:04 localhost kernel: [<784786e6>] ? audit_syscall_entry+0x113/0x135
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gvfs-fuse-dae S 7845a2e9     0  2021      1 0x00000080
Nov 15 13:12:04 localhost kernel: f4001dec 00000046 f4001db0 7845a2e9 e34251c0 0000001b 78a02380 eaaebea0
Nov 15 13:12:04 localhost kernel: 78a02380 eaaec11c eaaec118 eaaec118 78a02380 78a02380 000025f2 00000000
Nov 15 13:12:04 localhost kernel: eabd8f00 0000001b eaaebea0 f3e9e9e0 f3e9e9e0 eaaebea0 eaaebea0 f4001e7c
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:04 localhost kernel: [<f8397293>] fuse_dev_do_read+0xb3/0x397 [fuse]
Nov 15 13:12:04 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:04 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:04 localhost kernel: [<f83975d7>] fuse_dev_read+0x60/0x68 [fuse]
Nov 15 13:12:04 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:04 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:04 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:04 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:04 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:12:04 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gvfs-fuse-dae S 7845a2e9     0  2022      1 0x00000080
Nov 15 13:12:04 localhost kernel: f45d9dec 00000046 f45d9db0 7845a2e9 e34362e0 0000001b 78a02380 eaaeb430
Nov 15 13:12:04 localhost kernel: 78a02380 eaaeb6ac eaaeb6a8 eaaeb6a8 78a02380 78a02380 0000147e 00000000
Nov 15 13:12:04 localhost kernel: eabd8f00 0000001b eaaeb430 f3e9e9e0 f3e9e9e0 eaaeb430 eaaeb430 f45d9e7c
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:04 localhost kernel: [<f8397293>] fuse_dev_do_read+0xb3/0x397 [fuse]
Nov 15 13:12:04 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:04 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:04 localhost kernel: [<f83975d7>] fuse_dev_read+0x60/0x68 [fuse]
Nov 15 13:12:04 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:04 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:04 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:04 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:04 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:12:04 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gvfs-fuse-dae S 00000003     0  2025      1 0x00000080
Nov 15 13:12:04 localhost kernel: f45d1b70 00000046 00000001 00000003 baf53f17 00000007 78a02380 ea9bb430
Nov 15 13:12:04 localhost kernel: 78a02380 ea9bb6ac ea9bb6a8 ea9bb6a8 78a02380 78a02380 0004c380 00000000
Nov 15 13:12:04 localhost kernel: eaa43b80 00000007 ea9bb430 f45d1b70 00000000 00000000 00000000 f45d1bb8
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:04 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:04 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:04 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:04 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:04 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:04 localhost kernel: [<7859393f>] ? rb_insert_color+0xa1/0xc5
Nov 15 13:12:04 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:04 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:04 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:04 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:04 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:04 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:04 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:04 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:04 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:04 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:04 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:04 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:04 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:04 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gnome-termina S eaaed380     0  2023   1981 0x00000080
Nov 15 13:12:04 localhost kernel: eab73b70 00000046 00000000 eaaed380 11323352 0000001c 78a02380 eaaed380
Nov 15 13:12:04 localhost kernel: 78a02380 eaaed5fc eaaed5f8 eaaed5f8 78a02380 78a02380 00646794 00000000
Nov 15 13:12:04 localhost kernel: e38c2f00 0000001c eaaed380 00000000 eab73f74 00000000 eab73b80 eab73bb8
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:04 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:04 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:04 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:04 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:04 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:04 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:04 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:04 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:04 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:04 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:04 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:04 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:04 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:04 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:04 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:04 localhost kernel: gnome-termina S f449bea0     0  2044   1981 0x00000080
Nov 15 13:12:04 localhost kernel: f447be58 00000046 00000007 f449bea0 9df7360e 00000006 78a02380 f449bea0
Nov 15 13:12:04 localhost kernel: 78a02380 f449c11c f449c118 f449c118 78a02380 78a02380 0041dc5a 00000000
Nov 15 13:12:04 localhost kernel: f4489900 00000006 f449bea0 f447be50 f447be60 f4a5d360 f447be74 f447be80
Nov 15 13:12:04 localhost kernel: Call Trace:
Nov 15 13:12:04 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:05 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:05 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<78428f5e>] ? set_next_entity+0x9f/0x10b
Nov 15 13:12:05 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:05 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:05 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:05 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:05 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:05 localhost kernel: [<784c136d>] ? fget_light+0x31/0xb0
Nov 15 13:12:05 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: gvfsd-trash   S f44d7b03     0  2028      1 0x00000080
Nov 15 13:12:05 localhost kernel: f44d7b70 00000046 00000001 f44d7b03 b0ea56bf 00000007 78a02380 f43bc910
Nov 15 13:12:05 localhost kernel: 78a02380 f43bcb8c f43bcb88 f43bcb88 78a02380 78a02380 000d9b81 00000000
Nov 15 13:12:05 localhost kernel: eaa43400 00000007 f43bc910 f44d7b70 00000000 00000000 00000000 f44d7bb8
Nov 15 13:12:05 localhost kernel: Call Trace:
Nov 15 13:12:05 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:05 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:05 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:05 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:05 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:05 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:05 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<7845a500>] ? trace_hardirqs_on_caller+0xbf/0x125
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:05 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:05 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:05 localhost kernel: [<787651b4>] ? unix_stream_sendmsg+0x1d7/0x23c
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:05 localhost kernel: [<786e5fe4>] ? __sock_sendmsg+0x54/0x5b
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:05 localhost kernel: [<784c0e16>] ? do_readv_writev+0xe8/0xf5
Nov 15 13:12:05 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:05 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:05 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:05 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: gvfs-gdu-volu S 00000003     0  2030      1 0x00000080
Nov 15 13:12:05 localhost kernel: f4483b70 00000046 00000001 00000003 aca2d33f 0000000e 78a02380 f473ddf0
Nov 15 13:12:05 localhost kernel: 78a02380 f473e06c f473e068 f473e068 78a02380 78a02380 001717dc 00000000
Nov 15 13:12:05 localhost kernel: eaa43180 0000000e f473ddf0 f4483b70 00000000 00000000 00000000 f4483bb8
Nov 15 13:12:05 localhost kernel: Call Trace:
Nov 15 13:12:05 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:05 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:05 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:05 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:05 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:05 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:05 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:05 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:05 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:05 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:05 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:05 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:05 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:05 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:05 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:05 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:05 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:05 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:05 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: wnck-applet   S 00000003     0  2035      1 0x00000080
Nov 15 13:12:05 localhost kernel: f4401b70 00000046 00000001 00000003 de457a65 00000012 78a02380 f44994e0
Nov 15 13:12:05 localhost kernel: 78a02380 f449975c f4499758 f4499758 78a02380 78a02380 000254d9 00000000
Nov 15 13:12:05 localhost kernel: eaa43400 00000012 f44994e0 f4401b70 00000000 00000000 00000000 f4401bb8
Nov 15 13:12:05 localhost kernel: Call Trace:
Nov 15 13:12:05 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:05 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:05 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:05 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:05 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:05 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:05 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:05 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:05 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:05 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:05 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:05 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:05 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:05 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:05 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: devkit-disks- S 00000001     0  2037      1 0x00000080
Nov 15 13:12:05 localhost kernel: f4423b70 00000046 00000000 00000001 a5b08204 00000016 78a02380 f4499f50
Nov 15 13:12:05 localhost kernel: 78a02380 f449a1cc f449a1c8 f449a1c8 78a02380 78a02380 0001bdd6 00000000
Nov 15 13:12:05 localhost kernel: f3c59400 00000016 f4499f50 00000000 f4423f74 00000000 f4423b80 f4423bb8
Nov 15 13:12:05 localhost kernel: Call Trace:
Nov 15 13:12:05 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:05 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:05 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:05 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:05 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:05 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:05 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:05 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:05 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:05 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:05 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:05 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:05 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:05 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:05 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:05 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:05 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:05 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:05 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:05 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: devkit-disks- S 74f68503     0  2038   2037 0x00000080
Nov 15 13:12:05 localhost kernel: f4427b70 00000046 00000001 74f68503 9f482037 00000006 78a02380 f449a9c0
Nov 15 13:12:05 localhost kernel: 78a02380 f449ac3c f449ac38 f449ac38 78a02380 78a02380 00017730 00000000
Nov 15 13:12:05 localhost kernel: f4489400 00000006 f449a9c0 f4427c3c 00000000 00000000 00000000 f4427bb8
Nov 15 13:12:05 localhost kernel: Call Trace:
Nov 15 13:12:05 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:05 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:05 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:05 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:05 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:05 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:05 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:05 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:05 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:05 localhost kernel: [<784223b5>] ? __change_page_attr_set_clr+0x261/0x6ac
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:05 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:05 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:05 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:12:05 localhost kernel: [<7848e017>] ? unlock_page+0x40/0x43
Nov 15 13:12:05 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:05 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:05 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:12:05 localhost kernel: [<787912c8>] ? do_page_fault+0x357/0x382
Nov 15 13:12:05 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:05 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:05 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:05 localhost kernel: devkit-daemon S f449b430     0  2040      1 0x00000080
Nov 15 13:12:05 localhost kernel: f4453b70 00000046 eaabfb00 f449b430 a5b0b83a 00000016 78a02380 f449b430
Nov 15 13:12:05 localhost kernel: 78a02380 f449b6ac f449b6a8 f449b6a8 78a02380 78a02380 005d041a 00000000
Nov 15 13:12:06 localhost kernel: e46fe500 00000016 f449b430 00000000 00000000 00000000 00000000 f4453bb8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:06 localhost kernel: [<7878e2a4>] ? _raw_spin_unlock+0x1d/0x20
Nov 15 13:12:06 localhost kernel: [<7876402d>] ? unix_peer_get+0x29/0x2f
Nov 15 13:12:06 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:06 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:06 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:06 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:12:06 localhost kernel: [<78427185>] ? check_preempt_curr+0x18/0x2e
Nov 15 13:12:06 localhost kernel: [<7845991e>] ? trace_hardirqs_off+0xb/0xd
Nov 15 13:12:06 localhost kernel: [<7878e274>] ? _raw_spin_unlock_irqrestore+0x35/0x48
Nov 15 13:12:06 localhost kernel: [<784320d1>] ? try_to_wake_up+0x1ff/0x209
Nov 15 13:12:06 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:06 localhost kernel: [<784320e6>] ? default_wake_function+0xb/0xd
Nov 15 13:12:06 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:06 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:06 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:06 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:06 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:06 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:06 localhost kernel: [<787651b4>] ? unix_stream_sendmsg+0x1d7/0x23c
Nov 15 13:12:06 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:06 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:06 localhost kernel: [<786e5fe4>] ? __sock_sendmsg+0x54/0x5b
Nov 15 13:12:06 localhost kernel: [<784e655c>] ? fsnotify+0x408/0x422
Nov 15 13:12:06 localhost kernel: [<784e61b0>] ? fsnotify+0x5c/0x422
Nov 15 13:12:06 localhost kernel: [<784c00ba>] ? fsnotify_modify+0x65/0x6d
Nov 15 13:12:06 localhost kernel: [<784c0e16>] ? do_readv_writev+0xe8/0xf5
Nov 15 13:12:06 localhost kernel: [<786e7ebd>] ? sock_aio_write+0x0/0xdf
Nov 15 13:12:06 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:06 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: gnome-pty-hel S 0000035d     0  2041   2023 0x00000080
Nov 15 13:12:06 localhost kernel: f445bd60 00000046 00000003 0000035d 37f68761 00000007 78a02380 f4498a70
Nov 15 13:12:06 localhost kernel: 78a02380 f4498cec f4498ce8 f4498ce8 78a02380 78a02380 00040de5 00000000
Nov 15 13:12:06 localhost kernel: 00000000 00000007 f4498a70 00000007 f44203c0 7fffffff f445be10 f445bda4
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:06 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:06 localhost kernel: [<78764d9e>] unix_stream_recvmsg+0x1f2/0x431
Nov 15 13:12:06 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:06 localhost kernel: [<786e59d7>] __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:06 localhost kernel: [<786e6028>] __sock_recvmsg+0x3d/0x44
Nov 15 13:12:06 localhost kernel: [<786e7eb5>] sock_aio_read+0xd7/0xdf
Nov 15 13:12:06 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:06 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:06 localhost kernel: [<784c09b9>] vfs_read+0x96/0xe4
Nov 15 13:12:06 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: bash          S 00000000     0  2043   2023 0x00000080
Nov 15 13:12:06 localhost kernel: f447de84 00000046 f442aa30 00000000 37efcb7a 00000007 78a02380 f449c910
Nov 15 13:12:06 localhost kernel: 78a02380 f449cb8c f449cb88 f449cb88 78a02380 78a02380 00031f4b 00000000
Nov 15 13:12:06 localhost kernel: f4488000 00000007 f449c910 f442aa50 f442a8f0 7fffffff 7fffffff f447dec8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:06 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:06 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:06 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:06 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:06 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:06 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:06 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:06 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:06 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:06 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: bash          S 00000000     0  2057   2023 0x00000080
Nov 15 13:12:06 localhost kernel: f4ac9e84 00000046 f442c2c0 00000000 f4ac9e60 78447a6d 78a02380 f4ab0000
Nov 15 13:12:06 localhost kernel: 78a02380 f4ab027c f4ab0278 f4ab0278 78a02380 78a02380 c3cfe29f 00000006
Nov 15 13:12:06 localhost kernel: 00000000 00000006 f4ab0000 f442c2e0 f442c180 7fffffff 7fffffff f4ac9ec8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<78447a6d>] ? start_flush_work+0x2d/0x118
Nov 15 13:12:06 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:06 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:06 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:06 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:06 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:06 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:06 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:06 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:06 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:06 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:06 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: gvfs-gphoto2- S 00000003     0  2088      1 0x00000080
Nov 15 13:12:06 localhost kernel: f4487b70 00000046 00000001 00000003 f0f8d109 00000016 78a02380 f4ab0a70
Nov 15 13:12:06 localhost kernel: 78a02380 f4ab0cec f4ab0ce8 f4ab0ce8 78a02380 78a02380 0002ab7a 00000000
Nov 15 13:12:06 localhost kernel: eabd8000 00000016 f4ab0a70 f4487b70 00000000 00000000 00000000 f4487bb8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:06 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:06 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:06 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:06 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:06 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:06 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:06 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:06 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:06 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:06 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:06 localhost kernel: [<7876407b>] ? scm_destroy_cred+0xd/0x33
Nov 15 13:12:06 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:06 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:06 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:06 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:06 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:06 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:06 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:06 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:06 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:06 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: sensors-apple S 00000003     0  2099      1 0x00000080
Nov 15 13:12:06 localhost kernel: f4aefb70 00000046 00000000 00000003 b724da8e 0000001b 78a02380 f449e860
Nov 15 13:12:06 localhost kernel: 78a02380 f449eadc f449ead8 f449ead8 78a02380 78a02380 0094d8d0 00000000
Nov 15 13:12:06 localhost kernel: e38c2f00 0000001b f449e860 00000000 f4aeff74 00000000 f4aefb80 f4aefbb8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:06 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:06 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:06 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:06 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:06 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:06 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:06 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:06 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:06 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:06 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:06 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:06 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:06 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:06 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:06 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:06 localhost kernel: clock-applet  S eabd7b80     0  2103      1 0x00000080
Nov 15 13:12:06 localhost kernel: eabd7b70 00000046 00000000 eabd7b80 f06ec199 0000001b 78a02380 f449d380
Nov 15 13:12:06 localhost kernel: 78a02380 f449d5fc f449d5f8 f449d5f8 78a02380 78a02380 0078825b 00000000
Nov 15 13:12:06 localhost kernel: e38c2f00 0000001b f449d380 00000000 eabd7f74 00000000 eabd7b80 eabd7bb8
Nov 15 13:12:06 localhost kernel: Call Trace:
Nov 15 13:12:06 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:06 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:06 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:06 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:06 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:06 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:06 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:06 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:07 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:07 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:07 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:07 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:07 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:07 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:07 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:07 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:07 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:07 localhost kernel: notification- S ea9bd303     0  2104      1 0x00000080
Nov 15 13:12:07 localhost kernel: eabf9b70 00000046 00000001 ea9bd303 3dd20e99 00000008 78a02380 ea9bd380
Nov 15 13:12:07 localhost kernel: 78a02380 ea9bd5fc ea9bd5f8 ea9bd5f8 78a02380 78a02380 00002f27 00000000
Nov 15 13:12:07 localhost kernel: eaa43400 00000008 ea9bd380 eabf9b70 00000000 00000000 00000000 eabf9bb8
Nov 15 13:12:07 localhost kernel: Call Trace:
Nov 15 13:12:07 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:07 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:07 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:07 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:07 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:07 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:07 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:07 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:07 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:07 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:07 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:07 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:07 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:07 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:07 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:07 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:07 localhost kernel: multiload-app S eabfbb03     0  2105      1 0x00000080
Nov 15 13:12:07 localhost kernel: eabfbb70 00000046 00000000 eabfbb03 e34f46c9 0000001b 78a02380 f473e860
Nov 15 13:12:07 localhost kernel: 78a02380 f473eadc f473ead8 f473ead8 78a02380 78a02380 00b3089d 00000000
Nov 15 13:12:07 localhost kernel: e38c2f00 0000001b f473e860 00000000 eabfbf74 00000000 eabfbb80 eabfbbb8
Nov 15 13:12:07 localhost kernel: Call Trace:
Nov 15 13:12:07 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:07 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:07 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:07 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:07 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:07 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:07 localhost kernel: [<787640ac>] ? scm_destroy+0xb/0x1f
Nov 15 13:12:07 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:07 localhost kernel: [<78764fc6>] ? unix_stream_recvmsg+0x41a/0x431
Nov 15 13:12:07 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:07 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:07 localhost kernel: [<786e59d7>] ? __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:07 localhost kernel: [<786e6028>] ? __sock_recvmsg+0x3d/0x44
Nov 15 13:12:07 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:07 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:07 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:07 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:07 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:07 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:07 localhost kernel: gvfsd-burn    S 00000003     0  2111      1 0x00000080
Nov 15 13:12:07 localhost kernel: e6c2db70 00000046 00000001 00000003 bc9c8d1c 00000007 78a02380 f4498000
Nov 15 13:12:07 localhost kernel: 78a02380 f449827c f4498278 f4498278 78a02380 78a02380 00d36f18 00000000
Nov 15 13:12:07 localhost kernel: eabd8000 00000007 f4498000 e6c2db70 00000000 00000000 00000000 e6c2dbb8
Nov 15 13:12:07 localhost kernel: Call Trace:
Nov 15 13:12:07 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:07 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:07 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:07 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:07 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:07 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:07 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:07 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<78427185>] ? check_preempt_curr+0x18/0x2e
Nov 15 13:12:08 localhost kernel: [<7845991e>] ? trace_hardirqs_off+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<7878e274>] ? _raw_spin_unlock_irqrestore+0x35/0x48
Nov 15 13:12:08 localhost kernel: [<784320d1>] ? try_to_wake_up+0x1ff/0x209
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<784320e6>] ? default_wake_function+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:08 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:08 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<784a22ae>] ? __do_fault+0x1d5/0x359
Nov 15 13:12:08 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:08 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:08 localhost kernel: [<7844ee95>] ? up_read+0x16/0x29
Nov 15 13:12:08 localhost kernel: [<787912c8>] ? do_page_fault+0x357/0x382
Nov 15 13:12:08 localhost kernel: [<784302cb>] ? finish_task_switch+0x34/0xd4
Nov 15 13:12:08 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: bash          S f438b260     0  2113   1998 0x00000080
Nov 15 13:12:08 localhost kernel: f4aabe84 00000046 7878e236 f438b260 c2fe3bdb 0000000e 78a02380 f449f2d0
Nov 15 13:12:08 localhost kernel: 78a02380 f449f54c f449f548 f449f548 78a02380 78a02380 0015bf36 00000000
Nov 15 13:12:08 localhost kernel: e6d02780 0000000e f449f2d0 f438b280 f438b120 7fffffff 7fffffff f4aabec8
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 15 13:12:08 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:08 localhost kernel: [<78440b53>] ? del_timer_sync+0x87/0x97
Nov 15 13:12:08 localhost kernel: [<78440acc>] ? del_timer_sync+0x0/0x97
Nov 15 13:12:08 localhost kernel: [<78447d05>] ? flush_delayed_work+0x35/0x38
Nov 15 13:12:08 localhost kernel: [<7860f618>] n_tty_read+0x395/0x5ee
Nov 15 13:12:08 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:08 localhost kernel: [<7860b611>] tty_read+0x6e/0xa4
Nov 15 13:12:08 localhost kernel: [<7860f283>] ? n_tty_read+0x0/0x5ee
Nov 15 13:12:08 localhost kernel: [<7860b5a3>] ? tty_read+0x0/0xa4
Nov 15 13:12:08 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:08 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: gnome-keyring S f4493b03     0  2135      1 0x00000080
Nov 15 13:12:08 localhost kernel: f4493b70 00000046 00000001 f4493b03 f0f9c28f 00000016 78a02380 f4ab3ea0
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab411c f4ab4118 f4ab4118 78a02380 78a02380 00044c3b 00000000
Nov 15 13:12:08 localhost kernel: f20c9900 00000016 f4ab3ea0 f4493cbc 00000000 00000000 00000000 f4493bb8
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7878d324>] schedule_hrtimeout_range_clock+0x33/0xbd
Nov 15 13:12:08 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<7844b68c>] ? add_wait_queue+0x2b/0x30
Nov 15 13:12:08 localhost kernel: [<784ccdbc>] ? __pollwait+0x9f/0xa5
Nov 15 13:12:08 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:08 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:08 localhost kernel: [<784cd81e>] do_sys_poll+0x35b/0x3dc
Nov 15 13:12:08 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:08 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:08 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<787641aa>] ? scm_recv+0x2d/0xb5
Nov 15 13:12:08 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:08 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:08 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:08 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:08 localhost kernel: [<7878d236>] ? __mutex_lock_common+0x2e1/0x2eb
Nov 15 13:12:08 localhost kernel: [<784c7254>] ? pipe_read+0x4e/0x2ea
Nov 15 13:12:08 localhost kernel: [<7878ce0b>] ? __mutex_unlock_slowpath+0xf2/0xff
Nov 15 13:12:08 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:08 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<784c0331>] ? do_sync_read+0x9c/0xd6
Nov 15 13:12:08 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:08 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:08 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:08 localhost kernel: [<784cd9d7>] sys_poll+0x3f/0x88
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: top           R running      0  2154   1819 0x00000080
Nov 15 13:12:08 localhost kernel: e6c85d38 00000046 f4ab3430 f4ab3430 0f13bcd4 0000001c 78a02380 f4ab3430
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab36ac f4ab36a8 f4ab36ac 78a02380 78a02380 007a83a9 00000000
Nov 15 13:12:08 localhost kernel: e38c2f00 0000001c f4ab3430 e0dcd1b4 f3c59b80 00000000 00400040 e6c85d40
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7878c834>] _cond_resched+0x2b/0x44
Nov 15 13:12:08 localhost kernel: [<784350cd>] mmput+0x1d/0xb7
Nov 15 13:12:08 localhost kernel: [<784ffddc>] do_task_stat+0x6c4/0x6d1
Nov 15 13:12:08 localhost kernel: [<784ea31f>] ? sys_epoll_wait+0x1dd/0x27f
Nov 15 13:12:08 localhost kernel: [<784ea31f>] ? sys_epoll_wait+0x1dd/0x27f
Nov 15 13:12:08 localhost kernel: [<784ffe03>] proc_tgid_stat+0x1a/0x1f
Nov 15 13:12:08 localhost kernel: [<784fd12d>] proc_single_show+0x4a/0x63
Nov 15 13:12:08 localhost kernel: [<784d63fc>] seq_read+0x16a/0x321
Nov 15 13:12:08 localhost kernel: [<784d6292>] ? seq_read+0x0/0x321
Nov 15 13:12:08 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:08 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: flush-0:21    S e6cdbf24     0  2175      2 0x00000080
Nov 15 13:12:08 localhost kernel: e6cdbf68 00000046 7843c200 e6cdbf24 9089ba3e 0000000e 78a02380 f4ab5df0
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab606c f4ab6068 f4ab6068 78a02380 78a02380 00000dcf 00000000
Nov 15 13:12:08 localhost kernel: eabd9680 0000000e f4ab5df0 00000000 f2184550 f4ab5df0 f2184454 e6cdbf9c
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:12:08 localhost kernel: [<784d95fd>] bdi_writeback_thread+0xe2/0x125
Nov 15 13:12:08 localhost kernel: [<784d951b>] ? bdi_writeback_thread+0x0/0x125
Nov 15 13:12:08 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:08 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:08 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:08 localhost kernel: flush-0:22    S e6cddf24     0  2176      2 0x00000080
Nov 15 13:12:08 localhost kernel: e6cddf68 00000046 7843c200 e6cddf24 9089e68d 0000000e 78a02380 f4ab14e0
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab175c f4ab1758 f4ab1758 78a02380 78a02380 00000d42 00000000
Nov 15 13:12:08 localhost kernel: eabd9680 0000000e f4ab14e0 00000000 f2187360 f4ab14e0 f2187264 e6cddf9c
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:12:08 localhost kernel: [<784d95fd>] bdi_writeback_thread+0xe2/0x125
Nov 15 13:12:08 localhost kernel: [<784d951b>] ? bdi_writeback_thread+0x0/0x125
Nov 15 13:12:08 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:08 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:08 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:08 localhost kernel: flush-0:23    S e6cdff24     0  2177      2 0x00000080
Nov 15 13:12:08 localhost kernel: e6cdff68 00000046 7843c200 e6cdff24 908a0cd5 0000000e 78a02380 f4ab72d0
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab754c f4ab7548 f4ab7548 78a02380 78a02380 00000d05 00000000
Nov 15 13:12:08 localhost kernel: eabd9680 0000000e f4ab72d0 00000000 f3e9ec34 f4ab72d0 f3e9eb38 e6cdff9c
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:12:08 localhost kernel: [<784d95fd>] bdi_writeback_thread+0xe2/0x125
Nov 15 13:12:08 localhost kernel: [<784d951b>] ? bdi_writeback_thread+0x0/0x125
Nov 15 13:12:08 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:08 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:08 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:08 localhost kernel: kpktgend_0    S 00000000     0  2236      2 0x00000080
Nov 15 13:12:08 localhost kernel: e6cefe90 00000046 7878e27b 00000000 12f35343 0000001c 78a02380 f4ab5380
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab55fc f4ab55f8 f4ab55f8 78a02380 78a02380 00001cc5 00000000
Nov 15 13:12:08 localhost kernel: e38c2780 0000001c f4ab5380 00000286 e6cefea0 fffd4385 e6ceff4c e6cefed4
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7878e27b>] ? _raw_spin_unlock_irqrestore+0x3c/0x48
Nov 15 13:12:08 localhost kernel: [<7878ca9e>] schedule_timeout+0x81/0x9f
Nov 15 13:12:08 localhost kernel: [<784407ee>] ? process_timeout+0x0/0xa
Nov 15 13:12:08 localhost kernel: [<f8786de8>] pktgen_thread_worker+0x17c/0x15bf [pktgen]
Nov 15 13:12:08 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 15 13:12:08 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:08 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:08 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 15 13:12:08 localhost kernel: [<784302cb>] ? finish_task_switch+0x34/0xd4
Nov 15 13:12:08 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:08 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:08 localhost kernel: [<f8786c6c>] ? pktgen_thread_worker+0x0/0x15bf [pktgen]
Nov 15 13:12:08 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:08 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:08 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:08 localhost kernel: run_client_1  S f4738000     0  2276      1 0x00000080
Nov 15 13:12:08 localhost kernel: e6c9df1c 00000046 78931990 f4738000 dc22ad08 0000000e 78a02380 f4738000
Nov 15 13:12:08 localhost kernel: 78a02380 f473827c f4738278 f4738278 78a02380 78a02380 00107bea 00000000
Nov 15 13:12:08 localhost kernel: f3c58280 0000000e f4738000 78931980 e6c9df58 e6c9df58 f4738000 e6c9df4c
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:08 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:08 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:08 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: logchopper    S f4ab6860     0  2277      1 0x00000080
Nov 15 13:12:08 localhost kernel: e6ca7e58 00000046 00000007 f4ab6860 17e4ec07 00000019 78a02380 f4ab6860
Nov 15 13:12:08 localhost kernel: 78a02380 f4ab6adc f4ab6ad8 f4ab6ad8 78a02380 78a02380 016f1199 00000000
Nov 15 13:12:08 localhost kernel: 00000000 00000019 f4ab6860 e6ca7e50 e6ca7e60 e6c53ab0 e6ca7e74 e6ca7e80
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:08 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:08 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:08 localhost kernel: [<784e6148>] ? send_to_group+0x124/0x130
Nov 15 13:12:08 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:08 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:08 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:08 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:08 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: run_mgr_0     S f43bddf0     0  2279      1 0x00000080
Nov 15 13:12:08 localhost kernel: e6c99f1c 00000046 78931990 f43bddf0 d35f366b 0000000e 78a02380 f43bddf0
Nov 15 13:12:08 localhost kernel: 78a02380 f43be06c f43be068 f43be068 78a02380 78a02380 004548aa 00000000
Nov 15 13:12:08 localhost kernel: e6d02280 0000000e f43bddf0 78931980 e6c99f58 e6c99f58 f43bddf0 e6c99f4c
Nov 15 13:12:08 localhost kernel: Call Trace:
Nov 15 13:12:08 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:08 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:08 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:08 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:08 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:08 localhost kernel: logchopper    S f449ddf0     0  2280      1 0x00000080
Nov 15 13:12:08 localhost kernel: e6c83e58 00000046 00000007 f449ddf0 5d34c3bf 00000016 78a02380 f449ddf0
Nov 15 13:12:09 localhost kernel: 78a02380 f449e06c f449e068 f449e068 78a02380 78a02380 00007640 00000000
Nov 15 13:12:09 localhost kernel: eab1d180 00000016 f449ddf0 e6c83e50 e6c83e60 e6c533f0 e6c83e74 e6c83e80
Nov 15 13:12:09 localhost kernel: Call Trace:
Nov 15 13:12:09 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:09 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:09 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:09 localhost kernel: [<784567da>] ? clockevents_program_event+0xcb/0xdd
Nov 15 13:12:09 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:09 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:09 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:09 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:09 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:09 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:09 localhost kernel: run_pesq      S e6cc0a70     0  2284      1 0x00000080
Nov 15 13:12:09 localhost kernel: f4ac3f1c 00000046 78931990 e6cc0a70 cf97f62a 0000000e 78a02380 e6cc0a70
Nov 15 13:12:09 localhost kernel: 78a02380 e6cc0cec e6cc0ce8 e6cc0ce8 78a02380 78a02380 00088357 00000000
Nov 15 13:12:09 localhost kernel: e6d02780 0000000e e6cc0a70 78931980 f4ac3f58 f4ac3f58 e6cc0a70 f4ac3f4c
Nov 15 13:12:09 localhost kernel: Call Trace:
Nov 15 13:12:09 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:09 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:09 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:09 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:09 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:09 localhost kernel: logchopper    S e6cc14e0     0  2285      1 0x00000080
Nov 15 13:12:09 localhost kernel: e6d05e58 00000046 00000007 e6cc14e0 d37f39e7 0000000e 78a02380 e6cc14e0
Nov 15 13:12:09 localhost kernel: 78a02380 e6cc175c e6cc1758 e6cc1758 78a02380 78a02380 002ce932 00000000
Nov 15 13:12:09 localhost kernel: e6d03180 0000000e e6cc14e0 e6d05e50 e6d05e60 e6c536c0 e6d05e74 e6d05e80
Nov 15 13:12:09 localhost kernel: Call Trace:
Nov 15 13:12:09 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:09 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:09 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:09 localhost kernel: [<784e6148>] ? send_to_group+0x124/0x130
Nov 15 13:12:09 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:09 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:09 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:09 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:09 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:09 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:09 localhost kernel: pesqserver    S e6cc3ea0     0  2346   2284 0x00000080
Nov 15 13:12:09 localhost kernel: e6d0fad4 00000046 00000000 e6cc3ea0 d5aefb69 0000000e 78a02380 e6cc3ea0
Nov 15 13:12:09 localhost kernel: 78a02380 e6cc411c e6cc4118 e6cc4118 78a02380 78a02380 00007dab 00000000
Nov 15 13:12:09 localhost kernel: eab1d180 0000000e e6cc3ea0 00000000 e6d0fe24 00000000 e6d0fae4 e6d0fb1c
Nov 15 13:12:09 localhost kernel: Call Trace:
Nov 15 13:12:09 localhost kernel: [<7878d387>] schedule_hrtimeout_range_clock+0x96/0xbd
Nov 15 13:12:09 localhost kernel: [<7844dfff>] ? hrtimer_wakeup+0x0/0x1c
Nov 15 13:12:09 localhost kernel: [<7878d3c0>] schedule_hrtimeout_range+0x12/0x14
Nov 15 13:12:09 localhost kernel: [<784ccc9c>] poll_schedule_timeout+0x38/0x4f
Nov 15 13:12:09 localhost kernel: [<784cd486>] do_select+0x59c/0x5d9
Nov 15 13:12:09 localhost kernel: [<784cceea>] ? do_select+0x0/0x5d9
Nov 15 13:12:09 localhost kernel: [<784ccd1d>] ? __pollwait+0x0/0xa5
Nov 15 13:12:09 localhost kernel: [<784ccdc2>] ? pollwake+0x0/0x62
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:09 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:09 localhost kernel: [<784b52b7>] ? slab_pad_check+0x1e/0xf6
Nov 15 13:12:09 localhost kernel: [<784b5680>] ? check_object+0x154/0x185
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:09 localhost kernel: [<78427884>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:09 localhost kernel: [<78427eb6>] ? cpuacct_charge+0x50/0x57
Nov 15 13:12:09 localhost kernel: [<784593ff>] ? register_lock_class+0x17/0x297
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:09 localhost kernel: [<78428837>] ? check_preempt_wakeup+0x123/0x1a5
Nov 15 13:12:09 localhost kernel: [<7845a003>] ? valid_state+0xbc/0x170
Nov 15 13:12:09 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:09 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:09 localhost kernel: [<7845b370>] ? __lock_acquire+0x32c/0xb8b
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:09 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:09 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:09 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:09 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:09 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:09 localhost kernel: [<784cdc17>] core_sys_select+0x1b8/0x234
Nov 15 13:12:09 localhost kernel: [<784cda86>] ? core_sys_select+0x27/0x234
Nov 15 13:12:09 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:10 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:10 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784531b7>] ? ktime_get_ts+0xd1/0xd9
Nov 15 13:12:10 localhost kernel: [<784cde48>] sys_select+0x6e/0x89
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: btserver      S e6cc4910     0  2355   2279 0x00000080
Nov 15 13:12:10 localhost kernel: e6d11f1c 00000046 78931990 e6cc4910 ed4b33d1 0000001b 78a02380 e6cc4910
Nov 15 13:12:10 localhost kernel: 78a02380 e6cc4b8c e6cc4b88 e6cc4b88 78a02380 78a02380 007db2d1 00000000
Nov 15 13:12:10 localhost kernel: e38c2f00 0000001b e6cc4910 78931980 e6d11f58 e6d11f58 e6cc4910 e6d11f4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: btserver      D 7845a0d5     0  2375   2276 0x00000080
Nov 15 13:12:10 localhost kernel: e6d1fce4 00000046 e6d1fcb4 7845a0d5 625a9cf2 00000019 78a02380 e6cc5df0
Nov 15 13:12:10 localhost kernel: 78a02380 e6cc606c e6cc6068 e6cc6068 78a02380 78a02380 005fd6bf 00000000
Nov 15 13:12:10 localhost kernel: e38c2780 00000019 e6cc5df0 789826b4 789826b4 e6cc5df0 789826b8 e6d1fd30
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:10 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:10 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:10 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:10 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:10 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:10 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:10 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:10 localhost kernel: [<786e6269>] ? move_addr_to_kernel+0x3e/0x43
Nov 15 13:12:10 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:10 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<786e7b98>] sys_socketcall+0x169/0x289
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gnuserver     S e6cc3430     0  2407   2355 0x00000080
Nov 15 13:12:10 localhost kernel: e6cbff1c 00000046 78931990 e6cc3430 08757400 00000019 78a02380 e6cc3430
Nov 15 13:12:10 localhost kernel: 78a02380 e6cc36ac e6cc36a8 e6cc36a8 78a02380 78a02380 00068112 00000000
Nov 15 13:12:10 localhost kernel: e6d03180 00000019 e6cc3430 78931980 e6cbff58 e6cbff58 e6cc3430 e6cbff4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: iw            S 00000000     0  2458      1 0x00000080
Nov 15 13:12:10 localhost kernel: e6ff1c30 00000046 00000388 00000000 17882419 00000019 78a02380 e6cc29c0
Nov 15 13:12:10 localhost kernel: 78a02380 e6cc2c3c e6cc2c38 e6cc2c38 78a02380 78a02380 0000d937 00000000
Nov 15 13:12:10 localhost kernel: e46ff400 00000019 e6cc29c0 00000007 e6c925b0 7fffffff e6ff1cb8 e6ff1c74
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:10 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:10 localhost kernel: [<7844b5d5>] ? prepare_to_wait_exclusive+0x4e/0x55
Nov 15 13:12:10 localhost kernel: [<786ef5fd>] __skb_recv_datagram+0x194/0x1f9
Nov 15 13:12:10 localhost kernel: [<786ef68a>] ? receiver_wake_function+0x0/0x2a
Nov 15 13:12:10 localhost kernel: [<786ef685>] skb_recv_datagram+0x23/0x28
Nov 15 13:12:10 localhost kernel: [<7870d6a4>] netlink_recvmsg+0x44/0x27d
Nov 15 13:12:10 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:10 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:10 localhost kernel: [<786e9dfe>] ? sock_update_classid+0x7d/0xae
Nov 15 13:12:10 localhost kernel: [<786e59d7>] __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:10 localhost kernel: [<786e6028>] __sock_recvmsg+0x3d/0x44
Nov 15 13:12:10 localhost kernel: [<786e63c0>] sock_recvmsg+0x9d/0xb5
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:10 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:10 localhost kernel: [<786ee937>] ? verify_iovec+0x3e/0x77
Nov 15 13:12:10 localhost kernel: [<786e619c>] __sys_recvmsg+0xfb/0x18a
Nov 15 13:12:10 localhost kernel: [<786e6323>] ? sock_recvmsg+0x0/0xb5
Nov 15 13:12:10 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:10 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:10 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:10 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:10 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:10 localhost kernel: [<786e6773>] sys_recvmsg+0x36/0x4d
Nov 15 13:12:10 localhost kernel: [<786e7c6b>] sys_socketcall+0x23c/0x289
Nov 15 13:12:10 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: parse-iw-even S e6cc0000     0  2459      1 0x00000080
Nov 15 13:12:10 localhost kernel: e6ff5e58 00000046 00000007 e6cc0000 1812a1de 00000019 78a02380 e6cc0000
Nov 15 13:12:10 localhost kernel: 78a02380 e6cc027c e6cc0278 e6cc0278 78a02380 78a02380 000d4f32 00000000
Nov 15 13:12:10 localhost kernel: e6d03180 00000019 e6cc0000 e6ff5e50 e6ff5e60 e6c53120 e6ff5e74 e6ff5e80
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:10 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:10 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:10 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:10 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:10 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:10 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:10 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: kworker/0:3   D 7845a0d5     0  5972      2 0x00000080
Nov 15 13:12:10 localhost kernel: e47d5ebc 00000046 00000001 7845a0d5 17e5144b 00000019 78a02380 e54bc910
Nov 15 13:12:10 localhost kernel: 78a02380 e54bcb8c e54bcb88 e54bcb88 78a02380 78a02380 00000714 00000000
Nov 15 13:12:10 localhost kernel: 00000000 00000019 e54bc910 789826b4 789826b4 e54bc910 789826b8 e47d5f08
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:10 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:10 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:10 localhost kernel: [<787014c8>] linkwatch_event+0x8/0x22
Nov 15 13:12:10 localhost kernel: [<78446ee0>] process_one_work+0x1af/0x2bf
Nov 15 13:12:10 localhost kernel: [<78446e6f>] ? process_one_work+0x13e/0x2bf
Nov 15 13:12:10 localhost kernel: [<787014c0>] ? linkwatch_event+0x0/0x22
Nov 15 13:12:10 localhost kernel: [<7844862e>] worker_thread+0xf9/0x1bf
Nov 15 13:12:10 localhost kernel: [<78448535>] ? worker_thread+0x0/0x1bf
Nov 15 13:12:10 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:10 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:10 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e46d29c0     0  6275      1 0x00000080
Nov 15 13:12:10 localhost kernel: e46a3e58 00000046 00000007 e46d29c0 04ecaef6 00000019 78a02380 e46d29c0
Nov 15 13:12:10 localhost kernel: 78a02380 e46d2c3c e46d2c38 e46d2c38 78a02380 78a02380 00012fb3 00000000
Nov 15 13:12:10 localhost kernel: e46ff680 00000019 e46d29c0 e46a3e50 e46a3e60 e46062d0 e46a3e74 e46a3e80
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<784c6db0>] pipe_wait+0x4b/0x63
Nov 15 13:12:10 localhost kernel: [<7844b46e>] ? autoremove_wake_function+0x0/0x34
Nov 15 13:12:10 localhost kernel: [<784c748e>] pipe_read+0x288/0x2ea
Nov 15 13:12:10 localhost kernel: [<784c0331>] do_sync_read+0x9c/0xd6
Nov 15 13:12:10 localhost kernel: [<784c043d>] ? rw_verify_area+0xd2/0xed
Nov 15 13:12:10 localhost kernel: [<784c0295>] ? do_sync_read+0x0/0xd6
Nov 15 13:12:10 localhost kernel: [<784c09a8>] vfs_read+0x85/0xe4
Nov 15 13:12:10 localhost kernel: [<784c0a9d>] sys_read+0x3d/0x5e
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e46d1f50     0  6283      1 0x00000080
Nov 15 13:12:10 localhost kernel: e46edf1c 00000046 78931990 e46d1f50 031ed5fd 00000019 78a02380 e46d1f50
Nov 15 13:12:10 localhost kernel: 78a02380 e46d21cc e46d21c8 e46d21c8 78a02380 78a02380 00066f67 00000000
Nov 15 13:12:10 localhost kernel: f3c58280 00000019 e46d1f50 78931980 e46edf58 e46edf58 e46d1f50 e46edf4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e46d4910     0  6289      1 0x00000080
Nov 15 13:12:10 localhost kernel: e46adf1c 00000046 78931990 e46d4910 0cdc98bf 00000019 78a02380 e46d4910
Nov 15 13:12:10 localhost kernel: 78a02380 e46d4b8c e46d4b88 e46d4b88 78a02380 78a02380 0006fd1c 00000000
Nov 15 13:12:10 localhost kernel: f3c58280 00000019 e46d4910 78931980 e46adf58 e46adf58 e46d4910 e46adf4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e46d3ea0     0  6294      1 0x00000080
Nov 15 13:12:10 localhost kernel: e46fdf1c 00000046 78931990 e46d3ea0 13c52b50 00000019 78a02380 e46d3ea0
Nov 15 13:12:10 localhost kernel: 78a02380 e46d411c e46d4118 e46d4118 78a02380 78a02380 002aa6c6 00000000
Nov 15 13:12:10 localhost kernel: e46ff400 00000019 e46d3ea0 78931980 e46fdf58 e46fdf58 e46d3ea0 e46fdf4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e46d5380     0  6299      1 0x00000080
Nov 15 13:12:10 localhost kernel: e46a7f1c 00000046 78931990 e46d5380 0f854fc0 00000019 78a02380 e46d5380
Nov 15 13:12:10 localhost kernel: 78a02380 e46d55fc e46d55f8 e46d55f8 78a02380 78a02380 000906c1 00000000
Nov 15 13:12:10 localhost kernel: f3c58280 00000019 e46d5380 78931980 e46a7f58 e46a7f58 e46d5380 e46a7f4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:10 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:10 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:10 localhost kernel: gen_cfg.pl    S e54b8000     0  6304      1 0x00000080
Nov 15 13:12:10 localhost kernel: e39a9f1c 00000046 78931990 e54b8000 0a491452 00000019 78a02380 e54b8000
Nov 15 13:12:10 localhost kernel: 78a02380 e54b827c e54b8278 e54b8278 78a02380 78a02380 000717b5 00000000
Nov 15 13:12:10 localhost kernel: f3c58280 00000019 e54b8000 78931980 e39a9f58 e39a9f58 e54b8000 e39a9f4c
Nov 15 13:12:10 localhost kernel: Call Trace:
Nov 15 13:12:10 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:10 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:10 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:11 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: gen_cfg.pl    S e54bb430     0  6309      1 0x00000080
Nov 15 13:12:11 localhost kernel: e469bf1c 00000046 78931990 e54bb430 138e3ef9 00000019 78a02380 e54bb430
Nov 15 13:12:11 localhost kernel: 78a02380 e54bb6ac e54bb6a8 e54bb6a8 78a02380 78a02380 000a652a 00000000
Nov 15 13:12:11 localhost kernel: e38c2a00 00000019 e54bb430 78931980 e469bf58 e469bf58 e54bb430 e469bf4c
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:11 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:11 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:11 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: gen_cfg.pl    S e54bddf0     0  6314      1 0x00000080
Nov 15 13:12:11 localhost kernel: e46dbf1c 00000046 78931990 e54bddf0 03bf68e3 00000019 78a02380 e54bddf0
Nov 15 13:12:11 localhost kernel: 78a02380 e54be06c e54be068 e54be068 78a02380 78a02380 000710bf 00000000
Nov 15 13:12:11 localhost kernel: f3c58280 00000019 e54bddf0 78931980 e46dbf58 e46dbf58 e54bddf0 e46dbf4c
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:11 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:11 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:11 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: gen_cfg.pl    S e54bf2d0     0  6319      1 0x00000080
Nov 15 13:12:11 localhost kernel: e3a11f1c 00000046 78931990 e54bf2d0 16727a90 00000019 78a02380 e54bf2d0
Nov 15 13:12:11 localhost kernel: 78a02380 e54bf54c e54bf548 e54bf548 78a02380 78a02380 00450df0 00000000
Nov 15 13:12:11 localhost kernel: 00000000 00000019 e54bf2d0 78931980 e3a11f58 e3a11f58 e54bf2d0 e3a11f4c
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:11 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:11 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:11 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: gen_cfg.pl    S e6cc6860     0  6324      1 0x00000080
Nov 15 13:12:11 localhost kernel: e47d7f1c 00000046 78931990 e6cc6860 05833084 00000019 78a02380 e6cc6860
Nov 15 13:12:11 localhost kernel: 78a02380 e6cc6adc e6cc6ad8 e6cc6ad8 78a02380 78a02380 00065323 00000000
Nov 15 13:12:11 localhost kernel: f3c58280 00000019 e6cc6860 78931980 e47d7f58 e47d7f58 e6cc6860 e47d7f4c
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:11 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:11 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:11 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: ip            D 7845a0d5     0  6367   6283 0x00000080
Nov 15 13:12:11 localhost kernel: e3617cc4 00000046 e3617c94 7845a0d5 1649a044 00000019 78a02380 e46d0a70
Nov 15 13:12:11 localhost kernel: 78a02380 e46d0cec e46d0ce8 e46d0ce8 78a02380 78a02380 001d73ce 00000000
Nov 15 13:12:11 localhost kernel: e6d03400 00000019 e46d0a70 789826b4 789826b4 e46d0a70 789826b8 e3617d10
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:11 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:11 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:11 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:11 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:11 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:11 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:11 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:11 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:11 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:11 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:11 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:11 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:11 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<786e6520>] ? sockfd_lookup_light+0x16/0x46
Nov 15 13:12:11 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:11 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:11 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:11 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<786e6b1e>] sys_send+0x36/0x38
Nov 15 13:12:11 localhost kernel: [<786e7b6b>] sys_socketcall+0x13c/0x289
Nov 15 13:12:11 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: ip            D 00428314     0  6369   6314 0x00000080
Nov 15 13:12:11 localhost kernel: e3acf9d0 00000046 e46d3403 00428314 17a061ee 00000019 78a02380 e46d3430
Nov 15 13:12:11 localhost kernel: 78a02380 e46d36ac e46d36a8 e46d36a8 78a02380 78a02380 00173949 00000000
Nov 15 13:12:11 localhost kernel: 00000000 00000019 e46d3430 e3acfa94 e3acfa80 7fffffff e46d3430 e3acfa14
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7878ca33>] schedule_timeout+0x16/0x9f
Nov 15 13:12:11 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:11 localhost kernel: [<7878e236>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 15 13:12:11 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:11 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:11 localhost kernel: [<7878c908>] wait_for_common+0xbb/0x101
Nov 15 13:12:11 localhost kernel: [<784320db>] ? default_wake_function+0x0/0xd
Nov 15 13:12:11 localhost kernel: [<7878c9d1>] wait_for_completion+0x12/0x14
Nov 15 13:12:11 localhost kernel: [<78447bed>] flush_work+0x23/0x27
Nov 15 13:12:11 localhost kernel: [<78446adf>] ? wq_barrier_func+0x0/0xd
Nov 15 13:12:11 localhost kernel: [<f8b9d1d1>] ieee80211_do_stop+0x252/0x3b7 [mac80211]
Nov 15 13:12:11 localhost kernel: [<7843c200>] ? local_bh_enable_ip+0x8/0xa
Nov 15 13:12:11 localhost kernel: [<7878e211>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 15 13:12:11 localhost kernel: [<78707001>] ? dev_deactivate+0x0/0xd1
Nov 15 13:12:11 localhost kernel: [<f8b9d348>] ieee80211_stop+0x12/0x16 [mac80211]
Nov 15 13:12:11 localhost kernel: [<786f5e55>] __dev_close+0x73/0x88
Nov 15 13:12:11 localhost kernel: [<786f39b8>] ? dev_set_rx_mode+0x22/0x26
Nov 15 13:12:11 localhost kernel: [<786f3b5a>] __dev_change_flags+0xa5/0x11a
Nov 15 13:12:11 localhost kernel: [<786f5d00>] dev_change_flags+0x13/0x3f
Nov 15 13:12:11 localhost kernel: [<787004dd>] do_setlink+0x23a/0x525
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<78700b0b>] rtnl_newlink+0x283/0x45c
Nov 15 13:12:11 localhost kernel: [<78700906>] ? rtnl_newlink+0x7e/0x45c
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<784b5200>] ? on_freelist+0x151/0x17a
Nov 15 13:12:11 localhost kernel: [<7845a2e9>] ? mark_held_locks+0x47/0x5f
Nov 15 13:12:11 localhost kernel: [<7878d225>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 15 13:12:11 localhost kernel: [<7845a545>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 15 13:12:11 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:11 localhost kernel: [<78700888>] ? rtnl_newlink+0x0/0x45c
Nov 15 13:12:11 localhost kernel: [<78700043>] rtnetlink_rcv_msg+0x188/0x19e
Nov 15 13:12:11 localhost kernel: [<786ffebb>] ? rtnetlink_rcv_msg+0x0/0x19e
Nov 15 13:12:11 localhost kernel: [<7870e2d8>] netlink_rcv_skb+0x30/0x77
Nov 15 13:12:11 localhost kernel: [<786ffeb4>] rtnetlink_rcv+0x1b/0x22
Nov 15 13:12:11 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:11 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:11 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:11 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:11 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:11 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<785976a8>] ? _copy_from_user+0x31/0x115
Nov 15 13:12:11 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:11 localhost kernel: [<786ee937>] ? verify_iovec+0x3e/0x77
Nov 15 13:12:11 localhost kernel: [<786e68d7>] sys_sendmsg+0x14d/0x19a
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:11 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:11 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:11 localhost kernel: [<786e7c56>] sys_socketcall+0x227/0x289
Nov 15 13:12:11 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
Nov 15 13:12:11 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:11 localhost kernel: ip            D 7845a0d5     0  6373   6275 0x00000080
Nov 15 13:12:11 localhost kernel: e46c9c54 00000046 e46c9c24 7845a0d5 0a4ad3c8 00000019 78a02380 e46d14e0
Nov 15 13:12:11 localhost kernel: 78a02380 e46d175c e46d1758 e46d1758 78a02380 78a02380 012eae39 00000000
Nov 15 13:12:11 localhost kernel: eabd9900 00000019 e46d14e0 789826b4 789826b4 e46d14e0 789826b8 e46c9ca0
Nov 15 13:12:11 localhost kernel: Call Trace:
Nov 15 13:12:11 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:11 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:11 localhost kernel: [<7870d35c>] ? netlink_dump+0x3a/0x16a
Nov 15 13:12:11 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:11 localhost kernel: [<7870d35c>] ? netlink_dump+0x3a/0x16a
Nov 15 13:12:11 localhost kernel: [<7870d35c>] netlink_dump+0x3a/0x16a
Nov 15 13:12:11 localhost kernel: [<786ecc47>] ? consume_skb+0x2a/0x2c
Nov 15 13:12:11 localhost kernel: [<7870d7cd>] netlink_recvmsg+0x16d/0x27d
Nov 15 13:12:11 localhost kernel: [<786e8cef>] ? rcu_read_unlock+0x17/0x19
Nov 15 13:12:12 localhost kernel: [<786e59d7>] __sock_recvmsg_nosec+0x4a/0x52
Nov 15 13:12:12 localhost kernel: [<786e6028>] __sock_recvmsg+0x3d/0x44
Nov 15 13:12:12 localhost kernel: [<786e63c0>] sock_recvmsg+0x9d/0xb5
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a0104>] ? might_fault+0x90/0x96
Nov 15 13:12:12 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:12 localhost kernel: [<786ee937>] ? verify_iovec+0x3e/0x77
Nov 15 13:12:12 localhost kernel: [<786e619c>] __sys_recvmsg+0xfb/0x18a
Nov 15 13:12:12 localhost kernel: [<786e6323>] ? sock_recvmsg+0x0/0xb5
Nov 15 13:12:12 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:12 localhost kernel: [<78427eb6>] ? cpuacct_charge+0x50/0x57
Nov 15 13:12:12 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:12 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<786e6773>] sys_recvmsg+0x36/0x4d
Nov 15 13:12:12 localhost kernel: [<786e7c6b>] sys_socketcall+0x23c/0x289
Nov 15 13:12:12 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:12 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: ip            D 7845a0d5     0  6376   6324 0x00000080
Nov 15 13:12:12 localhost kernel: e453bcc4 00000046 e453bc94 7845a0d5 0a5321a2 00000019 78a02380 e54b94e0
Nov 15 13:12:12 localhost kernel: 78a02380 e54b975c e54b9758 e54b9758 78a02380 78a02380 000aebd4 00000000
Nov 15 13:12:12 localhost kernel: e38c3400 00000019 e54b94e0 789826b4 789826b4 e54b94e0 789826b8 e453bd10
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:12 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:12 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:12 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:12 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:12 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:12 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:12 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:12 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<786e6520>] ? sockfd_lookup_light+0x16/0x46
Nov 15 13:12:12 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:12 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:12 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:12 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<786e6b1e>] sys_send+0x36/0x38
Nov 15 13:12:12 localhost kernel: [<786e7b6b>] sys_socketcall+0x13c/0x289
Nov 15 13:12:12 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:12 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: sh            S e54be860     0  6377   2407 0x00000080
Nov 15 13:12:12 localhost kernel: e3609f1c 00000046 78931990 e54be860 0b26e49d 00000019 78a02380 e54be860
Nov 15 13:12:12 localhost kernel: 78a02380 e54beadc e54bead8 e54bead8 78a02380 78a02380 0e23bbc7 00000000
Nov 15 13:12:12 localhost kernel: 00000000 00000018 e54be860 78931980 e3609f58 e3609f58 e54be860 e3609f4c
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<7843a25b>] do_wait+0x158/0x1b6
Nov 15 13:12:12 localhost kernel: [<7843a341>] sys_wait4+0x88/0xa1
Nov 15 13:12:12 localhost kernel: [<7843887d>] ? child_wait_callback+0x0/0x5f
Nov 15 13:12:12 localhost kernel: [<7843a381>] sys_waitpid+0x27/0x29
Nov 15 13:12:12 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: ip            D 7845a0d5     0  6378   6304 0x00000080
Nov 15 13:12:12 localhost kernel: e4539cc4 00000046 e4539c94 7845a0d5 0ac0c72b 00000019 78a02380 e54b8a70
Nov 15 13:12:12 localhost kernel: 78a02380 e54b8cec e54b8ce8 e54b8ce8 78a02380 78a02380 0082b783 00000000
Nov 15 13:12:12 localhost kernel: e38c2500 00000019 e54b8a70 789826b4 789826b4 e54b8a70 789826b8 e4539d10
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:12 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:12 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:12 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:12 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:12 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:12 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:12 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:12 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<786e6520>] ? sockfd_lookup_light+0x16/0x46
Nov 15 13:12:12 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:12 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:12 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:12 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<786e6b1e>] sys_send+0x36/0x38
Nov 15 13:12:12 localhost kernel: [<786e7b6b>] sys_socketcall+0x13c/0x289
Nov 15 13:12:12 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:12 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: ip            D 7845a0d5     0  6379   6377 0x00000080
Nov 15 13:12:12 localhost kernel: e45bbcc4 00000046 e45bbc94 7845a0d5 0b86abda 00000019 78a02380 e54ba9c0
Nov 15 13:12:12 localhost kernel: 78a02380 e54bac3c e54bac38 e54bac38 78a02380 78a02380 00072f79 00000000
Nov 15 13:12:12 localhost kernel: 00000000 00000019 e54ba9c0 789826b4 789826b4 e54ba9c0 789826b8 e45bbd10
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:12 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:12 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:12 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:12 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:12 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:12 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:12 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:12 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<786e6520>] ? sockfd_lookup_light+0x16/0x46
Nov 15 13:12:12 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:12 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:12 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:12 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<786e6b1e>] sys_send+0x36/0x38
Nov 15 13:12:12 localhost kernel: [<786e7b6b>] sys_socketcall+0x13c/0x289
Nov 15 13:12:12 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:12 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: sh            R running      0  6380   6289 0x00000084
Nov 15 13:12:12 localhost kernel: e32e7fac 00000046 78501c21 e32e7f70 138bbec6 0000001c 78a02380 e54bd380
Nov 15 13:12:12 localhost kernel: 78a02380 e54bd5fc e54bd5f8 e54bd5fc 78a02380 78a02380 007a11f9 00000000
Nov 15 13:12:12 localhost kernel: e38c2780 0000001c e54bd380 e32e6000 00000001 00000002 6f726000 e32e6000
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<78501c21>] ? proc_sys_write+0x0/0x1f
Nov 15 13:12:12 localhost kernel: [<7878e5ca>] work_resched+0x5/0x30
Nov 15 13:12:12 localhost kernel: sh            R running      0  6381   6299 0x00000080
Nov 15 13:12:12 localhost kernel: e361df98 6f8ba000 78501c21 e361df70 78501c3b e361df98 00000001 e460fa00
Nov 15 13:12:12 localhost kernel: e361df8c 784c080d e361df98 00000007 e460fa00 fffffff7 6f8ba000 e361dfac
Nov 15 13:12:12 localhost kernel: 784c0902 e361df98 00000000 00000000 00000000 00000001 00000002 e361c000
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<78501c21>] ? proc_sys_write+0x0/0x1f
Nov 15 13:12:12 localhost kernel: [<78501c3b>] ? proc_sys_write+0x1a/0x1f
Nov 15 13:12:12 localhost kernel: [<784c080d>] ? vfs_write+0x88/0xe7
Nov 15 13:12:12 localhost kernel: [<784c0902>] ? sys_write+0x3d/0x5e
Nov 15 13:12:12 localhost kernel: [<784030dc>] ? sysenter_do_call+0x12/0x38
Nov 15 13:12:12 localhost kernel: sh            R running      0  6382   6309 0x00000084
Nov 15 13:12:12 localhost kernel: e4465fac 00000046 78501c21 e4465f70 136d376e 0000001c 78a02380 e6cc1f50
Nov 15 13:12:12 localhost kernel: 78a02380 e6cc21cc e6cc21c8 e6cc21cc 78a02380 78a02380 003d0b9a 00000000
Nov 15 13:12:12 localhost kernel: e38c2f00 0000001c e6cc1f50 e4464000 00000001 00000002 6f80d000 e4464000
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<78501c21>] ? proc_sys_write+0x0/0x1f
Nov 15 13:12:12 localhost kernel: [<7878e5ca>] work_resched+0x5/0x30
Nov 15 13:12:12 localhost kernel: ip            D 7845a0d5     0  6383   6294 0x00000080
Nov 15 13:12:12 localhost kernel: e3a0bcc4 00000046 e3a0bc94 7845a0d5 18907894 00000019 78a02380 e6cc72d0
Nov 15 13:12:12 localhost kernel: 78a02380 e6cc754c e6cc7548 e6cc7548 78a02380 78a02380 035afa0a 00000000
Nov 15 13:12:12 localhost kernel: e38c2f00 00000019 e6cc72d0 789826b4 789826b4 e6cc72d0 789826b8 e3a0bd10
Nov 15 13:12:12 localhost kernel: Call Trace:
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<7878d133>] __mutex_lock_common+0x1de/0x2eb
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<7878d2ec>] mutex_lock_nested+0x36/0x3b
Nov 15 13:12:12 localhost kernel: [<786ffe97>] ? rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:12 localhost kernel: [<786ffea7>] rtnetlink_rcv+0xe/0x22
Nov 15 13:12:12 localhost kernel: [<7870e0f7>] netlink_unicast+0xbe/0x11a
Nov 15 13:12:12 localhost kernel: [<786ee5ec>] ? copy_from_user+0x8/0xa
Nov 15 13:12:12 localhost kernel: [<7870ecc8>] netlink_sendmsg+0x23e/0x255
Nov 15 13:12:12 localhost kernel: [<786e8b28>] ? rcu_read_lock+0x0/0x35
Nov 15 13:12:12 localhost kernel: [<786e5fe4>] __sock_sendmsg+0x54/0x5b
Nov 15 13:12:12 localhost kernel: [<786e64ae>] sock_sendmsg+0x95/0xac
Nov 15 13:12:12 localhost kernel: [<784c130d>] ? fcheck_files+0x9b/0xca
Nov 15 13:12:12 localhost kernel: [<784c1369>] ? fget_light+0x2d/0xb0
Nov 15 13:12:12 localhost kernel: [<7845a0d5>] ? mark_lock+0x1e/0x1eb
Nov 15 13:12:12 localhost kernel: [<786e6520>] ? sockfd_lookup_light+0x16/0x46
Nov 15 13:12:12 localhost kernel: [<786e6acc>] sys_sendto+0xaa/0xc6
Nov 15 13:12:12 localhost kernel: [<784a2406>] ? __do_fault+0x32d/0x359
Nov 15 13:12:12 localhost kernel: [<7845bce2>] ? lock_release_non_nested+0x86/0x1ec
Nov 15 13:12:12 localhost kernel: [<784a2cfd>] ? handle_mm_fault+0x322/0x825
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:12 localhost kernel: [<784a00be>] ? might_fault+0x4a/0x96
Nov 15 13:12:13 localhost kernel: [<786e6b1e>] sys_send+0x36/0x38
Nov 15 13:12:13 localhost kernel: [<786e7b6b>] sys_socketcall+0x13c/0x289
Nov 15 13:12:13 localhost kernel: [<7878e53e>] ? restore_all_notrace+0x0/0x18
Nov 15 13:12:13 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:13 localhost kernel: sh            R running      0  6384   6319 0x00000084
Nov 15 13:12:13 localhost kernel: e4627fac 00000046 78501c21 e4627f70 134eb589 0000001c 78a02380 e6cc5380
Nov 15 13:12:13 localhost kernel: 78a02380 e6cc55fc e6cc55f8 e6cc55fc 78a02380 78a02380 006ad6ac 00000000
Nov 15 13:12:13 localhost kernel: e38c2a00 0000001c e6cc5380 e4626000 00000001 00000002 6f708000 e4626000
Nov 15 13:12:13 localhost kernel: Call Trace:
Nov 15 13:12:13 localhost kernel: [<78501c21>] ? proc_sys_write+0x0/0x1f
Nov 15 13:12:13 localhost kernel: [<7878e5ca>] work_resched+0x5/0x30
Nov 15 13:12:13 localhost kernel: kworker/0:4   S e468df5c     0  6385      2 0x00000080
Nov 15 13:12:13 localhost kernel: e468df78 00000046 f438b260 e468df5c 03741e31 0000001c 78a02380 f4ab1f50
Nov 15 13:12:13 localhost kernel: 78a02380 f4ab21cc f4ab21c8 f4ab21c8 78a02380 78a02380 005bd19b 00000000
Nov 15 13:12:13 localhost kernel: e38c2780 0000001c f4ab1f50 7845a571 e4606b40 e4606b50 f6003180 e468df9c
Nov 15 13:12:13 localhost kernel: Call Trace:
Nov 15 13:12:13 localhost kernel: [<7845a571>] ? trace_hardirqs_on+0xb/0xd
Nov 15 13:12:13 localhost kernel: [<784486ef>] worker_thread+0x1ba/0x1bf
Nov 15 13:12:13 localhost kernel: [<78448535>] ? worker_thread+0x0/0x1bf
Nov 15 13:12:13 localhost kernel: [<7844b15e>] kthread+0x62/0x67
Nov 15 13:12:13 localhost kernel: [<7844b0fc>] ? kthread+0x0/0x67
Nov 15 13:12:13 localhost kernel: [<784036c6>] kernel_thread_helper+0x6/0x1a
Nov 15 13:12:13 localhost kernel: mkdir         R running      0  6387   2355 0x00000080
Nov 15 13:12:13 localhost kernel: e0c61eb0 00000046 78404c08 00000007 12886acc 0000001c 78a02380 f4ab4910
Nov 15 13:12:13 localhost kernel: 78a02380 f4ab4b8c f4ab4b88 f4ab4b8c 78a02380 78a02380 006aeaab 00000000
Nov 15 13:12:13 localhost kernel: e38c2f00 0000001c f4ab4910 00000007 00000000 77e42c85 e456c100 e0c61eb8
Nov 15 13:12:13 localhost kernel: Call Trace:
Nov 15 13:12:13 localhost kernel: [<78404c08>] ? do_softirq+0xa7/0xbf
Nov 15 13:12:13 localhost kernel: [<7878c834>] _cond_resched+0x2b/0x44
Nov 15 13:12:13 localhost kernel: [<784a009e>] might_fault+0x2a/0x96
Nov 15 13:12:13 localhost kernel: [<784b698d>] ? kmem_cache_alloc+0x81/0xa1
Nov 15 13:12:13 localhost kernel: [<7859762c>] strncpy_from_user+0x33/0x4f
Nov 15 13:12:13 localhost kernel: [<784c94d2>] getname+0x62/0xb8
Nov 15 13:12:13 localhost kernel: [<784c9cfa>] user_path_parent+0x15/0x51
Nov 15 13:12:13 localhost kernel: [<784ca18a>] sys_mkdirat+0x22/0xb6
Nov 15 13:12:13 localhost kernel: [<784dc5b1>] ? set_fs_pwd+0x17/0x51
Nov 15 13:12:13 localhost kernel: [<784c7c9e>] ? mntput+0x13/0x15
Nov 15 13:12:13 localhost kernel: [<78403111>] ? sysenter_exit+0xf/0x1a
Nov 15 13:12:13 localhost kernel: [<784ca23e>] sys_mkdir+0x20/0x22
Nov 15 13:12:13 localhost kernel: [<784030dc>] sysenter_do_call+0x12/0x38
Nov 15 13:12:13 localhost kernel: Sched Debug Version: v0.09, 2.6.37-rc1-wl+ #48
Nov 15 13:12:13 localhost kernel: now at 120611.780932 msecs
Nov 15 13:12:13 localhost kernel:  .jiffies                                 : 4294787884
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_latency                    : 6.000000
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_min_granularity            : 0.750000
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_wakeup_granularity         : 1.000000
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_child_runs_first           : 0
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_features                   : 31855
Nov 15 13:12:13 localhost kernel:  .sysctl_sched_tunable_scaling            : 1 (logaritmic)
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel: cpu#0, 1866.539 MHz
Nov 15 13:12:13 localhost kernel:  .nr_running                    : 7
Nov 15 13:12:13 localhost kernel:  .load                          : 190261
Nov 15 13:12:13 localhost kernel:  .nr_switches                   : 96313
Nov 15 13:12:13 localhost kernel:  .nr_load_updates               : 72841
Nov 15 13:12:13 localhost kernel:  .nr_uninterruptible            : 12
Nov 15 13:12:13 localhost kernel:  .next_balance                  : 4294.764070
Nov 15 13:12:13 localhost kernel:  .curr->pid                     : 6381
Nov 15 13:12:13 localhost kernel:  .clock                         : 120588.003079
Nov 15 13:12:13 localhost kernel:  .cpu_load[0]                   : 190261
Nov 15 13:12:13 localhost kernel:  .cpu_load[1]                   : 190261
Nov 15 13:12:13 localhost kernel:  .cpu_load[2]                   : 190261
Nov 15 13:12:13 localhost kernel:  .cpu_load[3]                   : 190261
Nov 15 13:12:13 localhost kernel:  .cpu_load[4]                   : 190261
Nov 15 13:12:13 localhost kernel:  .yld_count                     : 2899
Nov 15 13:12:13 localhost kernel:  .sched_switch                  : 0
Nov 15 13:12:13 localhost kernel:  .sched_count                   : 102079
Nov 15 13:12:13 localhost kernel:  .sched_goidle                  : 7958
Nov 15 13:12:13 localhost kernel:  .avg_idle                      : 1000000
Nov 15 13:12:13 localhost kernel:  .ttwu_count                    : 46758
Nov 15 13:12:13 localhost kernel:  .ttwu_local                    : 46758
Nov 15 13:12:13 localhost kernel:  .bkl_count                     : 0
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel: cfs_rq[0]:/
Nov 15 13:12:13 localhost kernel:  .exec_clock                    : 65766.599833
Nov 15 13:12:13 localhost kernel:  .MIN_vruntime                  : 14057.157383
Nov 15 13:12:13 localhost kernel:  .min_vruntime                  : 14057.157383
Nov 15 13:12:13 localhost kernel:  .max_vruntime                  : 14057.783848
Nov 15 13:12:13 localhost kernel:  .spread                        : 0.626465
Nov 15 13:12:13 localhost kernel:  .spread0                       : 0.000000
Nov 15 13:12:13 localhost kernel:  .nr_running                    : 7
Nov 15 13:12:13 localhost kernel:  .load                          : 190261
Nov 15 13:12:13 localhost kernel:  .nr_spread_over                : 7
Nov 15 13:12:13 localhost kernel:  .shares                        : 0
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel: rt_rq[0]:/
Nov 15 13:12:13 localhost kernel:  .rt_nr_running                 : 0
Nov 15 13:12:13 localhost kernel:  .rt_throttled                  : 0
Nov 15 13:12:13 localhost kernel:  .rt_time                       : 0.000000
Nov 15 13:12:13 localhost kernel:  .rt_runtime                    : 950.000000
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel: runnable tasks:
Nov 15 13:12:13 localhost kernel:            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Nov 15 13:12:13 localhost kernel: ----------------------------------------------------------------------------------------------------------
Nov 15 13:12:13 localhost kernel:     kworker/u:5    41     14057.509652       913   120     14057.509652       608.324338     91123.303537 /
Nov 15 13:12:13 localhost kernel:             top  2154     14057.783848       375   120     14057.783848       725.178509     66683.912703 /
Nov 15 13:12:13 localhost kernel:              sh  6380     14057.194090      1594   103     14057.194090      3174.490858         0.000000 /
Nov 15 13:12:13 localhost kernel: R             sh  6381     14057.172953      1583   103     14057.172953      3143.640629         0.000000 /
Nov 15 13:12:13 localhost kernel:              sh  6382     14057.165841      1579   103     14057.165841      3120.222997         0.000000 /
Nov 15 13:12:13 localhost kernel:              sh  6384     14057.157383      1589   103     14057.157383      3114.835179         0.000000 /
Nov 15 13:12:13 localhost kernel:           mkdir  6387     14057.386318        11   115     14057.386318        11.084511         0.000000 /
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel:
Nov 15 13:12:13 localhost kernel: Showing all locks held in the system:
Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:1/19:
Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #1:  (wireless_nlevent_work){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:2/1054:
Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #1:  ((&rdev->conn_work)){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 1 lock held by ntpd/1592:
Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1939:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1940:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1941:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1942:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1943:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by mingetty/1944:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2043:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2057:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by bash/2113:
Nov 15 13:12:13 localhost kernel: #0:  (&tty->atomic_read_lock){+.+...}, at: [<7860f455>] n_tty_read+0x1d2/0x5ee
Nov 15 13:12:13 localhost kernel: 1 lock held by btserver/2375:
Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 3 locks held by kworker/0:3/5972:
Nov 15 13:12:13 localhost kernel: #0:  (events){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #1:  ((linkwatch_work).work){+.+.+.}, at: [<78446e6f>] process_one_work+0x13e/0x2bf
Nov 15 13:12:13 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 1 lock held by ip/6367:
Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:13 localhost kernel: 1 lock held by ip/6369:
Nov 15 13:12:13 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6373:
Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<7870d35c>] netlink_dump+0x3a/0x16a
Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6376:
Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6378:
Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6379:
Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:14 localhost kernel: 4 locks held by sh/6381:
Nov 15 13:12:14 localhost kernel: #0:  (&(&i->lock)->rlock){-.-...}, at: [<78631710>] serial8250_interrupt+0x1e/0xe2
Nov 15 13:12:14 localhost kernel: #1:  (&port_lock_key){-.-...}, at: [<78631496>] serial8250_handle_port+0x10/0x26c
Nov 15 13:12:14 localhost kernel: #2:  (sysrq_key_table_lock){-.....}, at: [<7861e8c2>] __handle_sysrq+0x18/0x11d
Nov 15 13:12:14 localhost kernel: #3:  (tasklist_lock){.?.+..}, at: [<78459d8b>] debug_show_all_locks+0x43/0x179
Nov 15 13:12:14 localhost kernel: 1 lock held by ip/6383:
Nov 15 13:12:14 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<786ffe97>] rtnl_lock+0xf/0x11
Nov 15 13:12:14 localhost kernel:
Nov 15 13:12:14 localhost kernel: =============================================
Nov 15 13:12:14 localhost kernel:
Nov 15 13:12:14 localhost kernel: sta20: deauthenticating from 30:46:9a:10:0b:9a by local choice (reason=3)
Nov 15 13:12:14 localhost kernel: ieee80211 wiphy0: Removed STA 30:46:9a:10:0b:9a
Nov 15 13:12:14 localhost kernel: ieee80211 wiphy0: Destroyed STA 30:46:9a:10:0b:9a
Nov 15 13:12:14 localhost kernel: sta16: deauthenticating from 30:46:9a:10:0b:9a by local choice (reason=3)
Nov 15 13:12:14 localhost kernel: ieee80211 wiphy0: Removed STA 30:46:9a:10:0b:9a
Nov 15 13:12:14 localhost kernel: ieee80211 wiphy0: Destroyed STA 30:46:9a:10:0b:9a

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

