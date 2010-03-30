Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48944 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0C3DJc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 23:09:32 -0400
Message-ID: <4BB16B67.4020708@openwrt.org>
Date: Mon, 29 Mar 2010 20:09:27 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath9k: split out access to rx status information
References: <4BB16ADF.8090609@openwrt.org>
In-Reply-To: <4BB16ADF.8090609@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes in a pointer to the ath_rx_status data structure for
functions that need it, instead of letting them grab it directly from
the ath_desc struct. This is useful for making it possible to allocate
the intermediate rx status data separately.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -859,7 +859,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw
 EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			u32 pa, struct ath_desc *nds, u64 tsf)
+			struct ath_rx_status *rs, u64 tsf)
 {
 	struct ar5416_desc ads;
 	struct ar5416_desc *adsp = AR5416DESC(ds);
@@ -870,70 +870,70 @@ int ath9k_hw_rxprocdesc(struct ath_hw *a
 
 	ads.u.rx = adsp->u.rx;
 
-	ds->ds_rxstat.rs_status = 0;
-	ds->ds_rxstat.rs_flags = 0;
+	rs->rs_status = 0;
+	rs->rs_flags = 0;
 
-	ds->ds_rxstat.rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
-	ds->ds_rxstat.rs_tstamp = ads.AR_RcvTimestamp;
+	rs->rs_datalen = ads.ds_rxstatus1 & AR_DataLen;
+	rs->rs_tstamp = ads.AR_RcvTimestamp;
 
 	if (ads.ds_rxstatus8 & AR_PostDelimCRCErr) {
-		ds->ds_rxstat.rs_rssi = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ctl0 = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ctl1 = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ctl2 = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ext0 = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ext1 = ATH9K_RSSI_BAD;
-		ds->ds_rxstat.rs_rssi_ext2 = ATH9K_RSSI_BAD;
+		rs->rs_rssi = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl0 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl1 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ctl2 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext0 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext1 = ATH9K_RSSI_BAD;
+		rs->rs_rssi_ext2 = ATH9K_RSSI_BAD;
 	} else {
-		ds->ds_rxstat.rs_rssi = MS(ads.ds_rxstatus4, AR_RxRSSICombined);
-		ds->ds_rxstat.rs_rssi_ctl0 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi = MS(ads.ds_rxstatus4, AR_RxRSSICombined);
+		rs->rs_rssi_ctl0 = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt00);
-		ds->ds_rxstat.rs_rssi_ctl1 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi_ctl1 = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt01);
-		ds->ds_rxstat.rs_rssi_ctl2 = MS(ads.ds_rxstatus0,
+		rs->rs_rssi_ctl2 = MS(ads.ds_rxstatus0,
 						AR_RxRSSIAnt02);
-		ds->ds_rxstat.rs_rssi_ext0 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext0 = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt10);
-		ds->ds_rxstat.rs_rssi_ext1 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext1 = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt11);
-		ds->ds_rxstat.rs_rssi_ext2 = MS(ads.ds_rxstatus4,
+		rs->rs_rssi_ext2 = MS(ads.ds_rxstatus4,
 						AR_RxRSSIAnt12);
 	}
 	if (ads.ds_rxstatus8 & AR_RxKeyIdxValid)
-		ds->ds_rxstat.rs_keyix = MS(ads.ds_rxstatus8, AR_KeyIdx);
+		rs->rs_keyix = MS(ads.ds_rxstatus8, AR_KeyIdx);
 	else
-		ds->ds_rxstat.rs_keyix = ATH9K_RXKEYIX_INVALID;
+		rs->rs_keyix = ATH9K_RXKEYIX_INVALID;
 
-	ds->ds_rxstat.rs_rate = RXSTATUS_RATE(ah, (&ads));
-	ds->ds_rxstat.rs_more = (ads.ds_rxstatus1 & AR_RxMore) ? 1 : 0;
+	rs->rs_rate = RXSTATUS_RATE(ah, (&ads));
+	rs->rs_more = (ads.ds_rxstatus1 & AR_RxMore) ? 1 : 0;
 
-	ds->ds_rxstat.rs_isaggr = (ads.ds_rxstatus8 & AR_RxAggr) ? 1 : 0;
-	ds->ds_rxstat.rs_moreaggr =
+	rs->rs_isaggr = (ads.ds_rxstatus8 & AR_RxAggr) ? 1 : 0;
+	rs->rs_moreaggr =
 		(ads.ds_rxstatus8 & AR_RxMoreAggr) ? 1 : 0;
-	ds->ds_rxstat.rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
-	ds->ds_rxstat.rs_flags =
+	rs->rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
+	rs->rs_flags =
 		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
-	ds->ds_rxstat.rs_flags |=
+	rs->rs_flags |=
 		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
-		ds->ds_rxstat.rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
+		rs->rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
 	if (ads.ds_rxstatus8 & AR_PostDelimCRCErr)
-		ds->ds_rxstat.rs_flags |= ATH9K_RX_DELIM_CRC_POST;
+		rs->rs_flags |= ATH9K_RX_DELIM_CRC_POST;
 	if (ads.ds_rxstatus8 & AR_DecryptBusyErr)
-		ds->ds_rxstat.rs_flags |= ATH9K_RX_DECRYPT_BUSY;
+		rs->rs_flags |= ATH9K_RX_DECRYPT_BUSY;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
 		if (ads.ds_rxstatus8 & AR_CRCErr)
-			ds->ds_rxstat.rs_status |= ATH9K_RXERR_CRC;
+			rs->rs_status |= ATH9K_RXERR_CRC;
 		else if (ads.ds_rxstatus8 & AR_PHYErr) {
-			ds->ds_rxstat.rs_status |= ATH9K_RXERR_PHY;
+			rs->rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
-			ds->ds_rxstat.rs_phyerr = phyerr;
+			rs->rs_phyerr = phyerr;
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
-			ds->ds_rxstat.rs_status |= ATH9K_RXERR_DECRYPT;
+			rs->rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
-			ds->ds_rxstat.rs_status |= ATH9K_RXERR_MIC;
+			rs->rs_status |= ATH9K_RXERR_MIC;
 	}
 
 	return 0;
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -241,9 +241,6 @@ struct ath_desc {
 	void *ds_vdata;
 } __packed;
 
-#define	ds_rxstat	ds_us.rx
-#define ds_stat		ds_us.stats
-
 #define ATH9K_TXDESC_CLRDMASK		0x0001
 #define ATH9K_TXDESC_NOACK		0x0002
 #define ATH9K_TXDESC_RTSENA		0x0004
@@ -732,7 +729,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw 
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q);
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q);
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
-			u32 pa, struct ath_desc *nds, u64 tsf);
+			struct ath_rx_status *rs, u64 tsf);
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags);
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -506,6 +506,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 
 		bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
 		ds = bf->bf_desc;
+		rx_stats = &ds->ds_us.rx;
 
 		/*
 		 * Must provide the virtual address of the current
@@ -518,10 +519,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		 * on.  All this is necessary because of our use of
 		 * a self-linked list to avoid rx overruns.
 		 */
-		retval = ath9k_hw_rxprocdesc(ah, ds,
-					     bf->bf_daddr,
-					     PA2DESC(sc, ds->ds_link),
-					     0);
+		retval = ath9k_hw_rxprocdesc(ah, ds, rx_stats, 0);
 		if (retval == -EINPROGRESS) {
 			struct ath_buf *tbf;
 			struct ath_desc *tds;
@@ -545,8 +543,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 			 */
 
 			tds = tbf->bf_desc;
-			retval = ath9k_hw_rxprocdesc(ah, tds, tbf->bf_daddr,
-					     PA2DESC(sc, tds->ds_link), 0);
+			retval = ath9k_hw_rxprocdesc(ah, tds, &tds->ds_us.rx, 0);
 			if (retval == -EINPROGRESS) {
 				break;
 			}
@@ -569,9 +566,8 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		rxs =  IEEE80211_SKB_RXCB(skb);
 
 		hw = ath_get_virt_hw(sc, hdr);
-		rx_stats = &ds->ds_rxstat;
 
-		ath_debug_stat_rx(sc, bf);
+		ath_debug_stat_rx(sc, rx_stats);
 
 		/*
 		 * If we're asked to flush receive queue, directly
@@ -626,7 +622,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		 * change the default rx antenna if rx diversity chooses the
 		 * other antenna 3 times in a row.
 		 */
-		if (sc->rx.defant != ds->ds_rxstat.rs_antenna) {
+		if (sc->rx.defant != rx_stats->rs_antenna) {
 			if (++sc->rx.rxotherant >= 3)
 				ath_setdefantenna(sc, rx_stats->rs_antenna);
 		} else {
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -744,30 +744,29 @@ static ssize_t read_file_recv(struct fil
 #undef PHY_ERR
 }
 
-void ath_debug_stat_rx(struct ath_softc *sc, struct ath_buf *bf)
+void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs)
 {
 #define RX_STAT_INC(c) sc->debug.stats.rxstats.c++
 #define RX_PHY_ERR_INC(c) sc->debug.stats.rxstats.phy_err_stats[c]++
 
-	struct ath_desc *ds = bf->bf_desc;
 	u32 phyerr;
 
-	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
+	if (rs->rs_status & ATH9K_RXERR_CRC)
 		RX_STAT_INC(crc_err);
-	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT)
+	if (rs->rs_status & ATH9K_RXERR_DECRYPT)
 		RX_STAT_INC(decrypt_crc_err);
-	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC)
+	if (rs->rs_status & ATH9K_RXERR_MIC)
 		RX_STAT_INC(mic_err);
-	if (ds->ds_rxstat.rs_status & ATH9K_RX_DELIM_CRC_PRE)
+	if (rs->rs_status & ATH9K_RX_DELIM_CRC_PRE)
 		RX_STAT_INC(pre_delim_crc_err);
-	if (ds->ds_rxstat.rs_status & ATH9K_RX_DELIM_CRC_POST)
+	if (rs->rs_status & ATH9K_RX_DELIM_CRC_POST)
 		RX_STAT_INC(post_delim_crc_err);
-	if (ds->ds_rxstat.rs_status & ATH9K_RX_DECRYPT_BUSY)
+	if (rs->rs_status & ATH9K_RX_DECRYPT_BUSY)
 		RX_STAT_INC(decrypt_busy_err);
 
-	if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY) {
+	if (rs->rs_status & ATH9K_RXERR_PHY) {
 		RX_STAT_INC(phy_err);
-		phyerr = ds->ds_rxstat.rs_phyerr & 0x24;
+		phyerr = rs->rs_phyerr & 0x24;
 		RX_PHY_ERR_INC(phyerr);
 	}
 
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -173,7 +173,7 @@ void ath_debug_stat_interrupt(struct ath
 void ath_debug_stat_rc(struct ath_softc *sc, int final_rate);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
 		       struct ath_buf *bf, struct ath_tx_status *ts);
-void ath_debug_stat_rx(struct ath_softc *sc, struct ath_buf *bf);
+void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 			    int xretries, int retries, u8 per);
 
