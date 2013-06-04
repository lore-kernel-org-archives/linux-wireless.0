Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33095 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3FDKOY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 06:14:24 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath9k: Fix ANI monitoring
Date: Tue,  4 Jun 2013 15:41:31 +0530
Message-Id: <1370340695-29003-2-git-send-email-sujith@msujith.org> (sfid-20130604_121427_395007_BE141C00)
In-Reply-To: <1370340695-29003-1-git-send-email-sujith@msujith.org>
References: <1370340695-29003-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The commit "ath9k_hw: improve ANI processing and rx desensitizing parameters"
changed various ANI operational parameters to address a specific
card/environment. This is not really applicable for other cards
in general usage.

As per internal documentation, lowering the immunity level can be
done only after 5 periods have passed and the CCK/OFDM errors are
below the low watermak threshold - which have been fixed at 300 and
400 respectively by the sytems team.

Raising the immunity level can be done when CCK/OFDM errors exceed
600 and 1000 (per second).

Set these values once during attach.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ani.c | 29 +++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/ani.h |  2 --
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 3ec4c53..1520e55 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -186,14 +186,6 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
 				     entry_ofdm->ofdm_weak_signal_on);
 	}
-
-	if (aniState->ofdmNoiseImmunityLevel >= ATH9K_ANI_OFDM_DEF_LEVEL) {
-		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH;
-		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI;
-	} else {
-		ah->config.ofdm_trig_high = ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI;
-		ah->config.ofdm_trig_low = ATH9K_ANI_OFDM_TRIG_LOW;
-	}
 }
 
 static void ath9k_hw_ani_ofdm_err_trigger(struct ath_hw *ah)
@@ -439,12 +431,25 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 		ofdmPhyErrRate, aniState->cckNoiseImmunityLevel,
 		cckPhyErrRate, aniState->ofdmsTurn);
 
-	if (aniState->listenTime > ah->aniperiod) {
-		if (cckPhyErrRate < ah->config.cck_trig_low &&
-		    ofdmPhyErrRate < ah->config.ofdm_trig_low) {
+	if (aniState->listenTime > 5 * ah->aniperiod) {
+		/*
+		 * Check if we need to lower immunity if
+		 * 5 ani_periods have passed.
+		 */
+		if (ofdmPhyErrRate <= ah->config.ofdm_trig_low &&
+		    cckPhyErrRate <= ah->config.cck_trig_low) {
 			ath9k_hw_ani_lower_immunity(ah);
 			aniState->ofdmsTurn = !aniState->ofdmsTurn;
-		} else if (ofdmPhyErrRate > ah->config.ofdm_trig_high) {
+		}
+		ath9k_ani_restart(ah);
+	} else if (aniState->listenTime > ah->aniperiod) {
+		/*
+		 * Check if immunity has to be raised,
+		 * (either OFDM or CCK).
+		 */
+		if (ofdmPhyErrRate > ah->config.ofdm_trig_high &&
+		    (cckPhyErrRate <= ah->config.cck_trig_high ||
+		     aniState->ofdmsTurn)) {
 			ath9k_hw_ani_ofdm_err_trigger(ah);
 			aniState->ofdmsTurn = false;
 		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 78b9fa9..1088472 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -21,11 +21,9 @@
 
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_HIGH          3500
-#define ATH9K_ANI_OFDM_TRIG_HIGH_BELOW_INI 1000
 
 /* units are errors per second */
 #define ATH9K_ANI_OFDM_TRIG_LOW           400
-#define ATH9K_ANI_OFDM_TRIG_LOW_ABOVE_INI 900
 
 /* units are errors per second */
 #define ATH9K_ANI_CCK_TRIG_HIGH           600
-- 
1.8.3

