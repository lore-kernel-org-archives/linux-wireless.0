Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38576 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab0LRXcK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 18:32:10 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 1/2] ath9k_hw: fix PA predistortion HT40 mask
Date: Sun, 19 Dec 2010 00:31:54 +0100
Message-Id: <1292715115-36506-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 'ath9k_hw: Disable PAPRD for rates with low Tx power' changed
the code that sets the PAPRD rate masks to use only either the HT20 mask
or the HT40 mask. This is wrong, as the hardware can still use HT20 rates
even when configured for HT40, and the operating channel mode does not
affect PAPRD operation.
The register for the HT40 rate mask is applied as a mask on top of the
other registers to selectively disable PAPRD for specific rates on HT40
packets only.
This patch changes the code back to the old behavior which matches the
intended use of these registers. While with current cards this should not
make any practical difference (according to Atheros, the HT20 and HT40
mask should always be equal), it is more correct that way, and maybe
the HT40 mask will be used for some rare corner cases in the future.

Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   19 +++++++++++--------
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c  |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h            |    1 +
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f80ec74..d7deae8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4762,6 +4762,7 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	struct ar9300_modal_eep_header *modal_hdr;
 	u8 targetPowerValT2[ar9300RateSize];
 	u8 target_power_val_t2_eep[ar9300RateSize];
 	unsigned int i = 0, paprd_scale_factor = 0;
@@ -4771,15 +4772,17 @@ static void ath9k_hw_ar9300_set_txpower(struct ath_hw *ah,
 
 	if (ah->eep_ops->get_eeprom(ah, EEP_PAPRD)) {
 		if (IS_CHAN_2GHZ(chan))
-			ah->paprd_ratemask = (IS_CHAN_HT40(chan) ?
-				le32_to_cpu(eep->modalHeader2G.papdRateMaskHt40) :
-				le32_to_cpu(eep->modalHeader2G.papdRateMaskHt20))
-				& AR9300_PAPRD_RATE_MASK;
+			modal_hdr = &eep->modalHeader2G;
 		else
-			ah->paprd_ratemask = (IS_CHAN_HT40(chan) ?
-				le32_to_cpu(eep->modalHeader5G.papdRateMaskHt40) :
-				le32_to_cpu(eep->modalHeader5G.papdRateMaskHt20))
-				& AR9300_PAPRD_RATE_MASK;
+			modal_hdr = &eep->modalHeader5G;
+
+		ah->paprd_ratemask =
+			le32_to_cpu(modal_hdr->papdRateMaskHt20) &
+			AR9300_PAPRD_RATE_MASK;
+
+		ah->paprd_ratemask_ht40 =
+			le32_to_cpu(modal_hdr->papdRateMaskHt40) &
+			AR9300_PAPRD_RATE_MASK;
 
 		paprd_scale_factor = ar9003_get_paprd_scale_factor(ah, chan);
 		min_pwridx = IS_CHAN_HT40(chan) ? ALL_TARGET_HT40_0_8_16 :
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 79554c5..356d2fd7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -134,7 +134,7 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_AM2PM, AR_PHY_PAPRD_AM2PM_MASK,
 		      ah->paprd_ratemask);
 	REG_RMW_FIELD(ah, AR_PHY_PAPRD_HT40, AR_PHY_PAPRD_HT40_MASK,
-		      AR_PHY_PAPRD_HT40_MASK);
+		      ah->paprd_ratemask_ht40);
 
 	for (i = 0; i < ah->caps.max_txchains; i++) {
 		REG_RMW_FIELD(ah, ctrl0[i],
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b98053f..b8ffaa5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -835,6 +835,7 @@ struct ath_hw {
 	unsigned int paprd_target_power;
 	unsigned int paprd_training_power;
 	unsigned int paprd_ratemask;
+	unsigned int paprd_ratemask_ht40;
 	bool paprd_table_write_done;
 	u32 paprd_gain_table_entries[PAPRD_GAIN_TABLE_ENTRIES];
 	u8 paprd_gain_table_index[PAPRD_GAIN_TABLE_ENTRIES];
-- 
1.7.3.2

