Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59227 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbaCNUa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 16:30:27 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so2630648wgh.10
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 13:30:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1393852248.10039.5.camel@jlt4.sipsolutions.net>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
	<1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
	<1393852248.10039.5.camel@jlt4.sipsolutions.net>
Date: Fri, 14 Mar 2014 13:30:25 -0700
Message-ID: <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com> (sfid-20140314_213031_869740_47A58F56)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
From: Colleen T <colleen@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, linux@eikelenboom.it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

This commit -- 5a970df8990d173e7e4092952f2e3da1de69b27d -- is causing
a regression on mac80211-next/master in our mesh test framework on
qemu.  We are using cfg80211 as a module.

In /etc/default/crda, I have:
REGDOMAIN=US

I can trigger the oops by loading mac80211_hwsim with three or more radios:

> modprobe mac80211_hwsim radios=3

It seems to be caused by updating the pending regulatory_requests
while new regulatory requests are still being added.

Here's the dmesg output which shows warnings, followed by an oops:
[   22.360102] ------------[ cut here ]------------
[   22.361001] WARNING: CPU: 0 PID: 468 at net/wireless/reg.c:1832
reg_process_hint+0x19a/0x3c0 [cfg80211]()
[   22.362758] invalid initiator -30720
[   22.363440] Modules linked in: mac80211_hwsim mac80211 cfg80211
[   22.364689] CPU: 0 PID: 468 Comm: kworker/0:1 Not tainted
3.14.0-rc2-5a970df+ #86
[   22.366114] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   22.367420] Workqueue: events reg_todo [cfg80211]
[   22.368465]  0000000000000009 ffff880007367c88 ffffffff8183ffeb
ffff880007367cd0
[   22.370092]  ffff880007367cc0 ffffffff8104cfbd ffff88000605f800
0000000000000000
[   22.371534]  ffff880007c16e00 0000000000000000 0000000000000000
ffff880007367d20
[   22.372994] Call Trace:
[   22.373487]  [<ffffffff8183ffeb>] dump_stack+0x4d/0x66
[   22.374454]  [<ffffffff8104cfbd>] warn_slowpath_common+0x7d/0xa0
[   22.375586]  [<ffffffff8104d02c>] warn_slowpath_fmt+0x4c/0x50
[   22.376669]  [<ffffffffa0001401>] ?
cfg80211_rdev_by_wiphy_idx+0x11/0x80 [cfg80211]
[   22.378009]  [<ffffffffa00077ba>] reg_process_hint+0x19a/0x3c0 [cfg80211]
[   22.378976]  [<ffffffffa0007b87>] reg_todo+0x1a7/0x1c0 [cfg80211]
[   22.379647]  [<ffffffff8106f52c>] process_one_work+0x1fc/0x670
[   22.380304]  [<ffffffff8106f4c1>] ? process_one_work+0x191/0x670
[   22.380958]  [<ffffffff8106fac1>] worker_thread+0x121/0x3a0
[   22.381675]  [<ffffffff8106f9a0>] ? process_one_work+0x670/0x670
[   22.382574]  [<ffffffff8107767d>] kthread+0xed/0x110
[   22.383140]  [<ffffffff81077590>] ? insert_kthread_work+0x70/0x70
[   22.384188]  [<ffffffff8185392c>] ret_from_fork+0x7c/0xb0
[   22.385209]  [<ffffffff81077590>] ? insert_kthread_work+0x70/0x70
[   22.386325] ---[ end trace a50e766039e79b68 ]---
[   22.387245] ------------[ cut here ]------------
[   22.388216] WARNING: CPU: 0 PID: 468 at net/wireless/reg.c:1832
reg_process_hint+0x19a/0x3c0 [cfg80211]()
[   22.390026] invalid initiator -559087616
[   22.390801] Modules linked in: mac80211_hwsim mac80211 cfg80211
[   22.391993] CPU: 0 PID: 468 Comm: kworker/0:1 Tainted: G        W
 3.14.0-rc2-5a970df+ #86
[   22.393512] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   22.394584] Workqueue: events reg_todo [cfg80211]
[   22.395482]  0000000000000009 ffff880007367c88 ffffffff8183ffeb
ffff880007367cd0
[   22.396915]  ffff880007367cc0 ffffffff8104cfbd ffff88000605f800
0000000000000000
[   22.398364]  ffff880007c16e00 0000000000000000 0000000000000000
ffff880007367d20
[   22.399808] Call Trace:
[   22.400312]  [<ffffffff8183ffeb>] dump_stack+0x4d/0x66
[   22.401291]  [<ffffffff8104cfbd>] warn_slowpath_common+0x7d/0xa0
[   22.402426]  [<ffffffff8104d02c>] warn_slowpath_fmt+0x4c/0x50
[   22.403515]  [<ffffffffa0001401>] ?
cfg80211_rdev_by_wiphy_idx+0x11/0x80 [cfg80211]
[   22.404924]  [<ffffffffa00077ba>] reg_process_hint+0x19a/0x3c0 [cfg80211]
[   22.406177]  [<ffffffffa0007b87>] reg_todo+0x1a7/0x1c0 [cfg80211]
[   22.407321]  [<ffffffff8106f52c>] process_one_work+0x1fc/0x670
[   22.408382]  [<ffffffff8106f4c1>] ? process_one_work+0x191/0x670
[   22.409249]  [<ffffffff8106fac1>] worker_thread+0x121/0x3a0
[   22.409886]  [<ffffffff8106f9a0>] ? process_one_work+0x670/0x670
[   22.410551]  [<ffffffff8107767d>] kthread+0xed/0x110
[   22.411107]  [<ffffffff81077590>] ? insert_kthread_work+0x70/0x70
[   22.411809]  [<ffffffff8185392c>] ret_from_fork+0x7c/0xb0
[   22.412655]  [<ffffffff81077590>] ? insert_kthread_work+0x70/0x70
[   22.413618] ---[ end trace a50e766039e79b69 ]---
[   25.503446] cfg80211: Calling CRDA to update world regulatory domain
[   25.507041] kernel tried to execute NX-protected page - exploit
attempt? (uid: 0)
[   25.508020] BUG: unable to handle kernel paging request at ffff8800062bfcf0
[   25.508020] IP: [<ffff8800062bfcf0>] 0xffff8800062bfcf0
[   25.508020] PGD 295c067 PUD 295d067 PMD 80000000062001e3
[   25.508020] Oops: 0011 [#1] SMP
[   25.508020] Modules linked in: mac80211_hwsim mac80211 cfg80211
[   25.508020] CPU: 0 PID: 2648 Comm: modprobe Tainted: G        W
3.14.0-rc2-5a970df+ #86
[   25.508020] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   25.508020] task: ffff88000724c640 ti: ffff8800037c4000 task.ti:
ffff8800037c4000
[   25.508020] RIP: 0010:[<ffff8800062bfcf0>]  [<ffff8800062bfcf0>]
0xffff8800062bfcf0
[   25.508020] RSP: 0000:ffff880007c03ea8  EFLAGS: 00010292
[   25.508020] RAX: ffff88000724c640 RBX: ffff88000605f800 RCX: 0000000000000000
[   25.508020] RDX: 0000000000000020 RSI: 0000000000000000 RDI: ffff88000605f800
[   25.508020] RBP: ffff880007c03f18 R08: 0000000000000001 R09: 0000000000000000
[   25.508020] R10: ffff88000724c640 R11: 0000000000000000 R12: 0000000000000001
[   25.508020] R13: 000000000000000a R14: ffff8800062bfcf0 R15: 0000000000000000
[   25.508020] FS:  00007f92aeb0e700(0000) GS:ffff880007c00000(0000)
knlGS:0000000000000000
[   25.508020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.508020] CR2: ffff8800062bfcf0 CR3: 000000000636d000 CR4: 00000000000006f0
[   25.508020] Stack:
[   25.508020]  ffffffff810baa12 ffffffff810ba9cf ffff88000605f800
ffff880007c0d660
[   25.508020]  ffff88000724c640 ffff8800037c5fd8 ffff880007c0d688
0000000000000001
[   25.508020]  ffffffff81e3be40 0000000000000009 ffffffff81e040c8
0000000000000009
[   25.508020] Call Trace:
[   25.508020]  <IRQ>
[   25.508020]  [<ffffffff810baa12>] ? rcu_process_callbacks+0x272/0x7e0
[   25.508020]  [<ffffffff810ba9cf>] ? rcu_process_callbacks+0x22f/0x7e0
[   25.508020]  [<ffffffff8105359e>] __do_softirq+0x12e/0x440
[   25.508020]  [<ffffffff81053b65>] irq_exit+0xa5/0xb0
[   25.508020]  [<ffffffff818559d5>] smp_apic_timer_interrupt+0x45/0x60
[   25.508020]  [<ffffffff8185462f>] apic_timer_interrupt+0x6f/0x80
[   25.508020]  <EOI>
[   25.508020]  [<ffffffff81158a68>] ? handle_mm_fault+0x198/0x9b0
[   25.508020]  [<ffffffff8184e26b>] ? __do_page_fault+0x2ab/0x560
[   25.508020]  [<ffffffff8184e265>] ? __do_page_fault+0x2a5/0x560
[   25.508020]  [<ffffffff810a1a10>] ? lock_release_non_nested+0xa0/0x300
[   25.508020]  [<ffffffff8115edcf>] ? do_brk+0x2bf/0x350
[   25.508020]  [<ffffffff8184a889>] ? retint_swapgs+0xe/0x13
[   25.508020]  [<ffffffff813328ea>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   25.508020]  [<ffffffff8184e52e>] do_page_fault+0xe/0x10
[   25.508020]  [<ffffffff8184aad2>] page_fault+0x22/0x30
[   25.508020] Code: 00 00 00 00 00 00 00 00 00 00 00 17 e1 c7 81 ff
ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f0 fc 2b 06
00 88 ff ff <60> dc b9 06 00 88 ff ff 00 00 00 00 00 00 00 00 00 00 00
00 ad
[   25.508020] RIP  [<ffff8800062bfcf0>] 0xffff8800062bfcf0
[   25.508020] RIP  [<ffff8800062bfcf0>] 0xffff8800062bfcf0
[   25.508020]  RSP <ffff880007c03ea8>
[   25.508020] CR2: ffff8800062bfcf0
[   25.508020] ---[ end trace a50e766039e79b6a ]---

After that, qemu locks hard.  Seems like there might be a free on an
invalid pointer.  The crash doesn't occur with this commit reverted.

Any advice?

Thanks,
Colleen

On Mon, Mar 3, 2014 at 5:10 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-02-25 at 17:09 -0800, Luis R. Rodriguez wrote:
>> This allows processing of the last regulatory request when
>> we determine its still pending. Without this if a regulatory
>> request failed to get processed by userspace we wouldn't
>> be able to re-process it later. An example situation that can
>> lead to an unprocessed last_request is enabling cfg80211 to
>> be built-in to the kernel, not enabling CFG80211_INTERNAL_REGDB
>> and the CRDA binary not being available at the time the udev
>> rule that kicks of CRDA triggers.
>>
>> In such a situation we want to let some cfg80211 triggers
>> eventually kick CRDA for us again. Without this if the first
>> cycle attempt to kick off CRDA failed we'd be stuck without
>> the ability to change process any further regulatory domains.
>>
>> cfg80211 will trigger re-processing of the regulatory queue
>> whenever schedule_work(&reg_work) is called, currently this
>> happens when:
>>
>>   * suspend / resume
>>   * disconnect
>>   * a beacon hint gets triggered (non DFS 5 GHz AP found)
>>   * a regulatory request gets added to the queue
>>
>> We don't have any specific opportunistic late boot triggers
>> to address a late mount of where CRDA resides though, adding
>> that should be done separately through another patch.
>> Without an opportunistic fix then this fix relies at least
>> one of the triggeres above to happen.
>
> Ok, applied. (with that typo there fixed)
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
