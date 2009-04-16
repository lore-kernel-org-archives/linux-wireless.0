Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:48779 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZDPA3n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:29:43 -0400
Date: Thu, 16 Apr 2009 03:29:51 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 4/7] ath5k: Beaconing fixes
Message-ID: <20090416002951.GD4138@makis> (sfid-20090416_022946_555424_63009D19)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Write next beacon timer even on AP mode since without this we get no beacons + ath9k does it too.
 Docs say that we must write 0 on this register on AP mode to start TSF increment, we do both to be
 on the safe side.

 * Fix num_tx_pending function, we never read the register :P that's why we got all those "beacon queue 7 didn't
 stop messages".

 * Put full prioriy on beacon queue, lock all queues with lower priority using the arblock and also bypass any
 arblock by seting the arblock ignore flag.

 * For the CAB queue (do we need this thing ?, it seems crap) since it's supposed to fire up after each beacon
 (we don't use it on driver part, ath9k/MadWiFi does), don't make it DBA gated but instead make it fire after
 each beacon by using the beacon sent gated flag.

 * Increase bmiss threshold to 10, that's what we used on MadWiFi for a long time. Also when we have pending
 frames on the beacon queue (we got a beacon that didn't make it on the air) it's more likely that the beacon
 queue never started, probably due to faulty DBA setting, so change that "beacon queue didn't stop) message.

 Tested this with AP mode and IBSS mode and seems to work fine ;-)

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |   64 +++++++++++++++++----------------
 drivers/net/wireless/ath/ath5k/pcu.c  |    4 +-
 drivers/net/wireless/ath/ath5k/qcu.c  |    7 +++-
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3390603..6594572 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1743,35 +1743,6 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
 	}
 }
 
-static void ath5k_tasklet_beacon(unsigned long data)
-{
-	struct ath5k_softc *sc = (struct ath5k_softc *) data;
-
-	/*
-	 * Software beacon alert--time to send a beacon.
-	 *
-	 * In IBSS mode we use this interrupt just to
-	 * keep track of the next TBTT (target beacon
-	 * transmission time) in order to detect wether
-	 * automatic TSF updates happened.
-	 */
-	if (sc->opmode == NL80211_IFTYPE_ADHOC) {
-		/* XXX: only if VEOL suppported */
-		u64 tsf = ath5k_hw_get_tsf64(sc->ah);
-		sc->nexttbtt += sc->bintval;
-		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
-				"SWBA nexttbtt: %x hw_tu: %x "
-				"TSF: %llx\n",
-				sc->nexttbtt,
-				TSF_TO_TU(tsf),
-				(unsigned long long) tsf);
-	} else {
-		spin_lock(&sc->block);
-		ath5k_beacon_send(sc);
-		spin_unlock(&sc->block);
-	}
-}
-
 static void
 ath5k_tasklet_rx(unsigned long data)
 {
@@ -2141,7 +2112,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount++;
 		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 			"missed %u consecutive beacons\n", sc->bmisscount);
-		if (sc->bmisscount > 3) {		/* NB: 3 is a guess */
+		if (sc->bmisscount > 10) {	/* NB: 10 is a guess */
 			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 				"stuck beacon time (%u missed)\n",
 				sc->bmisscount);
@@ -2162,10 +2133,12 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 	 * are still pending on the queue.
 	 */
 	if (unlikely(ath5k_hw_stop_tx_dma(ah, sc->bhalq))) {
-		ATH5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
+		ATH5K_WARN(sc, "beacon queue %u didn't start/stop ?\n", sc->bhalq);
 		/* NB: hw still stops DMA, so proceed */
 	}
 
+	/* Note: Beacon buffer is updated on beacon_update when mac80211
+	 * calls config_interface */
 	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
 	ath5k_hw_start_tx_dma(ah, sc->bhalq);
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "TXDP[%u] = %llx (%p)\n",
@@ -2322,6 +2295,35 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 	ath5k_hw_set_imr(ah, sc->imask);
 }
 
+static void ath5k_tasklet_beacon(unsigned long data)
+{
+	struct ath5k_softc *sc = (struct ath5k_softc *) data;
+
+	/*
+	 * Software beacon alert--time to send a beacon.
+	 *
+	 * In IBSS mode we use this interrupt just to
+	 * keep track of the next TBTT (target beacon
+	 * transmission time) in order to detect wether
+	 * automatic TSF updates happened.
+	 */
+	if (sc->opmode == NL80211_IFTYPE_ADHOC) {
+		/* XXX: only if VEOL suppported */
+		u64 tsf = ath5k_hw_get_tsf64(sc->ah);
+		sc->nexttbtt += sc->bintval;
+		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
+				"SWBA nexttbtt: %x hw_tu: %x "
+				"TSF: %llx\n",
+				sc->nexttbtt,
+				TSF_TO_TU(tsf),
+				(unsigned long long) tsf);
+	} else {
+		spin_lock(&sc->block);
+		ath5k_beacon_send(sc);
+		spin_unlock(&sc->block);
+	}
+}
+
 
 /********************\
 * Interrupt handling *
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 55122f1..b76385e 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -736,8 +736,8 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/* When in AP mode zero timer0 to start TSF */
 	if (ah->ah_op_mode == NL80211_IFTYPE_AP)
 		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
-	else
-		ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
+
+	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
 	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
 	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
 	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 5094c39..73407b3 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -160,7 +160,8 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 	if (ah->ah_version == AR5K_AR5210)
 		return false;
 
-	pending = (AR5K_QUEUE_STATUS(queue) & AR5K_QCU_STS_FRMPENDCNT);
+	pending = ath5k_hw_reg_read(ah, AR5K_QUEUE_STATUS(queue));
+	pending &= AR5K_QCU_STS_FRMPENDCNT;
 
 	/* It's possible to have no frames pending even if TXE
 	 * is set. To indicate that q has not stopped return
@@ -401,14 +402,16 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
 				AR5K_DCU_MISC_ARBLOCK_CTL_S) |
+				AR5K_DCU_MISC_ARBLOCK_IGNORE |
 				AR5K_DCU_MISC_POST_FR_BKOFF_DIS |
 				AR5K_DCU_MISC_BCN_ENABLE);
 			break;
 
 		case AR5K_TX_QUEUE_CAB:
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_FRSHED_DBA_GT |
+				AR5K_QCU_MISC_FRSHED_BCN_SENT_GT |
 				AR5K_QCU_MISC_CBREXP_DIS |
+				AR5K_QCU_MISC_RDY_VEOL_POLICY |
 				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
 			ath5k_hw_reg_write(ah, ((AR5K_TUNE_BEACON_INTERVAL -
