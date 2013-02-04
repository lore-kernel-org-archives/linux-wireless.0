Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42858 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab3BDKJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 05:09:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k: Fix IBSS joiner mode
Date: Mon,  4 Feb 2013 15:38:24 +0530
Message-Id: <1359972504-8900-3-git-send-email-sujith@msujith.org> (sfid-20130204_110945_899975_0DFE0E92)
In-Reply-To: <1359972504-8900-1-git-send-email-sujith@msujith.org>
References: <1359972504-8900-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

On joining an existing IBSS network, beaconing has to start
only after a TSF sync has happened by receiving a beacon from
the BSS. In creator mode, beaconing can start immediately after
a HW reset has been done.

Now that mac80211 notifies the driver of the mode type (creator/joiner)
via ieee80211_bss_conf->ibss_creator, make use of it to properly setup
the HW beacon timers.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   1 +
 drivers/net/wireless/ath/ath9k/beacon.c | 113 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/recv.c   |   2 +-
 3 files changed, 89 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 97c90b2..a56b241 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -389,6 +389,7 @@ struct ath_beacon_config {
 	u16 bmiss_timeout;
 	u8 dtim_count;
 	bool enable_beacon;
+	bool ibss_creator;
 };
 
 struct ath_beacon {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index dd37719..5f05c26 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -407,12 +407,17 @@ void ath9k_beacon_tasklet(unsigned long data)
 	}
 }
 
-static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt, u32 intval)
+/*
+ * Both nexttbtt and intval have to be in usecs.
+ */
+static void ath9k_beacon_init(struct ath_softc *sc, u32 nexttbtt,
+			      u32 intval, bool reset_tsf)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
 	ath9k_hw_disable_interrupts(ah);
-	ath9k_hw_reset_tsf(ah);
+	if (reset_tsf)
+		ath9k_hw_reset_tsf(ah);
 	ath9k_beaconq_config(sc);
 	ath9k_hw_beaconinit(ah, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
@@ -442,10 +447,12 @@ static void ath9k_beacon_config_ap(struct ath_softc *sc,
 	else
 		ah->imask &= ~ATH9K_INT_SWBA;
 
-	ath_dbg(common, BEACON, "AP nexttbtt: %u intval: %u conf_intval: %u\n",
+	ath_dbg(common, BEACON,
+		"AP (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
+		(conf->enable_beacon) ? "Enable" : "Disable",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath9k_beacon_init(sc, nexttbtt, intval);
+	ath9k_beacon_init(sc, nexttbtt, intval, true);
 }
 
 /*
@@ -586,17 +593,45 @@ static void ath9k_beacon_config_adhoc(struct ath_softc *sc,
 	ath9k_reset_beacon_status(sc);
 
 	intval = TU_TO_USEC(conf->beacon_interval);
-	nexttbtt = intval;
+
+	if (conf->ibss_creator) {
+		nexttbtt = intval;
+	} else {
+		u32 tbtt, offset, tsftu;
+		u64 tsf;
+
+		/*
+		 * Pull nexttbtt forward to reflect the current
+		 * sync'd TSF.
+		 */
+		tsf = ath9k_hw_gettsf64(ah);
+		tsftu = TSF_TO_TU(tsf >> 32, tsf) + FUDGE;
+		offset = tsftu % conf->beacon_interval;
+		tbtt = tsftu - offset;
+		if (offset)
+			tbtt += conf->beacon_interval;
+
+		nexttbtt = TU_TO_USEC(tbtt);
+	}
 
 	if (conf->enable_beacon)
 		ah->imask |= ATH9K_INT_SWBA;
 	else
 		ah->imask &= ~ATH9K_INT_SWBA;
 
-	ath_dbg(common, BEACON, "IBSS nexttbtt: %u intval: %u conf_intval: %u\n",
+	ath_dbg(common, BEACON,
+		"IBSS (%s) nexttbtt: %u intval: %u conf_intval: %u\n",
+		(conf->enable_beacon) ? "Enable" : "Disable",
 		nexttbtt, intval, conf->beacon_interval);
 
-	ath9k_beacon_init(sc, nexttbtt, intval);
+	ath9k_beacon_init(sc, nexttbtt, intval, conf->ibss_creator);
+
+	/*
+	 * Set the global 'beacon has been configured' flag for the
+	 * joiner case in IBSS mode.
+	 */
+	if (!conf->ibss_creator && conf->enable_beacon)
+		set_bit(SC_OP_BEACONS, &sc->sc_flags);
 }
 
 bool ath9k_allow_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif)
@@ -639,6 +674,7 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 	cur_conf->dtim_period = bss_conf->dtim_period;
 	cur_conf->listen_interval = 1;
 	cur_conf->dtim_count = 1;
+	cur_conf->ibss_creator = bss_conf->ibss_creator;
 	cur_conf->bmiss_timeout =
 		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
 
@@ -666,34 +702,59 @@ void ath9k_beacon_config(struct ath_softc *sc, struct ieee80211_vif *vif,
 {
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 	struct ath_beacon_config *cur_conf = &sc->cur_beacon_conf;
+	unsigned long flags;
+	bool skip_beacon = false;
 
 	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
 		ath9k_cache_beacon_config(sc, bss_conf);
 		ath9k_set_beacon(sc);
 		set_bit(SC_OP_BEACONS, &sc->sc_flags);
-	} else {
-		/*
-		 * Take care of multiple interfaces when
-		 * enabling/disabling SWBA.
-		 */
-		if (changed & BSS_CHANGED_BEACON_ENABLED) {
-			if (!bss_conf->enable_beacon &&
-			    (sc->nbcnvifs <= 1)) {
-				cur_conf->enable_beacon = false;
-			} else if (bss_conf->enable_beacon) {
-				cur_conf->enable_beacon = true;
-				ath9k_cache_beacon_config(sc, bss_conf);
-			}
+		return;
+
+	}
+
+	/*
+	 * Take care of multiple interfaces when
+	 * enabling/disabling SWBA.
+	 */
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		if (!bss_conf->enable_beacon &&
+		    (sc->nbcnvifs <= 1)) {
+			cur_conf->enable_beacon = false;
+		} else if (bss_conf->enable_beacon) {
+			cur_conf->enable_beacon = true;
+			ath9k_cache_beacon_config(sc, bss_conf);
 		}
+	}
 
-		if (cur_conf->beacon_interval) {
+	/*
+	 * Configure the HW beacon registers only when we have a valid
+	 * beacon interval.
+	 */
+	if (cur_conf->beacon_interval) {
+		/*
+		 * If we are joining an existing IBSS network, start beaconing
+		 * only after a TSF-sync has taken place. Ensure that this
+		 * happens by setting the appropriate flags.
+		 */
+		if ((changed & BSS_CHANGED_IBSS) && !bss_conf->ibss_creator &&
+		    bss_conf->enable_beacon) {
+			spin_lock_irqsave(&sc->sc_pm_lock, flags);
+			sc->ps_flags |= PS_BEACON_SYNC | PS_WAIT_FOR_BEACON;
+			spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
+			skip_beacon = true;
+		} else {
 			ath9k_set_beacon(sc);
-
-			if (cur_conf->enable_beacon)
-				set_bit(SC_OP_BEACONS, &sc->sc_flags);
-			else
-				clear_bit(SC_OP_BEACONS, &sc->sc_flags);
 		}
+
+		/*
+		 * Do not set the SC_OP_BEACONS flag for IBSS joiner mode
+		 * here, it is done in ath9k_beacon_config_adhoc().
+		 */
+		if (cur_conf->enable_beacon && !skip_beacon)
+			set_bit(SC_OP_BEACONS, &sc->sc_flags);
+		else
+			clear_bit(SC_OP_BEACONS, &sc->sc_flags);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 2d0fd17..ee156e5 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -533,7 +533,7 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 	if (sc->ps_flags & PS_BEACON_SYNC) {
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
-			"Reconfigure Beacon timers based on timestamp from the AP\n");
+			"Reconfigure beacon timers based on synchronized timestamp\n");
 		ath9k_set_beacon(sc);
 	}
 
-- 
1.8.1.2

