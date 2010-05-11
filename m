Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47561 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0EKPXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 11:23:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 1/4] ath9k: use debugfs_remove_recursive() instead of keeping pointers to all entries
Date: Tue, 11 May 2010 17:23:00 +0200
Message-Id: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   55 +++++++++----------------------
 drivers/net/wireless/ath/ath9k/debug.h |    7 ----
 2 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 64e30cd..679257c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -722,52 +722,36 @@ int ath9k_init_debug(struct ath_hw *ah)
 	sc->debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
 						      ath9k_debugfs_root);
 	if (!sc->debug.debugfs_phy)
-		goto err;
+		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-	sc->debug.debugfs_debug = debugfs_create_file("debug",
-		S_IRUSR | S_IWUSR, sc->debug.debugfs_phy, sc, &fops_debug);
-	if (!sc->debug.debugfs_debug)
+	if (!debugfs_create_file("debug", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_debug))
 		goto err;
 #endif
 
-	sc->debug.debugfs_dma = debugfs_create_file("dma", S_IRUSR,
-				       sc->debug.debugfs_phy, sc, &fops_dma);
-	if (!sc->debug.debugfs_dma)
+	if (!debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_dma))
 		goto err;
 
-	sc->debug.debugfs_interrupt = debugfs_create_file("interrupt",
-						     S_IRUSR,
-						     sc->debug.debugfs_phy,
-						     sc, &fops_interrupt);
-	if (!sc->debug.debugfs_interrupt)
+	if (!debugfs_create_file("interrupt", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_interrupt))
 		goto err;
 
-	sc->debug.debugfs_rcstat = debugfs_create_file("rcstat",
-						  S_IRUSR,
-						  sc->debug.debugfs_phy,
-						  sc, &fops_rcstat);
-	if (!sc->debug.debugfs_rcstat)
+	if (!debugfs_create_file("rcstat", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_rcstat))
 		goto err;
 
-	sc->debug.debugfs_wiphy = debugfs_create_file(
-		"wiphy", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy, sc,
-		&fops_wiphy);
-	if (!sc->debug.debugfs_wiphy)
+	if (!debugfs_create_file("wiphy", S_IRUSR | S_IWUSR,
+			sc->debug.debugfs_phy, sc, &fops_wiphy))
 		goto err;
 
-	sc->debug.debugfs_xmit = debugfs_create_file("xmit",
-						     S_IRUSR,
-						     sc->debug.debugfs_phy,
-						     sc, &fops_xmit);
-	if (!sc->debug.debugfs_xmit)
+	if (!debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_xmit))
 		goto err;
 
-	sc->debug.debugfs_recv = debugfs_create_file("recv",
-						     S_IRUSR,
-						     sc->debug.debugfs_phy,
-						     sc, &fops_recv);
-	if (!sc->debug.debugfs_recv)
+	if (!debugfs_create_file("recv", S_IRUSR, sc->debug.debugfs_phy,
+			sc, &fops_recv))
 		goto err;
 
 	return 0;
@@ -781,14 +765,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
-	debugfs_remove(sc->debug.debugfs_recv);
-	debugfs_remove(sc->debug.debugfs_xmit);
-	debugfs_remove(sc->debug.debugfs_wiphy);
-	debugfs_remove(sc->debug.debugfs_rcstat);
-	debugfs_remove(sc->debug.debugfs_interrupt);
-	debugfs_remove(sc->debug.debugfs_dma);
-	debugfs_remove(sc->debug.debugfs_debug);
-	debugfs_remove(sc->debug.debugfs_phy);
+	debugfs_remove_recursive(sc->debug.debugfs_phy);
 }
 
 int ath9k_debug_create_root(void)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index c545960..7314360 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -153,13 +153,6 @@ struct ath_stats {
 
 struct ath9k_debug {
 	struct dentry *debugfs_phy;
-	struct dentry *debugfs_debug;
-	struct dentry *debugfs_dma;
-	struct dentry *debugfs_interrupt;
-	struct dentry *debugfs_rcstat;
-	struct dentry *debugfs_wiphy;
-	struct dentry *debugfs_xmit;
-	struct dentry *debugfs_recv;
 	struct ath_stats stats;
 };
 
-- 
1.6.4.2

