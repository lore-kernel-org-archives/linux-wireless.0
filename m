Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60115 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1AEOpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 09:45:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: qualify global modparam_nohwcrypt variable
Date: Wed,  5 Jan 2011 09:39:17 -0500
Message-Id: <1294238357-4624-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/init.c  |    6 +++---
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fcc087c..3681caf5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -664,7 +664,7 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 }
 
 extern struct ieee80211_ops ath9k_ops;
-extern int modparam_nohwcrypt;
+extern int ath9k_modparam_nohwcrypt;
 extern int led_blink;
 extern int ath9k_pm_qos_value;
 extern bool is_ath9k_unloaded;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b6643b5..767d8b8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -29,8 +29,8 @@ static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 MODULE_PARM_DESC(debug, "Debugging mask");
 
-int modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
+int ath9k_modparam_nohwcrypt;
+module_param_named(nohwcrypt, ath9k_modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
 int led_blink;
@@ -653,7 +653,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
-	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
+	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a818e4f..f90a6ca 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1829,7 +1829,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
-	if (modparam_nohwcrypt)
+	if (ath9k_modparam_nohwcrypt)
 		return -ENOSPC;
 
 	mutex_lock(&sc->mutex);
-- 
1.7.3.4

