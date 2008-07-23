Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:41241 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYGWQza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 12:55:30 -0400
Date: Wed, 23 Jul 2008 18:55:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: [PATCH] ath9: endianess fixes
Message-ID: <20080723165518.GB30144@lst.de> (sfid-20080723_185533_629927_2AF08066)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 - in ath_beacon_alloc use a __le64 variable to store a byte swapped
   result.  Keep printing the unshifted native variable.
 - in ath_bar_rx add a missing le16_to_cpu for bar->control
 - in ath_rx_tasklet add a missing cpu_to_be16 for skb->protocol


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/net/wireless/ath9k/beacon.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath9k/beacon.c	2008-07-23 18:47:37.000000000 +0200
+++ linux-2.6/drivers/net/wireless/ath9k/beacon.c	2008-07-23 18:48:46.000000000 +0200
@@ -440,6 +440,7 @@ int ath_beacon_alloc(struct ath_softc *s
 	 */
 	if (sc->sc_stagbeacons && avp->av_bslot > 0) {
 		u_int64_t tsfadjust;
+		__le64 val;
 		int intval;
 
 		/* FIXME: Use default value for now: Sujith */
@@ -458,7 +459,7 @@ int ath_beacon_alloc(struct ath_softc *s
 		 * others get a timestamp aligned to the next interval.
 		 */
 		tsfadjust = (intval * (ATH_BCBUF - avp->av_bslot)) / ATH_BCBUF;
-		tsfadjust = cpu_to_le64(tsfadjust<<10);     /* TU->TSF */
+		val = cpu_to_le64(tsfadjust << 10);     /* TU->TSF */
 
 		DPRINTF(sc, ATH_DEBUG_BEACON,
 			"%s: %s beacons, bslot %d intval %u tsfadjust %llu\n",
@@ -466,7 +467,7 @@ int ath_beacon_alloc(struct ath_softc *s
 			avp->av_bslot, intval, (unsigned long long)tsfadjust);
 
 		wh = (struct ieee80211_hdr *)skb->data;
-		memcpy(&wh[1], &tsfadjust, sizeof(tsfadjust));
+		memcpy(&wh[1], &val, sizeof(val));
 	}
 
 	bf->bf_buf_addr = ath_skb_map_single(sc, skb, PCI_DMA_TODEVICE,
Index: linux-2.6/drivers/net/wireless/ath9k/recv.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/ath9k/recv.c	2008-07-23 18:49:53.000000000 +0200
+++ linux-2.6/drivers/net/wireless/ath9k/recv.c	2008-07-23 18:51:45.000000000 +0200
@@ -80,7 +80,7 @@ static int ath_bar_rx(struct ath_softc *
 	/* look at BAR contents	 */
 
 	bar = (struct ieee80211_bar *)skb->data;
-	tidno = (bar->control & IEEE80211_BAR_CTL_TID_M)
+	tidno = (le16_to_cpu(bar->control) & IEEE80211_BAR_CTL_TID_M)
 		>> IEEE80211_BAR_CTL_TID_S;
 	seqno = le16_to_cpu(bar->start_seq_num) >> IEEE80211_SEQ_SEQ_SHIFT;
 
@@ -1026,7 +1026,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		 * to receive another frame.
 		 */
 		skb_put(skb, ds->ds_rxstat.rs_datalen);
-		skb->protocol = ETH_P_CONTROL;
+		skb->protocol = cpu_to_be16(ETH_P_CONTROL);
 		rx_status.tsf = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
 		rx_status.rateieee =
 			sc->sc_hwmap[ds->ds_rxstat.rs_rate].ieeerate;
