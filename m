Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 6/6] ath9k: rename ath_beaconq_setup() to ath9k_hw_beaconq_setup()
Date: Tue,  6 Oct 2009 21:19:11 -0400
Message-Id: <1254878351-32433-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And move it to hw code on mac.c where it belongs.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath/ath9k/beacon.c |   12 ------------
 drivers/net/wireless/ath/ath9k/mac.c    |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h    |    1 +
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 14ff38d..13dd020 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -421,7 +421,6 @@ struct ath_beacon {
 
 void ath_beacon_tasklet(unsigned long data);
 void ath_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif);
-int ath_beaconq_setup(struct ath_hw *ah);
 int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
 
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 54be876..b10c884 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -242,18 +242,6 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc,
 		  sc->beacon.beaconq, ito64(bf->bf_daddr), bf->bf_desc);
 }
 
-int ath_beaconq_setup(struct ath_hw *ah)
-{
-	struct ath9k_tx_queue_info qi;
-
-	memset(&qi, 0, sizeof(qi));
-	qi.tqi_aifs = 1;
-	qi.tqi_cwmin = 0;
-	qi.tqi_cwmax = 0;
-	/* NB: don't enable any interrupts */
-	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
-}
-
 int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = aphy->sc;
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index e2c1ba3..46466ff 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -1018,3 +1018,16 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 #undef AH_RX_STOP_DMA_TIMEOUT
 }
 EXPORT_SYMBOL(ath9k_hw_stopdmarecv);
+
+int ath9k_hw_beaconq_setup(struct ath_hw *ah)
+{
+	struct ath9k_tx_queue_info qi;
+
+	memset(&qi, 0, sizeof(qi));
+	qi.tqi_aifs = 1;
+	qi.tqi_cwmin = 0;
+	qi.tqi_cwmax = 0;
+	/* NB: don't enable any interrupts */
+	return ath9k_hw_setuptxqueue(ah, ATH9K_TX_QUEUE_BEACON, &qi);
+}
+EXPORT_SYMBOL(ath9k_hw_beaconq_setup);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 9ab3431..fefb65d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -667,5 +667,6 @@ void ath9k_hw_rxena(struct ath_hw *ah);
 void ath9k_hw_startpcureceive(struct ath_hw *ah);
 void ath9k_hw_stoppcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
+int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
 #endif /* MAC_H */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c541516..36af6f3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1709,7 +1709,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	 * priority.  Note that the hal handles reseting
 	 * these queues at the needed time.
 	 */
-	sc->beacon.beaconq = ath_beaconq_setup(ah);
+	sc->beacon.beaconq = ath9k_hw_beaconq_setup(ah);
 	if (sc->beacon.beaconq == -1) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to setup a beacon xmit queue\n");
-- 
1.6.0.4

