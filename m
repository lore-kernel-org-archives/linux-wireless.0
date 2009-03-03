Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35479 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755335AbZCCRZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 12:25:43 -0500
Message-Id: <20090303172535.964036855@atheros.com> (sfid-20090303_182545_878412_525FD7CE)
References: <20090303172325.437810138@atheros.com>
Date: Tue, 03 Mar 2009 19:23:39 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 14/15] ath9k: Add a simple virtual wiphy scheduler
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a very simple scheduler that goes through the wiphys and
schedules one at a time every N milliseconds (current default value:
500 ms). This is enough for initial testing, but there are number of
areas where a more complex scheduler can improve operations greatly.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h   |    5 ++
 drivers/net/wireless/ath9k/main.c    |    3 +
 drivers/net/wireless/ath9k/virtual.c |   64 +++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:32:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-03 18:32:52.000000000 +0200
@@ -569,6 +569,9 @@ struct ath_softc {
 	struct work_struct chan_work;
 	int wiphy_select_failures;
 	unsigned long wiphy_select_first_fail;
+	struct delayed_work wiphy_work;
+	unsigned long wiphy_scheduler_int;
+	int wiphy_scheduler_index;
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
@@ -712,10 +715,12 @@ void ath9k_tx_status(struct ieee80211_hw
 int ath9k_wiphy_pause(struct ath_wiphy *aphy);
 int ath9k_wiphy_unpause(struct ath_wiphy *aphy);
 int ath9k_wiphy_select(struct ath_wiphy *aphy);
+void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int);
 void ath9k_wiphy_chan_work(struct work_struct *work);
 bool ath9k_wiphy_started(struct ath_softc *sc);
 void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 				  struct ath_wiphy *selected);
 bool ath9k_wiphy_scanning(struct ath_softc *sc);
+void ath9k_wiphy_work(struct work_struct *work);
 
 #endif /* ATH9K_H */
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/main.c	2009-03-03 18:32:52.000000000 +0200
@@ -1323,6 +1323,7 @@ void ath_detach(struct ath_softc *sc)
 #endif
 	ath_deinit_leds(sc);
 	cancel_work_sync(&sc->chan_work);
+	cancel_delayed_work_sync(&sc->wiphy_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -1670,6 +1671,8 @@ int ath_attach(u16 devid, struct ath_sof
 	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
 
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
+	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
+	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
 
 	error = ieee80211_register_hw(hw);
 
--- wireless-testing.orig/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:32:41.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/virtual.c	2009-03-03 18:32:52.000000000 +0200
@@ -154,6 +154,11 @@ int ath9k_wiphy_add(struct ath_softc *sc
 
 	error = ieee80211_register_hw(hw);
 
+	if (error == 0) {
+		/* Make sure wiphy scheduler is started (if enabled) */
+		ath9k_wiphy_set_scheduler(sc, sc->wiphy_scheduler_int);
+	}
+
 	return error;
 }
 
@@ -596,3 +601,62 @@ void ath9k_wiphy_pause_all_forced(struct
 	}
 	spin_unlock_bh(&sc->wiphy_lock);
 }
+
+void ath9k_wiphy_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    wiphy_work.work);
+	struct ath_wiphy *aphy = NULL;
+	bool first = true;
+
+	spin_lock_bh(&sc->wiphy_lock);
+
+	if (sc->wiphy_scheduler_int == 0) {
+		/* wiphy scheduler is disabled */
+		spin_unlock_bh(&sc->wiphy_lock);
+		return;
+	}
+
+try_again:
+	sc->wiphy_scheduler_index++;
+	while (sc->wiphy_scheduler_index <= sc->num_sec_wiphy) {
+		aphy = sc->sec_wiphy[sc->wiphy_scheduler_index - 1];
+		if (aphy && aphy->state != ATH_WIPHY_INACTIVE)
+			break;
+
+		sc->wiphy_scheduler_index++;
+		aphy = NULL;
+	}
+	if (aphy == NULL) {
+		sc->wiphy_scheduler_index = 0;
+		if (sc->pri_wiphy->state == ATH_WIPHY_INACTIVE) {
+			if (first) {
+				first = false;
+				goto try_again;
+			}
+			/* No wiphy is ready to be scheduled */
+		} else
+			aphy = sc->pri_wiphy;
+	}
+
+	spin_unlock_bh(&sc->wiphy_lock);
+
+	if (aphy &&
+	    aphy->state != ATH_WIPHY_ACTIVE && aphy->state != ATH_WIPHY_SCAN &&
+	    ath9k_wiphy_select(aphy)) {
+		printk(KERN_DEBUG "ath9k: Failed to schedule virtual wiphy "
+		       "change\n");
+	}
+
+	queue_delayed_work(sc->hw->workqueue, &sc->wiphy_work,
+			   sc->wiphy_scheduler_int);
+}
+
+void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
+{
+	cancel_delayed_work_sync(&sc->wiphy_work);
+	sc->wiphy_scheduler_int = msecs_to_jiffies(msec_int);
+	if (sc->wiphy_scheduler_int)
+		queue_delayed_work(sc->hw->workqueue, &sc->wiphy_work,
+				   sc->wiphy_scheduler_int);
+}

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
