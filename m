Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55440 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089Ab2CNPkq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 08/14] ath9k_hw: remove iniCommon_*_cck_fir_coeff_9271
Date: Wed, 14 Mar 2012 16:40:28 +0100
Message-Id: <1331739634-22318-8-git-send-email-nbd@openwrt.org> (sfid-20120314_164103_927209_3E3EFA12)
In-Reply-To: <1331739634-22318-7-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These arrays are unused

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    6 ------
 drivers/net/wireless/ath/ath9k/hw.h        |    2 --
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index e3f2689..2829c8c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -34,12 +34,6 @@ static void ar9002_hw_init_mode_regs(struct ath_hw *ah)
 			       ARRAY_SIZE(ar9271Modes_9271), 5);
 		INIT_INI_ARRAY(&ah->iniCommon, ar9271Common_9271,
 			       ARRAY_SIZE(ar9271Common_9271), 2);
-		INIT_INI_ARRAY(&ah->iniCommon_normal_cck_fir_coeff_9271,
-			       ar9287Common_normal_cck_fir_coeff_9287_1_1,
-			       ARRAY_SIZE(ar9287Common_normal_cck_fir_coeff_9287_1_1), 2);
-		INIT_INI_ARRAY(&ah->iniCommon_japan_2484_cck_fir_coeff_9271,
-			       ar9287Common_japan_2484_cck_fir_coeff_9287_1_1,
-			       ARRAY_SIZE(ar9287Common_japan_2484_cck_fir_coeff_9287_1_1), 2);
 		INIT_INI_ARRAY(&ah->iniModes_9271_1_0_only,
 			       ar9271Modes_9271_1_0_only,
 			       ARRAY_SIZE(ar9271Modes_9271_1_0_only), 5);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1aaf6d1..5b9f05b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -835,8 +835,6 @@ struct ath_hw {
 	struct ar5416IniArray iniCckfirNormal;
 	struct ar5416IniArray iniCckfirJapan2484;
 	struct ar5416IniArray ini_japan2484;
-	struct ar5416IniArray iniCommon_normal_cck_fir_coeff_9271;
-	struct ar5416IniArray iniCommon_japan_2484_cck_fir_coeff_9271;
 	struct ar5416IniArray iniModes_9271_ANI_reg;
 	struct ar5416IniArray iniModes_high_power_tx_gain_9271;
 	struct ar5416IniArray iniModes_normal_power_tx_gain_9271;
-- 
1.7.3.2

