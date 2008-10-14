Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:19940 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbYJNBXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 21:23:09 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1866930wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Oct 2008 18:23:09 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
From: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] ath5k: fix mesh point operation
Date: Mon, 13 Oct 2008 18:23:07 -0700 (PDT)
Message-ID: <48f3f47b.16048e0a.19b4.ffffc4a4@mx.google.com> (sfid-20081014_032314_186377_10B3BA39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes mesh point operation (thanks to YanBo for pointing out the 
problem): make mesh point interfaces start beaconing when they come up and configure the RX filter in mesh mode so that mesh beacons and action frames are 
received.  Add mesh point to the check in ath5k_add_interface.  Tested with 
multiple AR5211 cards.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 1a24a22..467ece6 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2170,7 +2170,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 	if (sc->opmode == NL80211_IFTYPE_STATION) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+	} else if (sc->opmode == NL80211_IFTYPE_ADHOC ||
+		   sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2182,11 +2183,14 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 		sc->imask |= AR5K_INT_SWBA;
 
-		if (ath5k_hw_hasveol(ah)) {
-			spin_lock(&sc->block);
-			ath5k_beacon_send(sc);
-			spin_unlock(&sc->block);
-		}
+		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+			if (ath5k_hw_hasveol(ah)) {
+				spin_lock(&sc->block);
+				ath5k_beacon_send(sc);
+				spin_unlock(&sc->block);
+			}
+		} else
+			ath5k_beacon_update_timers(sc, -1);
 	}
 	/* TODO else AP */
 
@@ -2742,6 +2746,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_MONITOR:
 		sc->opmode = conf->type;
 		break;
@@ -2813,7 +2818,8 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	}
 
 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == NL80211_IFTYPE_ADHOC) {
+	    (vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
@@ -2945,6 +2951,9 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		sc->opmode == NL80211_IFTYPE_ADHOC) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}
+	if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
+		rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
+			AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
 
 	/* Set filters */
 	ath5k_hw_set_rx_filter(ah,rfilt);
@@ -3062,7 +3071,8 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	if (sc->opmode != NL80211_IFTYPE_ADHOC) {
+	if (sc->opmode != NL80211_IFTYPE_ADHOC &&
+	    sc->opmode != NL80211_IFTYPE_MESH_POINT) {
 		ret = -EIO;
 		goto end;
 	}


