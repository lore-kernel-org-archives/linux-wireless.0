Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1894 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZERPA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:00:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, acab@clamav.net
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH] ath5k: update beacons in AP mode
Date: Mon, 18 May 2009 10:59:52 -0400
Message-Id: <1242658792-11163-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath5k only generated the beacon when bss_info_changed() was called,
but for AP mode this is not enough, because the TIM IE would never
get updated and consequently PS mode clients wouldn't know about
buffered frames.  Instead, get a new beacon on every SWBA interrupt.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   54 ++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index dbfe9f4..fb51937 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -242,8 +242,8 @@ static int ath5k_get_tx_stats(struct ieee80211_hw *hw,
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
-static int ath5k_beacon_update(struct ath5k_softc *sc,
-		struct sk_buff *skb);
+static int ath5k_beacon_update(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif);
 static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif,
 		struct ieee80211_bss_conf *bss_conf,
@@ -2127,8 +2127,10 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		/* NB: hw still stops DMA, so proceed */
 	}
 
-	/* Note: Beacon buffer is updated on beacon_update when mac80211
-	 * calls config_interface */
+	/* refresh the beacon for AP mode */
+	if (sc->opmode == NL80211_IFTYPE_AP)
+		ath5k_beacon_update(sc->hw, sc->vif);
+
 	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_start_tx_dma(ah, sc->bhalq);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
@@ -3047,28 +3049,55 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 		ath5k_hw_reset_tsf(sc->ah);
 }
 
+/*
+ * Updates the beacon that is sent by ath5k_beacon_send.  For adhoc,
+ * this is called only once at config_bss time, for AP we do it every
+ * SWBA interrupt so that the TIM will reflect buffered frames.
+ *
+ * Called with the beacon lock.
+ */
 static int
-ath5k_beacon_update(struct ath5k_softc *sc, struct sk_buff *skb)
+ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
-	unsigned long flags;
 	int ret;
+	struct ath5k_softc *sc = hw->priv;
+	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
+
+	if (!skb) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	spin_lock_irqsave(&sc->block, flags);
 	ath5k_txbuf_free(sc, sc->bbuf);
 	sc->bbuf->skb = skb;
 	ret = ath5k_beacon_setup(sc, sc->bbuf);
 	if (ret)
 		sc->bbuf->skb = NULL;
+out:
+	return ret;
+}
+
+/*
+ *  Update the beacon and reconfigure the beacon queues.
+ */
+static void
+ath5k_beacon_reconfig(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	int ret;
+	unsigned long flags;
+	struct ath5k_softc *sc = hw->priv;
+
+	spin_lock_irqsave(&sc->block, flags);
+	ret = ath5k_beacon_update(hw, vif);
 	spin_unlock_irqrestore(&sc->block, flags);
-	if (!ret) {
+	if (ret == 0) {
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
-
-	return ret;
 }
+
 static void
 set_beacon_filter(struct ieee80211_hw *hw, bool enable)
 {
@@ -3118,10 +3147,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 	    (vif->type == NL80211_IFTYPE_ADHOC ||
 	     vif->type == NL80211_IFTYPE_MESH_POINT ||
 	     vif->type == NL80211_IFTYPE_AP)) {
-		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
-
-		if (beacon)
-			ath5k_beacon_update(sc, beacon);
+		ath5k_beacon_reconfig(hw, vif);
 	}
 
  unlock:
-- 
1.6.0.6


