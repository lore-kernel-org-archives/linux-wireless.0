Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34786 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab2FYFPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 01:15:45 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com, Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k: raise aggregation limit to 64k for HT IBSS
Date: Mon, 25 Jun 2012 07:15:22 +0200
Message-Id: <1340601322-1802-1-git-send-email-sven@narfation.org> (sfid-20120625_071550_205917_B4AEA1EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 adds stations in HT IBSS as soon as a frame comes by,
even if the HT capabilities are not known yet (they are often
received later, e.g. in beacons). So far, ampdu factor/density
are only calculated when the station is initially added.

This patch changes this to update ampdu factor/density settings
when starting a blockack session.

Using this patch, we had performance boosts from 60 to 150 MBit/s
between two 2x2 Atheros devices in 5 GHz HT IBSS mode.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
This is a resent of an RFC (1340355904-861-1-git-send-email-sven@narfation.org,
but now marked as patch). No changes were made because no problems were found
during the review.

 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |    6 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   12 ++++++++++++
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index f72c4a3..fe39eb4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -722,6 +722,7 @@ extern int ath9k_modparam_nohwcrypt;
 extern int led_blink;
 extern bool is_ath9k_unloaded;
 
+u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 85f9ab4..e2e6958 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -19,7 +19,7 @@
 #include "ath9k.h"
 #include "btcoex.h"
 
-static u8 parse_mpdudensity(u8 mpdudensity)
+u8 ath9k_parse_mpdudensity(u8 mpdudensity)
 {
 	/*
 	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
@@ -320,6 +320,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 			    struct ieee80211_vif *vif)
 {
 	struct ath_node *an;
+	u8 density;
 	an = (struct ath_node *)sta->drv_priv;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
@@ -334,7 +335,8 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 		ath_tx_node_init(sc, an);
 		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
 				     sta->ht_cap.ampdu_factor);
-		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
+		an->mpdudensity = density;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8d83060..cafb4a0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1165,6 +1165,7 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 {
 	struct ath_atx_tid *txtid;
 	struct ath_node *an;
+	u8 density;
 
 	an = (struct ath_node *)sta->drv_priv;
 	txtid = ATH_AN_2_TID(an, tid);
@@ -1172,6 +1173,17 @@ int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 	if (txtid->state & (AGGR_CLEANUP | AGGR_ADDBA_COMPLETE))
 		return -EAGAIN;
 
+	/* update ampdu factor/density, they may have changed. This may happen
+	 * in HT IBSS when a beacon with HT-info is received after the station
+	 * has already been added.
+	 */
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
+		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+				     sta->ht_cap.ampdu_factor);
+		density = ath9k_parse_mpdudensity(sta->ht_cap.ampdu_density);
+		an->mpdudensity = density;
+	}
+
 	txtid->state |= AGGR_ADDBA_PROGRESS;
 	txtid->paused = true;
 	*ssn = txtid->seq_start = txtid->seq_next;
-- 
1.7.10
