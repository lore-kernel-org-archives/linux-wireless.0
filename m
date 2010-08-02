Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48358 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab0HBNxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/4] ath9k_hw: apply the noise floor validation to the median instead of single
Date: Mon,  2 Aug 2010 15:53:13 +0200
Message-Id: <1280757195-9532-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280757195-9532-1-git-send-email-nbd@openwrt.org>
References: <1280757195-9532-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/calib.c |   51 ++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 4520869..ccb1b2e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -19,8 +19,7 @@
 
 /* Common calibration code */
 
-/* We can tune this as we go by monitoring really low values */
-#define ATH9K_NF_TOO_LOW	-60
+#define ATH9K_NF_TOO_HIGH	-60
 
 static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 {
@@ -45,11 +44,35 @@ static int16_t ath9k_hw_get_nf_hist_mid(int16_t *nfCalBuffer)
 	return nfval;
 }
 
-static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
+static struct ath_nf_limits *ath9k_hw_get_nf_limits(struct ath_hw *ah,
+						    struct ath9k_channel *chan)
+{
+	struct ath_nf_limits *limit;
+
+	if (!chan || IS_CHAN_2GHZ(chan))
+		limit = &ah->nf_2g;
+	else
+		limit = &ah->nf_5g;
+
+	return limit;
+}
+
+static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
+				   struct ath9k_channel *chan)
+{
+	return ath9k_hw_get_nf_limits(ah, chan)->nominal;
+}
+
+
+static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
+					      struct ath9k_nfcal_hist *h,
 					      int16_t *nfarray)
 {
+	struct ath_nf_limits *limit;
 	int i;
 
+	limit = ath9k_hw_get_nf_limits(ah, ah->curchan);
+
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		h[i].nfCalBuffer[h[i].currIndex] = nfarray[i];
 
@@ -63,6 +86,9 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath9k_nfcal_hist *h,
 			h[i].privNF =
 				ath9k_hw_get_nf_hist_mid(h[i].nfCalBuffer);
 		}
+
+		if (h[i].privNF > limit->max)
+			h[i].privNF = limit->max;
 	}
 }
 
@@ -104,19 +130,6 @@ void ath9k_hw_reset_calibration(struct ath_hw *ah,
 	ah->cal_samples = 0;
 }
 
-static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
-				   struct ath9k_channel *chan)
-{
-	struct ath_nf_limits *limit;
-
-	if (!chan || IS_CHAN_2GHZ(chan))
-		limit = &ah->nf_2g;
-	else
-		limit = &ah->nf_5g;
-
-	return limit->nominal;
-}
-
 /* This is done for the currently configured channel */
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
@@ -277,10 +290,10 @@ static void ath9k_hw_nf_sanitize(struct ath_hw *ah, s16 *nf)
 			  "NF calibrated [%s] [chain %d] is %d\n",
 			  (i >= 3 ? "ext" : "ctl"), i % 3, nf[i]);
 
-		if (nf[i] > limit->max) {
+		if (nf[i] > ATH9K_NF_TOO_HIGH) {
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "NF[%d] (%d) > MAX (%d), correcting to MAX",
-				  i, nf[i], limit->max);
+				  i, nf[i], ATH9K_NF_TOO_HIGH);
 			nf[i] = limit->max;
 		} else if (nf[i] < limit->min) {
 			ath_print(common, ATH_DBG_CALIBRATE,
@@ -326,7 +339,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	h = caldata->nfCalHist;
 	caldata->nfcal_pending = false;
-	ath9k_hw_update_nfcal_hist_buffer(h, nfarray);
+	ath9k_hw_update_nfcal_hist_buffer(ah, h, nfarray);
 	caldata->rawNoiseFloor = h[0].privNF;
 	return true;
 }
-- 
1.6.4.2

