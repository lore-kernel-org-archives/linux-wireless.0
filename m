Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35456 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754918AbZCCRZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:22 -0500
Message-Id: <20090303172511.808072634@atheros.com> (sfid-20090303_182525_819408_C992151D)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:33 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 08/15] ath9k: Make start/stop operations aware of virtual wiphys
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of always going through initialization/deinitialization steps,
do this only for the first/last wiphy to not break the other wiphys.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |    2 ++
 drivers/net/wireless/ath9k/main.c    |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/virtual.c |   19 +++++++++++++++++++
 3 files changed, 49 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:30.000000000 +0200
@@ -627,6 +627,7 @@ struct ath_wiphy {
 	struct ath_softc *sc; /* shared for all virtual wiphys */
 	struct ieee80211_hw *hw;
 	enum ath_wiphy_state {
+		ATH_WIPHY_INACTIVE,
 		ATH_WIPHY_ACTIVE,
 		ATH_WIPHY_PAUSING,
 		ATH_WIPHY_PAUSED,
@@ -707,5 +708,6 @@ int ath9k_wiphy_pause(struct ath_wiphy *
 int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
 int ath9k_wiphy_select(struct ath_wiphy *aphy);
 void ath9k_wiphy_chan_work(struct work_struct *work);
+bool ath9k_wiphy_started(struct ath_softc *sc);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:30.000000000 +0200
@@ -1963,6 +1963,27 @@ static int ath9k_start(struct ieee80211_
 
 	mutex_lock(&sc->mutex);
 
+	if (ath9k_wiphy_started(sc)) {
+		if (sc->chan_idx == curchan->hw_value) {
+			/*
+			 * Already on the operational channel, the new wiphy
+			 * can be marked active.
+			 */
+			aphy->state = ATH_WIPHY_ACTIVE;
+			ieee80211_wake_queues(hw);
+		} else {
+			/*
+			 * Another wiphy is on another channel, start the new
+			 * wiphy in paused state.
+			 */
+			aphy->state = ATH_WIPHY_PAUSED;
+			ieee80211_stop_queues(hw);
+		}
+		mutex_unlock(&sc->mutex);
+		return 0;
+	}
+	aphy->state = ATH_WIPHY_ACTIVE;
+
 	/* setup initial channel */
 
 	pos = curchan->hw_value;
@@ -2102,6 +2123,8 @@ static void ath9k_stop(struct ieee80211_
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	aphy->state = ATH_WIPHY_INACTIVE;
+
 	if (sc->sc_flags & SC_OP_INVALID) {
 		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
 		return;
@@ -2111,6 +2134,11 @@ static void ath9k_stop(struct ieee80211_
 
 	ieee80211_stop_queues(hw);
 
+	if (ath9k_wiphy_started(sc)) {
+		mutex_unlock(&sc->mutex);
+		return; /* another wiphy still in use */
+	}
+
 	/* make sure h/w will not generate any interrupt
 	 * before setting the invalid flag. */
 	ath9k_hw_set_interrupts(sc->sc_ah, 0);
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:20.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:30.000000000 +0200
@@ -477,3 +477,22 @@ int ath9k_wiphy_select(struct ath_wiphy 
 
 	return 0;
 }
+
+bool ath9k_wiphy_started(struct ath_softc *sc)
+{
+	int i;
+	spin_lock_bh(&sc->wiphy_lock);
+	if (sc->pri_wiphy->state != ATH_WIPHY_INACTIVE) {
+		spin_unlock_bh(&sc->wiphy_lock);
+		return true;
+	}
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state != ATH_WIPHY_INACTIVE) {
+			spin_unlock_bh(&sc->wiphy_lock);
+			return true;
+		}
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+	return false;
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
