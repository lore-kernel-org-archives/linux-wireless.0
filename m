Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51228 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334AbYK1Qx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2008 11:53:27 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2008 08:53:27 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18736.8527.664371.487538@gargle.gargle.HOWL> (sfid-20081128_175330_110916_CC18E0A1)
Date: Fri, 28 Nov 2008 22:20:23 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/5] ath9k: Add initial layout for an ath9k specific debugfs mechanism
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h  |   20 ++++++++++++++++----
 drivers/net/wireless/ath9k/debug.c |   26 +++++++++++++++++++++++---
 drivers/net/wireless/ath9k/main.c  |    4 +++-
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4493879..5b75558 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -88,8 +88,15 @@ enum ATH_DEBUG {
 
 #ifdef CONFIG_ATH9K_DEBUG
 
+struct ath9k_debug {
+	int debug_mask;
+	struct dentry *debugfs_root;
+	struct dentry *debugfs_phy;
+};
+
 void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...);
-void ath9k_init_debug(struct ath_softc *sc);
+int ath9k_init_debug(struct ath_softc *sc);
+void ath9k_exit_debug(struct ath_softc *sc);
 
 #else
 
@@ -98,11 +105,16 @@ static inline void DPRINTF(struct ath_softc *sc, int dbg_mask,
 {
 }
 
-static inline ath9k_init_debug(struct ath_softc *sc)
+static inline int ath9k_init_debug(struct ath_softc *sc)
 {
+	return 0;
 }
 
-#endif
+static inline void ath9k_exit_debug(struct ath_softc *sc)
+{
+}
+
+#endif /* CONFIG_ATH9K_DEBUG */
 
 struct ath_config {
 	u32 ath_aggr_prot;
@@ -619,7 +631,7 @@ struct ath_softc {
 	u8 sc_bssidmask[ETH_ALEN];
 
 #ifdef CONFIG_ATH9K_DEBUG
-	int sc_debug;
+	struct ath9k_debug sc_debug;
 #endif
 	u32 sc_intrstatus;
 	u32 sc_flags; /* SC_OP_* */
diff --git a/drivers/net/wireless/ath9k/debug.c b/drivers/net/wireless/ath9k/debug.c
index 31af7cc..c146e48 100644
--- a/drivers/net/wireless/ath9k/debug.c
+++ b/drivers/net/wireless/ath9k/debug.c
@@ -24,7 +24,7 @@ void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
 	if (!sc)
 		return;
 
-	if (sc->sc_debug & dbg_mask) {
+	if (sc->sc_debug.debug_mask & dbg_mask) {
 		va_list args;
 
 		va_start(args, fmt);
@@ -34,7 +34,27 @@ void DPRINTF(struct ath_softc *sc, int dbg_mask, const char *fmt, ...)
 	}
 }
 
-void ath9k_init_debug(struct ath_softc *sc)
+int ath9k_init_debug(struct ath_softc *sc)
 {
-	sc->sc_debug = ath9k_debug;
+	sc->sc_debug.debug_mask = ath9k_debug;
+
+	sc->sc_debug.debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!sc->sc_debug.debugfs_root)
+		goto err;
+
+	sc->sc_debug.debugfs_phy = debugfs_create_dir(wiphy_name(sc->hw->wiphy),
+						      sc->sc_debug.debugfs_root);
+	if (!sc->sc_debug.debugfs_phy)
+		goto err;
+
+	return 0;
+err:
+	ath9k_exit_debug(sc);
+	return -ENOMEM;
+}
+
+void ath9k_exit_debug(struct ath_softc *sc)
+{
+	debugfs_remove(sc->sc_debug.debugfs_phy);
+	debugfs_remove(sc->sc_debug.debugfs_root);
 }
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 6e624be..aca7848 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1300,6 +1300,7 @@ static void ath_detach(struct ath_softc *sc)
 			ath_tx_cleanupq(sc, &sc->sc_txq[i]);
 
 	ath9k_hw_detach(sc->sc_ah);
+	ath9k_exit_debug(sc);
 }
 
 static int ath_init(u16 devid, struct ath_softc *sc)
@@ -1312,7 +1313,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	/* XXX: hardware will not be ready until ath_open() being called */
 	sc->sc_flags |= SC_OP_INVALID;
 
-	ath9k_init_debug(sc);
+	if (ath9k_init_debug(sc) < 0)
+		printk(KERN_ERR "Unable to create debugfs files\n");
 
 	spin_lock_init(&sc->sc_resetlock);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
-- 
1.6.0.3

