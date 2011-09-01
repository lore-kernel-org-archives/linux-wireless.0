Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2953 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/30] staging: brcm80211: removed static function
 declarations in ampdu.c
Date: Thu, 1 Sep 2011 11:16:53 +0200
Message-ID: <1314868640-9425-4-git-send-email-rvossen@broadcom.com> (sfid-20110901_111840_371456_6F201C20)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |  299 +++++++++++++---------------
 1 files changed, 140 insertions(+), 159 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 6fc1591..318235d 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -60,6 +60,8 @@
 					 * accumulate between resets.
 					 */
 
+#define SHORTNAME "AMPDU status"
+
 #define TX_SEQ_TO_INDEX(seq) ((seq) % AMPDU_TX_BA_MAX_WSIZE)
 
 /* max possible overhead per mpdu in the ampdu; 3 is for roundup if needed */
@@ -148,26 +150,77 @@ struct cb_del_ampdu_pars {
 #define SCB_AMPDU_CUBBY(ampdu, scb) (&(scb->scb_ampdu))
 #define SCB_AMPDU_INI(scb_ampdu, tid) (&(scb_ampdu->ini[tid]))
 
-static void brcms_c_ffpld_init(struct ampdu_info *ampdu);
-static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int f);
-static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
+#define brcms_c_ampdu_txflowcontrol(a, b, c)	do {} while (0)
 
-static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu,
-					       u8 dur);
-static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
-					    struct scb *scb);
-static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu);
+static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
+{
+	u32 rate, mcs;
 
-#define brcms_c_ampdu_txflowcontrol(a, b, c)	do {} while (0)
+	for (mcs = 0; mcs < MCS_TABLE_SIZE; mcs++) {
+		/* rate is in Kbps; dur is in msec ==> len = (rate * dur) / 8 */
+		/* 20MHz, No SGI */
+		rate = MCS_RATE(mcs, false, false);
+		ampdu->max_txlen[mcs][0][0] = (rate * dur) >> 3;
+		/* 40 MHz, No SGI */
+		rate = MCS_RATE(mcs, true, false);
+		ampdu->max_txlen[mcs][1][0] = (rate * dur) >> 3;
+		/* 20MHz, SGI */
+		rate = MCS_RATE(mcs, false, true);
+		ampdu->max_txlen[mcs][0][1] = (rate * dur) >> 3;
+		/* 40 MHz, SGI */
+		rate = MCS_RATE(mcs, true, true);
+		ampdu->max_txlen[mcs][1][1] = (rate * dur) >> 3;
+	}
+}
 
-static void
-brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
-				  struct scb *scb,
-				  struct sk_buff *p, struct tx_status *txs,
-				  u32 frmtxstatus, u32 frmtxstatus2);
+static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu)
+{
+	if (BRCMS_PHY_11N_CAP(ampdu->wlc->band))
+		return true;
+	else
+		return false;
+}
+
+static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
+{
+	struct brcms_c_info *wlc = ampdu->wlc;
 
-static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu);
-static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on);
+	wlc->pub->_ampdu = false;
+
+	if (on) {
+		if (!N_ENAB(wlc->pub)) {
+			wiphy_err(ampdu->wlc->wiphy, "wl%d: driver not "
+				"nmode enabled\n", wlc->pub->unit);
+			return -ENOTSUPP;
+		}
+		if (!brcms_c_ampdu_cap(ampdu)) {
+			wiphy_err(ampdu->wlc->wiphy, "wl%d: device not "
+				"ampdu capable\n", wlc->pub->unit);
+			return -ENOTSUPP;
+		}
+		wlc->pub->_ampdu = on;
+	}
+
+	return 0;
+}
+
+static void brcms_c_ffpld_init(struct ampdu_info *ampdu)
+{
+	int i, j;
+	struct brcms_fifo_info *fifo;
+
+	for (j = 0; j < NUM_FFPLD_FIFO; j++) {
+		fifo = (ampdu->fifo_tb + j);
+		fifo->ampdu_pld_size = 0;
+		for (i = 0; i <= FFPLD_MAX_MCS; i++)
+			fifo->mcs2ampdu_table[i] = 255;
+		fifo->dmaxferrate = 0;
+		fifo->accum_txampdu = 0;
+		fifo->prev_txfunfl = 0;
+		fifo->accum_txfunfl = 0;
+
+	}
+}
 
 struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 {
@@ -267,21 +320,35 @@ static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu)
 	brcms_c_scb_ampdu_update_config(ampdu, ampdu->wlc->pub->global_scb);
 }
 
-static void brcms_c_ffpld_init(struct ampdu_info *ampdu)
+static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 {
-	int i, j;
-	struct brcms_fifo_info *fifo;
+	int i;
+	u32 phy_rate, dma_rate, tmp;
+	u8 max_mpdu;
+	struct brcms_fifo_info *fifo = (ampdu->fifo_tb + f);
 
-	for (j = 0; j < NUM_FFPLD_FIFO; j++) {
-		fifo = (ampdu->fifo_tb + j);
-		fifo->ampdu_pld_size = 0;
-		for (i = 0; i <= FFPLD_MAX_MCS; i++)
-			fifo->mcs2ampdu_table[i] = 255;
-		fifo->dmaxferrate = 0;
-		fifo->accum_txampdu = 0;
-		fifo->prev_txfunfl = 0;
-		fifo->accum_txfunfl = 0;
+	/* recompute the dma rate */
+	/* note : we divide/multiply by 100 to avoid integer overflows */
+	max_mpdu = min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS],
+			 AMPDU_NUM_MPDU_LEGACY);
+	phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
+	dma_rate =
+	    (((phy_rate / 100) *
+	      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
+	     / (max_mpdu * FFPLD_MPDU_SIZE)) * 100;
+	fifo->dmaxferrate = dma_rate;
 
+	/* fill up the mcs2ampdu table; do not recalc the last mcs */
+	dma_rate = dma_rate >> 7;
+	for (i = 0; i < FFPLD_MAX_MCS; i++) {
+		/* shifting to keep it within integer range */
+		phy_rate = MCS_RATE(i, true, false) >> 7;
+		if (phy_rate > dma_rate) {
+			tmp = ((fifo->ampdu_pld_size * phy_rate) /
+			       ((phy_rate - dma_rate) * FFPLD_MPDU_SIZE)) + 1;
+			tmp = min_t(u32, tmp, 255);
+			fifo->mcs2ampdu_table[i] = (u8) tmp;
+		}
 	}
 }
 
@@ -410,38 +477,6 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 	return 0;
 }
 
-static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
-{
-	int i;
-	u32 phy_rate, dma_rate, tmp;
-	u8 max_mpdu;
-	struct brcms_fifo_info *fifo = (ampdu->fifo_tb + f);
-
-	/* recompute the dma rate */
-	/* note : we divide/multiply by 100 to avoid integer overflows */
-	max_mpdu = min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS],
-			 AMPDU_NUM_MPDU_LEGACY);
-	phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
-	dma_rate =
-	    (((phy_rate / 100) *
-	      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
-	     / (max_mpdu * FFPLD_MPDU_SIZE)) * 100;
-	fifo->dmaxferrate = dma_rate;
-
-	/* fill up the mcs2ampdu table; do not recalc the last mcs */
-	dma_rate = dma_rate >> 7;
-	for (i = 0; i < FFPLD_MAX_MCS; i++) {
-		/* shifting to keep it within integer range */
-		phy_rate = MCS_RATE(i, true, false) >> 7;
-		if (phy_rate > dma_rate) {
-			tmp = ((fifo->ampdu_pld_size * phy_rate) /
-			       ((phy_rate - dma_rate) * FFPLD_MPDU_SIZE)) + 1;
-			tmp = min_t(u32, tmp, 255);
-			fifo->mcs2ampdu_table[i] = (u8) tmp;
-		}
-	}
-}
-
 void
 brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	u8 ba_wsize,		/* negotiated ba window size (in pdu) */
@@ -846,61 +881,6 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	return err;
 }
 
-void
-brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
-		     struct sk_buff *p, struct tx_status *txs)
-{
-	struct scb_ampdu *scb_ampdu;
-	struct brcms_c_info *wlc = ampdu->wlc;
-	struct scb_ampdu_tid_ini *ini;
-	u32 s1 = 0, s2 = 0;
-	struct ieee80211_tx_info *tx_info;
-
-	tx_info = IEEE80211_SKB_CB(p);
-
-	/* BMAC_NOTE: For the split driver, second level txstatus comes later
-	 * So if the ACK was received then wait for the second level else just
-	 * call the first one
-	 */
-	if (txs->status & TX_STATUS_ACK_RCV) {
-		u8 status_delay = 0;
-
-		/* wait till the next 8 bytes of txstatus is available */
-		while (((s1 = R_REG(&wlc->regs->frmtxstatus)) & TXS_V) == 0) {
-			udelay(1);
-			status_delay++;
-			if (status_delay > 10)
-				return; /* error condition */
-		}
-
-		s2 = R_REG(&wlc->regs->frmtxstatus2);
-	}
-
-	if (likely(scb)) {
-		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
-		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
-		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
-	} else {
-		/* loop through all pkts and free */
-		u8 queue = txs->frameid & TXFID_QUEUE_MASK;
-		struct d11txh *txh;
-		u16 mcl;
-		while (p) {
-			tx_info = IEEE80211_SKB_CB(p);
-			txh = (struct d11txh *) p->data;
-			mcl = le16_to_cpu(txh->MacTxControlLow);
-			brcmu_pkt_buf_free_skb(p);
-			/* break out if last packet of ampdu */
-			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
-			    TXC_AMPDU_LAST)
-				break;
-			p = GETNEXTTXP(wlc, queue);
-		}
-		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
-	}
-	brcms_c_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
-}
-
 static void
 brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
 			  struct ieee80211_tx_info *tx_info,
@@ -916,8 +896,6 @@ brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
 	}
 }
 
-#define SHORTNAME "AMPDU status"
-
 static void
 brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			      struct sk_buff *p, struct tx_status *txs,
@@ -1125,56 +1103,59 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
-static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
+void
+brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
+		     struct sk_buff *p, struct tx_status *txs)
 {
+	struct scb_ampdu *scb_ampdu;
 	struct brcms_c_info *wlc = ampdu->wlc;
+	struct scb_ampdu_tid_ini *ini;
+	u32 s1 = 0, s2 = 0;
+	struct ieee80211_tx_info *tx_info;
 
-	wlc->pub->_ampdu = false;
-
-	if (on) {
-		if (!N_ENAB(wlc->pub)) {
-			wiphy_err(ampdu->wlc->wiphy, "wl%d: driver not "
-				"nmode enabled\n", wlc->pub->unit);
-			return -ENOTSUPP;
-		}
-		if (!brcms_c_ampdu_cap(ampdu)) {
-			wiphy_err(ampdu->wlc->wiphy, "wl%d: device not "
-				"ampdu capable\n", wlc->pub->unit);
-			return -ENOTSUPP;
-		}
-		wlc->pub->_ampdu = on;
-	}
+	tx_info = IEEE80211_SKB_CB(p);
 
-	return 0;
-}
+	/* BMAC_NOTE: For the split driver, second level txstatus comes later
+	 * So if the ACK was received then wait for the second level else just
+	 * call the first one
+	 */
+	if (txs->status & TX_STATUS_ACK_RCV) {
+		u8 status_delay = 0;
 
-static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu)
-{
-	if (BRCMS_PHY_11N_CAP(ampdu->wlc->band))
-		return true;
-	else
-		return false;
-}
+		/* wait till the next 8 bytes of txstatus is available */
+		while (((s1 = R_REG(&wlc->regs->frmtxstatus)) & TXS_V) == 0) {
+			udelay(1);
+			status_delay++;
+			if (status_delay > 10)
+				return; /* error condition */
+		}
 
-static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
-{
-	u32 rate, mcs;
+		s2 = R_REG(&wlc->regs->frmtxstatus2);
+	}
 
-	for (mcs = 0; mcs < MCS_TABLE_SIZE; mcs++) {
-		/* rate is in Kbps; dur is in msec ==> len = (rate * dur) / 8 */
-		/* 20MHz, No SGI */
-		rate = MCS_RATE(mcs, false, false);
-		ampdu->max_txlen[mcs][0][0] = (rate * dur) >> 3;
-		/* 40 MHz, No SGI */
-		rate = MCS_RATE(mcs, true, false);
-		ampdu->max_txlen[mcs][1][0] = (rate * dur) >> 3;
-		/* 20MHz, SGI */
-		rate = MCS_RATE(mcs, false, true);
-		ampdu->max_txlen[mcs][0][1] = (rate * dur) >> 3;
-		/* 40 MHz, SGI */
-		rate = MCS_RATE(mcs, true, true);
-		ampdu->max_txlen[mcs][1][1] = (rate * dur) >> 3;
+	if (likely(scb)) {
+		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
+		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
+	} else {
+		/* loop through all pkts and free */
+		u8 queue = txs->frameid & TXFID_QUEUE_MASK;
+		struct d11txh *txh;
+		u16 mcl;
+		while (p) {
+			tx_info = IEEE80211_SKB_CB(p);
+			txh = (struct d11txh *) p->data;
+			mcl = le16_to_cpu(txh->MacTxControlLow);
+			brcmu_pkt_buf_free_skb(p);
+			/* break out if last packet of ampdu */
+			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
+			    TXC_AMPDU_LAST)
+				break;
+			p = GETNEXTTXP(wlc, queue);
+		}
+		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
+	brcms_c_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
 }
 
 void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc)
-- 
1.7.4.1


