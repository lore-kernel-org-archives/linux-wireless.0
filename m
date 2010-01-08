Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57905 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab0AHEtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 23:49:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 20:49:08 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19270.48445.10761.976803@gargle.gargle.HOWL>
Date: Fri, 8 Jan 2010 10:36:05 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] ath9k: Cleanup Powersave flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sc_flags has slowly become a kitchen sink over time.
Move powersave related flags to a separate variable.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   43 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/main.c  |   36 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/recv.c  |   36 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/xmit.c  |   18 ++++++------
 4 files changed, 68 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 68a4230..f4645a4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -416,26 +416,28 @@ void ath_deinit_leds(struct ath_softc *sc);
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 #define ATH_RATE_DUMMY_MARKER   0
 
-#define SC_OP_INVALID           BIT(0)
-#define SC_OP_BEACONS           BIT(1)
-#define SC_OP_RXAGGR            BIT(2)
-#define SC_OP_TXAGGR            BIT(3)
-#define SC_OP_FULL_RESET        BIT(4)
-#define SC_OP_PREAMBLE_SHORT    BIT(5)
-#define SC_OP_PROTECT_ENABLE    BIT(6)
-#define SC_OP_RXFLUSH           BIT(7)
-#define SC_OP_LED_ASSOCIATED    BIT(8)
-#define SC_OP_WAIT_FOR_BEACON   BIT(12)
-#define SC_OP_LED_ON            BIT(13)
-#define SC_OP_SCANNING          BIT(14)
-#define SC_OP_TSF_RESET         BIT(15)
-#define SC_OP_WAIT_FOR_CAB      BIT(16)
-#define SC_OP_WAIT_FOR_PSPOLL_DATA BIT(17)
-#define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
-#define SC_OP_BEACON_SYNC       BIT(19)
-#define SC_OP_BT_PRIORITY_DETECTED BIT(21)
-#define SC_OP_NULLFUNC_COMPLETED BIT(22)
-#define SC_OP_PS_ENABLED	BIT(23)
+#define SC_OP_INVALID                BIT(0)
+#define SC_OP_BEACONS                BIT(1)
+#define SC_OP_RXAGGR                 BIT(2)
+#define SC_OP_TXAGGR                 BIT(3)
+#define SC_OP_FULL_RESET             BIT(4)
+#define SC_OP_PREAMBLE_SHORT         BIT(5)
+#define SC_OP_PROTECT_ENABLE         BIT(6)
+#define SC_OP_RXFLUSH                BIT(7)
+#define SC_OP_LED_ASSOCIATED         BIT(8)
+#define SC_OP_LED_ON                 BIT(9)
+#define SC_OP_SCANNING               BIT(10)
+#define SC_OP_TSF_RESET              BIT(11)
+#define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
+
+/* Powersave flags */
+#define PS_WAIT_FOR_BEACON        BIT(0)
+#define PS_WAIT_FOR_CAB           BIT(1)
+#define PS_WAIT_FOR_PSPOLL_DATA   BIT(2)
+#define PS_WAIT_FOR_TX_ACK        BIT(3)
+#define PS_BEACON_SYNC            BIT(4)
+#define PS_NULLFUNC_COMPLETED     BIT(5)
+#define PS_ENABLED                BIT(6)
 
 struct ath_wiphy;
 struct ath_rate_table;
@@ -471,6 +473,7 @@ struct ath_softc {
 
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
+	u16 ps_flags; /* PS_* */
 	u16 curtxpow;
 	u8 nbcnvifs;
 	u16 nvifs;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 48bd5d5..974de20 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -144,10 +144,10 @@ void ath9k_ps_restore(struct ath_softc *sc)
 		goto unlock;
 
 	if (sc->ps_enabled &&
-	    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-			      SC_OP_WAIT_FOR_CAB |
-			      SC_OP_WAIT_FOR_PSPOLL_DATA |
-			      SC_OP_WAIT_FOR_TX_ACK)))
+	    !(sc->ps_flags & (PS_WAIT_FOR_BEACON |
+			      PS_WAIT_FOR_CAB |
+			      PS_WAIT_FOR_PSPOLL_DATA |
+			      PS_WAIT_FOR_TX_ACK)))
 		ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_NETWORK_SLEEP);
 
  unlock:
@@ -424,7 +424,7 @@ void ath9k_tasklet(unsigned long data)
 		 */
 		ath_print(common, ATH_DBG_PS,
 			  "TSFOOR - Sync with next Beacon\n");
-		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON | SC_OP_BEACON_SYNC;
+		sc->ps_flags |= PS_WAIT_FOR_BEACON | PS_BEACON_SYNC;
 	}
 
 	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
@@ -525,7 +525,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 			 * receive frames */
 			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			ath9k_hw_setrxabort(sc->sc_ah, 0);
-			sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
+			sc->ps_flags |= PS_WAIT_FOR_BEACON;
 		}
 
 chip_reset:
@@ -833,7 +833,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		 * on the receipt of the first Beacon frame (i.e.,
 		 * after time sync with the AP).
 		 */
-		sc->sc_flags |= SC_OP_BEACON_SYNC;
+		sc->ps_flags |= PS_BEACON_SYNC;
 
 		/* Configure the beacon */
 		ath_beacon_config(sc, vif);
@@ -1238,11 +1238,11 @@ static int ath9k_tx(struct ieee80211_hw *hw,
 		if (ieee80211_is_pspoll(hdr->frame_control)) {
 			ath_print(common, ATH_DBG_PS,
 				  "Sending PS-Poll to pick a buffered frame\n");
-			sc->sc_flags |= SC_OP_WAIT_FOR_PSPOLL_DATA;
+			sc->ps_flags |= PS_WAIT_FOR_PSPOLL_DATA;
 		} else {
 			ath_print(common, ATH_DBG_PS,
 				  "Wake up to complete TX\n");
-			sc->sc_flags |= SC_OP_WAIT_FOR_TX_ACK;
+			sc->ps_flags |= PS_WAIT_FOR_TX_ACK;
 		}
 		/*
 		 * The actual restore operation will happen only after
@@ -1538,7 +1538,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	 */
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
 		if (conf->flags & IEEE80211_CONF_PS) {
-			sc->sc_flags |= SC_OP_PS_ENABLED;
+			sc->ps_flags |= PS_ENABLED;
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				if ((sc->imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -1551,23 +1551,23 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			 * At this point we know hardware has received an ACK
 			 * of a previously sent null data frame.
 			 */
-			if ((sc->sc_flags & SC_OP_NULLFUNC_COMPLETED)) {
-				sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+			if ((sc->ps_flags & PS_NULLFUNC_COMPLETED)) {
+				sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
 				sc->ps_enabled = true;
 				ath9k_hw_setrxabort(sc->sc_ah, 1);
                         }
 		} else {
 			sc->ps_enabled = false;
-			sc->sc_flags &= ~(SC_OP_PS_ENABLED |
-					  SC_OP_NULLFUNC_COMPLETED);
+			sc->ps_flags &= ~(PS_ENABLED |
+					  PS_NULLFUNC_COMPLETED);
 			ath9k_setpower(sc, ATH9K_PM_AWAKE);
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				ath9k_hw_setrxabort(sc->sc_ah, 0);
-				sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON |
-						  SC_OP_WAIT_FOR_CAB |
-						  SC_OP_WAIT_FOR_PSPOLL_DATA |
-						  SC_OP_WAIT_FOR_TX_ACK);
+				sc->ps_flags &= ~(PS_WAIT_FOR_BEACON |
+						  PS_WAIT_FOR_CAB |
+						  PS_WAIT_FOR_PSPOLL_DATA |
+						  PS_WAIT_FOR_TX_ACK);
 				if (sc->imask & ATH9K_INT_TIM_TIMER) {
 					sc->imask &= ~ATH9K_INT_TIM_TIMER;
 					ath9k_hw_set_interrupts(sc->sc_ah,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 477365e..17b0a6d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -364,10 +364,10 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0)
 		return; /* not from our current AP */
 
-	sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+	sc->ps_flags &= ~PS_WAIT_FOR_BEACON;
 
-	if (sc->sc_flags & SC_OP_BEACON_SYNC) {
-		sc->sc_flags &= ~SC_OP_BEACON_SYNC;
+	if (sc->ps_flags & PS_BEACON_SYNC) {
+		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_print(common, ATH_DBG_PS,
 			  "Reconfigure Beacon timers based on "
 			  "timestamp from the AP\n");
@@ -384,17 +384,17 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		 */
 		ath_print(common, ATH_DBG_PS, "Received DTIM beacon indicating "
 			  "buffered broadcast/multicast frame(s)\n");
-		sc->sc_flags |= SC_OP_WAIT_FOR_CAB | SC_OP_WAIT_FOR_BEACON;
+		sc->ps_flags |= PS_WAIT_FOR_CAB | PS_WAIT_FOR_BEACON;
 		return;
 	}
 
-	if (sc->sc_flags & SC_OP_WAIT_FOR_CAB) {
+	if (sc->ps_flags & PS_WAIT_FOR_CAB) {
 		/*
 		 * This can happen if a broadcast frame is dropped or the AP
 		 * fails to send a frame indicating that all CAB frames have
 		 * been delivered.
 		 */
-		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
+		sc->ps_flags &= ~PS_WAIT_FOR_CAB;
 		ath_print(common, ATH_DBG_PS,
 			  "PS wait for CAB frames timed out\n");
 	}
@@ -408,10 +408,10 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/* Process Beacon and CAB receive in PS state */
-	if ((sc->sc_flags & SC_OP_WAIT_FOR_BEACON) &&
+	if ((sc->ps_flags & PS_WAIT_FOR_BEACON) &&
 	    ieee80211_is_beacon(hdr->frame_control))
 		ath_rx_ps_beacon(sc, skb);
-	else if ((sc->sc_flags & SC_OP_WAIT_FOR_CAB) &&
+	else if ((sc->ps_flags & PS_WAIT_FOR_CAB) &&
 		 (ieee80211_is_data(hdr->frame_control) ||
 		  ieee80211_is_action(hdr->frame_control)) &&
 		 is_multicast_ether_addr(hdr->addr1) &&
@@ -420,20 +420,20 @@ static void ath_rx_ps(struct ath_softc *sc, struct sk_buff *skb)
 		 * No more broadcast/multicast frames to be received at this
 		 * point.
 		 */
-		sc->sc_flags &= ~SC_OP_WAIT_FOR_CAB;
+		sc->ps_flags &= ~PS_WAIT_FOR_CAB;
 		ath_print(common, ATH_DBG_PS,
 			  "All PS CAB frames received, back to sleep\n");
-	} else if ((sc->sc_flags & SC_OP_WAIT_FOR_PSPOLL_DATA) &&
+	} else if ((sc->ps_flags & PS_WAIT_FOR_PSPOLL_DATA) &&
 		   !is_multicast_ether_addr(hdr->addr1) &&
 		   !ieee80211_has_morefrags(hdr->frame_control)) {
-		sc->sc_flags &= ~SC_OP_WAIT_FOR_PSPOLL_DATA;
+		sc->ps_flags &= ~PS_WAIT_FOR_PSPOLL_DATA;
 		ath_print(common, ATH_DBG_PS,
 			  "Going back to sleep after having received "
 			  "PS-Poll data (0x%x)\n",
-			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-					SC_OP_WAIT_FOR_CAB |
-					SC_OP_WAIT_FOR_PSPOLL_DATA |
-					SC_OP_WAIT_FOR_TX_ACK));
+			sc->ps_flags & (PS_WAIT_FOR_BEACON |
+					PS_WAIT_FOR_CAB |
+					PS_WAIT_FOR_PSPOLL_DATA |
+					PS_WAIT_FOR_TX_ACK));
 	}
 }
 
@@ -631,9 +631,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			sc->rx.rxotherant = 0;
 		}
 
-		if (unlikely(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-					     SC_OP_WAIT_FOR_CAB |
-					     SC_OP_WAIT_FOR_PSPOLL_DATA)))
+		if (unlikely(sc->ps_flags & (PS_WAIT_FOR_BEACON |
+					     PS_WAIT_FOR_CAB |
+					     PS_WAIT_FOR_PSPOLL_DATA)))
 			ath_rx_ps(sc, skb);
 
 		ath_rx_send_to_mac80211(hw, sc, skb, rxs);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fa12b90..a821bb6 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1648,7 +1648,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
 	/* tag if this is a nullfunc frame to enable PS when AP acks it */
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc)) {
 		bf->bf_isnullfunc = true;
-		sc->sc_flags &= ~SC_OP_NULLFUNC_COMPLETED;
+		sc->ps_flags &= ~PS_NULLFUNC_COMPLETED;
 	} else
 		bf->bf_isnullfunc = false;
 
@@ -1858,15 +1858,15 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		skb_pull(skb, padsize);
 	}
 
-	if (sc->sc_flags & SC_OP_WAIT_FOR_TX_ACK) {
-		sc->sc_flags &= ~SC_OP_WAIT_FOR_TX_ACK;
+	if (sc->ps_flags & PS_WAIT_FOR_TX_ACK) {
+		sc->ps_flags &= ~PS_WAIT_FOR_TX_ACK;
 		ath_print(common, ATH_DBG_PS,
 			  "Going back to sleep after having "
 			  "received TX status (0x%x)\n",
-			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-					SC_OP_WAIT_FOR_CAB |
-					SC_OP_WAIT_FOR_PSPOLL_DATA |
-					SC_OP_WAIT_FOR_TX_ACK));
+			sc->ps_flags & (PS_WAIT_FOR_BEACON |
+					PS_WAIT_FOR_CAB |
+					PS_WAIT_FOR_PSPOLL_DATA |
+					PS_WAIT_FOR_TX_ACK));
 	}
 
 	if (unlikely(tx_info->pad[0] & ATH_TX_INFO_FRAME_TYPE_INTERNAL))
@@ -2053,11 +2053,11 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 */
 		if (bf->bf_isnullfunc &&
 		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
-			if ((sc->sc_flags & SC_OP_PS_ENABLED)) {
+			if ((sc->ps_flags & PS_ENABLED)) {
 				sc->ps_enabled = true;
 				ath9k_hw_setrxabort(sc->sc_ah, 1);
 			} else
-				sc->sc_flags |= SC_OP_NULLFUNC_COMPLETED;
+				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
 		}
 
 		/*
-- 
1.6.6

