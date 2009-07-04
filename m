Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3088 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZGDRAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/5] ath5k: rework beacon configuration
Date: Sat,  4 Jul 2009 12:59:52 -0400
Message-Id: <1246726795-3934-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the enable_beacon flag allows some simplifications and fixes
some corner cases in beacon handling.  This change adds a state
variable for beaconing in ath5k_beacon_config and handles both
enabling and disabling, thus eliminating the need for
ath5k_beacon_disable.  We also now configure the beacon when any
of the beacon parameters change, so ath5k_beacon_reconfig is no
longer needed (its mmiowb gets moved to ath5k_beacon_config).
Finally, by locking around the whole config function, we don't
need to worry about clearing the interrupt mask register before
installing the new mask.

The upshot is this correctly disables beaconing when the interfaces
are taken down, it fixes a potential restarting of beaconing
when ath5k_reset() is called, and ensures that updates to the
beacon interval take effect immediately.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   59 ++++++++++----------------------
 drivers/net/wireless/ath/ath5k/base.h |    1 +
 2 files changed, 20 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 87ebc46..4829329 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2093,13 +2093,6 @@ err_unmap:
 	return ret;
 }
 
-static void ath5k_beacon_disable(struct ath5k_softc *sc)
-{
-	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
-	ath5k_hw_set_imr(sc->ah, sc->imask);
-	ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
-}
-
 /*
  * Transmit a beacon frame at SWBA.  Dynamic updates to the
  * frame contents are done as needed and the slot time is
@@ -2293,13 +2286,11 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	struct ath5k_hw *ah = sc->ah;
 	unsigned long flags;
 
-	ath5k_hw_set_imr(ah, 0);
+	spin_lock_irqsave(&sc->block, flags);
 	sc->bmisscount = 0;
 	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
-	if (sc->opmode == NL80211_IFTYPE_ADHOC ||
-			sc->opmode == NL80211_IFTYPE_MESH_POINT ||
-			sc->opmode == NL80211_IFTYPE_AP) {
+	if (sc->enable_beacon) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2312,16 +2303,17 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		sc->imask |= AR5K_INT_SWBA;
 
 		if (sc->opmode == NL80211_IFTYPE_ADHOC) {
-			if (ath5k_hw_hasveol(ah)) {
-				spin_lock_irqsave(&sc->block, flags);
+			if (ath5k_hw_hasveol(ah))
 				ath5k_beacon_send(sc);
-				spin_unlock_irqrestore(&sc->block, flags);
-			}
 		} else
 			ath5k_beacon_update_timers(sc, -1);
+	} else {
+		ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
 	}
 
 	ath5k_hw_set_imr(ah, sc->imask);
+	mmiowb();
+	spin_unlock_irqrestore(&sc->block, flags);
 }
 
 static void ath5k_tasklet_beacon(unsigned long data)
@@ -2806,7 +2798,6 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 		goto end;
 
 	ath5k_hw_set_lladdr(sc->ah, mac);
-	ath5k_beacon_disable(sc);
 	sc->vif = NULL;
 end:
 	mutex_unlock(&sc->lock);
@@ -3135,25 +3126,6 @@ out:
 	return ret;
 }
 
-/*
- *  Update the beacon and reconfigure the beacon queues.
- */
-static void
-ath5k_beacon_reconfig(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
-{
-	int ret;
-	unsigned long flags;
-	struct ath5k_softc *sc = hw->priv;
-
-	spin_lock_irqsave(&sc->block, flags);
-	ret = ath5k_beacon_update(hw, vif);
-	spin_unlock_irqrestore(&sc->block, flags);
-	if (ret == 0) {
-		ath5k_beacon_config(sc);
-		mmiowb();
-	}
-}
-
 static void
 set_beacon_filter(struct ieee80211_hw *hw, bool enable)
 {
@@ -3176,6 +3148,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
+	unsigned long flags;
 
 	mutex_lock(&sc->lock);
 	if (WARN_ON(sc->vif != vif))
@@ -3201,13 +3174,19 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 			AR5K_LED_ASSOC : AR5K_LED_INIT);
 	}
 
-	if (changes & BSS_CHANGED_BEACON &&
-	    (vif->type == NL80211_IFTYPE_ADHOC ||
-	     vif->type == NL80211_IFTYPE_MESH_POINT ||
-	     vif->type == NL80211_IFTYPE_AP)) {
-		ath5k_beacon_reconfig(hw, vif);
+	if (changes & BSS_CHANGED_BEACON) {
+		spin_lock_irqsave(&sc->block, flags);
+		ath5k_beacon_update(hw, vif);
+		spin_unlock_irqrestore(&sc->block, flags);
 	}
 
+	if (changes & BSS_CHANGED_BEACON_ENABLED)
+		sc->enable_beacon = bss_conf->enable_beacon;
+
+	if (changes & (BSS_CHANGED_BEACON | BSS_CHANGED_BEACON_ENABLED |
+		       BSS_CHANGED_BEACON_INT))
+		ath5k_beacon_config(sc);
+
  unlock:
 	mutex_unlock(&sc->lock);
 }
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 65e75fb..778e422 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -190,6 +190,7 @@ struct ath5k_softc {
 	struct timer_list	calib_tim;	/* calibration timer */
 	int 			power_level;	/* Requested tx power in dbm */
 	bool			assoc;		/* assocate state */
+	bool			enable_beacon;	/* true if beacons are on */
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \
-- 
1.6.2.5


