Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:61888 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaIDKlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 06:41:09 -0400
Received: by mail-la0-f48.google.com with SMTP id ty20so51726lab.35
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 03:41:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] amenth10k: fix debugfs_create_dir() checking
Date: Thu,  4 Sep 2014 12:30:46 +0200
Message-Id: <1409826646-23269-1-git-send-email-michal.kazior@tieto.com> (sfid-20140904_124115_477718_AB8FAFD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function may return an -ENODEV if debugfs is
disabled in kernel. This should originally be
guarded by ath10k's Kconfig but it still makes
sense to check for the non-NULL errno return
value.

Either this or a Kconfig patch prevents from a
kernel oops due to invalid pointer dereference:

 BUG: unable to handle kernel NULL pointer dereference at 000000000000001d
 IP: [<ffffffff810d4423>] relay_open_buf.part.9+0x1a3/0x2d0
 PGD 0
 Oops: 0000 [#1] SMP
 Modules linked in: ath10k_pci ath10k_core ath
 CPU: 1 PID: 6 Comm: kworker/u8:0 Tainted: G        W      3.17.0-rc2-wl-ath+ #448
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 task: ffff88001e94abc0 ti: ffff88001e988000 task.ti: ffff88001e988000
 RIP: 0010:[<ffffffff810d4423>]  [<ffffffff810d4423>] relay_open_buf.part.9+0x1a3/0x2d0
 RSP: 0018:ffff88001e98bd40  EFLAGS: 00010286
 RAX: ffffffffffffffed RBX: ffffc90000a01000 RCX: 0000000000001473
 RDX: 0000000000000000 RSI: ffffffffffffffed RDI: ffff88001d4b1d00
 RBP: ffff88001e98bd80 R08: 0000000000014860 R09: ffff88001fc94860
 R10: ffffea0000752c40 R11: ffff88001e801700 R12: 0000000000000040
 R13: 0000000000000200 R14: ffff88001d5b8800 R15: ffff88001d4b1e00
 FS:  0000000000000000(0000) GS:ffff88001fc80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 000000000000001d CR3: 000000001d4bd000 CR4: 00000000000006e0
 Stack:
  000000001e98bda8 0000000000000040 ffff88001d5b8800 ffff88001d5b8800
  0000000000000000 0000000000000000 ffffffff81c96690 ffffffffa0025997
  ffff88001e98bdc8 ffffffff810d47bf 0000000000000000 ffffffffffffffed
 Call Trace:
  [<ffffffff810d47bf>] relay_open+0x17f/0x2c0
  [<ffffffffa001ea0f>] ath10k_spectral_create+0x2f/0x40 [ath10k_core]
  [<ffffffffa0012ff8>] ath10k_core_register_work+0x318/0x520 [ath10k_core]
  [<ffffffff810619d9>] process_one_work+0x169/0x390
  [<ffffffff810626a9>] worker_thread+0x119/0x490
  [<ffffffff81062590>] ? rescuer_thread+0x2b0/0x2b0
  [<ffffffff81066efd>] kthread+0xcd/0xf0
  [<ffffffff81066e30>] ? kthread_create_on_node+0x170/0x170
  [<ffffffff8179137c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81066e30>] ? kthread_create_on_node+0x170/0x170
 Code: 00 85 c0 74 2e 8b 55 c4 48 8b 7d d0 4c 89 fe e8 d4 fd ff ff 48 85 c0 0f 84 12 01 00 00 49 89 87 98 00 00 00 49 8b 97 d0 00 00 00 <48> 8b 40 30 48 89 50 50 8b 45 c4 be 01 00 00 00 4c 89 ff 41 89
 RIP  [<ffffffff810d4423>] relay_open_buf.part.9+0x1a3/0x2d0
  RSP <ffff88001e98bd40>
 CR2: 000000000000001d
 ---[ end trace 2eafd3e96c41b8e2 ]---

Note: Without a Kconfig patch ath10k with
ATH10K_DEBUGFS && !DEBUG_FS will fail and refuse
to register to mac80211.

Reported-by: Matteo Croce <matteo@openwrt.org>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
@Kalle:

 - this patch prevents kernel oops but ath10k will
   fail to load

 - Matteo's patch prevents kernel oops and ath10k
   will load fine

Since mine is just an extra precaution feel free
to drop all but the first paragraph of my commit
message if you want to.

 drivers/net/wireless/ath/ath10k/debug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index d922ef4..ed192a5 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1142,8 +1142,12 @@ int ath10k_debug_create(struct ath10k *ar)
 
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
 						   ar->hw->wiphy->debugfsdir);
-	if (!ar->debug.debugfs_phy) {
-		ret = -ENOMEM;
+	if (IS_ERR_OR_NULL(ar->debug.debugfs_phy)) {
+		if (IS_ERR(ar->debug.debugfs_phy))
+			ret = PTR_ERR(ar->debug.debugfs_phy);
+		else
+			ret = -ENOMEM;
+
 		goto err_free_fw_crash_data;
 	}
 
-- 
1.8.5.3

