Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59640 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab3L1EWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Dec 2013 23:22:20 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] ath9k: Move private HW callbacks to hw-ops.h
Date: Sat, 28 Dec 2013 09:47:10 +0530
Message-Id: <1388204235-14682-2-git-send-email-sujith@msujith.org> (sfid-20131228_052245_582847_51BA53AB)
In-Reply-To: <1388204235-14682-1-git-send-email-sujith@msujith.org>
References: <1388204235-14682-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw-ops.h | 27 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c     | 39 ---------------------------------
 2 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 0b2550a..a47ea84 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -247,4 +247,31 @@ static inline void ath9k_hw_set_radar_params(struct ath_hw *ah)
 	ath9k_hw_private_ops(ah)->set_radar_params(ah, &ah->radar_conf);
 }
 
+static inline void ath9k_hw_init_cal_settings(struct ath_hw *ah)
+{
+	ath9k_hw_private_ops(ah)->init_cal_settings(ah);
+}
+
+static inline u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
+					       struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->compute_pll_control(ah, chan);
+}
+
+static inline void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->init_mode_gain_regs)
+		return;
+
+	ath9k_hw_private_ops(ah)->init_mode_gain_regs(ah);
+}
+
+static inline void ath9k_hw_ani_cache_ini_regs(struct ath_hw *ah)
+{
+	if (!ath9k_hw_private_ops(ah)->ani_cache_ini_regs)
+		return;
+
+	ath9k_hw_private_ops(ah)->ani_cache_ini_regs(ah);
+}
+
 #endif /* ATH9K_HW_OPS_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 77fb523..a0e62cc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -37,45 +37,6 @@ MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
 MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-/* Private hardware callbacks */
-
-static void ath9k_hw_init_cal_settings(struct ath_hw *ah)
-{
-	ath9k_hw_private_ops(ah)->init_cal_settings(ah);
-}
-
-static u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
-					struct ath9k_channel *chan)
-{
-	return ath9k_hw_private_ops(ah)->compute_pll_control(ah, chan);
-}
-
-static void ath9k_hw_init_mode_gain_regs(struct ath_hw *ah)
-{
-	if (!ath9k_hw_private_ops(ah)->init_mode_gain_regs)
-		return;
-
-	ath9k_hw_private_ops(ah)->init_mode_gain_regs(ah);
-}
-
-static void ath9k_hw_ani_cache_ini_regs(struct ath_hw *ah)
-{
-	/* You will not have this callback if using the old ANI */
-	if (!ath9k_hw_private_ops(ah)->ani_cache_ini_regs)
-		return;
-
-	ath9k_hw_private_ops(ah)->ani_cache_ini_regs(ah);
-}
-
-/********************/
-/* Helper Functions */
-/********************/
-
-#ifdef CONFIG_ATH9K_DEBUGFS
-
-#endif
-
-
 static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-- 
1.8.5.2

