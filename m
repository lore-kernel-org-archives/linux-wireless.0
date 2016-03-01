Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33099 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbcCAKgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:36:17 -0500
Received: by mail-wm0-f52.google.com with SMTP id l68so28959929wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:36:17 -0800 (PST)
Date: Tue, 1 Mar 2016 11:36:13 +0100
From: Vishal Thanki <vishalthanki@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: rt2x00queue: rt2800usb: NULL pointer crash while during USB
 disconnect
Message-ID: <20160301103612.GC29736@c50.bag.software> (sfid-20160301_113621_962281_CE23565F)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I observed a NULL pointer access crash during my testing on a custom AM33xx
based board with RT5572 USB wifi module. The kernel log is attached with
the mail. With initial debugging, I think that the USB disconnect
event was triggered while there was an pending/incomplete URB request
present. As a part of USB disconnect, the driver cleanup deallocated
queues. However the completion of pending URB tried to access the queue,
which resulted in the NULL pointer crash.

I added a check in the queue helper routines and with that I did not see
the problem. The patch for the same is also attached with the email.
Please suggest if that is the right way to address the problem.

Thanks,
Vishal

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kernel_crash.log"

[ 1022.938678] usb 2-1: USB disconnect, device number 2
[ 1023.158202] tether: port 2(wlan0) entered disabled state
[ 1023.196244] device wlan0 left promiscuous mode
[ 1023.215777] tether: port 2(wlan0) entered disabled state
[ 1023.414554] tether: port 1(eth0) entered disabled state
[ 1023.461553] ieee80211 : rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -108
[ 1023.471006] Unable to handle kernel NULL pointer dereference at virtual address 00000084
[ 1023.479496] pgd = c0004000
[ 1023.482335] [00000084] *pgd=00000000
[ 1023.486101] Internal error: Oops: 17 [#1] PREEMPT ARM
[ 1023.491401] Modules linked in: ctr ccm rt2800usb rt2x00usb rt2800lib rt2x00lib mac80211
[ 1023.499865] CPU: 0 PID: 3 Comm: ksoftirqd/0 Not tainted 4.0.0 #1
[ 1023.506166] Hardware name: Generic AM33XX (Flattened Device Tree)
[ 1023.512557] task: cf049600 ti: cf060000 task.ti: cf060000
[ 1023.518240] PC is at __lock_acquire+0x1c4/0x1f54
[ 1023.523086] LR is at 0x1
[ 1023.525744] pc : [<c0060ab8>]    lr : [<00000001>]    psr: 200f0093
[ 1023.525744] sp : cf061d58  ip : 00000000  fp : 40000006
[ 1023.537789] r10: c082784c  r9 : c086a400  r8 : cf049600
[ 1023.543267] r7 : 00000084  r6 : 00000000  r5 : c083a594  r4 : c10375cc
[ 1023.550114] r3 : c0e567ec  r2 : 00000000  r1 : 00000000  r0 : 00000084
[ 1023.556964] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[ 1023.564722] Control: 10c5387d  Table: 8f704019  DAC: 00000015
[ 1023.570748] Process ksoftirqd/0 (pid: 3, stack limit = 0xcf060210)
[ 1023.577232] Stack: (0xcf061d58 to 0xcf062000)
[ 1023.581805] 1d40:                                                       53425553 45545359
[ 1023.590389] 1d60: 65693d4d 30386565 00313132 49564544 2b3d4543 65656569 00000000 60003a31
[ 1023.598973] 1d80: c05a48fc cf049600 00000001 c10375cc c083a594 00000000 00000000 cf049600
[ 1023.607556] 1da0: c09968e4 c082784c 000001f7 c0060ce8 00000000 cf049600 000001f7 00000000
[ 1023.616139] 1dc0: 600f0093 00000080 00000001 cf4a1988 c086a400 00000100 40000006 c00630a4
[ 1023.624721] 1de0: 00000001 00000080 00000000 bf060a94 00000000 00000100 40000006 00000074
[ 1023.633305] 1e00: 800f0093 bf060a94 cf4a19a8 c05a4740 00000001 00000000 bf060a94 cf061e40
[ 1023.641887] 1e20: 00000002 00000000 00000074 bf060a94 00000000 000000b8 cf4cb640 bf08aa00
[ 1023.650469] 1e40: 0000020a cf4cb640 ce3a9e00 600f0013 cf4a19a8 bf08abd4 ce3a9e00 ffffff94
[ 1023.659052] 1e60: ce487cc0 bf083420 bf083400 ce3a9e00 00000000 c0388b58 cf4a1984 cf061e88
[ 1023.667636] 1e80: 00000000 c0389d7c cf061e88 cf061e88 cf4a19b0 00000000 c0824e98 c086a3c0
[ 1023.676217] 1ea0: cf060000 c00359d0 c0827720 00000000 00000006 c086a418 c086a400 c0035d14
[ 1023.684799] 1ec0: ffffffff c0012468 c086a3c0 0000000a c0828ae0 00011a9a 04208040 00000000
[ 1023.693381] 1ee0: cf060000 cf060000 cf01f200 00000000 00000001 c0824eac 00000002 00000000
[ 1023.701964] 1f00: 00000000 c0035e90 c0035e68 c004f040 00000000 cf01f240 cf01f200 c004eee8
[ 1023.710545] 1f20: 00000000 00000000 00000000 c004b814 00000001 00000001 00000000 cf01f200
[ 1023.719128] 1f40: 00000000 00000001 dead4ead ffffffff ffffffff c086a778 c09a1b64 00000000
[ 1023.727710] 1f60: c0709174 cf061f64 cf061f64 00000000 00000001 dead4ead ffffffff ffffffff
[ 1023.736294] 1f80: c086a778 00000000 00000000 c0709174 cf061f90 cf061f90 cf061fac cf01f240
[ 1023.744877] 1fa0: c004b738 00000000 00000000 c000e690 00000000 00000000 00000000 00000000
[ 1023.753460] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[ 1023.762041] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[ 1023.770640] [<c0060ab8>] (__lock_acquire) from [<c00630a4>] (lock_acquire+0x68/0x88)
[ 1023.778778] [<c00630a4>] (lock_acquire) from [<c05a4740>] (_raw_spin_lock_irqsave+0x48/0x5c)
[ 1023.787666] [<c05a4740>] (_raw_spin_lock_irqsave) from [<bf060a94>] (rt2x00queue_get_entry+0x24/0x78 [rt2x00lib])
[ 1023.798460] [<bf060a94>] (rt2x00queue_get_entry [rt2x00lib]) from [<bf08aa00>] (rt2800usb_watchdog+0x1c4/0x2b0 [rt2800usb)
[ 1023.810150] [<bf08aa00>] (rt2800usb_watchdog [rt2800usb]) from [<bf08abd4>] (rt2800usb_tx_sta_fifo_read_completed+0xc4/0x)
[ 1023.823117] [<bf08abd4>] (rt2800usb_tx_sta_fifo_read_completed [rt2800usb]) from [<bf083420>] (rt2x00usb_register_read_as)
[ 1023.837275] [<bf083420>] (rt2x00usb_register_read_async_cb [rt2x00usb]) from [<c0388b58>] (__usb_hcd_giveback_urb+0x60/0x)
[ 1023.849145] [<c0388b58>] (__usb_hcd_giveback_urb) from [<c0389d7c>] (usb_giveback_urb_bh+0x88/0xc4)
[ 1023.858651] [<c0389d7c>] (usb_giveback_urb_bh) from [<c00359d0>] (tasklet_action+0x94/0x108)
[ 1023.867513] [<c00359d0>] (tasklet_action) from [<c0035d14>] (__do_softirq+0x14c/0x2a0)
[ 1023.875826] [<c0035d14>] (__do_softirq) from [<c0035e90>] (run_ksoftirqd+0x28/0x50)
[ 1023.883868] [<c0035e90>] (run_ksoftirqd) from [<c004f040>] (smpboot_thread_fn+0x158/0x24c)
[ 1023.892551] [<c004f040>] (smpboot_thread_fn) from [<c004b814>] (kthread+0xdc/0xf0)
[ 1023.900507] [<c004b814>] (kthread) from [<c000e690>] (ret_from_fork+0x14/0x24)
[ 1023.908091] Code: e1a00004 e28dd064 e8bd8ff0 e59f3ee4 (e5972000) 
[ 1023.914513] ---[ end trace 8a7e367b258f7269 ]---
[ 1023.919362] Kernel panic - not syncing: Fatal exception in interrupt
[ 1023.926035] ---[ end Kernel panic - not syncing: Fatal exception in interrupt


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-rt2x00-Validate-queue-entry-before-accessing.patch"

>From 2375404218e01c014fc4b736f3005e481c9376fd Mon Sep 17 00:00:00 2001
From: Vishal Thanki <vishalthanki@gmail.com>
Date: Tue, 1 Mar 2016 11:25:33 +0100
Subject: [PATCH] rt2x00: Validate queue entry before accessing

Prevent the access of queue if it is destroyed.

Signed-off-by: Vishal Thanki <vishalthanki@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 2233b91..96ea5ba 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -532,7 +532,7 @@ struct data_queue {
  */
 #define queue_loop(__entry, __start, __end)			\
 	for ((__entry) = (__start);				\
-	     prefetch(queue_next(__entry)), (__entry) != (__end);\
+	     prefetch(queue_next(__entry)), __entry && (__entry) != (__end);\
 	     (__entry) = queue_next(__entry))
 
 /**
-- 
2.4.3


--h31gzZEtNLTqOjlF--
