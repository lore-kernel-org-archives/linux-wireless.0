Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:56317 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3KNKAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 05:00:38 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix issue with MCS15
Date: Thu, 14 Nov 2013 15:26:06 +0530
Message-Id: <1384422966-10467-1-git-send-email-sujith@msujith.org> (sfid-20131114_110040_706068_1388DC07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

On some boards which are based on AR9300, AR9580 or
AR9550, MCS15 usage is problematic.

This is because these boards use a "frequency doubler",
which doubles the refclk to get better EVM, but causes
spurs. Handle this properly in the driver to recover
throughput.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 50 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.h | 11 +++++++
 2 files changed, 61 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 11f5358..d39b79f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -701,6 +701,54 @@ static int ar9550_hw_get_modes_txgain_index(struct ath_hw *ah,
 	return ret;
 }
 
+static void ar9003_doubler_fix(struct ath_hw *ah)
+{
+	if (AR_SREV_9300(ah) || AR_SREV_9580(ah) || AR_SREV_9550(ah)) {
+		REG_RMW(ah, AR_PHY_65NM_CH0_RXTX2,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
+		REG_RMW(ah, AR_PHY_65NM_CH1_RXTX2,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
+		REG_RMW(ah, AR_PHY_65NM_CH2_RXTX2,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S, 0);
+
+		udelay(200);
+
+		REG_CLR_BIT(ah, AR_PHY_65NM_CH0_RXTX2,
+			    AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK);
+		REG_CLR_BIT(ah, AR_PHY_65NM_CH1_RXTX2,
+			    AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK);
+		REG_CLR_BIT(ah, AR_PHY_65NM_CH2_RXTX2,
+			    AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK);
+
+		udelay(1);
+
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_RXTX2,
+			      AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK, 1);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH1_RXTX2,
+			      AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK, 1);
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH2_RXTX2,
+			      AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK, 1);
+
+		udelay(200);
+
+		REG_RMW_FIELD(ah, AR_PHY_65NM_CH0_SYNTH12,
+			      AR_PHY_65NM_CH0_SYNTH12_VREFMUL3, 0xf);
+
+		REG_RMW(ah, AR_PHY_65NM_CH0_RXTX2, 0,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S);
+		REG_RMW(ah, AR_PHY_65NM_CH1_RXTX2, 0,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S);
+		REG_RMW(ah, AR_PHY_65NM_CH2_RXTX2, 0,
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S |
+			1 << AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S);
+	}
+}
+
 static int ar9003_hw_process_ini(struct ath_hw *ah,
 				 struct ath9k_channel *chan)
 {
@@ -726,6 +774,8 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 					   modesIndex);
 	}
 
+	ar9003_doubler_fix(ah);
+
 	/*
 	 * RXGAIN initvals.
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index fca6243..2af667b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -656,13 +656,24 @@
 #define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x00000001 : 0x00000002)
 #define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S ((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0 : 1)
 #define AR_PHY_65NM_CH0_SYNTH7      0x16098
+#define AR_PHY_65NM_CH0_SYNTH12     0x160ac
 #define AR_PHY_65NM_CH0_BIAS1       0x160c0
 #define AR_PHY_65NM_CH0_BIAS2       0x160c4
 #define AR_PHY_65NM_CH0_BIAS4       0x160cc
+#define AR_PHY_65NM_CH0_RXTX2       0x16104
+#define AR_PHY_65NM_CH1_RXTX2       0x16504
+#define AR_PHY_65NM_CH2_RXTX2       0x16904
 #define AR_PHY_65NM_CH0_RXTX4       0x1610c
 #define AR_PHY_65NM_CH1_RXTX4       0x1650c
 #define AR_PHY_65NM_CH2_RXTX4       0x1690c
 
+#define AR_PHY_65NM_CH0_SYNTH12_VREFMUL3           0x00780000
+#define AR_PHY_65NM_CH0_SYNTH12_VREFMUL3_S         19
+#define AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK         0x00000004
+#define AR_PHY_65NM_CH0_RXTX2_SYNTHON_MASK_S       2
+#define AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK        0x00000008
+#define AR_PHY_65NM_CH0_RXTX2_SYNTHOVR_MASK_S      3
+
 #define AR_CH0_TOP	(AR_SREV_9300(ah) ? 0x16288 : \
 			 (((AR_SREV_9462(ah) || AR_SREV_9565(ah)) ? 0x1628c : 0x16280)))
 #define AR_CH0_TOP_XPABIASLVL (AR_SREV_9550(ah) ? 0x3c0 : 0x300)
-- 
1.8.4.2

