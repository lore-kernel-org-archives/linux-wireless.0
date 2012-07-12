Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49582 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab2GLPEU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 11:04:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 09/12] ath9k_hw: apply XPA timing control values from EEPROM
Date: Thu, 12 Jul 2012 17:04:08 +0200
Message-Id: <1342105451-42297-9-git-send-email-nbd@openwrt.org> (sfid-20120712_170444_271876_89B39D06)
In-Reply-To: <1342105451-42297-8-git-send-email-nbd@openwrt.org>
References: <1342105451-42297-1-git-send-email-nbd@openwrt.org>
 <1342105451-42297-2-git-send-email-nbd@openwrt.org>
 <1342105451-42297-3-git-send-email-nbd@openwrt.org>
 <1342105451-42297-4-git-send-email-nbd@openwrt.org>
 <1342105451-42297-5-git-send-email-nbd@openwrt.org>
 <1342105451-42297-6-git-send-email-nbd@openwrt.org>
 <1342105451-42297-7-git-send-email-nbd@openwrt.org>
 <1342105451-42297-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 3cddd78..86e4be4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3962,9 +3962,32 @@ static void ar9003_hw_txend_to_xpa_off_apply(struct ath_hw *ah, u16 freq)
 		      AR_PHY_XPA_TIMING_CTL_TX_END_XPAA_OFF, value);
 }
 
+static void ar9003_hw_xpa_timing_control_apply(struct ath_hw *ah, bool is_2ghz)
+{
+	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	u8 xpa_ctl;
+
+	if (!(eep->baseEepHeader.featureEnable & 0x80))
+		return;
+
+	if (!AR_SREV_9300(ah) && !AR_SREV_9340(ah) && !AR_SREV_9580(ah))
+		return;
+
+	if (is_2ghz) {
+		xpa_ctl = eep->modalHeader2G.txFrameToXpaOn;
+		REG_RMW_FIELD(ah, AR_PHY_XPA_TIMING_CTL,
+			      AR_PHY_XPA_TIMING_CTL_FRAME_XPAB_ON, xpa_ctl);
+	} else {
+		xpa_ctl = eep->modalHeader5G.txFrameToXpaOn;
+		REG_RMW_FIELD(ah, AR_PHY_XPA_TIMING_CTL,
+			      AR_PHY_XPA_TIMING_CTL_FRAME_XPAA_ON, xpa_ctl);
+	}
+}
+
 static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 					     struct ath9k_channel *chan)
 {
+	ar9003_hw_xpa_timing_control_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_xpa_bias_level_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_ant_ctrl_apply(ah, IS_CHAN_2GHZ(chan));
 	ar9003_hw_drive_strength_apply(ah);
-- 
1.7.3.2

