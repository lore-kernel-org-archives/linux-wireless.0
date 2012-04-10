Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30341 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab2DJPP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:15:59 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [WIP 10/11] ath9k: Add debug messages for WoW
Date: Tue, 10 Apr 2012 20:43:20 +0530
Message-ID: <1334070801-21708-11-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171610_104667_206B033E)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

add sufficient debug messages in the driver for
debugging WoW

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   91 +++++++++++++++++++++++++++++----
 1 files changed, 80 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7b8b8a9..92637da 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2521,6 +2521,8 @@ void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 		dis_deauth_mask[3] = 0xfc;
 	}
 
+	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
+
 	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
 				   pattern_count, byte_cnt);
 
@@ -2544,6 +2546,7 @@ void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
 	struct ath9k_wow_pattern *wow_pattern  = NULL;
 	struct cfg80211_wowlan_trig_pkt_pattern *patterns = wowlan->patterns;
 	s8 i = 0;
+	u16 j = 0;
 
 	/*
 	 * check for duplicate patterns
@@ -2553,8 +2556,11 @@ void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
 			if (!memcmp(wow_pattern->pattern_bytes,
 				    patterns->pattern, MAX_PATTERN_SIZE) &&
 			    !memcmp(wow_pattern->mask_bytes,
-				    patterns->mask, MAX_PATTERN_SIZE))
+				    patterns->mask, MAX_PATTERN_SIZE)) {
+				ath_dbg(common, WOW, "duplicate WOW pattern"
+					"detected returning\n");
 				return;
+			}
 		}
 
 		i++;
@@ -2567,12 +2573,16 @@ void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
 
 	list_for_each_entry(wow_pattern, &wow_info->wow_patterns, list) {
 
-
+		/* check if we have free slot for the new pattern */
 		if (!wow_pattern->slot) {
 			wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
 
-			if (!wow_pattern)
+			if (!wow_pattern) {
+				ath_dbg(common, WOW, "memory allocation failed"
+					"for wow_pattern driver structure\n");
 				return;
+			}
+
 			memcpy(wow_pattern->pattern_bytes,
 			       patterns->pattern, MAX_PATTERN_SIZE);
 			memcpy(wow_pattern->mask_bytes,
@@ -2582,11 +2592,42 @@ void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
 			list_add_tail(&wow_pattern->list,
 				      &wow_info->wow_patterns);
 
-			wow_info->num_of_patterns = i + 2;
 			/*
-			 * just need to take care of deauth and
+			 * need to take care of deauth and
 			 * disssoc pattern, make sure we don't overwirte
 			 */
+			wow_info->num_of_patterns = i + 2;
+
+			ath_dbg(common, WOW, "number of WOW patterns"
+				"configured %u", wow_info->num_of_patterns);
+
+			ath_dbg(common, WOW, "WoW pattern_len %u",
+				wow_pattern->pattern_len);
+
+			ath_dbg(common, WOW, "WoW patterns:\n");
+
+			for (j = 0; j < MAX_PATTERN_SIZE; j++) {
+
+				if (j && !(j % 32))
+					ath_dbg(common, WOW, "\n");
+
+				ath_dbg(common, WOW, "0x%x",
+					wow_pattern->pattern_bytes[j]);
+
+			}
+
+			ath_dbg(common, WOW, "WoW mask:\n");
+
+			for (j = 0; j < MAX_PATTERN_SIZE; j++) {
+
+				if (j && !(j % 32))
+					ath_dbg(common, WOW, "\n");
+
+				ath_dbg(common, WOW, "0x%x",
+					wow_pattern->mask_bytes[j]);
+
+			}
+
 
 			ath9k_hw_wow_apply_pattern(ah,
 						   wow_pattern->pattern_bytes,
@@ -2598,8 +2639,11 @@ void ath9k_wow_add_pattern(struct ath_softc *sc, struct cfg80211_wowlan *wowlan)
 
 		i++;
 
-		if (i >= MAX_NUM_USER_PATTERN)
+		if (i >= MAX_NUM_USER_PATTERN) {
+			ath_dbg(common, WOW, "no available slot for new"
+				"WOW pattern\n");
 			break;
+		}
 	}
 
 }
@@ -2617,12 +2661,16 @@ static int ath9k_suspend(struct ieee80211_hw *hw,
 
 	sc->wow_enabled = false;
 
-	if (WARN_ON(!wowlan))
+	if (WARN_ON(!wowlan)) {
+		ath_dbg(common, WOW, "None of the WoW triggers enabled");
 		return -EINVAL;
+	}
 
 	ath9k_ps_wakeup(sc);
 
 	if (!device_can_wakeup(sc->dev)) {
+		ath_dbg(common, WOW, "device_can_wakeup failed"
+			"WoW is not enabled");
 		ret = 1;
 		goto fail_wow;
 	}
@@ -2634,13 +2682,33 @@ static int ath9k_suspend(struct ieee80211_hw *hw,
 	 * configure 'keep alive frame' for each
 	 * STA
 	 */
-	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF) || (sc->nvifs > 1)) {
+	if (sc->nvifs > 1) {
+		ath_dbg(common, WOW, "more than one interfaces"
+			"Currently WoW for multivif is not handled"
+			"WoW is not enabled %s\n", __func__);
+		ret = 1;
+		goto fail_wow;
+	}
+
+	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF))  {
+		ath_dbg(common, WOW, "None of the STA vifs are associated"
+			"WoW is not enabled %s\n", __func__);
 		ret = 1;
 		goto fail_wow;
 	}
 
+
 	wow_triggers_enabled = ath9k_wow_map_triggers(sc, wowlan);
 
+	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
+			      wow_triggers_enabled);
+
+	if (!wow_triggers_enabled) {
+		ath_dbg(common, WOW, "No WoW triggers are configured\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
 	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN) {
 		ath9k_wow_add_disassoc_deauth_pattern(sc);
 		ath9k_wow_add_pattern(sc, wowlan);
@@ -2678,8 +2746,10 @@ static int ath9k_resume(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 
-	if (!sc->wow_enabled)
+	if (!sc->wow_enabled) {
+		ath_dbg(common, ANY, "WoW not enabled %s\n", __func__);
 		goto wow_unlock;
+	}
 
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_disable_interrupts(ah);
@@ -2703,14 +2773,13 @@ static int ath9k_resume(struct ieee80211_hw *hw)
 
 	if (wow_status) {
 		ath_dbg(common, ANY, "Waking up due to WoW triggers %s"
-			"with WoW status = %x\n",
+			"with WoW status = 0x%x\n",
 			ath9k_hw_wow_event_to_string(wow_status), wow_status);
 	}
 
 	ath9k_ps_restore(sc);
 
 wow_unlock:
-
 	mutex_unlock(&sc->mutex);
 	return 0;
 }
-- 
1.7.0.4

