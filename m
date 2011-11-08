Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27903 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab1KHItP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 03:49:15 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/4] ath9k_hw: Read and configure xpa timing field
Date: Tue, 8 Nov 2011 14:19:33 +0530
Message-ID: <1320742175-10962-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111108_094917_921932_CA6D3CA4)
In-Reply-To: <1320742175-10962-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1320742175-10962-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure xpa timing field while loading boad defaults to
fix 11b CCK spur issue that was observed in EMI testing.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index de103ef..5fb3f54 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3411,6 +3411,7 @@ static u32 ar9003_dump_modal_eeprom(char *buf, u32 len, u32 size,
 	PR_EEP("Chain1 NF Threshold", modal_hdr->noiseFloorThreshCh[1]);
 	PR_EEP("Chain2 NF Threshold", modal_hdr->noiseFloorThreshCh[2]);
 	PR_EEP("Quick Drop", modal_hdr->quick_drop);
+	PR_EEP("txEndToXpaOff", modal_hdr->txEndToXpaOff);
 	PR_EEP("xPA Bias Level", modal_hdr->xpaBiasLvl);
 	PR_EEP("txFrameToDataStart", modal_hdr->txFrameToDataStart);
 	PR_EEP("txFrameToPaOn", modal_hdr->txFrameToPaOn);
@@ -3956,6 +3957,20 @@ static void ar9003_hw_quick_drop_apply(struct ath_hw *ah, u16 freq)
 	REG_RMW_FIELD(ah, AR_PHY_AGC, AR_PHY_AGC_QUICK_DROP, quick_drop);
 }
 
+static void ar9003_hw_txend_to_xpa_off_apply(struct ath_hw *ah, u16 freq)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	u32 value;
+
+	value = (freq < 4000) ? eep->modalHeader2G.txEndToXpaOff :
+				eep->modalHeader5G.txEndToXpaOff;
+
+	REG_RMW_FIELD(ah, AR_PHY_XPA_TIMING_CTL,
+		      AR_PHY_XPA_TIMING_CTL_TX_END_XPAB_OFF, value);
+	REG_RMW_FIELD(ah, AR_PHY_XPA_TIMING_CTL,
+		      AR_PHY_XPA_TIMING_CTL_TX_END_XPAA_OFF, value);
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
@@ -3968,6 +3983,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 		ar9003_hw_internal_regulator_apply(ah);
 	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
 		ar9003_hw_apply_tuning_caps(ah);
+	ar9003_hw_txend_to_xpa_off_apply(ah, chan->channel);
 }
 
 static void ath9k_hw_ar9300_set_addac(struct ath_hw *ah,
-- 
1.7.7.2

