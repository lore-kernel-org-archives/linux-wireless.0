Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58538 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403788AbeHASYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 14:24:15 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath10k:  fix use-after-free of netbufs_ring
Date: Wed,  1 Aug 2018 09:37:36 -0700
Message-Id: <1533141456-3026-1-git-send-email-greearb@candelatech.com> (sfid-20180801_183824_093465_EFDC8404)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When firmware crashes on startup, the htt logic may
be stopped twice, leading to use-after free and/or
double-free problems.

This is from my 4.16 tree, which has my own changes as well as
some patches cherry-picked from upstream.

Firmware is modified 10.4 on 9984, but no firmware should cause
the driver to crash, so firmware is mostly of no concern.

I added a WARN_ON in the ath10k_htt_rx_free and a bit of printk
debugging to help understand how this happens.  Here is the log
of the call path.  The WARN_ON is the first rx_free, the BUG
is the second one.  With this patch, it has survived multiple
crashes of the firmware on startup without trouble.

[  132.560515] ath10k_pci 0000:04:00.0: htt-rx-alloc, htt rx ring size 2048 fill_level 1023  netbufs_ring: 000000007e01aa60
[  132.570374] ath10k_pci 0000:04:00.0: boot hif start
[  132.576061] ath10k_pci 0000:04:00.0: boot htc service HTT Data does not allocate target credits
[  132.576160] ath10k_pci 0000:04:00.0: boot htc service 'HTT Data' ul pipe 4 dl pipe 5 eid 1 ready
[  132.576163] ath10k_pci 0000:04:00.0: boot htc service 'HTT Data' eid 1 TX flow control disabled
[  132.576869] ath10k_pci 0000:04:00.0: boot htc service 'WMI' ul pipe 3 dl pipe 2 eid 2 ready
[  132.577693] ath10k_pci 0000:04:00.0: firmware 10.4-ct-9984-xtH-004-cf82bd4 booted
[  132.577716] ath10k_pci 0000:04:00.0: 10.4 wmi init: vdevs: 4  peers: 64  tid: 156
[  132.577719] ath10k_pci 0000:04:00.0: using rx swcrypt
[  132.577722] ath10k_pci 0000:04:00.0: using 7 firmware rate-ctrl objects
[  132.577725] ath10k_pci 0000:04:00.0: msdu-desc: 2200  skid: 60
[  132.582645] e1000e: eth5 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[  132.652834] ath10k_pci 0000:04:00.0: wmi print 'P 64 V 4 T 238'
[  132.652871] ath10k_pci 0000:04:00.0: wmi print 'msdu-desc: 2200  sw-crypt: 1'
[  132.653499] ath10k_pci 0000:04:00.0: wmi print 'free: 65288 iram: 5108 sram: 19380'
[  132.654306] ath10k_pci 0000:04:00.0: htt target version 2.2
[  132.981802] ath10k_pci 0000:04:00.0: firmware crashed! (guid 90d614c4-915e-4d23-9929-e5fb1da30789)
[  132.989839] ath10k_pci 0000:04:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_id 0x00000000 sub 168c:cafe
[  132.989845] ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
[  132.990776] ath10k_pci 0000:04:00.0: firmware ver 10.4-ct-9984-xtH-004-cf82bd4 api 5 features peer-flow-ctrl,txstatus-noack,wmi-10.x-CT,rxswcrypt-CT8
[  132.991007] ath10k_pci 0000:04:00.0: board_file api 2 bmi_id 0:31 crc32 e807b522
[  132.991011] ath10k_pci 0000:04:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal otp max-sta 64 raw 0 hwcrypto 1
[  132.993057] ath10k_pci 0000:04:00.0: firmware register dump:

*** snip ***

[  133.546095] igb 0000:01:00.3 eth3: igb: eth3 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[  133.546343] ath10k_pci 0000:04:00.0: failed to update channel list: -108
[  133.546375] ath10k_pci 0000:04:00.0: failed to set pdev regdomain: -108
[  133.546401] ath10k_pci 0000:04:00.0: failed to set quiet mode period 100 duarion 0 enabled 0 ret -108
[  133.546475] ath10k_pci 0000:04:00.0: failed to create WMI vdev 0: -108
[  133.553696] ath10k_pci 0000:04:00.0: boot hif stop
[  133.553756] ath10k_pci 0000:04:00.0: boot qca99x0 chip reset
[  133.553759] ath10k_pci 0000:04:00.0: boot cold reset
[  133.597554] ath10k_pci 0000:04:00.0: boot cold reset complete
[  133.597559] ath10k_pci 0000:04:00.0: boot waiting target to initialise
[  133.597564] ath10k_pci 0000:04:00.0: boot target indicator 2
[  133.597570] ath10k_pci 0000:04:00.0: boot target initialised
[  133.597572] ath10k_pci 0000:04:00.0: boot qca99x0 chip reset complete (cold)
[  133.606567] htt-rx-free, ring-sz: 16384  vaddr: 00000000731130b3  base_paddr: 4275339264
[  133.615109] htt-rx-free, sizeof vaddr: 4 vaddr: 0000000095a6e617  paddr: 4280053760  netbufs_ring: 000000007e01aa60
[  133.625808] WARNING: CPU: 3 PID: 289 at /home/greearb/git/linux-4.16.dev.y/drivers/net/wireless/ath/ath10k/htt_rx.c:304 ath10k_htt_rx_free+0x33e/0x7]
[  133.625810] Modules linked in: bonding veth vrf 8021q garp mrp stp llc fuse macvlan pktgen nfsv3 nfs fscache snd_hda_codec_hdmi iTCO_wdt iTCO_vendort
[  133.625914] CPU: 3 PID: 289 Comm: kworker/u8:3 Tainted: G        W        4.16.18+ #24
[  133.625915] Hardware name: _ _/, BIOS 5.11 08/26/2016
[  133.625927] Workqueue: ath10k_wq ath10k_core_restart [ath10k_core]
[  133.625939] RIP: 0010:ath10k_htt_rx_free+0x33e/0x740 [ath10k_core]
[  133.625941] RSP: 0018:ffff880143dcfc98 EFLAGS: 00010286
[  133.625945] RAX: 0000000000000067 RBX: ffff880140b84fe8 RCX: 0000000000000000
[  133.625947] RDX: 0000000000000067 RSI: ffff88014df9f718 RDI: ffffed00287b9f89
[  133.625949] RBP: ffff880140b85110 R08: 0000000000000001 R09: 0000000000000000
[  133.625950] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880140b85118
[  133.625953] R13: ffff880140b85060 R14: ffff880171d9c000 R15: ffff880171d9c000
[  133.625955] FS:  0000000000000000(0000) GS:ffff88014df80000(0000) knlGS:0000000000000000
[  133.625957] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.625959] CR2: 0000556f59a470f8 CR3: 0000000003a14005 CR4: 00000000003606e0
[  133.625961] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.625963] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.625964] Call Trace:
[  133.625980]  ath10k_core_stop+0x127/0x180 [ath10k_core]
[  133.625990]  ath10k_halt+0x3d0/0x630 [ath10k_core]
[  133.626003]  ath10k_core_restart+0x166/0x230 [ath10k_core]
[  133.626024]  process_one_work+0x5f7/0x14d0
[  133.626033]  ? pwq_dec_nr_in_flight+0x2b0/0x2b0
[  133.626039]  ? _raw_spin_unlock_irq+0x24/0x40
[  133.626046]  worker_thread+0xdc/0x12d0
[  133.626059]  ? rescuer_thread+0x12b0/0x12b0
[  133.626062]  kthread+0x2cf/0x3c0
[  133.626065]  ? kthread_delayed_work_timer_fn+0x1e0/0x1e0
[  133.626070]  ret_from_fork+0x24/0x30
[  133.626081] Code: 00 00 48 89 ea 48 c1 ea 03 80 3c 02 00 0f 85 5d 02 00 00 48 8b 93 28 01 00 00 be 04 00 00 00 48 c7 c7 60 57 7f a1 e8 e7 31 bf df <
[  133.626170] ---[ end trace 1183b41e13eec444 ]---
[  133.626186] ath10k_pci 0000:04:00.0: boot hif power down
[  133.626192] ieee80211 wiphy1: Hardware restart was requested
[  133.638827] ath10k_pci 0000:04:00.0: failed to read hi_board_data address: -16
[  133.638861] ath10k_pci 0000:04:00.0: boot hif stop
[  133.638955] ath10k_pci 0000:04:00.0: boot qca99x0 chip reset
[  133.638957] ath10k_pci 0000:04:00.0: boot cold reset
[  133.682411] ath10k_pci 0000:04:00.0: boot cold reset complete
[  133.682416] ath10k_pci 0000:04:00.0: boot waiting target to initialise
[  133.682421] ath10k_pci 0000:04:00.0: boot target indicator 2
[  133.682427] ath10k_pci 0000:04:00.0: boot target initialised
[  133.682430] ath10k_pci 0000:04:00.0: boot qca99x0 chip reset complete (cold)
[  133.682589] htt-rx-free, ring-sz: 0  vaddr: 00000000731130b3  base_paddr: 4275339264
[  133.690694] ------------[ cut here ]------------
[  133.690697] kernel BUG at /home/greearb/git/linux-4.16.dev.y/drivers/iommu/intel-iommu.c:1260!
[  133.699699] invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
[  133.705511] Modules linked in: bonding veth vrf 8021q garp mrp stp llc fuse macvlan pktgen nfsv3 nfs fscache snd_hda_codec_hdmi iTCO_wdt iTCO_vendort
[  133.763582] CPU: 3 PID: 3288 Comm: hostapd Tainted: G        W        4.16.18+ #24
[  133.771573] Hardware name: _ _/, BIOS 5.11 08/26/2016
[  133.777051] RIP: 0010:domain_unmap+0x1cf/0x230
[  133.782026] RSP: 0018:ffff8801390d7588 EFLAGS: 00010202
[  133.787769] RAX: 0000000000000000 RBX: ffff880145b98d00 RCX: 0000000000000024
[  133.795390] RDX: 0000000000000000 RSI: 00000000000fed48 RDI: ffff880145b998dc
[  133.803015] RBP: 00000000000fed48 R08: 0000000000000000 R09: 0000000000000000
[  133.810642] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000fed47
[  133.818854] R13: ffff88014d819b80 R14: 0000000000000002 R15: 00000000000fed48
[  133.826490] FS:  00007f72c2cde800(0000) GS:ffff88014df80000(0000) knlGS:0000000000000000
[  133.835109] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  133.841414] CR2: 0000556f59a470f8 CR3: 000000013ad6c004 CR4: 00000000003606e0
[  133.849118] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  133.856840] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  133.864528] Call Trace:
[  133.867533]  intel_unmap+0xbb/0x1d0
[  133.871618]  intel_free_coherent+0x92/0x120
[  133.876281]  ath10k_htt_rx_free+0x2b8/0x740 [ath10k_core]
[  133.882282]  ath10k_core_stop+0x127/0x180 [ath10k_core]
[  133.888040]  ath10k_halt+0x3d0/0x630 [ath10k_core]
[  133.893316]  ath10k_stop+0xa9/0xf0 [ath10k_core]
[  133.898493]  drv_stop+0xc8/0x5a0 [mac80211]
[  133.903174]  ieee80211_do_open+0x1137/0x1b60 [mac80211]
[  133.908912]  __dev_open+0x185/0x2c0
[  133.912893]  ? dev_set_rx_mode+0x30/0x30
[  133.917250]  ? trace_hardirqs_on_caller+0x3ea/0x560
[  133.922640]  ? __dev_change_flags+0x14b/0x4c0
[  133.927478]  __dev_change_flags+0x39b/0x4c0
[  133.932147]  ? dev_set_allmulti+0x10/0x10
[  133.936604]  ? lock_downgrade+0x580/0x580
[  133.941071]  dev_change_flags+0x75/0x150
[  133.945426]  devinet_ioctl+0xf6f/0x1600
[  133.949678]  ? inet_ioctl+0x171/0x2d0
[  133.953725]  inet_ioctl+0x171/0x2d0
[  133.957562]  ? inet_getname+0x3d0/0x3d0
[  133.961764]  ? dev_load+0x66/0x150
[  133.965519]  ? __might_fault+0xea/0x1a0
[  133.969677]  ? lock_downgrade+0x580/0x580
[  133.973961]  ? sock_do_ioctl+0xef/0x250
[  133.978068]  sock_do_ioctl+0xef/0x250
[  133.982050]  ? compat_ifr_data_ioctl+0x130/0x130
[  133.986919]  ? __lock_acquire_lockdep+0xb4d/0x3de0
[  133.991930]  ? ___sys_sendmsg+0x8f0/0x8f0
[  133.996171]  ? debug_check_no_locks_freed+0x290/0x290
[  134.001468]  ? sock_ioctl+0x407/0x500
[  134.005317]  sock_ioctl+0x407/0x500
[  134.008969]  ? dlci_ioctl_set+0x30/0x30
[  134.013675]  ? __audit_syscall_entry+0x2f5/0x5f0
[  134.018978]  ? lock_downgrade+0x580/0x580
[  134.023639]  ? lock_acquire+0x114/0x330
[  134.027621]  ? do_vfs_ioctl+0x16e/0xe70
[  134.031593]  do_vfs_ioctl+0x16e/0xe70
[  134.035314]  ? trace_hardirqs_on_caller+0x3ea/0x560
[  134.040260]  ? ioctl_preallocate+0x170/0x170
[  134.044640]  ? __audit_syscall_entry+0x2f5/0x5f0
[  134.049311]  ? syscall_trace_enter+0x51a/0xbf0
[  134.053776]  ? kfree+0x299/0x300
[  134.056983]  ? trace_raw_output_sys_exit+0xe0/0xe0
[  134.061753]  ? __audit_syscall_exit+0x722/0xa00
[  134.066235]  SyS_ioctl+0x6f/0x80
[  134.069416]  ? do_vfs_ioctl+0xe70/0xe70
[  134.073129]  do_syscall_64+0x193/0x5e0
[  134.076712]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[  134.081501] RIP: 0033:0x7f72c163ccc7
[  134.084828] RSP: 002b:00007ffd098bf558 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[  134.092124] RAX: ffffffffffffffda RBX: 0000000002071e10 RCX: 00007f72c163ccc7
[  134.099044] RDX: 00007ffd098bf570 RSI: 0000000000008914 RDI: 0000000000000009
[  134.105983] RBP: 00007ffd098bf5a0 R08: 0000000002075100 R09: 0000000000000000
[  134.112885] R10: 0000000000019630 R11: 0000000000000206 R12: 0000000000408320
[  134.119781] R13: 00007ffd098bfa70 R14: 0000000000000000 R15: 0000000000000000
[  134.126684] Code: 89 fe 48 c1 ee 03 80 3c 0e 00 75 2b 48 89 45 10 48 c7 83 d0 0b 00 00 00 00 00 00 48 83 c4 08 5b 48 89 e8 5d 41 5c 41 5d 41 5e c3 <
[  134.146604] RIP: domain_unmap+0x1cf/0x230 RSP: ffff8801390d7588
[  134.152466] ---[ end trace 1183b41e13eec445 ]---

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  More complete fix, and backtrace of the two call paths that lead to the
double-free in comments.

 drivers/net/wireless/ath/ath10k/htt_rx.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8ab949d..0a226ed6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -287,17 +287,25 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 	ath10k_htt_rx_ring_free(htt);
 	spin_unlock_bh(&htt->rx_ring.lock);
 
-	dma_free_coherent(htt->ar->dev,
-			  htt->rx_ops->htt_get_rx_ring_size(htt),
-			  htt->rx_ops->htt_get_vaddr_ring(htt),
-			  htt->rx_ring.base_paddr);
+	if (htt->rx_ring.base_paddr) {
+		dma_free_coherent(htt->ar->dev,
+				  htt->rx_ops->htt_get_rx_ring_size(htt),
+				  htt->rx_ops->htt_get_vaddr_ring(htt),
+				  htt->rx_ring.base_paddr);
+		htt->rx_ring.base_paddr = 0;
+	}
 
-	dma_free_coherent(htt->ar->dev,
-			  sizeof(*htt->rx_ring.alloc_idx.vaddr),
-			  htt->rx_ring.alloc_idx.vaddr,
-			  htt->rx_ring.alloc_idx.paddr);
+	if (htt->rx_ring.alloc_idx.paddr) {
+		dma_free_coherent(htt->ar->dev,
+				  sizeof(*htt->rx_ring.alloc_idx.vaddr),
+				  htt->rx_ring.alloc_idx.vaddr,
+				  htt->rx_ring.alloc_idx.paddr);
+		htt->rx_ring.alloc_idx.paddr = 0;
+	}
 
 	kfree(htt->rx_ring.netbufs_ring);
+	htt->rx_ring.netbufs_ring = NULL;
+	htt->rx_ring.size = 0;
 }
 
 static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
-- 
2.4.11
