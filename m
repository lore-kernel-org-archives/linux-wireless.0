Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:43700 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab1CAI7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 03:59:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 00:59:18 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_hw: Read noise floor only for available chains for AR9003
Date: Tue, 1 Mar 2011 08:59:36 -0800
Message-ID: <1298998776-3903-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   37 ++++++++++++++-------------
 1 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 8d60f4f..eb250d6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1020,28 +1020,29 @@ static bool ar9003_hw_ani_control(struct ath_hw *ah,
 static void ar9003_hw_do_getnf(struct ath_hw *ah,
 			      int16_t nfarray[NUM_NF_READINGS])
 {
-	int16_t nf;
-
-	nf = MS(REG_READ(ah, AR_PHY_CCA_0), AR_PHY_MINCCA_PWR);
-	nfarray[0] = sign_extend32(nf, 8);
-
-	nf = MS(REG_READ(ah, AR_PHY_CCA_1), AR_PHY_CH1_MINCCA_PWR);
-	nfarray[1] = sign_extend32(nf, 8);
+#define AR_PHY_CH_MINCCA_PWR	0x1FF00000
+#define AR_PHY_CH_MINCCA_PWR_S	20
+#define AR_PHY_CH_EXT_MINCCA_PWR 0x01FF0000
+#define AR_PHY_CH_EXT_MINCCA_PWR_S 16
 
-	nf = MS(REG_READ(ah, AR_PHY_CCA_2), AR_PHY_CH2_MINCCA_PWR);
-	nfarray[2] = sign_extend32(nf, 8);
-
-	if (!IS_CHAN_HT40(ah->curchan))
-		return;
+	int16_t nf;
+	int i;
 
-	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA), AR_PHY_EXT_MINCCA_PWR);
-	nfarray[3] = sign_extend32(nf, 8);
+	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+		if (ah->rxchainmask & BIT(i)) {
+			nf = MS(REG_READ(ah, ah->nf_regs[i]),
+					 AR_PHY_CH_MINCCA_PWR);
+			nfarray[i] = sign_extend32(nf, 8);
 
-	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_1), AR_PHY_CH1_EXT_MINCCA_PWR);
-	nfarray[4] = sign_extend32(nf, 8);
+			if (IS_CHAN_HT40(ah->curchan)) {
+				u8 ext_idx = AR9300_MAX_CHAINS + i;
 
-	nf = MS(REG_READ(ah, AR_PHY_EXT_CCA_2), AR_PHY_CH2_EXT_MINCCA_PWR);
-	nfarray[5] = sign_extend32(nf, 8);
+				nf = MS(REG_READ(ah, ah->nf_regs[ext_idx]),
+						 AR_PHY_CH_EXT_MINCCA_PWR);
+				nfarray[ext_idx] = sign_extend32(nf, 8);
+			}
+		}
+	}
 }
 
 static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
-- 
1.7.0.4

