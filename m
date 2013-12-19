Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59656 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab3LSRCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 12:02:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/4] ath9k: call ath9k_set_tsfadjust from ath9k_beacon_config
Date: Thu, 19 Dec 2013 18:01:49 +0100
Message-Id: <1387472511-86178-2-git-send-email-nbd@openwrt.org> (sfid-20131219_180212_368329_C6907513)
In-Reply-To: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
References: <1387472511-86178-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make that function and ath9k_allow_beacon_config static

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  2 --
 drivers/net/wireless/ath/ath9k/beacon.c | 12 +++++++++---
 drivers/net/wireless/ath/ath9k/main.c   |  9 ++-------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9ad8a67..f2202e7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -431,12 +431,10 @@ struct ath_beacon {
 };
 
 void ath9k_beacon_tasklet(unsigned long data);
-bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 			 u32 changed);
 void ath9k_beacon_assign_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_beacon_remove_slot(struct ath_softc *sc, struct ieee80211_vif *vif);
-void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif);
 void ath9k_set_beacon(struct ath_softc *sc);
 bool ath9k_csa_is_finished(struct ath_softc *sc);
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 78ffe76..accfb3b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -274,7 +274,7 @@ static int ath9k_beacon_choose_slot(struct ath_softc *sc)
 	return slot;
 }
 
-void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
+static void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
@@ -622,7 +622,8 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 		set_bit(SC_OP_BEACONS, &sc->sc_flags);
 }
 
-bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
+static bool ath9k_allow_beacon_config(struct ath_softc *sc,
+				      struct ieee80211_vif *vif)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
@@ -693,12 +694,17 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 	unsigned long flags;
 	bool skip_beacon = false;
 
+	if (vif->type == NL80211_IFTYPE_AP)
+		ath9k_set_tsfadjust(sc, vif);
+
+	if (!ath9k_allow_beacon_config(sc, vif))
+		return;
+
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		ath9k_cache_beacon_config(sc, bss_conf);
 		ath9k_set_beacon(sc);
 		set_bit(SC_OP_BEACONS, &sc->sc_flags);
 		return;
-
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cda342e..21b764b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1665,13 +1665,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) ||
-	    (changed & BSS_CHANGED_BEACON_INT)) {
-		if (ah->opmode == NL80211_IFTYPE_AP &&
-		    bss_conf->enable_beacon)
-			ath9k_set_tsfadjust(sc, vif);
-		if (ath9k_allow_beacon_config(sc, vif))
-			ath9k_beacon_config(sc, vif, changed);
-	}
+	    (changed & BSS_CHANGED_BEACON_INT))
+		ath9k_beacon_config(sc, vif, changed);
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-- 
1.8.3.4 (Apple Git-47)

