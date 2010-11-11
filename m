Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39121 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0KKQz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 11:55:57 -0500
Message-ID: <4CDC2016.8020200@candelatech.com>
Date: Thu, 11 Nov 2010 08:55:50 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
References: <4CDB2488.4040802@candelatech.com> <1289437356.3748.25.camel@jlt3.sipsolutions.net> <4CDBB716.7020802@kernel.org>
In-Reply-To: <4CDBB716.7020802@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 01:27 AM, Tejun Heo wrote:
> Hello,
>
> On 11/11/2010 02:02 AM, Johannes Berg wrote:
>> I don't really see any deadlock here... hmm. Tejun, do you see anything
>> wrong with the "locking" in workq stuff here?
>>
>> Something is holding the RTNL, and a bunch of other things are trying to
>> acquire it. We don't really know who's holding it and who's acquiring it
>> though.
>>
>>> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> ...
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> ...
>>> Nov 10 14:54:33 localhost kernel: #2:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
> ...
>>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6438:
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070f78c>] netlink_dump+0x3a/0x16a
>>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6441:
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6442:
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>>> Nov 10 14:54:33 localhost kernel: 1 lock held by iwconfig/6443:
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>>> Nov 10 14:54:33 localhost kernel: 1 lock held by ip/6444:
>>> Nov 10 14:54:33 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11
>
> Looks like everyone is stuck trying to get hold of rtnl_mutex.
> Lockdep seems enabled, isn't there a sysrq which shows all held locks?
> Yeah, it's 'd'.  I don't think much can be found out by looking at the
> above part.  We need to be looking at who's holding the lock.  Is the
> problem reproducible?

It is reproducible, and the output above is from sysrq-d.

In the dump of the processes hung for 120 seconds, there was this one.
I think it successfully got rtnl_lock, and maybe it's waiting on
a wait-queue or something?

Please note that the 'sysrq-d' and
this capture below were from different instances of the deadlock.
For whatever reason, sysrq-d is only printing useful data some
of the time.

Nov 10 13:26:24 localhost kernel: INFO: task ip:7603 blocked for more than 120 seconds.
Nov 10 13:26:24 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 10 13:26:24 localhost kernel: ip            D 00428314     0  7603   7548 0x00000080
Nov 10 13:26:24 localhost kernel: f106b9d0 00000046 f1009403 00428314 533f1a80 00000045 c0a22380 f10094e0
Nov 10 13:26:24 localhost kernel: c0a22380 f100975c f1009758 f1009758 c0a22380 c0a22380 0014a3a9 00000000
Nov 10 13:26:24 localhost kernel: f23a4780 00000045 f10094e0 f106ba94 f106ba80 7fffffff f10094e0 f106ba14
Nov 10 13:26:24 localhost kernel: Call Trace:
Nov 10 13:26:24 localhost kernel: [<c078f4a3>] schedule_timeout+0x16/0x9f
Nov 10 13:26:24 localhost kernel: [<c045a2b1>] ? mark_held_locks+0x47/0x5f
Nov 10 13:26:24 localhost kernel: [<c0790ca6>] ? _raw_spin_unlock_irq+0x22/0x2b
Nov 10 13:26:24 localhost kernel: [<c045a50d>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 10 13:26:24 localhost kernel: [<c045a539>] ? trace_hardirqs_on+0xb/0xd
Nov 10 13:26:24 localhost kernel: [<c078f378>] wait_for_common+0xbb/0x101
Nov 10 13:26:24 localhost kernel: [<c0432063>] ? default_wake_function+0x0/0xd
Nov 10 13:26:24 localhost kernel: [<c078f441>] wait_for_completion+0x12/0x14
Nov 10 13:26:24 localhost kernel: [<c0447b6b>] flush_work+0x23/0x27
Nov 10 13:26:24 localhost kernel: [<c0446a5e>] ? wq_barrier_func+0x0/0xd
Nov 10 13:26:24 localhost kernel: [<f8c9e1e1>] ieee80211_do_stop+0x252/0x3b7 [mac80211]
Nov 10 13:26:24 localhost kernel: [<c043c184>] ? local_bh_enable_ip+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c0790c81>] ? _raw_spin_unlock_bh+0x25/0x28
Nov 10 13:26:24 localhost kernel: [<c0709401>] ? dev_deactivate+0x18/0xd1
Nov 10 13:26:24 localhost kernel: [<f8c9e358>] ieee80211_stop+0x12/0x16 [mac80211]
Nov 10 13:26:24 localhost kernel: [<c06f8131>] __dev_close+0x73/0x88
Nov 10 13:26:24 localhost kernel: [<c06f5c1e>] ? dev_set_rx_mode+0x22/0x26
Nov 10 13:26:24 localhost kernel: [<c06f5dc0>] __dev_change_flags+0xa5/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f7fdc>] dev_change_flags+0x13/0x3f
Nov 10 13:26:24 localhost kernel: [<c0702855>] do_setlink+0x23a/0x525
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c0702e83>] rtnl_newlink+0x283/0x45c
Nov 10 13:26:24 localhost kernel: [<c0702c7e>] ? rtnl_newlink+0x7e/0x45c
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c04b5300>] ? slab_pad_check+0xb/0xf6
Nov 10 13:26:24 localhost kernel: [<c045a2b1>] ? mark_held_locks+0x47/0x5f
Nov 10 13:26:24 localhost kernel: [<c078fc95>] ? __mutex_lock_common+0x2d0/0x2eb
Nov 10 13:26:24 localhost kernel: [<c045a50d>] ? trace_hardirqs_on_caller+0x104/0x125
Nov 10 13:26:24 localhost kernel: [<c070220f>] ? rtnl_lock+0xf/0x11

rtnl successfully acquired here, I think. ^^

Nov 10 13:26:24 localhost kernel: [<c0702c00>] ? rtnl_newlink+0x0/0x45c
Nov 10 13:26:24 localhost kernel: [<c07023bb>] rtnetlink_rcv_msg+0x188/0x19e
Nov 10 13:26:24 localhost kernel: [<c0702233>] ? rtnetlink_rcv_msg+0x0/0x19e
Nov 10 13:26:24 localhost kernel: [<c0710708>] netlink_rcv_skb+0x30/0x77
Nov 10 13:26:24 localhost kernel: [<c070222c>] rtnetlink_rcv+0x1b/0x22
Nov 10 13:26:24 localhost kernel: [<c0710527>] netlink_unicast+0xbe/0x11a
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c07110f8>] netlink_sendmsg+0x23e/0x255
Nov 10 13:26:24 localhost kernel: [<c06eace8>] ? rcu_read_lock+0x0/0x35
Nov 10 13:26:24 localhost kernel: [<c06e81a4>] __sock_sendmsg+0x54/0x5b
Nov 10 13:26:24 localhost kernel: [<c06e866e>] sock_sendmsg+0x95/0xac
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c0597708>] ? _copy_from_user+0x31/0x115
Nov 10 13:26:24 localhost kernel: [<c06f07fc>] ? copy_from_user+0x8/0xa
Nov 10 13:26:24 localhost kernel: [<c06f0b47>] ? verify_iovec+0x3e/0x77
Nov 10 13:26:24 localhost kernel: [<c06e8a97>] sys_sendmsg+0x14d/0x19a
Nov 10 13:26:24 localhost kernel: [<c045a09d>] ? mark_lock+0x1e/0x1eb
Nov 10 13:26:24 localhost kernel: [<c04a247d>] ? __do_fault+0x32d/0x359
Nov 10 13:26:24 localhost kernel: [<c045bcaa>] ? lock_release_non_nested+0x86/0x1ec
Nov 10 13:26:24 localhost kernel: [<c04c1365>] ? fcheck_files+0x9b/0xca
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a013a>] ? might_fault+0x4a/0x96
Nov 10 13:26:24 localhost kernel: [<c04a0180>] ? might_fault+0x90/0x96
Nov 10 13:26:24 localhost kernel: [<c06e9e16>] sys_socketcall+0x227/0x289
Nov 10 13:26:24 localhost kernel: [<c0403111>] ? sysenter_exit+0xf/0x1a
Nov 10 13:26:24 localhost kernel: [<c04030dc>] sysenter_do_call+0x12/0x38
Nov 10 13:26:24 localhost kernel: 1 lock held by ip/7603:
Nov 10 13:26:24 localhost kernel: #0:  (rtnl_mutex){+.+.+.}, at: [<c070220f>] rtnl_lock+0xf/0x11



>
> Thank you.
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

