Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35475 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755221AbZCCRZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:39 -0500
Message-Id: <20090303172531.802161983@atheros.com> (sfid-20090303_182545_186929_9F50EFAD)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:38 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 13/15] ath9k: Special processing for channel changes during scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow mac80211-controlled channel changes on an active wiphy and
especially during a scan. We need this as long as the scan is
controlled by mac80211. Moving this control into the driver could
allow some optimizations on scanning while using multiple virtual
interfaces, but for now, try to work as well as possible with the
current scan mechanism.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |    2 +
 drivers/net/wireless/ath9k/main.c    |   35 ++++++++++++++++++++++-------
 drivers/net/wireless/ath9k/virtual.c |   41 ++++++++++++++++++++++++++++++++++-
 3 files changed, 68 insertions(+), 10 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:32:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:32:41.000000000 +0200
@@ -633,6 +633,7 @@ struct ath_wiphy {
 		ATH_WIPHY_ACTIVE,
 		ATH_WIPHY_PAUSING,
 		ATH_WIPHY_PAUSED,
+		ATH_WIPHY_SCAN,
 	} state;
 	int chan_idx;
 	int chan_is_ht;
@@ -715,5 +716,6 @@ void ath9k_wiphy_chan_work(struct work_s
 bool ath9k_wiphy_started(struct ath_softc *sc);
 void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 				  struct ath_wiphy *selected);
+bool ath9k_wiphy_scanning(struct ath_softc *sc);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:41.000000000 +0200
@@ -2075,7 +2075,7 @@ static int ath9k_tx(struct ieee80211_hw 
 	struct ath_tx_control txctl;
 	int hdrlen, padsize;
 
-	if (aphy->state != ATH_WIPHY_ACTIVE) {
+	if (aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN) {
 		printk(KERN_DEBUG "ath9k: %s: TX in unexpected wiphy state "
 		       "%d\n", wiphy_name(hw->wiphy), aphy->state);
 		goto exit;
@@ -2346,14 +2346,16 @@ static int ath9k_config(struct ieee80211
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
 
-		/* TODO: do not change operation channel immediately if there
-		 * are other virtual wiphys that use another channel. For now,
-		 * we do the change immediately to allow mac80211-operated scan
-		 * to work. Once the scan operation is moved into ath9k, we can
-		 * just move the current aphy in PAUSED state if the channel is
-		 * changed into something different from the current operation
-		 * channel. */
-		ath9k_wiphy_pause_all_forced(sc, aphy);
+		if (aphy->state == ATH_WIPHY_SCAN ||
+		    aphy->state == ATH_WIPHY_ACTIVE)
+			ath9k_wiphy_pause_all_forced(sc, aphy);
+		else {
+			/*
+			 * Do not change operational channel based on a paused
+			 * wiphy changes.
+			 */
+			goto skip_chan_change;
+		}
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
@@ -2370,6 +2372,7 @@ static int ath9k_config(struct ieee80211
 		}
 	}
 
+skip_chan_change:
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->config.txpowlimit = 2 * conf->power_level;
 
@@ -2737,6 +2740,19 @@ static void ath9k_sw_scan_start(struct i
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	if (ath9k_wiphy_scanning(sc)) {
+		printk(KERN_DEBUG "ath9k: Two wiphys trying to scan at the "
+		       "same time\n");
+		/*
+		 * Do not allow the concurrent scanning state for now. This
+		 * could be improved with scanning control moved into ath9k.
+		 */
+		return;
+	}
+
+	aphy->state = ATH_WIPHY_SCAN;
+	ath9k_wiphy_pause_all_forced(sc, aphy);
+
 	mutex_lock(&sc->mutex);
 	sc->sc_flags |= SC_OP_SCANNING;
 	mutex_unlock(&sc->mutex);
@@ -2748,6 +2764,7 @@ static void ath9k_sw_scan_complete(struc
 	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
+	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	mutex_unlock(&sc->mutex);
 }
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:32:06.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:32:41.000000000 +0200
@@ -244,6 +244,28 @@ static bool ath9k_wiphy_pausing(struct a
 	return ret;
 }
 
+static bool __ath9k_wiphy_scanning(struct ath_softc *sc)
+{
+	int i;
+	if (sc->pri_wiphy->state == ATH_WIPHY_SCAN)
+		return true;
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state == ATH_WIPHY_SCAN)
+			return true;
+	}
+	return false;
+}
+
+bool ath9k_wiphy_scanning(struct ath_softc *sc)
+{
+	bool ret;
+	spin_lock_bh(&sc->wiphy_lock);
+	ret = __ath9k_wiphy_scanning(sc);
+	spin_unlock_bh(&sc->wiphy_lock);
+	return ret;
+}
+
 static int __ath9k_wiphy_unpause(struct ath_wiphy *aphy);
 
 /* caller must hold wiphy_lock */
@@ -463,6 +485,16 @@ int ath9k_wiphy_select(struct ath_wiphy 
 	bool now;
 
 	spin_lock_bh(&sc->wiphy_lock);
+	if (__ath9k_wiphy_scanning(sc)) {
+		/*
+		 * For now, we are using mac80211 sw scan and it expects to
+		 * have full control over channel changes, so avoid wiphy
+		 * scheduling during a scan. This could be optimized if the
+		 * scanning control were moved into the driver.
+		 */
+		spin_unlock_bh(&sc->wiphy_lock);
+		return -EBUSY;
+	}
 	if (__ath9k_wiphy_pausing(sc)) {
 		if (sc->wiphy_select_failures == 0)
 			sc->wiphy_select_first_fail = jiffies;
@@ -537,7 +569,14 @@ bool ath9k_wiphy_started(struct ath_soft
 static void ath9k_wiphy_pause_chan(struct ath_wiphy *aphy,
 				   struct ath_wiphy *selected)
 {
-	if (aphy->chan_idx == selected->chan_idx)
+	if (selected->state == ATH_WIPHY_SCAN) {
+		if (aphy == selected)
+			return;
+		/*
+		 * Pause all other wiphys for the duration of the scan even if
+		 * they are on the current channel now.
+		 */
+	} else if (aphy->chan_idx == selected->chan_idx)
 		return;
 	aphy->state = ATH_WIPHY_PAUSED;
 	ieee80211_stop_queues(aphy->hw);

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
