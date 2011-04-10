Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44264 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab1DJQcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:32:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 6/7] ath5k: clean up debugfs code
Date: Sun, 10 Apr 2011 18:32:18 +0200
Message-Id: <1302453139-11437-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302453139-11437-5-git-send-email-nbd@openwrt.org>
References: <1302453139-11437-1-git-send-email-nbd@openwrt.org>
 <1302453139-11437-2-git-send-email-nbd@openwrt.org>
 <1302453139-11437-3-git-send-email-nbd@openwrt.org>
 <1302453139-11437-4-git-send-email-nbd@openwrt.org>
 <1302453139-11437-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The pointers to the debugfs entries do not need to be saved, because they
will be recursively removed when the wiphy is unregistered.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/base.c  |    1 -
 drivers/net/wireless/ath/ath5k/debug.c |   65 +++++++++----------------------
 drivers/net/wireless/ath/ath5k/debug.h |   17 --------
 3 files changed, 19 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 1a561b8..a799d04 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2901,7 +2901,6 @@ ath5k_deinit_softc(struct ath5k_softc *sc)
 	 * XXX: ??? detach ath5k_hw ???
 	 * Other than that, it's straightforward...
 	 */
-	ath5k_debug_finish_device(sc);
 	ieee80211_unregister_hw(hw);
 	ath5k_desc_free(sc);
 	ath5k_txq_release(sc);
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index 0230f30..0bf7313 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -888,65 +888,38 @@ static const struct file_operations fops_queue = {
 void
 ath5k_debug_init_device(struct ath5k_softc *sc)
 {
-	sc->debug.level = ath5k_debug;
+	struct dentry *phydir;
 
-	sc->debug.debugfs_phydir = debugfs_create_dir("ath5k",
-				sc->hw->wiphy->debugfsdir);
+	sc->debug.level = ath5k_debug;
 
-	sc->debug.debugfs_debug = debugfs_create_file("debug",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc, &fops_debug);
+	phydir = debugfs_create_dir("ath5k", sc->hw->wiphy->debugfsdir);
+	if (!phydir)
+	    return;
 
-	sc->debug.debugfs_registers = debugfs_create_file("registers", S_IRUSR,
-				sc->debug.debugfs_phydir, sc, &fops_registers);
+	debugfs_create_file("debug", S_IWUSR | S_IRUSR, phydir, sc,
+			    &fops_debug);
 
-	sc->debug.debugfs_beacon = debugfs_create_file("beacon",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc, &fops_beacon);
+	debugfs_create_file("registers", S_IRUSR, phydir, sc, &fops_registers);
 
-	sc->debug.debugfs_reset = debugfs_create_file("reset", S_IWUSR,
-				sc->debug.debugfs_phydir, sc, &fops_reset);
+	debugfs_create_file("beacon", S_IWUSR | S_IRUSR, phydir, sc,
+			    &fops_beacon);
 
-	sc->debug.debugfs_antenna = debugfs_create_file("antenna",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc, &fops_antenna);
+	debugfs_create_file("reset", S_IWUSR, phydir, sc, &fops_reset);
 
-	sc->debug.debugfs_misc = debugfs_create_file("misc",
-				S_IRUSR,
-				sc->debug.debugfs_phydir, sc, &fops_misc);
+	debugfs_create_file("antenna", S_IWUSR | S_IRUSR, phydir, sc,
+			    &fops_antenna);
 
-	sc->debug.debugfs_frameerrors = debugfs_create_file("frameerrors",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc,
-				&fops_frameerrors);
+	debugfs_create_file("misc", S_IRUSR, phydir, sc, &fops_misc);
 
-	sc->debug.debugfs_ani = debugfs_create_file("ani",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc,
-				&fops_ani);
+	debugfs_create_file("frameerrors", S_IWUSR | S_IRUSR, phydir, sc,
+			    &fops_frameerrors);
 
-	sc->debug.debugfs_queue = debugfs_create_file("queue",
-				S_IWUSR | S_IRUSR,
-				sc->debug.debugfs_phydir, sc,
-				&fops_queue);
-}
+	debugfs_create_file("ani", S_IWUSR | S_IRUSR, phydir, sc, &fops_ani);
 
-void
-ath5k_debug_finish_device(struct ath5k_softc *sc)
-{
-	debugfs_remove(sc->debug.debugfs_debug);
-	debugfs_remove(sc->debug.debugfs_registers);
-	debugfs_remove(sc->debug.debugfs_beacon);
-	debugfs_remove(sc->debug.debugfs_reset);
-	debugfs_remove(sc->debug.debugfs_antenna);
-	debugfs_remove(sc->debug.debugfs_misc);
-	debugfs_remove(sc->debug.debugfs_frameerrors);
-	debugfs_remove(sc->debug.debugfs_ani);
-	debugfs_remove(sc->debug.debugfs_queue);
-	debugfs_remove(sc->debug.debugfs_phydir);
+	debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, sc,
+			    &fops_queue);
 }
 
-
 /* functions used in other places */
 
 void
diff --git a/drivers/net/wireless/ath/ath5k/debug.h b/drivers/net/wireless/ath/ath5k/debug.h
index b0355ae..193dd2d 100644
--- a/drivers/net/wireless/ath/ath5k/debug.h
+++ b/drivers/net/wireless/ath/ath5k/debug.h
@@ -68,17 +68,6 @@ struct ath5k_buf;
 
 struct ath5k_dbg_info {
 	unsigned int		level;		/* debug level */
-	/* debugfs entries */
-	struct dentry		*debugfs_phydir;
-	struct dentry		*debugfs_debug;
-	struct dentry		*debugfs_registers;
-	struct dentry		*debugfs_beacon;
-	struct dentry		*debugfs_reset;
-	struct dentry		*debugfs_antenna;
-	struct dentry		*debugfs_misc;
-	struct dentry		*debugfs_frameerrors;
-	struct dentry		*debugfs_ani;
-	struct dentry		*debugfs_queue;
 };
 
 /**
@@ -141,9 +130,6 @@ void
 ath5k_debug_init_device(struct ath5k_softc *sc);
 
 void
-ath5k_debug_finish_device(struct ath5k_softc *sc);
-
-void
 ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah);
 
 void
@@ -167,9 +153,6 @@ static inline void
 ath5k_debug_init_device(struct ath5k_softc *sc) {}
 
 static inline void
-ath5k_debug_finish_device(struct ath5k_softc *sc) {}
-
-static inline void
 ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah) {}
 
 static inline void
-- 
1.7.3.2

