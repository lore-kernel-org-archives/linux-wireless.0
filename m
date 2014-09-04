Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:46492 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaIDHXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 03:23:18 -0400
Received: by mail-la0-f44.google.com with SMTP id hz20so11294098lab.31
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 00:23:16 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: move fw_crash_dump allocation
Date: Thu,  4 Sep 2014 09:13:08 +0200
Message-Id: <1409814788-1661-1-git-send-email-michal.kazior@tieto.com> (sfid-20140904_092321_885676_C9798264)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw_crash_data was allocated too late. Upon
early firmware crash, before registering to
mac80211, it was possible to crash the whole
system:

 ath10k_pci 0000:00:05.0: device has crashed during init
 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<ffffffffa0058005>] ath10k_debug_get_new_fw_crash_data+0x15/0x30 [ath10k_core]
 PGD 0
 Oops: 0002 [#1] SMP
 Modules linked in: ath10k_pci(O) ath10k_core(O) ath [last unloaded: ath]
 CPU: 3 PID: 29 Comm: kworker/u8:1 Tainted: G           O   3.17.0-rc2-wl-ath+ #447
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
 Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 task: ffff88001eb01ad0 ti: ffff88001eb60000 task.ti: ffff88001eb60000
 RIP: 0010:[<ffffffffa0058005>]  [<ffffffffa0058005>] ath10k_debug_get_new_fw_crash_data+0x15/0x30 [ath10k_core]
 RSP: 0018:ffff88001eb63ce8  EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffffc90001a09030 RDI: 0000000000000001
 RBP: ffff88001eb63cf0 R08: 0000000000000000 R09: ffff8800000bb200
 R10: 00000000000001e2 R11: ffff88001eb638de R12: ffff88001d7459a0
 R13: ffff88001d746ab0 R14: 00000000fffe14d4 R15: ffff88001d747c60
 FS:  0000000000000000(0000) GS:ffff88001fd80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 000000001df34000 CR4: 00000000000006e0
 Stack:
  ffff88001d7459a0 ffff88001eb63d58 ffffffffa0083bbe ffff880000000010
  ffff88001eb63d68 ffff88001eb63d18 0000000000000002 0000000000059010
  ffffffffa0086fef 00000000deadbeef ffff88001d747a28 ffff88001d7459a0
 Call Trace:
  [<ffffffffa0083bbe>] ath10k_pci_fw_crashed_dump+0x2e/0xd0 [ath10k_pci]
  [<ffffffffa0085410>] __ath10k_pci_hif_power_up+0x5f0/0x700 [ath10k_pci]
  [<ffffffffa0085550>] ath10k_pci_hif_power_up+0x30/0xe0 [ath10k_pci]
  [<ffffffffa005bc7b>] ath10k_core_register_work+0x2b/0x520 [ath10k_core]
  [<ffffffff810689cc>] process_one_work+0x18c/0x3f0
  [<ffffffff81069011>] worker_thread+0x121/0x4a0
  [<ffffffff81068ef0>] ? rescuer_thread+0x2c0/0x2c0
  [<ffffffff8106daf2>] kthread+0xd2/0xf0
  [<ffffffff8106da20>] ? kthread_create_on_node+0x170/0x170
  [<ffffffff81857cfc>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106da20>] ? kthread_create_on_node+0x170/0x170
 Code: 8b 40 38 48 c7 80 00 01 00 00 00 00 00 00 5b 5d c3 0f 1f 44 00 00 0f 1f 44 00 00 55 48 89 e5 53 48 8b 9f 90 1d 00 00 48 8d 7b 01 <c6> 03 01 e8 e3 ec 2b e1 48 8d 7b 18 e8 6a 4f 05 e1 48 89 d8 5b
 RIP  [<ffffffffa0058005>] ath10k_debug_get_new_fw_crash_data+0x15/0x30 [ath10k_core]
  RSP <ffff88001eb63ce8>
 CR2: 0000000000000000
 ---[ end trace 5d0ed15b050bcc1f ]---
 Kernel panic - not syncing: Fatal exception in interrupt
 Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
 ---[ end Kernel panic - not syncing: Fatal exception in interrupt

To prevent that split debug functions and allocate
fw_crash_data earlier.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c  | 18 +++++++++++++----
 drivers/net/wireless/ath/ath10k/debug.c | 34 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/debug.h | 11 +++++++++++
 3 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 651a6da..eadb225 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -977,7 +977,7 @@ static void ath10k_core_register_work(struct work_struct *work)
 		goto err_release_fw;
 	}
 
-	status = ath10k_debug_create(ar);
+	status = ath10k_debug_register(ar);
 	if (status) {
 		ath10k_err(ar, "unable to initialize debugfs\n");
 		goto err_unregister_mac;
@@ -1043,7 +1043,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 
 	ath10k_core_free_firmware_files(ar);
 
-	ath10k_debug_destroy(ar);
+	ath10k_debug_unregister(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
 
@@ -1051,6 +1051,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 				  const struct ath10k_hif_ops *hif_ops)
 {
 	struct ath10k *ar;
+	int ret;
 
 	ar = ath10k_mac_create(priv_size);
 	if (!ar)
@@ -1076,7 +1077,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	ar->workqueue = create_singlethread_workqueue("ath10k_wq");
 	if (!ar->workqueue)
-		goto err_wq;
+		goto err_free_mac;
 
 	mutex_init(&ar->conf_mutex);
 	spin_lock_init(&ar->data_lock);
@@ -1094,10 +1095,18 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 	INIT_WORK(&ar->register_work, ath10k_core_register_work);
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
 
+	ret = ath10k_debug_create(ar);
+	if (ret)
+		goto err_free_wq;
+
 	return ar;
 
-err_wq:
+err_free_wq:
+	destroy_workqueue(ar->workqueue);
+
+err_free_mac:
 	ath10k_mac_destroy(ar);
+
 	return NULL;
 }
 EXPORT_SYMBOL(ath10k_core_create);
@@ -1107,6 +1116,7 @@ void ath10k_core_destroy(struct ath10k *ar)
 	flush_workqueue(ar->workqueue);
 	destroy_workqueue(ar->workqueue);
 
+	ath10k_debug_destroy(ar);
 	ath10k_mac_destroy(ar);
 }
 EXPORT_SYMBOL(ath10k_core_destroy);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index d922ef4..966784a 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1132,20 +1132,25 @@ static const struct file_operations fops_dfs_stats = {
 
 int ath10k_debug_create(struct ath10k *ar)
 {
-	int ret;
-
 	ar->debug.fw_crash_data = vzalloc(sizeof(*ar->debug.fw_crash_data));
-	if (!ar->debug.fw_crash_data) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (!ar->debug.fw_crash_data)
+		return -ENOMEM;
 
+	return 0;
+}
+
+void ath10k_debug_destroy(struct ath10k *ar)
+{
+	vfree(ar->debug.fw_crash_data);
+	ar->debug.fw_crash_data = NULL;
+}
+
+int ath10k_debug_register(struct ath10k *ar)
+{
 	ar->debug.debugfs_phy = debugfs_create_dir("ath10k",
 						   ar->hw->wiphy->debugfsdir);
-	if (!ar->debug.debugfs_phy) {
-		ret = -ENOMEM;
-		goto err_free_fw_crash_data;
-	}
+	if (!ar->debug.debugfs_phy)
+		return -ENOMEM;
 
 	INIT_DELAYED_WORK(&ar->debug.htt_stats_dwork,
 			  ath10k_debug_htt_stats_dwork);
@@ -1192,17 +1197,10 @@ int ath10k_debug_create(struct ath10k *ar)
 	}
 
 	return 0;
-
-err_free_fw_crash_data:
-	vfree(ar->debug.fw_crash_data);
-
-err:
-	return ret;
 }
 
-void ath10k_debug_destroy(struct ath10k *ar)
+void ath10k_debug_unregister(struct ath10k *ar)
 {
-	vfree(ar->debug.fw_crash_data);
 	cancel_delayed_work_sync(&ar->debug.htt_stats_dwork);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 5674653..71c8084 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -49,6 +49,8 @@ int ath10k_debug_start(struct ath10k *ar);
 void ath10k_debug_stop(struct ath10k *ar);
 int ath10k_debug_create(struct ath10k *ar);
 void ath10k_debug_destroy(struct ath10k *ar);
+int ath10k_debug_register(struct ath10k *ar);
+void ath10k_debug_unregister(struct ath10k *ar);
 void ath10k_debug_read_service_map(struct ath10k *ar,
 				   void *service_map,
 				   size_t map_size);
@@ -80,6 +82,15 @@ static inline void ath10k_debug_destroy(struct ath10k *ar)
 {
 }
 
+static inline int ath10k_debug_register(struct ath10k *ar)
+{
+	return 0;
+}
+
+static inline void ath10k_debug_unregister(struct ath10k *ar)
+{
+}
+
 static inline void ath10k_debug_read_service_map(struct ath10k *ar,
 						 void *service_map,
 						 size_t map_size)
-- 
1.8.5.3

