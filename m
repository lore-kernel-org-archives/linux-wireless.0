Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward105o.mail.yandex.net ([37.140.190.183]:42548 "EHLO
        forward105o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030656AbeCANCu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 08:02:50 -0500
From: Kirill Tkhai <tkhai@ya.ru>
To: syzbot <syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        ktkhai <ktkhai@virtuozzo.com>
In-Reply-To: <001a113ecf342db684056655e097@google.com>
References: <001a113ecf342db684056655e097@google.com>
Subject: Re: KASAN: use-after-free Read in mac80211_hwsim_del_radio
MIME-Version: 1.0
Message-Id: <809581519908936@web46j.yandex.ru> (sfid-20180301_140317_217594_C2E2B98A)
Date: Thu, 01 Mar 2018 15:55:36 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

01.03.2018, 11:46, "syzbot" <syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com>:
> Hello,
>
> syzbot hit the following crash on upstream commit
> f3afe530d644488a074291da04a69a296ab63046 (Tue Feb 27 22:02:39 2018 +0000)
> Merge branch 'fixes-v4.16-rc4' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
>
> So far this crash happened 4 times on upstream.
> Unfortunately, I don't have any reproducer for this crash yet.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+70ce058e01259de7bb1d@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> ==================================================================
> BUG: KASAN: use-after-free in strlen+0x85/0xa0 lib/string.c:482
> Read of size 1 at addr ffff8801d6c38f40 by task kworker/0:1/23
>
> CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 4.16.0-rc3+ #332
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: hwsim_wq destroy_radio
> Call Trace:
>   __dump_stack lib/dump_stack.c:17 [inline]
>   dump_stack+0x194/0x24d lib/dump_stack.c:53
>   print_address_description+0x73/0x250 mm/kasan/report.c:256
>   kasan_report_error mm/kasan/report.c:354 [inline]
>   kasan_report+0x23b/0x360 mm/kasan/report.c:412
>   __asan_report_load1_noabort+0x14/0x20 mm/kasan/report.c:430
>   strlen+0x85/0xa0 lib/string.c:482
>   strlen include/linux/string.h:267 [inline]
>   hwsim_mcast_del_radio drivers/net/wireless/mac80211_hwsim.c:2835 [inline]
>   mac80211_hwsim_del_radio+0x168/0x3b0
> drivers/net/wireless/mac80211_hwsim.c:2854
>   destroy_radio+0x9d/0x100 drivers/net/wireless/mac80211_hwsim.c:3396
>   process_one_work+0xc47/0x1bb0 kernel/workqueue.c:2113
>   worker_thread+0x223/0x1990 kernel/workqueue.c:2247
>   kthread+0x33c/0x400 kernel/kthread.c:238
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:406
>
> Allocated by task 6226:
>   save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>   set_track mm/kasan/kasan.c:459 [inline]
>   kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:552
>   __do_kmalloc mm/slab.c:3705 [inline]
>   __kmalloc_track_caller+0x15e/0x760 mm/slab.c:3720
>   kvasprintf+0xa9/0x130 lib/kasprintf.c:25
>   kvasprintf_const+0x56/0x160 lib/kasprintf.c:49
>   kobject_set_name_vargs+0x5b/0x140 lib/kobject.c:263
>   dev_set_name+0xb4/0xf0 drivers/base/core.c:1649
>   wiphy_new_nm+0x910/0x21d0 net/wireless/core.c:451
>   ieee80211_alloc_hw_nm+0x4b4/0x2180 net/mac80211/main.c:531
>   mac80211_hwsim_new_radio+0x227/0x2cd0
> drivers/net/wireless/mac80211_hwsim.c:2537
>   hwsim_new_radio_nl+0x67a/0x8c0 drivers/net/wireless/mac80211_hwsim.c:3213
>   genl_family_rcv_msg+0x7b7/0xfb0 net/netlink/genetlink.c:599
>   genl_rcv_msg+0xb2/0x140 net/netlink/genetlink.c:624
>   netlink_rcv_skb+0x14b/0x380 net/netlink/af_netlink.c:2444
>   genl_rcv+0x28/0x40 net/netlink/genetlink.c:635
>   netlink_unicast_kernel net/netlink/af_netlink.c:1308 [inline]
>   netlink_unicast+0x4c4/0x6b0 net/netlink/af_netlink.c:1334
>   netlink_sendmsg+0xa4a/0xe60 net/netlink/af_netlink.c:1897
>   sock_sendmsg_nosec net/socket.c:630 [inline]
>   sock_sendmsg+0xca/0x110 net/socket.c:640
>   ___sys_sendmsg+0x767/0x8b0 net/socket.c:2046
>   __sys_sendmsg+0xe5/0x210 net/socket.c:2080
>   SYSC_sendmsg net/socket.c:2091 [inline]
>   SyS_sendmsg+0x2d/0x50 net/socket.c:2087
>   do_syscall_64+0x281/0x940 arch/x86/entry/common.c:287
>   entry_SYSCALL_64_after_hwframe+0x42/0xb7
>
> Freed by task 5:
>   save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>   set_track mm/kasan/kasan.c:459 [inline]
>   __kasan_slab_free+0x11a/0x170 mm/kasan/kasan.c:520
>   kasan_slab_free+0xe/0x10 mm/kasan/kasan.c:527
>   __cache_free mm/slab.c:3485 [inline]
>   kfree+0xd9/0x260 mm/slab.c:3800
>   kfree_const+0x31/0x40 mm/util.c:38
>   kobject_rename+0x1b3/0x2a0 lib/kobject.c:501
>   device_rename+0x147/0x1f0 drivers/base/core.c:2648
>   cfg80211_switch_netns+0x1fa/0x470 net/wireless/core.c:192
>   cfg80211_pernet_exit+0x93/0xc0 net/wireless/core.c:1336
>   ops_exit_list.isra.6+0xae/0x150 net/core/net_namespace.c:142
>   cleanup_net+0x6a1/0xcb0 net/core/net_namespace.c:517
>   process_one_work+0xc47/0x1bb0 kernel/workqueue.c:2113
>   worker_thread+0x223/0x1990 kernel/workqueue.c:2247
>   kthread+0x33c/0x400 kernel/kthread.c:238
>   ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:406
>
> The buggy address belongs to the object at ffff8801d6c38f40
>   which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 0 bytes inside of
>   32-byte region [ffff8801d6c38f40, ffff8801d6c38f60)
> The buggy address belongs to the page:
> page:ffffea00075b0e00 count:1 mapcount:0 mapping:ffff8801d6c38000
> index:0xffff8801d6c38fc1
> flags: 0x2fffc0000000100(slab)
> raw: 02fffc0000000100 ffff8801d6c38000 ffff8801d6c38fc1 000000010000003f
> raw: ffffea00075b0c20 ffffea00075b0f20 ffff8801dac001c0 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8801d6c38e00: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>   ffff8801d6c38e80: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
>>  ffff8801d6c38f00: 07 fc fc fc fc fc fc fc fb fb fb fb fc fc fc fc
>
>                                             ^
>   ffff8801d6c38f80: fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8801d6c39000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.

JFI: As a coincidence, I'm converting pernet_operation and hwsim_net_ops are the last
in drivers directory which is not converted. There is also an issue with hwsim_netgroup,
and I sent a fix today:

https://patchwork.ozlabs.org/patch/879748/

Thanks,
Kirill
