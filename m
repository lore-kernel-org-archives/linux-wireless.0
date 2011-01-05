Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47579 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab1AET1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:27:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@venema.h4ckr.net, ath9k-devel@venema.h4ckr.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] ath9k: use nohwcrypt in ath_common structure
Date: Wed,  5 Jan 2011 14:22:07 -0500
Message-Id: <1294255328-14322-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/init.c  |    5 +++--
 drivers/net/wireless/ath/ath9k/main.c  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index fcc087c..0e97352 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -664,7 +664,6 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 }
 
 extern struct ieee80211_ops ath9k_ops;
-extern int modparam_nohwcrypt;
 extern int led_blink;
 extern int ath9k_pm_qos_value;
 extern bool is_ath9k_unloaded;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b6643b5..9aafd29 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -29,7 +29,7 @@ static unsigned int ath9k_debug = ATH_DBG_DEFAULT;
 module_param_named(debug, ath9k_debug, uint, 0);
 MODULE_PARM_DESC(debug, "Debugging mask");
 
-int modparam_nohwcrypt;
+static int modparam_nohwcrypt;
 module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption");
 
@@ -552,6 +552,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
 	common->btcoex_enabled = ath9k_btcoex_enable == 1;
+	common->nohwcrypt = modparam_nohwcrypt;
 	spin_lock_init(&common->cc_lock);
 
 	spin_lock_init(&sc->wiphy_lock);
@@ -653,7 +654,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
-	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || modparam_nohwcrypt)
+	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || common->nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->wiphy->interface_modes =
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a818e4f..b2149ee 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1829,7 +1829,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	int ret = 0;
 
-	if (modparam_nohwcrypt)
+	if (common->nohwcrypt)
 		return -ENOSPC;
 
 	mutex_lock(&sc->mutex);
-- 
1.7.3.4

