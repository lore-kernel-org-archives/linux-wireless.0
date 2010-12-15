Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64263 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab0LOPbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 07:31:05 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] ath9k_hw: Configure appropriate Tx power when PAPRD fails
Date: Wed, 15 Dec 2010 07:30:53 -0800
Message-ID: <1292427053-5880-7-git-send-email-vasanth@atheros.com>
In-Reply-To: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
References: <1292427053-5880-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Target Tx power available in eeprom is for PAPRD. If PAPRD
fails, paprd scale factor needs to be detected from this
target tx power.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   34 ++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |   14 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.c            |    2 +
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 drivers/net/wireless/ath/ath9k/main.c          |    2 +-
 5 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 0e9ea35..f80ec74 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4743,6 +4743,16 @@ static void ar9003_hw_set_power_per_rate_table(struct ath_hw *ah,
 	} /* end ctl mode checking */
 }
 
+static inline u8 mcsidx_to_tgtpwridx(unsigned int mcs_idx, u8 base_pwridx)
+{
+	u8 mod_idx = mcs_idx % 8;
+
+	if (mod_idx <= 3)
+		return mod_idx ? (base_pwridx + 1) : base_pwridx;
+	else
+		return base_pwridx + 4 * (mcs_idx / 8) + mod_idx - 2;
+}
+
 static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					struct ath9k_channel *chan, u16 cfgCtl,
 					u8 twiceAntennaReduction,
@@ -4755,7 +4765,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	u8 targetPowerValT2[ar9300RateSize];
 	u8 target_power_val_t2_eep[ar9300RateSize];
 	unsigned int i = 0, paprd_scale_factor = 0;
-	u8 pwr_idx, min_pwridx;
+	u8 pwr_idx, min_pwridx = 0;
 
 	ar9003_hw_set_target_power_eeprom(ah, chan->channel, targetPowerValT2);
 
@@ -4771,6 +4781,24 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 				le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20))
 				& AR9300_PAPRD_RATE_MASK;
 
+		paprd_scale_factor = ar9003_get_paprd_scale_factor(ah, chan);
+		min_pwridx = IS_CHAN_HT40(chan) ? ALL_TARGET_HT40_0_8_16 :
+						  ALL_TARGET_HT20_0_8_16;
+
+		if (!ah->paprd_table_write_done) {
+			memcpy(target_power_val_t2_eep, targetPowerValT2,
+			       sizeof(targetPowerValT2));
+			for (i = 0; i < 24; i++) {
+				pwr_idx = mcsidx_to_tgtpwridx(i, min_pwridx);
+				if (ah->paprd_ratemask & (1 << i)) {
+					if (targetPowerValT2[pwr_idx] &&
+					    targetPowerValT2[pwr_idx] ==
+					    target_power_val_t2_eep[pwr_idx])
+						targetPowerValT2[pwr_idx] -=
+							paprd_scale_factor;
+				}
+			}
+		}
 		memcpy(target_power_val_t2_eep, targetPowerValT2,
 		       sizeof(targetPowerValT2));
 	}
@@ -4782,10 +4810,6 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 					   powerLimit);
 
 	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
-		paprd_scale_factor = ar9003_get_paprd_scale_factor(ah, chan);
-		min_pwridx = IS_CHAN_HT40(chan) ? ALL_TARGET_HT40_0_8_16 :
-						  ALL_TARGET_HT20_0_8_16;
-
 		for (i = 0; i < ar9300RateSize; i++) {
 			if ((ah->paprd_ratemask & (1 << i)) &&
 			    (abs(targetPowerValT2[i] -
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 26cf31c..79554c5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -19,6 +19,20 @@
 
 void ar9003_paprd_enable(struct ath_hw *ah, bool val)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+	struct ath9k_channel *chan = ah->curchan;
+
+	if (val) {
+		ah->paprd_table_write_done = true;
+
+		ah->eep_ops->set_txpower(ah, chan,
+				ath9k_regd_get_ctl(regulatory, chan),
+				chan->chan->max_antenna_gain * 2,
+				chan->chan->max_power * 2,
+				min((u32) MAX_RATE_POWER,
+				(u32) regulatory->power_limit), false);
+	}
+
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_CTRL0_B0,
 		      AR_PHY_PAPRD_CTRL0_PAPRD_ENABLE, !!val);
 	if (ah->caps.tx_chainmask & BIT(1))
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0f373be..ddda76f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1272,6 +1272,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ath9k_hw_mark_phy_inactive(ah);
 
+	ah->paprd_table_write_done = false;
+
 	/* Only required on the first reset */
 	if (AR_SREV_9271(ah) && ah->htc_reset_init) {
 		REG_WRITE(ah,
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3a6101b..21e37d1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -836,6 +836,7 @@ struct ath_hw {
 	unsigned int paprd_target_power;
 	unsigned int paprd_training_power;
 	unsigned int paprd_ratemask;
+	bool paprd_table_write_done;
 	u32 paprd_gain_table_entries[PAPRD_GAIN_TABLE_ENTRIES];
 	u8 paprd_gain_table_index[PAPRD_GAIN_TABLE_ENTRIES];
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c68205d..d5fd9d1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -533,7 +533,7 @@ set_timer:
 	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) && ah->caldata) {
 		if (!ah->caldata->paprd_done)
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
-		else
+		else if (!ah->paprd_table_write_done)
 			ath_paprd_activate(sc);
 	}
 }
-- 
1.7.0.4

