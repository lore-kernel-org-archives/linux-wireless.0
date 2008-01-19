Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:2648 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752371AbYASJSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 04:18:10 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/3] ath5k: use SWBA to detect IBSS HW merges
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 19 Jan 2008 18:18:21 +0900
Message-ID: <20080119091821.31251.5098.stgit@one> (sfid-20080119_091818_265508_ECFA4777)
In-Reply-To: <20080119091759.31251.60264.stgit@one>
References: <20080119091759.31251.60264.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use SWBA (software beacon alert) interrupts to keep track of the next beacon
time und check if a HW merge (automatic TSF update) has happened on every
received beacon with the same BSSID.

this is necessary because the atheros hardware will silently update the local
TSF in IBSS mode, but not its beacon timers. if the TSF is ahead of the beacon
timers no beacons are sent until the timers wrap around (typically after about
1 minute).

this solution is not very nice, since we have to look into every beacon, but
there is apparently no other way to detect HW merges.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/base.h:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |   79 +++++++++++++++++++++++++++++++------
 drivers/net/wireless/ath5k/base.h |    1 
 2 files changed, 67 insertions(+), 13 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ae3d470..a47e0f3 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1629,6 +1629,34 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 	return 0;
 }
 
+
+static void
+ath5k_check_ibss_hw_merge(struct ath5k_softc *sc, struct sk_buff *skb)
+{
+	u32 hw_tu;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+
+	if ((mgmt->frame_control & IEEE80211_FCTL_FTYPE) ==
+		IEEE80211_FTYPE_MGMT &&
+	    (mgmt->frame_control & IEEE80211_FCTL_STYPE) ==
+		IEEE80211_STYPE_BEACON &&
+	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
+	    memcmp(mgmt->bssid, sc->ah->ah_bssid, ETH_ALEN) == 0) {
+		/*
+		 * Received an IBSS beacon with the same BSSID. Hardware might
+		 * have updated the TSF, check if we need to update timers.
+		 */
+		hw_tu = TSF_TO_TU(ath5k_hw_get_tsf64(sc->ah));
+		if (hw_tu >= sc->nexttbtt) {
+			ath5k_beacon_update_timers(sc,
+				mgmt->u.beacon.timestamp);
+			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+				"detected HW merge from received beacon\n");
+		}
+	}
+}
+
+
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -1763,6 +1791,10 @@ accept:
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
+		/* check beacons in IBSS mode */
+		if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+			ath5k_check_ibss_hw_merge(sc, skb);
+
 		__ieee80211_rx(sc->hw, skb, &rxs);
 		sc->led_rxrate = ds->ds_rxstat.rs_rate;
 		ath5k_led_event(sc, ATH_LED_RX);
@@ -2053,6 +2085,8 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 	}
 #undef FUDGE
 
+	sc->nexttbtt = nexttbtt;
+
 	intval |= AR5K_BEACON_ENA;
 	ath5k_hw_init_beacon(ah, nexttbtt, intval);
 
@@ -2080,16 +2114,19 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
 }
 
 
-/*
- * Configure the beacon timers and interrupts based on the operating mode
+/**
+ * ath5k_beacon_config - Configure the beacon queues and interrupts
+ *
+ * @sc: struct ath5k_softc pointer we are operating on
  *
  * When operating in station mode we want to receive a BMISS interrupt when we
  * stop seeing beacons from the AP we've associated with so we can look for
  * another AP to associate with.
  *
- * In IBSS mode we need to configure the beacon timers and use a self-linked tx
- * descriptor if possible. If the hardware cannot deal with that we enable SWBA
- * interrupts to send the beacons from the interrupt handler.
+ * In IBSS mode we use a self-linked tx descriptor if possible. We enable SWBA
+ * interrupts to detect HW merges only.
+ *
+ * AP mode is missing.
  */
 static void
 ath5k_beacon_config(struct ath5k_softc *sc)
@@ -2103,17 +2140,17 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		sc->imask |= AR5K_INT_BMISS;
 	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
 		/*
-		 * In IBSS mode enable the beacon timers but only enable SWBA
-		 * interrupts if we need to manually prepare beacon frames.
-		 * Otherwise we use a self-linked tx descriptor and let the
-		 * hardware deal with things. In that case we have to load it
+		 * In IBSS mode we use a self-linked tx descriptor and let the
+		 * hardware send the beacons automatically. We have to load it
 		 * only once here.
+		 * We use the SWBA interrupt only to keep track of the beacon
+		 * timers in order to detect HW merges (automatic TSF updates).
 		 */
 		ath5k_beaconq_config(sc);
 
-		if (!ath5k_hw_hasveol(ah))
-			sc->imask |= AR5K_INT_SWBA;
-		else
+		sc->imask |= AR5K_INT_SWBA;
+
+		if (ath5k_hw_hasveol(ah))
 			ath5k_beacon_send(sc);
 	}
 	/* TODO else AP */
@@ -2316,8 +2353,24 @@ ath5k_intr(int irq, void *dev_id)
 				* Handle beacon transmission directly; deferring
 				* this is too slow to meet timing constraints
 				* under load.
+				*
+				* In IBSS mode we use this interrupt just to
+				* keep track of the next TBTT (target beacon
+				* transmission time) in order to detect hardware
+				* merges (TSF updates).
 				*/
-				ath5k_beacon_send(sc);
+				if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+					 /* XXX: only if VEOL suppported */
+					u64 tsf = ath5k_hw_get_tsf64(ah);
+					sc->nexttbtt += sc->bintval;
+					ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+						"SWBA nexttbtt: %x hw_tu: %x "
+						"TSF: %llx\n",
+						sc->nexttbtt,
+						TSF_TO_TU(tsf), tsf);
+				} else {
+					ath5k_beacon_send(sc);
+				}
 			}
 			if (status & AR5K_INT_RXEOL) {
 				/*
diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless/ath5k/base.h
index 20c9469..8287ae7 100644
--- a/drivers/net/wireless/ath5k/base.h
+++ b/drivers/net/wireless/ath5k/base.h
@@ -166,6 +166,7 @@ struct ath5k_softc {
 				bmisscount,	/* missed beacon transmits */
 				bintval,	/* beacon interval in TU */
 				bsent;
+	unsigned int		nexttbtt;	/* next beacon time in TU */
 
 	struct timer_list	calib_tim;	/* calibration timer */
 };

