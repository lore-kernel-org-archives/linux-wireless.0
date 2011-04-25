Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61866 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab1DYK0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 06:26:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 03:26:21 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 5/5] ath9k_hw: Fix warnings due to -Wunused-but-set-variable
Date: Mon, 25 Apr 2011 15:56:20 +0530
Message-ID: <1303727180-22212-5-git-send-email-rmanoharan@atheros.com> (sfid-20110425_122650_185575_7124BAB3)
In-Reply-To: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
References: <1303727180-22212-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These warnings are exposed by gcc 4.6.
drivers/net/wireless/ath/ath9k/hw.c: In function
'ath9k_hw_fill_cap_info':
drivers/net/wireless/ath/ath9k/hw.c:1796:6: warning: variable 'capField'
set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/ar9003_phy.c: In function
'ar9003_hw_process_ini':
drivers/net/wireless/ath/ath9k/ar9003_phy.c:602:18: warning: variable
'freqIndex' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/eeprom_9287.c: In function
'ath9k_hw_set_ar9287_power_cal_table':
drivers/net/wireless/ath/ath9k/eeprom_9287.c:322:10: warning: variable
'modalIdx' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c: In function
'ar9300_compress_decision':
drivers/net/wireless/ath/ath9k/ar9003_eeprom.c:3220:6: warning: variable
'dptr' set but not used [-Wunused-but-set-variable]

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    5 +----
 drivers/net/wireless/ath/ath9k/ar9003_phy.c    |    6 +-----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |    3 +--
 drivers/net/wireless/ath/ath9k/hw.c            |    4 +---
 4 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6eadf97..e826480 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3217,7 +3217,6 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 				    u8 *word, int length, int mdata_size)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u8 *dptr;
 	const struct ar9300_eeprom *eep = NULL;
 
 	switch (code) {
@@ -3234,9 +3233,7 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 			it, length);
 		break;
 	case _CompressBlock:
-		if (reference == 0) {
-			dptr = mptr;
-		} else {
+		if (reference != 0) {
 			eep = ar9003_eeprom_struct_find_by_id(reference);
 			if (eep == NULL) {
 				ath_dbg(common, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1bc33f5..3113aa8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -599,29 +599,25 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	unsigned int regWrites = 0, i;
 	struct ieee80211_channel *channel = chan->chan;
-	u32 modesIndex, freqIndex;
+	u32 modesIndex;
 
 	switch (chan->chanmode) {
 	case CHANNEL_A:
 	case CHANNEL_A_HT20:
 		modesIndex = 1;
-		freqIndex = 1;
 		break;
 	case CHANNEL_A_HT40PLUS:
 	case CHANNEL_A_HT40MINUS:
 		modesIndex = 2;
-		freqIndex = 1;
 		break;
 	case CHANNEL_G:
 	case CHANNEL_G_HT20:
 	case CHANNEL_B:
 		modesIndex = 4;
-		freqIndex = 2;
 		break;
 	case CHANNEL_G_HT40PLUS:
 	case CHANNEL_G_HT40MINUS:
 		modesIndex = 3;
-		freqIndex = 2;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 1357975..b87db47 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -319,10 +319,9 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset, regval;
-	int16_t modalIdx, diff = 0;
+	int16_t diff = 0;
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 
-	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
 	xpdMask = pEepData->modalHeader.xpdGain;
 
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 045abd5..7a9d4a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1793,7 +1793,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	u16 capField = 0, eeval;
+	u16 eeval;
 	u8 ant_div_ctl1, tx_chainmask, rx_chainmask;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
@@ -1804,8 +1804,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		eeval |= AR9285_RDEXT_DEFAULT;
 	regulatory->current_rd_ext = eeval;
 
-	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
-
 	if (ah->opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (regulatory->current_rd == 0x64 ||
-- 
1.7.4.4

