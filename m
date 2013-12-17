Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49240 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3LQSLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 13:11:51 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Fix AR9330 external reset
Date: Tue, 17 Dec 2013 23:36:48 +0530
Message-Id: <1387303608-31356-5-git-send-email-sujith@msujith.org> (sfid-20131217_191155_712745_31514B62)
In-Reply-To: <1387303608-31356-1-git-send-email-sujith@msujith.org>
References: <1387303608-31356-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The external SoC reset for AR9330 is required only when a
beacon stuck is seen, so do not check all the TX queues
for pending frames.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 66 ++++++++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/hw.h   |  1 +
 drivers/net/wireless/ath/ath9k/init.c |  3 +-
 3 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a511c6..29125c2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1272,6 +1272,38 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 	*coef_exponent = coef_exp - 16;
 }
 
+/* AR9330 WAR:
+ * call external reset function to reset WMAC if:
+ * - doing a cold reset
+ * - we have pending frames in the beacon queue
+ */
+static bool ath9k_hw_ar9330_reset_war(struct ath_hw *ah, int type)
+{
+	int npend = 0;
+
+	npend = ath9k_hw_numtxpending(ah, ah->beaconq);
+
+	if (ah->external_reset &&
+	    (npend || type == ATH9K_RESET_COLD)) {
+		int reset_err = 0;
+
+		ath_dbg(ath9k_hw_common(ah), RESET,
+			"reset MAC via external reset\n");
+
+		reset_err = ah->external_reset();
+		if (reset_err) {
+			ath_err(ath9k_hw_common(ah),
+				"External reset failed, err=%d\n",
+				reset_err);
+			return false;
+		}
+
+		REG_WRITE(ah, AR_RTC_RESET, 1);
+	}
+
+	return true;
+}
+
 static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 {
 	u32 rst_flags;
@@ -1322,38 +1354,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	}
 
 	if (AR_SREV_9330(ah)) {
-		int npend = 0;
-		int i;
-
-		/* AR9330 WAR:
-		 * call external reset function to reset WMAC if:
-		 * - doing a cold reset
-		 * - we have pending frames in the TX queues
-		 */
-
-		for (i = 0; i < AR_NUM_QCU; i++) {
-			npend = ath9k_hw_numtxpending(ah, i);
-			if (npend)
-				break;
-		}
-
-		if (ah->external_reset &&
-		    (npend || type == ATH9K_RESET_COLD)) {
-			int reset_err = 0;
-
-			ath_dbg(ath9k_hw_common(ah), RESET,
-				"reset MAC via external reset\n");
-
-			reset_err = ah->external_reset();
-			if (reset_err) {
-				ath_err(ath9k_hw_common(ah),
-					"External reset failed, err=%d\n",
-					reset_err);
-				return false;
-			}
-
-			REG_WRITE(ah, AR_RTC_RESET, 1);
-		}
+		if (!ath9k_hw_ar9330_reset_war(ah, type))
+			return false;
 	}
 
 	if (ath9k_hw_mci_is_enabled(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ba0059f..def98b4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -753,6 +753,7 @@ struct ath_hw {
 	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
+	int beaconq;
 
 	enum ath9k_int imask;
 	u32 imrs2_reg;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ea67c01..dff1e96 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -469,8 +469,9 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	int i = 0;
 
 	sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
-	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
+	sc->sc_ah->beaconq = sc->beacon.beaconq;
 
+	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
 	ath_cabq_update(sc);
 
 	sc->tx.uapsdq = ath_txq_setup(sc, ATH9K_TX_QUEUE_UAPSD, 0);
-- 
1.8.5.1

