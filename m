Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63563 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbbCUIrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 04:47:42 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 09/18] ath9k: ath9k_hw_loadnf: use REG_RMW
Date: Sat, 21 Mar 2015 09:47:12 +0100
Message-Id: <1426927641-18474-10-git-send-email-linux@rempel-privat.de> (sfid-20150321_094800_912530_84E7034B)
In-Reply-To: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
References: <1426927641-18474-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/calib.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index e200a6e..3e2e24e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -238,7 +238,6 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	struct ath9k_nfcal_hist *h = NULL;
 	unsigned i, j;
-	int32_t val;
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);
 	s16 default_nf = ath9k_hw_get_default_nf(ah, chan);
@@ -246,6 +245,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (ah->caldata)
 		h = ah->caldata->nfCalHist;
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
 			s16 nfval;
@@ -258,10 +258,8 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 			else
 				nfval = default_nf;
 
-			val = REG_READ(ah, ah->nf_regs[i]);
-			val &= 0xFFFFFE00;
-			val |= (((u32) nfval << 1) & 0x1ff);
-			REG_WRITE(ah, ah->nf_regs[i], val);
+			REG_RMW(ah, ah->nf_regs[i],
+				(((u32) nfval << 1) & 0x1ff), 0x1ff);
 		}
 	}
 
@@ -274,6 +272,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL, AR_PHY_AGC_CONTROL_NF);
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	/*
 	 * Wait for load to complete, should be fast, a few 10s of us.
@@ -309,19 +308,17 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * by the median we just loaded.  This will be initial (and max) value
 	 * of next noise floor calibration the baseband does.
 	 */
-	ENABLE_REGWRITE_BUFFER(ah);
+	ENABLE_REG_RMW_BUFFER(ah);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
 			if ((i >= AR5416_MAX_CHAINS) && !IS_CHAN_HT40(chan))
 				continue;
 
-			val = REG_READ(ah, ah->nf_regs[i]);
-			val &= 0xFFFFFE00;
-			val |= (((u32) (-50) << 1) & 0x1ff);
-			REG_WRITE(ah, ah->nf_regs[i], val);
+			REG_RMW(ah, ah->nf_regs[i],
+					(((u32) (-50) << 1) & 0x1ff), 0x1ff);
 		}
 	}
-	REGWRITE_BUFFER_FLUSH(ah);
+	REG_RMW_BUFFER_FLUSH(ah);
 
 	return 0;
 }
-- 
1.9.1

