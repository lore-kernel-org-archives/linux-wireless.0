Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34224 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933902AbbHKI3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2015 04:29:31 -0400
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
From: poma <pomidorabelisima@gmail.com>
Subject: WARNING: CPU: 3 PID: 827 at lib/dma-debug.c:1169
 check_for_stack+0x94/0xe0()
Message-ID: <55C9B267.8000705@gmail.com> (sfid-20150811_103056_425815_1A4BB1CA)
Date: Tue, 11 Aug 2015 10:29:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


------------[ cut here ]------------
WARNING: CPU: 3 PID: 827 at lib/dma-debug.c:1169 check_for_stack+0x94/0xe0()
ehci-pci 0000:00:02.1: DMA-API: device driver maps memory from stack [addr=ffff8800bc6dfa3c]
Modules linked in: ... mt7601u(+) mac80211 ... cfg80211 rfkill ...
CPU: 3 PID: 827 Comm: systemd-udevd Not tainted 4.2.0-0.rc6.git0.1.fc24.x86_64+debug #1
...
Call Trace:
 [<ffffffff81868d8e>] dump_stack+0x4c/0x65
 [<ffffffff810ab406>] warn_slowpath_common+0x86/0xc0
 [<ffffffff810ab495>] warn_slowpath_fmt+0x55/0x70
 [<ffffffff81871e26>] ? _raw_spin_unlock_irqrestore+0x36/0x60
 [<ffffffff81450044>] check_for_stack+0x94/0xe0
 [<ffffffff8145062b>] debug_dma_map_page+0xfb/0x140
 [<ffffffff81614eb8>] usb_hcd_map_urb_for_dma+0x608/0x760
 [<ffffffff8161548d>] usb_hcd_submit_urb+0x1cd/0xab0
 [<ffffffff8110315f>] ? save_trace+0x3f/0xc0
 [<ffffffff81106edd>] ? mark_held_locks+0x7d/0xb0
 [<ffffffff8110ddd5>] ? __raw_spin_lock_init+0x25/0x60
 [<ffffffff81103b73>] ? lockdep_init_map+0x73/0x640
 [<ffffffff81107039>] ? trace_hardirqs_on_caller+0x129/0x1b0
 [<ffffffff8161707c>] usb_submit_urb+0x3fc/0x5a0
 [<ffffffff81617947>] usb_start_wait_urb+0x77/0x180
 [<ffffffff8124a83e>] ? __kmalloc+0x28e/0x360
 [<ffffffff81617b2c>] usb_control_msg+0xdc/0x130
 [<ffffffffa0850510>] mt7601u_vendor_request+0xf0/0x310 [mt7601u]
 [<ffffffff8186f4dc>] ? __mutex_unlock_slowpath+0xbc/0x180
 [<ffffffffa08507b9>] mt7601u_rr+0x59/0x280 [mt7601u]
 [<ffffffff8161b738>] ? usb_autosuspend_device+0x28/0x30
 [<ffffffffa0857c93>] mt7601u_wait_asic_ready+0x23/0x60 [mt7601u]
 [<ffffffffa0850ac0>] mt7601u_probe+0xe0/0x220 [mt7601u]
 [<ffffffff8161c03b>] usb_probe_interface+0x1bb/0x2e0
 [<ffffffff81579f26>] driver_probe_device+0x1f6/0x450
 [<ffffffff8157a214>] __driver_attach+0x94/0xa0
 [<ffffffff8157a180>] ? driver_probe_device+0x450/0x450
 [<ffffffff815778f3>] bus_for_each_dev+0x73/0xc0
 [<ffffffff815796fe>] driver_attach+0x1e/0x20
 [<ffffffff8157922e>] bus_add_driver+0x1ee/0x280
 [<ffffffff8157b0a0>] driver_register+0x60/0xe0
 [<ffffffff8161a87d>] usb_register_driver+0xad/0x160
 [<ffffffffa086e000>] ? 0xffffffffa086e000
 [<ffffffffa086e01e>] mt7601u_driver_init+0x1e/0x20 [mt7601u]
 [<ffffffff81002123>] do_one_initcall+0xb3/0x200
 [<ffffffff8124ac65>] ? kmem_cache_alloc_trace+0x355/0x380
 [<ffffffff81867c37>] ? do_init_module+0x28/0x1e9
 [<ffffffff81867c6f>] do_init_module+0x60/0x1e9
 [<ffffffff81154167>] load_module+0x21f7/0x28d0
 [<ffffffff8114f600>] ? m_show+0x1b0/0x1b0
 [<ffffffff81026d79>] ? sched_clock+0x9/0x10
 [<ffffffff810e6ddc>] ? local_clock+0x1c/0x20
 [<ffffffff811549b8>] SyS_init_module+0x178/0x1c0
 [<ffffffff8187282e>] entry_SYSCALL_64_fastpath+0x12/0x76
---[ end trace 0c0ff6cd25624338 ]---


Ref.
https://bugzilla.redhat.com/show_bug.cgi?id=1252336
https://bugzilla.kernel.org/show_bug.cgi?id=102661
