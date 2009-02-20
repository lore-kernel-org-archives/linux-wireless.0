Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16417 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbZBTJrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 04:47:08 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 01:47:08 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18846.31537.167252.116124@gargle.gargle.HOWL> (sfid-20090220_104714_557230_13129046)
Date: Fri, 20 Feb 2009 15:13:13 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/5] ath9k: Remove multiple macro occurrences
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OLC_FOR_AR9280_20_LATER is defined in multiple places,
move it to a common location.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c  |    2 --
 drivers/net/wireless/ath9k/eeprom.c |    2 --
 drivers/net/wireless/ath9k/eeprom.h |    3 +++
 drivers/net/wireless/ath9k/hw.c     |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 93c6e1f..1c074c0 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -749,8 +749,6 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal,
 			bool *isCalDone)
 {
-#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
-				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 	struct hal_cal_list *currCal = ah->cal_list_curr;
 
 	*isCalDone = true;
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 8379a42..17b3d04 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -2164,8 +2164,6 @@ static bool ath9k_hw_set_def_power_cal_table(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
 				  int16_t *pTxPowerIndexOffset)
 {
-#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
-				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 #define SM_PD_GAIN(x) SM(0x38, AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##x)
 #define SM_PDGAIN_B(x, y) \
 		SM((gainBoundaries[x]), AR_PHY_TPCRG5_PD_GAIN_BOUNDARY_##y)
diff --git a/drivers/net/wireless/ath9k/eeprom.h b/drivers/net/wireless/ath9k/eeprom.h
index 2cfea5d..6296e3e 100644
--- a/drivers/net/wireless/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath9k/eeprom.h
@@ -95,6 +95,9 @@
 #define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
 #define ath9k_hw_use_flash(_ah)	(!(_ah->ah_flags & AH_USE_EEPROM))
 
+#define OLC_FOR_AR9280_20_LATER (AR_SREV_9280_20_OR_LATER(ah) && \
+				 ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
+
 #define AR_EEPROM_RFSILENT_GPIO_SEL     0x001c
 #define AR_EEPROM_RFSILENT_GPIO_SEL_S   2
 #define AR_EEPROM_RFSILENT_POLARITY     0x0002
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 2c0173a..6f2e92e 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1219,8 +1219,6 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
 {
-#define OLC_FOR_AR9280_20_LATER	(AR_SREV_9280_20_OR_LATER(ah) && \
-				ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 	int i, regWrites = 0;
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
-- 
1.6.1

