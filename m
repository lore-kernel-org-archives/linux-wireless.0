Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C1723B63E
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 03:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785642404; cv=none; b=PNt3nQgFEfscZd4NmjcCYm0Y3HRvyCqU2ij/AvE1qRnmzr5z6EyKkKgGcDMWhYSYcLshgUSg1wVlvj5Y44NilgTsk7Y+muMcYBvDSoWxFWpfKavmTofP/W0vh5E5J8B5Uu1E41GZnfjP85MpGkZ4ZI0xXttmLKj3+wiowqC1ILY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785642404; c=relaxed/simple;
	bh=sezgLEyBC9Es3UETpH3+MuabYW/HD/PBrBBUJMwZj0s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LVZYQdOCuPyuJmZrfkTEO/H8mDPjwhfciUxcJbsMqsZAOJcZX1njBluWf2l4yrfFkNmvBZHnLZLvVNoPwVPBjaLlr74t1AZXRR52mwAleTn0edrwkM0TZH68CEf0FvjdO6UfvNJapuM8eNIfpZthTtDIf/CvApjq2fTSu9BeEhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-49aa4525b82so3184218b6e.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2026 20:46:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785642399; x=1786247199;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kL/Ml9iryEkMC+wj+LqPNtEaj4DBg6U2aownFArWlo4=;
        b=jXCN+FIKcp9tiFccIvz6f8lyvH0cvqJQAXos9LaPS+OMRumnd17i5bFhwfLuB4v3wp
         hiyS6eNTnkiMZ5G1+tM/1PJBH4lRmrGxfm8Jai4gbbB7Fxn7J+wPhRzKMDP0SygloMP+
         FOTp19NCy3MeQAuO6b1d5lGfgIJOGI/x8c+WCsCApzno7MLkk1pqGDSp/YNlKiLfa/I/
         jtM3MKbEREf3Xnjblr8uOSe2djyE2EJJLsHapTTCEo+WXMHL3N4mroz+40ucx4TNGVrf
         GVz1+hb9odtQeVEbAGdCX9as6V9cFPDR4/zASd0OL0lRJldvutflJOpSPWR+FTMxfKD6
         BJYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqcx0oPs/aivv0es5VBrme+OEpuscYq7PheG8UppzZUZWHBeG6xH6l4siqfhn+dSIig/+eYz6y9X/R7g0D0YQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT3WcWQuTrlxgEYwRu3cACHYz4MTaL/oJ3iDj8m5Mqs5gGtQkB
	aPO7cnK2v+UpxQW1azm5tysysvl8CB069VC3IHlQ/t8Vrs23DXBx7hrIDFMz6aqhIRI1cpMqyXB
	sWseheJA3m9/xGl8RLZCjCO9Mq74wVfbgdiQ6lfSthx1djxe+xEQVp7snh5c=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:150c:b0:4ab:32ea:95f6 with SMTP id
 5614622812f47-4af5e1b215amr9515583b6e.13.1785642399119; Sat, 01 Aug 2026
 20:46:39 -0700 (PDT)
Date: Sat, 01 Aug 2026 20:46:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6ebd9f.2d659fcc.1d46f5.01cd.GAE@google.com>
Subject: [syzbot] [libertas?] INFO: task hung in lbs_remove_card (2)
From: syzbot <syzbot+a88c826d548437310a57@syzkaller.appspotmail.com>
To: libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5d5fd841c346 Merge 7.2-rc5 into usb-next
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=13539499580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec4d592e55f7960
dashboard link: https://syzkaller.appspot.com/bug?extid=a88c826d548437310a57
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2ed536ae4daf/disk-5d5fd841.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ab40098ccbf1/vmlinux-5d5fd841.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66d5c395f47c/bzImage-5d5fd841.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a88c826d548437310a57@syzkaller.appspotmail.com

INFO: task kworker/1:3:5238 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:3     state:D stack:20968 pid:5238  tgid:5238  ppid:2      task_flags:0x4288060 flags:0x00080000
Workqueue: events request_firmware_work_func
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x1325/0x47d0 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0xdd/0x2c0 kernel/sched/core.c:7326
 lbs_wait_for_firmware_load+0x11e/0x1e0 drivers/net/wireless/marvell/libertas/firmware.c:117
 lbs_remove_card+0x84/0x390 drivers/net/wireless/marvell/libertas/main.c:913
 if_usb_disconnect+0xc5/0x270 drivers/net/wireless/marvell/libertas/if_usb.c:317
 usb_unbind_interface+0x1dd/0x9e0 drivers/usb/core/driver.c:461
 device_remove drivers/base/dd.c:618 [inline]
 device_remove+0x12a/0x180 drivers/base/dd.c:610
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x44e/0x620 drivers/base/dd.c:1372
 usb_driver_release_interface drivers/usb/core/driver.c:643 [inline]
 usb_forced_unbind_intf+0x1a4/0x240 drivers/usb/core/driver.c:1137
 usb_reset_device+0x411/0xaa0 drivers/usb/core/hub.c:6409
 if_usb_reset_device.isra.0+0x21e/0x290 drivers/net/wireless/marvell/libertas/if_usb.c:400
 if_usb_prog_firmware.cold+0x161/0x192 drivers/net/wireless/marvell/libertas/if_usb.c:918
 lbs_fw_loaded drivers/net/wireless/marvell/libertas/firmware.c:23 [inline]
 helper_firmware_cb drivers/net/wireless/marvell/libertas/firmware.c:80 [inline]
 helper_firmware_cb+0x1f7/0x2d0 drivers/net/wireless/marvell/libertas/firmware.c:64
 request_firmware_work_func+0x13f/0x440 drivers/base/firmware_loader/main.c:1164
 process_one_work+0xa23/0x1940 kernel/workqueue.c:3322
 process_scheduled_works kernel/workqueue.c:3405 [inline]
 worker_thread+0x5ef/0xe50 kernel/workqueue.c:3486
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Showing all locks held in the system:
5 locks held by kworker/0:1/11:
5 locks held by kworker/1:0/23:
 #0: ffff888106684540 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x12b1/0x1940 kernel/workqueue.c:3297
 #1: ffffc9000018fd18 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298
 #2: ffff88810b7441d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #2: ffff88810b7441d8 (&dev->mutex){....}-{4:4}, at: hub_event+0x1bd/0x4af0 drivers/usb/core/hub.c:5904
 #3: ffff8881360491d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #3: ffff8881360491d8 (&dev->mutex){....}-{4:4}, at: usb_disconnect+0x10a/0x9a0 drivers/usb/core/hub.c:2341
 #4: ffff888104e921a0 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #4: ffff888104e921a0 (&dev->mutex){....}-{4:4}, at: device_del+0xa0/0x9b0 drivers/base/core.c:3923
1 lock held by khungtaskd/29:
 #0: ffffffff896e2b40 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff896e2b40 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff896e2b40 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x3d/0x184 kernel/locking/lockdep.c:6775
8 locks held by kworker/1:1/40:
2 locks held by getty/2917:
 #0: ffff888112a280a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x24/0x80 drivers/tty/tty_ldisc.c:243
 #1: ffffc900000452e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x419/0x14e0 drivers/tty/n_tty.c:2211
3 locks held by kworker/1:3/5238:
 #0: ffff88810006b140 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x12b1/0x1940 kernel/workqueue.c:3297
 #1: ffffc90001fffd18 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298
 #2: ffff888104e921a0 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #2: ffff888104e921a0 (&dev->mutex){....}-{4:4}, at: __device_driver_lock drivers/base/dd.c:1171 [inline]
 #2: ffff888104e921a0 (&dev->mutex){....}-{4:4}, at: device_release_driver_internal+0xb2/0x620 drivers/base/dd.c:1369
3 locks held by kworker/1:4/5243:
 #0: ffff8881f57397a0 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:667 [inline]
 #0: ffff8881f57397a0 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock kernel/sched/sched.h:1653 [inline]
 #0: ffff8881f57397a0 (&rq->__lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1991 [inline]
 #0: ffff8881f57397a0 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x2dc/0x47d0 kernel/sched/core.c:7108
 #1: ffffc9000203fd18 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298
 #2: ffff8881f5728d28 (lock#5){..-.}-{3:3}, at: local_lock_acquire include/linux/local_lock_internal.h:46 [inline]
 #2: ffff8881f5728d28 (lock#5){..-.}-{3:3}, at: kcov_remote_stop+0x77/0x540 kernel/kcov.c:1040
5 locks held by kworker/0:6/5376:
 #0: ffff888106684540 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work+0x12b1/0x1940 kernel/workqueue.c:3297
 #1: ffffc90004327d18 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work+0x988/0x1940 kernel/workqueue.c:3298
 #2: ffff88810bb1c1d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #2: ffff88810bb1c1d8 (&dev->mutex){....}-{4:4}, at: hub_event+0x1bd/0x4af0 drivers/usb/core/hub.c:5904
 #3: ffff888123b8a1d8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #3: ffff888123b8a1d8 (&dev->mutex){....}-{4:4}, at: __device_attach+0x7e/0x4d0 drivers/base/dd.c:1073
 #4: ffff88813c9131a0 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1102 [inline]
 #4: ffff88813c9131a0 (&dev->mutex){....}-{4:4}, at: __device_attach+0x7e/0x4d0 drivers/base/dd.c:1073

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 29 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 nmi_cpu_backtrace.cold+0x12d/0x151 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x21c/0x2a0 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x141/0x190 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xcb1/0x1030 kernel/hung_task.c:561
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x69a/0xc80 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 9946 Comm: syz.5.678 Not tainted syzkaller #0 PREEMPT(lazy) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/16/2026
RIP: 0010:io_serial_in+0x87/0xb0 drivers/tty/serial/8250/8250_port.c:402
Code: 82 88 fe 48 8d 7d 40 44 89 e1 48 b8 00 00 00 00 00 fc ff df 48 89 fa d3 e3 48 c1 ea 03 80 3c 02 00 75 1a 66 03 5d 40 89 da ec <5b> 0f b6 c0 5d 41 5c e9 cd 85 53 04 e8 38 e8 f0 fe eb a2 e8 c1 e8
RSP: 0018:ffffc9001299f8b0 EFLAGS: 00000002
RAX: dffffc0000000000 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: ffffffff832b8160 RDI: ffffffff94249da0
RBP: ffffffff94249d60 R08: 0000000000000001 R09: 000000000000001f
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000020 R14: fffffbfff2849406 R15: dffffc0000000000
FS:  00007f0e216776c0(0000) GS:ffff888268636000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c38e08b CR3: 00000001350e0000 CR4: 00000000003506f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:128 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:150 [inline]
 wait_for_lsr+0x13a/0x210 drivers/tty/serial/8250/8250_port.c:1982
 serial8250_fifo_wait_for_lsr_thre drivers/tty/serial/8250/8250_port.c:3235 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3300 [inline]
 serial8250_console_write+0xdfd/0x1a50 drivers/tty/serial/8250/8250_port.c:3385
 console_emit_next_record kernel/printk/printk.c:3183 [inline]
 console_flush_one_record+0x790/0xe50 kernel/printk/printk.c:3269
 console_flush_all kernel/printk/printk.c:3343 [inline]
 __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
 console_unlock+0x103/0x260 kernel/printk/printk.c:3413
 vprintk_emit+0x407/0x6b0 kernel/printk/printk.c:2479
 _printk+0xcf/0x110 kernel/printk/printk.c:2504
 usb_gadget_register_driver_owner.cold+0x58/0xd0 drivers/usb/gadget/udc/core.c:1762
 raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
 raw_ioctl+0x1a85/0x2b80 drivers/usb/gadget/legacy/raw_gadget.c:1307
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x10b/0x7f0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0e22c1dc2b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007f0e21674f00 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007f0e22c1dc2b
RDX: 0000000000000000 RSI: 0000000000005501 RDI: 0000000000000006
RBP: 00007f0e21675fd0 R08: 0000000000000001 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000200000000000 R14: 0000000000000000 R15: 00000000000010d0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
