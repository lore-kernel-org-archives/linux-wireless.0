Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19331 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbZBDCnx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 21:43:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 18:43:53 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18825.7.637355.728769@gargle.gargle.HOWL> (sfid-20090204_034411_110255_2848C18F)
Date: Wed, 4 Feb 2009 08:10:07 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/4] ath9k: Lock mac80211 callbacks with a mutex
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   60 ++++++++++++++++++++++++++++--------
 1 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 1c0f893..9b040ba 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1938,6 +1938,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
+	mutex_lock(&sc->mutex);
+
 	/* setup initial channel */
 
 	pos = curchan->hw_value;
@@ -1963,7 +1965,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 			"(freq %u MHz)\n", r,
 			curchan->center_freq);
 		spin_unlock_bh(&sc->sc_resetlock);
-		return r;
+		goto mutex_unlock;
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1983,7 +1985,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (ath_startrecv(sc) != 0) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to start recv logic\n");
-		return -EIO;
+		r = -EIO;
+		goto mutex_unlock;
 	}
 
 	/* Setup our intr mask. */
@@ -2010,6 +2013,10 @@ static int ath9k_start(struct ieee80211_hw *hw)
 #if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 	r = ath_start_rfkill_poll(sc);
 #endif
+
+mutex_unlock:
+	mutex_unlock(&sc->mutex);
+
 	return r;
 }
 
@@ -2074,7 +2081,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		return;
 	}
 
-	DPRINTF(sc, ATH_DBG_CONFIG, "Cleaning up\n");
+	mutex_lock(&sc->mutex);
 
 	ieee80211_stop_queues(sc->hw);
 
@@ -2099,6 +2106,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	sc->sc_flags |= SC_OP_INVALID;
 
+	mutex_unlock(&sc->mutex);
+
 	DPRINTF(sc, ATH_DBG_CONFIG, "Driver halt\n");
 }
 
@@ -2114,6 +2123,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	if (sc->sc_nvaps)
 		return -ENOBUFS;
 
+	mutex_lock(&sc->mutex);
+
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 		ic_opmode = NL80211_IFTYPE_STATION;
@@ -2173,6 +2184,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 	}
 
+	mutex_unlock(&sc->mutex);
+
 	return 0;
 }
 
@@ -2184,6 +2197,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach Interface\n");
 
+	mutex_lock(&sc->mutex);
+
 	/* Stop ANI */
 	del_timer_sync(&sc->sc_ani.timer);
 
@@ -2198,6 +2213,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	sc->sc_vaps[0] = NULL;
 	sc->sc_nvaps--;
+
+	mutex_unlock(&sc->mutex);
 }
 
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
@@ -2206,6 +2223,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	mutex_lock(&sc->mutex);
+
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
 			if ((sc->sc_imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -2250,6 +2268,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
 	mutex_unlock(&sc->mutex);
+
 	return 0;
 }
 
@@ -2392,8 +2411,7 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	}
 }
 
-static int ath9k_conf_tx(struct ieee80211_hw *hw,
-			 u16 queue,
+static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 			 const struct ieee80211_tx_queue_params *params)
 {
 	struct ath_softc *sc = hw->priv;
@@ -2403,6 +2421,8 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	if (queue >= WME_NUM_AC)
 		return 0;
 
+	mutex_lock(&sc->mutex);
+
 	qi.tqi_aifs = params->aifs;
 	qi.tqi_cwmin = params->cw_min;
 	qi.tqi_cwmax = params->cw_max;
@@ -2419,6 +2439,8 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	if (ret)
 		DPRINTF(sc, ATH_DBG_FATAL, "TXQ Update failed\n");
 
+	mutex_unlock(&sc->mutex);
+
 	return ret;
 }
 
@@ -2431,6 +2453,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
 
+	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
 	DPRINTF(sc, ATH_DBG_KEYCACHE, "Set HW Key\n");
 
@@ -2456,6 +2479,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	}
 
 	ath9k_ps_restore(sc);
+	mutex_unlock(&sc->mutex);
+
 	return ret;
 }
 
@@ -2466,6 +2491,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 
+	mutex_lock(&sc->mutex);
+
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "BSS Changed PREAMBLE %d\n",
 			bss_conf->use_short_preamble);
@@ -2490,15 +2517,18 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			bss_conf->assoc);
 		ath9k_bss_assoc_info(sc, vif, bss_conf);
 	}
+
+	mutex_unlock(&sc->mutex);
 }
 
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 {
 	u64 tsf;
 	struct ath_softc *sc = hw->priv;
-	struct ath_hal *ah = sc->sc_ah;
 
-	tsf = ath9k_hw_gettsf64(ah);
+	mutex_lock(&sc->mutex);
+	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	mutex_unlock(&sc->mutex);
 
 	return tsf;
 }
@@ -2506,23 +2536,25 @@ static u64 ath9k_get_tsf(struct ieee80211_hw *hw)
 static void ath9k_set_tsf(struct ieee80211_hw *hw, u64 tsf)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_hal *ah = sc->sc_ah;
 
-	ath9k_hw_settsf64(ah, tsf);
+	mutex_lock(&sc->mutex);
+	ath9k_hw_settsf64(sc->sc_ah, tsf);
+	mutex_unlock(&sc->mutex);
 }
 
 static void ath9k_reset_tsf(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_hal *ah = sc->sc_ah;
 
-	ath9k_hw_reset_tsf(ah);
+	mutex_lock(&sc->mutex);
+	ath9k_hw_reset_tsf(sc->sc_ah);
+	mutex_unlock(&sc->mutex);
 }
 
 static int ath9k_ampdu_action(struct ieee80211_hw *hw,
-		       enum ieee80211_ampdu_mlme_action action,
-		       struct ieee80211_sta *sta,
-		       u16 tid, u16 *ssn)
+			      enum ieee80211_ampdu_mlme_action action,
+			      struct ieee80211_sta *sta,
+			      u16 tid, u16 *ssn)
 {
 	struct ath_softc *sc = hw->priv;
 	int ret = 0;
-- 
1.6.1

