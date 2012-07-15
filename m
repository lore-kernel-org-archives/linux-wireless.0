Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40173 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 12/12] ath9k_hw: fix SREV checks for applying tuning caps from EEPROM
Date: Sun, 15 Jul 2012 19:53:40 +0200
Message-Id: <1342374820-92409-12-git-send-email-nbd@openwrt.org> (sfid-20120715_195400_439395_96FE2A09)
In-Reply-To: <1342374820-92409-11-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
 <1342374820-92409-2-git-send-email-nbd@openwrt.org>
 <1342374820-92409-3-git-send-email-nbd@openwrt.org>
 <1342374820-92409-4-git-send-email-nbd@openwrt.org>
 <1342374820-92409-5-git-send-email-nbd@openwrt.org>
 <1342374820-92409-6-git-send-email-nbd@openwrt.org>
 <1342374820-92409-7-git-send-email-nbd@openwrt.org>
 <1342374820-92409-8-git-send-email-nbd@openwrt.org>
 <1342374820-92409-9-git-send-email-nbd@openwrt.org>
 <1342374820-92409-10-git-send-email-nbd@openwrt.org>
 <1342374820-92409-11-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9485, AR9330 and AR9340 are the chips that this is *NOT* supposed to be
applied on.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index c5f3c43..b5c8450 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3890,6 +3890,9 @@ static void ar9003_hw_apply_tuning_caps(struct ath_hw *ah)
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
 	u8 tuning_caps_param = eep->baseEepHeader.params_for_tuning_caps[0];
 
+	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
+		return;
+
 	if (eep->baseEepHeader.featureEnable & 0x40) {
 		tuning_caps_param &= 0x7f;
 		REG_RMW_FIELD(ah, AR_CH0_XTAL, AR_CH0_XTAL_CAPINDAC,
@@ -3987,8 +3990,7 @@ static void ath9k_hw_ar9300_set_board_values(struct ath_hw *ah,
 	ar9003_hw_quick_drop_apply(ah, chan->channel);
 	if (!AR_SREV_9330(ah) && !AR_SREV_9340(ah) && !AR_SREV_9550(ah))
 		ar9003_hw_internal_regulator_apply(ah);
-	if (AR_SREV_9485(ah) || AR_SREV_9330(ah) || AR_SREV_9340(ah))
-		ar9003_hw_apply_tuning_caps(ah);
+	ar9003_hw_apply_tuning_caps(ah);
 	ar9003_hw_txend_to_xpa_off_apply(ah, is2ghz);
 }
 
-- 
1.7.7.5 (Apple Git-26)

