Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23183 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZLNJ3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 04:29:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 01:29:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19238.1592.398805.805381@gargle.gargle.HOWL>
Date: Mon, 14 Dec 2009 15:02:40 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] ath9k: Remove ANI lock
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cancel/restart the ANI timer directly.
With this patch, the ANI lock can be removed.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   19 ++++---------------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e2cef2f..9f1f523 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -453,7 +453,6 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
-	spinlock_t ani_lock;
 	spinlock_t sc_pm_lock;
 	struct mutex mutex;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9e68c1a..310ad5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -363,14 +363,6 @@ static void ath_ani_calibrate(unsigned long data)
 	short_cal_interval = (ah->opmode == NL80211_IFTYPE_AP) ?
 		ATH_AP_SHORT_CALINTERVAL : ATH_STA_SHORT_CALINTERVAL;
 
-	/*
-	* don't calibrate when we're scanning.
-	* we are most likely not on our home channel.
-	*/
-	spin_lock(&sc->ani_lock);
-	if (sc->sc_flags & SC_OP_SCANNING)
-		goto set_timer;
-
 	/* Only calibrate if awake */
 	if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE)
 		goto set_timer;
@@ -437,7 +429,6 @@ static void ath_ani_calibrate(unsigned long data)
 	ath9k_ps_restore(sc);
 
 set_timer:
-	spin_unlock(&sc->ani_lock);
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
@@ -1610,7 +1601,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
-	spin_lock_init(&sc->ani_lock);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
@@ -3119,6 +3109,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 	if (ath9k_wiphy_scanning(sc)) {
@@ -3134,10 +3125,8 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
-
-	spin_lock_bh(&sc->ani_lock);
 	sc->sc_flags |= SC_OP_SCANNING;
-	spin_unlock_bh(&sc->ani_lock);
+	del_timer_sync(&common->ani.timer);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -3145,13 +3134,13 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
-	spin_lock_bh(&sc->ani_lock);
 	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	sc->sc_flags |= SC_OP_FULL_RESET;
-	spin_unlock_bh(&sc->ani_lock);
+	ath_start_ani(common);
 	ath_beacon_config(sc, NULL);
 	mutex_unlock(&sc->mutex);
 }
-- 
1.6.5.6

