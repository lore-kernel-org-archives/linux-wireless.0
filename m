Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49985 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab0GAWKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 18:10:05 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 6/6] ath9k: fix false positives in the baseband hang check
Date: Fri,  2 Jul 2010 00:09:52 +0200
Message-Id: <1278022192-83277-6-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278022192-83277-5-git-send-email-nbd@openwrt.org>
References: <1278022192-83277-1-git-send-email-nbd@openwrt.org>
 <1278022192-83277-2-git-send-email-nbd@openwrt.org>
 <1278022192-83277-3-git-send-email-nbd@openwrt.org>
 <1278022192-83277-4-git-send-email-nbd@openwrt.org>
 <1278022192-83277-5-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_check_alive() occasionally returns false, as the hardware
is still processing data in a specific state. Fix this issue by
repeating the test a few times with longer delay inbetween attempts.
This gets rid of excessive hardware resets that appear frequently on
some AR9132 based devices, but could also happen on AR9280.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 ++
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   27 +++++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 72d5e52..6e486a5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -428,6 +428,7 @@ int ath_beaconq_config(struct ath_softc *sc);
 
 #define ATH_PAPRD_TIMEOUT	100 /* msecs */
 
+void ath_hw_check(struct work_struct *work);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
 
@@ -562,6 +563,7 @@ struct ath_softc {
 	spinlock_t sc_pm_lock;
 	struct mutex mutex;
 	struct work_struct paprd_work;
+	struct work_struct hw_check_work;
 	struct completion paprd_complete;
 
 	u32 intrstatus;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 8700e3d..fe730cb 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -718,6 +718,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 			goto error_world;
 	}
 
+	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
 	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index efbf535..4c0831f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -515,6 +515,25 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 		ath_tx_node_cleanup(sc, an);
 }
 
+void ath_hw_check(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc, hw_check_work);
+	int i;
+
+	ath9k_ps_wakeup(sc);
+
+	for (i = 0; i < 3; i++) {
+		if (ath9k_hw_check_alive(sc->sc_ah))
+			goto out;
+
+		msleep(1);
+	}
+	ath_reset(sc, false);
+
+out:
+	ath9k_ps_restore(sc);
+}
+
 void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -526,13 +545,15 @@ void ath9k_tasklet(unsigned long data)
 
 	ath9k_ps_wakeup(sc);
 
-	if ((status & ATH9K_INT_FATAL) ||
-	    !ath9k_hw_check_alive(ah)) {
+	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, false);
 		ath9k_ps_restore(sc);
 		return;
 	}
 
+	if (!ath9k_hw_check_alive(ah))
+		ieee80211_queue_work(sc->hw, &sc->hw_check_work);
+
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		rxmask = (ATH9K_INT_RXHP | ATH9K_INT_RXLP | ATH9K_INT_RXEOL |
 			  ATH9K_INT_RXORN);
@@ -1253,6 +1274,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	cancel_work_sync(&sc->paprd_work);
+	cancel_work_sync(&sc->hw_check_work);
 
 	if (!sc->num_sec_wiphy) {
 		cancel_delayed_work_sync(&sc->wiphy_work);
@@ -1976,6 +1998,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	sc->sc_flags |= SC_OP_SCANNING;
 	del_timer_sync(&common->ani.timer);
 	cancel_work_sync(&sc->paprd_work);
+	cancel_work_sync(&sc->hw_check_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 	mutex_unlock(&sc->mutex);
 }
-- 
1.6.4.2

