Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40016 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbZCCEuw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:50:52 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 20:50:51 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.46654.958938.298625@gargle.gargle.HOWL> (sfid-20090303_055112_660451_0413869E)
Date: Tue, 3 Mar 2009 10:16:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 4/7] ath9k: Split beacon configuration into mode specific routines
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the code easier to understand.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h  |    1 -
 drivers/net/wireless/ath9k/beacon.c |  406 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/main.c   |    3 +-
 3 files changed, 203 insertions(+), 207 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 497e6f3..733108c 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -458,7 +458,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id);
 int ath_beaconq_setup(struct ath_hw *ah);
 int ath_beacon_alloc(struct ath_softc *sc, int if_id);
 void ath_beacon_return(struct ath_softc *sc, struct ath_vif *avp);
-void ath_beacon_sync(struct ath_softc *sc, int if_id);
 
 /*******/
 /* ANI */
diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index 349904c..7491643 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -16,6 +16,8 @@
 
 #include "ath9k.h"
 
+#define FUDGE 2
+
 /*
  *  This function will modify certain transmit queue properties depending on
  *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
@@ -498,235 +500,231 @@ void ath_beacon_tasklet(unsigned long data)
 }
 
 /*
- * Configure the beacon and sleep timers.
- *
- * When operating as an AP this resets the TSF and sets
- * up the hardware to notify us when we need to issue beacons.
- *
- * When operating in station mode this sets up the beacon
- * timers according to the timestamp of the last received
- * beacon and the current TSF, configures PCF and DTIM
- * handling, programs the sleep registers so the hardware
- * will wakeup in time to receive beacons, and configures
- * the beacon miss handling so we'll receive a BMISS
- * interrupt when we stop seeing beacons from the AP
- * we've associated with.
+ * For multi-bss ap support beacons are either staggered evenly over N slots or
+ * burst together.  For the former arrange for the SWBA to be delivered for each
+ * slot. Slots that are not occupied will generate nothing.
  */
-void ath_beacon_config(struct ath_softc *sc, int if_id)
+static void ath_beacon_config_ap(struct ath_softc *sc,
+				 struct ath_beacon_config *conf,
+				 struct ath_vif *avp)
 {
-	struct ieee80211_vif *vif;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_beacon_config conf;
-	struct ath_vif *avp;
-	enum nl80211_iftype opmode;
 	u32 nexttbtt, intval;
 
-	if (if_id != ATH_IF_ID_ANY) {
-		vif = sc->vifs[if_id];
-		avp = (void *)vif->drv_priv;
-		opmode = avp->av_opmode;
-	} else {
-		opmode = sc->sc_ah->opmode;
-	}
+	/* NB: the beacon interval is kept internally in TU's */
+	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
+	intval /= ATH_BCBUF;    /* for staggered beacons */
+	nexttbtt = intval;
+	intval |= ATH9K_BEACON_RESET_TSF;
 
-	memset(&conf, 0, sizeof(struct ath_beacon_config));
+	/*
+	 * In AP mode we enable the beacon timers and SWBA interrupts to
+	 * prepare beacon frames.
+	 */
+	intval |= ATH9K_BEACON_ENA;
+	sc->imask |= ATH9K_INT_SWBA;
+	ath_beaconq_config(sc);
 
-	conf.beacon_interval = sc->hw->conf.beacon_int ?
-		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
-	conf.listen_interval = 1;
-	conf.dtim_period = conf.beacon_interval;
-	conf.dtim_count = 1;
-	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
+	/* Set the computed AP beacon timers */
 
-	/* extract tstamp from last beacon and convert to TU */
-	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
+	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_beaconinit(sc->sc_ah, nexttbtt, intval);
+	sc->beacon.bmisscnt = 0;
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+}
 
-	/* XXX conditionalize multi-bss support? */
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
-		/*
-		 * For multi-bss ap support beacons are either staggered
-		 * evenly over N slots or burst together.  For the former
-		 * arrange for the SWBA to be delivered for each slot.
-		 * Slots that are not occupied will generate nothing.
-		 */
-		/* NB: the beacon interval is kept internally in TU's */
-		intval = conf.beacon_interval & ATH9K_BEACON_PERIOD;
-		intval /= ATH_BCBUF;    /* for staggered beacons */
+/*
+ * This sets up the beacon timers according to the timestamp of the last
+ * received beacon and the current TSF, configures PCF and DTIM
+ * handling, programs the sleep registers so the hardware will wakeup in
+ * time to receive beacons, and configures the beacon miss handling so
+ * we'll receive a BMISS interrupt when we stop seeing beacons from the AP
+ * we've associated with.
+ */
+static void ath_beacon_config_sta(struct ath_softc *sc,
+				  struct ath_beacon_config *conf,
+				  struct ath_vif *avp)
+{
+	struct ath9k_beacon_state bs;
+	int dtimperiod, dtimcount, sleepduration;
+	int cfpperiod, cfpcount;
+	u32 nexttbtt = 0, intval, tsftu;
+	u64 tsf;
+
+	memset(&bs, 0, sizeof(bs));
+	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
+
+	/*
+	 * Setup dtim and cfp parameters according to
+	 * last beacon we received (which may be none).
+	 */
+	dtimperiod = conf->dtim_period;
+	if (dtimperiod <= 0)		/* NB: 0 if not known */
+		dtimperiod = 1;
+	dtimcount = conf->dtim_count;
+	if (dtimcount >= dtimperiod)	/* NB: sanity check */
+		dtimcount = 0;
+	cfpperiod = 1;			/* NB: no PCF support yet */
+	cfpcount = 0;
+
+	sleepduration = conf->listen_interval * intval;
+	if (sleepduration <= 0)
+		sleepduration = intval;
+
+	/*
+	 * Pull nexttbtt forward to reflect the current
+	 * TSF and calculate dtim+cfp state for the result.
+	 */
+	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
+	do {
+		nexttbtt += intval;
+		if (--dtimcount < 0) {
+			dtimcount = dtimperiod - 1;
+			if (--cfpcount < 0)
+				cfpcount = cfpperiod - 1;
+		}
+	} while (nexttbtt < tsftu);
+
+	bs.bs_intval = intval;
+	bs.bs_nexttbtt = nexttbtt;
+	bs.bs_dtimperiod = dtimperiod*intval;
+	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount*intval;
+	bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
+	bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
+	bs.bs_cfpmaxduration = 0;
+
+	/*
+	 * Calculate the number of consecutive beacons to miss* before taking
+	 * a BMISS interrupt. The configuration is specified in TU so we only
+	 * need calculate based	on the beacon interval.  Note that we clamp the
+	 * result to at most 15 beacons.
+	 */
+	if (sleepduration > intval) {
+		bs.bs_bmissthreshold = conf->listen_interval *
+			ATH_DEFAULT_BMISS_LIMIT / 2;
 	} else {
-		intval = conf.beacon_interval & ATH9K_BEACON_PERIOD;
+		bs.bs_bmissthreshold = DIV_ROUND_UP(conf->bmiss_timeout, intval);
+		if (bs.bs_bmissthreshold > 15)
+			bs.bs_bmissthreshold = 15;
+		else if (bs.bs_bmissthreshold <= 0)
+			bs.bs_bmissthreshold = 1;
 	}
 
-	if (nexttbtt == 0)	/* e.g. for ap mode */
-		nexttbtt = intval;
-	else if (intval)	/* NB: can be 0 for monitor mode */
-		nexttbtt = roundup(nexttbtt, intval);
+	/*
+	 * Calculate sleep duration. The configuration is given in ms.
+	 * We ensure a multiple of the beacon period is used. Also, if the sleep
+	 * duration is greater than the DTIM period then it makes senses
+	 * to make it a multiple of that.
+	 *
+	 * XXX fixed at 100ms
+	 */
 
-	DPRINTF(sc, ATH_DBG_BEACON, "nexttbtt %u intval %u (%u)\n",
-		nexttbtt, intval, conf.beacon_interval);
+	bs.bs_sleepduration = roundup(IEEE80211_MS_TO_TU(100), sleepduration);
+	if (bs.bs_sleepduration > bs.bs_dtimperiod)
+		bs.bs_sleepduration = bs.bs_dtimperiod;
 
-	/* Check for NL80211_IFTYPE_AP and sc_nostabeacons for WDS client */
-	if (sc->sc_ah->opmode == NL80211_IFTYPE_STATION) {
-		struct ath9k_beacon_state bs;
-		u64 tsf;
-		u32 tsftu;
-		int dtimperiod, dtimcount, sleepduration;
-		int cfpperiod, cfpcount;
+	/* TSF out of range threshold fixed at 1 second */
+	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
 
-		/*
-		 * Setup dtim and cfp parameters according to
-		 * last beacon we received (which may be none).
-		 */
-		dtimperiod = conf.dtim_period;
-		if (dtimperiod <= 0)		/* NB: 0 if not known */
-			dtimperiod = 1;
-		dtimcount = conf.dtim_count;
-		if (dtimcount >= dtimperiod)	/* NB: sanity check */
-			dtimcount = 0;
-		cfpperiod = 1;			/* NB: no PCF support yet */
-		cfpcount = 0;
-
-		sleepduration = conf.listen_interval * intval;
-		if (sleepduration <= 0)
-			sleepduration = intval;
+	DPRINTF(sc, ATH_DBG_BEACON, "tsf: %llu tsftu: %u\n", tsf, tsftu);
+	DPRINTF(sc, ATH_DBG_BEACON,
+		"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
+		bs.bs_bmissthreshold, bs.bs_sleepduration,
+		bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
 
-#define FUDGE 2
-		/*
-		 * Pull nexttbtt forward to reflect the current
-		 * TSF and calculate dtim+cfp state for the result.
-		 */
-		tsf = ath9k_hw_gettsf64(ah);
-		tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
-		do {
-			nexttbtt += intval;
-			if (--dtimcount < 0) {
-				dtimcount = dtimperiod - 1;
-				if (--cfpcount < 0)
-					cfpcount = cfpperiod - 1;
-			}
-		} while (nexttbtt < tsftu);
-#undef FUDGE
-		memset(&bs, 0, sizeof(bs));
-		bs.bs_intval = intval;
-		bs.bs_nexttbtt = nexttbtt;
-		bs.bs_dtimperiod = dtimperiod*intval;
-		bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount*intval;
-		bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
-		bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
-		bs.bs_cfpmaxduration = 0;
+	/* Set the computed STA beacon timers */
 
-		/*
-		 * Calculate the number of consecutive beacons to miss
-		 * before taking a BMISS interrupt.  The configuration
-		 * is specified in TU so we only need calculate based
-		 * on the beacon interval.  Note that we clamp the
-		 * result to at most 15 beacons.
-		 */
-		if (sleepduration > intval) {
-			bs.bs_bmissthreshold = conf.listen_interval *
-				ATH_DEFAULT_BMISS_LIMIT / 2;
-		} else {
-			bs.bs_bmissthreshold =
-				DIV_ROUND_UP(conf.bmiss_timeout, intval);
-			if (bs.bs_bmissthreshold > 15)
-				bs.bs_bmissthreshold = 15;
-			else if (bs.bs_bmissthreshold <= 0)
-				bs.bs_bmissthreshold = 1;
-		}
+	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_set_sta_beacon_timers(sc->sc_ah, &bs);
+	sc->imask |= ATH9K_INT_BMISS;
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+}
 
-		/*
-		 * Calculate sleep duration.  The configuration is
-		 * given in ms.  We insure a multiple of the beacon
-		 * period is used.  Also, if the sleep duration is
-		 * greater than the DTIM period then it makes senses
-		 * to make it a multiple of that.
-		 *
-		 * XXX fixed at 100ms
-		 */
+static void ath_beacon_config_adhoc(struct ath_softc *sc,
+				    struct ath_beacon_config *conf,
+				    struct ath_vif *avp)
+{
+	u64 tsf;
+	u32 tsftu, intval, nexttbtt;
 
-		bs.bs_sleepduration = roundup(IEEE80211_MS_TO_TU(100),
-					      sleepduration);
-		if (bs.bs_sleepduration > bs.bs_dtimperiod)
-			bs.bs_sleepduration = bs.bs_dtimperiod;
+	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 
-		/* TSF out of range threshold fixed at 1 second */
-		bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
+	/* Pull nexttbtt forward to reflect the current TSF */
 
-		DPRINTF(sc, ATH_DBG_BEACON,
-			"tsf: %llu tsftu: %u\n", tsf, tsftu);
-		DPRINTF(sc, ATH_DBG_BEACON,
-			"bmiss: %u sleep: %u cfp-period: %u maxdur: %u next: %u\n",
-			bs.bs_bmissthreshold, bs.bs_sleepduration,
-			bs.bs_cfpperiod, bs.bs_cfpmaxduration, bs.bs_cfpnext);
-
-		ath9k_hw_set_interrupts(ah, 0);
-		ath9k_hw_set_sta_beacon_timers(ah, &bs);
-		sc->imask |= ATH9K_INT_BMISS;
-		ath9k_hw_set_interrupts(ah, sc->imask);
-	} else {
-		u64 tsf;
-		u32 tsftu;
+	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);
+	if (nexttbtt == 0)
+                nexttbtt = intval;
+        else if (intval)
+                nexttbtt = roundup(nexttbtt, intval);
 
-		ath9k_hw_set_interrupts(ah, 0);
-		if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) {
-			/* Pull nexttbtt forward to reflect the current TSF */
-#define FUDGE 2
-			if (!(intval & ATH9K_BEACON_RESET_TSF)) {
-				tsf = ath9k_hw_gettsf64(ah);
-				tsftu = TSF_TO_TU((u32)(tsf>>32),
-						  (u32)tsf) + FUDGE;
-				do {
-					nexttbtt += intval;
-				} while (nexttbtt < tsftu);
-			}
-#undef FUDGE
-			DPRINTF(sc, ATH_DBG_BEACON,
-				"IBSS nexttbtt %u intval %u (%u)\n",
-				nexttbtt, intval & ~ATH9K_BEACON_RESET_TSF,
-				conf.beacon_interval);
+	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	tsftu = TSF_TO_TU((u32)(tsf>>32), (u32)tsf) + FUDGE;
+	do {
+		nexttbtt += intval;
+	} while (nexttbtt < tsftu);
 
-			/*
-			 * In IBSS mode enable the beacon timers but only
-			 * enable SWBA interrupts if we need to manually
-			 * prepare beacon frames.  Otherwise we use a
-			 * self-linked tx descriptor and let the hardware
-			 * deal with things.
-			 */
-			intval |= ATH9K_BEACON_ENA;
-			if (!(ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
-				sc->imask |= ATH9K_INT_SWBA;
-			ath_beaconq_config(sc);
-		} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
-			if (nexttbtt == intval)
-				intval |= ATH9K_BEACON_RESET_TSF;
-			/*
-			 * In AP mode we enable the beacon timers and
-			 * SWBA interrupts to prepare beacon frames.
-			 */
-			intval |= ATH9K_BEACON_ENA;
-			sc->imask |= ATH9K_INT_SWBA;
-			ath_beaconq_config(sc);
-		}
+	DPRINTF(sc, ATH_DBG_BEACON,
+		"IBSS nexttbtt %u intval %u (%u)\n",
+		nexttbtt, intval, conf->beacon_interval);
 
-		ath9k_hw_beaconinit(ah, nexttbtt, intval);
-		sc->beacon.bmisscnt = 0;
-		ath9k_hw_set_interrupts(ah, sc->imask);
+	/*
+	 * In IBSS mode enable the beacon timers but only enable SWBA interrupts
+	 * if we need to manually prepare beacon frames.  Otherwise we use a
+	 * self-linked tx descriptor and let the hardware deal with things.
+	 */
+	intval |= ATH9K_BEACON_ENA;
+	if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
+		sc->imask |= ATH9K_INT_SWBA;
 
-		/*
-		 * When using a self-linked beacon descriptor in
-		 * ibss mode load it once here.
-		 */
-		if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC &&
-		    (ah->caps.hw_caps & ATH9K_HW_CAP_VEOL))
-			ath_beacon_start_adhoc(sc, 0);
-	}
+	ath_beaconq_config(sc);
+
+	/* Set the computed ADHOC beacon timers */
+
+	ath9k_hw_set_interrupts(sc->sc_ah, 0);
+	ath9k_hw_beaconinit(sc->sc_ah, nexttbtt, intval);
+	sc->beacon.bmisscnt = 0;
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
+
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)
+		ath_beacon_start_adhoc(sc, 0);
 }
 
-void ath_beacon_sync(struct ath_softc *sc, int if_id)
+void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
-	/*
-	 * Resync beacon timers using the tsf of the
-	 * beacon frame we just received.
-	 */
-	ath_beacon_config(sc, if_id);
-	sc->sc_flags |= SC_OP_BEACONS;
+	struct ath_beacon_config conf;
+	struct ath_vif *avp;
+	struct ieee80211_vif *vif;
+
+	/* Setup the beacon configuration parameters */
+
+	memset(&conf, 0, sizeof(struct ath_beacon_config));
+	conf.beacon_interval = sc->hw->conf.beacon_int ?
+		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
+	conf.listen_interval = 1;
+	conf.dtim_period = conf.beacon_interval;
+	conf.dtim_count = 1;
+	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
+
+	if (if_id != ATH_IF_ID_ANY) {
+		vif = sc->vifs[if_id];
+		avp = (struct ath_vif *)vif->drv_priv;
+
+		switch(avp->av_opmode) {
+		case NL80211_IFTYPE_AP:
+			ath_beacon_config_ap(sc, &conf, avp);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ath_beacon_config_adhoc(sc, &conf, avp);
+			break;
+		case NL80211_IFTYPE_STATION:
+			ath_beacon_config_sta(sc, &conf, avp);
+			break;
+		default:
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"Unsupported beaconing mode\n");
+			return;
+		}
+
+		sc->sc_flags |= SC_OP_BEACONS;
+	}
 }
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 52d4f67..2ed6848 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -924,7 +924,6 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 
 		/* Configure the beacon */
 		ath_beacon_config(sc, 0);
-		sc->sc_flags |= SC_OP_BEACONS;
 
 		/* Reset rssi stats */
 		sc->nodestats.ns_avgbrssi = ATH_RSSI_DUMMY_MARKER;
@@ -2363,7 +2362,7 @@ static int ath9k_config_interface(struct ieee80211_hw *hw,
 			if (error != 0)
 				return error;
 
-			ath_beacon_sync(sc, 0);
+			ath_beacon_config(sc, 0);
 		}
 	}
 
-- 
1.6.1

