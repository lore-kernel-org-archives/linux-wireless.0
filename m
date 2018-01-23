Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:16326 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751065AbeAWHlY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 02:41:24 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [PATCH 3/4] ath9k: Use calibrated noise floor value when available
Date: Tue, 23 Jan 2018 08:35:24 +0100
Message-Id: <1516692925-6695-4-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20180123_084129_015637_EA052AF2)
In-Reply-To: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use calibrated noise floor value to improve rssi/signal reporting.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 38 +++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 13ab6bc..3d9447e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -58,19 +58,25 @@ static struct ath_nf_limits *ath9k_hw_get_nf_limits(struct ath_hw *ah,
 }
 
 static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
-				   struct ath9k_channel *chan)
+				   struct ath9k_channel *chan,
+				   int chain)
 {
-	return ath9k_hw_get_nf_limits(ah, chan)->nominal;
+	s16 calib_nf = ath9k_hw_get_nf_limits(ah, chan)->cal[chain];
+
+	if (calib_nf)
+		return calib_nf;
+	else
+		return ath9k_hw_get_nf_limits(ah, chan)->nominal;
 }
 
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
 			   s16 nf)
 {
-	s8 noise = ATH_DEFAULT_NOISE_FLOOR;
+	s8 noise = ath9k_hw_get_default_nf(ah, chan, 0);
 
 	if (nf) {
 		s8 delta = nf - ATH9K_NF_CAL_NOISE_THRESH -
-			   ath9k_hw_get_default_nf(ah, chan);
+			   ath9k_hw_get_default_nf(ah, chan, 0);
 		if (delta > 0)
 			noise += delta;
 	}
@@ -240,7 +246,7 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	unsigned i, j;
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);
-	s16 default_nf = ath9k_hw_get_default_nf(ah, chan);
+	s16 default_nf = ath9k_hw_get_nf_limits(ah, chan)->nominal;
 	u32 bb_agc_ctl = REG_READ(ah, AR_PHY_AGC_CONTROL);
 
 	if (ah->caldata)
@@ -258,8 +264,13 @@ int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 				nfval = ah->nf_override;
 			else if (h)
 				nfval = h[i].privNF;
-			else
-				nfval = default_nf;
+			else {
+				/* Try to get calibrated noise floor value */
+				nfval =
+				    ath9k_hw_get_nf_limits(ah, chan)->cal[i];
+				if (nfval > -60 || nfval < -127)
+					nfval = default_nf;
+			}
 
 			REG_RMW(ah, ah->nf_regs[i],
 				(((u32) nfval << 1) & 0x1ff), 0x1ff);
@@ -429,20 +440,19 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan)
 {
 	struct ath9k_nfcal_hist *h;
-	s16 default_nf;
-	int i, j;
+	int i, j, k = 0;
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags;
 	h = ah->caldata->nfCalHist;
-	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		h[i].currIndex = 0;
-		h[i].privNF = default_nf;
+		h[i].privNF = ath9k_hw_get_default_nf(ah, chan, k);
 		h[i].invalidNFcount = AR_PHY_CCA_FILTERWINDOW_LENGTH;
-		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++) {
-			h[i].nfCalBuffer[j] = default_nf;
-		}
+		for (j = 0; j < ATH9K_NF_CAL_HIST_MAX; j++)
+			h[i].nfCalBuffer[j] = h[i].privNF;
+		if (++k >= AR5416_MAX_CHAINS)
+			k = 0;
 	}
 }
 
-- 
2.7.4
