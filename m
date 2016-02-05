Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33313 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbcBEBqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 20:46:11 -0500
From: miaoqing@codeaurora.org
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com, Miaoqing Pan <miaoqing@codeaurora.org>
Subject: [PATCH v2] ath9k: make NF load complete quickly and reliably
Date: Fri,  5 Feb 2016 09:45:50 +0800
Message-Id: <1454636750-2372-1-git-send-email-miaoqing@codeaurora.org> (sfid-20160205_024615_408275_65AFE203)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Miaoqing Pan <miaoqing@codeaurora.org>

Make NF load complete quickly and reliably. NF load execution
is delayed by HW to end of frame if frame Rx or Tx is ongoing.
Increasing timeout to max frame duration. If NF cal is ongoing
before NF load, stop it before load, and restart it afterwards.

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
---
 drivers/net/wireless/ath/ath9k/calib.c | 38 ++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 3e2e24e..37f6d66 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -241,6 +241,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);
 	s16 default_nf = ath9k_hw_get_default_nf(ah, chan);
+	u32 bb_agc_ctl = REG_READ(ah, AR_PHY_AGC_CONTROL);
 
 	if (ah->caldata)
 		h = ah->caldata->nfCalHist;
@@ -264,6 +265,16 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	/*
+	 * stop NF cal if ongoing to ensure NF load completes immediately
+	 * (or after end rx/tx frame if ongoing)
+	 */
+	if (bb_agc_ctl & AR_PHY_AGC_CONTROL_NF) {
+		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+		REG_RMW_BUFFER_FLUSH(ah);
+		ENABLE_REG_RMW_BUFFER(ah);
+	}
+
+	/*
 	 * Load software filtered NF value into baseband internal minCCApwr
 	 * variable.
 	 */
@@ -276,18 +287,33 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	/*
 	 * Wait for load to complete, should be fast, a few 10s of us.
-	 * The max delay was changed from an original 250us to 10000us
-	 * since 250us often results in NF load timeout and causes deaf
-	 * condition during stress testing 12/12/2009
+	 * The max delay was changed from an original 250us to 22.2 msec.
+	 * This would increase timeout to the longest possible frame
+	 * (11n max length 22.1 msec)
 	 */
-	for (j = 0; j < 10000; j++) {
+	for (j = 0; j < 22200; j++) {
 		if ((REG_READ(ah, AR_PHY_AGC_CONTROL) &
-		     AR_PHY_AGC_CONTROL_NF) == 0)
+			      AR_PHY_AGC_CONTROL_NF) == 0)
 			break;
 		udelay(10);
 	}
 
 	/*
+	 * Restart NF so it can continue.
+	 */
+	if (bb_agc_ctl & AR_PHY_AGC_CONTROL_NF) {
+		ENABLE_REG_RMW_BUFFER(ah);
+		if (bb_agc_ctl & AR_PHY_AGC_CONTROL_ENABLE_NF)
+			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_ENABLE_NF);
+		if (bb_agc_ctl & AR_PHY_AGC_CONTROL_NO_UPDATE_NF)
+			REG_SET_BIT(ah, AR_PHY_AGC_CONTROL,
+				    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
+		REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+		REG_RMW_BUFFER_FLUSH(ah);
+	}
+
+	/*
 	 * We timed out waiting for the noisefloor to load, probably due to an
 	 * in-progress rx. Simply return here and allow the load plenty of time
 	 * to complete before the next calibration interval.  We need to avoid
@@ -296,7 +322,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * here, the baseband nf cal will just be capped by our present
 	 * noisefloor until the next calibration timer.
 	 */
-	if (j == 10000) {
+	if (j == 22200) {
 		ath_dbg(common, ANY,
 			"Timeout while waiting for nf to load: AR_PHY_AGC_CONTROL=0x%x\n",
 			REG_READ(ah, AR_PHY_AGC_CONTROL));
-- 
1.9.1

