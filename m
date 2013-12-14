Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48971 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 07/11] ath9k_hw: simplify spur channel handling
Date: Sat, 14 Dec 2013 18:03:41 +0100
Message-Id: <1387040625-38114-7-git-send-email-nbd@openwrt.org> (sfid-20131214_180422_279590_2B21C09B)
In-Reply-To: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove ah->config.spurmode and ah->config.spurchans, always use EEPROM
data.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c  |  1 -
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   | 26 +-------------------------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c | 26 +-------------------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c  | 26 +-------------------------
 drivers/net/wireless/ath/ath9k/hw.c          |  7 -------
 drivers/net/wireless/ath/ath9k/hw.h          |  5 -----
 6 files changed, 3 insertions(+), 88 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index f087117..9a2afa2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -201,7 +201,6 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	ath9k_hw_get_channel_centers(ah, chan, &centers);
 	freq = centers.synth_center;
 
-	ah->config.spurmode = SPUR_ENABLE_EEPROM;
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
 		cur_bb_spur = ah->eep_ops->get_spur_channel(ah, i, is2GHz);
 
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index b409171..07b806c 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -1085,31 +1085,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 
 static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
-#define EEP_MAP4K_SPURCHAN \
-	(ah->eeprom.map4k.modalHeader.spurChans[i].spurChan)
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	u16 spur_val = AR_NO_SPUR;
-
-	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
-
-	switch (ah->config.spurmode) {
-	case SPUR_DISABLE:
-		break;
-	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
-			spur_val);
-		break;
-	case SPUR_ENABLE_EEPROM:
-		spur_val = EEP_MAP4K_SPURCHAN;
-		break;
-	}
-
-	return spur_val;
-
-#undef EEP_MAP4K_SPURCHAN
+	return ah->eeprom.map4k.modalHeader.spurChans[i].spurChan;
 }
 
 const struct eeprom_ops eep_4k_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index e1d0c21..5ba1385 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -1004,31 +1004,7 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 					    u16 i, bool is2GHz)
 {
-#define EEP_MAP9287_SPURCHAN \
-	(ah->eeprom.map9287.modalHeader.spurChans[i].spurChan)
-
-	struct ath_common *common = ath9k_hw_common(ah);
-	u16 spur_val = AR_NO_SPUR;
-
-	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
-
-	switch (ah->config.spurmode) {
-	case SPUR_DISABLE:
-		break;
-	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
-			spur_val);
-		break;
-	case SPUR_ENABLE_EEPROM:
-		spur_val = EEP_MAP9287_SPURCHAN;
-		break;
-	}
-
-	return spur_val;
-
-#undef EEP_MAP9287_SPURCHAN
+	return ah->eeprom.map9287.modalHeader.spurChans[i].spurChan;
 }
 
 const struct eeprom_ops eep_ar9287_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 39107e3..3218ca9 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -1348,31 +1348,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 
 static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
-#define EEP_DEF_SPURCHAN \
-	(ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan)
-	struct ath_common *common = ath9k_hw_common(ah);
-
-	u16 spur_val = AR_NO_SPUR;
-
-	ath_dbg(common, ANI, "Getting spur idx:%d is2Ghz:%d val:%x\n",
-		i, is2GHz, ah->config.spurchans[i][is2GHz]);
-
-	switch (ah->config.spurmode) {
-	case SPUR_DISABLE:
-		break;
-	case SPUR_ENABLE_IOCTL:
-		spur_val = ah->config.spurchans[i][is2GHz];
-		ath_dbg(common, ANI, "Getting spur val from new loc. %d\n",
-			spur_val);
-		break;
-	case SPUR_ENABLE_EEPROM:
-		spur_val = EEP_DEF_SPURCHAN;
-		break;
-	}
-
-	return spur_val;
-
-#undef EEP_DEF_SPURCHAN
+	return ah->eeprom.def.modalHeader[is2GHz].spurChans[i].spurChan;
 }
 
 const struct eeprom_ops eep_def_ops = {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index eeb0741..a4f3d2b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -439,8 +439,6 @@ static bool ath9k_hw_chip_test(struct ath_hw *ah)
 
 static void ath9k_hw_init_config(struct ath_hw *ah)
 {
-	int i;
-
 	ah->config.dma_beacon_response_time = 1;
 	ah->config.sw_beacon_response_time = 6;
 	ah->config.additional_swba_backoff = 0;
@@ -448,11 +446,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.cwm_ignore_extcca = 0;
 	ah->config.analog_shiftreg = 1;
 
-	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
-		ah->config.spurchans[i][0] = AR_NO_SPUR;
-		ah->config.spurchans[i][1] = AR_NO_SPUR;
-	}
-
 	ah->config.rx_intr_mitigation = true;
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b8e2476..57d3d0c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -293,9 +293,6 @@ struct ath9k_ops_config {
 	int serialize_regmode;
 	bool rx_intr_mitigation;
 	bool tx_intr_mitigation;
-#define SPUR_DISABLE        	0
-#define SPUR_ENABLE_IOCTL   	1
-#define SPUR_ENABLE_EEPROM  	2
 #define AR_SPUR_5413_1      	1640
 #define AR_SPUR_5413_2      	1200
 #define AR_NO_SPUR      	0x8000
@@ -303,8 +300,6 @@ struct ath9k_ops_config {
 #define AR_BASE_FREQ_5GHZ   	4900
 #define AR_SPUR_FEEQ_BOUND_HT40 19
 #define AR_SPUR_FEEQ_BOUND_HT20 10
-	int spurmode;
-	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
 	u16 ani_poll_interval; /* ANI poll interval in ms */
 
-- 
1.8.3.4 (Apple Git-47)

