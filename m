Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:5522 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0DKRNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 13:13:16 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1761273qwh.37
        for <linux-wireless@vger.kernel.org>; Sun, 11 Apr 2010 10:13:15 -0700 (PDT)
Message-ID: <4bc20326.e22be50a.5f3d.ffffc22d@mx.google.com>
Date: Sun, 11 Apr 2010 10:13:10 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: ath9k-devel@ath9k.org, linux-wireless@vger.kernel.org
Subject: ath: timeout on reg 0x9860
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing 2.6.34 I find that my card will frequently (once an hour or so)
drop my connection. This is evidently the result of the hardware going down
(dmesg output[1] attached). What debugging flags might help in identifying this
issue?

Futhermore, it seems that the driver goes down pretty hard, as even rmmod
simply hangs in stop_machine() (backtraces[2] attached). It is rather strange
that this is yet another lockup in stop_machine(), considering this is also
where a aes acceleration issue has manifested itself (see "Lockup inside of
stop_machine() during modprobe aes (was: Re: Another AR5008 hang)"). That being
said, I think that this is a distinct issue.

Any feedback at all would be greatly appreciated. Thanks,

- Ben


Hardware:
0c:00.0 Network controller: Atheros Communications Inc. AR5008 Wireless Network Adapter (rev 01)
	Subsystem: Askey Computer Corp. Device 7125
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at f6cf0000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [60] Express Legacy Endpoint, MSI 00
	Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k


======================================================================
[1] Representative timeouts

[ 2854.842825] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2854.842843] ath: Unable to reset channel (2422 MHz), reset status -5
[ 2854.842893] ath: Unable to set channel
[ 2855.273252] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2855.273270] ath: Unable to reset channel (5680 MHz), reset status -5
[ 2855.273290] ath: Unable to set channel
[ 2855.399853] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2855.399868] ath: Unable to reset channel (2422 MHz), reset status -5
[ 2855.399986] ath: Unable to set channel
[ 2855.827771] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
...
[ 2858.728228] ath: Unable to reset channel (2422 MHz), reset status -5
[ 2858.728245] ath: Unable to set channel
[ 2859.736738] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 2859.736770] ath: Unable to stop TxDMA. Reset HAL!
[ 2859.863857] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2859.863874] ath: Unable to reset hardware; reset status -5
[ 2859.991871] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2859.991886] ath: Unable to reset hardware; reset status -5
[ 2861.493121] No probe response from AP 00:21:63:2f:fe:6f after 500ms, disconnecting.
[ 2861.502294] ath: Failed to stop TX DMA in 100 msec after killing last frame
[ 2861.502324] ath: Unable to stop TxDMA. Reset HAL!
[ 2861.629032] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2861.629048] ath: Unable to reset hardware; reset status -5
[ 2861.756113] ath: timeout (100000 us) on reg 0x9860: 0x00049d19 & 0x00000001 != 0x00000000
[ 2861.756127] ath: Unable to reset channel (2422 MHz), reset status -5
[ 2861.756201] ath: Unable to set channel

======================================================================
[2] Post-mortem backtraces and locking data after rmmod ath9k

[ 3058.221094] SysRq : Show Blocked State
[ 3058.221110]   task                        PC stack   pid father
[ 3058.221193] rmmod         D 00000000ffffffff     0 15406  15194 0x00000000
[ 3058.221206]  ffff8800659abc08 0000000000000046 ffffffff81e62040 0000000000015c80
[ 3058.221219]  ffff8800659abfd8 0000000000015c80 ffff8800659abfd8 ffff88009f9da020
[ 3058.221232]  0000000000015c80 0000000000015c80 ffff8800659abfd8 0000000000015c80
[ 3058.221244] Call Trace:
[ 3058.221261]  [<ffffffff815bd73d>] schedule_timeout+0x23d/0x310
[ 3058.221274]  [<ffffffff8109089b>] ? mark_held_locks+0x6b/0xa0
[ 3058.221284]  [<ffffffff815bff90>] ? _raw_spin_unlock_irq+0x30/0x40
[ 3058.221294]  [<ffffffff81090bad>] ? trace_hardirqs_on_caller+0x14d/0x190
[ 3058.221304]  [<ffffffff815bd32f>] wait_for_common+0xcf/0x170
[ 3058.221316]  [<ffffffff81052620>] ? default_wake_function+0x0/0x20
[ 3058.221325]  [<ffffffff81090bad>] ? trace_hardirqs_on_caller+0x14d/0x190
[ 3058.221334]  [<ffffffff815bd48d>] wait_for_completion+0x1d/0x20
[ 3058.221345]  [<ffffffff8107668d>] flush_cpu_workqueue+0x6d/0xd0
[ 3058.221354]  [<ffffffff81076850>] ? wq_barrier_func+0x0/0x20
[ 3058.221364]  [<ffffffff81077153>] flush_workqueue+0x83/0xb0
[ 3058.221373]  [<ffffffff810770d0>] ? flush_workqueue+0x0/0xb0
[ 3058.221383]  [<ffffffff810b4ae4>] __stop_machine+0x114/0x140
[ 3058.221392]  [<ffffffff8109bb40>] ? __try_stop_module+0x0/0x50
[ 3058.221401]  [<ffffffff810b4d4e>] stop_machine+0x3e/0x60
[ 3058.221410]  [<ffffffff8109b064>] ? find_module+0x34/0x70
[ 3058.221428]  [<ffffffff8109c43b>] sys_delete_module+0x18b/0x290
[ 3058.221439]  [<ffffffff81080613>] ? up_read+0x23/0x40
[ 3058.221449]  [<ffffffff815bf5f2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3058.221461]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
...
[ 3224.234488] SysRq : Show Locks Held
[ 3224.234495] 
[ 3224.234496] Showing all locks held in the system:
[ 3224.234516] 1 lock held by getty/4343:
[ 3224.234518]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234539] 1 lock held by getty/4349:
[ 3224.234541]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234549] 1 lock held by getty/4452:
[ 3224.234550]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234557] 1 lock held by getty/4453:
[ 3224.234559]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234565] 1 lock held by getty/4455:
[ 3224.234567]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234576] 1 lock held by getty/5047:
[ 3224.234578]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234589] 1 lock held by bash/5174:
[ 3224.234590]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234602] 1 lock held by bash/5305:
[ 3224.234603]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234617] 1 lock held by chromium-browse/6063:
[ 3224.234618]  #0:  (&u->readlock){+.+.+.}, at: [<ffffffff81548a43>] unix_dgram_recvmsg+0x73/0x380
[ 3224.234628] 2 locks held by rmmod/15406:
[ 3224.234629]  #0:  (module_mutex){+.+.+.}, at: [<ffffffff8109c36e>] sys_delete_module+0xbe/0x290
[ 3224.234637]  #1:  (lock){+.+...}, at: [<ffffffff810b49f7>] __stop_machine+0x27/0x140
[ 3224.234650] 1 lock held by bash/15410:
[ 3224.234651]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138d0ce>] n_tty_read+0x4ce/0x980
[ 3224.234658] 6 locks held by gnome-screensho/15760:
[ 3224.234659]  #0:  (&serio->lock){-.-...}, at: [<ffffffff814537e6>] serio_interrupt+0x36/0xa0
[ 3224.234666]  #1:  (&(&dev->event_lock)->rlock){-.-...}, at: [<ffffffff814589b2>] input_event+0x62/0xa0
[ 3224.234672]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff81457fb0>] input_pass_event+0x0/0x110
[ 3224.234677]  #3:  (kbd_event_lock){-.-...}, at: [<ffffffff81399098>] kbd_event+0x38/0x820
[ 3224.234682]  #4:  (sysrq_key_table_lock){-.-...}, at: [<ffffffff813a2975>] __handle_sysrq+0x35/0x190
[ 3224.234688]  #5:  (tasklist_lock){.?.?..}, at: [<ffffffff8108f500>] debug_show_all_locks+0x40/0x1c0
[ 3224.234696] 
[ 3224.234697] =============================================

