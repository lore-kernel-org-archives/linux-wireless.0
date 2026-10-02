Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403504FD7AA
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790961281; cv=none; b=HBA704lgKKdfEnjX1RyyB0a6RvASJs/fKvpBAw654qCZ+n3F0IlOY1R2282Zw+0YwElGkLKSxFCJ8EkYBujseitVtZR2Zqa0Xpan5DdzAPAKgeUMbAVGZ7UgUc+2zjN+srZTTQf5gBEb6gA5e/Il2T0y1X7e3SV0RoXkneEBPvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790961281; c=relaxed/simple;
	bh=LQviPCUkIMDgb1CvVrYpCDK4oVU1cFTpcqAWZv6kBVg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qWdHWYV13tTjcaTnHgfFUOvZJMb1gMwIvJFT/DWxbPbakA3JktXzh19LKF9ezZIROVTA+msq9jaslnNU7Ahom1wBosI3Kdqk6X8JfGVQmexgNFxF6h/2hEHh2Jwka8NJsH8sGnJjCg7QZY73r+Wkik8W9VhN1dFyF1UTCyzmZsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28deb7ee3so190279b6e.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 10:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790961273; x=1791566073;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o9Xlp9Azblr48PFkRqlcT77alqRJxb8wFI04dtg1bnE=;
        b=1Uo6o3J1NR5BXJE0EnI22dJRMjirKo66iwFSvz0xQOlDNzDCUp5jSMLUOH8aAQDzaL
         EsfVSx220iMNcSEKhfrUeDHYQLMFK/Vmzwhtcp2Hfhi7VFqBVxChBY6ggsTLptSKc60s
         jhHAiMH73XtKSbjkQrn9uukKs4DCoYOeA4Zj7B1gxZKPTnWAxFOtp9NtaQK7EU/KmpHQ
         ExdYCH8gd1dFqD/+TCXbOuKCET+TO9bgAzCi7ssvRowG3oylFbYYfvR8QgbkdGwXnWs6
         3DA1hgwiCmQJwPP5EZQHfzUWJdVMljIBkVCPwoBa17thLvShoZn65e06mbJ0F4EJ77td
         hvTQ==
X-Forwarded-Encrypted: i=1; AKwUvBx6c8i2nFtcqAdg6urEJXc31EpvlwhvU40Gb48vy8xfWQekyop7KdVtHd3dYFug6gRxDJe9cWHuhmmk1M3dSw==@vger.kernel.org
X-Gm-Message-State: AFuF++lV5V3wnwSKumdAog+2GAJ+8HvA+DfZKY+xzjXep3mXTMI6kZ5y
	5YJlKblXd3LwPyjWnkHv1pRvOQIjA6YVjyYoUBgNjRg3mc4hhhxf7rNqOj8B9+V1pFE7t4z8agm
	Y9KnCXxVRdSUei1gmN4GWxxCVSSNpspJJeJHNjM5GfIpYa9WThOn7v/wJ5YA=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:bc6:b0:490:315d:e0d5 with SMTP id
 5614622812f47-4f529d201b4mr2601825b6e.16.1790961273269; Fri, 02 Oct 2026
 10:14:33 -0700 (PDT)
Date: Fri, 02 Oct 2026 10:14:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abfe679.b50370da.302ea9.000d.GAE@google.com>
Subject: [syzbot] [wireless?] KASAN: slab-use-after-free Read in tasklet_action_common
From: syzbot <syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com>
To: jeff.johnson@oss.qualcomm.com, linux-kernel@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, peterz@infradead.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org, toke@redhat.com, 
	toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    d24e8ac715de Merge tag 'net-7.3-rc6' of git://git.kernel.o.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D14361b15580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9d4242cb1c54cdf=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3De91dc13b1b37759b3=
d9f
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-=
1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D12361b1558000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D155bc725580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4ccd4fb94f0b/disk-=
d24e8ac7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/701ac3e3f73b/vmlinux-=
d24e8ac7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/976b7d839ef2/bzI=
mage-d24e8ac7.xz

The issue was bisected to:

commit 1af8dc9ca726cf53767f9c0661171396f95c146a
Author: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Date:   Tue Sep 8 17:05:18 2026 +0000

    wifi: ath9k: Clean up device initialisation guards

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D145e5b155800=
00
final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D165e5b155800=
00
console output: https://syzkaller.appspot.com/x/log.txt?x=3D125e5b15580000

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Fixes: 1af8dc9ca726 ("wifi: ath9k: Clean up device initialisation guards")

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in tasklet_action_common+0x103/0x490 kernel=
/softirq.c:954
Read of size 8 at addr ffff888035947158 by task syz-executor/5756

CPU: 0 UID: 0 PID: 5756 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 07/24/2026
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 tasklet_action_common+0x103/0x490 kernel/softirq.c:954
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 do_softirq+0x77/0xd0 kernel/softirq.c:546
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x140 kernel/softirq.c:473
 spin_unlock_bh include/linux/spinlock.h:407 [inline]
 tun_flow_delete_by_queue drivers/net/tun.c:379 [inline]
 __tun_detach+0xccc/0x1900 drivers/net/tun.c:614
 tun_detach drivers/net/tun.c:653 [inline]
 tun_chr_close+0x10a/0x1c0 drivers/net/tun.c:3587
 __fput+0x418/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x73a/0x2360 kernel/exit.c:986
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1129
 __do_sys_exit_group kernel/exit.c:1140 [inline]
 __se_sys_exit_group kernel/exit.c:1138 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1138
 x64_sys_call+0x18c6/0x18d0 arch/x86/include/generated/asm/syscalls_64.h:23=
2
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f558db9e159
Code: Unable to access opcode bytes at 0x7f558db9e12f.
RSP: 002b:00007ffc01d96c68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f558dc35fb3 RCX: 00007f558db9e159
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000043
RBP: 00007f558dc35fc5 R08: 0000000000000000 R09: 00000000000927c0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
R13: 00000000000927c0 R14: 0000000000015771 R15: 00007ffc01d96e10
 </TASK>

Allocated by task 9:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
 _kmalloc_noprof include/linux/slab.h:991 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 ath9k_init_wmi+0x4f/0x2b0 drivers/net/wireless/ath/ath9k/wmi.c:95
 ath9k_htc_probe_device+0x1e5/0x2370 drivers/net/wireless/ath/ath9k/htc_drv=
_init.c:956
 ath9k_htc_hw_init+0x32/0x70 drivers/net/wireless/ath/ath9k/htc_hst.c:532
 ath9k_hif_usb_firmware_cb+0x214/0x4b0 drivers/net/wireless/ath/ath9k/hif_u=
sb.c:1255
 request_firmware_work_func+0xf7/0x2d0 drivers/base/firmware_loader/main.c:=
1164
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 9:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6508 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6801
 ath9k_htc_probe_device+0x11a9/0x2370 drivers/net/wireless/ath/ath9k/htc_dr=
v_init.c:978
 ath9k_htc_hw_init+0x32/0x70 drivers/net/wireless/ath/ath9k/htc_hst.c:532
 ath9k_hif_usb_firmware_cb+0x214/0x4b0 drivers/net/wireless/ath/ath9k/hif_u=
sb.c:1255
 request_firmware_work_func+0xf7/0x2d0 drivers/base/firmware_loader/main.c:=
1164
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888035947000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 344 bytes inside of
 freed 2048-byte region [ffff888035947000, ffff888035947800)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x35940
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b042000 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801b042000 dead000000000100 dead000000000122
head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 1225, tgid 1225 (kworker/0:2), ts 87487181723
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7417
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_node_track_caller_noprof+0x548/0x720 mm/slub.c:5545
 kmalloc_reserve net/core/skbuff.c:637 [inline]
 __alloc_skb+0x2c1/0x7a0 net/core/skbuff.c:715
 alloc_skb include/linux/skbuff.h:1384 [inline]
 mld_newpack+0x165/0xcb0 net/ipv6/mcast.c:1810
 add_grhead net/ipv6/mcast.c:1921 [inline]
 add_grec+0x119f/0x19d0 net/ipv6/mcast.c:2060
 mld_send_initial_cr+0x288/0x550 net/ipv6/mcast.c:2305
 mld_dad_work+0x3d/0x480 net/ipv6/mcast.c:2331
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
page last free pid 5650 tgid 5650 ts 85122206691 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 free_pages_prepare+0x9eb/0xaf0 mm/page_alloc.c:1463
 __free_contig_range_common+0x174/0x340 mm/page_alloc.c:7072
 __free_contig_range mm/page_alloc.c:7117 [inline]
 free_pages_bulk+0x48/0x120 mm/page_alloc.c:5322
 vm_area_free_pages mm/vmalloc.c:3461 [inline]
 vfree+0x231/0x490 mm/vmalloc.c:3510
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3414
 process_one_work kernel/workqueue.c:3396 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888035947000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888035947080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888035947100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888035947180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888035947200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisectio=
n

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
