Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34775 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbA3Ncw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:52 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgp-004FiR-LU
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:52 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 09/17] ath9k: Remove ath9k_hw_wow_event_to_string
Date: Fri, 30 Jan 2015 19:05:29 +0530
Message-Id: <1422624937-4810-10-git-send-email-sujith@msujith.org> (sfid-20150130_143348_728212_A5EF7823)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Printing the value of the wakeup status is sufficient.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 15 ---------------
 drivers/net/wireless/ath/ath9k/hw.h         |  5 -----
 drivers/net/wireless/ath/ath9k/wow.c        | 10 +++-------
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 81c88dd..3abc907 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -19,21 +19,6 @@
 #include "reg.h"
 #include "hw-ops.h"
 
-const char *ath9k_hw_wow_event_to_string(u32 wow_event)
-{
-	if (wow_event & AH_WOW_MAGIC_PATTERN_EN)
-		return "Magic pattern";
-	if (wow_event & AH_WOW_USER_PATTERN_EN)
-		return "User pattern";
-	if (wow_event & AH_WOW_LINK_CHANGE)
-		return "Link change";
-	if (wow_event & AH_WOW_BEACON_MISS)
-		return "Beacon miss";
-
-	return  "unknown reason";
-}
-EXPORT_SYMBOL(ath9k_hw_wow_event_to_string);
-
 static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dabc94e..22b0422 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1146,17 +1146,12 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 
 
 #ifdef CONFIG_ATH9K_WOW
-const char *ath9k_hw_wow_event_to_string(u32 wow_event);
 void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 				u8 *user_mask, int pattern_count,
 				int pattern_len);
 u32 ath9k_hw_wow_wakeup(struct ath_hw *ah);
 void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable);
 #else
-static inline const char *ath9k_hw_wow_event_to_string(u32 wow_event)
-{
-	return NULL;
-}
 static inline void ath9k_hw_wow_apply_pattern(struct ath_hw *ah,
 					      u8 *user_pattern,
 					      u8 *user_mask,
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index fa60dbb..d4cfbc3 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -281,7 +281,7 @@ int ath9k_resume(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 wow_status;
+	u8 status;
 
 	mutex_lock(&sc->mutex);
 
@@ -296,12 +296,8 @@ int ath9k_resume(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
-	wow_status = ath9k_hw_wow_wakeup(ah);
-
-	if (wow_status) {
-		ath_dbg(common, ANY, "Waking up due to WoW triggers %s with WoW status = %x\n",
-			ath9k_hw_wow_event_to_string(wow_status), wow_status);
-	}
+	status = ath9k_hw_wow_wakeup(ah);
+	ath_dbg(common, WOW, "Resume with WoW status: 0x%x\n", status);
 
 	ath_restart_work(sc);
 	ath9k_start_btcoex(sc);
-- 
2.2.2

