Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60428 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab3ILScm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 14:32:42 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r8CIWfnU002409
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Sep 2013 11:32:42 -0700
Message-ID: <523208C9.7050909@candelatech.com> (sfid-20130912_203248_683551_F4436FB4)
Date: Thu, 12 Sep 2013 11:32:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: iee80211_scan_work crash in 3.11.0+ kernel.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This kernel has our standard set of patches, but nothing much beyond
what we ran in the 3.9 kernel for some time without seeing this particular
crash, so I am thinking it might be something new in 3.11.  I do have my
scan-one-channel patch in this tree, so it's possible it is somehow
to blame.

This happened on restart of our user-space app, which would have been
restarting supplicant/hostapd and re-configuring interfaces.  It should
not have been actually creating or deleting any network devices as they
were already created.

This crash was in a kernel w/out debugging symbols, but after re-building with
debugging, it decodes to here:

(gdb) l *(ieee80211_scan_work+0x321)
0x8e11 is in ieee80211_scan_work (/home/greearb/git/linux-3.11.dev.y/net/mac80211/scan.c:608).
603	{
604		/*
605		 * TODO: channel switching also consumes quite some time,
606		 * add that delay as well to get a better estimation
607		 */
608		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
609			return IEEE80211_PASSIVE_CHANNEL_TIME;
610		return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
611	}
612	
(gdb)

Maybe scan_channel_idx is out of bounds somehow?

My 3.11 tree is at:

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.11.dev.y/.git;a=summary


[518743.539126] BUG: unable to handle kernel paging request at 00003b43
[518743.540019] IP: [<f861be11>] ieee80211_scan_work+0x321/0x3e0 [mac80211]
[518743.540019] *pdpt = 0000000016113001 *pde = 0000000000000000
[518743.540019] Oops: 0000 [#1] PREEMPT SMP
[518743.540019] Modules linked in: ipt_MASQUERADE iptable_nat iptable_raw xt_CT veth nfnetlink_log nfnetlink nf_conntrack]
[518743.540019] CPU: 0 PID: 565 Comm: kworker/u4:0 Tainted: G         C O 3.11.0+ #20
[518743.645757] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/31/20
[518743.645757] Workqueue: phy0 ieee80211_scan_work [mac80211]
[518743.645757] task: f1f54d40 ti: effd8000 task.ti: effd8000
[518743.645757] EIP: 0060:[<f861be11>] EFLAGS: 00010202 CPU: 0
[518743.645757] EIP is at ieee80211_scan_work+0x321/0x3e0 [mac80211]
[518743.645757] EAX: 00003b3b EBX: f463c360 ECX: 1ee6d214 EDX: f465b400
[518743.645757] ESI: 00000000 EDI: 00000001 EBP: effd9ef8 ESP: effd9ec8
[518743.645757]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[518743.645757] CR0: 8005003b CR2: 00003b43 CR3: 2ff88000 CR4: 000007e0
[518743.645757] Stack:
[518743.645757]  0001d7cb f79db400 f463cf2c f463ceb0 f463ce78 f463ce80 1ee6d110 f536eaec
[518743.645757]  00000000 f463cf2c f1ff1a80 00000080 effd9f30 c0471d1a c0487f9d f79db400
[518743.645757]  f1f54d40 c0c3e980 efc7eb2a f496f695 f496f600 00001000 f5004400 f1ff1a80
[518743.645757] Call Trace:
[518743.645757]  [<c0471d1a>] process_one_work+0x11a/0x400
[518743.645757]  [<c0487f9d>] ? try_to_wake_up+0x1bd/0x220
[518743.645757]  [<c0472f5f>] worker_thread+0xff/0x3c0
[518743.645757]  [<c0477ff4>] kthread+0xa4/0xb0
[518743.645757]  [<c0472e60>] ? manage_workers+0x2a0/0x2a0
[518743.645757]  [<c0480000>] ? SyS_setgroups+0xb0/0xf0
[518743.645757]  [<c09d35b7>] ret_from_kernel_thread+0x1b/0x28
[518743.645757]  [<c0477f50>] ? kthread_freezable_should_stop+0x50/0x50
[518743.645757] Code: 01 00 00 00 8b 45 e4 e8 8e cf 3a c8 8b 8b c4 0b 00 00 8b 93 94 0b 00 00 89 4d e8 8b 83 a4 0b 00 00 0
[518743.645757] EIP: [<f861be11>] ieee80211_scan_work+0x321/0x3e0 [mac80211] SS:ESP 0068:effd9ec8
[518743.645757] CR2: 0000000000003b43
[518743.963077] ---[ end trace 7b4bcf9767616f77 ]---
[518743.971245] BUG: unable to handle kernel paging request at ffffffec
[518743.972018] IP: [<c0477a3f>] kthread_data+0xf/0x20
[518743.972018] *pdpt = 0000000000d85001 *pde = 00000000379fd067 *pte = 0000000000000000
[518743.972018] Oops: 0000 [#2] PREEMPT SMP
[518743.972018] Modules linked in: ipt_MASQUERADE iptable_nat iptable_raw xt_CT veth nfnetlink_log nfnetlink nf_conntrack]
[518743.972018] CPU: 0 PID: 565 Comm: kworker/u4:0 Tainted: G      D  C O 3.11.0+ #20
[518743.972018] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080015  05/31/20
[518743.972018] task: f1f54d40 ti: effd8000 task.ti: effd8000
[518743.972018] EIP: 0060:[<c0477a3f>] EFLAGS: 00010002 CPU: 0
[518743.972018] EIP is at kthread_data+0xf/0x20
[518743.972018] EAX: 00000000 EBX: 00000000 ECX: f79db400 EDX: 00000000
[518743.972018] ESI: 00000000 EDI: f1f54d40 EBP: effd9c90 ESP: effd9c88
[518743.972018]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[518743.972018] CR0: 8005003b CR2: 00000014 CR3: 36fee000 CR4: 000007e0
[518743.972018] Stack:
[518743.972018]  c04704e0 f1f54d40 effd9d20 c09cac99 c0c937d4 00000086 00000086 effd9cc4
[518743.972018]  f1f54d40 c0d7e400 c0d7e400 c0d7e400 c0d7e400 f5b10b80 00000235 f79db400
[518743.972018]  f1f54d40 effd9cec 00000246 c0457098 00000246 0035df80 f1f54d40 f1f54d40
[518743.972018] Call Trace:
[518743.972018]  [<c04704e0>] ? wq_worker_sleeping+0x10/0x80
[518743.972018]  [<c09cac99>] __schedule+0x5c9/0x7d0
[518743.972018]  [<c0457098>] ? __cleanup_sighand+0x28/0x30
[518743.972018]  [<c04de8bc>] ? call_rcu+0x1c/0x20
[518743.972018]  [<c045a87f>] ? release_task+0x2bf/0x410
[518743.972018]  [<c04c2901>] ? cgroup_exit+0x31/0xf0
[518743.972018]  [<c09cb043>] schedule+0x23/0x60
[518743.972018]  [<c045bb77>] do_exit+0x5f7/0x980
[518743.972018]  [<c09c86f3>] ? printk+0x3d/0x3f
[518743.972018]  [<c09cdf16>] oops_end+0x96/0xd0
[518743.972018]  [<c044bb38>] no_context+0xd8/0x1f0
[518743.972018]  [<c044bd08>] __bad_area_nosemaphore+0xb8/0x160
[518743.972018]  [<c044bdc7>] bad_area_nosemaphore+0x17/0x20
[518743.972018]  [<c09d017d>] __do_page_fault+0x33d/0x4a0
[518743.972018]  [<c0490f05>] ? dequeue_task_fair+0x65/0x590
[518743.972018]  [<c048c0b6>] ? __dequeue_entity+0x26/0x50
[518743.972018]  [<c0410b0e>] ? __switch_to+0xee/0x3b0
[518743.972018]  [<c09d02e0>] ? __do_page_fault+0x4a0/0x4a0
[518743.972018]  [<c09d02ed>] do_page_fault+0xd/0x10
[518743.972018]  [<c09cd6bf>] error_code+0x67/0x6c
[518743.972018]  [<f861be11>] ? ieee80211_scan_work+0x321/0x3e0 [mac80211]
[518743.972018]  [<c0471d1a>] process_one_work+0x11a/0x400
[518743.972018]  [<c0487f9d>] ? try_to_wake_up+0x1bd/0x220
[518743.972018]  [<c0472f5f>] worker_thread+0xff/0x3c0
[518743.972018]  [<c0477ff4>] kthread+0xa4/0xb0
[518743.972018]  [<c0472e60>] ? manage_workers+0x2a0/0x2a0
[518743.972018]  [<c0480000>] ? SyS_setgroups+0xb0/0xf0
[518743.972018]  [<c09d35b7>] ret_from_kernel_thread+0x1b/0x28
[518743.972018]  [<c0477f50>] ? kthread_freezable_should_stop+0x50/0x50
[518743.972018] Code: 8d 74 26 00 64 a1 ac 7f d7 c0 8b 80 9c 02 00 00 5d 8b 40 e4 c1 e8 02 83 e0 01 c3 90 55 89 e5 3e 8d e
[518743.972018] EIP: [<c0477a3f>] kthread_data+0xf/0x20 SS:ESP 0068:effd9c88
[518743.972018] CR2: 00000000ffffffec
[518743.972018] ---[ end trace 7b4bcf9767616f78 ]---
[518743.972018] Fixing recursive fault but reboot is needed!


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

