Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:18336 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763989AbYCEJgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:50 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 4/4] ath5k: work around wrong beacon rx timestamp in IBSS mode
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 05 Mar 2008 18:36:26 +0900
Message-ID: <20080305093626.5670.51643.stgit@one> (sfid-20080305_093711_652055_B4FFF805)
In-Reply-To: <20080305091347.5670.40944.stgit@one>
References: <20080305091347.5670.40944.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

atheros hardware has a problem with the rx timestamp of some IBSS beacons when
they caused a TSF update (they have the same BSSID).

the rx timestamp is wrong especially if the beacon frames get bigger than 78
byte (at least on AR5213 and AR5414 hardware). in that case ath5k_extend_tsf()
will assume a rs_tstamp overflow and give us a timestamp too far in the past
which will cause mac80211 to merge IBSS on every beacon (which is not necessary
since the BSSID already matches). but in this case we know that the HW must
have synced to the beacons TSF and the rx timestamp must be later than that so
we can adjust mactime accordingly.

also rename the function to ath5k_check_ibss_tsf() and change comments, since
"hw merge" is better described as a TSF update.

drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/base.c |   59 ++++++++++++++++++++++++++++---------
 1 files changed, 45 insertions(+), 14 deletions(-)


diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 03e05fe..5139217 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1712,8 +1712,10 @@ ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
 
 
 static void
-ath5k_check_ibss_hw_merge(struct ath5k_softc *sc, struct sk_buff *skb)
+ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
+		     struct ieee80211_rx_status *rxs)
 {
+	u64 tsf, bc_tstamp;
 	u32 hw_tu;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 
@@ -1724,16 +1726,45 @@ ath5k_check_ibss_hw_merge(struct ath5k_softc *sc, struct sk_buff *skb)
 	    le16_to_cpu(mgmt->u.beacon.capab_info) & WLAN_CAPABILITY_IBSS &&
 	    memcmp(mgmt->bssid, sc->ah->ah_bssid, ETH_ALEN) == 0) {
 		/*
-		 * Received an IBSS beacon with the same BSSID. Hardware might
-		 * have updated the TSF, check if we need to update timers.
+		 * Received an IBSS beacon with the same BSSID. Hardware *must*
+		 * have updated the local TSF. We have to work around various
+		 * hardware bugs, though...
 		 */
-		hw_tu = TSF_TO_TU(ath5k_hw_get_tsf64(sc->ah));
-		if (hw_tu >= sc->nexttbtt) {
-			ath5k_beacon_update_timers(sc,
-				le64_to_cpu(mgmt->u.beacon.timestamp));
+		tsf = ath5k_hw_get_tsf64(sc->ah);
+		bc_tstamp = le64_to_cpu(mgmt->u.beacon.timestamp);
+		hw_tu = TSF_TO_TU(tsf);
+
+		ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
+			"beacon %llx mactime %llx (diff %lld) tsf now %llx\n",
+			bc_tstamp, rxs->mactime,
+			(rxs->mactime - bc_tstamp), tsf);
+
+		/*
+		 * Sometimes the HW will give us a wrong tstamp in the rx
+		 * status, causing the timestamp extension to go wrong.
+		 * (This seems to happen especially with beacon frames bigger
+		 * than 78 byte (incl. FCS))
+		 * But we know that the receive timestamp must be later than the
+		 * timestamp of the beacon since HW must have synced to that.
+		 *
+		 * NOTE: here we assume mactime to be after the frame was
+		 * received, not like mac80211 which defines it at the start.
+		 */
+		if (bc_tstamp > rxs->mactime) {
 			ATH5K_DBG_UNLIMIT(sc, ATH5K_DEBUG_BEACON,
-				"detected HW merge from received beacon\n");
+				"fixing mactime from %llx to %llx\n",
+				rxs->mactime, tsf);
+			rxs->mactime = tsf;
 		}
+
+		/*
+		 * Local TSF might have moved higher than our beacon timers,
+		 * in that case we have to update them to continue sending
+		 * beacons. This also takes care of synchronizing beacon sending
+		 * times with other stations.
+		 */
+		if (hw_tu >= sc->nexttbtt)
+			ath5k_beacon_update_timers(sc, bc_tstamp);
 	}
 }
 
@@ -1882,7 +1913,7 @@ accept:
 
 		/* check beacons in IBSS mode */
 		if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
-			ath5k_check_ibss_hw_merge(sc, skb);
+			ath5k_check_ibss_tsf(sc, skb, &rxs);
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
 		sc->led_rxrate = rs.rs_rate;
@@ -2115,7 +2146,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
  * beacon timer registers.
  *
  * This is called in a variety of situations, e.g. when a beacon is received,
- * when a HW merge has been detected, but also when an new IBSS is created or
+ * when a TSF update has been detected, but also when an new IBSS is created or
  * when we otherwise know we have to update the timers, but we keep it in this
  * function to have it all together in one place.
  */
@@ -2215,7 +2246,7 @@ ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf)
  * another AP to associate with.
  *
  * In IBSS mode we use a self-linked tx descriptor if possible. We enable SWBA
- * interrupts to detect HW merges only.
+ * interrupts to detect TSF updates only.
  *
  * AP mode is missing.
  */
@@ -2235,7 +2266,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		 * hardware send the beacons automatically. We have to load it
 		 * only once here.
 		 * We use the SWBA interrupt only to keep track of the beacon
-		 * timers in order to detect HW merges (automatic TSF updates).
+		 * timers in order to detect automatic TSF updates.
 		 */
 		ath5k_beaconq_config(sc);
 
@@ -2448,8 +2479,8 @@ ath5k_intr(int irq, void *dev_id)
 				*
 				* In IBSS mode we use this interrupt just to
 				* keep track of the next TBTT (target beacon
-				* transmission time) in order to detect hardware
-				* merges (TSF updates).
+				* transmission time) in order to detect wether
+				* automatic TSF updates happened.
 				*/
 				if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
 					 /* XXX: only if VEOL suppported */

