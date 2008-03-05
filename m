Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:8142 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757416AbYCEJgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 04:36:07 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 2/4] ath5k: move rx and tx status structures out of hardware
	descriptor
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 05 Mar 2008 18:35:45 +0900
Message-ID: <20080305093544.5670.34548.stgit@one> (sfid-20080305_093645_062258_BB0655CC)
In-Reply-To: <20080305091347.5670.40944.stgit@one>
References: <20080305091347.5670.40944.stgit@one>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move ath5k_tx_status and ath5k_rx_status structures out of the hardware
descriptor since they are not accessed by the hardware at all. they just
contain converted information from the hardware descriptor. since they are only
used in the rx and tx tasklets there is also no use to keep them for each
descriptor.

drivers/net/wireless/ath5k/ath5k.h:     Changes-licensed-under: ISC
drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
drivers/net/wireless/ath5k/debug.c:     Changes-licensed-under: GPL
drivers/net/wireless/ath5k/debug.h:     Changes-licensed-under: GPL
drivers/net/wireless/ath5k/hw.c:        Changes-licensed-under: ISC

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---

 drivers/net/wireless/ath5k/ath5k.h |   16 +---
 drivers/net/wireless/ath5k/base.c  |   74 +++++++++----------
 drivers/net/wireless/ath5k/debug.c |   19 +++--
 drivers/net/wireless/ath5k/debug.h |    6 +-
 drivers/net/wireless/ath5k/hw.c    |  141 ++++++++++++++++++------------------
 5 files changed, 126 insertions(+), 130 deletions(-)


diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index e2f889b..09b9852 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -500,6 +500,7 @@ struct ath5k_beacon_state {
 
 /*
  * Atheros hardware descriptor
+ * This is read and written to by the hardware
  */
 struct ath5k_desc {
 	u32	ds_link;	/* physical address of the next descriptor */
@@ -510,15 +511,6 @@ struct ath5k_desc {
 		struct ath5k_hw_5212_tx_desc	ds_tx5212;
 		struct ath5k_hw_all_rx_desc	ds_rx;
 	} ud;
-
-	union {
-		struct ath5k_rx_status rx;
-		struct ath5k_tx_status tx;
-	} ds_us;
-
-#define ds_rxstat ds_us.rx
-#define ds_txstat ds_us.tx
-
 } __packed;
 
 #define AR5K_RXDESC_INTREQ	0x0020
@@ -1037,8 +1029,10 @@ struct ath5k_hw {
 	int (*ah_setup_xtx_desc)(struct ath5k_hw *, struct ath5k_desc *,
 		unsigned int, unsigned int, unsigned int, unsigned int,
 		unsigned int, unsigned int);
-	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *);
-	int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *);
+	int (*ah_proc_tx_desc)(struct ath5k_hw *, struct ath5k_desc *,
+		struct ath5k_tx_status *);
+	int (*ah_proc_rx_desc)(struct ath5k_hw *, struct ath5k_desc *,
+		struct ath5k_rx_status *);
 };
 
 /*
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 393b5f3..777bc4a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -280,7 +280,8 @@ static int 	ath5k_rx_start(struct ath5k_softc *sc);
 static void 	ath5k_rx_stop(struct ath5k_softc *sc);
 static unsigned int ath5k_rx_decrypted(struct ath5k_softc *sc,
 					struct ath5k_desc *ds,
-					struct sk_buff *skb);
+					struct sk_buff *skb,
+					struct ath5k_rx_status *rs);
 static void 	ath5k_tasklet_rx(unsigned long data);
 /* Tx handling */
 static void 	ath5k_tx_processq(struct ath5k_softc *sc,
@@ -1560,8 +1561,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	 */
 	spin_lock_bh(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
-		ath5k_debug_printtxbuf(sc, bf, !sc->ah->ah_proc_tx_desc(sc->ah,
-					bf->desc));
+		ath5k_debug_printtxbuf(sc, bf);
 
 		ath5k_txbuf_free(sc, bf);
 
@@ -1686,20 +1686,20 @@ ath5k_rx_stop(struct ath5k_softc *sc)
 
 static unsigned int
 ath5k_rx_decrypted(struct ath5k_softc *sc, struct ath5k_desc *ds,
-		struct sk_buff *skb)
+		struct sk_buff *skb, struct ath5k_rx_status *rs)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int keyix, hlen = ieee80211_get_hdrlen_from_skb(skb);
 
-	if (!(ds->ds_rxstat.rs_status & AR5K_RXERR_DECRYPT) &&
-			ds->ds_rxstat.rs_keyix != AR5K_RXKEYIX_INVALID)
+	if (!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
+			rs->rs_keyix != AR5K_RXKEYIX_INVALID)
 		return RX_FLAG_DECRYPTED;
 
 	/* Apparently when a default key is used to decrypt the packet
 	   the hw does not set the index used to decrypt.  In such cases
 	   get the index from the packet. */
 	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED) &&
-			!(ds->ds_rxstat.rs_status & AR5K_RXERR_DECRYPT) &&
+			!(rs->rs_status & AR5K_RXERR_DECRYPT) &&
 			skb->len >= hlen + 4) {
 		keyix = skb->data[hlen + 3] >> 6;
 
@@ -1742,12 +1742,11 @@ static void
 ath5k_tasklet_rx(unsigned long data)
 {
 	struct ieee80211_rx_status rxs = {};
+	struct ath5k_rx_status rs = {};
 	struct sk_buff *skb;
 	struct ath5k_softc *sc = (void *)data;
 	struct ath5k_buf *bf;
 	struct ath5k_desc *ds;
-	u16 len;
-	u8 stat;
 	int ret;
 	int hdrlen;
 	int pad;
@@ -1770,7 +1769,7 @@ ath5k_tasklet_rx(unsigned long data)
 		if (unlikely(ds->ds_link == bf->daddr)) /* this is the end */
 			break;
 
-		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds);
+		ret = sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
@@ -1779,16 +1778,15 @@ ath5k_tasklet_rx(unsigned long data)
 			return;
 		}
 
-		if (unlikely(ds->ds_rxstat.rs_more)) {
+		if (unlikely(rs.rs_more)) {
 			ATH5K_WARN(sc, "unsupported jumbo\n");
 			goto next;
 		}
 
-		stat = ds->ds_rxstat.rs_status;
-		if (unlikely(stat)) {
-			if (stat & AR5K_RXERR_PHY)
+		if (unlikely(rs.rs_status)) {
+			if (rs.rs_status & AR5K_RXERR_PHY)
 				goto next;
-			if (stat & AR5K_RXERR_DECRYPT) {
+			if (rs.rs_status & AR5K_RXERR_DECRYPT) {
 				/*
 				 * Decrypt error.  If the error occurred
 				 * because there was no hardware key, then
@@ -1799,30 +1797,29 @@ ath5k_tasklet_rx(unsigned long data)
 				 *
 				 * XXX do key cache faulting
 				 */
-				if (ds->ds_rxstat.rs_keyix ==
-						AR5K_RXKEYIX_INVALID &&
-						!(stat & AR5K_RXERR_CRC))
+				if (rs.rs_keyix == AR5K_RXKEYIX_INVALID &&
+				    !(rs.rs_status & AR5K_RXERR_CRC))
 					goto accept;
 			}
-			if (stat & AR5K_RXERR_MIC) {
+			if (rs.rs_status & AR5K_RXERR_MIC) {
 				rxs.flag |= RX_FLAG_MMIC_ERROR;
 				goto accept;
 			}
 
 			/* let crypto-error packets fall through in MNTR */
-			if ((stat & ~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
+			if ((rs.rs_status &
+				~(AR5K_RXERR_DECRYPT|AR5K_RXERR_MIC)) ||
 					sc->opmode != IEEE80211_IF_TYPE_MNTR)
 				goto next;
 		}
 accept:
-		len = ds->ds_rxstat.rs_datalen;
-		pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, len,
-				PCI_DMA_FROMDEVICE);
+		pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr,
+				rs.rs_datalen, PCI_DMA_FROMDEVICE);
 		pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
 				PCI_DMA_FROMDEVICE);
 		bf->skb = NULL;
 
-		skb_put(skb, len);
+		skb_put(skb, rs.rs_datalen);
 
 		/*
 		 * the hardware adds a padding to 4 byte boundaries between
@@ -1845,7 +1842,7 @@ accept:
 		 * 32768usec (about 32ms). it might be necessary to move this to
 		 * the interrupt handler, like it is done in madwifi.
 		 */
-		rxs.mactime = ath5k_extend_tsf(sc->ah, ds->ds_rxstat.rs_tstamp);
+		rxs.mactime = ath5k_extend_tsf(sc->ah, rs.rs_tstamp);
 		rxs.flag |= RX_FLAG_TSFT;
 
 		rxs.freq = sc->curchan->center_freq;
@@ -1859,17 +1856,16 @@ accept:
 		/* noise floor in dBm, from the last noise calibration */
 		rxs.noise = sc->ah->ah_noise_floor;
 		/* signal level in dBm */
-		rxs.ssi = rxs.noise + ds->ds_rxstat.rs_rssi;
+		rxs.ssi = rxs.noise + rs.rs_rssi;
 		/*
 		 * "signal" is actually displayed as Link Quality by iwconfig
 		 * we provide a percentage based on rssi (assuming max rssi 64)
 		 */
-		rxs.signal = ds->ds_rxstat.rs_rssi * 100 / 64;
+		rxs.signal = rs.rs_rssi * 100 / 64;
 
-		rxs.antenna = ds->ds_rxstat.rs_antenna;
-		rxs.rate_idx = ath5k_hw_to_driver_rix(sc,
-			ds->ds_rxstat.rs_rate);
-		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb);
+		rxs.antenna = rs.rs_antenna;
+		rxs.rate_idx = ath5k_hw_to_driver_rix(sc, rs.rs_rate);
+		rxs.flag |= ath5k_rx_decrypted(sc, ds, skb, &rs);
 
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);
 
@@ -1878,7 +1874,7 @@ accept:
 			ath5k_check_ibss_hw_merge(sc, skb);
 
 		__ieee80211_rx(sc->hw, skb, &rxs);
-		sc->led_rxrate = ds->ds_rxstat.rs_rate;
+		sc->led_rxrate = rs.rs_rate;
 		ath5k_led_event(sc, ATH_LED_RX);
 next:
 		list_move_tail(&bf->list, &sc->rxbuf);
@@ -1897,6 +1893,7 @@ static void
 ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 {
 	struct ieee80211_tx_status txs = {};
+	struct ath5k_tx_status ts = {};
 	struct ath5k_buf *bf, *bf0;
 	struct ath5k_desc *ds;
 	struct sk_buff *skb;
@@ -1909,7 +1906,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		/* TODO only one segment */
 		pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
 				sc->desc_len, PCI_DMA_FROMDEVICE);
-		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds);
+		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
 		else if (unlikely(ret)) {
@@ -1924,17 +1921,16 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 				PCI_DMA_TODEVICE);
 
 		txs.control = bf->ctl;
-		txs.retry_count = ds->ds_txstat.ts_shortretry +
-			ds->ds_txstat.ts_longretry / 6;
-		if (unlikely(ds->ds_txstat.ts_status)) {
+		txs.retry_count = ts.ts_shortretry + ts.ts_longretry / 6;
+		if (unlikely(ts.ts_status)) {
 			sc->ll_stats.dot11ACKFailureCount++;
-			if (ds->ds_txstat.ts_status & AR5K_TXERR_XRETRY)
+			if (ts.ts_status & AR5K_TXERR_XRETRY)
 				txs.excessive_retries = 1;
-			else if (ds->ds_txstat.ts_status & AR5K_TXERR_FILT)
+			else if (ts.ts_status & AR5K_TXERR_FILT)
 				txs.flags |= IEEE80211_TX_STATUS_TX_FILTERED;
 		} else {
 			txs.flags |= IEEE80211_TX_STATUS_ACK;
-			txs.ack_signal = ds->ds_txstat.ts_rssi;
+			txs.ack_signal = ts.ts_rssi;
 		}
 
 		ieee80211_tx_status(sc->hw, skb, &txs);
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index 9301494..d3eb9e8 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -497,7 +497,8 @@ ath5k_debug_dump_bands(struct ath5k_softc *sc)
 }
 
 static inline void
-ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done)
+ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done,
+		       struct ath5k_rx_status *rs)
 {
 	struct ath5k_desc *ds = bf->desc;
 	struct ath5k_hw_all_rx_desc *rd = &ds->ud.ds_rx;
@@ -507,7 +508,7 @@ ath5k_debug_printrxbuf(struct ath5k_buf *bf, int done)
 		ds->ds_link, ds->ds_data,
 		rd->rx_ctl.rx_control_0, rd->rx_ctl.rx_control_1,
 		rd->u.rx_stat.rx_status_0, rd->u.rx_stat.rx_status_0,
-		!done ? ' ' : (ds->ds_rxstat.rs_status == 0) ? '*' : '!');
+		!done ? ' ' : (rs->rs_status == 0) ? '*' : '!');
 }
 
 void
@@ -515,6 +516,7 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 {
 	struct ath5k_desc *ds;
 	struct ath5k_buf *bf;
+	struct ath5k_rx_status rs = {};
 	int status;
 
 	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
@@ -526,9 +528,9 @@ ath5k_debug_printrxbuffs(struct ath5k_softc *sc, struct ath5k_hw *ah)
 	spin_lock_bh(&sc->rxbuflock);
 	list_for_each_entry(bf, &sc->rxbuf, list) {
 		ds = bf->desc;
-		status = ah->ah_proc_rx_desc(ah, ds);
+		status = ah->ah_proc_rx_desc(ah, ds, &rs);
 		if (!status)
-			ath5k_debug_printrxbuf(bf, status == 0);
+			ath5k_debug_printrxbuf(bf, status == 0, &rs);
 	}
 	spin_unlock_bh(&sc->rxbuflock);
 }
@@ -552,21 +554,24 @@ ath5k_debug_dump_skb(struct ath5k_softc *sc,
 }
 
 void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc,
-			struct ath5k_buf *bf, int done)
+ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf)
 {
 	struct ath5k_desc *ds = bf->desc;
 	struct ath5k_hw_5212_tx_desc *td = &ds->ud.ds_tx5212;
+	struct ath5k_tx_status ts = {};
+	int done;
 
 	if (likely(!(sc->debug.level & ATH5K_DEBUG_RESET)))
 		return;
 
+	done = sc->ah->ah_proc_tx_desc(sc->ah, bf->desc, &ts);
+
 	printk(KERN_DEBUG "T (%p %llx) %08x %08x %08x %08x %08x %08x %08x "
 		"%08x %c\n", ds, (unsigned long long)bf->daddr, ds->ds_link,
 		ds->ds_data, td->tx_ctl.tx_control_0, td->tx_ctl.tx_control_1,
 		td->tx_ctl.tx_control_2, td->tx_ctl.tx_control_3,
 		td->tx_stat.tx_status_0, td->tx_stat.tx_status_1,
-		!done ? ' ' : (ds->ds_txstat.ts_status == 0) ? '*' : '!');
+		done ? ' ' : (ts.ts_status == 0) ? '*' : '!');
 }
 
 #endif /* ifdef CONFIG_ATH5K_DEBUG */
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index 8c0b5c5..2cf8d18 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -160,8 +160,7 @@ ath5k_debug_dump_skb(struct ath5k_softc *sc,
 			struct sk_buff *skb, const char *prefix, int tx);
 
 void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc,
-			struct ath5k_buf *bf, int done);
+ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf);
 
 #else /* no debugging */
 
@@ -199,8 +198,7 @@ ath5k_debug_dump_skb(struct ath5k_softc *sc,
 			struct sk_buff *skb, const char *prefix, int tx) {}
 
 static inline void
-ath5k_debug_printtxbuf(struct ath5k_softc *sc,
-			struct ath5k_buf *bf, int done) {}
+ath5k_debug_printtxbuf(struct ath5k_softc *sc, struct ath5k_buf *bf) {}
 
 #endif /* ifdef CONFIG_ATH5K_DEBUG */
 
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index bcd6041..53744c2 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -48,14 +48,18 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 static int ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int);
-static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *, struct ath5k_desc *,
+					 struct ath5k_tx_status *);
 static int ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *, struct ath5k_desc *,
 	unsigned int, unsigned int, enum ath5k_pkt_type, unsigned int,
 	unsigned int, unsigned int, unsigned int, unsigned int, unsigned int,
 	unsigned int, unsigned int);
-static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *);
-static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *, struct ath5k_desc *);
-static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *, struct ath5k_desc *);
+static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *, struct ath5k_desc *,
+					 struct ath5k_tx_status *);
+static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *, struct ath5k_desc *,
+					struct ath5k_rx_status *);
+static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *, struct ath5k_desc *,
+					struct ath5k_rx_status *);
 static int ath5k_hw_get_capabilities(struct ath5k_hw *);
 
 static int ath5k_eeprom_init(struct ath5k_hw *);
@@ -3732,7 +3736,7 @@ ath5k_hw_setup_xr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
  * Proccess the tx status descriptor on 5210/5211
  */
 static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc)
+		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
 {
 	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
@@ -3749,32 +3753,32 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 	/*
 	 * Get descriptor status
 	 */
-	desc->ds_us.tx.ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
-	desc->ds_us.tx.ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
-	desc->ds_us.tx.ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
-	/*TODO: desc->ds_us.tx.ts_virtcol + test*/
-	desc->ds_us.tx.ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
+	/*TODO: ts->ts_virtcol + test*/
+	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
 		AR5K_DESC_TX_STATUS1_SEQ_NUM);
-	desc->ds_us.tx.ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
-	desc->ds_us.tx.ts_antenna = 1;
-	desc->ds_us.tx.ts_status = 0;
-	desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_0,
+	ts->ts_antenna = 1;
+	ts->ts_status = 0;
+	ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_0,
 		AR5K_2W_TX_DESC_CTL0_XMIT_RATE);
 
 	if ((tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK) == 0){
 		if (tx_status->tx_status_0 &
 				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_XRETRY;
+			ts->ts_status |= AR5K_TXERR_XRETRY;
 
 		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_FIFO;
+			ts->ts_status |= AR5K_TXERR_FIFO;
 
 		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_FILT;
+			ts->ts_status |= AR5K_TXERR_FILT;
 	}
 
 	return 0;
@@ -3784,7 +3788,7 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
  * Proccess a tx descriptor on 5212
  */
 static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc)
+		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
@@ -3801,42 +3805,42 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	/*
 	 * Get descriptor status
 	 */
-	desc->ds_us.tx.ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_tstamp = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_SEND_TIMESTAMP);
-	desc->ds_us.tx.ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_shortretry = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_SHORT_RETRY_COUNT);
-	desc->ds_us.tx.ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
+	ts->ts_longretry = AR5K_REG_MS(tx_status->tx_status_0,
 		AR5K_DESC_TX_STATUS0_LONG_RETRY_COUNT);
-	desc->ds_us.tx.ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_seqnum = AR5K_REG_MS(tx_status->tx_status_1,
 		AR5K_DESC_TX_STATUS1_SEQ_NUM);
-	desc->ds_us.tx.ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
+	ts->ts_rssi = AR5K_REG_MS(tx_status->tx_status_1,
 		AR5K_DESC_TX_STATUS1_ACK_SIG_STRENGTH);
-	desc->ds_us.tx.ts_antenna = (tx_status->tx_status_1 &
+	ts->ts_antenna = (tx_status->tx_status_1 &
 		AR5K_DESC_TX_STATUS1_XMIT_ANTENNA) ? 2 : 1;
-	desc->ds_us.tx.ts_status = 0;
+	ts->ts_status = 0;
 
 	switch (AR5K_REG_MS(tx_status->tx_status_1,
 			AR5K_DESC_TX_STATUS1_FINAL_TS_INDEX)) {
 	case 0:
-		desc->ds_us.tx.ts_rate = tx_ctl->tx_control_3 &
+		ts->ts_rate = tx_ctl->tx_control_3 &
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE0;
 		break;
 	case 1:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE1);
-		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES1);
 		break;
 	case 2:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE2);
-		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES2);
 		break;
 	case 3:
-		desc->ds_us.tx.ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
+		ts->ts_rate = AR5K_REG_MS(tx_ctl->tx_control_3,
 			AR5K_4W_TX_DESC_CTL3_XMIT_RATE3);
-		desc->ds_us.tx.ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
+		ts->ts_longretry += AR5K_REG_MS(tx_ctl->tx_control_2,
 			AR5K_4W_TX_DESC_CTL2_XMIT_TRIES3);
 		break;
 	}
@@ -3844,13 +3848,13 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 	if ((tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FRAME_XMIT_OK) == 0){
 		if (tx_status->tx_status_0 &
 				AR5K_DESC_TX_STATUS0_EXCESSIVE_RETRIES)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_XRETRY;
+			ts->ts_status |= AR5K_TXERR_XRETRY;
 
 		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FIFO_UNDERRUN)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_FIFO;
+			ts->ts_status |= AR5K_TXERR_FIFO;
 
 		if (tx_status->tx_status_0 & AR5K_DESC_TX_STATUS0_FILTERED)
-			desc->ds_us.tx.ts_status |= AR5K_TXERR_FILT;
+			ts->ts_status |= AR5K_TXERR_FILT;
 	}
 
 	return 0;
@@ -3895,7 +3899,7 @@ int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
  * Proccess the rx status descriptor on 5210/5211
  */
 static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc)
+		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
 
@@ -3909,28 +3913,29 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	/*
 	 * Frame receive status
 	 */
-	desc->ds_us.rx.rs_datalen = rx_status->rx_status_0 &
+	rs->rs_datalen = rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_DATA_LEN;
-	desc->ds_us.rx.rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
+	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_SIGNAL);
-	desc->ds_us.rx.rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
+	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_RATE);
-	desc->ds_us.rx.rs_antenna = rx_status->rx_status_0 &
+	rs->rs_antenna = rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	desc->ds_us.rx.rs_more = rx_status->rx_status_0 &
+	rs->rs_more = rx_status->rx_status_0 &
 		AR5K_5210_RX_DESC_STATUS0_MORE;
-	desc->ds_us.rx.rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
+	/* TODO: this timestamp is 13 bit, later on we assume 15 bit */
+	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
-	desc->ds_us.rx.rs_status = 0;
+	rs->rs_status = 0;
 
 	/*
 	 * Key table status
 	 */
 	if (rx_status->rx_status_1 & AR5K_5210_RX_DESC_STATUS1_KEY_INDEX_VALID)
-		desc->ds_us.rx.rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
+		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
 			AR5K_5210_RX_DESC_STATUS1_KEY_INDEX);
 	else
-		desc->ds_us.rx.rs_keyix = AR5K_RXKEYIX_INVALID;
+		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
 
 	/*
 	 * Receive/descriptor errors
@@ -3939,23 +3944,22 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 			AR5K_5210_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_CRC_ERROR)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_CRC;
+			rs->rs_status |= AR5K_RXERR_CRC;
 
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_FIFO_OVERRUN)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_FIFO;
+			rs->rs_status |= AR5K_RXERR_FIFO;
 
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_PHY;
-			desc->ds_us.rx.rs_phyerr =
-				AR5K_REG_MS(rx_status->rx_status_1,
-					AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
+			rs->rs_status |= AR5K_RXERR_PHY;
+			rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
+					   AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
 		}
 
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_DECRYPT;
+			rs->rs_status |= AR5K_RXERR_DECRYPT;
 	}
 
 	return 0;
@@ -3965,7 +3969,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
  * Proccess the rx status descriptor on 5212
  */
 static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc)
+		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
 	struct ath5k_hw_rx_error *rx_err;
@@ -3984,28 +3988,28 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	/*
 	 * Frame receive status
 	 */
-	desc->ds_us.rx.rs_datalen = rx_status->rx_status_0 &
+	rs->rs_datalen = rx_status->rx_status_0 &
 		AR5K_5212_RX_DESC_STATUS0_DATA_LEN;
-	desc->ds_us.rx.rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
+	rs->rs_rssi = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5212_RX_DESC_STATUS0_RECEIVE_SIGNAL);
-	desc->ds_us.rx.rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
+	rs->rs_rate = AR5K_REG_MS(rx_status->rx_status_0,
 		AR5K_5212_RX_DESC_STATUS0_RECEIVE_RATE);
-	desc->ds_us.rx.rs_antenna = rx_status->rx_status_0 &
+	rs->rs_antenna = rx_status->rx_status_0 &
 		AR5K_5212_RX_DESC_STATUS0_RECEIVE_ANTENNA;
-	desc->ds_us.rx.rs_more = rx_status->rx_status_0 &
+	rs->rs_more = rx_status->rx_status_0 &
 		AR5K_5212_RX_DESC_STATUS0_MORE;
-	desc->ds_us.rx.rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
+	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
-	desc->ds_us.rx.rs_status = 0;
+	rs->rs_status = 0;
 
 	/*
 	 * Key table status
 	 */
 	if (rx_status->rx_status_1 & AR5K_5212_RX_DESC_STATUS1_KEY_INDEX_VALID)
-		desc->ds_us.rx.rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
+		rs->rs_keyix = AR5K_REG_MS(rx_status->rx_status_1,
 				AR5K_5212_RX_DESC_STATUS1_KEY_INDEX);
 	else
-		desc->ds_us.rx.rs_keyix = AR5K_RXKEYIX_INVALID;
+		rs->rs_keyix = AR5K_RXKEYIX_INVALID;
 
 	/*
 	 * Receive/descriptor errors
@@ -4014,23 +4018,22 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 			AR5K_5212_RX_DESC_STATUS1_FRAME_RECEIVE_OK) == 0) {
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_CRC_ERROR)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_CRC;
+			rs->rs_status |= AR5K_RXERR_CRC;
 
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_PHY;
-			desc->ds_us.rx.rs_phyerr =
-				AR5K_REG_MS(rx_err->rx_error_1,
-					AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
+			rs->rs_status |= AR5K_RXERR_PHY;
+			rs->rs_phyerr = AR5K_REG_MS(rx_err->rx_error_1,
+					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
 		}
 
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_DECRYPT_CRC_ERROR)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_DECRYPT;
+			rs->rs_status |= AR5K_RXERR_DECRYPT;
 
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_MIC_ERROR)
-			desc->ds_us.rx.rs_status |= AR5K_RXERR_MIC;
+			rs->rs_status |= AR5K_RXERR_MIC;
 	}
 
 	return 0;

