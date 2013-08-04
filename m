Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50333 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3HDIzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] ath9k: Add a HW capability for WLAN/BT RX diversity
Date: Sun,  4 Aug 2013 14:21:56 +0530
Message-Id: <1375606322-9983-5-git-send-email-sujith@msujith.org> (sfid-20130804_105614_977411_821A9EF4)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Make use of this capability to restrict the usage of the
debugfs file and modparam using which this feature can
be enabled.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  9 +++++----
 drivers/net/wireless/ath/ath9k/debug.c |  6 +++++-
 drivers/net/wireless/ath/ath9k/hw.h    |  1 +
 drivers/net/wireless/ath/ath9k/init.c  | 21 +++++++++++++++++----
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 74009f1..18898ab 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -634,10 +634,11 @@ void ath_ant_comb_update(struct ath_softc *sc);
 /* Main driver core */
 /********************/
 
-#define ATH9K_PCI_CUS198 0x0001
-#define ATH9K_PCI_CUS230 0x0002
-#define ATH9K_PCI_CUS217 0x0004
-#define ATH9K_PCI_WOW    0x0008
+#define ATH9K_PCI_CUS198     0x0001
+#define ATH9K_PCI_CUS230     0x0002
+#define ATH9K_PCI_CUS217     0x0004
+#define ATH9K_PCI_WOW        0x0008
+#define ATH9K_PCI_BT_ANT_DIV 0x0010
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 881ca6c..daa316b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -289,6 +289,7 @@ static ssize_t write_file_bt_ant_diversity(struct file *file,
 {
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath9k_hw_capabilities *pCap = &sc->sc_ah->caps;
 	unsigned long bt_ant_diversity;
 	char buf[32];
 	ssize_t len;
@@ -297,6 +298,9 @@ static ssize_t write_file_bt_ant_diversity(struct file *file,
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV))
+		goto exit;
+
 	buf[len] = '\0';
 	if (kstrtoul(buf, 0, &bt_ant_diversity))
 		return -EINVAL;
@@ -307,7 +311,7 @@ static ssize_t write_file_bt_ant_diversity(struct file *file,
 	ath_dbg(common, CONFIG, "Enable WLAN/BT RX Antenna diversity: %d\n",
 		common->bt_ant_diversity);
 	ath9k_ps_restore(sc);
-
+exit:
 	return count;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index fd009e5..4ab8f58 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -248,6 +248,7 @@ enum ath9k_hw_caps {
 	ATH9K_HW_WOW_DEVICE_CAPABLE		= BIT(17),
 	ATH9K_HW_CAP_PAPRD			= BIT(18),
 	ATH9K_HW_CAP_FCC_BAND_SWITCH		= BIT(19),
+	ATH9K_HW_CAP_BT_ANT_DIV			= BIT(20),
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5e81b2c..b678add 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -516,6 +516,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 static void ath9k_init_platform(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (common->bus_ops->ath_bus_type != ATH_PCI)
@@ -531,8 +532,14 @@ static void ath9k_init_platform(struct ath_softc *sc)
 		ath_info(common, "Set parameters for %s\n",
 			 (sc->driver_data & ATH9K_PCI_CUS198) ?
 			 "CUS198" : "CUS230");
-	} else if (sc->driver_data & ATH9K_PCI_CUS217) {
+	}
+
+	if (sc->driver_data & ATH9K_PCI_CUS217)
 		ath_info(common, "CUS217 card detected\n");
+
+	if (sc->driver_data & ATH9K_PCI_BT_ANT_DIV) {
+		pCap->hw_caps |= ATH9K_HW_CAP_BT_ANT_DIV;
+		ath_info(common, "Set BT/WLAN RX diversity capability\n");
 	}
 }
 
@@ -586,6 +593,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 {
 	struct ath9k_platform_data *pdata = sc->dev->platform_data;
 	struct ath_hw *ah = NULL;
+	struct ath9k_hw_capabilities *pCap;
 	struct ath_common *common;
 	int ret = 0, i;
 	int csz = 0;
@@ -602,6 +610,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->reg_ops.rmw = ath9k_reg_rmw;
 	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
+	pCap = &ah->caps;
 
 	sc->dfs_detector = dfs_pattern_detector_init(ah, NL80211_DFS_UNSET);
 
@@ -633,10 +642,14 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_init_platform(sc);
 
 	/*
-	 * Enable WLAN/BT RX Antenna diversity only when BTCOEX is enabled
-	 * and the user manually requests the feature.
+	 * Enable WLAN/BT RX Antenna diversity only when:
+	 *
+	 * - BTCOEX is enabled
+	 * - the user manually requests the feature.
+	 * - the HW cap is set using the platform data.
 	 */
-	if (common->btcoex_enabled && ath9k_bt_ant_diversity)
+	if (common->btcoex_enabled && ath9k_bt_ant_diversity &&
+	    (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV))
 		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
-- 
1.8.3.4

