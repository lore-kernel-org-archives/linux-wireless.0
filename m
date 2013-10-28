Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51911 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab3J1Hmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 03:42:39 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Add an initialization routine for WoW
Date: Mon, 28 Oct 2013 13:08:11 +0530
Message-Id: <1382945891-12779-4-git-send-email-sujith@msujith.org> (sfid-20131028_084244_408348_C4C6F52E)
In-Reply-To: <1382945891-12779-1-git-send-email-sujith@msujith.org>
References: <1382945891-12779-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
 drivers/net/wireless/ath/ath9k/init.c  | 20 +-------------------
 drivers/net/wireless/ath/ath9k/wow.c   | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9e1b728..b351df3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -575,11 +575,15 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 /************************/
 
 #ifdef CONFIG_ATH9K_WOW
+void ath9k_init_wow(struct ieee80211_hw *hw);
 int ath9k_suspend(struct ieee80211_hw *hw,
 		  struct cfg80211_wowlan *wowlan);
 int ath9k_resume(struct ieee80211_hw *hw);
 void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled);
 #else
+static inline void ath9k_init_wow(struct ieee80211_hw *hw)
+{
+}
 static inline int ath9k_suspend(struct ieee80211_hw *hw,
 				struct cfg80211_wowlan *wowlan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index ee7da65..600aa0b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -870,15 +870,6 @@ static const struct ieee80211_iface_combination if_comb[] = {
 	}
 };
 
-#ifdef CONFIG_ATH9K_WOW
-static const struct wiphy_wowlan_support ath9k_wowlan_support = {
-	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
-	.n_patterns = MAX_NUM_USER_PATTERN,
-	.pattern_min_len = 1,
-	.pattern_max_len = MAX_PATTERN_SIZE,
-};
-#endif
-
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -928,16 +919,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
-#ifdef CONFIG_ATH9K_WOW
-	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
-	    (sc->driver_data & ATH9K_PCI_WOW) &&
-	    device_can_wakeup(sc->dev))
-		hw->wiphy->wowlan = &ath9k_wowlan_support;
-
-	atomic_set(&sc->wow_sleep_proc_intr, -1);
-	atomic_set(&sc->wow_got_bmiss_intr, -1);
-#endif
-
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
@@ -963,6 +944,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 
+	ath9k_init_wow(hw);
 	ath9k_reload_chainmask_settings(sc);
 
 	SET_IEEE80211_PERM_ADDR(hw, common->macaddr);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index e161bbc..f1cde81 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -16,6 +16,13 @@
 
 #include "ath9k.h"
 
+static const struct wiphy_wowlan_support ath9k_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.n_patterns = MAX_NUM_USER_PATTERN,
+	.pattern_min_len = 1,
+	.pattern_max_len = MAX_PATTERN_SIZE,
+};
+
 static void ath9k_wow_map_triggers(struct ath_softc *sc,
 				   struct cfg80211_wowlan *wowlan,
 				   u32 *wow_triggers)
@@ -339,3 +346,16 @@ void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 	device_set_wakeup_enable(sc->dev, enabled);
 	mutex_unlock(&sc->mutex);
 }
+
+void ath9k_init_wow(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
+	    (sc->driver_data & ATH9K_PCI_WOW) &&
+	    device_can_wakeup(sc->dev))
+		hw->wiphy->wowlan = &ath9k_wowlan_support;
+
+	atomic_set(&sc->wow_sleep_proc_intr, -1);
+	atomic_set(&sc->wow_got_bmiss_intr, -1);
+}
-- 
1.8.4.1

