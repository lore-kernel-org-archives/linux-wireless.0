Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34428 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdKUNwG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 08:52:06 -0500
Received: by mail-oi0-f46.google.com with SMTP id a75so8564147oib.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2017 05:52:05 -0800 (PST)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 21 Nov 2017 14:52:04 +0100
Message-ID: <CAAeHK+zcqAGo7T2bBJkLOk04Su5SY7cDrVH5AP9xtRpvs-Sitw@mail.gmail.com> (sfid-20171121_145233_056501_669D57A4)
Subject: usb/net/zd1211rw: possible deadlock in zd_chip_disable_rxtx
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit e1d1ea549b57790a3d8cf6300e6ef86118d692a3 (4.15-rc1).

usb 1-1: New USB device found, idVendor=0baf, idProduct=0121
usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 1-1: config 0 descriptor??
usb 1-1: reset full-speed USB device number 2 using dummy_hcd
ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
zd1211rw 1-1:0.0: phy2
zd1211rw 1-1:0.0: error ioread32(CR_REG1): -11
usb 1-1: reset full-speed USB device number 2 using dummy_hcd
ieee80211 phy3: Selected rate control algorithm 'minstrel_ht'
zd1211rw 1-1:0.8: phy3
zd1211rw 1-1:0.8 rename38: renamed from wlan3
zd1211rw 1-1:0.0: error ioread32(CR_REG1): -11
============================================
WARNING: possible recursive locking detected
4.14.0-57501-g9284d204d604 #119 Not tainted
--------------------------------------------
kworker/1:1/43 is trying to acquire lock:
 (&chip->mutex){+.+.}, at: [<ffffffff83788ac5>] zd_chip_disable_rxtx+0x25/0x50

but task is already holding lock:
 (&chip->mutex){+.+.}, at: [<ffffffff83797a15>] pre_reset+0x1e5/0x250

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chip->mutex);
  lock(&chip->mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by kworker/1:1/43:
 #0:  ((wq_completion)"usb_hub_wq"){+.+.}, at: [<ffffffff8118157d>]
process_one_work+0x71d/0x15f0
 #1:  ((work_completion)(&hub->events)){+.+.}, at:
[<ffffffff811815b0>] process_one_work+0x750/0x15f0
 #2:  (&dev->mutex){....}, at: [<ffffffff8390ff27>] hub_event_impl+0xa7/0x3440
 #3:  (&dev->mutex){....}, at: [<ffffffff82874e46>] __device_attach+0x36/0x2a0
 #4:  (&dev->mutex){....}, at: [<ffffffff82874e46>] __device_attach+0x36/0x2a0
 #5:  (&chip->mutex){+.+.}, at: [<ffffffff83797a15>] pre_reset+0x1e5/0x250

stack backtrace:
CPU: 1 PID: 43 Comm: kworker/1:1 Not tainted 4.14.0-57501-g9284d204d604 #119
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:17
 dump_stack+0xe1/0x157 lib/dump_stack.c:53
 check_deadlock kernel/locking/lockdep.c:1809
 validate_chain kernel/locking/lockdep.c:2457
 __lock_acquire.cold.66+0x132/0x3bc kernel/locking/lockdep.c:3500
 lock_acquire+0x113/0x330 kernel/locking/lockdep.c:4004
 __mutex_lock_common kernel/locking/mutex.c:756
 __mutex_lock+0x78/0xf70 kernel/locking/mutex.c:893
 mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:908
 zd_chip_disable_rxtx+0x25/0x50
drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1478
 zd_op_stop+0x4e/0xe0 drivers/net/wireless/zydas/zd1211rw/zd_mac.c:356
 zd_usb_stop drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1490
 pre_reset+0x195/0x250 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1513
 usb_reset_device+0x389/0x940 drivers/usb/core/hub.c:5776
 probe+0x117/0x910 drivers/net/wireless/zydas/zd1211rw/zd_usb.c:1382
 usb_probe_interface+0x324/0x940 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:424
 driver_probe_device+0x564/0x820 drivers/base/dd.c:566
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:662
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1ab/0x2a0 drivers/base/dd.c:719
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:766
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_set_configuration+0xd55/0x17a0 drivers/usb/core/message.c:1967
 generic_probe+0xbb/0x120 drivers/usb/core/generic.c:174
 usb_probe_device+0xab/0x100 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:424
 driver_probe_device+0x564/0x820 drivers/base/dd.c:566
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:662
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1ab/0x2a0 drivers/base/dd.c:719
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:766
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_new_device+0x7fa/0x1090 drivers/usb/core/hub.c:2538
 hub_port_connect drivers/usb/core/hub.c:5000
 hub_port_connect_change drivers/usb/core/hub.c:5106
 port_event drivers/usb/core/hub.c:5212
 hub_event_impl+0x17bc/0x3440 drivers/usb/core/hub.c:5324
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5222
 process_one_work+0x944/0x15f0 kernel/workqueue.c:2112
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2246
 kthread+0x367/0x420 kernel/kthread.c:238
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:437
