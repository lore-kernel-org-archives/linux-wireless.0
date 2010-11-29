Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39785 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0K2WNb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 17:13:31 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Move debugfs under ieee80211/[phyname]/ath9k/
Date: Mon, 29 Nov 2010 14:13:22 -0800
Message-Id: <1291068802-991-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This fixes debugfs problems when a phy is renamed,
and is able to remove a bit of code that is no longer
needed.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 0c3c74c... 3586c43... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 646ff7e... 1e5078b... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 7eef1fa... c2852e5... M	drivers/net/wireless/ath/ath9k/init.c
 drivers/net/wireless/ath/ath9k/debug.c |   35 +++----------------------------
 drivers/net/wireless/ath/ath9k/debug.h |   16 --------------
 drivers/net/wireless/ath/ath9k/init.c  |   30 +++++++--------------------
 3 files changed, 12 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 0c3c74c..3586c43 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -24,8 +24,6 @@
 #define REG_READ_D(_ah, _reg) \
 	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
 
-static struct dentry *ath9k_debugfs_root;
-
 static int ath9k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -878,11 +876,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
-	if (!ath9k_debugfs_root)
-		return -ENOENT;
-
-	sc->debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-						      ath9k_debugfs_root);
+	sc->debug.debugfs_phy = debugfs_create_dir("ath9k",
+						   sc->hw->wiphy->debugfsdir);
 	if (!sc->debug.debugfs_phy)
 		return -ENOMEM;
 
@@ -935,29 +930,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 	sc->debug.regidx = 0;
 	return 0;
 err:
-	ath9k_exit_debug(ah);
-	return -ENOMEM;
-}
-
-void ath9k_exit_debug(struct ath_hw *ah)
-{
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-
 	debugfs_remove_recursive(sc->debug.debugfs_phy);
-}
-
-int ath9k_debug_create_root(void)
-{
-	ath9k_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
-	if (!ath9k_debugfs_root)
-		return -ENOENT;
-
-	return 0;
-}
-
-void ath9k_debug_remove_root(void)
-{
-	debugfs_remove(ath9k_debugfs_root);
-	ath9k_debugfs_root = NULL;
+	sc->debug.debugfs_phy = NULL;
+	return -ENOMEM;
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 646ff7e..1e5078b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -164,10 +164,7 @@ struct ath9k_debug {
 };
 
 int ath9k_init_debug(struct ath_hw *ah);
-void ath9k_exit_debug(struct ath_hw *ah);
 
-int ath9k_debug_create_root(void);
-void ath9k_debug_remove_root(void);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		       struct ath_tx_status *ts);
@@ -180,19 +177,6 @@ static inline int ath9k_init_debug(struct ath_hw *ah)
 	return 0;
 }
 
-static inline void ath9k_exit_debug(struct ath_hw *ah)
-{
-}
-
-static inline int ath9k_debug_create_root(void)
-{
-	return 0;
-}
-
-static inline void ath9k_debug_remove_root(void)
-{
-}
-
 static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 					    enum ath9k_int status)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7eef1fa..c2852e5 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -565,13 +565,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (ret)
 		goto err_hw;
 
-	ret = ath9k_init_debug(ah);
-	if (ret) {
-		ath_print(common, ATH_DBG_FATAL,
-			  "Unable to create debugfs files\n");
-		goto err_debug;
-	}
-
 	ret = ath9k_init_queues(sc);
 	if (ret)
 		goto err_queues;
@@ -594,8 +587,6 @@ err_btcoex:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 err_queues:
-	ath9k_exit_debug(ah);
-err_debug:
 	ath9k_hw_deinit(ah);
 err_hw:
 	tasklet_kill(&sc->intr_tq);
@@ -739,6 +730,13 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (error)
 		goto error_register;
 
+	error = ath9k_init_debug(ah);
+	if (error) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unable to create debugfs files\n");
+		goto error_world;
+	}
+
 	/* Handle world regulatory */
 	if (!ath_is_world_regd(reg)) {
 		error = regulatory_hint(hw->wiphy, reg->alpha2);
@@ -797,7 +795,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_exit_debug(sc->sc_ah);
 	ath9k_hw_deinit(sc->sc_ah);
 
 	tasklet_kill(&sc->intr_tq);
@@ -864,20 +861,12 @@ static int __init ath9k_init(void)
 		goto err_out;
 	}
 
-	error = ath9k_debug_create_root();
-	if (error) {
-		printk(KERN_ERR
-			"ath9k: Unable to create debugfs root: %d\n",
-			error);
-		goto err_rate_unregister;
-	}
-
 	error = ath_pci_init();
 	if (error < 0) {
 		printk(KERN_ERR
 			"ath9k: No PCI devices found, driver not installed.\n");
 		error = -ENODEV;
-		goto err_remove_root;
+		goto err_rate_unregister;
 	}
 
 	error = ath_ahb_init();
@@ -891,8 +880,6 @@ static int __init ath9k_init(void)
  err_pci_exit:
 	ath_pci_exit();
 
- err_remove_root:
-	ath9k_debug_remove_root();
  err_rate_unregister:
 	ath_rate_control_unregister();
  err_out:
@@ -904,7 +891,6 @@ static void __exit ath9k_exit(void)
 {
 	ath_ahb_exit();
 	ath_pci_exit();
-	ath9k_debug_remove_root();
 	ath_rate_control_unregister();
 	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
 }
-- 
1.7.2.3

