Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1072 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbZD3T44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 15:56:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Nick Kossifidis <mick@madwifi-project.org>
Subject: [PATCH 4/9] ath5k: Beaconing fixes
Date: Thu, 30 Apr 2009 15:55:47 -0400
Message-Id: <1241121352-6064-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
References: <1241121352-6064-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nick Kossifidis <mick@madwifi-project.org>

* Write next beacon timer even on AP mode since without this we get
 no beacons + ath9k does it too.  Docs say that we must write 0 on
 this register on AP mode to start TSF increment, we do both to be
 on the safe side.

 * Fix num_tx_pending function, we never read the register :P that's
 why we got all those "beacon queue 7 didn't stop messages".

 * Put full prioriy on beacon queue, lock all queues with lower
 priority using the arblock and also bypass any arblock by seting
 the arblock ignore flag.

 * For the CAB queue (do we need this thing ?, it seems crap) since
 it's supposed to fire up after each beacon (we don't use it on driver
 part, ath9k/MadWiFi does), don't make it DBA gated but instead make
 it fire after each beacon by using the beacon sent gated flag.

 * Increase bmiss threshold to 10, that's what we used on MadWiFi for
 a long time. Also when we have pending frames on the beacon queue (we
 got a beacon that didn't make it on the air) it's more likely that
 the beacon queue never started, probably due to faulty DBA setting,
 so change that "beacon queue didn't stop" message.

 Tested this with AP mode and IBSS mode and seems to work fine ;-)

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
 Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   64 +++++++++++++++++----------------
 drivers/net/wireless/ath/ath5k/pcu.c  |    4 +-
 drivers/net/wireless/ath/ath5k/qcu.c  |    7 +++-
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d70856a..b48ff7d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1738,35 +1738,6 @@ ath5k_check_ibss_tsf(struct ath5k_softc *sc, struct sk_buff *skb,
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
@@ -2120,7 +2091,7 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount++;
 		ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 			"missed %u consecutive beacons\n", sc->bmisscount);
-		if (sc->bmisscount > 3) {		/* NB: 3 is a guess */
+		if (sc->bmisscount > 10) {	/* NB: 10 is a guess */
 			ATH5K_DBG(sc, ATH5K_DEBUG_BEACON,
 				"stuck beacon time (%u missed)\n",
 				sc->bmisscount);
@@ -2141,10 +2112,12 @@ ath5k_beacon_send(struct ath5k_softc *sc)
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
@@ -2301,6 +2274,35 @@ ath5k_beacon_config(struct ath5k_softc *sc)
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
index 5f07e87..579aa0a 100644
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
-- 
1.6.0.6


