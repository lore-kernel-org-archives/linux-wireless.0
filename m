Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:13444 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582AbZHZDJL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 23:09:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 20:09:14 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19092.42868.444264.146442@gargle.gargle.HOWL>
Date: Wed, 26 Aug 2009 08:39:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath9k: Reduce the frequency of PA offset calibration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PA calibration need not be done if the offset is not varying.
The current logic does PA calibration even if the offset is the
same.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   25 +++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/calib.h |    7 +++++++
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 3 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 20f74b5..47a024d 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -861,7 +861,7 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
 }
 
-static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
+static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 
 	u32 regVal;
@@ -877,6 +877,8 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 		{ 0x7838, 0 },
 	};
 
+	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE, "Running PA Calibration\n");
+
 	if (AR_SREV_9285_11(ah)) {
 		REG_WRITE(ah, AR9285_AN_TOP4, (AR9285_AN_TOP4_DEFAULT | 0x14));
 		udelay(10);
@@ -936,6 +938,17 @@ static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah)
 	offs_6_1 = offset>>1;
 	offs_0 = offset & 1;
 
+	if ((!is_reset) && (ah->pacal_info.prev_offset == offset)) {
+		if (ah->pacal_info.max_skipcount < MAX_PACAL_SKIPCOUNT)
+			ah->pacal_info.max_skipcount =
+				2 * ah->pacal_info.max_skipcount;
+		ah->pacal_info.skipcount = ah->pacal_info.max_skipcount;
+	} else {
+		ah->pacal_info.max_skipcount = 1;
+		ah->pacal_info.skipcount = 0;
+		ah->pacal_info.prev_offset = offset;
+	}
+
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G6, AR9285_AN_RF2G6_OFFS, offs_6_1);
 	REG_RMW_FIELD(ah, AR9285_AN_RF2G3, AR9285_AN_RF2G3_PDVCCOMP, offs_0);
 
@@ -982,8 +995,12 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 		/* Do periodic PAOffset Cal */
 		if (AR_SREV_9271(ah))
 			ath9k_hw_9271_pa_cal(ah);
-		else if (AR_SREV_9285_11_OR_LATER(ah))
-			ath9k_hw_9285_pa_cal(ah);
+		else if (AR_SREV_9285_11_OR_LATER(ah)) {
+			if (!ah->pacal_info.skipcount)
+				ath9k_hw_9285_pa_cal(ah, false);
+			else
+				ah->pacal_info.skipcount--;
+		}
 
 		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
 			ath9k_olc_temp_compensation(ah);
@@ -1081,7 +1098,7 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/* Do PA Calibration */
 	if (AR_SREV_9285_11_OR_LATER(ah))
-		ath9k_hw_9285_pa_cal(ah);
+		ath9k_hw_9285_pa_cal(ah, true);
 
 	/* Do NF Calibration after DC offset and other calibrations */
 	REG_WRITE(ah, AR_PHY_AGC_CONTROL,
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 547e697..019bcbb 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -110,6 +110,13 @@ struct ath9k_nfcal_hist {
 	u8 invalidNFcount;
 };
 
+#define MAX_PACAL_SKIPCOUNT 8
+struct ath9k_pacal_info{
+	int32_t prev_offset;	/* Previous value of PA offset value */
+	int8_t max_skipcount;	/* Max No. of times PACAL can be skipped */
+	int8_t skipcount;	/* No. of times the PACAL to be skipped */
+};
+
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah);
 void ath9k_hw_start_nfcal(struct ath_hw *ah);
 void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 24b3063..b24150a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -424,6 +424,7 @@ struct ath_hw {
 	enum ath9k_power_mode power_mode;
 
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
+	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
 	struct ath9k_tx_queue_info txq[ATH9K_NUM_TX_QUEUES];
 
-- 
1.6.4

