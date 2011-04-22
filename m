Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:35962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1DVGCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 02:02:54 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 23:02:27 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 4/5] ath9k: cleanup hw pll work handler
Date: Fri, 22 Apr 2011 11:32:11 +0530
Message-ID: <1303452132-5436-4-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
References: <1303452132-5436-1-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no reason why pll work handler should be part of xmit
file. move it to main.c so that reading hw check routines are
all in the same place.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |   23 -----------------------
 4 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5ebfc57..0312aa0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -423,6 +423,7 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status);
 #define ATH_PAPRD_TIMEOUT	100 /* msecs */
 
 void ath_hw_check(struct work_struct *work);
+void ath_hw_pll_work(struct work_struct *work);
 void ath_paprd_calibrate(struct work_struct *work);
 void ath_ani_calibrate(unsigned long data);
 
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e78b6ae..b172d15 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -801,6 +801,7 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 
 	INIT_WORK(&sc->hw_check_work, ath_hw_check);
 	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
+	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
 	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 
 	ath_init_leds(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 37b80ac..fa80e13 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -624,6 +624,29 @@ out:
 	ath9k_ps_restore(sc);
 }
 
+void ath_hw_pll_work(struct work_struct *work)
+{
+	struct ath_softc *sc = container_of(work, struct ath_softc,
+					    hw_pll_work.work);
+	static int count;
+
+	if (AR_SREV_9485(sc->sc_ah)) {
+		if (ar9003_get_pll_sqsum_dvc(sc->sc_ah) >= 0x40000) {
+			count++;
+
+			if (count == 3) {
+				/* Rx is hung for more than 500ms. Reset it */
+				ath_reset(sc, true);
+				count = 0;
+			}
+		} else
+			count = 0;
+
+		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
+	}
+}
+
+
 void ath9k_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e9e99f7..7b91b2a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2180,28 +2180,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 	}
 }
 
-static void ath_hw_pll_work(struct work_struct *work)
-{
-	struct ath_softc *sc = container_of(work, struct ath_softc,
-					    hw_pll_work.work);
-	static int count;
-
-	if (AR_SREV_9485(sc->sc_ah)) {
-		if (ar9003_get_pll_sqsum_dvc(sc->sc_ah) >= 0x40000) {
-			count++;
-
-			if (count == 3) {
-				/* Rx is hung for more than 500ms. Reset it */
-				ath_reset(sc, true);
-				count = 0;
-			}
-		} else
-			count = 0;
-
-		ieee80211_queue_delayed_work(sc->hw, &sc->hw_pll_work, HZ/5);
-	}
-}
-
 static void ath_tx_complete_poll_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc,
@@ -2396,7 +2374,6 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	}
 
 	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
-	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		error = ath_tx_edma_init(sc);
-- 
1.7.0.4

