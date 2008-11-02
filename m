Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:49122 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYKBIWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 03:22:21 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA28MG36010996
	for <linux-wireless@vger.kernel.org>; Sun, 2 Nov 2008 10:22:17 +0200
Received: from tikku (essapo-nirac25314.europe.nokia.com [10.162.253.14])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA28MAHn009532
	for <linux-wireless@vger.kernel.org>; Sun, 2 Nov 2008 10:22:11 +0200
To: linux-wireless@vger.kernel.org
Subject: 2.6.28-rc2-wl: network lockups
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 02 Nov 2008 10:22:09 +0200
Message-ID: <871vxuh70u.fsf@nokia.com> (sfid-20081102_092309_246862_148A32CC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have now seen twice a network related lockup with 2.6.28-rc2-wl
(wireless-testing commit d80fe004), once yesterday and once this
morning. I'm guessing that it's somehow wireless related, most
probably a deadlock somewhere. Unfortunately I don't have time to
investigate this more right now, but I'll send the information what I
have now.

o lenovo x60s with iwl3945
o debian unstable
o wpa_supplicant with debian's ifup hack
o all network access stalled (see git-fetch from the process trace)
o ip link stalled
o I use suspend to ram all the time
o was testing with hostapd and b43 earlier, don't know yet if it's related
o no problems with 2.6.27-wl

At the end of this mail there is a process trace taken with sysrq+t.
I'll send more information if/when I see this again.

-- 
Kalle Valo


Nov  2 09:31:39 tikku kernel: f6b71e18 00000046 f1c1fc80 f65b8240 00000400 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707f0f0 f707f248 c2403d60 00000000 f1c1fc80 f69a8cc0 c0290a8c f707f248
Nov  2 09:31:39 tikku kernel: [21610.263053]  0134470d 00000600 f00d801c f6b44760 f2465c00 f65b8240 00000073 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02872bb>] mutex_lock+0x21/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f83ffd49>] iwl3945_mac_hw_scan+0x5e/0x3fe [iwl3945]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0242f57>] ? __qdisc_run+0xee/0x1ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023743b>] ? dev_queue_xmit+0x419/0x44d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028849a>] ? _spin_lock_irqsave+0xc/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128f32>] ? lock_timer_base+0x1f/0x3e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0118cb0>] ? update_curr+0x45/0x85
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f83a88c3>] ieee80211_start_scan+0x78/0x200 [mac80211]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02317a8>] ? skb_dequeue+0x45/0x4c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f83ad7ee>] ieee80211_sta_work+0xa5/0x5f9 [mac80211]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01110fe>] ? smp_apic_timer_interrupt+0x71/0x7f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e51c>] run_workqueue+0x79/0xf3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f83ad749>] ? ieee80211_sta_work+0x0/0x5f9 [mac80211]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e64d>] worker_thread+0xb7/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] kjournald     S 00000296     0  2226      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f66ddf8c 00000046 00000006 00000296 00000001 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f642b0b0 f642b208 c240bd60 00000001 f66ddf68 f73b3980 00000000 f642b208
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6b8269c 00000286 f66ddf68 00000246 f6b826bc 00000246 f66ddf78 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84faf61>] kjournald+0x16d/0x1dd [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84fadf4>] ? kjournald+0x0/0x1dd [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] syslogd       S 490d571e     0  2683      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f66d7b00 00000086 f6a21030 490d571e 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f69ca850 f69ca9a8 c2403d60 00000000 eda613ec f641b900 00000000 f69ca9a8
Nov  2 09:31:39 tikku kernel: [21610.263053]  014529f3 00000400 00000096 f66d7b00 c2403dcc f6a21b74 ffffffff 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0274698>] ? unix_peer_get+0x29/0x2f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027565c>] ? unix_dgram_poll+0xae/0x12e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f821846d>] ? __map_bio+0x43/0x11e [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c018955e>] ? bio_alloc_bioset+0x77/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f82192fc>] ? __split_bio+0x4c7/0x4d1 [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f6a53>] ? journal_stop+0x16e/0x179 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f82194b0>] ? dm_request+0x126/0x13d [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01ba6c1>] ? generic_make_request+0x46e/0x4a4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d9bd>] ? generic_file_buffered_write+0x177/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01ae710>] ? cap_inode_need_killpriv+0x28/0x3c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014ec49>] ? mempool_alloc_slab+0xe/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014eeae>] ? mempool_alloc+0x42/0xe0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014ec49>] ? mempool_alloc_slab+0xe/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014eeae>] ? mempool_alloc+0x42/0xe0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172cf1>] ? pipe_write+0x3cb/0x40c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c781>] ? find_get_pages_tag+0x2f/0xda
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cc9c>] ? rw_copy_check_uvector+0x5b/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d3cc>] ? do_readv_writev+0x82/0x165
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172926>] ? pipe_write+0x0/0x40c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0129ae3>] ? sys_rt_sigprocmask+0x48/0xb8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] klogd         S f65ade30     0  2692      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f65adf00 00000082 c01754f4 f65ade30 f65ade9c c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71f8850 f71f89a8 c2403d60 00000000 f65aded8 f69cb280 f65aded8 f71f89a8
Nov  2 09:31:39 tikku kernel: [21610.263053]  f65adf70 c016cec3 00000000 00000246 c0354a0c 00000246 f65adeec 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01754f4>] ? path_walk+0x92/0x9b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cec3>] ? do_sync_write+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0122397>] do_syslog+0xdc/0x2f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c019f7cf>] ? kmsg_read+0x0/0x3d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c019f803>] kmsg_read+0x34/0x3d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0199100>] proc_reg_read+0x60/0x74
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01990a0>] ? proc_reg_read+0x0/0x74
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] acpid         S f651db28     0  2709      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f651db8c 00000086 f70fbb80 f651db28 c0288427 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707e460 f707e5b8 c240bd60 00000001 c0354824 f69a82c0 00000000 f707e5b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  013e2fb9 00000001 c0377a80 00000000 c0377a80 f651db70 c0288427 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c990c>] ? number+0x106/0x1be
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01ca3ca>] ? vsnprintf+0x591/0x5dc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151532>] ? get_page_from_freelist+0xa5/0x367
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151a69>] ? __alloc_pages_internal+0xb0/0x37f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0117d40>] ? ptep_set_access_flags+0x21/0x28
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01598c9>] ? do_wp_page+0x3de/0x443
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015aa85>] ? handle_mm_fault+0x4a0/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012332c>] ? release_task+0x272/0x282
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123755>] ? wait_consider_task+0x419/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131559>] ? remove_wait_queue+0x30/0x34
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c3e>] ? do_wait+0x1d7/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] dbus-daemon   S c0111119     0  2719      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6bf1b8c 00000082 f7071bc0 c0111119 ffffffff c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70aab80 f70aacd8 c240bd60 00000001 c03546c0 f6a32040 c0354824 f70aacd8
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144b4ce f6bf1b60 c01057a7 00000001 c0377a80 00000000 c0377a80 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0111119>] ? lapic_timer_broadcast+0xd/0xf
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01057a7>] ? timer_interrupt+0x47/0x4e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 9 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02883f0>] ? _read_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eebd>] ? sock_def_readable+0x5b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275fbc>] ? unix_stream_sendmsg+0x242/0x2ef
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c815>] ? sock_aio_write+0x100/0x10d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cdda>] ? do_sync_readv_writev+0xa1/0xdf
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d4a2>] ? do_readv_writev+0x158/0x165
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0125158>] ? sys_gettimeofday+0x2b/0x58
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] avahi-daemon  S c0362e7c     0  2731      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6b93b8c 00000086 f6b93cda c0362e7c 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64d10f0 f64d1248 c240bd60 00000001 00000001 f7343100 00000000 f64d1248
Nov  2 09:31:39 tikku kernel: [21610.263053]  01344761 00000400 c0133ff2 5131bea6 00001520 c24092bc 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 9 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02754d2>] ? unix_dgram_sendmsg+0x3f6/0x478
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] ? sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017f32c>] ? mnt_drop_write+0x5d/0xbd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017b6cf>] ? touch_atime+0xa0/0xba
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0173024>] ? pipe_read+0x2f2/0x2fe
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01760dc>] ? do_filp_open+0x94/0x669
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] avahi-daemon  S f65f7d7c     0  2732   2731
Nov  2 09:31:39 tikku kernel: [21610.263053]  f65f7d90 00000082 f694dc00 f65f7d7c c0275fbc c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f649c850 f649c9a8 c2403d60 00000000 f6b7b540 f65ca080 00000001 f649c9a8
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffbfae4 00000069 00000000 c014c9c0 00000000 00000000 c02a8e50 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275fbc>] ? unix_stream_sendmsg+0x242/0x2ef
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275ae8>] unix_stream_recvmsg+0x20c/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0115ab8>] ? do_page_fault+0x2f8/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c926>] sock_aio_read+0x104/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d858>] vfs_read+0x98/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] boa           S c011b275     0  2759      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f66e7b00 00000082 f713a460 c011b275 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f694dc00 f694dd58 c2403d60 00000000 c03c3d6c f69cb080 0000000c f694dd58
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc00da 006e7b5c f82192fc f66e7be8 00000000 c2400d80 c2408dd4 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011b275>] ? find_busiest_group+0x296/0x704
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f82192fc>] ? __split_bio+0x4c7/0x4d1 [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02520d1>] ? tcp_poll+0x18/0x130
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01866b1>] ? __getblk+0x31/0x2c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015aa1f>] ? handle_mm_fault+0x43a/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0115ab8>] ? do_page_fault+0x2f8/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f6a53>] ? journal_stop+0x16e/0x179 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852e317>] ? ext3_ordered_write_end+0x114/0x123 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d96a>] ? generic_file_buffered_write+0x124/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015179c>] ? get_page_from_freelist+0x30f/0x367
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01157c0>] ? do_page_fault+0x0/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028860a>] ? error_code+0x72/0x78
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017e8e5>] ? mntput_no_expire+0x1a/0xf5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] cupsd         S f651bfb8     0  2768      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f651bf00 00000086 00000006 f651bfb8 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6557420 f6557578 c2403d60 00000000 f6a4aac4 f7343b00 00000000 f6557578
Nov  2 09:31:39 tikku kernel: [21610.263053]  010d0684 00000400 c01021d2 00000000 00800004 f651bfb8 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128bf9>] ? process_timeout+0x0/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b9f>] ? schedule_timeout+0x98/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c018f204>] sys_epoll_wait+0x16f/0x3ad
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016dea5>] ? fput+0x17/0x19
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016b8cc>] ? sys_close+0x6a/0xa4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] dictd         S c238edb0     0  2777      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6519e48 00000082 c0412fb4 c238edb0 7d2be025 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70aa7d0 f70aa928 c2403d60 00000000 c0288427 f65caa80 c015aa1f f70aa928
Nov  2 09:31:39 tikku kernel: [21610.263053]  bf8d2abc f6a11518 f65caa80 f7300460 00000348 f6766bf8 f64bc348 c187bd6c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015aa1f>] ? handle_mm_fault+0x43a/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288402>] ? _spin_unlock_bh+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eaeb>] ? release_sock+0x8d/0x95
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0251d86>] inet_csk_accept+0x9e/0x19e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c026a99a>] inet_accept+0x20/0x93
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022dd72>] do_accept+0x110/0x1d0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288402>] ? _spin_unlock_bh+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eaeb>] ? release_sock+0x8d/0x95
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c026b0f2>] ? inet_listen+0x5b/0x62
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022debb>] sys_socketcall+0x89/0x17e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] exim4         S f6783aa0     0  3044      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6783b00 00000082 f6a0b4a0 f6783aa0 00000082 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70ac810 f70ac968 c2403d60 00000000 00000202 f6547c40 f6783ad8 f70ac968
Nov  2 09:31:39 tikku kernel: [21610.263053]  012a7706 00000000 f734cf20 f82e4020 f6783ae8 c012ed72 f734cf20 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012ed72>] ? queue_work_on+0x3b/0x46
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02520d1>] ? tcp_poll+0x18/0x130
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01341fa>] ? ktime_get_ts+0x40/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0134211>] ? ktime_get+0x13/0x2f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0139b05>] ? tick_handle_oneshot_broadcast+0xda/0xe2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c990c>] ? number+0x106/0x1be
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0148299>] ? handle_edge_irq+0xfe/0x104
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01259c8>] ? irq_exit+0x53/0x6d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c010502d>] ? do_IRQ+0x6f/0x86
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01ca3ca>] ? vsnprintf+0x591/0x5dc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151701>] ? get_page_from_freelist+0x274/0x367
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151a69>] ? __alloc_pages_internal+0xb0/0x37f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0108c6f>] ? save_i387_fxsave+0x82/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017a7d7>] ? d_lookup+0x22/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012f586>] ? free_pid+0x85/0x8b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012332c>] ? release_task+0x272/0x282
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123755>] ? wait_consider_task+0x419/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0129d34>] ? do_sigaction+0x139/0x14a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] inetd         S 000001e2     0  3122      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f66efb00 00000082 f6bba070 000001e2 00000400 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f73f9b40 f73f9c98 c2403d60 00000000 f6d37580 f6a4f480 c0290a8c f73f9c98
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc1b24 00000400 00000000 f6e3b9f8 f6e77b38 f66efb24 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02332d8>] ? datagram_poll+0x18/0xbb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0264646>] ? udp_poll+0x12/0xf0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151a69>] ? __alloc_pages_internal+0xb0/0x37f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015aa1f>] ? handle_mm_fault+0x43a/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0115ab8>] ? do_page_fault+0x2f8/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151532>] ? get_page_from_freelist+0xa5/0x367
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8bb9>] ? rb_erase+0x111/0x224
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01157c0>] ? do_page_fault+0x0/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028860a>] ? error_code+0x72/0x78
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb0fe>] ? copy_from_user+0x11b/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0129d34>] ? do_sigaction+0x139/0x14a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015cd78>] ? unmap_region+0xda/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] kondemand/0   S 0000000a     0  3241      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6711fa8 00000046 f812f731 0000000a c03c4230 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70b1030 f70b1188 c2403d60 00000000 f64e0358 f69cbc80 00000004 f70b1188
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452b09 004b0992 c2404250 00000246 f64e0358 00000246 f6711f94 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f812f731>] ? do_dbs_timer+0x2b4/0x2bd [cpufreq_ondemand]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] famd          S f65f3c4c     0  3252      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6789b00 00000082 f6458810 f65f3c4c f6c09ae0 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6bba070 f6bba1c8 c2403d60 00000000 f6c09aec f7375740 00000001 f6bba1c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  c240bda8 f73f97c4 f6789af0 c0119cc4 f73f97bc f6bba09c f6bba070 f73f97bc
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02520d1>] ? tcp_poll+0x18/0x130
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133e93>] ? hrtimer_cancel+0xd/0x18
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0125ad0>] ? local_bh_enable+0x71/0x7d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023743b>] ? dev_queue_xmit+0x419/0x44d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024e7d8>] ? ip_finish_output+0x1c2/0x1fa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024c710>] ? ip_cork_release+0x2d/0x3a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024cea0>] ? ip_push_pending_frames+0x2b3/0x2bd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023322d>] ? memcpy_toiovec+0x2c/0x50
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c123>] ? sock_destroy_inode+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017beb8>] ? destroy_inode+0x2e/0x3f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017c463>] ? generic_drop_inode+0x141/0x145
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017953c>] ? __d_free+0x3a/0x3d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017e8e5>] ? mntput_no_expire+0x1a/0xf5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017abf2>] ? dput+0x34/0x11b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016b8cc>] ? sys_close+0x6a/0xa4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] hcid          S ffe80669     0  3260      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6705b8c 00000086 c035132c ffe80669 00000086 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6458810 f6458968 c2403d60 00000000 f6705b9c f73f51c0 00000000 f6458968
Nov  2 09:31:39 tikku kernel: [21610.263053]  01344962 00000282 f6705b68 00000282 00000001 f6705b80 c0133e7c 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133e7c>] ? hrtimer_try_to_cancel+0x61/0x6b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172035>] ? pipe_poll+0x29/0x88
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 9 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012521d>] ? tasklet_action+0x61/0xac
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012586b>] ? __do_softirq+0x119/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023322d>] ? memcpy_toiovec+0x2c/0x50
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017a7d7>] ? d_lookup+0x22/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017a842>] ? d_hash_and_lookup+0x5a/0x64
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c019bdb6>] ? proc_flush_task+0x128/0x221
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131559>] ? remove_wait_queue+0x30/0x34
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c3e>] ? do_wait+0x1d7/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d73>] ? sys_wait4+0x87/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] ? sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] krfcommd      S f6b7a02c     0  3269      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64c1f10 00000046 00000000 f6b7a02c 00001431 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6458bc0 f6458d18 c240bd60 00000001 f64c1ed0 f69cbc80 c0290a8c f6458d18
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc223d 00001214 00000246 00000004 f64c1f00 00000246 0000006e 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8295cbf>] ? rfcomm_run+0x0/0x13f2 [rfcomm]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8295dfc>] rfcomm_run+0x13d/0x13f2 [rfcomm]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8295cbf>] ? rfcomm_run+0x0/0x13f2 [rfcomm]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] gdm           S f6d1b940     0  3287      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f65f5b8c 00000082 f7071bc0 f6d1b940 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7300460 f73005b8 c2403d60 00000000 f65f5b6c f7375b40 00000000 f73005b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  0103c767 00000818 f6d45540 f65f5bd4 f65f5b7c 00000246 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 3 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0232733>] ? __alloc_skb+0x46/0xf3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022f18a>] ? sock_alloc_send_skb+0x88/0x1b0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02883f0>] ? _read_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eebd>] ? sock_def_readable+0x5b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275fbc>] ? unix_stream_sendmsg+0x242/0x2ef
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02883f0>] ? _read_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02761fc>] ? unix_write_space+0x6c/0x71
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8bb9>] ? rb_erase+0x111/0x224
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c123>] ? sock_destroy_inode+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01029f5>] ? restore_sigcontext+0x100/0x143
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01784cc>] do_restart_poll+0x2e/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0125171>] ? sys_gettimeofday+0x44/0x58
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01295bc>] sys_restart_syscall+0x11/0x13
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] gdm           S f821846d     0  3289   3287
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7145b00 00000082 f7145acc f821846d 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6458460 f64585b8 c2403d60 00000000 00000001 f73b3580 00000000 f64585b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  013f9969 f7145b5c f82192fc f82e4020 f7145ae8 c012ed72 f734cf20 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f821846d>] ? __map_bio+0x43/0x11e [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f82192fc>] ? __split_bio+0x4c7/0x4d1 [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012ed72>] ? queue_work_on+0x3b/0x46
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f821846d>] ? __map_bio+0x43/0x11e [dm_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172035>] ? pipe_poll+0x29/0x88
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313ce>] ? wake_up_bit+0x5c/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852d32f>] ? __ext3_get_inode_loc+0xc5/0x29d [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0187cb4>] ? __block_prepare_write+0x2c7/0x336
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8537935>] ? __ext3_journal_dirty_metadata+0x19/0x3c [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f6a53>] ? journal_stop+0x16e/0x179 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852e317>] ? ext3_ordered_write_end+0x114/0x123 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d96a>] ? generic_file_buffered_write+0x124/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d9bd>] ? generic_file_buffered_write+0x177/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8535c90>] ? __ext3_journal_stop+0x1c/0x38 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014e30c>] ? __generic_file_aio_write_nolock+0x3d7/0x40f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014eab0>] ? generic_file_aio_write+0x67/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852bf39>] ? ext3_file_write+0x1a/0x89 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cec3>] ? do_sync_write+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012d0ca>] ? sys_setresgid+0x117/0x12b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] Xorg          S f647dab0     0  3297   3289
Nov  2 09:31:39 tikku kernel: [21610.263053]  f647db00 00003082 f25cfe18 f647dab0 c01c8a3e c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70acbc0 f70acd18 c2403d60 00000000 00000001 f69cbc80 f647dacc f70acd18
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452b09 f647daf8 c0133ff2 887b360b 000013a7 c24012bc 00000000 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 19 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01337fc>] ? enqueue_hrtimer+0xc7/0xd2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133684>] ? __remove_hrtimer+0x5f/0x67
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133e7c>] ? hrtimer_try_to_cancel+0x61/0x6b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01246f3>] ? do_setitimer+0x15b/0x2d4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] system-tools- S f6d1acf8     0  3300      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67c3b8c 00000082 f7342b40 f6d1acf8 00000400 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7389bc0 f7389d18 c2403d60 00000000 f67c3b9c f6b75780 00000000 f7389d18
Nov  2 09:31:39 tikku kernel: [21610.263053]  c0133684 00000282 f67c3b68 00000282 00000001 f67c3b80 c0133e7c 00000282
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133684>] ? __remove_hrtimer+0x5f/0x67
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133e7c>] ? hrtimer_try_to_cancel+0x61/0x6b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852d32f>] ? __ext3_get_inode_loc+0xc5/0x29d [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0187bf8>] ? __block_prepare_write+0x20b/0x336
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8537935>] ? __ext3_journal_dirty_metadata+0x19/0x3c [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c926>] ? sock_aio_read+0x104/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016fec2>] ? sys_fstat64+0x22/0x28
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01784cc>] do_restart_poll+0x2e/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01295bc>] sys_restart_syscall+0x11/0x13
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] atd           S f6bbfec0     0  3321      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6bbff08 00000082 012b52c4 f6bbfec0 012b52c4 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7342b40 f7342c98 c2403d60 00000000 00000001 f69cba80 f6bbfed4 f7342c98
Nov  2 09:31:39 tikku kernel: [21610.263053]  010ed6db f6bbff00 c0133ff2 b8d08292 000013b0 c24012bc 00000000 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287737>] do_nanosleep+0x62/0xa2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01340e1>] hrtimer_nanosleep+0xd5/0x136
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028771d>] ? do_nanosleep+0x48/0xa2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0134184>] sys_nanosleep+0x42/0x53
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] cron          S f6785eb8     0  3341      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6785f08 00000082 f2469b9c f6785eb8 c01c8a83 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70a5030 f70a5188 c2403d60 00000000 00000001 f6a4f880 f6785ed4 f70a5188
Nov  2 09:31:39 tikku kernel: [21610.263053]  01449884 f6785f00 c0133ff2 c3b08402 000013ac c24012bc 00000000 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287737>] do_nanosleep+0x62/0xa2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01340e1>] hrtimer_nanosleep+0xd5/0x136
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8475800>] ? alc883_lenovo_101e_unsol_event+0x38/0x5e [snd_hda_intel]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028771d>] ? do_nanosleep+0x48/0xa2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0134184>] sys_nanosleep+0x42/0x53
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3416      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67cbe98 00000086 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70adc00 f70add58 c2403d60 00000000 f70add58 f64e45c0 00000001 f70add58
Nov  2 09:31:39 tikku kernel: [21610.263053]  0000040f 00000000 f70adebc f70d3d40 00000000 f67cbe7c c01294cd f67cbe9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3417      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67d3e98 00000086 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6479b40 f6479c98 c2403d60 00000000 f6479c98 f64e41c0 f67d3e68 f6479c98
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc44cb 00000000 f6479dfc f731b1c0 00000000 f67d3e7c c01294cd f67d3e9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3418      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67d7e98 00000082 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70ad0f0 f70ad248 c2403d60 00000000 f70ad248 f69cb880 00000001 f70ad248
Nov  2 09:31:39 tikku kernel: [21610.263053]  000006b5 00000000 f70ad3ac f641cb00 00000000 f67d7e7c c01294cd f67d7e9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3419      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67cde98 00000082 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71fe070 f71fe1c8 c2403d60 00000000 f71fe1c8 f69cb680 00000001 f71fe1c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000728 00000000 f71fe32c f69917c0 00000000 f67cde7c c01294cd f67cde9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3420      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67cfe98 00000086 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f649cc00 f649cd58 c2403d60 00000000 f649cd58 f64e49c0 00000001 f649cd58
Nov  2 09:31:39 tikku kernel: [21610.263053]  000006b6 00000000 f649cebc f6bf92c0 00000000 f67cfe7c c01294cd f67cfe9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] getty         S c03c3d60     0  3421      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67d9e98 00000086 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6a21790 f6a218e8 c2403d60 00000000 f6a218e8 f73f59c0 00000001 f6a218e8
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000872 00000000 f6a21a4c f64b2a80 00000000 f67d9e7c c01294cd f67d9e9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] gnome-keyring S f2469b3c     0  3454      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2469b8c 00000082 f70aab80 f2469b3c c01c8a83 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6a21030 f6a21188 c2403d60 00000000 00000001 f6547040 f2469b58 f6a21188
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2469b9c f2469b84 c0133ff2 72e4b97b 000013ae c24012bc 00000000 c2401280
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 6 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02883f0>] ? _read_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eebd>] ? sock_def_readable+0x5b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02754d2>] ? unix_dgram_sendmsg+0x3f6/0x478
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] ? sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0173680>] ? do_lookup+0x4f/0x151
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172fe0>] ? pipe_read+0x2ae/0x2fe
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] sh            S f245df18     0  3455   3289
Nov  2 09:31:39 tikku kernel: [21610.263053]  f245df34 00000082 c01af928 f245df18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70fb420 f70fb578 c2403d60 00000000 00000db5 f6547640 19ca29b4 f70fb578
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000004 00000004 007ffc6f 00000000 f7342030 00000000 f70fb420 f245df78
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123b31>] ? do_wait+0xca/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] dbus-launch   S c240bdcc     0  3513      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2445b00 00000082 f70813e0 c240bdcc 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f717c0b0 f717c208 c2403d60 00000000 00000001 f69cb480 00000000 f717c208
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc8396 00000818 00000000 00000082 00018269 00000082 f2445aec 00000082
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0164c66>] ? dma_pool_alloc+0x1da/0x1e4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313e2>] ? autoremove_wake_function+0xf/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d7ff>] ? rebalance_domains+0x68/0x377
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] ? sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] dbus-daemon   S 00000246     0  3514      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2447b8c 00000082 f7081790 00000246 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70813e0 f7081538 c2403d60 00000000 f2447b54 f6547440 00000000 f7081538
Nov  2 09:31:39 tikku kernel: [21610.263053]  fffc8360 00000818 00000000 00000008 00000000 f6949480 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cccb>] ? unlock_page+0x3e/0x41
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01594b3>] ? __do_fault+0x2ef/0x327
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8bb9>] ? rb_erase+0x111/0x224
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0173680>] ? do_lookup+0x4f/0x151
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c018df67>] ? inotify_d_instantiate+0x38/0x3c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01afaf2>] ? security_d_instantiate+0x1c/0x1e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0129d34>] ? do_sigaction+0x139/0x14a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01784cc>] do_restart_poll+0x2e/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0125158>] ? sys_gettimeofday+0x2b/0x58
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01295bc>] sys_restart_syscall+0x11/0x13
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] ssh-agent     S f67c5ab8     0  3525      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f67c5b00 00000082 c035132c f67c5ab8 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7081790 f70818e8 c2403d60 00000000 f67c5ac0 f73b3b80 00000000 f70818e8
Nov  2 09:31:39 tikku kernel: [21610.263053]  01114a74 00000400 f717addc f67c5af8 c0119400 00000000 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01598c9>] ? do_wp_page+0x3de/0x443
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0153f34>] ? activate_page+0xdf/0xe6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0110842>] ? xapic_wait_icr_idle+0x14/0x1b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c010ff76>] ? native_smp_send_reschedule+0x41/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02317a8>] ? skb_dequeue+0x45/0x4c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c123>] ? sock_destroy_inode+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017beb8>] ? destroy_inode+0x2e/0x3f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017c463>] ? generic_drop_inode+0x141/0x145
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017953c>] ? __d_free+0x3a/0x3d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017e8e5>] ? mntput_no_expire+0x1a/0xf5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017abf2>] ? dput+0x34/0x11b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016b8cc>] ? sys_close+0x6a/0xa4
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] unclutter     S f2459ab0     0  3528   3455
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2459b00 00000082 f64d1c00 f2459ab0 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f713a460 f713a5b8 c2403d60 00000000 f2459ae4 f64ef140 00000000 f713a5b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144d65a 00000400 f2459adc 00000282 00000000 f2459af4 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d8a5>] ? rebalance_domains+0x10e/0x377
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02883f0>] ? _read_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eebd>] ? sock_def_readable+0x5b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275fbc>] ? unix_stream_sendmsg+0x242/0x2ef
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c815>] ? sock_aio_write+0x100/0x10d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d4a2>] ? do_readv_writev+0x158/0x165
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d533>] ? sys_writev+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xwrits        S f245bab0     0  3529   3455
Nov  2 09:31:39 tikku kernel: [21610.263053]  f245bb00 00000082 f70acbc0 f245bab0 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f69ca4a0 f69ca5f8 c2403d60 00000000 00000001 f73b3d80 f245bacc f69ca5f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  f245bb10 f245baf8 c0133ff2 8cd16b68 000013a7 c24012bc 00000000 c2401280
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xscreensaver  S 00000246     0  3530   3455
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24e1b8c 00000082 f70acbc0 00000246 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f69cac00 f69cad58 c2403d60 00000000 00000001 f7328840 f24e1b58 f69cad58
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24e1b9c f24e1b84 c0133ff2 d75fd639 000013a7 c24012bc 00000000 c2401280
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c926>] ? sock_aio_read+0x104/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S 00000004     0  3531   3455
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24e3b00 00000082 f70710b0 00000004 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71fa030 f71fa188 c240bd60 00000001 00000046 f73b3980 00000000 f71fa188
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144c297 00000400 f24e3ad8 c01259c8 f24e3ae8 c01110fe 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01259c8>] ? irq_exit+0x53/0x6d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01110fe>] ? smp_apic_timer_interrupt+0x71/0x7f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012586b>] ? __do_softirq+0x119/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013801e>] ? clocksource_get_next+0x3c/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0137183>] ? update_wall_time+0x59a/0x6cb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] sawfish       S f2477ab0     0  3542   3455
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2477b00 00000082 f24e1b9c f2477ab0 c01c8a3e c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7342030 f7342188 c2403d60 00000000 00000001 f6547a40 f2477acc f7342188
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452965 f2477af8 c0133ff2 ab8500b3 000013a7 c24012bc 00000000 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f81fd4cb>] ? sd_prep_fn+0x758/0x775 [sd_mod]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 4 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0129d34>] ? do_sigaction+0x139/0x14a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S c03c3d60     0  3543   3531
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24ade98 00000082 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f713abc0 f713ad18 c2403d60 00000000 f713ad18 f73b3380 f24ade78 f713ad18
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000246 f24ade98 f713ae7c f73fd100 00000000 f24ade7c c01294cd f24ade9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S c03f9db8     0  3571      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f5e81b00 00200082 f7342030 c03f9db8 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f713a810 f713a968 c240bd60 00000001 00000200 f6a32840 00000000 f713a968
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144c3af 00000818 c014834a c03781d4 c03781a0 f5e81ae4 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014834a>] ? handle_fasteoi_irq+0xab/0xb1
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0148299>] ? handle_edge_irq+0xfe/0x104
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0139b05>] ? tick_handle_oneshot_broadcast+0xda/0xe2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151a69>] ? __alloc_pages_internal+0xb0/0x37f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0232733>] ? __alloc_skb+0x46/0xf3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022f18a>] ? sock_alloc_send_skb+0x88/0x1b0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S c03c3d60     0  3572   3571
Nov  2 09:31:39 tikku kernel: [21610.263053]  f244fe98 00200082 c03c13fc c03c3d60 c03c3d60 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70aa070 f70aa1c8 c2403d60 00000000 f70aa1c8 f64ef940 00000bd4 f70aa1c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  00adc6ec f244fe98 f70aa32c f73fd300 00000000 f244fe7c c01294cd f244fe9c
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01294cd>] ? recalc_sigpending+0xe/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012b97d>] ? dequeue_signal+0x9d/0x10f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] emacs         S f2425ab0     0  3841   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2425b00 00000082 c035132c f2425ab0 c01c8a3e c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f65577d0 f6557928 c2403d60 00000000 00000001 f6a4f080 f2425acc f6557928
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2425b10 f2425af8 c0133ff2 8a74b1c0 000013a7 c24012bc 00000000 c2401280
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313ce>] ? wake_up_bit+0x5c/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852d32f>] ? __ext3_get_inode_loc+0xc5/0x29d [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0187bf8>] ? __block_prepare_write+0x20b/0x336
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8537935>] ? __ext3_journal_dirty_metadata+0x19/0x3c [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f6a53>] ? journal_stop+0x16e/0x179 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852e317>] ? ext3_ordered_write_end+0x114/0x123 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d96a>] ? generic_file_buffered_write+0x124/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d9bd>] ? generic_file_buffered_write+0x177/0x504
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012ed09>] ? delayed_work_timer_fn+0x0/0x2e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S f25c3680     0  3843      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24fbb00 00000082 f707ab80 f25c3680 00000800 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f694d850 f694d9a8 c240bd60 00000001 00000246 f65ca680 c0290a8c f694d9a8
Nov  2 09:31:39 tikku kernel: [21610.263053]  0143fdf2 00000800 f24fbb44 f27cb0f0 f24fbb08 f8592cce 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8592cce>] ? ip6_xmit+0x28e/0x340 [ipv6]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0118c64>] ? sched_slice+0x49/0x50
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0139b05>] ? tick_handle_oneshot_broadcast+0xda/0xe2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S f24f9e7c     0  3844   3843
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24f9e98 00000086 7799c065 f24f9e7c 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f73000b0 f7300208 c240bd60 00000001 f7343900 f7343900 00000000 f7300208
Nov  2 09:31:39 tikku kernel: [21610.263053]  012b7fd3 00000400 c0287292 00000008 f66f317c 080fb008 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S 00000100     0  3877      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2473b00 00200086 f7071bc0 00000100 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707ab80 f707acd8 c240bd60 00000001 00000000 f64e4bc0 00000000 f707acd8
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452a9b 00000400 c24004c4 f2473adc c01259c8 f2473aec 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01259c8>] ? irq_exit+0x53/0x6d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013801e>] ? clocksource_get_next+0x3c/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0137183>] ? update_wall_time+0x59a/0x6cb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S f2471e7c     0  3878   3877
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2471e98 00200082 76b37065 f2471e7c 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71fa790 f71fa8e8 c240bd60 00000001 f6a32240 f6a32240 00000000 f71fa8e8
Nov  2 09:31:39 tikku kernel: [21610.263053]  01450e0a 00000400 c0287292 00000008 f7079ef0 080fb008 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S f80529f4     0  4102      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f27cdb00 00200086 c035132c f80529f4 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64d1c00 f64d1d58 c2403d60 00000000 f27cdad4 f641b700 00000000 f64d1d58
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144aaab 00000400 c0288427 f27cdaec c014834a c03781d4 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f80529f4>] ? uhci_irq+0x113/0x120 [uhci_hcd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014834a>] ? handle_fasteoi_irq+0xab/0xb1
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023743b>] ? dev_queue_xmit+0x419/0x44d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313e2>] ? autoremove_wake_function+0xf/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0139b05>] ? tick_handle_oneshot_broadcast+0xda/0xe2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S f2631f18     0  4103   4102
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2631f34 00200086 c01af928 f2631f18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64d14a0 f64d15f8 c2403d60 00000000 f70afd40 f73f5dc0 c0119400 f64d15f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000001 c02017e0 f26b3800 bfa3d564 f6a0b4a0 00000000 f64d14a0 f2631f78
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02017e0>] ? tty_ioctl+0x0/0x6d6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123b31>] ? do_wait+0xca/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   S 00000246     0  4157   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2661b8c 00000082 f2661b28 00000246 f2661c00 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7389460 f73895b8 c240bd60 00000001 00000001 f6b75380 f2661b58 f73895b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2661b9c f2661b84 c0133ff2 60016fd8 000013a8 c24092bc 00000000 c2409280
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 8 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c926>] ? sock_aio_read+0x104/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012ed09>] ? delayed_work_timer_fn+0x0/0x2e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   D c0242f57     0  4160   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f698dd1c 00000082 f698dcd0 c0242f57 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7081030 f7081188 c2403d60 00000000 c023743b f6b75380 00000000 f7081188
Nov  2 09:31:39 tikku kernel: [21610.263053]  0143ef97 00000400 f698dd0c f8592f9a f069bd20 00000000 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0242f57>] ? __qdisc_run+0xee/0x1ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023743b>] ? dev_queue_xmit+0x419/0x44d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8592f9a>] ? ip6_output2+0x21a/0x272 [ipv6]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02872bb>] mutex_lock+0x21/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023f056>] rtnetlink_rcv+0x10/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0244fca>] netlink_unicast+0x1a9/0x20a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0245263>] netlink_sendmsg+0x238/0x245
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128f32>] ? lock_timer_base+0x1f/0x3e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015aa85>] ? handle_mm_fault+0x4a0/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb01c>] ? copy_from_user+0x39/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d295>] sys_sendto+0xa4/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d910>] ? move_addr_to_user+0x3b/0x52
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022dc57>] ? sys_getsockname+0x6b/0x76
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c018df67>] ? inotify_d_instantiate+0x38/0x3c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01afaf2>] ? security_d_instantiate+0x1c/0x1e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022df0c>] sys_socketcall+0xda/0x17e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   S c24012c4     0  4161   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f25cfdfc 00000082 c035132c c24012c4 f25cfe18 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f642b810 f642b968 c2403d60 00000000 f25cfdc0 f6b75380 f25cfe18 f642b968
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452ac2 89565486 000013a7 c24012bc 00000000 c2401280 00000282 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013b8cb>] futex_wait+0x285/0x3ce
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013b8ad>] ? futex_wait+0x267/0x3ce
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013caa8>] do_futex+0x68/0x7cd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01341fa>] ? ktime_get_ts+0x40/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013d2de>] sys_futex+0xd1/0xe7
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   S ffffffff     0  4165   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f27e1dfc 00000082 f649c0f0 ffffffff efdecd40 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70fb7d0 f70fb928 c2403d60 00000000 00000062 f6b75380 f694d884 f70fb928
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64d1c2c c2403da8 f64d1c34 f27e1df0 00000246 f27e1e7c 00000246 f27e1dec
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013b819>] futex_wait+0x1d3/0x3ce
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017b60e>] ? file_update_time+0x87/0xa8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013caa8>] do_futex+0x68/0x7cd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0111119>] ? lapic_timer_broadcast+0xd/0xf
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0139b05>] ? tick_handle_oneshot_broadcast+0xda/0xe2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013d2de>] sys_futex+0xd1/0xe7
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d7b7>] ? sys_write+0x57/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   S 00a1a1a1     0  4166   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f27e3dfc 00000082 f707ebc0 00a1a1a1 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f649c0f0 f649c248 c2403d60 00000000 f27e3dd0 f6b75380 f64d1c34 f649c248
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70fb7fc c2403da8 f70fb804 f27e3df0 00000246 f27e3e7c 00000246 f27e3dec
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013b819>] futex_wait+0x1d3/0x3ce
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01341fa>] ? ktime_get_ts+0x40/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013caa8>] do_futex+0x68/0x7cd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012586b>] ? __do_softirq+0x119/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013d2de>] sys_futex+0xd1/0xe7
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] firefox-bin   S e23b5380     0  4172   3543
Nov  2 09:31:39 tikku kernel: [21610.263053]  f251fdfc 00000082 f251fe3c e23b5380 f1a5eb80 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707ebc0 f707ed18 c240bd60 00000001 f1a5eac4 f6b75380 e23b53c4 f707ed18
Nov  2 09:31:39 tikku kernel: [21610.263053]  0143efdb 00000818 c011075c 00000000 00000246 f251fe7c 00000246 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011075c>] ? flush_tlb_page+0x59/0x5e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013b819>] futex_wait+0x1d3/0x3ce
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017f32c>] ? mnt_drop_write+0x5d/0xbd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017b60e>] ? file_update_time+0x87/0xa8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013caa8>] do_futex+0x68/0x7cd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0193a08>] ? vfs_lock_file+0x2d/0x31
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013d2de>] sys_futex+0xd1/0xe7
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d7b7>] ? sys_write+0x57/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] gconfd-2      S f27d3b3c     0  4159      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f27d3b8c 00000082 f6785f3c f27d3b3c c01c8a83 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f73890b0 f7389208 c2403d60 00000000 00000001 f73b3180 f27d3b58 f7389208
Nov  2 09:31:39 tikku kernel: [21610.263053]  014525d6 f27d3b84 c0133ff2 33383cfe 000013ae c24012bc 00000000 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133ff2>] ? hrtimer_start_range_ns+0x154/0x16e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02876a0>] schedule_hrtimeout_range+0x105/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0133a19>] ? hrtimer_wakeup+0x0/0x1c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287686>] ? schedule_hrtimeout_range+0xeb/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 4 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01866b1>] ? __getblk+0x31/0x2c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313ce>] ? wake_up_bit+0x5c/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0186676>] ? __find_get_block+0x13b/0x145
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8537935>] ? __ext3_journal_dirty_metadata+0x19/0x3c [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01866b1>] ? __getblk+0x31/0x2c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313ce>] ? wake_up_bit+0x5c/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c57e1>] ? __next_cpu+0x15/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011b275>] ? find_busiest_group+0x296/0x704
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01109fd>] ? lapic_next_event+0x13/0x17
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01392b1>] ? clockevents_program_event+0xd4/0xe3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] ispell        S f717c460     0  4216   3841
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1c9fe4c 00000082 00000000 f717c460 f1c9fdfc c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f717c460 f717c5b8 c2403d60 00000000 00000001 f73b3780 c2403d60 f717c5b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2425c00 f1c3c004 00000001 00000246 f695b800 f695b800 f1c9fe44 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172904>] pipe_wait+0x53/0x75
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172fd3>] pipe_read+0x2a1/0x2fe
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cf01>] ? do_sync_read+0x0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S c03c1438     0  5264      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1c47b00 00000086 f70acbc0 c03c1438 0000000a c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6479790 f64798e8 c2403d60 00000000 f1c47ac0 f7343500 f1c47ad0 f64798e8
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000246 00000001 f1c47b14 c0103b0c 00000246 c032c846 00007203 00000001
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103b0c>] ? apic_timer_interrupt+0x28/0x30
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012586b>] ? __do_softirq+0x119/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S f265de44     0  5265   5264
Nov  2 09:31:39 tikku kernel: [21610.263053]  f265de98 00000082 f1c6081c f265de44 00000246 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71fe420 f71fe578 c240bd60 00000001 c0205678 f6b75980 f265de78 f71fe578
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000246 f265de98 c0287292 f1c60820 f71fe420 f1c60830 00000246 00000003
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205678>] ? tty_mode_ioctl+0x38b/0x39c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287099>] ? __mutex_lock_interruptible_slowpath+0x1b4/0x1ec
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020368f>] n_tty_read+0x364/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020332b>] ? n_tty_read+0x0/0x599
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02001ce>] tty_read+0x62/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c020016c>] ? tty_read+0x0/0x99
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] xterm         S 00000000     0  8380      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f24ebb00 00200082 f713a810 00000000 00000400 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70710b0 f7071208 c240bd60 00000001 f24ebad0 f7328240 c0290a8c f7071208
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144aaab 00000400 f24ebae4 c010502d 00000000 f24ebbec 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c010502d>] ? do_IRQ+0x6f/0x86
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0205d25>] ? tty_ldisc_deref+0x5c/0x63
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0202e2b>] ? n_tty_poll+0x0/0x11a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02000fd>] ? tty_poll+0x53/0x5f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku last message repeated 2 times
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a83>] ? rb_insert_color+0x9b/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028846c>] ? _spin_lock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119c27>] ? task_rq_lock+0x31/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] ? sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] bash          S f2493f18     0  8381   8380
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2493f34 00200082 c01af928 f2493f18 00000400 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f73f93e0 f73f9538 c2403d60 00000000 f6763c00 f64ef340 c0290a8c f73f9538
Nov  2 09:31:39 tikku kernel: [21610.263053]  01442399 00000600 f6b5de00 bf9b04d4 f0ba0460 00000000 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] portmap       S c7e27668     0 16090      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6bfbb8c 00200086 f642bbc0 c7e27668 0100007f c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0ba0810 f0ba0968 c2403d60 00000000 c024aa05 f69a86c0 f27eb980 f0ba0968
Nov  2 09:31:39 tikku kernel: [21610.263053]  c024a95c eec8db40 ef4a448c c037dde8 f27eb980 c036ca74 f6bfbb9c c02368d5
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024aa05>] ? ip_local_deliver+0x7f/0xee
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024a95c>] ? ip_rcv+0x3e0/0x40a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02368d5>] ? netif_receive_skb+0x20c/0x223
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02520d1>] ? tcp_poll+0x18/0x130
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c024cea0>] ? ip_push_pending_frames+0x2b3/0x2bd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288402>] ? _spin_unlock_bh+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eaeb>] ? release_sock+0x8d/0x95
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0265bbf>] ? udp_sendmsg+0x3f7/0x4ed
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0265c14>] ? udp_sendmsg+0x44c/0x4ed
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c026a211>] ? inet_sendmsg+0x3b/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] ? sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8bb9>] ? rb_erase+0x111/0x224
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119cc4>] ? __dequeue_entity+0x73/0x7b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011e4b2>] ? finish_task_switch+0x32/0x7a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028685c>] ? schedule+0x5f3/0x651
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb01c>] ? copy_from_user+0x39/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb01c>] ? copy_from_user+0x39/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d19e>] ? sys_sendmsg+0x13f/0x192
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012bee7>] ? get_signal_to_deliver+0x2f8/0x305
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01021d2>] ? do_notify_resume+0x71/0x781
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015cd78>] ? unmap_region+0xda/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01784cc>] do_restart_poll+0x2e/0x43
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01295bc>] sys_restart_syscall+0x11/0x13
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] migration/1   S 000000be     0 10859      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7069fa8 00000046 e0e6bbe0 000000be 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70577d0 f7057928 c240bd60 00000001 f6a0b4a0 f73f55c0 c240bd60 f7057928
Nov  2 09:31:39 tikku kernel: [21610.263053]  01440f35 00000003 f0133f60 00000286 f7069f8c 00000286 f0133f4c 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011eef2>] migration_thread+0x168/0x1e1
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011ed8a>] ? migration_thread+0x0/0x1e1
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] ksoftirqd/1   S c028840c     0 10860      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f708bfbc 00000046 f708bf54 c028840c f708bf88 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7057420 f7057578 c240bd60 00000001 f708bf74 f73b3d80 00000100 f7057578
Nov  2 09:31:39 tikku kernel: [21610.263053]  00000046 f708bfb0 c012586b c03c3c60 c03c3c60 c03c1438 0000000a 00000001
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012586b>] ? __do_softirq+0x119/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01258e1>] ksoftirqd+0x34/0xc8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01258ad>] ? ksoftirqd+0x0/0xc8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] watchdog/1    S f705738c     0 10861      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f708dfb0 00000046 00000246 f705738c 00000246 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f7057070 f70571c8 c240bd60 00000001 0000104e c0351160 c240c200 f70571c8
Nov  2 09:31:39 tikku kernel: [21610.263053]  010cfeb2 c013556f c240c200 ffffffff 00000246 02048000 00000000 f708dfa0
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013556f>] ? sched_clock_cpu+0x136/0x142
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0146b94>] ? watchdog+0x0/0x1c2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0146bce>] watchdog+0x3a/0x1c2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0146b94>] ? watchdog+0x0/0x1c2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] kondemand/1   S 00000004     0 10862      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f05c9fa8 00000046 f812f731 00000004 c03c4230 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70a53e0 f70a5538 c240bd60 00000001 c01110fe f6b75380 00000004 f70a5538
Nov  2 09:31:39 tikku kernel: [21610.263053]  01452a9b 001e03d4 c240c250 00000246 f64e0a58 00000246 f05c9f94 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f812f731>] ? do_dbs_timer+0x2b4/0x2bd [cpufreq_ondemand]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01110fe>] ? smp_apic_timer_interrupt+0x71/0x7f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] iwl3945/1     S f65b8ea0     0 10863      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6589fa8 00000046 c0231edf f65b8ea0 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f717cbc0 f717cd18 c240bd60 00000001 00000246 f73f57c0 00000000 f717cd18
Nov  2 09:31:39 tikku kernel: [21610.263053]  01262e0a 000007fb f65bc940 00000246 f649fdd8 00000246 00000073 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0231edf>] ? __kfree_skb+0x6c/0x6f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] ata/1         S c028840c     0 10864      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f248bfa8 00000046 f248bf40 c028840c f248bf58 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70a5790 f70a58e8 c240bd60 00000001 f70924a0 c0351160 ffffffff f70a58e8
Nov  2 09:31:39 tikku kernel: [21610.263053]  c03c3d60 c03c3d60 f70a5790 00000246 f6a4d518 00000246 f248bf94 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] aio/1         S c028840c     0 10865      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f250bfa8 00000046 f250bf40 c028840c f250bf58 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f64580b0 f6458208 c240bd60 00000001 f7071bc0 c0351160 ffffffff f6458208
Nov  2 09:31:39 tikku kernel: [21610.263053]  c03c3d60 c03c3d60 f64580b0 00000246 f713f8d8 00000246 f250bf94 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] kblockd/1     S f6a350bc     0 10866      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f02bbfa8 00000046 f73cb810 f6a350bc f736d000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6479030 f6479188 c240bd60 00000001 f02bbf68 f73b3d80 f02bbf74 f6479188
Nov  2 09:31:39 tikku kernel: [21610.263053]  0144b4ce f02bbf8c f73cb8dc 00000246 f70f0fd8 00000246 f02bbf94 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] kstop/1       S c240bd60     0 10867      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f05bffa8 00000046 c028840e c240bd60 f05bff58 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71f80f0 f71f8248 c240bd60 00000001 f6479030 c0351160 ffffffff f71f8248
Nov  2 09:31:39 tikku kernel: [21610.263053]  c03c3d60 c03c3d60 f71f80f0 00000246 f705d8d8 00000246 f05bff94 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840e>] ? _spin_unlock_irq+0xa/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] events/1      S c01290d2     0 10868      2
Nov  2 09:31:39 tikku kernel: [21610.263053]  f05dbfa8 00000046 f05dbf58 c01290d2 01452ef0 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70924a0 f70925f8 c240bd60 00000001 ffffffff f6b75380 f705de40 f70925f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  f05dbf7c c012eeb3 c24096b8 00000246 f705de58 00000246 f05dbf94 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01290d2>] ? __mod_timer+0xc5/0xd0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012eeb3>] ? queue_delayed_work+0x1b/0x1e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131524>] ? prepare_to_wait+0x43/0x48
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e61f>] worker_thread+0x89/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e596>] ? worker_thread+0x0/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c013115d>] kthread+0x3b/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0131122>] ? kthread+0x0/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0103c57>] kernel_thread_helper+0x7/0x10
Nov  2 09:31:39 tikku kernel: [21610.263053] wpa_supplican D f6463200     0 11732      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1c81e04 00000086 00000000 f6463200 f1c81ecc c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6557b80 f6557cd8 c2403d60 00000000 f1c81dd4 f69a8cc0 f65b8240 f6557cd8
Nov  2 09:31:39 tikku kernel: [21610.263053]  0134b141 f1c81ecc f1c81de4 00000286 00000000 f1c81ebc f1c81ecc 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02872bb>] mutex_lock+0x21/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023f044>] rtnl_lock+0xd/0xf
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027a529>] wext_handle_ioctl+0x15f/0x175
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023890b>] dev_ioctl+0x5bc/0x5dc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022db1d>] ? sys_recvfrom+0x7b/0xba
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c4d4>] ? sock_ioctl+0x0/0x1d8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c6a0>] sock_ioctl+0x1cc/0x1d8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c4d4>] ? sock_ioctl+0x0/0x1d8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017719f>] vfs_ioctl+0x22/0x69
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177593>] do_vfs_ioctl+0x3ad/0x3de
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177db0>] ? poll_select_copy_remaining+0xa0/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177604>] sys_ioctl+0x40/0x5a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] wpa_cli       S f0599f18     0 11770      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0599f34 00200086 c01af928 f0599f18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f73f9030 f73f9188 c2403d60 00000000 c240bda8 f73f53c0 f0599f14 f73f9188
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707f87c a4ad6ddf 000000bf f707f87c f707f850 00000000 f73f9030 f0599f78
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123b31>] ? do_wait+0xca/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] sshd          S 000001e2     0 11870      1
Nov  2 09:31:39 tikku kernel: [21610.263053]  f06afb00 00000082 f06afaa8 000001e2 00000246 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0ba00b0 f0ba0208 c240bd60 00000001 f6d37580 f6a32640 f06afad4 f0ba0208
Nov  2 09:31:39 tikku kernel: [21610.263053]  f69a9000 f69a9000 00000000 d51ced04 c7e27668 f06afb24 f84f7252 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02520d1>] ? tcp_poll+0x18/0x130
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01789b1>] do_select+0x4d0/0x537
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313ce>] ? wake_up_bit+0x5c/0x61
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852d32f>] ? __ext3_get_inode_loc+0xc5/0x29d [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0187bf8>] ? __block_prepare_write+0x20b/0x336
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f8537935>] ? __ext3_journal_dirty_metadata+0x19/0x3c [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119abe>] ? __wake_up+0x31/0x3b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f6a53>] ? journal_stop+0x16e/0x179 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f852e317>] ? ext3_ordered_write_end+0x114/0x123 [ext3]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cdb7>] ? find_lock_page+0x2d/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014d3e7>] ? filemap_fault+0x1cb/0x312
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014cccb>] ? unlock_page+0x3e/0x41
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01594b3>] ? __do_fault+0x2ef/0x327
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178bd5>] core_sys_select+0x1bd/0x2ab
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0115ab8>] ? do_page_fault+0x2f8/0x63c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01513f6>] ? __pagevec_free+0x1d/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0153ac1>] ? release_pages+0x16d/0x175
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01621d6>] ? free_pages_and_swap_cache+0x65/0x7e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015cd78>] ? unmap_region+0xda/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178e94>] sys_select+0x6e/0x8c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] wpa_action    S f1c3ff18     0 13846  11770
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1c3ff34 00200082 c01af928 f1c3ff18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f707f850 f707f9a8 c240bd60 00000001 c2403da8 f7375140 355f509e f707f9a8
Nov  2 09:31:39 tikku kernel: [21610.263053]  013446d9 c2403d60 f70b1b40 c2403da8 f70b1b40 00000000 f707f850 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] ifdown        S f0653f18     0 13852  13846
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0653f34 00200086 c01af928 f0653f18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f70b1b40 f70b1c98 c2403d60 00000000 c240bda8 f7343700 b2c0b990 f70b1c98
Nov  2 09:31:39 tikku kernel: [21610.263053]  0134475b c240bd60 f71fe7d0 c240bda8 f71fe7d0 00000000 f70b1b40 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] ifconfig      D 00000000     0 13903  13852
Nov  2 09:31:39 tikku kernel: [21610.263053]  f246bd48 00200082 c2403d60 00000000 c2400dd8 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f71fe7d0 f71fe928 c240bd60 00000001 c03c3d60 f6a4f680 f71fe7d0 f71fe928
Nov  2 09:31:39 tikku kernel: [21610.263053]  01344761 f7057420 c7c46f28 c7c46f44 c03c13fc c03c3d60 c03c3d60 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286b1e>] schedule_timeout+0x17/0xbc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c014c9c0>] ? find_get_page+0x1d/0x81
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286a16>] wait_for_common+0xbc/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0286ade>] wait_for_completion+0x12/0x14
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012ea9a>] __cancel_work_timer+0x10a/0x151
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012e780>] ? wq_barrier_func+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c012eaf8>] cancel_work_sync+0xa/0xc
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f83ae58a>] ieee80211_stop+0x288/0x3c7 [mac80211]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0237a9b>] dev_close+0x76/0x95
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02377b6>] dev_change_flags+0xa2/0x157
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0269b36>] devinet_ioctl+0x21a/0x514
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c026a961>] inet_ioctl+0x8e/0xa7
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c688>] sock_ioctl+0x1b4/0x1d8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c4d4>] ? sock_ioctl+0x0/0x1d8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017719f>] vfs_ioctl+0x22/0x69
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177593>] do_vfs_ioctl+0x3ad/0x3de
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016b7c7>] ? fd_install+0x44/0x4a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0127916>] ? cap_set_effective+0x43/0x4d
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016c2ea>] ? sys_faccessat+0x169/0x173
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177604>] sys_ioctl+0x40/0x5a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] xpdf.bin      S 00000246     0 14037   5265
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0747b8c 00000082 f70acbc0 00000246 f0747c00 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f642b460 f642b5b8 c2403d60 00000000 f0747b54 f64ef540 00000001 f642b5b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  014076ae c0177f06 00000000 00000008 f0747e70 f1cfb3c0 f0747e44 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0177f06>] ? poll_freewait+0x2f/0x78
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02875cf>] schedule_hrtimeout_range+0x34/0x12c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01315c0>] ? add_wait_queue+0x2f/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178f5f>] ? __pollwait+0xad/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c027430f>] ? unix_poll+0x17/0x96
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c017826e>] do_sys_poll+0x31f/0x3c0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178eb2>] ? __pollwait+0x0/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0151a69>] ? __alloc_pages_internal+0xb0/0x37f
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01c8a3e>] ? rb_insert_color+0x56/0xc0
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119e17>] ? __enqueue_entity+0xe3/0xeb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011a0d1>] ? enqueue_task_fair+0xa0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011c9ab>] ? check_preempt_wakeup+0x92/0xb6
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0c8>] ? try_to_wake_up+0x16a/0x174
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0dd>] ? default_wake_function+0xb/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119400>] ? __wake_up_common+0x35/0x5b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0119a83>] ? __wake_up_sync+0x3a/0x44
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287292>] ? __mutex_lock_slowpath+0x19d/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0287599>] ? mutex_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0275cb8>] ? unix_stream_recvmsg+0x3dc/0x49e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022c926>] ? sock_aio_read+0x104/0x112
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] ? do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c028840c>] ? _spin_unlock_irq+0x8/0xb
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0178454>] sys_poll+0x40/0x8a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0125158>] ? sys_gettimeofday+0x2b/0x58
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] rep           S f694d0f0     0 14038   3542
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1c99e4c 00000086 00000000 f694d0f0 f1c99dfc c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f694d0f0 f694d248 c240bd60 00000001 00000001 f641bb00 c240bd60 f694d248
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2477c38 f24ca604 00000001 00000246 f24ca200 f24ca200 f1c99e44 00000246
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172904>] pipe_wait+0x53/0x75
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0172fd3>] pipe_read+0x2a1/0x2fe
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cfac>] do_sync_read+0xab/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0128a6f>] ? run_timer_softirq+0x193/0x19b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af6e6>] ? security_file_permission+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016cf01>] ? do_sync_read+0x0/0xe9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d847>] vfs_read+0x87/0x101
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c016d95a>] sys_read+0x3b/0x60
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
Nov  2 09:31:39 tikku kernel: [21610.263053] git-pull      S f0133f18     0 14074   4103
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0133f34 00200082 c01af928 f0133f18 c01233a2 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f6a0b4a0 f6a0b5f8 c240bd60 00000001 c2403da8 f6a4fa80 f0133f14 f6a0b5f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  014410ed eb9a9fa5 000000be f0ba0bec f0ba0bc0 00000000 f6a0b4a0 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01af928>] ? security_task_wait+0xf/0x11
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01233a2>] ? wait_consider_task+0x66/0x72b
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123c16>] do_wait+0x1af/0x285
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c011d0d2>] ? default_wake_function+0x0/0xd
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d6a>] sys_wait4+0x7e/0x94
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0123d93>] sys_waitpid+0x13/0x15
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] git-fetch     D f84f7252     0 14088  14074
Nov  2 09:31:39 tikku kernel: [21610.263053]  f1db3d1c 00200086 f1db3cf4 f84f7252 00000000 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0ba0bc0 f0ba0d18 c240bd60 00000001 b80ef080 f73f55c0 00000000 f0ba0d18
Nov  2 09:31:39 tikku kernel: [21610.263053]  01441134 00000400 00030001 00200282 f69a90d4 00000287 00000078 00000000
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<f84f7252>] ? do_get_write_access+0x3ba/0x3f2 [jbd]
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02872bb>] mutex_lock+0x21/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023f056>] rtnetlink_rcv+0x10/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0244fca>] netlink_unicast+0x1a9/0x20a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0245263>] netlink_sendmsg+0x238/0x245
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015a840>] ? handle_mm_fault+0x25b/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb01c>] ? copy_from_user+0x39/0x121
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d295>] sys_sendto+0xa4/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d910>] ? move_addr_to_user+0x3b/0x52
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022dc45>] ? sys_getsockname+0x59/0x76
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c018df67>] ? inotify_d_instantiate+0x38/0x3c
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01afaf2>] ? security_d_instantiate+0x1c/0x1e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288427>] ? _spin_unlock+0x8/0xa
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022df0c>] sys_socketcall+0xda/0x17e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053] ip            D 02625a00     0 14089   8381
Nov  2 09:31:39 tikku kernel: [21610.263053]  f2511d04 00200082 00000343 02625a00 c240bda8 c03c13fc c03c3d60 c03c3d60
Nov  2 09:31:39 tikku kernel: [21610.263053]  f0ba0460 f0ba05b8 c240bd60 00000001 d2d65010 f6b75b80 000f4240 f0ba05b8
Nov  2 09:31:39 tikku kernel: [21610.263053]  c01368ab f2511cfc 015804d6 f2511ce0 c01109fd f2511d08 c01392b1 02a90e2a
Nov  2 09:31:39 tikku kernel: [21610.263053] Call Trace:
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01368ab>] ? getnstimeofday+0x37/0xb9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01109fd>] ? lapic_next_event+0x13/0x17
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01392b1>] ? clockevents_program_event+0xd4/0xe3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02871e4>] __mutex_lock_slowpath+0xef/0x1a5
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02872bb>] mutex_lock+0x21/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c023f056>] rtnetlink_rcv+0x10/0x24
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0244fca>] netlink_unicast+0x1a9/0x20a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0245263>] netlink_sendmsg+0x238/0x245
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d044>] sock_sendmsg+0xde/0xf9
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01313d3>] ? autoremove_wake_function+0x0/0x33
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c015a840>] ? handle_mm_fault+0x25b/0x4f8
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d295>] sys_sendto+0xa4/0xc3
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c01cb13f>] ? copy_to_user+0x3b/0x10a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d910>] ? move_addr_to_user+0x3b/0x52
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022dc45>] ? sys_getsockname+0x59/0x76
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0288402>] ? _spin_unlock_bh+0x10/0x12
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022eaeb>] ? release_sock+0x8d/0x95
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022ee5d>] ? sock_def_write_space+0x7b/0x80
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c02301a4>] ? sock_setsockopt+0x4e8/0x4f2
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022d2cc>] sys_send+0x18/0x1a
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c022def7>] sys_socketcall+0xc5/0x17e
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0102ea5>] sysenter_do_call+0x12/0x25
Nov  2 09:31:39 tikku kernel: [21610.263053]  [<c0280000>] ? pci_fixup_msi_k8t_onboard_sound+0x45/0x98
