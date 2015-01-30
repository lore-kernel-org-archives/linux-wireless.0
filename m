Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:35279 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbbA3NdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:33:03 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBh0-004FiR-6J
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:33:02 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 17/17] ath9k: Fix max pattern check
Date: Fri, 30 Jan 2015 19:05:37 +0530
Message-Id: <1422624937-4810-18-git-send-email-sujith@msujith.org> (sfid-20150130_143630_422733_C679112D)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the maximum number of configurable patterns
is chip-specific, use the HW capability instead
of a fixed value for checking if a free pattern
slot is available.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 12 +++----
 drivers/net/wireless/ath/ath9k/hw.h         | 17 ++++-----
 drivers/net/wireless/ath/ath9k/wow.c        | 53 ++++++++++++++++++++---------
 3 files changed, 51 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 6681a7b..d2a4f6f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -89,17 +89,16 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 
 }
 
-void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
-				u8 *user_mask, int pattern_count,
-				int pattern_len)
+int ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
+			       u8 *user_mask, int pattern_count,
+			       int pattern_len)
 {
 	int i;
 	u32 pattern_val, mask_val;
 	u32 set, clr;
 
-	/* FIXME: should check count by querying the hardware capability */
-	if (pattern_count >= MAX_NUM_PATTERN)
-		return;
+	if (pattern_count >= ah->wow.max_patterns)
+		return -ENOSPC;
 
 	REG_SET_BIT(ah, AR_WOW_PATTERN, BIT(pattern_count));
 
@@ -154,6 +153,7 @@ void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 		REG_RMW(ah, AR_WOW_LENGTH2, set, clr);
 	}
 
+	return 0;
 }
 EXPORT_SYMBOL(ath9k_hw_wow_apply_pattern);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index e1801c9..f51a28f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1152,18 +1152,19 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 
 
 #ifdef CONFIG_ATH9K_WOW
-void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
-				u8 *user_mask, int pattern_count,
-				int pattern_len);
+int ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
+			       u8 *user_mask, int pattern_count,
+			       int pattern_len);
 u32 ath9k_hw_wow_wakeup(struct ath_hw *ah);
 void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable);
 #else
-static inline void ath9k_hw_wow_apply_pattern(struct ath_hw *ah,
-					      u8 *user_pattern,
-					      u8 *user_mask,
-					      int pattern_count,
-					      int pattern_len)
+static inline int ath9k_hw_wow_apply_pattern(struct ath_hw *ah,
+					     u8 *user_pattern,
+					     u8 *user_mask,
+					     int pattern_count,
+					     int pattern_len)
 {
+	return 0;
 }
 static inline u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index da52b1f..5092939 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -40,12 +40,12 @@ static u8 ath9k_wow_map_triggers(struct ath_softc *sc,
 	return wow_triggers;
 }
 
-static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
+static int ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int pattern_count = 0;
-	int i, byte_cnt = 0;
+	int ret, i, byte_cnt = 0;
 	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
 	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
 
@@ -110,8 +110,10 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	dis_deauth_mask[1] = 0x03;
 	dis_deauth_mask[2] = 0xc0;
 
-	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
-				   pattern_count, byte_cnt);
+	ret = ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+					 pattern_count, byte_cnt);
+	if (ret)
+		goto exit;
 
 	pattern_count++;
 	/*
@@ -120,18 +122,20 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	 */
 	dis_deauth_pattern[0] = 0xC0;
 
-	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
-				   pattern_count, byte_cnt);
+	ret = ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+					 pattern_count, byte_cnt);
+exit:
+	return ret;
 }
 
-static void ath9k_wow_add_pattern(struct ath_softc *sc,
-				  struct cfg80211_wowlan *wowlan)
+static int ath9k_wow_add_pattern(struct ath_softc *sc,
+				 struct cfg80211_wowlan *wowlan)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
 	u8 wow_pattern[MAX_PATTERN_SIZE];
 	u8 wow_mask[MAX_PATTERN_SIZE];
-	int mask_len;
+	int mask_len, ret = 0;
 	s8 i = 0;
 
 	for (i = 0; i < wowlan->n_patterns; i++) {
@@ -141,12 +145,16 @@ static void ath9k_wow_add_pattern(struct ath_softc *sc,
 		memcpy(wow_pattern, patterns[i].pattern, patterns[i].pattern_len);
 		memcpy(wow_mask, patterns[i].mask, mask_len);
 
-		ath9k_hw_wow_apply_pattern(ah,
-					   wow_pattern,
-					   wow_mask,
-					   i + 2,
-					   patterns[i].pattern_len);
+		ret = ath9k_hw_wow_apply_pattern(ah,
+						 wow_pattern,
+						 wow_mask,
+						 i + 2,
+						 patterns[i].pattern_len);
+		if (ret)
+			break;
 	}
+
+	return ret;
 }
 
 int ath9k_suspend(struct ieee80211_hw *hw,
@@ -213,10 +221,21 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	 * Enable wake up on recieving disassoc/deauth
 	 * frame by default.
 	 */
-	ath9k_wow_add_disassoc_deauth_pattern(sc);
+	ret = ath9k_wow_add_disassoc_deauth_pattern(sc);
+	if (ret) {
+		ath_err(common,
+			"Unable to add disassoc/deauth pattern: %d\n", ret);
+		goto fail_wow;
+	}
 
-	if (triggers & AH_WOW_USER_PATTERN_EN)
-		ath9k_wow_add_pattern(sc, wowlan);
+	if (triggers & AH_WOW_USER_PATTERN_EN) {
+		ret = ath9k_wow_add_pattern(sc, wowlan);
+		if (ret) {
+			ath_err(common,
+				"Unable to add user pattern: %d\n", ret);
+			goto fail_wow;
+		}
+	}
 
 	spin_lock_bh(&sc->sc_pcu_lock);
 	/*
-- 
2.2.2

