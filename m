Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40014 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbZHCVbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 17:31:25 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vivek Natarajan <vnatarajan@atheros.com>
Subject: [PATCH v2] ath9k: Remove _t postfix for ar9287_eeprom structure
Date: Mon,  3 Aug 2009 17:31:25 -0400
Message-Id: <1249335085-30131-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't use typdefs on ath9k, remove that _t.

Cc: Vivek Natarajan <vnatarajan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

now with a proper ath9k prefix on the subject :)

 drivers/net/wireless/ath/ath9k/eeprom.c |   24 ++++++++++++------------
 drivers/net/wireless/ath/ath9k/eeprom.h |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h     |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c b/drivers/net/wireless/ath/ath9k/eeprom.c
index 4e4a300..c724c55 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom.c
@@ -2794,7 +2794,7 @@ static int ath9k_hw_AR9287_get_eeprom_rev(struct ath_hw *ah)
 
 static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 {
-	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	u16 *eep_data;
 	int addr, eep_start_loc = AR9287_EEP_START_LOC;
 	eep_data = (u16 *)eep;
@@ -2803,7 +2803,7 @@ static bool ath9k_hw_AR9287_fill_eeprom(struct ath_hw *ah)
 				"Reading from EEPROM, not flash\n");
 	}
 
-	for (addr = 0; addr < sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+	for (addr = 0; addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 			addr++)	{
 		if (!ath9k_hw_nvram_read(ah, addr + eep_start_loc, eep_data)) {
 			DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
@@ -2820,7 +2820,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	u16 temp, word, magic, magic2, *eepdata;
 	int i, addr;
 	bool need_swap = false;
-	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 
 	if (!ath9k_hw_use_flash(ah)) {
 		if (!ath9k_hw_nvram_read
@@ -2842,7 +2842,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 				eepdata = (u16 *)(&ah->eeprom);
 
 				for (addr = 0;
-				     addr < sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+				     addr < sizeof(struct ar9287_eeprom) / sizeof(u16);
 				     addr++) {
 					temp = swab16(*eepdata);
 					*eepdata = temp;
@@ -2863,8 +2863,8 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 	else
 		el = ah->eeprom.map9287.baseEepHeader.length;
 
-	if (el > sizeof(struct ar9287_eeprom_t))
-		el = sizeof(struct ar9287_eeprom_t) / sizeof(u16);
+	if (el > sizeof(struct ar9287_eeprom))
+		el = sizeof(struct ar9287_eeprom) / sizeof(u16);
 	else
 		el = el / sizeof(u16);
 
@@ -2925,7 +2925,7 @@ static int ath9k_hw_AR9287_check_eeprom(struct ath_hw *ah)
 static u32 ath9k_hw_AR9287_get_eeprom(struct ath_hw *ah,
 		enum eeprom_param param)
 {
-	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 	struct base_eep_ar9287_header *pBase = &eep->baseEepHeader;
 	u16 ver_minor;
@@ -3215,7 +3215,7 @@ static void ath9k_hw_set_AR9287_power_cal_table(struct ath_hw *ah,
 	u16 xpdGainValues[AR9287_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset;
 	int16_t   modalIdx, diff = 0;
-	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
 	xpdMask = pEepData->modalHeader.xpdGain;
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
@@ -3385,7 +3385,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 	struct chan_centers centers;
 	int tx_chainmask;
 	u16 twiceMinEdgePower;
-	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	tx_chainmask = ah->txchainmask;
 
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
@@ -3618,7 +3618,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 {
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10
-	struct ar9287_eeprom_t *pEepData = &ah->eeprom.map9287;
+	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
 	int16_t  txPowerIndexOffset = 0;
@@ -3781,7 +3781,7 @@ static void ath9k_hw_AR9287_set_addac(struct ath_hw *ah,
 static void ath9k_hw_AR9287_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
-	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 
 	u16 antWrites[AR9287_ANT_16S];
@@ -3933,7 +3933,7 @@ static u8 ath9k_hw_AR9287_get_num_ant_config(struct ath_hw *ah,
 static u16 ath9k_hw_AR9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
 		struct ath9k_channel *chan)
 {
-	struct ar9287_eeprom_t *eep = &ah->eeprom.map9287;
+	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
 	return pModal->antCtrlCommon & 0xFFFF;
 }
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 335098d..db77e90 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -600,7 +600,7 @@ struct ar5416_eeprom_4k {
 	u8 padding;
 } __packed;
 
-struct ar9287_eeprom_t {
+struct ar9287_eeprom {
 	struct base_eep_ar9287_header  baseEepHeader;
 	u8 custData[AR9287_DATA_SZ];
 	struct modal_eep_ar9287_header modalHeader;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4e717cc..9c23db1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -403,7 +403,7 @@ struct ath_hw {
 	union {
 		struct ar5416_eeprom_def def;
 		struct ar5416_eeprom_4k map4k;
-		struct ar9287_eeprom_t map9287;
+		struct ar9287_eeprom map9287;
 	} eeprom;
 	const struct eeprom_ops *eep_ops;
 	enum ath9k_eep_map eep_map;
-- 
1.6.3.3

