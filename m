Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47310 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbbBBMsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:17 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQK-002djK-26
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath9k: Register correct WOW details with mac80211
Date: Mon,  2 Feb 2015 18:21:09 +0530
Message-Id: <1422881473-24580-3-git-send-email-sujith@msujith.org> (sfid-20150202_134837_415683_C6805F23)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since the number of user patterns is higher for
newer chips, make sure that this is registered
during initialization.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/wow.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 5092939..8d0b173 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -16,13 +16,20 @@
 
 #include "ath9k.h"
 
-static const struct wiphy_wowlan_support ath9k_wowlan_support = {
+static const struct wiphy_wowlan_support ath9k_wowlan_support_legacy = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
 	.n_patterns = MAX_NUM_USER_PATTERN,
 	.pattern_min_len = 1,
 	.pattern_max_len = MAX_PATTERN_SIZE,
 };
 
+static const struct wiphy_wowlan_support ath9k_wowlan_support = {
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.n_patterns = MAX_NUM_PATTERN - 2,
+	.pattern_min_len = 1,
+	.pattern_max_len = MAX_PATTERN_SIZE,
+};
+
 static u8 ath9k_wow_map_triggers(struct ath_softc *sc,
 				 struct cfg80211_wowlan *wowlan)
 {
@@ -320,9 +327,14 @@ void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 void ath9k_init_wow(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
 
 	if ((sc->driver_data & ATH9K_PCI_WOW) || sc->force_wow) {
-		hw->wiphy->wowlan = &ath9k_wowlan_support;
+		if (AR_SREV_9462_20_OR_LATER(ah) || AR_SREV_9565_11_OR_LATER(ah))
+			hw->wiphy->wowlan = &ath9k_wowlan_support;
+		else
+			hw->wiphy->wowlan = &ath9k_wowlan_support_legacy;
+
 		device_init_wakeup(sc->dev, 1);
 	}
 }
-- 
2.2.2

