Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2BVHKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 02:10:31 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20292.38109.369585.986404@gargle.gargle.HOWL> (sfid-20120222_081039_038147_68E35317)
Date: Wed, 22 Feb 2012 12:40:21 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 04/26] ath9k: Move BTCOEX init/deinit functions to gpio.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath/ath9k/gpio.c  |   51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c  |   48 +-----------------------------
 3 files changed, 54 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 171ccf7..aa60983 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -454,6 +454,8 @@ struct ath_btcoex {
 	struct ath_mci_profile mci;
 };
 
+int ath9k_init_btcoex(struct ath_softc *sc);
+void ath9k_deinit_btcoex(struct ath_softc *sc);
 int ath_init_btcoex_timer(struct ath_softc *sc);
 void ath9k_btcoex_timer_resume(struct ath_softc *sc);
 void ath9k_btcoex_timer_pause(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 597c84e..ef23624 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -317,3 +317,54 @@ void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 
 	btcoex->hw_timer_enabled = false;
 }
+
+void ath9k_deinit_btcoex(struct ath_softc *sc)
+{
+        if ((sc->btcoex.no_stomp_timer) &&
+	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
+		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
+
+	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_MCI)
+		ath_mci_cleanup(sc);
+}
+
+int ath9k_init_btcoex(struct ath_softc *sc)
+{
+	struct ath_txq *txq;
+	struct ath_hw *ah = sc->sc_ah;
+	int r;
+
+	switch (ath9k_hw_get_btcoex_scheme(sc->sc_ah)) {
+	case ATH_BTCOEX_CFG_NONE:
+		break;
+	case ATH_BTCOEX_CFG_2WIRE:
+		ath9k_hw_btcoex_init_2wire(sc->sc_ah);
+		break;
+	case ATH_BTCOEX_CFG_3WIRE:
+		ath9k_hw_btcoex_init_3wire(sc->sc_ah);
+		r = ath_init_btcoex_timer(sc);
+		if (r)
+			return -1;
+		txq = sc->tx.txq_map[WME_AC_BE];
+		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
+		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		break;
+	case ATH_BTCOEX_CFG_MCI:
+		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
+		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
+		INIT_LIST_HEAD(&sc->btcoex.mci.info);
+
+		r = ath_mci_setup(sc);
+		if (r)
+			return r;
+
+		ath9k_hw_btcoex_init_mci(ah);
+
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a944fc9..d8b0596 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -419,47 +419,6 @@ fail:
 	return error;
 }
 
-static int ath9k_init_btcoex(struct ath_softc *sc)
-{
-	struct ath_txq *txq;
-	struct ath_hw *ah = sc->sc_ah;
-	int r;
-
-	switch (ath9k_hw_get_btcoex_scheme(sc->sc_ah)) {
-	case ATH_BTCOEX_CFG_NONE:
-		break;
-	case ATH_BTCOEX_CFG_2WIRE:
-		ath9k_hw_btcoex_init_2wire(sc->sc_ah);
-		break;
-	case ATH_BTCOEX_CFG_3WIRE:
-		ath9k_hw_btcoex_init_3wire(sc->sc_ah);
-		r = ath_init_btcoex_timer(sc);
-		if (r)
-			return -1;
-		txq = sc->tx.txq_map[WME_AC_BE];
-		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
-		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		break;
-	case ATH_BTCOEX_CFG_MCI:
-		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
-		sc->btcoex.duty_cycle = ATH_BTCOEX_DEF_DUTY_CYCLE;
-		INIT_LIST_HEAD(&sc->btcoex.mci.info);
-
-		r = ath_mci_setup(sc);
-		if (r)
-			return r;
-
-		ath9k_hw_btcoex_init_mci(ah);
-
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	return 0;
-}
-
 static int ath9k_init_queues(struct ath_softc *sc)
 {
 	int i = 0;
@@ -861,12 +820,7 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 	if (sc->sbands[IEEE80211_BAND_5GHZ].channels)
 		kfree(sc->sbands[IEEE80211_BAND_5GHZ].channels);
 
-        if ((sc->btcoex.no_stomp_timer) &&
-	    ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_3WIRE)
-		ath_gen_timer_free(sc->sc_ah, sc->btcoex.no_stomp_timer);
-
-	if (ath9k_hw_get_btcoex_scheme(sc->sc_ah) == ATH_BTCOEX_CFG_MCI)
-		ath_mci_cleanup(sc);
+	ath9k_deinit_btcoex(sc);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i))
-- 
1.7.9.1

