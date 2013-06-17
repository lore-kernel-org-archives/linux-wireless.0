Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45220 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3FQIw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 04:52:28 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k: Fix ANI for AP mode
Date: Mon, 17 Jun 2013 14:19:32 +0530
Message-Id: <1371458972-2646-1-git-send-email-sujith@msujith.org> (sfid-20130617_105232_039842_2B023ACA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k: Fix ANI monitoring" reverted an earlier
commit that adjusted ANI to improve performance. But, this causes
adverse effects in AP mode (as reported by Felix based on an OpenWrt
report). Use the older INI/period configuration for now until more
testing is done.

Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 29 ++++++++++++-----------------
 drivers/net/wireless/ath/ath9k/ani.h |  7 ++++++-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index a68beb1..4994bea 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -186,6 +186,14 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 				     entry_ofdm->ofdm_weak_signal_on);
 	}
+
+	if (aniState->ofdmNoiseImmunityLevel >= ATH9K_ANI_OFDM_DEF_LEVEL) {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI;
+	} else {
+		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI;
+		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW;
+	}
 }
 
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
@@ -420,25 +428,12 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		ofdmPhyErrRate, aniState->cckNoiseImmunityLevel,
 		cckPhyErrRate, aniState->ofdmsTurn);
 
-	if (aniState->listenTime > 5 * ah->aniperiod) {
-		/*
-		 * Check if we need to lower immunity if
-		 * 5 ani_periods have passed.
-		 */
-		if (ofdmPhyErrRate <= ah->config.ofdm_trig_low &&
-		    cckPhyErrRate <= ah->config.cck_trig_low) {
+	if (aniState->listenTime > ah->aniperiod) {
+		if (cckPhyErrRate < ah->config.cck_trig_low &&
+		    ofdmPhyErrRate < ah->config.ofdm_trig_low) {
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
-		}
-		ath9k_ani_restart(ah);
-	} else if (aniState->listenTime > ah->aniperiod) {
-		/*
-		 * Check if immunity has to be raised,
-		 * (either OFDM or CCK).
-		 */
-		if (ofdmPhyErrRate > ah->config.ofdm_trig_high &&
-		    (cckPhyErrRate <= ah->config.cck_trig_high ||
-		     aniState->ofdmsTurn)) {
+		} else if (ofdmPhyErrRate > ah->config.ofdm_trig_high) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
 			aniState->ofdmsTurn = false;
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 77a06fd..a709490 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -20,8 +20,13 @@
 #define BEACON_RSSI(ahp) (ahp->stats.avgbrssi)
 
 /* units are errors per second */
-#define ATH9K_ANI_OFDM_TRIG_HIGH          1000
+#define ATH9K_ANI_OFDM_TRIG_HIGH          3500
 #define ATH9K_ANI_OFDM_TRIG_LOW           400
+#define ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI 1000
+
+#define ATH9K_ANI_OFDM_TRIG_LOW           400
+#define ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI 900
+
 #define ATH9K_ANI_CCK_TRIG_HIGH           600
 #define ATH9K_ANI_CCK_TRIG_LOW            300
 
-- 
1.8.3.1

