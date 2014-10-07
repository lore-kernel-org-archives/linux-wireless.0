Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:32855 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaJGPFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 11:05:22 -0400
Received: by mail-wg0-f48.google.com with SMTP id k14so8202187wgh.31
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2014 08:05:21 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH] ath9k_htc: avoid kernel panic in ath9k_hw_reset
Date: Tue,  7 Oct 2014 17:04:30 +0200
Message-Id: <1412694270-14421-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20141007_170531_934756_B42DC6AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw pointer of ath_hw is not assigned to proper value
in function ath9k_hw_reset what finally causes kernel panic.
This can be solved by proper initialization of ath_hw in
ath9k_init_priv.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---

[432866.234088] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[432866.234139] IP: [<ffffffffa09cd915>] ath9k_hw_reset+0xe05/0x13e0 [ath9k_hw]
[432866.234183] PGD 220dc9067 PUD 220dca067 PMD 0 
[432866.234213] Oops: 0000 [#1] SMP 
[432866.234234] Modules linked in: ath9k_htc ath9k_common ath9k_hw ath btrfs xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c reiserfs ext2 ppdev lp rfcomm bnep binfmt_misc nfsd auth_rpcgss nfs_acl nfs lockd fscache sunrpc snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_codec_generic arc4 joydev uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common iwlmvm videodev iwldvm btusb mac80211 bluetooth snd_hda_intel i915 snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq iTCO_wdt snd_seq_device iwlwifi parport_pc tpm_tis dell_laptop snd_timer cfg80211 drm_kms_helper snd drm psmouse parport soundcore video iTCO_vendor_support dcdbas i2c_algo_bit i2c_i801 lpc_ich dell_wmi pcspkr sparse_keymap serio_raw wmi evbug mac_hid ahci sdhci_pci libahci sdhci e1000e ptp pps_core
[432866.234749] CPU: 0 PID: 3131 Comm: NetworkManager Tainted: G        W      3.17.0-rc6-wl+ #63
[432866.234790] Hardware name: Dell Inc. Latitude E6420/0K0DNP, BIOS A08 10/18/2011
[432866.234826] task: ffff88021f1221c0 ti: ffff88021e920000 task.ti: ffff88021e920000
[432866.234862] RIP: 0010:[<ffffffffa09cd915>]  [<ffffffffa09cd915>] ath9k_hw_reset+0xe05/0x13e0 [ath9k_hw]
[432866.234913] RSP: 0018:ffff88021e923568  EFLAGS: 00010283
[432866.234940] RAX: 0000000000000000 RBX: ffff8801c2904330 RCX: 0000000000000006
[432866.234975] RDX: 0000000000000006 RSI: ffff88021f122a18 RDI: ffff88021f1221c0
[432866.235010] RBP: ffff88021e9235d8 R08: 0000000000000000 R09: 0000000000000000
[432866.235044] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[432866.235079] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8801c2904000
[432866.235114] FS:  00007f8f64f64800(0000) GS:ffff88022dc00000(0000) knlGS:0000000000000000
[432866.235153] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[432866.235182] CR2: 0000000000000030 CR3: 0000000220c56000 CR4: 00000000000407f0
[432866.235216] Stack:
[432866.235228]  ffff88021e9235d8 ffffffff81800964 0000000000000000 00ff880120000000
[432866.235272]  00000000000183f5 ffff8801c2904040 ffff8801c2904040 ffff88021f7fb818
[432866.235315]  ffff88021e9235d8 ffff8801c2a2a620 ffff8801c2904000 ffff8801c2a289a0
[432866.235359] Call Trace:
[432866.235378]  [<ffffffffa0a41423>] ath9k_htc_start+0xa3/0x280 [ath9k_htc]
[432866.235414]  [<ffffffff810a1b7a>] ? mark_held_locks+0x6a/0x90
[432866.235458]  [<ffffffffa04815a1>] ieee80211_do_open+0x331/0xdd0 [mac80211]
[432866.235495]  [<ffffffff81749b8e>] ? mutex_unlock+0xe/0x10
[432866.235532]  [<ffffffffa04820a1>] ieee80211_open+0x61/0x70 [mac80211]
[432866.235566]  [<ffffffff816384d6>] __dev_open+0xb6/0x130
[432866.235594]  [<ffffffff816387ec>] __dev_change_flags+0xac/0x180
[432866.235625]  [<ffffffff81638910>] dev_change_flags+0x30/0x70
[432866.235657]  [<ffffffff811556e2>] ? get_page_from_freelist+0x822/0x980
[432866.235692]  [<ffffffff81646409>] do_setlink+0x349/0x9e0
[432866.235721]  [<ffffffff810a1cad>] ? trace_hardirqs_on_caller+0x10d/0x1d0
[432866.235755]  [<ffffffff810a1d7d>] ? trace_hardirqs_on+0xd/0x10
[432866.235786]  [<ffffffff8164926b>] rtnl_newlink+0x4cb/0x730
[432866.235816]  [<ffffffff81648ea3>] ? rtnl_newlink+0x103/0x730
[432866.235848]  [<ffffffff81648c00>] rtnetlink_rcv_msg+0xa0/0x240
[432866.235879]  [<ffffffff810a1d7d>] ? trace_hardirqs_on+0xd/0x10
[432866.235910]  [<ffffffff81644e47>] ? rtnl_lock+0x17/0x20
[432866.235939]  [<ffffffff81648b60>] ? __rtnl_unlock+0x20/0x20
[432866.235970]  [<ffffffff81664ff1>] netlink_rcv_skb+0xb1/0xc0
[432866.236000]  [<ffffffff81644ec5>] rtnetlink_rcv+0x25/0x40
[432866.236029]  [<ffffffff816648ad>] netlink_unicast+0x18d/0x200
[432866.236060]  [<ffffffff81664c3d>] netlink_sendmsg+0x31d/0x430
[432866.236091]  [<ffffffff8161ab3c>] sock_sendmsg+0x9c/0xd0
[432866.236121]  [<ffffffff81176aac>] ? might_fault+0x8c/0xa0
[432866.236149]  [<ffffffff81176a63>] ? might_fault+0x43/0xa0
[432866.236179]  [<ffffffff81629366>] ? verify_iovec+0x56/0xe0
[432866.236208]  [<ffffffff8161b5f9>] ___sys_sendmsg+0x389/0x3a0
[432866.236239]  [<ffffffff811ddc65>] ? __fget+0x5/0xe0
[432866.236266]  [<ffffffff811dddc3>] ? __fdget+0x13/0x20
[432866.237561]  [<ffffffff811ddd0a>] ? __fget+0xaa/0xe0
[432866.238837]  [<ffffffff811ddc65>] ? __fget+0x5/0xe0
[432866.240098]  [<ffffffff811ddd65>] ? __fget_light+0x25/0x70
[432866.241357]  [<ffffffff8161c069>] __sys_sendmsg+0x49/0x90
[432866.242489]  [<ffffffff8161c0c2>] SyS_sendmsg+0x12/0x20
[432866.243308]  [<ffffffff8174c496>] system_call_fastpath+0x1a/0x1f
[432866.244029] Code: 00 41 ff 57 10 bf de 46 03 00 e8 07 91 9c e0 e9 6d f4 ff ff 66 90 41 81 bf c8 02 00 00 c0 02 00 00 0f 84 df 03 00 00 49 8b 47 38 <80> 78 30 00 0f 84 7e fb ff ff f6 43 0a 30 49 8b 87 e0 16 00 00 
[432866.245634] RIP  [<ffffffffa09cd915>] ath9k_hw_reset+0xe05/0x13e0 [ath9k_hw]
[432866.246399]  RSP <ffff88021e923568>
[432866.247145] CR2: 0000000000000030
[432866.252454] ---[ end trace 85181a8c528713c8 ]---


 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d779f4f..4014c4b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -464,6 +464,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 		return -ENOMEM;
 
 	ah->dev = priv->dev;
+	ah->hw = priv->hw;
 	ah->hw_version.devid = devid;
 	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
-- 
2.1.1

