Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27406 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYKRDit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:38:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:38:49 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14363.513271.585724@gargle.gargle.HOWL> (sfid-20081118_043853_500639_811B148B)
Date: Tue, 18 Nov 2008 09:05:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 07/18] ath9k: Revamp RX handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove a lot of old, crufty code and make
RX status reporting a bit sane and clean.

Do not do anything to the RX skb before unmapping.
So in ath_rx_tasklet(), move the skb_put() after PCI unmap.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   53 +----
 drivers/net/wireless/ath9k/main.c |  100 -------
 drivers/net/wireless/ath9k/recv.c |  575 +++++++++++++------------------------
 3 files changed, 209 insertions(+), 519 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index fe9dc99..5500ef4 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -279,13 +279,6 @@ struct ath_descdma {
 	dma_addr_t dd_dmacontext;
 };
 
-/* Abstraction of a received RX MPDU/MMPDU, or a RX fragment */
-
-struct ath_rx_context {
-	struct ath_buf *ctx_rxbuf;	/* associated ath_buf for rx */
-};
-#define ATH_RX_CONTEXT(skb) ((struct ath_rx_context *)skb->cb)
-
 int ath_descdma_setup(struct ath_softc *sc,
 		      struct ath_descdma *dd,
 		      struct list_head *head,
@@ -298,61 +291,21 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 			 struct ath_descdma *dd,
 			 struct list_head *head);
 
-/******/
-/* RX */
-/******/
+/***********/
+/* RX / TX */
+/***********/
 
 #define ATH_MAX_ANTENNA          3
 #define ATH_RXBUF                512
 #define WME_NUM_TID              16
 
-/* per frame rx status block */
-struct ath_recv_status {
-	u64 tsf;		/* mac tsf */
-	int8_t rssi;		/* RSSI (noise floor ajusted) */
-	int8_t rssictl[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
-	int8_t rssiextn[ATH_MAX_ANTENNA];	/* RSSI (noise floor ajusted) */
-	int8_t abs_rssi;	/* absolute RSSI */
-	u8 rateieee;		/* data rate received (IEEE rate code) */
-	u8 ratecode;		/* phy rate code */
-	int rateKbps;		/* data rate received (Kbps) */
-	int antenna;		/* rx antenna */
-	int flags;		/* status of associated skb */
-#define ATH_RX_FCS_ERROR        0x01
-#define ATH_RX_MIC_ERROR        0x02
-#define ATH_RX_DECRYPT_ERROR    0x04
-#define ATH_RX_RSSI_VALID       0x08
-/* if any of ctl,extn chainrssis are valid */
-#define ATH_RX_CHAIN_RSSI_VALID 0x10
-/* if extn chain rssis are valid */
-#define ATH_RX_RSSI_EXTN_VALID  0x20
-/* set if 40Mhz, clear if 20Mhz */
-#define ATH_RX_40MHZ            0x40
-/* set if short GI, clear if full GI */
-#define ATH_RX_SHORT_GI         0x80
-};
-
-struct ath_rxbuf {
-	struct sk_buff *rx_wbuf;
-	unsigned long rx_time;			/* system time when received */
-	struct ath_recv_status rx_status;	/* cached rx status */
-};
-
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
-void ath_handle_rx_intr(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
 int ath_rx_tasklet(struct ath_softc *sc, int flush);
-int _ath_rx_indicate(struct ath_softc *sc,
-		     struct sk_buff *skb,
-		     struct ath_recv_status *status,
-		     u16 keyix);
-/******/
-/* TX */
-/******/
 
 #define ATH_TXBUF               512
 /* max number of transmit attempts (tries) */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index fce6982..2f5d15b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -236,68 +236,6 @@ static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
 	ht_info->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 }
 
-static int ath_rate2idx(struct ath_softc *sc, int rate)
-{
-	int i = 0, cur_band, n_rates;
-	struct ieee80211_hw *hw = sc->hw;
-
-	cur_band = hw->conf.channel->band;
-	n_rates = sc->sbands[cur_band].n_bitrates;
-
-	for (i = 0; i < n_rates; i++) {
-		if (sc->sbands[cur_band].bitrates[i].bitrate == rate)
-			break;
-	}
-
-	/*
-	 * NB:mac80211 validates rx rate index against the supported legacy rate
-	 * index only (should be done against ht rates also), return the highest
-	 * legacy rate index for rx rate which does not match any one of the
-	 * supported basic and extended rates to make mac80211 happy.
-	 * The following hack will be cleaned up once the issue with
-	 * the rx rate index validation in mac80211 is fixed.
-	 */
-	if (i == n_rates)
-		return n_rates - 1;
-	return i;
-}
-
-static void ath9k_rx_prepare(struct ath_softc *sc,
-			     struct sk_buff *skb,
-			     struct ath_recv_status *status,
-			     struct ieee80211_rx_status *rx_status)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_channel *curchan = hw->conf.channel;
-
-	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
-
-	rx_status->mactime = status->tsf;
-	rx_status->band = curchan->band;
-	rx_status->freq =  curchan->center_freq;
-	rx_status->noise = sc->sc_ani.sc_noise_floor;
-	rx_status->signal = rx_status->noise + status->rssi;
-	rx_status->rate_idx = ath_rate2idx(sc, (status->rateKbps / 100));
-	rx_status->antenna = status->antenna;
-
-	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
-	 * scheme can be used here but it requires tables of SNR/throughput for
-	 * each possible mode used. */
-	rx_status->qual = status->rssi * 100 / 45;
-
-	/* rssi can be more than 45 though, anything above that
-	 * should be considered at 100% */
-	if (rx_status->qual > 100)
-		rx_status->qual = 100;
-
-	if (status->flags & ATH_RX_MIC_ERROR)
-		rx_status->flag |= RX_FLAG_MMIC_ERROR;
-	if (status->flags & ATH_RX_FCS_ERROR)
-		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-
-	rx_status->flag |= RX_FLAG_TSFT;
-}
-
 static void ath9k_ht_conf(struct ath_softc *sc,
 			  struct ieee80211_bss_conf *bss_conf)
 {
@@ -441,44 +379,6 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	ieee80211_tx_status(hw, skb);
 }
 
-int _ath_rx_indicate(struct ath_softc *sc,
-		     struct sk_buff *skb,
-		     struct ath_recv_status *status,
-		     u16 keyix)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_rx_status rx_status;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	int padsize;
-
-	/* see if any padding is done by the hw and remove it */
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-
-	if (!(keyix == ATH9K_RXKEYIX_INVALID) &&
-	    !(status->flags & ATH_RX_DECRYPT_ERROR)) {
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-	} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
-		   && !(status->flags & ATH_RX_DECRYPT_ERROR)
-		   && skb->len >= hdrlen + 4) {
-		keyix = skb->data[hdrlen + 3] >> 6;
-
-		if (test_bit(keyix, sc->sc_keymap))
-			rx_status.flag |= RX_FLAG_DECRYPTED;
-	}
-
-	__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
 /********************************/
 /*	 LED functions		*/
 /********************************/
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 2d72ac1..000e189 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -14,10 +14,6 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/*
- * Implementation of receive path.
- */
-
 #include "core.h"
 
 /*
@@ -27,10 +23,7 @@
  * MAC acknowledges BA status as long as it copies frames to host
  * buffer (or rx fifo). This can incorrectly acknowledge packets
  * to a sender if last desc is self-linked.
- *
- * NOTE: Caller should hold the rxbuf lock.
  */
-
 static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -40,19 +33,17 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ATH_RXBUF_RESET(bf);
 
 	ds = bf->bf_desc;
-	ds->ds_link = 0;    /* link to null */
+	ds->ds_link = 0; /* link to null */
 	ds->ds_data = bf->bf_buf_addr;
 
-	/* XXX For RADAR?
-	 * virtual addr of the beginning of the buffer. */
+	/* virtual addr of the beginning of the buffer. */
 	skb = bf->bf_mpdu;
 	ASSERT(skb != NULL);
 	ds->ds_vdata = skb->data;
 
 	/* setup rx descriptors */
-	ath9k_hw_setuprxdesc(ah,
-			     ds,
-			     skb_tailroom(skb),   /* buffer size */
+	ath9k_hw_setuprxdesc(ah, ds,
+			     skb_tailroom(skb), /* buffer size */
 			     0);
 
 	if (sc->sc_rxlink == NULL)
@@ -64,8 +55,7 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ath9k_hw_rxena(ah);
 }
 
-static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
-	u32 len)
+static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc, u32 len)
 {
 	struct sk_buff *skb;
 	u32 off;
@@ -91,59 +81,154 @@ static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
 	return skb;
 }
 
-static void ath_rx_requeue(struct ath_softc *sc, struct sk_buff *skb)
+static void ath_rx_requeue(struct ath_softc *sc, struct ath_buf *bf)
 {
-	struct ath_buf *bf = ATH_RX_CONTEXT(skb)->ctx_rxbuf;
+	struct sk_buff *skb;
 
 	ASSERT(bf != NULL);
 
-	spin_lock_bh(&sc->sc_rxbuflock);
-	if (bf->bf_status & ATH_BUFSTATUS_STALE) {
-		/*
-		 * This buffer is still held for hw acess.
-		 * Mark it as free to be re-queued it later.
-		 */
-		bf->bf_status |= ATH_BUFSTATUS_FREE;
-	} else {
-		/* XXX: we probably never enter here, remove after
-		 * verification */
-		list_add_tail(&bf->list, &sc->sc_rxbuf);
-		ath_rx_buf_link(sc, bf);
+	if (bf->bf_mpdu == NULL) {
+		skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
+		if (skb != NULL) {
+			bf->bf_mpdu = skb;
+			bf->bf_buf_addr = pci_map_single(sc->pdev, skb->data,
+						 skb_end_pointer(skb) - skb->head,
+						 PCI_DMA_FROMDEVICE);
+			bf->bf_dmacontext = bf->bf_buf_addr;
+
+		}
 	}
-	spin_unlock_bh(&sc->sc_rxbuflock);
+
+	list_move_tail(&bf->list, &sc->sc_rxbuf);
+	ath_rx_buf_link(sc, bf);
+}
+
+
+static int ath_rate2idx(struct ath_softc *sc, int rate)
+{
+	int i = 0, cur_band, n_rates;
+	struct ieee80211_hw *hw = sc->hw;
+
+	cur_band = hw->conf.channel->band;
+	n_rates = sc->sbands[cur_band].n_bitrates;
+
+	for (i = 0; i < n_rates; i++) {
+		if (sc->sbands[cur_band].bitrates[i].bitrate == rate)
+			break;
+	}
+
+	/*
+	 * NB:mac80211 validates rx rate index against the supported legacy rate
+	 * index only (should be done against ht rates also), return the highest
+	 * legacy rate index for rx rate which does not match any one of the
+	 * supported basic and extended rates to make mac80211 happy.
+	 * The following hack will be cleaned up once the issue with
+	 * the rx rate index validation in mac80211 is fixed.
+	 */
+	if (i == n_rates)
+		return n_rates - 1;
+
+	return i;
 }
 
 /*
- * The skb indicated to upper stack won't be returned to us.
- * So we have to allocate a new one and queue it by ourselves.
+ * For Decrypt or Demic errors, we only mark packet status here and always push
+ * up the frame up to let mac80211 handle the actual error case, be it no
+ * decryption key or real decryption error. This let us keep statistics there.
  */
-static int ath_rx_indicate(struct ath_softc *sc,
-			   struct sk_buff *skb,
-			   struct ath_recv_status *status,
-			   u16 keyix)
+static int ath_rx_prepare(struct sk_buff *skb, struct ath_desc *ds,
+			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
+			  struct ath_softc *sc)
 {
-	struct ath_buf *bf = ATH_RX_CONTEXT(skb)->ctx_rxbuf;
-	struct sk_buff *nskb;
-	int type;
-
-	/* indicate frame to the stack, which will free the old skb. */
-	type = _ath_rx_indicate(sc, skb, status, keyix);
-
-	/* allocate a new skb and queue it to for H/W processing */
-	nskb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
-	if (nskb != NULL) {
-		bf->bf_mpdu = nskb;
-		bf->bf_buf_addr = pci_map_single(sc->pdev, nskb->data,
-					 skb_end_pointer(nskb) - nskb->head,
-					 PCI_DMA_FROMDEVICE);
-		bf->bf_dmacontext = bf->bf_buf_addr;
-		ATH_RX_CONTEXT(nskb)->ctx_rxbuf = bf;
+	struct ieee80211_hdr *hdr;
+	int ratekbps;
+	u8 ratecode;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
+
+	if (ds->ds_rxstat.rs_more) {
+		/*
+		 * Frame spans multiple descriptors; this cannot happen yet
+		 * as we don't support jumbograms. If not in monitor mode,
+		 * discard the frame. Enable this if you want to see
+		 * error frames in Monitor mode.
+		 */
+		if (sc->sc_ah->ah_opmode != ATH9K_M_MONITOR)
+			goto rx_next;
+	} else if (ds->ds_rxstat.rs_status != 0) {
+		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
+			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY)
+			goto rx_next;
 
-		/* queue the new wbuf to H/W */
-		ath_rx_requeue(sc, nskb);
+		if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT) {
+			*decrypt_error = true;
+		} else if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC) {
+			if (ieee80211_is_ctl(fc))
+				/*
+				 * Sometimes, we get invalid
+				 * MIC failures on valid control frames.
+				 * Remove these mic errors.
+				 */
+				ds->ds_rxstat.rs_status &= ~ATH9K_RXERR_MIC;
+			else
+				rx_status->flag |= RX_FLAG_MMIC_ERROR;
+		}
+		/*
+		 * Reject error frames with the exception of
+		 * decryption and MIC failures. For monitor mode,
+		 * we also ignore the CRC error.
+		 */
+		if (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR) {
+			if (ds->ds_rxstat.rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
+			      ATH9K_RXERR_CRC))
+				goto rx_next;
+		} else {
+			if (ds->ds_rxstat.rs_status &
+			    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
+				goto rx_next;
+			}
+		}
 	}
 
-	return type;
+	ratecode = ds->ds_rxstat.rs_rate;
+	ratekbps = sc->sc_hwmap[ratecode].rateKbps;
+
+	/* HT rate */
+	if (ratecode & 0x80) {
+		if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040)
+			ratekbps = (ratekbps * 27) / 13;
+		if (ds->ds_rxstat.rs_flags & ATH9K_RX_GI)
+			ratekbps = (ratekbps * 10) / 9;
+	}
+
+	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
+	rx_status->band = sc->hw->conf.channel->band;
+	rx_status->freq =  sc->hw->conf.channel->center_freq;
+	rx_status->noise = sc->sc_ani.sc_noise_floor;
+	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
+	rx_status->rate_idx = ath_rate2idx(sc, (ratekbps / 100));
+	rx_status->antenna = ds->ds_rxstat.rs_antenna;
+
+	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
+	 * scheme can be used here but it requires tables of SNR/throughput for
+	 * each possible mode used. */
+	rx_status->qual =  ds->ds_rxstat.rs_rssi * 100 / 45;
+
+	/* rssi can be more than 45 though, anything above that
+	 * should be considered at 100% */
+	if (rx_status->qual > 100)
+		rx_status->qual = 100;
+
+	rx_status->flag |= RX_FLAG_TSFT;
+
+	return 1;
+rx_next:
+	return 0;
 }
 
 static void ath_opmode_init(struct ath_softc *sc)
@@ -185,12 +270,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 		sc->sc_flags &= ~SC_OP_RXFLUSH;
 		spin_lock_init(&sc->sc_rxbuflock);
 
-		/*
-		 * Cisco's VPN software requires that drivers be able to
-		 * receive encapsulated frames that are larger than the MTU.
-		 * Since we can't be sure how large a frame we'll get, setup
-		 * to handle the larges on possible.
-		 */
 		sc->sc_rxbufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 					   min(sc->sc_cachelsz,
 					       (u16)64));
@@ -209,8 +288,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 			break;
 		}
 
-		/* Pre-allocate a wbuf for each rx buffer */
-
 		list_for_each_entry(bf, &sc->sc_rxbuf, list) {
 			skb = ath_rxbuf_alloc(sc, sc->sc_rxbufsize);
 			if (skb == NULL) {
@@ -223,7 +300,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 					 skb_end_pointer(skb) - skb->head,
 					 PCI_DMA_FROMDEVICE);
 			bf->bf_dmacontext = bf->bf_buf_addr;
-			ATH_RX_CONTEXT(skb)->ctx_rxbuf = bf;
 		}
 		sc->sc_rxlink = NULL;
 
@@ -235,8 +311,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	return error;
 }
 
-/* Reclaim all rx queue resources */
-
 void ath_rx_cleanup(struct ath_softc *sc)
 {
 	struct sk_buff *skb;
@@ -248,8 +322,6 @@ void ath_rx_cleanup(struct ath_softc *sc)
 			dev_kfree_skb(skb);
 	}
 
-	/* cleanup rx descriptors */
-
 	if (sc->sc_rxdma.dd_desc_len != 0)
 		ath_descdma_cleanup(sc, &sc->sc_rxdma, &sc->sc_rxbuf);
 }
@@ -297,20 +369,19 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	}
 
 	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
-			sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
+	    sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames
 	   & beacon frames */
 	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP)
 		rfilt |= (ATH9K_RX_FILTER_BEACON | ATH9K_RX_FILTER_PSPOLL);
+
 	return rfilt;
 
 #undef RX_FILTER_PRESERVE
 }
 
-/* Enable the receive h/w following a reset. */
-
 int ath_startrecv(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -322,21 +393,6 @@ int ath_startrecv(struct ath_softc *sc)
 
 	sc->sc_rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->sc_rxbuf, list) {
-		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
-			/* restarting h/w, no need for holding descriptors */
-			bf->bf_status &= ~ATH_BUFSTATUS_STALE;
-			/*
-			 * Upper layer may not be done with the frame yet so
-			 * we can't just re-queue it to hardware. Remove it
-			 * from h/w queue. It'll be re-queued when upper layer
-			 * returns the frame and ath_rx_requeue_mpdu is called.
-			 */
-			if (!(bf->bf_status & ATH_BUFSTATUS_FREE)) {
-				list_del(&bf->list);
-				continue;
-			}
-		}
-		/* chain descriptors */
 		ath_rx_buf_link(sc, bf);
 	}
 
@@ -346,120 +402,69 @@ int ath_startrecv(struct ath_softc *sc)
 
 	bf = list_first_entry(&sc->sc_rxbuf, struct ath_buf, list);
 	ath9k_hw_putrxbuf(ah, bf->bf_daddr);
-	ath9k_hw_rxena(ah);      /* enable recv descriptors */
+	ath9k_hw_rxena(ah);
 
 start_recv:
 	spin_unlock_bh(&sc->sc_rxbuflock);
-	ath_opmode_init(sc);        /* set filters, etc. */
-	ath9k_hw_startpcureceive(ah);	/* re-enable PCU/DMA engine */
+	ath_opmode_init(sc);
+	ath9k_hw_startpcureceive(ah);
+
 	return 0;
 }
 
-/* Disable the receive h/w in preparation for a reset. */
-
 bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
-	u64 tsf;
 	bool stopped;
 
-	ath9k_hw_stoppcurecv(ah);	/* disable PCU */
-	ath9k_hw_setrxfilter(ah, 0);	/* clear recv filter */
-	stopped = ath9k_hw_stopdmarecv(ah);	/* disable DMA engine */
-	mdelay(3);			/* 3ms is long enough for 1 frame */
-	tsf = ath9k_hw_gettsf64(ah);
-	sc->sc_rxlink = NULL;		/* just in case */
+	ath9k_hw_stoppcurecv(ah);
+	ath9k_hw_setrxfilter(ah, 0);
+	stopped = ath9k_hw_stopdmarecv(ah);
+	mdelay(3); /* 3ms is long enough for 1 frame */
+	sc->sc_rxlink = NULL;
+
 	return stopped;
 }
 
-/* Flush receive queue */
-
 void ath_flushrecv(struct ath_softc *sc)
 {
-	/*
-	 * ath_rx_tasklet may be used to handle rx interrupt and flush receive
-	 * queue at the same time. Use a lock to serialize the access of rx
-	 * queue.
-	 * ath_rx_tasklet cannot hold the spinlock while indicating packets.
-	 * Instead, do not claim the spinlock but check for a flush in
-	 * progress (see references to sc_rxflush)
-	 */
 	spin_lock_bh(&sc->sc_rxflushlock);
 	sc->sc_flags |= SC_OP_RXFLUSH;
-
 	ath_rx_tasklet(sc, 1);
-
 	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_unlock_bh(&sc->sc_rxflushlock);
 }
 
-/* Process receive queue, as well as LED, etc. */
-
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
 {
 #define PA2DESC(_sc, _pa)                                               \
 	((struct ath_desc *)((caddr_t)(_sc)->sc_rxdma.dd_desc +		\
 			     ((_pa) - (_sc)->sc_rxdma.dd_desc_paddr)))
 
-	struct ath_buf *bf, *bf_held = NULL;
+	struct ath_buf *bf;
 	struct ath_desc *ds;
-	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb = NULL;
-	struct ath_recv_status rx_status;
+	struct ieee80211_rx_status rx_status;
 	struct ath_hal *ah = sc->sc_ah;
-	int type, rx_processed = 0;
-	u32 phyerr;
-	u8 chainreset = 0;
-	int retval;
-	__le16 fc;
+	struct ieee80211_hdr *hdr;
+	int hdrlen, padsize, retval;
+	bool decrypt_error = false;
+	u8 keyix;
+
+	spin_lock_bh(&sc->sc_rxbuflock);
 
 	do {
 		/* If handling rx interrupt and flush is in progress => exit */
 		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
 			break;
 
-		spin_lock_bh(&sc->sc_rxbuflock);
 		if (list_empty(&sc->sc_rxbuf)) {
 			sc->sc_rxlink = NULL;
-			spin_unlock_bh(&sc->sc_rxbuflock);
 			break;
 		}
 
 		bf = list_first_entry(&sc->sc_rxbuf, struct ath_buf, list);
-
-		/*
-		 * There is a race condition that BH gets scheduled after sw
-		 * writes RxE and before hw re-load the last descriptor to get
-		 * the newly chained one. Software must keep the last DONE
-		 * descriptor as a holding descriptor - software does so by
-		 * marking it with the STALE flag.
-		 */
-		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
-			bf_held = bf;
-			if (list_is_last(&bf_held->list, &sc->sc_rxbuf)) {
-				/*
-				 * The holding descriptor is the last
-				 * descriptor in queue. It's safe to
-				 * remove the last holding descriptor
-				 * in BH context.
-				 */
-				list_del(&bf_held->list);
-				bf_held->bf_status &= ~ATH_BUFSTATUS_STALE;
-				sc->sc_rxlink = NULL;
-
-				if (bf_held->bf_status & ATH_BUFSTATUS_FREE) {
-					list_add_tail(&bf_held->list,
-						&sc->sc_rxbuf);
-					ath_rx_buf_link(sc, bf_held);
-				}
-				spin_unlock_bh(&sc->sc_rxbuflock);
-				break;
-			}
-			bf = list_entry(bf->list.next, struct ath_buf, list);
-		}
-
 		ds = bf->bf_desc;
-		++rx_processed;
 
 		/*
 		 * Must provide the virtual address of the current
@@ -472,8 +477,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 * on.  All this is necessary because of our use of
 		 * a self-linked list to avoid rx overruns.
 		 */
-		retval = ath9k_hw_rxprocdesc(ah,
-					     ds,
+		retval = ath9k_hw_rxprocdesc(ah, ds,
 					     bf->bf_daddr,
 					     PA2DESC(sc, ds->ds_link),
 					     0);
@@ -482,7 +486,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			struct ath_desc *tds;
 
 			if (list_is_last(&bf->list, &sc->sc_rxbuf)) {
-				spin_unlock_bh(&sc->sc_rxbuflock);
+				sc->sc_rxlink = NULL;
 				break;
 			}
 
@@ -500,215 +504,70 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 			 */
 
 			tds = tbf->bf_desc;
-			retval = ath9k_hw_rxprocdesc(ah,
-				tds, tbf->bf_daddr,
-				PA2DESC(sc, tds->ds_link), 0);
+			retval = ath9k_hw_rxprocdesc(ah, tds, tbf->bf_daddr,
+					     PA2DESC(sc, tds->ds_link), 0);
 			if (retval == -EINPROGRESS) {
-				spin_unlock_bh(&sc->sc_rxbuflock);
 				break;
 			}
 		}
 
-		/* XXX: we do not support frames spanning
-		 * multiple descriptors */
-		bf->bf_status |= ATH_BUFSTATUS_DONE;
-
 		skb = bf->bf_mpdu;
-		if (skb == NULL) {		/* XXX ??? can this happen */
-			spin_unlock_bh(&sc->sc_rxbuflock);
+		if (!skb)
 			continue;
-		}
-		/*
-		 * Now we know it's a completed frame, we can indicate the
-		 * frame. Remove the previous holding descriptor and leave
-		 * this one in the queue as the new holding descriptor.
-		 */
-		if (bf_held) {
-			list_del(&bf_held->list);
-			bf_held->bf_status &= ~ATH_BUFSTATUS_STALE;
-			if (bf_held->bf_status & ATH_BUFSTATUS_FREE) {
-				list_add_tail(&bf_held->list, &sc->sc_rxbuf);
-				/* try to requeue this descriptor */
-				ath_rx_buf_link(sc, bf_held);
-			}
-		}
 
-		bf->bf_status |= ATH_BUFSTATUS_STALE;
-		bf_held = bf;
 		/*
-		 * Release the lock here in case ieee80211_input() return
-		 * the frame immediately by calling ath_rx_mpdu_requeue().
+		 * If we're asked to flush receive queue, directly
+		 * chain it back at the queue without processing it.
 		 */
-		spin_unlock_bh(&sc->sc_rxbuflock);
-
-		if (flush) {
-			/*
-			 * If we're asked to flush receive queue, directly
-			 * chain it back at the queue without processing it.
-			 */
+		if (flush)
 			goto rx_next;
-		}
 
-		hdr = (struct ieee80211_hdr *)skb->data;
-		fc = hdr->frame_control;
-		memset(&rx_status, 0, sizeof(struct ath_recv_status));
-
-		if (ds->ds_rxstat.rs_more) {
-			/*
-			 * Frame spans multiple descriptors; this
-			 * cannot happen yet as we don't support
-			 * jumbograms.  If not in monitor mode,
-			 * discard the frame.
-			 */
-#ifndef ERROR_FRAMES
-			/*
-			 * Enable this if you want to see
-			 * error frames in Monitor mode.
-			 */
-			if (sc->sc_ah->ah_opmode != ATH9K_M_MONITOR)
-				goto rx_next;
-#endif
-			/* fall thru for monitor mode handling... */
-		} else if (ds->ds_rxstat.rs_status != 0) {
-			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_CRC)
-				rx_status.flags |= ATH_RX_FCS_ERROR;
-			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_PHY) {
-				phyerr = ds->ds_rxstat.rs_phyerr & 0x1f;
-				goto rx_next;
-			}
+		if (!ds->ds_rxstat.rs_datalen)
+			goto rx_next;
 
-			if (ds->ds_rxstat.rs_status & ATH9K_RXERR_DECRYPT) {
-				/*
-				 * Decrypt error. We only mark packet status
-				 * here and always push up the frame up to let
-				 * mac80211 handle the actual error case, be
-				 * it no decryption key or real decryption
-				 * error. This let us keep statistics there.
-				 */
-				rx_status.flags |= ATH_RX_DECRYPT_ERROR;
-			} else if (ds->ds_rxstat.rs_status & ATH9K_RXERR_MIC) {
-				/*
-				 * Demic error. We only mark frame status here
-				 * and always push up the frame up to let
-				 * mac80211 handle the actual error case. This
-				 * let us keep statistics there. Hardware may
-				 * post a false-positive MIC error.
-				 */
-				if (ieee80211_is_ctl(fc))
-					/*
-					 * Sometimes, we get invalid
-					 * MIC failures on valid control frames.
-					 * Remove these mic errors.
-					 */
-					ds->ds_rxstat.rs_status &=
-						~ATH9K_RXERR_MIC;
-				else
-					rx_status.flags |= ATH_RX_MIC_ERROR;
-			}
-			/*
-			 * Reject error frames with the exception of
-			 * decryption and MIC failures. For monitor mode,
-			 * we also ignore the CRC error.
-			 */
-			if (sc->sc_ah->ah_opmode == ATH9K_M_MONITOR) {
-				if (ds->ds_rxstat.rs_status &
-				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC |
-					ATH9K_RXERR_CRC))
-					goto rx_next;
-			} else {
-				if (ds->ds_rxstat.rs_status &
-				    ~(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_MIC)) {
-					goto rx_next;
-				}
-			}
-		}
-		/*
-		 * The status portion of the descriptor could get corrupted.
-		 */
+		/* The status portion of the descriptor could get corrupted. */
 		if (sc->sc_rxbufsize < ds->ds_rxstat.rs_datalen)
 			goto rx_next;
-		/*
-		 * Sync and unmap the frame.  At this point we're
-		 * committed to passing the sk_buff somewhere so
-		 * clear buf_skb; this means a new sk_buff must be
-		 * allocated when the rx descriptor is setup again
-		 * to receive another frame.
-		 */
-		skb_put(skb, ds->ds_rxstat.rs_datalen);
-		skb->protocol = cpu_to_be16(ETH_P_CONTROL);
-		rx_status.tsf = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
-		rx_status.rateieee =
-			sc->sc_hwmap[ds->ds_rxstat.rs_rate].ieeerate;
-		rx_status.rateKbps =
-			sc->sc_hwmap[ds->ds_rxstat.rs_rate].rateKbps;
-		rx_status.ratecode = ds->ds_rxstat.rs_rate;
-
-		/* HT rate */
-		if (rx_status.ratecode & 0x80) {
-			/* TODO - add table to avoid division */
-			if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040) {
-				rx_status.flags |= ATH_RX_40MHZ;
-				rx_status.rateKbps =
-					(rx_status.rateKbps * 27) / 13;
-			}
-			if (ds->ds_rxstat.rs_flags & ATH9K_RX_GI)
-				rx_status.rateKbps =
-					(rx_status.rateKbps * 10) / 9;
-			else
-				rx_status.flags |= ATH_RX_SHORT_GI;
-		}
 
-		/* sc_noise_floor is only available when the station
-		   attaches to an AP, so we use a default value
-		   if we are not yet attached. */
-		rx_status.abs_rssi =
-			ds->ds_rxstat.rs_rssi + sc->sc_ani.sc_noise_floor;
+		if (!ath_rx_prepare(skb, ds, &rx_status, &decrypt_error, sc))
+			goto rx_next;
 
-		pci_dma_sync_single_for_cpu(sc->pdev,
-					    bf->bf_buf_addr,
+		/* Sync and unmap the frame */
+		pci_dma_sync_single_for_cpu(sc->pdev, bf->bf_buf_addr,
 					    skb_tailroom(skb),
 					    PCI_DMA_FROMDEVICE);
-		pci_unmap_single(sc->pdev,
-				 bf->bf_buf_addr,
+		pci_unmap_single(sc->pdev, bf->bf_buf_addr,
 				 sc->sc_rxbufsize,
 				 PCI_DMA_FROMDEVICE);
 
-		/* XXX: Ah! make me more readable, use a helper */
-		if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) {
-			if (ds->ds_rxstat.rs_moreaggr == 0) {
-				rx_status.rssictl[0] =
-					ds->ds_rxstat.rs_rssi_ctl0;
-				rx_status.rssictl[1] =
-					ds->ds_rxstat.rs_rssi_ctl1;
-				rx_status.rssictl[2] =
-					ds->ds_rxstat.rs_rssi_ctl2;
-				rx_status.rssi = ds->ds_rxstat.rs_rssi;
-				if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040) {
-					rx_status.rssiextn[0] =
-						ds->ds_rxstat.rs_rssi_ext0;
-					rx_status.rssiextn[1] =
-						ds->ds_rxstat.rs_rssi_ext1;
-					rx_status.rssiextn[2] =
-						ds->ds_rxstat.rs_rssi_ext2;
-					rx_status.flags |=
-						ATH_RX_RSSI_EXTN_VALID;
-				}
-				rx_status.flags |= ATH_RX_RSSI_VALID |
-					ATH_RX_CHAIN_RSSI_VALID;
-			}
-		} else {
-			/*
-			 * Need to insert the "combined" rssi into the
-			 * status structure for upper layer processing
-			 */
-			rx_status.rssi = ds->ds_rxstat.rs_rssi;
-			rx_status.flags |= ATH_RX_RSSI_VALID;
+		skb_put(skb, ds->ds_rxstat.rs_datalen);
+		skb->protocol = cpu_to_be16(ETH_P_CONTROL);
+
+		/* see if any padding is done by the hw and remove it */
+		hdr = (struct ieee80211_hdr *)skb->data;
+		hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+
+		if (hdrlen & 3) {
+			padsize = hdrlen % 4;
+			memmove(skb->data + padsize, skb->data, hdrlen);
+			skb_pull(skb, padsize);
 		}
 
-		/* Pass frames up to the stack. */
+		keyix = ds->ds_rxstat.rs_keyix;
 
-		type = ath_rx_indicate(sc, skb,
-			&rx_status, ds->ds_rxstat.rs_keyix);
+		if (!(keyix == ATH9K_RXKEYIX_INVALID) && !decrypt_error) {
+			rx_status.flag |= RX_FLAG_DECRYPTED;
+		} else if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_PROTECTED)
+			   && !decrypt_error && skb->len >= hdrlen + 4) {
+			keyix = skb->data[hdrlen + 3] >> 6;
+
+			if (test_bit(keyix, sc->sc_keymap))
+				rx_status.flag |= RX_FLAG_DECRYPTED;
+		}
+
+		/* Send the frame to mac80211 */
+		__ieee80211_rx(sc->hw, skb, &rx_status);
+		bf->bf_mpdu = NULL;
 
 		/*
 		 * change the default rx antenna if rx diversity chooses the
@@ -716,37 +575,15 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush)
 		 */
 		if (sc->sc_defant != ds->ds_rxstat.rs_antenna) {
 			if (++sc->sc_rxotherant >= 3)
-				ath_setdefantenna(sc,
-						ds->ds_rxstat.rs_antenna);
+				ath_setdefantenna(sc, ds->ds_rxstat.rs_antenna);
 		} else {
 			sc->sc_rxotherant = 0;
 		}
-
-#ifdef CONFIG_SLOW_ANT_DIV
-		if ((rx_status.flags & ATH_RX_RSSI_VALID) &&
-		    ieee80211_is_beacon(fc)) {
-			ath_slow_ant_div(&sc->sc_antdiv, hdr, &ds->ds_rxstat);
-		}
-#endif
-		/*
-		 * For frames successfully indicated, the buffer will be
-		 * returned to us by upper layers by calling
-		 * ath_rx_mpdu_requeue, either synchronusly or asynchronously.
-		 * So we don't want to do it here in this loop.
-		 */
-		continue;
-
 rx_next:
-		bf->bf_status |= ATH_BUFSTATUS_FREE;
-	} while (TRUE);
-
-	if (chainreset) {
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"%s: Reset rx chain mask. "
-			"Do internal reset\n", __func__);
-		ASSERT(flush == 0);
-		ath_reset(sc, false);
-	}
+		ath_rx_requeue(sc, bf);
+	} while (1);
+
+	spin_unlock_bh(&sc->sc_rxbuflock);
 
 	return 0;
 #undef PA2DESC
-- 
1.6.0.3

