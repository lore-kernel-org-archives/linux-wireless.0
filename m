Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64261 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab0LOPbQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:31:01 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] ath9k_hw: Disable PAPRD for rates with low Tx power
Date: Wed, 15 Dec 2010 07:30:52 -0800
Message-ID: <1292427053-5880-6-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the drop in Tx power for a particular mcs rate exceeds
the paprd scale factor, paprd may not work properly. Disable
paprd for any such rates.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   39 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |   20 ++++--------
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 3 files changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 9fa5793..0e9ea35 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4751,16 +4751,53 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 {
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 targetPowerValT2[ar9300RateSize];
-	unsigned int i = 0;
+	u8 target_power_val_t2_eep[ar9300RateSize];
+	unsigned int i = 0, paprd_scale_factor = 0;
+	u8 pwr_idx, min_pwridx;
 
 	ar9003_hw_set_target_power_eeprom(ah, chan->channel, targetPowerValT2);
+
+	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
+		if (IS_CHAN_2GHZ(chan))
+			ah->paprd_ratemask = (IS_CHAN_HT40(chan) ?
+				le32_to_cpu(eep->modalHeader2G.papdRateMaskHt40) :
+				le32_to_cpu(eep->modalHeader2G.papdRateMaskHt20))
+				& AR9300_PAPRD_RATE_MASK;
+		else
+			ah->paprd_ratemask = (IS_CHAN_HT40(chan) ?
+				le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40) :
+				le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20))
+				& AR9300_PAPRD_RATE_MASK;
+
+		memcpy(target_power_val_t2_eep, targetPowerValT2,
+		       sizeof(targetPowerValT2));
+	}
+
 	ar9003_hw_set_power_per_rate_table(ah, chan,
 					   targetPowerValT2, cfgCtl,
 					   twiceAntennaReduction,
 					   twiceMaxRegulatoryPower,
 					   powerLimit);
 
+	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
+		paprd_scale_factor = ar9003_get_paprd_scale_factor(ah, chan);
+		min_pwridx = IS_CHAN_HT40(chan) ? ALL_TARGET_HT40_0_8_16 :
+						  ALL_TARGET_HT20_0_8_16;
+
+		for (i = 0; i < ar9300RateSize; i++) {
+			if ((ah->paprd_ratemask & (1 << i)) &&
+			    (abs(targetPowerValT2[i] -
+				target_power_val_t2_eep[i]) >
+			    paprd_scale_factor)) {
+				ah->paprd_ratemask &= ~(1 << i);
+				ath_dbg(common, ATH_DBG_EEPROM,
+					"paprd disabled for mcs %d\n", i);
+			}
+		}
+	}
+
 	regulatory->max_power_level = 0;
 	for (i = 0; i < ar9300RateSize; i++) {
 		if (targetPowerValT2[i] > regulatory->max_power_level)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 4c74479..26cf31c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -87,8 +87,6 @@ static int ar9003_get_training_power_5g(struct ath_hw *ah)
 static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
-	struct ar9300_modal_eep_header *hdr;
 	static const u32 ctrl0[3] = {
 		AR_PHY_PAPRD_CTRL0_B0,
 		AR_PHY_PAPRD_CTRL0_B1,
@@ -99,18 +97,9 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		AR_PHY_PAPRD_CTRL1_B1,
 		AR_PHY_PAPRD_CTRL1_B2
 	};
-	u32 am_mask, ht40_mask;
 	int training_power;
 	int i;
 
-	if (ah->curchan && IS_CHAN_5GHZ(ah->curchan))
-		hdr = &eep->modalHeader5G;
-	else
-		hdr = &eep->modalHeader2G;
-
-	am_mask = le32_to_cpu(hdr->papdRateMaskHt20) & AR9300_PAPRD_RATE_MASK;
-	ht40_mask = le32_to_cpu(hdr->papdRateMaskHt40) & AR9300_PAPRD_RATE_MASK;
-
 	if (IS_CHAN_2GHZ(ah->curchan))
 		training_power = ar9003_get_training_power_2g(ah);
 	else
@@ -126,9 +115,12 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 		"Training power: %d, Target power: %d\n",
 		ah->paprd_training_power, ah->paprd_target_power);
 
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2AM, AR_PHY_PAPRD_AM2AM_MASK, am_mask);
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK, am_mask);
-	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK, ht40_mask);
+	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2AM, AR_PHY_PAPRD_AM2AM_MASK,
+		      ah->paprd_ratemask);
+	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK,
+		      ah->paprd_ratemask);
+	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK,
+		      AR_PHY_PAPRD_HT40_MASK);
 
 	for (i = 0; i < ah->caps.max_txchains; i++) {
 		REG_RMW_FIELD(ah, ctrl0[i],
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index fb64ab8..3a6101b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -835,6 +835,7 @@ struct ath_hw {
 
 	unsigned int paprd_target_power;
 	unsigned int paprd_training_power;
+	unsigned int paprd_ratemask;
 	u32 paprd_gain_table_entries[PAPRD_GAIN_TABLE_ENTRIES];
 	u8 paprd_gain_table_index[PAPRD_GAIN_TABLE_ENTRIES];
 	/*
-- 
1.7.0.4

