Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44832 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732806AbeHABeW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 21:34:22 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        kvalo@codeaurora.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  fix use-after-free of netbufs_ring
Date: Tue, 31 Jul 2018 16:51:33 -0700
Message-Id: <1533081093-16921-1-git-send-email-greearb@candelatech.com> (sfid-20180801_015141_293199_4F7D3BAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

When firmware crashes in certain ways, it
appears to crash the kernel often.  One of the problems
is some way to access the netbufs_ring after it is freed.

I am not sure exactly how that happens, but setting it to NULL
fixes the problem.  The splat looked like this when I was setting
the object to null but not setting the 'size' to 0.  This shows
the attempted double-access.

This is from my 4.16 tree, which has my own changes as well as
some patches cherry-picked from upstream.

Firmware is modified 10.4 on 9984, but no firmware should cause
the driver to crash, so firmware is mostly of no concern.

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN PTI
Modules linked in: bonding veth vrf 8021q garp mrp stp llc fuse macvlan pktgen nfsv3 nfs fscache iTCO_wdt iTCO_vendor_support ath10k_pci snd_hda_codec_hdmi ath10k_core coretemp intel_rapl ath x86_pkg_temp_thermal intel_powerclamp snd_hda_intel kvm_intel snd_hda_codec mac80211 kvm snd_hda_core snd_hwdep irqbypass snd_seq snd_seq_device snd_pcm snd_timer cfg80211 snd i2c_i801 joydev soundcore shpchp mei_wdt intel_pch_thermal acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc sch_fq_codel igb hwmon serio_raw e1000e dca i915 i2c_algo_bit drm_kms_helper drm i2c_core video ipv6 crc_ccitt
CPU: 3 PID: 3331 Comm: hostapd Not tainted 4.16.18+ #24
Hardware name: _ _/, BIOS 5.11 08/26/2016
RIP: 0010:ath10k_htt_rx_ring_free+0x196/0x980 [ath10k_core]
RSP: 0018:ffff88014c2275c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 1ffffffff0910fa3
RDX: 0000000000000000 RSI: 0000000000000800 RDI: ffff880149f15068
RBP: ffff880149f15100 R08: bb8910a6fa25ec7f R09: 0000000000000000
R10: ffff88014c2275a8 R11: 1ffff10029844e8c R12: ffff880149f14fe8
R13: ffff880149f15060 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f8f73de6800(0000) GS:ffff88014df80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005599f7c38188 CR3: 000000013fe40003 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ath10k_htt_rx_free+0x56/0x540 [ath10k_core]
 ath10k_core_stop+0x127/0x180 [ath10k_core]
 ath10k_halt+0x3d0/0x630 [ath10k_core]
 ath10k_stop+0xa9/0xf0 [ath10k_core]
 drv_stop+0xc8/0x5a0 [mac80211]
 ieee80211_do_open+0x1137/0x1b60 [mac80211]
 __dev_open+0x185/0x2c0
 ? dev_set_rx_mode+0x30/0x30
 ? trace_hardirqs_on_caller+0x3ea/0x560
 ? __dev_change_flags+0x14b/0x4c0
 __dev_change_flags+0x39b/0x4c0
 ? dev_set_allmulti+0x10/0x10
 ? lock_downgrade+0x580/0x580
 dev_change_flags+0x75/0x150
 devinet_ioctl+0xf6f/0x1600
 ? inet_ioctl+0x171/0x2d0
 inet_ioctl+0x171/0x2d0
 ? inet_getname+0x3d0/0x3d0
 ? dev_load+0x66/0x150
 ? __might_fault+0xea/0x1a0
 ? lock_downgrade+0x580/0x580
 ? sock_do_ioctl+0xef/0x250
 sock_do_ioctl+0xef/0x250
 ? compat_ifr_data_ioctl+0x130/0x130
 ? __lock_acquire_lockdep+0xb4d/0x3de0
 ? ___sys_sendmsg+0x8f0/0x8f0
 ? debug_check_no_locks_freed+0x290/0x290
 ? sock_ioctl+0x407/0x500
 sock_ioctl+0x407/0x500
 ? dlci_ioctl_set+0x30/0x30
 ? __audit_syscall_entry+0x2f5/0x5f0
 ? lock_downgrade+0x580/0x580
 ? lock_acquire+0x114/0x330
 ? do_vfs_ioctl+0x16e/0xe70
 do_vfs_ioctl+0x16e/0xe70
 ? trace_hardirqs_on_caller+0x3ea/0x560
 ? ioctl_preallocate+0x170/0x170
 ? __audit_syscall_entry+0x2f5/0x5f0
 ? syscall_trace_enter+0x51a/0xbf0
 ? kfree+0x299/0x300
 ? trace_raw_output_sys_exit+0xe0/0xe0
 ? __audit_syscall_exit+0x722/0xa00
 SyS_ioctl+0x6f/0x80
 ? do_vfs_ioctl+0xe70/0xe70
 do_syscall_64+0x193/0x5e0
 entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x7f8f72744cc7
RSP: 002b:00007ffd455c0fc8 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00000000009ece10 RCX: 00007f8f72744cc7
RDX: 00007ffd455c0fe0 RSI: 0000000000008914 RDI: 0000000000000009
RBP: 00007ffd455c1010 R08: 00000000009f0100 R09: 0000000000000000
R10: 0000000000019630 R11: 0000000000000206 R12: 0000000000408320
R13: 00007ffd455c14e0 R14: 0000000000000000 R15: 0000000000000000
Code: 00 0f 8e cd 03 00 00 4c 89 e8 48 c1 e8 03 80 3c 18 00 0f 85 93 06 00 00 49 8b 54 24 78 49 63 c7 4c 8d 34 c2 4c 89 f0 48 c1 e8 03 <80> 3c 18 00 0f 85 83 06 00 00 4d 8b 36 4d 85 f6 74 a1 49 8d be
RIP: ath10k_htt_rx_ring_free+0x196/0x980 [ath10k_core] RSP: ffff88014c2275c0
---[ end trace 0bfeec6a8990824a ]---
Kernel panic - not syncing: Fatal exception in interrupt

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 8ab949d..35e6fd9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -298,6 +298,8 @@ void ath10k_htt_rx_free(struct ath10k_htt *htt)
 			  htt->rx_ring.alloc_idx.paddr);
 
 	kfree(htt->rx_ring.netbufs_ring);
+	htt->rx_ring.netbufs_ring = NULL;
+	htt->rx_ring.size = 0;
 }
 
 static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
-- 
2.4.11
