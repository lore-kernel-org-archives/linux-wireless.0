Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41817 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbA3Ncz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:55 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgs-004FiR-6C
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:54 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 11/17] ath9k: Simplify user pattern configuration
Date: Fri, 30 Jan 2015 19:05:31 +0530
Message-Id: <1422624937-4810-12-git-send-email-sujith@msujith.org> (sfid-20150130_143258_974603_65327208)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no need to allocate a new structure and
free it for every user pattern, instead use local
variables.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  6 -----
 drivers/net/wireless/ath/ath9k/wow.c   | 49 +++++++++-------------------------
 2 files changed, 12 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 20216c5..0f8e946 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -830,12 +830,6 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 /* Wake on Wireless LAN */
 /************************/
 
-struct ath9k_wow_pattern {
-	u8 pattern_bytes[MAX_PATTERN_SIZE];
-	u8 mask_bytes[MAX_PATTERN_SIZE];
-	u32 pattern_len;
-};
-
 #ifdef CONFIG_ATH9K_WOW
 void ath9k_init_wow(struct ieee80211_hw *hw);
 void ath9k_deinit_wow(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 4b3b565..da52b1f 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -128,50 +128,25 @@ static void ath9k_wow_add_pattern(struct ath_softc *sc,
 				  struct cfg80211_wowlan *wowlan)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_wow_pattern *wow_pattern = NULL;
 	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
+	u8 wow_pattern[MAX_PATTERN_SIZE];
+	u8 wow_mask[MAX_PATTERN_SIZE];
 	int mask_len;
 	s8 i = 0;
 
-	if (!wowlan->n_patterns)
-		return;
-
-	/*
-	 * Add the new user configured patterns
-	 */
 	for (i = 0; i < wowlan->n_patterns; i++) {
-
-		wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
-
-		if (!wow_pattern)
-			return;
-
-		/*
-		 * TODO: convert the generic user space pattern to
-		 * appropriate chip specific/802.11 pattern.
-		 */
-
-		mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
-		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
-		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);
-		memcpy(wow_pattern->pattern_bytes, patterns[i].pattern,
-		       patterns[i].pattern_len);
-		memcpy(wow_pattern->mask_bytes, patterns[i].mask, mask_len);
-		wow_pattern->pattern_len = patterns[i].pattern_len;
-
-		/*
-		 * just need to take care of deauth and disssoc pattern,
-		 * make sure we don't overwrite them.
-		 */
-
-		ath9k_hw_wow_apply_pattern(ah, wow_pattern->pattern_bytes,
-					   wow_pattern->mask_bytes,
+		mask_len = DIV_ROUND_UP(patterns[i].pattern_len, 8);
+		memset(wow_pattern, 0, MAX_PATTERN_SIZE);
+		memset(wow_mask, 0, MAX_PATTERN_SIZE);
+		memcpy(wow_pattern, patterns[i].pattern, patterns[i].pattern_len);
+		memcpy(wow_mask, patterns[i].mask, mask_len);
+
+		ath9k_hw_wow_apply_pattern(ah,
+					   wow_pattern,
+					   wow_mask,
 					   i + 2,
-					   wow_pattern->pattern_len);
-		kfree(wow_pattern);
-
+					   patterns[i].pattern_len);
 	}
-
 }
 
 int ath9k_suspend(struct ieee80211_hw *hw,
-- 
2.2.2

