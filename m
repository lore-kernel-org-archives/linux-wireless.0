Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:53224 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3IBIcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:32:55 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/8] ath9k: Bypass EEPROM for diversity cap for AR9565
Date: Mon,  2 Sep 2013 13:59:00 +0530
Message-Id: <1378110546-22305-2-git-send-email-sujith@msujith.org> (sfid-20130902_103313_464891_AFC8C8F2)
In-Reply-To: <1378110546-22305-1-git-send-email-sujith@msujith.org>
References: <21028.19411.335796.192256@gargle.gargle.HOWL>
 <1378110546-22305-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use a default antenna diversity value for AR9565 instead
of relying on the EEPROM/OTP programmed value.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 5 ++++-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index f486480..6af2d73 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -2991,7 +2991,10 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_CHAIN_MASK_REDUCE:
 		return (pBase->miscConfiguration >> 0x3) & 0x1;
 	case EEP_ANT_DIV_CTL1:
-		return eep->base_ext1.ant_div_control;
+		if (AR_SREV_9565(ah))
+			return AR9300_EEP_ANTDIV_CONTROL_DEFAULT_VALUE;
+		else
+			return eep->base_ext1.ant_div_control;
 	case EEP_ANTENNA_GAIN_5G:
 		return eep->modalHeader5G.antennaGain;
 	case EEP_ANTENNA_GAIN_2G:
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 75d4fb4..0e5daa5 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -52,6 +52,8 @@
 #define AR9300_PAPRD_SCALE_2		0x70000000
 #define AR9300_PAPRD_SCALE_2_S		28
 
+#define AR9300_EEP_ANTDIV_CONTROL_DEFAULT_VALUE 0xc9
+
 /* Delta from which to start power to pdadc table */
 /* This offset is used in both open loop and closed loop power control
  * schemes. In open loop power control, it is not really needed, but for
-- 
1.8.4

