Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:50102 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdJJHoT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 03:44:19 -0400
Date: Tue, 10 Oct 2017 09:44:14 +0200
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: 4.14.0-rc3 iwlwifi: Hardware became unavailable during restart
Message-ID: <20171010074414.x3uqv27prkqov45v@macchiaveli> (sfid-20171010_094441_939369_311684DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've got this splat after a couple of suspend-resume cycles on my
HP-laptop. I haven't had the time to bisect or test other rcs for now.
Pasting some logs before the actual WARN_ON, as they may be relevant.
Just after the splat the connection is successfully reestablished.

[14293.758404] iwlwifi 0000:24:00.0: Error sending REPLY_SCAN_ABORT_CMD: 
time out after 2000ms.
[14293.758429] iwlwifi 0000:24:00.0: Current CMD queue read_ptr 67 write_ptr 68
[14293.758518] iwlwifi 0000:24:00.0: Loaded firmware version: 18.168.6.1
[14293.758734] iwlwifi 0000:24:00.0: 0x00000000 | OK                          
[14293.758740] iwlwifi 0000:24:00.0: 0x00000000 | uPc
[14293.758746] iwlwifi 0000:24:00.0: 0x00000000 | branchlink1
[14293.758750] iwlwifi 0000:24:00.0: 0x00000000 | branchlink2
[14293.758756] iwlwifi 0000:24:00.0: 0x00000000 | interruptlink1
[14293.758762] iwlwifi 0000:24:00.0: 0x00000000 | interruptlink2
[14293.758767] iwlwifi 0000:24:00.0: 0x00000000 | data1
[14293.758773] iwlwifi 0000:24:00.0: 0x00000000 | data2
[14293.758778] iwlwifi 0000:24:00.0: 0x00000000 | line
[14293.758784] iwlwifi 0000:24:00.0: 0x00000000 | beacon time
[14293.758789] iwlwifi 0000:24:00.0: 0x00000000 | tsf low
[14293.758795] iwlwifi 0000:24:00.0: 0x00000000 | tsf hi
[14293.758800] iwlwifi 0000:24:00.0: 0x00000000 | time gp1
[14293.758805] iwlwifi 0000:24:00.0: 0x00000000 | time gp2
[14293.758810] iwlwifi 0000:24:00.0: 0x00000000 | time gp3
[14293.758816] iwlwifi 0000:24:00.0: 0x00000000 | uCode version
[14293.758821] iwlwifi 0000:24:00.0: 0x00000000 | hw version
[14293.758827] iwlwifi 0000:24:00.0: 0x00000000 | board version
[14293.758833] iwlwifi 0000:24:00.0: 0x00000000 | hcmd
[14293.758838] iwlwifi 0000:24:00.0: 0x00000000 | isr0
[14293.758844] iwlwifi 0000:24:00.0: 0x00000000 | isr1
[14293.758850] iwlwifi 0000:24:00.0: 0x00000000 | isr2
[14293.758855] iwlwifi 0000:24:00.0: 0x00000000 | isr3
[14293.758861] iwlwifi 0000:24:00.0: 0x00000000 | isr4
[14293.758866] iwlwifi 0000:24:00.0: 0x00000000 | isr_pref
[14293.758872] iwlwifi 0000:24:00.0: 0x00000000 | wait_event
[14293.758877] iwlwifi 0000:24:00.0: 0x00000000 | l2p_control
[14293.758882] iwlwifi 0000:24:00.0: 0x00000000 | l2p_duration
[14293.758888] iwlwifi 0000:24:00.0: 0x00000000 | l2p_mhvalid
[14293.758894] iwlwifi 0000:24:00.0: 0x00000000 | l2p_addr_match
[14293.758899] iwlwifi 0000:24:00.0: 0x00000000 | lmpm_pmg_sel
[14293.758905] iwlwifi 0000:24:00.0: 0x00000000 | timestamp
[14293.758911] iwlwifi 0000:24:00.0: 0x00000000 | flow_handler
[14293.759009] iwlwifi 0000:24:00.0: Start IWL Event Log Dump: nothing in log
[14293.759028] iwlwifi 0000:24:00.0: Command REPLY_RXON failed: FW Error
[14293.759034] iwlwifi 0000:24:00.0: Error clearing ASSOC_MSK on BSS (-5)
[14293.771378] ieee80211 phy0: Hardware restart was requested
[14293.777841] iwlwifi 0000:24:00.0: Radio type=0x1-0x2-0x0
[14294.082086] iwlwifi 0000:24:00.0: Radio type=0x1-0x2-0x0
[14294.184741] IPv6: ADDRCONF(NETDEV_UP): wlo1: link is not ready
[14294.191364] iwlwifi 0000:24:00.0: Radio type=0x1-0x2-0x0
[14299.198235] iwlwifi 0000:24:00.0: Failed to load firmware chunk!
[14299.198255] iwlwifi 0000:24:00.0: Could not load the [0] uCode section
[14299.210483] iwlwifi 0000:24:00.0: Failed to run INIT ucode: -110
[14299.210534] iwlwifi 0000:24:00.0: Unable to initialize device.
[14299.210537] Hardware became unavailable during restart.
[14299.210582] ------------[ cut here ]------------
[14299.210639] WARNING: CPU: 2 PID: 13367 at net/mac80211/util.c:1866 ieee80211_reconfig+0x415/0x1f50 [mac80211]
[14299.210640] Modules linked in: bridge stp llc cuse vhost_net tun vhost tap fuse btrfs xor zstd_decompress zstd_compress xxhash zlib_deflate raid6_pq ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_addrtype iptable_nat nf_nat_ipv4 nf_nat uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 x86_pkg_temp_thermal kvm_intel videobuf2_core kvm irqbypass iwldvm crc32_pclmul mac80211 iwlwifi input_leds cfg80211 rfkill i915 button ext4 mbcache jbd2 fscrypto ahci libahci libata ehci_pci ehci_hcd
[14299.210678] CPU: 2 PID: 13367 Comm: kworker/2:1 Not tainted 4.14.0-rc3+ #2
[14299.210680] Hardware name: Hewlett-Packard HP EliteBook 2560p/162B, BIOS 68SSU Ver. F.02 07/26/2011
[14299.210717] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[14299.210720] task: ffff8801f0ece740 task.stack: ffff8801f1d78000
[14299.210757] RIP: 0010:ieee80211_reconfig+0x415/0x1f50 [mac80211]
[14299.210759] RSP: 0018:ffff8801f1d7fc78 EFLAGS: 00010282
[14299.210761] RAX: 000000000000002b RBX: ffff8801f2c28c16 RCX: 0000000000000000
[14299.210763] RDX: 000000000000002b RSI: dffffc0000000000 RDI: ffffed003e3aff85
[14299.210765] RBP: ffff8801f1d7fda8 R08: fffffbfff05924fb R09: ffffffff82c927d7
[14299.210767] R10: ffff8801f2c2a632 R11: fffffbfff05924fb R12: ffff8801f2c28fb8
[14299.210768] R13: ffff8801f2c293d8 R14: ffff8801f2c28780 R15: ffff8801f2c28780
[14299.210770] FS:  0000000000000000(0000) GS:ffff8801f5c80000(0000) knlGS:0000000000000000
[14299.210772] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14299.210773] CR2: 00007fce94113019 CR3: 00000001efe42004 CR4: 00000000000606e0
[14299.210774] Call Trace:
[14299.210781]  ? get_work_pool+0x12/0x50
[14299.210783]  ? get_work_pool+0x12/0x50
[14299.210786]  ? flush_work+0x8a/0x2b0
[14299.210788]  ? work_busy+0xe0/0xe0
[14299.210828]  ? ieee80211_stop_device+0x60/0x60 [mac80211]
[14299.210864]  ieee80211_restart_work+0xc2/0xf0 [mac80211]
[14299.210867]  process_one_work+0x3f2/0x760
[14299.210872]  worker_thread+0x90/0x710
[14299.210876]  kthread+0x18c/0x1e0
[14299.210879]  ? trace_event_raw_event_workqueue_work+0x120/0x120
[14299.210881]  ? kthread_create_on_node+0xb0/0xb0
[14299.210884]  ret_from_fork+0x22/0x30
[14299.210887] Code: e0 41 c6 87 94 04 00 00 00 4c 89 ff e8 45 72 fa ff 85 c0 89 85 70 ff ff ff 0f 84 ac 01 00 00 48 c7 c7 20 a0 71 a0 e8 5c 50 a5 e0 <0f> ff e9 35 fd ff ff 48 89 df e8 3c 6c 03 00 e9 9d fe ff ff 4d 
[14299.210924] ---[ end trace 5ddc2533368c0064 ]---
[14299.211014] wlo1:  Failed check-sdata-in-driver check, flags: 0x0
[14299.211045] ------------[ cut here ]------------
[14299.211102] WARNING: CPU: 2 PID: 13367 at net/mac80211/driver-ops.h:17 drv_remove_interface+0x1b3/0x1c0 [mac80211]
[14299.211104] Modules linked in: bridge stp llc cuse vhost_net tun vhost tap fuse btrfs xor zstd_decompress zstd_compress xxhash zlib_deflate raid6_pq ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_addrtype iptable_nat nf_nat_ipv4 nf_nat uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 x86_pkg_temp_thermal kvm_intel videobuf2_core kvm irqbypass iwldvm crc32_pclmul mac80211 iwlwifi input_leds cfg80211 rfkill i915 button ext4 mbcache jbd2 fscrypto ahci libahci libata ehci_pci ehci_hcd
[14299.211138] CPU: 2 PID: 13367 Comm: kworker/2:1 Tainted: G        W       4.14.0-rc3+ #2
[14299.211140] Hardware name: Hewlett-Packard HP EliteBook 2560p/162B, BIOS 68SSU Ver. F.02 07/26/2011
[14299.211173] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[14299.211175] task: ffff8801f0ece740 task.stack: ffff8801f1d78000
[14299.211209] RIP: 0010:drv_remove_interface+0x1b3/0x1c0 [mac80211]
[14299.211210] RSP: 0018:ffff8801f1d7f888 EFLAGS: 00010282
[14299.211212] RAX: 0000000000000035 RBX: 0000000000000000 RCX: 0000000000000000
[14299.211214] RDX: 0000000000000035 RSI: dffffc0000000000 RDI: ffffed003e3aff07
[14299.211215] RBP: ffff8801f1d7f8b0 R08: fffffbfff0592651 R09: ffffffff82c93285
[14299.211217] R10: ffff8801f5ca094b R11: fffffbfff0592651 R12: ffff8801f32fab40
[14299.211218] R13: ffff8801f2c28780 R14: ffff8801f2c28f10 R15: ffff8801f32fab30
[14299.211220] FS:  0000000000000000(0000) GS:ffff8801f5c80000(0000) knlGS:0000000000000000
[14299.211222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14299.211223] CR2: 00007fce94113019 CR3: 00000001efe42004 CR4: 00000000000606e0
[14299.211224] Call Trace:
[14299.211260]  ieee80211_do_stop+0x8fd/0xeb0 [mac80211]
[14299.211264]  ? inetdev_event+0x9e/0x730
[14299.211300]  ? ieee80211_add_virtual_monitor+0x3e0/0x3e0 [mac80211]
[14299.211303]  ? preempt_count_sub+0x18/0xc0
[14299.211306]  ? __local_bh_enable_ip+0x3e/0x70
[14299.211308]  ? preempt_count_sub+0x18/0xc0
[14299.211311]  ? __local_bh_enable_ip+0x3e/0x70
[14299.211314]  ? _raw_spin_unlock_bh+0x23/0x30
[14299.211317]  ? dev_deactivate_many+0x335/0x370
[14299.211352]  ieee80211_stop+0x1a/0x20 [mac80211]
[14299.211356]  __dev_close_many+0xfe/0x190
[14299.211359]  ? call_netdevice_notifiers+0x70/0x70
[14299.211362]  ? do_trap+0xd6/0x1e0
[14299.211365]  dev_close_many+0x158/0x2a0
[14299.211368]  ? netdev_notify_peers+0xa0/0xa0
[14299.211371]  ? vprintk_emit+0x271/0x2b0
[14299.211373]  dev_close.part.100+0x9d/0xe0
[14299.211376]  ? dev_close_many+0x2a0/0x2a0
[14299.211378]  ? do_invalid_op+0x20/0x30
[14299.211381]  ? invalid_op+0x18/0x20
[14299.211383]  dev_close+0x2a/0x30
[14299.211424]  cfg80211_shutdown_all_interfaces+0x54/0xe0 [cfg80211]
[14299.211462]  ieee80211_handle_reconfig_failure+0x11f/0x140 [mac80211]
[14299.211500]  ieee80211_reconfig+0x159/0x1f50 [mac80211]
[14299.211503]  ? get_work_pool+0x12/0x50
[14299.211505]  ? get_work_pool+0x12/0x50
[14299.211507]  ? flush_work+0x8a/0x2b0
[14299.211510]  ? work_busy+0xe0/0xe0
[14299.211547]  ? ieee80211_stop_device+0x60/0x60 [mac80211]
[14299.211582]  ieee80211_restart_work+0xc2/0xf0 [mac80211]
[14299.211584]  process_one_work+0x3f2/0x760
[14299.211588]  worker_thread+0x90/0x710
[14299.211591]  kthread+0x18c/0x1e0
[14299.211594]  ? trace_event_raw_event_workqueue_work+0x120/0x120
[14299.211596]  ? kthread_create_on_node+0xb0/0xb0
[14299.211599]  ret_from_fork+0x22/0x30
[14299.211601] Code: 24 e0 01 00 00 49 81 c4 00 02 00 00 e8 f7 23 c4 e0 49 8b 74 24 e0 89 da 48 c7 c7 e0 4c 71 a0 48 85 f6 49 0f 44 f4 e8 3e d5 aa e0 <0f> ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 66 66 66 90 55 48 89 
[14299.211638] ---[ end trace 5ddc2533368c0065 ]---
[14299.211665] ------------[ cut here ]------------
[14299.211699] WARNING: CPU: 2 PID: 13367 at net/mac80211/driver-ops.c:39 drv_stop+0x1a9/0x1c0 [mac80211]
[14299.211699] Modules linked in: bridge stp llc cuse vhost_net tun vhost tap fuse btrfs xor zstd_decompress zstd_compress xxhash zlib_deflate raid6_pq ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_addrtype iptable_nat nf_nat_ipv4 nf_nat uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 x86_pkg_temp_thermal kvm_intel videobuf2_core kvm irqbypass iwldvm crc32_pclmul mac80211 iwlwifi input_leds cfg80211 rfkill i915 button ext4 mbcache jbd2 fscrypto ahci libahci libata ehci_pci ehci_hcd
[14299.211729] CPU: 2 PID: 13367 Comm: kworker/2:1 Tainted: G        W       4.14.0-rc3+ #2
[14299.211731] Hardware name: Hewlett-Packard HP EliteBook 2560p/162B, BIOS 68SSU Ver. F.02 07/26/2011
[14299.211763] Workqueue: events_freezable ieee80211_restart_work [mac80211]
[14299.211765] task: ffff8801f0ece740 task.stack: ffff8801f1d78000
[14299.211798] RIP: 0010:drv_stop+0x1a9/0x1c0 [mac80211]
[14299.211800] RSP: 0018:ffff8801f1d7f878 EFLAGS: 00010246
[14299.211802] RAX: 0000000000000000 RBX: ffff8801f2c28780 RCX: ffffffffa0665f72
[14299.211803] RDX: 1ffff1003e585182 RSI: dffffc0000000000 RDI: ffff8801f2c28c14
[14299.211805] RBP: ffff8801f1d7f898 R08: 0000000000000000 R09: 0000000000000000
[14299.211806] R10: ffff8801f1d7f8a8 R11: fffffbfff0592651 R12: ffff8801f2c28780
[14299.211808] R13: ffff8801f2c28c14 R14: ffff8801f2c28f10 R15: 0000000000000010
[14299.211809] FS:  0000000000000000(0000) GS:ffff8801f5c80000(0000) knlGS:0000000000000000
[14299.211811] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14299.211812] CR2: 00007fce94113019 CR3: 00000001efe42004 CR4: 00000000000606e0
[14299.211813] Call Trace:
[14299.211851]  ieee80211_stop_device+0x4f/0x60 [mac80211]
[14299.211887]  ieee80211_do_stop+0x8e0/0xeb0 [mac80211]
[14299.211889]  ? inetdev_event+0x9e/0x730
[14299.211926]  ? ieee80211_add_virtual_monitor+0x3e0/0x3e0 [mac80211]
[14299.211928]  ? preempt_count_sub+0x18/0xc0
[14299.211930]  ? __local_bh_enable_ip+0x3e/0x70
[14299.211932]  ? preempt_count_sub+0x18/0xc0
[14299.211935]  ? __local_bh_enable_ip+0x3e/0x70
[14299.211938]  ? _raw_spin_unlock_bh+0x23/0x30
[14299.211940]  ? dev_deactivate_many+0x335/0x370
[14299.211976]  ieee80211_stop+0x1a/0x20 [mac80211]
[14299.211979]  __dev_close_many+0xfe/0x190
[14299.211982]  ? call_netdevice_notifiers+0x70/0x70
[14299.211984]  ? do_trap+0xd6/0x1e0
[14299.211987]  dev_close_many+0x158/0x2a0
[14299.211990]  ? netdev_notify_peers+0xa0/0xa0
[14299.211992]  ? vprintk_emit+0x271/0x2b0
[14299.211995]  dev_close.part.100+0x9d/0xe0
[14299.211997]  ? dev_close_many+0x2a0/0x2a0
[14299.212000]  ? do_invalid_op+0x20/0x30
[14299.212002]  ? invalid_op+0x18/0x20
[14299.212004]  dev_close+0x2a/0x30
[14299.212037]  cfg80211_shutdown_all_interfaces+0x54/0xe0 [cfg80211]
[14299.212075]  ieee80211_handle_reconfig_failure+0x11f/0x140 [mac80211]
[14299.212112]  ieee80211_reconfig+0x159/0x1f50 [mac80211]
[14299.212115]  ? get_work_pool+0x12/0x50
[14299.212117]  ? get_work_pool+0x12/0x50
[14299.212119]  ? flush_work+0x8a/0x2b0
[14299.212122]  ? work_busy+0xe0/0xe0
[14299.212159]  ? ieee80211_stop_device+0x60/0x60 [mac80211]
[14299.212193]  ieee80211_restart_work+0xc2/0xf0 [mac80211]
[14299.212196]  process_one_work+0x3f2/0x760
[14299.212200]  worker_thread+0x90/0x710
[14299.212203]  kthread+0x18c/0x1e0
[14299.212206]  ? trace_event_raw_event_workqueue_work+0x120/0x120
[14299.212208]  ? kthread_create_on_node+0xb0/0xb0
[14299.212211]  ret_from_fork+0x22/0x30
[14299.212213] Code: 41 ff d6 4c 89 e7 e8 97 29 c4 e0 4d 8b 34 24 4d 85 f6 75 d6 65 ff 0d e7 f2 9a 5f 0f 85 bf fe ff ff e8 89 b7 99 e0 e9 b5 fe ff ff <0f> ff 5b 41 5c 41 5d 41 5e 5d c3 66 90 66 2e 0f 1f 84 00 00 00 
[14299.212250] ---[ end trace 5ddc2533368c0066 ]---
