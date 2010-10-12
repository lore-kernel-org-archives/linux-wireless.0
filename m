Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55254 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JLRzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 13:55:43 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath5k:  Move debugfs under ieee80211/[wiphy-name]
Date: Tue, 12 Oct 2010 10:55:38 -0700
Message-Id: <1286906138-4890-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This automatically keeps things proper when wiphy
is renamed.

Based on patch by Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v1 -> v2:  Remove empty functions that are no longer needed.

:100644 100644 c9732a6... bc8581e... M	drivers/net/wireless/ath/ath5k/base.c
:100644 100644 a3b2171... 8f7924f... M	drivers/net/wireless/ath/ath5k/debug.c
:100644 100644 4f078b1... 236edbd... M	drivers/net/wireless/ath/ath5k/debug.h
 drivers/net/wireless/ath/ath5k/base.c  |    7 +------
 drivers/net/wireless/ath/ath5k/debug.c |   20 ++------------------
 drivers/net/wireless/ath/ath5k/debug.h |   12 ------------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c9732a6..bc8581e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3543,8 +3543,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->hw = hw;
 	sc->pdev = pdev;
 
-	ath5k_debug_init_device(sc);
-
 	/*
 	 * Mark the device as detached to avoid processing
 	 * interrupts until setup is complete.
@@ -3652,6 +3650,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		}
 	}
 
+	ath5k_debug_init_device(sc);
 
 	/* ready to process interrupts */
 	__clear_bit(ATH_STAT_INVALID, sc->status);
@@ -3738,8 +3737,6 @@ init_ath5k_pci(void)
 {
 	int ret;
 
-	ath5k_debug_init();
-
 	ret = pci_register_driver(&ath5k_pci_driver);
 	if (ret) {
 		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
@@ -3753,8 +3750,6 @@ static void __exit
 exit_ath5k_pci(void)
 {
 	pci_unregister_driver(&ath5k_pci_driver);
-
-	ath5k_debug_finish();
 }
 
 module_init(init_ath5k_pci);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index a3b2171..8f7924f 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -72,8 +72,6 @@ module_param_named(debug, ath5k_debug, uint, 0);
 #include "reg.h"
 #include "ani.h"
 
-static struct dentry *ath5k_global_debugfs;
-
 static int ath5k_debugfs_open(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
@@ -890,21 +888,13 @@ static const struct file_operations fops_queue = {
 };
 
 
-/* init */
-
-void
-ath5k_debug_init(void)
-{
-	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
-}
-
 void
 ath5k_debug_init_device(struct ath5k_softc *sc)
 {
 	sc->debug.level = ath5k_debug;
 
-	sc->debug.debugfs_phydir = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
-				ath5k_global_debugfs);
+	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
+				sc->hw->wiphy->debugfsdir);
 
 	sc->debug.debugfs_debug = debugfs_create_file("debug",
 				S_IWUSR | S_IRUSR,
@@ -945,12 +935,6 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 }
 
 void
-ath5k_debug_finish(void)
-{
-	debugfs_remove(ath5k_global_debugfs);
-}
-
-void
 ath5k_debug_finish_device(struct ath5k_softc *sc)
 {
 	debugfs_remove(sc->debug.debugfs_debug);
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index 4f078b1..236edbd 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -138,15 +138,9 @@ enum ath5k_debug_level {
 	} while (0)
 
 void
-ath5k_debug_init(void);
-
-void
 ath5k_debug_init_device(struct ath5k_softc *sc);
 
 void
-ath5k_debug_finish(void);
-
-void
 ath5k_debug_finish_device(struct ath5k_softc *sc);
 
 void
@@ -174,15 +168,9 @@ ATH5K_DBG_UNLIMIT(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...)
 {}
 
 static inline void
-ath5k_debug_init(void) {}
-
-static inline void
 ath5k_debug_init_device(struct ath5k_softc *sc) {}
 
 static inline void
-ath5k_debug_finish(void) {}
-
-static inline void
 ath5k_debug_finish_device(struct ath5k_softc *sc) {}
 
 static inline void
-- 
1.7.2.2

