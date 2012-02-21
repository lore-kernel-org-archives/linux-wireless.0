Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22941 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2BUJWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 04:22:45 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20291.25176.959512.155936@gargle.gargle.HOWL> (sfid-20120221_102248_883029_E0A12B91)
Date: Tue, 21 Feb 2012 14:52:32 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC/WIP 05/22] ath9k: Use proper start/stop routines for BTCOEX
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ++-
 drivers/net/wireless/ath/ath9k/gpio.c  |   31 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/main.c  |   19 ++-----------------
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index aa60983..2ede897 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -456,7 +456,8 @@ struct ath_btcoex {
 
 int ath9k_init_btcoex(struct ath_softc *sc);
 void ath9k_deinit_btcoex(struct ath_softc *sc);
-int ath_init_btcoex_timer(struct ath_softc *sc);
+void ath9k_start_btcoex(struct ath_softc *sc);
+void ath9k_stop_btcoex(struct ath_softc *sc);
 void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index ef23624..1ca2ca5 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -245,7 +245,7 @@ static void ath_btcoex_no_stomp_timer(void *arg)
 	ath9k_ps_restore(sc);
 }
 
-int ath_init_btcoex_timer(struct ath_softc *sc)
+static int ath_init_btcoex_timer(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
 
@@ -318,6 +318,35 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 	btcoex->hw_timer_enabled = false;
 }
 
+void ath9k_start_btcoex(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
+	    !ah->btcoex_hw.enabled) {
+		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+						   AR_STOMP_LOW_WLAN_WGHT);
+		ath9k_hw_btcoex_enable(ah);
+
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+			ath9k_btcoex_timer_resume(sc);
+	}
+}
+
+void ath9k_stop_btcoex(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ah->btcoex_hw.enabled &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
+		ath9k_hw_btcoex_disable(ah);
+		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
+			ath9k_btcoex_timer_pause(sc);
+		ath_mci_flush_profile(&sc->btcoex.mci);
+	}
+}
+
 void ath9k_deinit_btcoex(struct ath_softc *sc)
 {
         if ((sc->btcoex.no_stomp_timer) &&
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ec82e92..ee5335c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1079,16 +1079,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
-	    !ah->btcoex_hw.enabled) {
-		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
-			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-						   AR_STOMP_LOW_WLAN_WGHT);
-		ath9k_hw_btcoex_enable(ah);
-
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-			ath9k_btcoex_timer_resume(sc);
-	}
+	ath9k_start_btcoex(sc);
 
 	if (ah->caps.pcie_lcr_extsync_en && common->bus_ops->extn_synch_en)
 		common->bus_ops->extn_synch_en(common);
@@ -1189,13 +1180,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	/* Ensure HW is awake when we try to shut it down. */
 	ath9k_ps_wakeup(sc);
 
-	if (ah->btcoex_hw.enabled &&
-	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		ath9k_hw_btcoex_disable(ah);
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-			ath9k_btcoex_timer_pause(sc);
-		ath_mci_flush_profile(&sc->btcoex.mci);
-	}
+	ath9k_stop_btcoex(sc);
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-- 
1.7.9.1

