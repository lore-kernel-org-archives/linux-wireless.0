Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35456 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3LRE2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 23:28:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 10/10] ath9k: Use a subroutine for the AR9330 reset WAR
Date: Wed, 18 Dec 2013 09:53:27 +0530
Message-Id: <1387340607-20045-11-git-send-email-sujith@msujith.org> (sfid-20131218_052854_468893_F4C19C07)
In-Reply-To: <1387340607-20045-1-git-send-email-sujith@msujith.org>
References: <1387340607-20045-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c   | 70 +++++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/init.c |  1 -
 2 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a511c6..289a59d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1272,6 +1272,42 @@ void ath9k_hw_get_delta_slope_vals(struct ath_hw *ah, u32 coef_scaled,
 	*coef_exponent = coef_exp - 16;
 }
 
+/* AR9330 WAR:
+ * call external reset function to reset WMAC if:
+ * - doing a cold reset
+ * - we have pending frames in the TX queues.
+ */
+static bool ath9k_hw_ar9330_reset_war(struct ath_hw *ah, int type)
+{
+	int i, npend = 0;
+
+	for (i = 0; i < AR_NUM_QCU; i++) {
+		npend = ath9k_hw_numtxpending(ah, i);
+		if (npend)
+			break;
+	}
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
@@ -1322,38 +1358,8 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
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
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ea67c01..e63465b7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -470,7 +470,6 @@ static int ath9k_init_queues(struct ath_softc *sc)
 
 	sc->beacon.beaconq = ath9k_hw_beaconq_setup(sc->sc_ah);
 	sc->beacon.cabq = ath_txq_setup(sc, ATH9K_TX_QUEUE_CAB, 0);
-
 	ath_cabq_update(sc);
 
 	sc->tx.uapsdq = ath_txq_setup(sc, ATH9K_TX_QUEUE_UAPSD, 0);
-- 
1.8.5.1

