Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41568 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab3GXIY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 04:24:58 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] ath9k: Add a HW capability for WLAN/BT RX diversity
Date: Wed, 24 Jul 2013 13:51:29 +0530
Message-Id: <1374654090-24408-4-git-send-email-sujith@msujith.org> (sfid-20130724_102512_548805_EA1C14BF)
In-Reply-To: <1374654090-24408-1-git-send-email-sujith@msujith.org>
References: <1374654090-24408-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  9 +++++----
 drivers/net/wireless/ath/ath9k/hw.h    |  1 +
 drivers/net/wireless/ath/ath9k/init.c  | 13 +++++++++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 76e38d3..2992fd0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -624,10 +624,11 @@ void ath_ant_comb_update(struct ath_softc *sc);
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
index d27395f..defed26 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -516,6 +516,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 static void ath9k_init_platform(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (common->bus_ops->ath_bus_type != ATH_PCI)
@@ -529,8 +530,14 @@ static void ath9k_init_platform(struct ath_softc *sc)
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
+		ath_info(common, "Enable BT/WLAN RX diversity\n");
 	}
 }
 
@@ -583,6 +590,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 			    const struct ath_bus_ops *bus_ops)
 {
 	struct ath9k_platform_data *pdata = sc->dev->platform_data;
+	struct ath9k_hw_capabilities *pCap;
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
 	int ret = 0, i;
@@ -600,6 +608,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ah->reg_ops.rmw = ath9k_reg_rmw;
 	atomic_set(&ah->intr_ref_cnt, -1);
 	sc->sc_ah = ah;
+	pCap = &ah->caps;
 
 	sc->dfs_detector = dfs_pattern_detector_init(ah, NL80211_DFS_UNSET);
 
@@ -650,7 +659,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	 * WB195 which is a AR9285 + AR3011 card doesn't have
 	 * this feature.
 	 */
-	if (ath9k_bt_ant_diversity)
+	if (ath9k_bt_ant_diversity && (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV))
 		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
-- 
1.8.3.3

