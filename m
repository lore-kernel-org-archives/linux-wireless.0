Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42628 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2EXEEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:04:35 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45842.425459.886973@gargle.gargle.HOWL> (sfid-20120524_060438_792439_51B76900)
Date: Thu, 24 May 2012 09:33:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 16/22] ath9k_hw: configure ar9462 switching regulator
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

Enable WLAN and BT mode for switching regulator discontinuous
orverride for AR9462 chips.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++++
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 drivers/net/wireless/ath/ath9k/reg.h        |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 11abb97..d6baf69 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -676,6 +676,10 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (chan->channel == 2484)
 		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
 
+	if (AR_SREV_9462(ah))
+		REG_WRITE(ah, AR_GLB_SWREG_DISCONT_MODE,
+			  AR_GLB_SWREG_DISCONT_EN_BT_WLAN);
+
 	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3740aab..03d5909 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -824,7 +824,6 @@ struct ath_hw {
 	struct ar5416IniArray ini_japan2484;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray ini_radio_post_sys2ant;
-	struct ar5416IniArray ini_BTCOEX_MAX_TXPWR;
 
 	struct ar5416IniArray iniMac[ATH_INI_NUM_SPLIT];
 	struct ar5416IniArray iniBB[ATH_INI_NUM_SPLIT];
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 458f81b..560d6ef 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -2211,5 +2211,7 @@ enum {
 #define AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT	0x00000fff
 #define AR_BTCOEX_CTRL3_CONT_INFO_TIMEOUT_S	0
 
+#define AR_GLB_SWREG_DISCONT_MODE         0x2002c
+#define AR_GLB_SWREG_DISCONT_EN_BT_WLAN   0x3
 
 #endif
-- 
1.7.10.2

