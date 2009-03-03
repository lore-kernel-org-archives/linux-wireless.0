Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35462 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbZCCRZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:26 -0500
Message-Id: <20090303172520.075046478@atheros.com> (sfid-20090303_182927_729171_71D467DD)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:35 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 10/15] ath9k: Pause other virtual wiphys on channel change
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For now, allow channel changes immediately and just force the other
virtual wiphys to paused state. This is needed to allow
mac80211-controlled scan to control channel changes.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |    2 ++
 drivers/net/wireless/ath9k/main.c    |    8 +++++++-
 drivers/net/wireless/ath9k/virtual.c |   24 ++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:43.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:31:50.000000000 +0200
@@ -2341,7 +2341,13 @@ static int ath9k_config(struct ieee80211
 		aphy->chan_is_ht = conf_is_ht(conf);
 
 		/* TODO: do not change operation channel immediately if there
-		 * are other virtual wiphys that use another channel */
+		 * are other virtual wiphys that use another channel. For now,
+		 * we do the change immediately to allow mac80211-operated scan
+		 * to work. Once the scan operation is moved into ath9k, we can
+		 * just move the current aphy in PAUSED state if the channel is
+		 * changed into something different from the current operation
+		 * channel. */
+		ath9k_wiphy_pause_all_forced(sc, aphy);
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:31:50.000000000 +0200
@@ -709,5 +709,7 @@ int ath9k_wiphy_unpause(struct ath_wiphy
 int ath9k_wiphy_select(struct ath_wiphy *aphy);
 void ath9k_wiphy_chan_work(struct work_struct *work);
 bool ath9k_wiphy_started(struct ath_softc *sc);
+void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
+				  struct ath_wiphy *selected);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:30.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:31:50.000000000 +0200
@@ -496,3 +496,27 @@ bool ath9k_wiphy_started(struct ath_soft
 	spin_unlock_bh(&sc->wiphy_lock);
 	return false;
 }
+
+static void ath9k_wiphy_pause_chan(struct ath_wiphy *aphy,
+				   struct ath_wiphy *selected)
+{
+	if (aphy->chan_idx == selected->chan_idx)
+		return;
+	aphy->state = ATH_WIPHY_PAUSED;
+	ieee80211_stop_queues(aphy->hw);
+}
+
+void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
+				  struct ath_wiphy *selected)
+{
+	int i;
+	spin_lock_bh(&sc->wiphy_lock);
+	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE)
+		ath9k_wiphy_pause_chan(sc->pri_wiphy, selected);
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i] &&
+		    sc->sec_wiphy[i]->state == ATH_WIPHY_ACTIVE)
+			ath9k_wiphy_pause_chan(sc->sec_wiphy[i], selected);
+	}
+	spin_unlock_bh(&sc->wiphy_lock);
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
