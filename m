Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13848 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab0LAHeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:34:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:34:22 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/26] ath9k_hw: Read and configure antenna diversity control for AR9485
Date: Tue, 30 Nov 2010 23:32:44 -0800
Message-ID: <1291188775-13707-16-git-send-email-vasanth@atheros.com>
In-Reply-To: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
References: <1291188775-13707-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   24 ++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   10 ++++++++++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 02b6150..9ce6846 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3031,6 +3031,8 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		return !!(pBase->featureEnable & BIT(5));
 	case EEP_CHAIN_MASK_REDUCE:
 		return (pBase->miscConfiguration >> 0x3) & 0x1;
+	case EEP_ANT_DIV_CTL1:
+		return le32_to_cpu(eep->base_ext1.ant_div_control);
 	default:
 		return 0;
 	}
@@ -3512,11 +3514,25 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 	value = ar9003_hw_ant_ctrl_chain_get(ah, 0, is2ghz);
 	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_0, AR_SWITCH_TABLE_ALL, value);
 
-	value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
-	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL, value);
+	if (!AR_SREV_9485(ah)) {
+		value = ar9003_hw_ant_ctrl_chain_get(ah, 1, is2ghz);
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_1, AR_SWITCH_TABLE_ALL,
+			      value);
 
-	value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
-	REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL, value);
+		value = ar9003_hw_ant_ctrl_chain_get(ah, 2, is2ghz);
+		REG_RMW_FIELD(ah, AR_PHY_SWITCH_CHAIN_2, AR_SWITCH_TABLE_ALL,
+			      value);
+	}
+
+	if (AR_SREV_9485(ah)) {
+		value = ath9k_hw_ar9300_get_eeprom(ah, EEP_ANT_DIV_CTL1);
+		REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_CTRL_ALL,
+			      value);
+		REG_RMW_FIELD(ah, AR_PHY_MC_GAIN_CTRL, AR_ANT_DIV_ENABLE,
+			      value >> 6);
+		REG_RMW_FIELD(ah, AR_PHY_CCK_DETECT, AR_FAST_DIV_ENABLE,
+			      value >> 7);
+	}
 }
 
 static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index b772081..6e0d4ad 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -260,7 +260,13 @@
 #define AR_PHY_CCA_0            (AR_AGC_BASE + 0x1c)
 #define AR_PHY_EXT_CCA0         (AR_AGC_BASE + 0x20)
 #define AR_PHY_RESTART          (AR_AGC_BASE + 0x24)
+
 #define AR_PHY_MC_GAIN_CTRL     (AR_AGC_BASE + 0x28)
+#define AR_ANT_DIV_CTRL_ALL	0x7e000000
+#define AR_ANT_DIV_CTRL_ALL_S	25
+#define AR_ANT_DIV_ENABLE	0x1000000
+#define AR_ANT_DIV_ENABLE_S	24
+
 #define AR_PHY_EXTCHN_PWRTHR1   (AR_AGC_BASE + 0x2c)
 #define AR_PHY_EXT_CHN_WIN      (AR_AGC_BASE + 0x30)
 #define AR_PHY_20_40_DET_THR    (AR_AGC_BASE + 0x34)
@@ -271,7 +277,11 @@
 #define AR_PHY_RX_GAIN_BOUNDS_2 (AR_AGC_BASE + 0x48)
 #define AR_PHY_RSSI_0           (AR_AGC_BASE + 0x180)
 #define AR_PHY_SPUR_CCK_REP0    (AR_AGC_BASE + 0x184)
+
 #define AR_PHY_CCK_DETECT       (AR_AGC_BASE + 0x1c0)
+#define AR_FAST_DIV_ENABLE	0x2000
+#define AR_FAST_DIV_ENABLE_S	13
+
 #define AR_PHY_DAG_CTRLCCK      (AR_AGC_BASE + 0x1c4)
 #define AR_PHY_IQCORR_CTRL_CCK  (AR_AGC_BASE + 0x1c8)
 
-- 
1.7.0.4

