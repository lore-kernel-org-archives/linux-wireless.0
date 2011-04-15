Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28026 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab1DOG7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:59:01 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 23:58:35 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2 2/2] ath9k_htc: Cleanup HTC debugfs
Date: Fri, 15 Apr 2011 12:28:53 +0530
Message-ID: <1302850733-23388-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1302850733-23388-1-git-send-email-rmanoharan@atheros.com>
References: <1302850733-23388-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the ath9k_htc debugfs under ieee80211 to be inline
with ath9k driver and it also helps to simplify debug code.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h           |   14 ---
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |  113 ++++--------------------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c  |   41 +++------
 3 files changed, 31 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 852cdcf..48a8855 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -359,14 +359,6 @@ struct ath_rx_stats {
 
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
-	struct dentry *debugfs_tgt_int_stats;
-	struct dentry *debugfs_tgt_tx_stats;
-	struct dentry *debugfs_tgt_rx_stats;
-	struct dentry *debugfs_xmit;
-	struct dentry *debugfs_recv;
-	struct dentry *debugfs_slot;
-	struct dentry *debugfs_queue;
-	struct dentry *debugfs_debug;
 	struct ath_tx_stats tx_stats;
 	struct ath_rx_stats rx_stats;
 };
@@ -613,15 +605,9 @@ void ath9k_htc_suspend(struct htc_target *htc_handle);
 int ath9k_htc_resume(struct htc_target *htc_handle);
 #endif
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-int ath9k_htc_debug_create_root(void);
-void ath9k_htc_debug_remove_root(void);
 int ath9k_htc_init_debug(struct ath_hw *ah);
-void ath9k_htc_exit_debug(struct ath_hw *ah);
 #else
-static inline int ath9k_htc_debug_create_root(void) { return 0; };
-static inline void ath9k_htc_debug_remove_root(void) {};
 static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; };
-static inline void ath9k_htc_exit_debug(struct ath_hw *ah) {};
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #endif /* HTC_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 7394a1b..d9c0009 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -16,8 +16,6 @@
 
 #include "htc.h"
 
-static struct dentry *ath9k_debugfs_root;
-
 static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -481,100 +479,27 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
 
-	if (!ath9k_debugfs_root)
-		return -ENOENT;
-
-	priv->debug.debugfs_phy = debugfs_create_dir(wiphy_name(priv->hw->wiphy),
-						     ath9k_debugfs_root);
+	priv->debug.debugfs_phy = debugfs_create_dir("ath9k_htc",
+					     priv->hw->wiphy->debugfsdir);
 	if (!priv->debug.debugfs_phy)
-		goto err;
-
-	priv->debug.debugfs_tgt_int_stats = debugfs_create_file("tgt_int_stats",
-							S_IRUSR,
-							priv->debug.debugfs_phy,
-							priv, &fops_tgt_int_stats);
-	if (!priv->debug.debugfs_tgt_int_stats)
-		goto err;
-
-	priv->debug.debugfs_tgt_tx_stats = debugfs_create_file("tgt_tx_stats",
-						       S_IRUSR,
-						       priv->debug.debugfs_phy,
-						       priv, &fops_tgt_tx_stats);
-	if (!priv->debug.debugfs_tgt_tx_stats)
-		goto err;
-
-	priv->debug.debugfs_tgt_rx_stats = debugfs_create_file("tgt_rx_stats",
-						       S_IRUSR,
-						       priv->debug.debugfs_phy,
-						       priv, &fops_tgt_rx_stats);
-	if (!priv->debug.debugfs_tgt_rx_stats)
-		goto err;
-
-	priv->debug.debugfs_xmit = debugfs_create_file("xmit", S_IRUSR,
-						       priv->debug.debugfs_phy,
-						       priv, &fops_xmit);
-	if (!priv->debug.debugfs_xmit)
-		goto err;
-
-	priv->debug.debugfs_recv = debugfs_create_file("recv", S_IRUSR,
-						       priv->debug.debugfs_phy,
-						       priv, &fops_recv);
-	if (!priv->debug.debugfs_recv)
-		goto err;
-
-	priv->debug.debugfs_slot = debugfs_create_file("slot", S_IRUSR,
-						       priv->debug.debugfs_phy,
-						       priv, &fops_slot);
-	if (!priv->debug.debugfs_slot)
-		goto err;
-
-	priv->debug.debugfs_queue = debugfs_create_file("queue", S_IRUSR,
-							priv->debug.debugfs_phy,
-							priv, &fops_queue);
-	if (!priv->debug.debugfs_queue)
-		goto err;
-
-	priv->debug.debugfs_debug = debugfs_create_file("debug",
-							S_IRUSR | S_IWUSR,
-							priv->debug.debugfs_phy,
-							priv, &fops_debug);
-	if (!priv->debug.debugfs_debug)
-		goto err;
-
-	return 0;
-
-err:
-	ath9k_htc_exit_debug(ah);
-	return -ENOMEM;
-}
-
-void ath9k_htc_exit_debug(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
-
-	debugfs_remove(priv->debug.debugfs_queue);
-	debugfs_remove(priv->debug.debugfs_slot);
-	debugfs_remove(priv->debug.debugfs_recv);
-	debugfs_remove(priv->debug.debugfs_xmit);
-	debugfs_remove(priv->debug.debugfs_tgt_int_stats);
-	debugfs_remove(priv->debug.debugfs_tgt_tx_stats);
-	debugfs_remove(priv->debug.debugfs_tgt_rx_stats);
-	debugfs_remove(priv->debug.debugfs_debug);
-	debugfs_remove(priv->debug.debugfs_phy);
-}
+		return -ENOMEM;
 
-int ath9k_htc_debug_create_root(void)
-{
-	ath9k_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!ath9k_debugfs_root)
-		return -ENOENT;
+	debugfs_create_file("tgt_int_stats", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_tgt_int_stats);
+	debugfs_create_file("tgt_tx_stats", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_tgt_tx_stats);
+	debugfs_create_file("tgt_rx_stats", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_tgt_rx_stats);
+	debugfs_create_file("xmit", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_xmit);
+	debugfs_create_file("recv", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_recv);
+	debugfs_create_file("slot", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_slot);
+	debugfs_create_file("queue", S_IRUSR, priv->debug.debugfs_phy,
+				priv, &fops_queue);
+	debugfs_create_file("debug", S_IRUSR | S_IWUSR, priv->debug.debugfs_phy,
+				priv, &fops_debug);
 
 	return 0;
 }
-
-void ath9k_htc_debug_remove_root(void)
-{
-	debugfs_remove(ath9k_debugfs_root);
-	ath9k_debugfs_root = NULL;
-}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 22736eb..1a8980d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -140,7 +140,6 @@ static int ath9k_htc_wait_for_target(struct ath9k_htc_priv *priv)
 
 static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
-	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
 	kfree(priv->ah);
 	priv->ah = NULL;
@@ -150,6 +149,10 @@ static void ath9k_deinit_device(struct ath9k_htc_priv *priv)
 {
 	struct ieee80211_hw *hw = priv->hw;
 
+	if (priv->debug.debugfs_phy) {
+		debugfs_remove_recursive(priv->debug.debugfs_phy);
+		priv->debug.debugfs_phy = NULL;
+	}
 	wiphy_rfkill_stop_polling(hw->wiphy);
 	ath9k_deinit_leds(priv);
 	ieee80211_unregister_hw(hw);
@@ -700,12 +703,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 		goto err_hw;
 	}
 
-	ret = ath9k_htc_init_debug(ah);
-	if (ret) {
-		ath_err(common, "Unable to create debugfs files\n");
-		goto err_debug;
-	}
-
 	ret = ath9k_init_queues(priv);
 	if (ret)
 		goto err_queues;
@@ -725,8 +722,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	return 0;
 
 err_queues:
-	ath9k_htc_exit_debug(ah);
-err_debug:
 	ath9k_hw_deinit(ah);
 err_hw:
 
@@ -867,6 +862,12 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 			goto err_world;
 	}
 
+	error = ath9k_htc_init_debug(priv->ah);
+	if (error) {
+		ath_err(common, "Unable to create debugfs files\n");
+		goto err_world;
+	}
+
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"WMI:%d, BCN:%d, CAB:%d, UAPSD:%d, MGMT:%d, "
 		"BE:%d, BK:%d, VI:%d, VO:%d\n",
@@ -987,38 +988,20 @@ int ath9k_htc_resume(struct htc_target *htc_handle)
 
 static int __init ath9k_htc_init(void)
 {
-	int error;
-
-	error = ath9k_htc_debug_create_root();
-	if (error < 0) {
-		printk(KERN_ERR
-			"ath9k_htc: Unable to create debugfs root: %d\n",
-			error);
-		goto err_dbg;
-	}
-
-	error = ath9k_hif_usb_init();
-	if (error < 0) {
+	if (ath9k_hif_usb_init() < 0) {
 		printk(KERN_ERR
 			"ath9k_htc: No USB devices found,"
 			" driver not installed.\n");
-		error = -ENODEV;
-		goto err_usb;
+		return -ENODEV;
 	}
 
 	return 0;
-
-err_usb:
-	ath9k_htc_debug_remove_root();
-err_dbg:
-	return error;
 }
 module_init(ath9k_htc_init);
 
 static void __exit ath9k_htc_exit(void)
 {
 	ath9k_hif_usb_exit();
-	ath9k_htc_debug_remove_root();
 	printk(KERN_INFO "ath9k_htc: Driver unloaded\n");
 }
 module_exit(ath9k_htc_exit);
-- 
1.7.4.4

