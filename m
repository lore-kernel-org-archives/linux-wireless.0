Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39944 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3ATRwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:12 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 6/8] ath9k_hw: remove ath9k_hw_ani_setup and its variables
Date: Sun, 20 Jan 2013 18:51:57 +0100
Message-Id: <1358704319-81749-6-git-send-email-nbd@openwrt.org> (sfid-20130120_185217_792796_A7F8511F)
In-Reply-To: <1358704319-81749-5-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
 <1358704319-81749-2-git-send-email-nbd@openwrt.org>
 <1358704319-81749-3-git-send-email-nbd@openwrt.org>
 <1358704319-81749-4-git-send-email-nbd@openwrt.org>
 <1358704319-81749-5-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are no longer needed for ANI functionality

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 17 -----------------
 drivers/net/wireless/ath/ath9k/ani.h |  1 -
 drivers/net/wireless/ath/ath9k/hw.c  |  4 +---
 drivers/net/wireless/ath/ath9k/hw.h  |  4 ----
 4 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index e09ec40..2978287 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -489,23 +489,6 @@ void ath9k_hw_disable_mib_counters(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_disable_mib_counters);
 
-void ath9k_hw_ani_setup(struct ath_hw *ah)
-{
-	int i;
-
-	static const int totalSizeDesired[] = { -55, -55, -55, -55, -62 };
-	static const int coarseHigh[] = { -14, -14, -14, -14, -12 };
-	static const int coarseLow[] = { -64, -64, -64, -64, -70 };
-	static const int firpwr[] = { -78, -78, -78, -78, -80 };
-
-	for (i = 0; i < 5; i++) {
-		ah->totalSizeDesired[i] = totalSizeDesired[i];
-		ah->coarse_high[i] = coarseHigh[i];
-		ah->coarse_low[i] = coarseLow[i];
-		ah->firpwr[i] = firpwr[i];
-	}
-}
-
 void ath9k_hw_ani_init(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 1485bf5..385bdba 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -147,7 +147,6 @@ struct ar5416Stats {
 
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
-void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
 
 #endif /* ANI_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 0d84c1c..42cf3c7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -549,10 +549,8 @@ static int ath9k_hw_post_init(struct ath_hw *ah)
 		ah->eep_ops->get_eeprom_ver(ah),
 		ah->eep_ops->get_eeprom_rev(ah));
 
-	if (ah->config.enable_ani) {
-		ath9k_hw_ani_setup(ah);
+	if (ah->config.enable_ani)
 		ath9k_hw_ani_init(ah);
-	}
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 639d60d..9b6e45d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -857,10 +857,6 @@ struct ath_hw {
 	/* ANI */
 	u32 proc_phyerr;
 	u32 aniperiod;
-	int totalSizeDesired[5];
-	int coarse_high[5];
-	int coarse_low[5];
-	int firpwr[5];
 	enum ath9k_ani_cmd ani_function;
 	u32 ani_skip_count;
 
-- 
1.8.0.2

