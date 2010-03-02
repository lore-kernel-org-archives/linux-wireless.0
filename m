Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23984 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab0CBJZX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 04:25:23 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 01:25:23 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.56806.589652.236019@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 15:14:06 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k: Fix symbol collision between ath9k and ath9k_htc
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   22 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   18 +++++++++---------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   14 +++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++--
 4 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ad5ce09..fc9de89 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -32,7 +32,7 @@
 #include "lib.h"
 
 extern struct ieee80211_ops ath9k_htc_ops;
-extern int modparam_nohwcrypt;
+extern int modparam_htc_nohwcrypt;
 
 enum htc_phymode {
 	HTC_MODE_AUTO		= 0,
@@ -385,8 +385,8 @@ void ath9k_tx_cleanup(struct ath9k_htc_priv *priv);
 bool ath9k_htc_txq_setup(struct ath9k_htc_priv *priv,
 			 enum ath9k_tx_queue_subtype qtype);
 int get_hw_qnum(u16 queue, int *hwq_map);
-int ath_txq_update(struct ath9k_htc_priv *priv, int qnum,
-		   struct ath9k_tx_queue_info *qinfo);
+int ath9k_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
+			 struct ath9k_tx_queue_info *qinfo);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
@@ -402,15 +402,15 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug);
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-int ath9k_debug_create_root(void);
-void ath9k_debug_remove_root(void);
-int ath9k_init_debug(struct ath_hw *ah);
-void ath9k_exit_debug(struct ath_hw *ah);
+int ath9k_htc_debug_create_root(void);
+void ath9k_htc_debug_remove_root(void);
+int ath9k_htc_init_debug(struct ath_hw *ah);
+void ath9k_htc_exit_debug(struct ath_hw *ah);
 #else
-static inline int ath9k_debug_create_root(void) { return 0; };
-static inline void ath9k_debug_remove_root(void) {};
-static inline int ath9k_init_debug(struct ath_hw *ah) { return 0; };
-static inline void ath9k_exit_debug(struct ath_hw *ah) {};
+static inline int ath9k_htc_debug_create_root(void) { return 0; };
+static inline void ath9k_htc_debug_remove_root(void) {};
+static inline int ath9k_htc_init_debug(struct ath_hw *ah) { return 0; };
+static inline void ath9k_htc_exit_debug(struct ath_hw *ah) {};
 #endif /* CONFIG_ATH9K_HTC_DEBUGFS */
 
 #endif /* HTC_H */
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 67a9dd2..eab9e54 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -24,9 +24,9 @@ static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 MODULE_PARM_DESC(debug, "Debugging mask");
 
-int modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
+int modparam_htc_nohwcrypt;
+module_param_named(htc_nohwcrypt, modparam_htc_nohwcrypt, int, 0444);
+MODULE_PARM_DESC(htc_nohwcrypt, "Disable hardware encryption");
 
 #define CHAN2G(_freq, _idx)  { \
 	.center_freq = (_freq), \
@@ -93,7 +93,7 @@ static int ath9k_htc_wait_for_target(struct ath9k_htc_priv *priv)
 
 static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
-	ath9k_exit_debug(priv->ah);
+	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
 	tasklet_kill(&priv->wmi_tasklet);
 	tasklet_kill(&priv->rx_tasklet);
@@ -469,7 +469,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
 		goto err_hw;
 	}
 
-	ret = ath9k_init_debug(ah);
+	ret = ath9k_htc_init_debug(ah);
 	if (ret) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to create debugfs files\n");
@@ -487,7 +487,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
 	return 0;
 
 err_queues:
-	ath9k_exit_debug(ah);
+	ath9k_htc_exit_debug(ah);
 err_debug:
 	ath9k_hw_deinit(ah);
 err_hw:
@@ -658,7 +658,7 @@ static int __init ath9k_htc_init(void)
 {
 	int error;
 
-	error = ath9k_debug_create_root();
+	error = ath9k_htc_debug_create_root();
 	if (error < 0) {
 		printk(KERN_ERR
 			"ath9k_htc: Unable to create debugfs root: %d\n",
@@ -677,7 +677,7 @@ static int __init ath9k_htc_init(void)
 	return 0;
 
 err_usb:
-	ath9k_debug_remove_root();
+	ath9k_htc_debug_remove_root();
 err_dbg:
 	return error;
 }
@@ -686,7 +686,7 @@ module_init(ath9k_htc_init);
 static void __exit ath9k_htc_exit(void)
 {
 	ath9k_hif_usb_exit();
-	ath9k_debug_remove_root();
+	ath9k_htc_debug_remove_root();
 	printk(KERN_INFO "ath9k_htc: Driver unloaded\n");
 }
 module_exit(ath9k_htc_exit);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b7618c1..e137b6b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -575,7 +575,7 @@ static const struct file_operations fops_recv = {
 	.owner = THIS_MODULE
 };
 
-int ath9k_init_debug(struct ath_hw *ah)
+int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
@@ -610,11 +610,11 @@ int ath9k_init_debug(struct ath_hw *ah)
 	return 0;
 
 err:
-	ath9k_exit_debug(ah);
+	ath9k_htc_exit_debug(ah);
 	return -ENOMEM;
 }
 
-void ath9k_exit_debug(struct ath_hw *ah)
+void ath9k_htc_exit_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) common->priv;
@@ -625,7 +625,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
 	debugfs_remove(priv->debug.debugfs_phy);
 }
 
-int ath9k_debug_create_root(void)
+int ath9k_htc_debug_create_root(void)
 {
 	ath9k_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
 	if (!ath9k_debugfs_root)
@@ -634,7 +634,7 @@ int ath9k_debug_create_root(void)
 	return 0;
 }
 
-void ath9k_debug_remove_root(void)
+void ath9k_htc_debug_remove_root(void)
 {
 	debugfs_remove(ath9k_debugfs_root);
 	ath9k_debugfs_root = NULL;
@@ -1335,7 +1335,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		  queue, qnum, params->aifs, params->cw_min,
 		  params->cw_max, params->txop);
 
-	ret = ath_txq_update(priv, qnum, &qi);
+	ret = ath9k_htc_txq_update(priv, qnum, &qi);
 	if (ret)
 		ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
 
@@ -1354,7 +1354,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	int ret = 0;
 
-	if (modparam_nohwcrypt)
+	if (modparam_htc_nohwcrypt)
 		return -ENOSPC;
 
 	mutex_lock(&priv->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index f95ab56..cbf21c6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -36,8 +36,8 @@ int get_hw_qnum(u16 queue, int *hwq_map)
 	}
 }
 
-int ath_txq_update(struct ath9k_htc_priv *priv, int qnum,
-		   struct ath9k_tx_queue_info *qinfo)
+int ath9k_htc_txq_update(struct ath9k_htc_priv *priv, int qnum,
+			 struct ath9k_tx_queue_info *qinfo)
 {
 	struct ath_hw *ah = priv->ah;
 	int error = 0;
-- 
1.7.0.1

