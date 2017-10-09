Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:44292 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932096AbdJIRuU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 13:50:20 -0400
Received: by mail-oi0-f48.google.com with SMTP id v132so21716620oie.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Oct 2017 10:50:20 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 9 Oct 2017 19:50:19 +0200
Message-ID: <CAAeHK+xAUzhshnua978hs7VcFESeerAH-kfLtniWkv9Sr7SCOA@mail.gmail.com> (sfid-20171009_195342_401120_2FAC9D75)
Subject: usb/nfs/pn533: use-after-free in pn533_send_complete
To: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes.berg@intel.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrey Rusalin <arusalin@dev.rtsoft.ru>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f (4.14-rc4).

usb 1-1: NFC: Can't submit reader poweron cmd response -90
pn533_usb 1-1:6.1: NFC: Couldn't poweron the reader (error -90)
pn533_usb: probe of 1-1:6.1 failed with error -90
==================================================================
BUG: KASAN: use-after-free in pn533_send_complete+0xc4/0xd0
Read of size 8 at addr ffff880069a51e28 by task swapper/1/0

CPU: 1 PID: 0 Comm: swapper/1 Not tainted
4.14.0-rc4-43418-g43a3f84d2109-dirty #391
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_load8_noabort+0x19/0x20 mm/kasan/report.c:430
 pn533_send_complete+0xc4/0xd0 drivers/nfc/pn533/usb.c:431
 __usb_hcd_giveback_urb+0x2e0/0x650 drivers/usb/core/hcd.c:1779
 usb_hcd_giveback_urb+0x337/0x420 drivers/usb/core/hcd.c:1845
 dummy_timer+0xba9/0x39f0 drivers/usb/gadget/udc/dummy_hcd.c:1965
 call_timer_fn+0x2a2/0x940 kernel/time/timer.c:1281
 expire_timers kernel/time/timer.c:1320
 __run_timers+0x87f/0xd40 kernel/time/timer.c:1620
 run_timer_softirq+0x83/0x140 kernel/time/timer.c:1646
 __do_softirq+0x2ee/0xc0f kernel/softirq.c:284
 invoke_softirq kernel/softirq.c:364
 irq_exit+0x171/0x1a0 kernel/softirq.c:405
 exiting_irq ./arch/x86/include/asm/apic.h:638
 smp_apic_timer_interrupt+0x2b9/0x8d0 arch/x86/kernel/apic/apic.c:1048
 apic_timer_interrupt+0x9d/0xb0
 </IRQ>
RIP: 0010:native_safe_halt+0x6/0x10 ./arch/x86/include/asm/irqflags.h:53
RSP: 0018:ffff88006bac7b90 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff10
RAX: dffffc0000000020 RBX: 1ffff1000d758f76 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88006baa3a64
RBP: ffff88006bac7b90 R08: ffff88006bac6c01 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 1ffff1000d758f82
R13: ffff88006bac7cd0 R14: ffffffff8881ecc8 R15: 0000000000000000
 arch_safe_halt ./arch/x86/include/asm/paravirt.h:93
 default_idle+0x127/0x690 arch/x86/kernel/process.c:341
 arch_cpu_idle+0xf/0x20 arch/x86/kernel/process.c:332
 default_idle_call+0x3b/0x60 kernel/sched/idle.c:98
 cpuidle_idle_call kernel/sched/idle.c:156
 do_idle+0x33a/0x410 kernel/sched/idle.c:246
 cpu_startup_entry+0x1d/0x20 kernel/sched/idle.c:351
 start_secondary+0x3de/0x500 arch/x86/kernel/smpboot.c:278
 secondary_startup_64+0xa5/0xa5 arch/x86/kernel/head_64.S:235

Allocated by task 41:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:489
 slab_post_alloc_hook mm/slab.h:444
 slab_alloc_node mm/slub.c:2745
 __kmalloc_node_track_caller+0x14b/0x380 mm/slub.c:4340
 alloc_dr drivers/base/devres.c:91
 devm_kmalloc+0xb4/0x200 drivers/base/devres.c:781
 devm_kzalloc ./include/linux/device.h:662
 pn533_usb_probe+0x43/0xb40 drivers/nfc/pn533/usb.c:462
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Freed by task 41:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 release_nodes+0x5a5/0xd60 drivers/base/devres.c:496
 devres_release_all+0x101/0x190 drivers/base/devres.c:517
 really_probe drivers/base/dd.c:460
 driver_probe_device+0x2d8/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26e/0x3d0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc7f/0x1db0 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x3a1/0x470 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

The buggy address belongs to the object at ffff880069a51e00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 40 bytes inside of
 96-byte region [ffff880069a51e00, ffff880069a51e60)
The buggy address belongs to the page:
page:ffffea0001a69440 count:1 mapcount:0 mapping:          (null) index:0x0
flags: 0x100000000000100(slab)
raw: 0100000000000100 0000000000000000 0000000000000000 0000000180200020
raw: ffffea0001a46ec0 0000000e00000002 ffff88006c003680 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880069a51d00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff880069a51d80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
>ffff880069a51e00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
                                  ^
 ffff880069a51e80: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff880069a51f00: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================
