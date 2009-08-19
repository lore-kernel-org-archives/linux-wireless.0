Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60502 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZHSLBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 07:01:48 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 04:01:51 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH] ath9k: Nuke struct ath9k_node_stats
Date: Wed, 19 Aug 2009 16:23:40 +0530
Message-ID: <1250679220-30392-2-git-send-email-vasanth@atheros.com>
In-Reply-To: <1250679220-30392-1-git-send-email-vasanth@atheros.com>
References: <1250679220-30392-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other than ns_avgbrssi (Average beacon rssi) no data of
ath9k_node_stats is being used anywhere. Nuke this structure
and move its only useful member to ar5416Anistate. Also cleanup
this redundant data in ath_softc.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c   |    6 +-----
 drivers/net/wireless/ath/ath9k/ani.h   |   15 +++------------
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |    9 +++------
 drivers/net/wireless/ath/ath9k/recv.c  |    2 +-
 5 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index f264097..a7cbb07 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -538,7 +538,6 @@ void ath9k_ani_reset(struct ath_hw *ah)
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
-			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan)
 {
 	struct ar5416AniState *aniState;
@@ -550,7 +549,6 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 		return;
 
 	aniState = ah->curani;
-	ah->stats.ast_nodestats = *stats;
 
 	listenTime = ath9k_hw_ani_get_listen_time(ah);
 	if (listenTime < 0) {
@@ -693,8 +691,7 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah,
  * any of the MIB counters overflow/trigger so don't assume we're
  * here because a PHY error counter triggered.
  */
-void ath9k_hw_procmibevent(struct ath_hw *ah,
-			   const struct ath9k_node_stats *stats)
+void ath9k_hw_procmibevent(struct ath_hw *ah)
 {
 	u32 phyCnt1, phyCnt2;
 
@@ -706,7 +703,6 @@ void ath9k_hw_procmibevent(struct ath_hw *ah,
 
 	/* Clear the mib counters and save them in the stats */
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-	ah->stats.ast_nodestats = *stats;
 
 	if (!DO_ANI(ah))
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 6273fd0..4e1ab94 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -21,7 +21,7 @@
 
 #define DO_ANI(ah) (((ah)->proc_phyerr & HAL_PROCESS_ANI))
 
-#define BEACON_RSSI(ahp) (ahp->stats.ast_nodestats.ns_avgbrssi)
+#define BEACON_RSSI(ahp) (ahp->stats.avgbrssi)
 
 #define ATH9K_ANI_OFDM_TRIG_HIGH          500
 #define ATH9K_ANI_OFDM_TRIG_LOW           200
@@ -60,13 +60,6 @@ struct ath9k_mib_stats {
 	u32 beacons;
 };
 
-struct ath9k_node_stats {
-	u32 ns_avgbrssi;
-	u32 ns_avgrssi;
-	u32 ns_avgtxrssi;
-	u32 ns_avgtxrate;
-};
-
 struct ar5416AniState {
 	struct ath9k_channel *c;
 	u8 noiseImmunityLevel;
@@ -110,21 +103,19 @@ struct ar5416Stats {
 	u32 ast_ani_reset;
 	u32 ast_ani_lzero;
 	u32 ast_ani_lneg;
+	u32 avgbrssi;
 	struct ath9k_mib_stats ast_mibstats;
-	struct ath9k_node_stats ast_nodestats;
 };
 #define ah_mibStats stats.ast_mibstats
 
 void ath9k_ani_reset(struct ath_hw *ah);
 void ath9k_hw_ani_monitor(struct ath_hw *ah,
-			  const struct ath9k_node_stats *stats,
 			  struct ath9k_channel *chan);
 void ath9k_enable_mib_counters(struct ath_hw *ah);
 void ath9k_hw_disable_mib_counters(struct ath_hw *ah);
 u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
 				  u32 *rxf_pcnt, u32 *txf_pcnt);
-void ath9k_hw_procmibevent(struct ath_hw *ah,
-			   const struct ath9k_node_stats *stats);
+void ath9k_hw_procmibevent(struct ath_hw *ah);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
 void ath9k_hw_ani_disable(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2c9f662..70bdd92 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -603,7 +603,6 @@ struct ath_softc {
 	int beacon_interval;
 
 	struct ath_ani ani;
-	struct ath9k_node_stats nodestats;
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug debug;
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2f9c149..f92b47d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -384,7 +384,7 @@ static void ath_ani_calibrate(unsigned long data)
 	if (longcal || shortcal || aniflag) {
 		/* Call ANI routine if necessary */
 		if (aniflag)
-			ath9k_hw_ani_monitor(ah, &sc->nodestats, ah->curchan);
+			ath9k_hw_ani_monitor(ah, ah->curchan);
 
 		/* Perform calibration if necessary */
 		if (longcal || shortcal) {
@@ -589,7 +589,7 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * it will clear whatever condition caused
 		 * the interrupt.
 		 */
-		ath9k_hw_procmibevent(ah, &sc->nodestats);
+		ath9k_hw_procmibevent(ah);
 		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 
@@ -940,10 +940,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		ath_beacon_config(sc, vif);
 
 		/* Reset rssi stats */
-		sc->nodestats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->nodestats.ns_avgrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->nodestats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
-		sc->nodestats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
+		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 
 		ath_start_ani(sc);
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 61dbdd2..7b62c22 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -222,7 +222,7 @@ static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
 
 	/* Update Beacon RSSI, this is used by ANI. */
 	if (ieee80211_is_beacon(fc))
-		sc->nodestats.ns_avgbrssi = ds->ds_rxstat.rs_rssi;
+		sc->sc_ah->stats.avgbrssi = ds->ds_rxstat.rs_rssi;
 
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
-- 
1.5.5.1

