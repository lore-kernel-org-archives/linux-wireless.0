Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17139 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbYG2Fre (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 01:47:34 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 22:47:34 -0700
From: <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 05/16] ath9k: Use 'ATH9K' as a prefix instead of 'HAL' for a lot of macros
Date: Mon, 28 Jul 2008 22:47:14 -0700
Message-ID: <19916ec72dd84e665ab5563c9e66b3c3afe7f25a.1217309551.git.lrodriguez@atheros.com> (sfid-20080729_074737_935743_8269CB16)
In-Reply-To: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
References: <4800d552efce6350888c68b859f66767196d720b.1217309551.git.lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 0c58bb9..24dad48 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -32,19 +32,19 @@
 #define	AR_SUBVENDOR_ID_NOG	0x0e11
 #define AR_SUBVENDOR_ID_NEW_A	0x7065
 
-#define	HAL_TXERR_XRETRY        0x01
-#define	HAL_TXERR_FILT	        0x02
-#define	HAL_TXERR_FIFO		0x04
-#define HAL_TXERR_XTXOP		0x08
-#define HAL_TXERR_TIMER_EXPIRED 0x10
-
-#define HAL_TX_BA               0x01
-#define HAL_TX_PWRMGMT          0x02
-#define HAL_TX_DESC_CFG_ERR     0x04
-#define HAL_TX_DATA_UNDERRUN    0x08
-#define HAL_TX_DELIM_UNDERRUN   0x10
-#define HAL_TX_SW_ABORTED       0x40
-#define HAL_TX_SW_FILTERED      0x80
+#define ATH9K_TXERR_XRETRY         0x01
+#define ATH9K_TXERR_FILT           0x02
+#define ATH9K_TXERR_FIFO           0x04
+#define ATH9K_TXERR_XTXOP          0x08
+#define ATH9K_TXERR_TIMER_EXPIRED  0x10
+
+#define ATH9K_TX_BA                0x01
+#define ATH9K_TX_PWRMGMT           0x02
+#define ATH9K_TX_DESC_CFG_ERR      0x04
+#define ATH9K_TX_DATA_UNDERRUN     0x08
+#define ATH9K_TX_DELIM_UNDERRUN    0x10
+#define ATH9K_TX_SW_ABORTED        0x40
+#define ATH9K_TX_SW_FILTERED       0x80
 
 #define NBBY    8
 #ifndef howmany
@@ -102,19 +102,19 @@ struct ath_rx_status {
 	u_int32_t evm2;
 };
 
-#define	HAL_RXERR_CRC		0x01
-#define	HAL_RXERR_PHY		0x02
-#define	HAL_RXERR_FIFO		0x04
-#define	HAL_RXERR_DECRYPT	0x08
-#define	HAL_RXERR_MIC		0x10
+#define ATH9K_RXERR_CRC           0x01
+#define ATH9K_RXERR_PHY           0x02
+#define ATH9K_RXERR_FIFO          0x04
+#define ATH9K_RXERR_DECRYPT       0x08
+#define ATH9K_RXERR_MIC           0x10
 
-#define HAL_RX_MORE             0x01
-#define HAL_RX_MORE_AGGR        0x02
-#define HAL_RX_GI               0x04
-#define HAL_RX_2040             0x08
-#define HAL_RX_DELIM_CRC_PRE    0x10
-#define HAL_RX_DELIM_CRC_POST   0x20
-#define HAL_RX_DECRYPT_BUSY     0x40
+#define ATH9K_RX_MORE             0x01
+#define ATH9K_RX_MORE_AGGR        0x02
+#define ATH9K_RX_GI               0x04
+#define ATH9K_RX_2040             0x08
+#define ATH9K_RX_DELIM_CRC_PRE    0x10
+#define ATH9K_RX_DELIM_CRC_POST   0x20
+#define ATH9K_RX_DECRYPT_BUSY     0x40
 
 enum hal_bool {
 	AH_FALSE = 0,
@@ -645,9 +645,9 @@ struct hal_country_entry {
 #define HAL_DBG_BEACON          0x00080000
 #define HAL_DBG_KEYCACHE        0x00100000
 #define HAL_DBG_POWER_MGMT      0x00200000
-#define HAL_DBG_MALLOC		0x00400000
-#define HAL_DBG_POWER_OVERRIDE	0x01000000
-#define HAL_DBG_SPUR_MITIGATE	0x02000000
+#define HAL_DBG_MALLOC          0x00400000
+#define HAL_DBG_POWER_OVERRIDE  0x01000000
+#define HAL_DBG_SPUR_MITIGATE   0x02000000
 #define HAL_DBG_UNMASKABLE      0xFFFFFFFF
 
 #define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 0995c6e..6acf3a6 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -611,7 +611,7 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 
 #define ATH_DS_BA_SEQ(_ds)               ((_ds)->ds_us.tx.ts_seqnum)
 #define ATH_DS_BA_BITMAP(_ds)            (&(_ds)->ds_us.tx.ba_low)
-#define ATH_DS_TX_BA(_ds)                ((_ds)->ds_us.tx.ts_flags & HAL_TX_BA)
+#define ATH_DS_TX_BA(_ds)	((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
 #define ATH_AN_2_TID(_an, _tidno)        (&(_an)->an_aggr.tx.tid[(_tidno)])
 
 enum ATH_AGGR_STATUS {
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index f1f7265..71f6574 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -7881,28 +7881,28 @@ ath9k_hw_txprocdesc(struct ath_hal *ah, struct ath_desc *ds)
 	ds->ds_txstat.ts_flags = 0;
 
 	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
-		ds->ds_txstat.ts_status |= HAL_TXERR_XRETRY;
+		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
-		ds->ds_txstat.ts_status |= HAL_TXERR_FILT;
+		ds->ds_txstat.ts_status |= ATH9K_TXERR_FILT;
 	if (ads->ds_txstatus1 & AR_FIFOUnderrun)
-		ds->ds_txstat.ts_status |= HAL_TXERR_FIFO;
+		ds->ds_txstat.ts_status |= ATH9K_TXERR_FIFO;
 	if (ads->ds_txstatus9 & AR_TxOpExceeded)
-		ds->ds_txstat.ts_status |= HAL_TXERR_XTXOP;
+		ds->ds_txstat.ts_status |= ATH9K_TXERR_XTXOP;
 	if (ads->ds_txstatus1 & AR_TxTimerExpired)
-		ds->ds_txstat.ts_status |= HAL_TXERR_TIMER_EXPIRED;
+		ds->ds_txstat.ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
 
 	if (ads->ds_txstatus1 & AR_DescCfgErr)
-		ds->ds_txstat.ts_flags |= HAL_TX_DESC_CFG_ERR;
+		ds->ds_txstat.ts_flags |= ATH9K_TX_DESC_CFG_ERR;
 	if (ads->ds_txstatus1 & AR_TxDataUnderrun) {
-		ds->ds_txstat.ts_flags |= HAL_TX_DATA_UNDERRUN;
+		ds->ds_txstat.ts_flags |= ATH9K_TX_DATA_UNDERRUN;
 		ath9k_hw_updatetxtriglevel(ah, AH_TRUE);
 	}
 	if (ads->ds_txstatus1 & AR_TxDelimUnderrun) {
-		ds->ds_txstat.ts_flags |= HAL_TX_DELIM_UNDERRUN;
+		ds->ds_txstat.ts_flags |= ATH9K_TX_DELIM_UNDERRUN;
 		ath9k_hw_updatetxtriglevel(ah, AH_TRUE);
 	}
 	if (ads->ds_txstatus0 & AR_TxBaStatus) {
-		ds->ds_txstat.ts_flags |= HAL_TX_BA;
+		ds->ds_txstat.ts_flags |= ATH9K_TX_BA;
 		ds->ds_txstat.ba_low = ads->AR_BaBitmapLow;
 		ds->ds_txstat.ba_high = ads->AR_BaBitmapHigh;
 	}
@@ -8206,31 +8206,31 @@ ath9k_hw_rxprocdesc(struct ath_hal *ah, struct ath_desc *ds,
 		(ads.ds_rxstatus8 & AR_RxMoreAggr) ? 1 : 0;
 	ds->ds_rxstat.rs_antenna = MS(ads.ds_rxstatus3, AR_RxAntenna);
 	ds->ds_rxstat.rs_flags =
-		(ads.ds_rxstatus3 & AR_GI) ? HAL_RX_GI : 0;
+		(ads.ds_rxstatus3 & AR_GI) ? ATH9K_RX_GI : 0;
 	ds->ds_rxstat.rs_flags |=
-		(ads.ds_rxstatus3 & AR_2040) ? HAL_RX_2040 : 0;
+		(ads.ds_rxstatus3 & AR_2040) ? ATH9K_RX_2040 : 0;
 
 	if (ads.ds_rxstatus8 & AR_PreDelimCRCErr)
-		ds->ds_rxstat.rs_flags |= HAL_RX_DELIM_CRC_PRE;
+		ds->ds_rxstat.rs_flags |= ATH9K_RX_DELIM_CRC_PRE;
 	if (ads.ds_rxstatus8 & AR_PostDelimCRCErr)
-		ds->ds_rxstat.rs_flags |= HAL_RX_DELIM_CRC_POST;
+		ds->ds_rxstat.rs_flags |= ATH9K_RX_DELIM_CRC_POST;
 	if (ads.ds_rxstatus8 & AR_DecryptBusyErr)
-		ds->ds_rxstat.rs_flags |= HAL_RX_DECRYPT_BUSY;
+		ds->ds_rxstat.rs_flags |= ATH9K_RX_DECRYPT_BUSY;
 
 	if ((ads.ds_rxstatus8 & AR_RxFrameOK) == 0) {
 
 		if (ads.ds_rxstatus8 & AR_CRCErr)
-			ds->ds_rxstat.rs_status |= HAL_RXERR_CRC;
+			ds->ds_rxstat.rs_status |= ATH9K_RXERR_CRC;
 		else if (ads.ds_rxstatus8 & AR_PHYErr) {
 			u_int phyerr;
 
-			ds->ds_rxstat.rs_status |= HAL_RXERR_PHY;
+			ds->ds_rxstat.rs_status |= ATH9K_RXERR_PHY;
 			phyerr = MS(ads.ds_rxstatus8, AR_PHYErrCode);
 			ds->ds_rxstat.rs_phyerr = phyerr;
 		} else if (ads.ds_rxstatus8 & AR_DecryptCRCErr)
-			ds->ds_rxstat.rs_status |= HAL_RXERR_DECRYPT;
+			ds->ds_rxstat.rs_status |= ATH9K_RXERR_DECRYPT;
 		else if (ads.ds_rxstatus8 & AR_MichaelErr)
-			ds->ds_rxstat.rs_status |= HAL_RXERR_MIC;
+			ds->ds_rxstat.rs_status |= ATH9K_RXERR_MIC;
 	}
 
 	return HAL_OK;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index ccd599a..1114c32 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1652,7 +1652,7 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 
 	avp = rc_priv->avp;
 	if ((avp->av_config.av_fixed_rateset != IEEE80211_FIXED_RATE_NONE)
-			|| info_priv->tx.ts_status & HAL_TXERR_FILT)
+			|| info_priv->tx.ts_status & ATH9K_TXERR_FILT)
 		return;
 
 	if (info_priv->tx.ts_rssi > 0) {
@@ -1667,14 +1667,14 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 	 * times. This affects how ratectrl updates PER for the failed rate.
 	 */
 	if (info_priv->tx.ts_flags &
-		(HAL_TX_DATA_UNDERRUN | HAL_TX_DELIM_UNDERRUN) &&
+		(ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN) &&
 		((sc->sc_ah->ah_txTrigLevel) >= tx_triglevel_max)) {
 		tx_status = 1;
 		is_underrun = 1;
 	}
 
-	if ((info_priv->tx.ts_status & HAL_TXERR_XRETRY) ||
-			(info_priv->tx.ts_status & HAL_TXERR_FIFO))
+	if ((info_priv->tx.ts_status & ATH9K_TXERR_XRETRY) ||
+			(info_priv->tx.ts_status & ATH9K_TXERR_FIFO))
 		tx_status = 1;
 
 	ath_rc_update(sc, rc_priv, info_priv, final_ts_idx, tx_status,
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 2446c00..372c893 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -961,14 +961,14 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 #endif
 			/* fall thru for monitor mode handling... */
 		} else if (ds->ds_rxstat.rs_status != 0) {
-			if (ds->ds_rxstat.rs_status & HAL_RXERR_CRC)
+			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
 				rx_status.flags |= ATH_RX_FCS_ERROR;
-			if (ds->ds_rxstat.rs_status & HAL_RXERR_PHY) {
+			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY) {
 				phyerr = ds->ds_rxstat.rs_phyerr & 0x1f;
 				goto rx_next;
 			}
 
-			if (ds->ds_rxstat.rs_status & HAL_RXERR_DECRYPT) {
+			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT) {
 				/*
 				 * Decrypt error. We only mark packet status
 				 * here and always push up the frame up to let
@@ -977,7 +977,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				 * error. This let us keep statistics there.
 				 */
 				rx_status.flags |= ATH_RX_DECRYPT_ERROR;
-			} else if (ds->ds_rxstat.rs_status & HAL_RXERR_MIC) {
+			} else if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC) {
 				/*
 				 * Demic error. We only mark frame status here
 				 * and always push up the frame up to let
@@ -992,7 +992,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 					 * Remove these mic errors.
 					 */
 					ds->ds_rxstat.rs_status &=
-						~HAL_RXERR_MIC;
+						~ATH9K_RXERR_MIC;
 				else
 					rx_status.flags |= ATH_RX_MIC_ERROR;
 			}
@@ -1003,12 +1003,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 */
 			if (sc->sc_opmode == HAL_M_MONITOR) {
 				if (ds->ds_rxstat.rs_status &
-				    ~(HAL_RXERR_DECRYPT | HAL_RXERR_MIC |
-					HAL_RXERR_CRC))
+				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+					ATH9K_RXERR_CRC))
 					goto rx_next;
 			} else {
 				if (ds->ds_rxstat.rs_status &
-				    ~(HAL_RXERR_DECRYPT | HAL_RXERR_MIC)) {
+				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
 					goto rx_next;
 				}
 			}
@@ -1037,12 +1037,12 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		/* HT rate */
 		if (rx_status.ratecode & 0x80) {
 			/* TODO - add table to avoid division */
-			if (ds->ds_rxstat.rs_flags & HAL_RX_2040) {
+			if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040) {
 				rx_status.flags |= ATH_RX_40MHZ;
 				rx_status.rateKbps =
 					(rx_status.rateKbps * 27) / 13;
 			}
-			if (ds->ds_rxstat.rs_flags & HAL_RX_GI)
+			if (ds->ds_rxstat.rs_flags & ATH9K_RX_GI)
 				rx_status.rateKbps =
 					(rx_status.rateKbps * 10) / 9;
 			else
@@ -1083,7 +1083,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 				rx_status.rssictl[2] =
 					ds->ds_rxstat.rs_rssi_ctl2;
 				rx_status.rssi = ds->ds_rxstat.rs_rssi;
-				if (ds->ds_rxstat.rs_flags & HAL_RX_2040) {
+				if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040) {
 					rx_status.rssiextn[0] =
 						ds->ds_rxstat.rs_rssi_ext0;
 					rx_status.rssiextn[1] =
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 127204c..71c2e77 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -625,7 +625,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc,
 	int nbad = 0;
 	int isaggr = 0;
 
-	if (isnodegone || ds->ds_txstat.ts_flags == HAL_TX_SW_ABORTED)
+	if (isnodegone || ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
 		return 0;
 
 	isaggr = bf->bf_isaggr;
@@ -1069,7 +1069,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 		} else {
 
 			if (!tid->cleanup_inprogress && !isnodegone &&
-			    ds->ds_txstat.ts_flags != HAL_TX_SW_ABORTED) {
+			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, bf);
 					txpending = 1;
@@ -1350,7 +1350,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			 * Use hardware retry status for this frame.
 			 */
 			bf->bf_retries = ds->ds_txstat.ts_longretry;
-			if (ds->ds_txstat.ts_status & HAL_TXERR_XRETRY)
+			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_isxretried = 1;
 			nbad = 0;
 		} else {
@@ -1360,9 +1360,9 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		tx_info = IEEE80211_SKB_CB(skb);
 		tx_info_priv = (struct ath_tx_info_priv *)
 			tx_info->driver_data[0];
-		if (ds->ds_txstat.ts_status & HAL_TXERR_FILT)
+		if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 			tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-		if ((ds->ds_txstat.ts_status & HAL_TXERR_FILT) == 0 &&
+		if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
 				(bf->bf_flags & HAL_TXDESC_NOACK) == 0) {
 			if (ds->ds_txstat.ts_status == 0)
 				nacked++;
@@ -2475,7 +2475,8 @@ void ath_tx_draintxq(struct ath_softc *sc,
 
 		lastbf = bf->bf_lastbf;
 		if (!retry_tx)
-			lastbf->bf_desc->ds_txstat.ts_flags = HAL_TX_SW_ABORTED;
+			lastbf->bf_desc->ds_txstat.ts_flags =
+				ATH9K_TX_SW_ABORTED;
 
 		/* remove ath_buf's of the same mpdu from txq */
 		list_cut_position(&bf_head, &txq->axq_q, &lastbf->list);
-- 
1.5.4.3

