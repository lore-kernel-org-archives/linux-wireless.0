Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47189 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbZCLTxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 15:53:36 -0400
Date: Thu, 12 Mar 2009 21:53:23 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add support for multiple virtual AP interfaces
Message-ID: <20090312195323.GA2120@jm.kir.nu> (sfid-20090312_205340_028197_5EB1094F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the TSF offset calculation for staggered Beacon frames
and sets ATH_BCBUF back to the earlier value 4 to enable multi-BSS
configurations of up to four BSSes.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/ath9k.h  |    3 +-
 drivers/net/wireless/ath9k/beacon.c |   50 ++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/ath9k.h	2009-03-12 21:48:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/ath9k.h	2009-03-12 21:49:47.000000000 +0200
@@ -390,6 +390,7 @@ void ath_tx_aggr_resume(struct ath_softc
 
 struct ath_vif {
 	int av_bslot;
+	__le64 tsf_adjust; /* TSF adjustment for staggered beacons */
 	enum nl80211_iftype av_opmode;
 	struct ath_buf *av_bcbuf;
 	struct ath_tx_control av_btxctl;
@@ -406,7 +407,7 @@ struct ath_vif {
  * number of beacon intervals, the game's up.
  */
 #define BSTUCK_THRESH           	(9 * ATH_BCBUF)
-#define	ATH_BCBUF               	1
+#define	ATH_BCBUF               	4
 #define ATH_DEFAULT_BINTVAL     	100 /* TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
--- wireless-testing.orig/drivers/net/wireless/ath9k/beacon.c	2009-03-12 21:48:52.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/beacon.c	2009-03-12 21:49:55.000000000 +0200
@@ -153,6 +153,8 @@ static struct ath_buf *ath_beacon_genera
 	bf->bf_mpdu = skb;
 	if (skb == NULL)
 		return NULL;
+	((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
+		avp->tsf_adjust;
 
 	info = IEEE80211_SKB_CB(skb);
 	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
@@ -253,7 +255,6 @@ int ath_beacon_alloc(struct ath_wiphy *a
 {
 	struct ath_softc *sc = aphy->sc;
 	struct ath_vif *avp;
-	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
 	__le64 tstamp;
@@ -316,42 +317,33 @@ int ath_beacon_alloc(struct ath_wiphy *a
 
 	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	sc->beacon.bc_tstamp = le64_to_cpu(tstamp);
-
-	/*
-	 * Calculate a TSF adjustment factor required for
-	 * staggered beacons.  Note that we assume the format
-	 * of the beacon frame leaves the tstamp field immediately
-	 * following the header.
-	 */
+	/* Calculate a TSF adjustment factor required for staggered beacons. */
 	if (avp->av_bslot > 0) {
 		u64 tsfadjust;
-		__le64 val;
 		int intval;
 
 		intval = sc->hw->conf.beacon_int ?
 			sc->hw->conf.beacon_int : ATH_DEFAULT_BINTVAL;
 
 		/*
-		 * The beacon interval is in TU's; the TSF in usecs.
-		 * We figure out how many TU's to add to align the
-		 * timestamp then convert to TSF units and handle
-		 * byte swapping before writing it in the frame.
-		 * The hardware will then add this each time a beacon
-		 * frame is sent.  Note that we align vif's 1..N
-		 * and leave vif 0 untouched.  This means vap 0
-		 * has a timestamp in one beacon interval while the
-		 * others get a timestamp aligned to the next interval.
+		 * Calculate the TSF offset for this beacon slot, i.e., the
+		 * number of usecs that need to be added to the timestamp field
+		 * in Beacon and Probe Response frames. Beacon slot 0 is
+		 * processed at the correct offset, so it does not require TSF
+		 * adjustment. Other slots are adjusted to get the timestamp
+		 * close to the TBTT for the BSS.
 		 */
-		tsfadjust = (intval * (ATH_BCBUF - avp->av_bslot)) / ATH_BCBUF;
-		val = cpu_to_le64(tsfadjust << 10);     /* TU->TSF */
+		tsfadjust = intval * avp->av_bslot / ATH_BCBUF;
+		avp->tsf_adjust = cpu_to_le64(TU_TO_USEC(tsfadjust));
 
 		DPRINTF(sc, ATH_DBG_BEACON,
 			"stagger beacons, bslot %d intval %u tsfadjust %llu\n",
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
-		hdr = (struct ieee80211_hdr *)skb->data;
-		memcpy(&hdr[1], &val, sizeof(val));
-	}
+		((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp =
+			avp->tsf_adjust;
+	} else
+		avp->tsf_adjust = cpu_to_le64(0);
 
 	bf->bf_mpdu = skb;
 	bf->bf_buf_addr = bf->bf_dmacontext =
@@ -447,8 +439,16 @@ void ath_beacon_tasklet(unsigned long da
 	tsf = ath9k_hw_gettsf64(ah);
 	tsftu = TSF_TO_TU(tsf>>32, tsf);
 	slot = ((tsftu % intval) * ATH_BCBUF) / intval;
-	vif = sc->beacon.bslot[(slot + 1) % ATH_BCBUF];
-	aphy = sc->beacon.bslot_aphy[(slot + 1) % ATH_BCBUF];
+	/*
+	 * Reverse the slot order to get slot 0 on the TBTT offset that does
+	 * not require TSF adjustment and other slots adding
+	 * slot/ATH_BCBUF * beacon_int to timestamp. For example, with
+	 * ATH_BCBUF = 4, we process beacon slots as follows: 3 2 1 0 3 2 1 ..
+	 * and slot 0 is at correct offset to TBTT.
+	 */
+	slot = ATH_BCBUF - slot - 1;
+	vif = sc->beacon.bslot[slot];
+	aphy = sc->beacon.bslot_aphy[slot];
 
 	DPRINTF(sc, ATH_DBG_BEACON,
 		"slot %d [tsf %llu tsftu %u intval %u] vif %p\n",

-- 
Jouni Malinen                                            PGP id EFC895FA
