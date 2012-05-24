Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55999 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab2EXMcj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 08:32:39 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.5 4/4] ath9k_hw: apply internal regulator settings on AR933x
Date: Thu, 24 May 2012 14:32:22 +0200
Message-Id: <1337862742-10574-4-git-send-email-nbd@openwrt.org> (sfid-20120524_143244_311027_603A4AA3)
In-Reply-To: <1337862742-10574-3-git-send-email-nbd@openwrt.org>
References: <1337862742-10574-1-git-send-email-nbd@openwrt.org>
 <1337862742-10574-2-git-send-email-nbd@openwrt.org>
 <1337862742-10574-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AR933x, the internal regulator settings need to be applied before the
PLL init to avoid stability issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |    3 +++
 drivers/net/wireless/ath/ath9k/hw.c            |    3 +++
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index ac53d90..dfb0441 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3809,7 +3809,7 @@ static bool is_pmu_set(struct ath_hw *ah, u32 pmu_reg, int pmu_set)
 	return true;
 }
 
-static void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
+void ar9003_hw_internal_regulator_apply(struct ath_hw *ah)
 {
 	int internal_regulator =
 		ath9k_hw_ar9300_get_eeprom(ah, EEP_INTERNAL_REGULATOR);
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 2505ac4..8396d15 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -334,4 +334,7 @@ u8 *ar9003_get_spur_chan_ptr(struct ath_hw *ah, bool is_2ghz);
 
 unsigned int ar9003_get_paprd_scale_factor(struct ath_hw *ah,
 					   struct ath9k_channel *chan);
+
+void ar9003_hw_internal_regulator_apply(struct ath_hw *ah);
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index abe05ec..7db1890 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1468,6 +1468,9 @@ static bool ath9k_hw_chip_reset(struct ath_hw *ah,
 		return false;
 
 	ah->chip_fullsleep = false;
+
+	if (AR_SREV_9330(ah))
+		ar9003_hw_internal_regulator_apply(ah);
 	ath9k_hw_init_pll(ah, chan);
 	ath9k_hw_set_rfmode(ah, chan);
 
-- 
1.7.3.2

