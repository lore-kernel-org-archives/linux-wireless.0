Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39604 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYIQErN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 00:47:13 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18640.35669.341533.891954@gargle.gargle.HOWL> (sfid-20080917_064717_091229_8960DF44)
Date: Wed, 17 Sep 2008 10:15:09 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/3] ath9k: Whitespace cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, remove comments that are not relevant anymore.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |  136 +++++++++++++++-------------------
 1 files changed, 60 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index c43fd58..f8d952c 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -26,7 +26,6 @@
  *  the operating mode of the station (AP or AdHoc).  Parameters are AIFS
  *  settings and channel width min/max
 */
-
 static int ath_beaconq_config(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -63,19 +62,18 @@ static int ath_beaconq_config(struct ath_softc *sc)
  *  up all required antenna switch parameters, rate codes, and channel flags.
  *  Beacons are always sent out at the lowest rate, and are not retried.
 */
-
 static void ath_beacon_setup(struct ath_softc *sc,
-	struct ath_vap *avp, struct ath_buf *bf)
+			     struct ath_vap *avp, struct ath_buf *bf)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_desc *ds;
-	int flags, antenna;
+	struct ath9k_11n_rate_series series[4];
 	const struct ath9k_rate_table *rt;
+	int flags, antenna;
 	u8 rix, rate;
 	int ctsrate = 0;
 	int ctsduration = 0;
-	struct ath9k_11n_rate_series  series[4];
 
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: m %p len %u\n",
 		__func__, skb, skb->len);
@@ -115,20 +113,21 @@ static void ath_beacon_setup(struct ath_softc *sc,
 		rate |= rt->info[rix].shortPreamble;
 
 	ath9k_hw_set11n_txdesc(ah, ds,
-			       skb->len + FCS_LEN, /* frame length */
-			       ATH9K_PKT_TYPE_BEACON, /* Atheros packet type */
+			       skb->len + FCS_LEN,     /* frame length */
+			       ATH9K_PKT_TYPE_BEACON,  /* Atheros packet type */
 			       avp->av_btxctl.txpower, /* txpower XXX */
-			       ATH9K_TXKEYIX_INVALID, /* no encryption */
-			       ATH9K_KEY_TYPE_CLEAR, /* no encryption */
-			       flags /* no ack, veol for beacons */
+			       ATH9K_TXKEYIX_INVALID,  /* no encryption */
+			       ATH9K_KEY_TYPE_CLEAR,   /* no encryption */
+			       flags                   /* no ack,
+							  veol for beacons */
 		);
 
 	/* NB: beacon's BufLen must be a multiple of 4 bytes */
 	ath9k_hw_filltxdesc(ah, ds,
 			    roundup(skb->len, 4), /* buffer length */
-			    true, /* first segment */
-			    true, /* last segment */
-			    ds /* first descriptor */
+			    true,                 /* first segment */
+			    true,                 /* last segment */
+			    ds                    /* first descriptor */
 		);
 
 	memzero(series, sizeof(struct ath9k_11n_rate_series) * 4);
@@ -153,22 +152,23 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	struct ath_buf *bf;
 	struct ath_vap *avp;
 	struct sk_buff *skb;
-	int cabq_depth;
 	struct ath_txq *cabq;
 	struct ieee80211_tx_info *info;
+	int cabq_depth;
+
 	avp = sc->sc_vaps[if_id];
+	ASSERT(avp);
 
 	cabq = sc->sc_cabq;
 
-	ASSERT(avp);
-
 	if (avp->av_bcbuf == NULL) {
 		DPRINTF(sc, ATH_DBG_BEACON, "%s: avp=%p av_bcbuf=%p\n",
 			__func__, avp, avp->av_bcbuf);
 		return NULL;
 	}
+
 	bf = avp->av_bcbuf;
-	skb = (struct sk_buff *) bf->bf_mpdu;
+	skb = (struct sk_buff *)bf->bf_mpdu;
 	if (skb) {
 		pci_unmap_single(sc->pdev, bf->bf_dmacontext,
 				 skb_end_pointer(skb) - skb->head,
@@ -179,17 +179,19 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
 		return NULL;
+
 	info = IEEE80211_SKB_CB(skb);
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		/*
 		 * TODO: make sure the seq# gets assigned properly (vs. other
 		 * TX frames)
 		 */
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 		sc->seq_no += 0x10;
 		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 		hdr->seq_ctrl |= cpu_to_le16(sc->seq_no);
 	}
+
 	bf->bf_buf_addr = bf->bf_dmacontext =
 		pci_map_single(sc->pdev, skb->data,
 			       skb_end_pointer(skb) - skb->head,
@@ -241,7 +243,6 @@ static struct ath_buf *ath_beacon_generate(struct ath_softc *sc, int if_id)
  * Startup beacon transmission for adhoc mode when they are sent entirely
  * by the hardware using the self-linked descriptor + veol trick.
 */
-
 static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -278,7 +279,6 @@ static void ath_beacon_start_adhoc(struct ath_softc *sc, int if_id)
  *  min/max, and enable aifs). The info structure does not need to be
  *  persistant.
 */
-
 int ath_beaconq_setup(struct ath_hal *ah)
 {
 	struct ath9k_tx_queue_info qi;
@@ -299,11 +299,10 @@ int ath_beaconq_setup(struct ath_hal *ah)
  *  the ATH interface.  This routine also calculates the beacon "slot" for
  *  staggared beacons in the mBSSID case.
 */
-
 int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 {
 	struct ath_vap *avp;
-	struct ieee80211_hdr *wh;
+	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
 
@@ -312,13 +311,11 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 
 	/* Allocate a beacon descriptor if we haven't done so. */
 	if (!avp->av_bcbuf) {
-		/*
-		 * Allocate beacon state for hostap/ibss.  We know
-		 * a buffer is available.
-		 */
+		/* Allocate beacon state for hostap/ibss.  We know
+		 * a buffer is available. */
 
 		avp->av_bcbuf = list_first_entry(&sc->sc_bbuf,
-				struct ath_buf, list);
+						 struct ath_buf, list);
 		list_del(&avp->av_bcbuf->list);
 
 		if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP ||
@@ -362,9 +359,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	}
 
 	/*
-	 * NB: the beacon data buffer must be 32-bit aligned;
-	 * we assume the wbuf routines will return us something
-	 * with this alignment (perhaps should assert).
+	 * NB: the beacon data buffer must be 32-bit aligned.
 	 * FIXME: Fill avp->av_btxctl.txpower and
 	 * avp->av_btxctl.shortPreamble
 	 */
@@ -408,8 +403,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 			__func__, "stagger",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
-		wh = (struct ieee80211_hdr *)skb->data;
-		memcpy(&wh[1], &val, sizeof(val));
+		hdr = (struct ieee80211_hdr *)skb->data;
+		memcpy(&hdr[1], &val, sizeof(val));
 	}
 
 	bf->bf_buf_addr = bf->bf_dmacontext =
@@ -425,9 +420,8 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
  *  Reclaim beacon resources and return buffer to the pool.
  *
  *  Checks the VAP to put the beacon frame buffer back to the ATH object
- *  queue, and de-allocates any wbuf frames that were sent as CAB traffic.
+ *  queue, and de-allocates any skbs that were sent as CAB traffic.
 */
-
 void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
 {
 	if (avp->av_bcbuf != NULL) {
@@ -459,10 +453,7 @@ void ath_beacon_return(struct ath_softc *sc, struct ath_vap *avp)
  * Transmit one or more beacon frames at SWBA.  Dynamic updates to the frame
  * contents are done as needed and the slot time is also adjusted based on
  * current state.
- *
- * This tasklet is not scheduled, it's called in ISR context.
 */
-
 void ath9k_beacon_tasklet(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
@@ -490,6 +481,8 @@ void ath9k_beacon_tasklet(unsigned long data)
 	 * and wait for the next.  Missed beacons indicate
 	 * a problem and should not occur.  If we miss too
 	 * many consecutive beacons reset the device.
+	 *
+	 * FIXME: Clean up this mess !!
 	 */
 	if (ath9k_hw_numtxpending(ah, sc->sc_bhalq) != 0) {
 		sc->sc_bmisscount++;
@@ -505,19 +498,16 @@ void ath9k_beacon_tasklet(unsigned long data)
 					__func__, sc->sc_bmisscount);
 				if (show_cycles) {
 					/*
-					 * Display cycle counter stats
-					 * from HW to aide in debug of
-					 * stickiness.
+					 * Display cycle counter stats from HW
+					 * to aide in debug of stickiness.
 					 */
-					DPRINTF(sc,
-						ATH_DBG_BEACON,
+					DPRINTF(sc, ATH_DBG_BEACON,
 						"%s: busy times: rx_clear=%d, "
 						"rx_frame=%d, tx_frame=%d\n",
 						__func__, rx_clear, rx_frame,
 						tx_frame);
 				} else {
-					DPRINTF(sc,
-						ATH_DBG_BEACON,
+					DPRINTF(sc, ATH_DBG_BEACON,
 						"%s: unable to obtain "
 						"busy times\n", __func__);
 				}
@@ -529,8 +519,7 @@ void ath9k_beacon_tasklet(unsigned long data)
 		} else if (sc->sc_bmisscount >= BSTUCK_THRESH) {
 			if (sc->sc_flags & SC_OP_NO_RESET) {
 				if (sc->sc_bmisscount == BSTUCK_THRESH) {
-					DPRINTF(sc,
-						ATH_DBG_BEACON,
+					DPRINTF(sc, ATH_DBG_BEACON,
 						"%s: beacon is officially "
 						"stuck\n", __func__);
 					ath9k_hw_dmaRegDump(ah);
@@ -542,13 +531,12 @@ void ath9k_beacon_tasklet(unsigned long data)
 				ath_bstuck_process(sc);
 			}
 		}
-
 		return;
 	}
+
 	if (sc->sc_bmisscount != 0) {
 		if (sc->sc_flags & SC_OP_NO_RESET) {
-			DPRINTF(sc,
-				ATH_DBG_BEACON,
+			DPRINTF(sc, ATH_DBG_BEACON,
 				"%s: resume beacon xmit after %u misses\n",
 				__func__, sc->sc_bmisscount);
 		} else {
@@ -572,10 +560,12 @@ void ath9k_beacon_tasklet(unsigned long data)
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
 	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
 	if_id = sc->sc_bslot[(slot + 1) % ATH_BCBUF];
+
 	DPRINTF(sc, ATH_DBG_BEACON,
-			"%s: slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
-			__func__, slot, (unsigned long long) tsf, tsftu,
-			intval, if_id);
+		"%s: slot %d [tsf %llu tsftu %u intval %u] if_id %d\n",
+		__func__, slot, (unsigned long long)tsf, tsftu,
+		intval, if_id);
+
 	bfaddr = 0;
 	if (if_id != ATH_IF_ID_ANY) {
 		bf = ath_beacon_generate(sc, if_id);
@@ -632,9 +622,8 @@ void ath9k_beacon_tasklet(unsigned long data)
  *  Tasklet for Beacon Stuck processing
  *
  *  Processing for Beacon Stuck.
- *  Basically calls the ath_internal_reset function to reset the chip.
+ *  Basically resets the chip.
 */
-
 void ath_bstuck_process(struct ath_softc *sc)
 {
 	DPRINTF(sc, ATH_DBG_BEACON,
@@ -658,13 +647,12 @@ void ath_bstuck_process(struct ath_softc *sc)
  * interrupt when we stop seeing beacons from the AP
  * we've associated with.
  */
-
 void ath_beacon_config(struct ath_softc *sc, int if_id)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u32 nexttbtt, intval;
 	struct ath_beacon_config conf;
 	enum ath9k_opmode av_opmode;
+	u32 nexttbtt, intval;
 
 	if (if_id != ATH_IF_ID_ANY)
 		av_opmode = sc->sc_vaps[if_id]->av_opmode;
@@ -673,12 +661,6 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 
 	memzero(&conf, sizeof(struct ath_beacon_config));
 
-	/* FIXME: Use default values for now - Sujith */
-	/* Query beacon configuration first */
-	/*
-	 * Protocol stack doesn't support dynamic beacon configuration,
-	 * use default configurations.
-	 */
 	conf.beacon_interval = sc->hw->conf.beacon_int ?
 		sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
 	conf.listen_interval = 1;
@@ -704,12 +686,14 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		intval = conf.beacon_interval & ATH9K_BEACON_PERIOD;
 	}
 
-	if (nexttbtt == 0)      /* e.g. for ap mode */
+	if (nexttbtt == 0)	/* e.g. for ap mode */
 		nexttbtt = intval;
-	else if (intval)        /* NB: can be 0 for monitor mode */
+	else if (intval)	/* NB: can be 0 for monitor mode */
 		nexttbtt = roundup(nexttbtt, intval);
+
 	DPRINTF(sc, ATH_DBG_BEACON, "%s: nexttbtt %u intval %u (%u)\n",
 		__func__, nexttbtt, intval, conf.beacon_interval);
+
 	/* Check for ATH9K_M_HOSTAP and sc_nostabeacons for WDS client */
 	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
 		struct ath9k_beacon_state bs;
@@ -723,19 +707,19 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * last beacon we received (which may be none).
 		 */
 		dtimperiod = conf.dtim_period;
-		if (dtimperiod <= 0)        /* NB: 0 if not known */
+		if (dtimperiod <= 0)		/* NB: 0 if not known */
 			dtimperiod = 1;
 		dtimcount = conf.dtim_count;
-		if (dtimcount >= dtimperiod)    /* NB: sanity check */
-			dtimcount = 0;      /* XXX? */
-		cfpperiod = 1;          /* NB: no PCF support yet */
+		if (dtimcount >= dtimperiod)	/* NB: sanity check */
+			dtimcount = 0;
+		cfpperiod = 1;			/* NB: no PCF support yet */
 		cfpcount = 0;
 
 		sleepduration = conf.listen_interval * intval;
 		if (sleepduration <= 0)
 			sleepduration = intval;
 
-#define FUDGE   2
+#define FUDGE 2
 		/*
 		 * Pull nexttbtt forward to reflect the current
 		 * TSF and calculate dtim+cfp state for the result.
@@ -759,6 +743,7 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		bs.bs_cfpperiod = cfpperiod*bs.bs_dtimperiod;
 		bs.bs_cfpnext = bs.bs_nextdtim + cfpcount*bs.bs_dtimperiod;
 		bs.bs_cfpmaxduration = 0;
+
 		/*
 		 * Calculate the number of consecutive beacons to miss
 		 * before taking a BMISS interrupt.  The configuration
@@ -767,9 +752,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * result to at most 15 beacons.
 		 */
 		if (sleepduration > intval) {
-			bs.bs_bmissthreshold =
-				conf.listen_interval *
-					ATH_DEFAULT_BMISS_LIMIT / 2;
+			bs.bs_bmissthreshold = conf.listen_interval *
+				ATH_DEFAULT_BMISS_LIMIT / 2;
 		} else {
 			bs.bs_bmissthreshold =
 				DIV_ROUND_UP(conf.bmiss_timeout, intval);
@@ -789,8 +773,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		 * XXX fixed at 100ms
 		 */
 
-		bs.bs_sleepduration =
-			roundup(IEEE80211_MS_TO_TU(100), sleepduration);
+		bs.bs_sleepduration = roundup(IEEE80211_MS_TO_TU(100),
+					      sleepduration);
 		if (bs.bs_sleepduration > bs.bs_dtimperiod)
 			bs.bs_sleepduration = bs.bs_dtimperiod;
 
@@ -834,9 +818,9 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 		if (sc->sc_ah->ah_opmode == ATH9K_M_IBSS) {
 			/*
 			 * Pull nexttbtt forward to reflect the current
-			 * TSF .
+			 * TSF
 			 */
-#define FUDGE   2
+#define FUDGE 2
 			if (!(intval & ATH9K_BEACON_RESET_TSF)) {
 				tsf = ath9k_hw_gettsf64(ah);
 				tsftu = TSF_TO_TU((u32)(tsf>>32),
-- 
1.6.0.2

