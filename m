Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51533 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab1KHV7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 16:59:05 -0500
Received: by iage36 with SMTP id e36so1031164iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 13:59:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320756755.4304.29.camel@jlt3.sipsolutions.net>
References: <1320756755.4304.29.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Nov 2011 13:58:44 -0800
Message-ID: <CAB=NE6X820RGTbaqm2_YBV+Um_cz7OjPFDv46pVCLKjEY81-Mw@mail.gmail.com> (sfid-20111108_225910_821844_35794633)
Subject: Re: regulatory crash
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 4:52 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> After random poking with hwsim:
>
> [  640.357147] mac80211_hwsim: unregister radios
> [  640.357151] mac80211_hwsim: closing netlink
> [  640.871735] BUG: unable to handle kernel paging request at ffff88001a06b5ab
> [  640.879198] IP: [<ffffffffa030df9a>] reg_device_uevent+0x1a/0x50 [cfg80211]
> [  640.880507] PGD 1836063 PUD 183a063 PMD 1ffcb067 PTE 1a06b160
> [  640.880507] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  640.880507] CPU 0
> [  640.880507] Modules linked in: cfg80211(-) [last unloaded: mac80211]
> [  640.880507]
> [  640.880507] Pid: 2279, comm: rmmod Tainted: G        W   3.1.0-wl+ #663 Bochs Bochs
> [  640.880507] RIP: 0010:[<ffffffffa030df9a>]  [<ffffffffa030df9a>] reg_device_uevent+0x1a/0x50 [cfg80211]
> [  640.880507] RSP: 0000:ffff88001c5f9d58  EFLAGS: 00010286
> [  640.880507] RAX: 0000000000000000 RBX: ffff88001d2eda88 RCX: ffff88001c7468fc
> [  640.880507] RDX: ffff88001a06b5a0 RSI: ffff88001c7467b0 RDI: ffff88001c7467b0
> [  640.880507] RBP: ffff88001c5f9d58 R08: 000000000000ffff R09: 000000000000ffff
> [  640.880507] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88001c7467b0
> [  640.880507] R13: ffff88001d2eda78 R14: ffffffff8164a840 R15: 0000000000000001
> [  640.880507] FS:  00007f8a91d8a6e0(0000) GS:ffff88001fc00000(0000) knlGS:0000000000000000
> [  640.880507] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  640.880507] CR2: ffff88001a06b5ab CR3: 000000001c62e000 CR4: 00000000000006f0
> [  640.880507] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  640.880507] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  640.880507] Process rmmod (pid: 2279, threadinfo ffff88001c5f8000, task ffff88000023c780)
> [  640.880507] Stack:
> [  640.880507]  ffff88001c5f9d98 ffffffff812ff7e5 ffffffff8176ab3d ffff88001c7468c2
> [  640.880507]  000000000000ffff ffff88001d2eda88 ffff88001c7467b0 ffff880000114820
> [  640.880507]  ffff88001c5f9e38 ffffffff81241dc7 ffff88001c5f9db8 ffffffff81040189
> [  640.880507] Call Trace:
> [  640.880507]  [<ffffffff812ff7e5>] dev_uevent+0xc5/0x170
> [  640.880507]  [<ffffffff81241dc7>] kobject_uevent_env+0x1f7/0x490
> [  640.880507]  [<ffffffff81040189>] ? sub_preempt_count+0x29/0x60
> [  640.880507]  [<ffffffff814cab1a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
> [  640.880507]  [<ffffffff81305307>] ? devres_release_all+0x27/0x60
> [  640.880507]  [<ffffffff8124206b>] kobject_uevent+0xb/0x10
> [  640.880507]  [<ffffffff812fee27>] device_del+0x157/0x1b0
> [  640.880507]  [<ffffffff8130377d>] platform_device_del+0x1d/0x90
> [  640.880507]  [<ffffffff81303b76>] platform_device_unregister+0x16/0x30
> [  640.880507]  [<ffffffffa030fffd>] regulatory_exit+0x5d/0x180 [cfg80211]
> [  640.880507]  [<ffffffffa032bec3>] cfg80211_exit+0x2b/0x45 [cfg80211]
> [  640.880507]  [<ffffffff8109a84c>] sys_delete_module+0x16c/0x220
> [  640.880507]  [<ffffffff8108a23e>] ? trace_hardirqs_on_caller+0x7e/0x120
> [  640.880507]  [<ffffffff814cba02>] system_call_fastpath+0x16/0x1b
> [  640.880507] Code: 5b 5d c3 66 0f 1f 44 00 00 bf 10 00 00 00 eb d1 90 55 48 89 e5 66 66 66 66 90 48 8b 15 b8 3b 02 00 31 c0 48 85 d2 48 89 f7 74 06
> [  640.880507]  7a 0b 00 74 08 5d c3 66 0f 1f 44 00 00 0f be 4a 09 48 c7 c6
> [  640.880507] RIP  [<ffffffffa030df9a>] reg_device_uevent+0x1a/0x50 [cfg80211]
> [  640.880507]  RSP <ffff88001c5f9d58>
> [  640.880507] CR2: ffff88001a06b5ab
> [  640.880507] ---[ end trace 147c5099a411e8c0 ]---
> [  640.880507] BUG: sleeping function called from invalid context at /home/johannes/sys/wireless-testing/kernel/rwsem.c:21
> [  640.880507] in_atomic(): 0, irqs_disabled(): 1, pid: 2279, name: rmmod
> [  640.880507] INFO: lockdep is turned off.
> [  640.880507] irq event stamp: 31652
> [  640.880507] hardirqs last  enabled at (31651): [<ffffffff814bd1b0>] __slab_alloc.isra.58.constprop.63+0x3b8/0x3db
> [  640.880507] hardirqs last disabled at (31652): [<ffffffff814cb536>] error_sti+0x5/0x6
> [  640.880507] softirqs last  enabled at (31204): [<ffffffff81052ab7>] __do_softirq+0x137/0x3c0
> [  640.880507] softirqs last disabled at (31185): [<ffffffff814cd07c>] call_softirq+0x1c/0x30
> [  640.880507] Pid: 2279, comm: rmmod Tainted: G      D W   3.1.0-wl+ #663
> [  640.880507] Call Trace:
> [  640.880507]  [<ffffffff81089740>] ? print_irqtrace_events+0xd0/0xe0
> [  640.880507]  [<ffffffff8103b729>] __might_sleep.part.132+0xb9/0xd0
> [  640.880507]  [<ffffffff8103b791>] __might_sleep+0x51/0x70
> [  640.880507]  [<ffffffff814c9246>] down_read+0x26/0x9c
> [  640.880507]  [<ffffffff810a39cb>] acct_collect+0x4b/0x1b0
> [  640.880507]  [<ffffffff8104f1eb>] do_exit+0x30b/0x470
> [  640.880507]  [<ffffffff81005b19>] oops_end+0x89/0xc0
> [  640.880507]  [<ffffffff814b7864>] no_context+0x146/0x153
> [  640.880507]  [<ffffffff814b7a42>] __bad_area_nosemaphore+0x1d1/0x1f0
> [  640.880507]  [<ffffffff814caaa5>] ? _raw_spin_unlock+0x35/0x60
> [  640.880507]  [<ffffffff814b7a74>] bad_area_nosemaphore+0x13/0x15
> [  640.880507]  [<ffffffff8102a7ed>] do_page_fault+0x40d/0x4e0
> [  640.880507]  [<ffffffff814bd1b0>] ? __slab_alloc.isra.58.constprop.63+0x3b8/0x3db
> [  640.880507]  [<ffffffff8108a23e>] ? trace_hardirqs_on_caller+0x7e/0x120
> [  640.880507]  [<ffffffff81249cde>] ? string.isra.5+0x3e/0xd0
> [  640.880507]  [<ffffffff8124c91d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [  640.880507]  [<ffffffff814cb2f5>] page_fault+0x25/0x30
> [  640.880507]  [<ffffffffa030df9a>] ? reg_device_uevent+0x1a/0x50 [cfg80211]
> [  640.880507]  [<ffffffff81303560>] ? platform_uevent+0x30/0x40
> [  640.880507]  [<ffffffff812ff7e5>] dev_uevent+0xc5/0x170
> [  640.880507]  [<ffffffff81241dc7>] kobject_uevent_env+0x1f7/0x490
> [  640.880507]  [<ffffffff81040189>] ? sub_preempt_count+0x29/0x60
> [  640.880507]  [<ffffffff814cab1a>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
> [  640.880507]  [<ffffffff81305307>] ? devres_release_all+0x27/0x60
> [  640.880507]  [<ffffffff8124206b>] kobject_uevent+0xb/0x10
> [  640.880507]  [<ffffffff812fee27>] device_del+0x157/0x1b0
> [  640.880507]  [<ffffffff8130377d>] platform_device_del+0x1d/0x90
> [  640.880507]  [<ffffffff81303b76>] platform_device_unregister+0x16/0x30
> [  640.880507]  [<ffffffffa030fffd>] regulatory_exit+0x5d/0x180 [cfg80211]
> [  640.880507]  [<ffffffffa032bec3>] cfg80211_exit+0x2b/0x45 [cfg80211]
> [  640.880507]  [<ffffffff8109a84c>] sys_delete_module+0x16c/0x220
> [  640.880507]  [<ffffffff8108a23e>] ? trace_hardirqs_on_caller+0x7e/0x120
> [  640.880507]  [<ffffffff814cba02>] system_call_fastpath+0x16/0x1b
>


It seems we cannot tell udev we are committing suicide at __exit() for
whatever reason. Not sure why. I find this odd unless this is
generally true. Can you reproduce easily? Can you try this.

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2520a1b..9f1037e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2259,6 +2259,8 @@ void /* __init_or_exit */ regulatory_exit(void)
        mutex_lock(&cfg80211_mutex);
        mutex_lock(&reg_mutex);

+       dev_set_uevent_suppress(&reg_pdev->dev, true);
+
        reset_regdomains();

        kfree(last_request);

  Luis
