Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26497 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab0KJNEB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 08:04:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 05:03:49 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/11] ath9k_hw: Enable strong signal detection for AR9003
Date: Wed, 10 Nov 2010 05:03:12 -0800
Message-ID: <1289394196-3465-7-git-send-email-vasanth@atheros.com>
In-Reply-To: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
References: <1289394196-3465-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attenuation from eeprom is configured into attenuator control
register.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   79 ++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 17f73e4..da26d37 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -57,6 +57,8 @@
 #define SUB_NUM_CTL_MODES_AT_5G_40 2    /* excluding HT40, EXT-OFDM */
 #define SUB_NUM_CTL_MODES_AT_2G_40 3    /* excluding HT40, EXT-OFDM, EXT-CCK */
 
+static int ar9003_hw_power_interpolate(int32_t x,
+				       int32_t *px, int32_t *py, u_int16_t np);
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
@@ -3443,6 +3445,82 @@ static void ar9003_hw_drive_strength_apply(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_65NM_CH0_BIAS4, reg);
 }
 
+static u16 ar9003_hw_atten_chain_get(struct ath_hw *ah, int chain,
+				     struct ath9k_channel *chan)
+{
+	int f[3], t[3];
+	u16 value;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (chain >= 0 && chain < 3) {
+		if (IS_CHAN_2GHZ(chan))
+			return eep->modalHeader2G.xatten1DB[chain];
+		else if (eep->base_ext2.xatten1DBLow[chain] != 0) {
+			t[0] = eep->base_ext2.xatten1DBLow[chain];
+			f[0] = 5180;
+			t[1] = eep->modalHeader5G.xatten1DB[chain];
+			f[1] = 5500;
+			t[2] = eep->base_ext2.xatten1DBHigh[chain];
+			f[2] = 5785;
+			value = ar9003_hw_power_interpolate((s32) chan->channel,
+							    f, t, 3);
+			return value;
+		} else
+			return eep->modalHeader5G.xatten1DB[chain];
+	}
+
+	return 0;
+}
+
+
+static u16 ar9003_hw_atten_chain_get_margin(struct ath_hw *ah, int chain,
+					    struct ath9k_channel *chan)
+{
+	int f[3], t[3];
+	u16 value;
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+
+	if (chain >= 0 && chain < 3) {
+		if (IS_CHAN_2GHZ(chan))
+			return eep->modalHeader2G.xatten1Margin[chain];
+		else if (eep->base_ext2.xatten1MarginLow[chain] != 0) {
+			t[0] = eep->base_ext2.xatten1MarginLow[chain];
+			f[0] = 5180;
+			t[1] = eep->modalHeader5G.xatten1Margin[chain];
+			f[1] = 5500;
+			t[2] = eep->base_ext2.xatten1MarginHigh[chain];
+			f[2] = 5785;
+			value = ar9003_hw_power_interpolate((s32) chan->channel,
+							    f, t, 3);
+			return value;
+		} else
+			return eep->modalHeader5G.xatten1Margin[chain];
+	}
+
+	return 0;
+}
+
+static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	int i;
+	u16 value;
+	unsigned long ext_atten_reg[3] = {AR_PHY_EXT_ATTEN_CTL_0,
+					  AR_PHY_EXT_ATTEN_CTL_1,
+					  AR_PHY_EXT_ATTEN_CTL_2,
+					 };
+
+	/* Test value. if 0 then attenuation is unused. Don't load anything. */
+	for (i = 0; i < 3; i++) {
+		value = ar9003_hw_atten_chain_get(ah, i, chan);
+		REG_RMW_FIELD(ah, ext_atten_reg[i],
+			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
+
+		value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
+		REG_RMW_FIELD(ah, ext_atten_reg[i],
+			      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN, value);
+	}
+}
+
 static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 {
 	int internal_regulator =
@@ -3474,6 +3552,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_xpa_bias_level_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_drive_strength_apply(ah);
+	ar9003_hw_atten_apply(ah, chan);
 	ar9003_hw_internal_regulator_apply(ah);
 }
 
-- 
1.7.0.4

