Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:45421
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752407AbaKDP5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 10:57:04 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: add support for reporting tx power to mac80211
Date: Tue,  4 Nov 2014 16:56:57 +0100
Message-Id: <1415116617-55154-1-git-send-email-nbd@openwrt.org> (sfid-20141104_165708_912319_9799C6F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track it per channel context instead of in the softc

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 +-
 drivers/net/wireless/ath/ath9k/init.c  | 25 ++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/main.c  | 29 +++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 85d74ff..adb49a9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -347,6 +347,7 @@ struct ath_chanctx {
 
 	int flush_timeout;
 	u16 txpower;
+	u16 cur_txpower;
 	bool offchannel;
 	bool stopped;
 	bool active;
@@ -987,7 +988,6 @@ struct ath_softc {
 	u8 gtt_cnt;
 	u32 intrstatus;
 	u16 ps_flags; /* PS_* */
-	u16 curtxpow;
 	bool ps_enabled;
 	bool ps_idle;
 	short nbcnvifs;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4d69a0..4a9421c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -172,17 +172,20 @@ static void ath9k_reg_notifier(struct wiphy *wiphy,
 	ath_reg_notifier_apply(wiphy, request, reg);
 
 	/* Set tx power */
-	if (ah->curchan) {
-		sc->cur_chan->txpower = 2 * ah->curchan->chan->max_power;
-		ath9k_ps_wakeup(sc);
-		ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
-		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
-		/* synchronize DFS detector if regulatory domain changed */
-		if (sc->dfs_detector != NULL)
-			sc->dfs_detector->set_dfs_domain(sc->dfs_detector,
-							 request->dfs_region);
-		ath9k_ps_restore(sc);
-	}
+	if (!ah->curchan)
+		return;
+
+	sc->cur_chan->txpower = 2 * ah->curchan->chan->max_power;
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
+	ath9k_cmn_update_txpow(ah, sc->cur_chan->cur_txpower,
+			       sc->cur_chan->txpower,
+			       &sc->cur_chan->cur_txpower);
+	/* synchronize DFS detector if regulatory domain changed */
+	if (sc->dfs_detector != NULL)
+		sc->dfs_detector->set_dfs_domain(sc->dfs_detector,
+						 request->dfs_region);
+	ath9k_ps_restore(sc);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a91ee92..92fb067 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -233,8 +233,9 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 
 	ath9k_calculate_summary_state(sc, sc->cur_chan);
 	ath_startrecv(sc);
-	ath9k_cmn_update_txpow(ah, sc->curtxpow,
-			       sc->cur_chan->txpower, &sc->curtxpow);
+	ath9k_cmn_update_txpow(ah, sc->cur_chan->cur_txpower,
+			       sc->cur_chan->txpower,
+			       &sc->cur_chan->cur_txpower);
 	clear_bit(ATH_OP_HW_RESET, &common->op_flags);
 
 	if (!sc->cur_chan->offchannel && start) {
@@ -1471,8 +1472,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		ath_dbg(common, CONFIG, "Set power: %d\n", conf->power_level);
 		sc->cur_chan->txpower = 2 * conf->power_level;
-		ath9k_cmn_update_txpow(ah, sc->curtxpow,
-				       sc->cur_chan->txpower, &sc->curtxpow);
+		ath9k_cmn_update_txpow(ah, sc->cur_chan->cur_txpower,
+				       sc->cur_chan->txpower,
+				       &sc->cur_chan->cur_txpower);
 	}
 
 	mutex_unlock(&sc->mutex);
@@ -2594,6 +2596,24 @@ void ath9k_fill_chanctx_ops(void)
 
 #endif
 
+static int ath9k_get_txpower(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			     int *dbm)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
+
+	mutex_lock(&sc->mutex);
+	if (avp->chanctx)
+		*dbm = avp->chanctx->cur_txpower;
+	else
+		*dbm = sc->cur_chan->cur_txpower;
+	mutex_unlock(&sc->mutex);
+
+	*dbm /= 2;
+
+	return 0;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2640,4 +2660,5 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+	.get_txpower        = ath9k_get_txpower,
 };
-- 
2.1.2

