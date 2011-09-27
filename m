Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4448 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab1I0Rps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 02/26] staging: brcm80211: removed unused argument
 from softmac functions
Date: Tue, 27 Sep 2011 10:45:06 -0700
Message-ID: <1317145530-18839-3-git-send-email-frankyl@broadcom.com> (sfid-20110927_194643_147522_2FACE172)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Parameter 's2' was unused. Affected function was only used internally
to main.c and has been made static and moved above its callers.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |  380 ++++++++++++++---------------
 drivers/staging/brcm80211/brcmsmac/main.h |    2 -
 2 files changed, 188 insertions(+), 194 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d6b43ff..d160212 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -830,9 +830,193 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	return n >= bound_limit;
 }
 
+static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
+{
+	if (tx) {
+		/* the post-increment is used in STAY_AWAKE macro */
+		if (wlc->txpend16165war++ == 0)
+			brcms_c_set_ps_ctrl(wlc);
+	} else {
+		wlc->txpend16165war--;
+		if (wlc->txpend16165war == 0)
+			brcms_c_set_ps_ctrl(wlc);
+	}
+}
+
+/* process an individual struct tx_status */
 static bool
-brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
-		   u32 s2)
+brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
+{
+	struct sk_buff *p;
+	uint queue;
+	struct d11txh *txh;
+	struct scb *scb = NULL;
+	bool free_pdu;
+	int tx_rts, tx_frame_count, tx_rts_count;
+	uint totlen, supr_status;
+	bool lastframe;
+	struct ieee80211_hdr *h;
+	u16 mcl;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *txrate;
+	int i;
+
+	/* discard intermediate indications for ucode with one legitimate case:
+	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
+	 *   but the subsequent tx of DATA failed. so it will start rts/cts
+	 *   from the beginning (resetting the rts transmission count)
+	 */
+	if (!(txs->status & TX_STATUS_AMPDU)
+	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
+		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
+			  __func__);
+		return false;
+	}
+
+	queue = txs->frameid & TXFID_QUEUE_MASK;
+	if (queue >= NFIFO) {
+		p = NULL;
+		goto fatal;
+	}
+
+	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
+	if (wlc->war16165)
+		brcms_c_war16165(wlc, false);
+	if (p == NULL)
+		goto fatal;
+
+	txh = (struct d11txh *) (p->data);
+	mcl = le16_to_cpu(txh->MacTxControlLow);
+
+	if (txs->phyerr) {
+		if (brcm_msg_level & LOG_ERROR_VAL) {
+			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
+				  txs->phyerr, txh->MainRates);
+			brcms_c_print_txdesc(txh);
+		}
+		brcms_c_print_txstatus(txs);
+	}
+
+	if (txs->frameid != cpu_to_le16(txh->TxFrameID))
+		goto fatal;
+	tx_info = IEEE80211_SKB_CB(p);
+	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
+
+	if (tx_info->control.sta)
+		scb = (struct scb *)tx_info->control.sta->drv_priv;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
+		return false;
+	}
+
+	supr_status = txs->status & TX_STATUS_SUPR_MASK;
+	if (supr_status == TX_STATUS_SUPR_BADCH)
+		BCMMSG(wlc->wiphy,
+		       "%s: Pkt tx suppressed, possibly channel %d\n",
+		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+
+	tx_rts = cpu_to_le16(txh->MacTxControlLow) & TXC_SENDRTS;
+	tx_frame_count =
+	    (txs->status & TX_STATUS_FRM_RTX_MASK) >> TX_STATUS_FRM_RTX_SHIFT;
+	tx_rts_count =
+	    (txs->status & TX_STATUS_RTS_RTX_MASK) >> TX_STATUS_RTS_RTX_SHIFT;
+
+	lastframe = !ieee80211_has_morefrags(h->frame_control);
+
+	if (!lastframe) {
+		wiphy_err(wlc->wiphy, "Not last frame!\n");
+	} else {
+		/*
+		 * Set information to be consumed by Minstrel ht.
+		 *
+		 * The "fallback limit" is the number of tx attempts a given
+		 * MPDU is sent at the "primary" rate. Tx attempts beyond that
+		 * limit are sent at the "secondary" rate.
+		 * A 'short frame' does not exceed RTS treshold.
+		 */
+		u16 sfbl,	/* Short Frame Rate Fallback Limit */
+		    lfbl,	/* Long Frame Rate Fallback Limit */
+		    fbl;
+
+		if (queue < AC_COUNT) {
+			sfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
+				      EDCF_SFB);
+			lfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
+				      EDCF_LFB);
+		} else {
+			sfbl = wlc->SFBL;
+			lfbl = wlc->LFBL;
+		}
+
+		txrate = tx_info->status.rates;
+		if (txrate[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+			fbl = lfbl;
+		else
+			fbl = sfbl;
+
+		ieee80211_tx_info_clear_status(tx_info);
+
+		if ((tx_frame_count > fbl) && (txrate[1].idx >= 0)) {
+			/*
+			 * rate selection requested a fallback rate
+			 * and we used it
+			 */
+			txrate[0].count = fbl;
+			txrate[1].count = tx_frame_count - fbl;
+		} else {
+			/*
+			 * rate selection did not request fallback rate, or
+			 * we didn't need it
+			 */
+			txrate[0].count = tx_frame_count;
+			/*
+			 * rc80211_minstrel.c:minstrel_tx_status() expects
+			 * unused rates to be marked with idx = -1
+			 */
+			txrate[1].idx = -1;
+			txrate[1].count = 0;
+		}
+
+		/* clear the rest of the rates */
+		for (i = 2; i < IEEE80211_TX_MAX_RATES; i++) {
+			txrate[i].idx = -1;
+			txrate[i].count = 0;
+		}
+
+		if (txs->status & TX_STATUS_ACK_RCV)
+			tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	totlen = brcmu_pkttotlen(p);
+	free_pdu = true;
+
+	brcms_c_txfifo_complete(wlc, queue, 1);
+
+	if (lastframe) {
+		p->next = NULL;
+		p->prev = NULL;
+		/* remove PLCP & Broadcom tx descriptor header */
+		skb_pull(p, D11_PHY_HDR_LEN);
+		skb_pull(p, D11_TXH_LEN);
+		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
+	} else {
+		wiphy_err(wlc->wiphy, "%s: Not last frame => not calling "
+			  "tx_status\n", __func__);
+	}
+
+	return false;
+
+ fatal:
+	if (p)
+		brcmu_pkt_buf_free_skb(p);
+
+	return true;
+
+}
+
+static bool
+brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
@@ -843,7 +1027,7 @@ brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
 	    && (txs->status & TX_STATUS_INTERMEDIATE))
 		return false;
 
-	return brcms_c_dotxstatus(wlc_hw->wlc, txs, s2);
+	return brcms_c_dotxstatus(wlc_hw->wlc, txs);
 }
 
 /* process tx completion events in BMAC
@@ -885,7 +1069,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 		txs->phyerr = (s2 & TXS_PTX_MASK) >> TXS_PTX_SHIFT;
 		txs->lasttxtime = 0;
 
-		*fatal = brcms_b_dotxstatus(wlc_hw, txs, s2);
+		*fatal = brcms_b_dotxstatus(wlc_hw, txs);
 
 		/* !give others some time to run! */
 		if (++n >= max_tx_num)
@@ -7654,19 +7838,6 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	in_send_q = false;
 }
 
-static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
-{
-	if (tx) {
-		/* the post-increment is used in STAY_AWAKE macro */
-		if (wlc->txpend16165war++ == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	} else {
-		wlc->txpend16165war--;
-		if (wlc->txpend16165war == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	}
-}
-
 void
 brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	       bool commit, s8 txpktpend)
@@ -7978,181 +8149,6 @@ void brcms_c_tbtt(struct brcms_c_info *wlc)
 		wlc->qvalid |= MCMD_DIRFRMQVAL;
 }
 
-/* process an individual struct tx_status */
-bool
-brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
-{
-	struct sk_buff *p;
-	uint queue;
-	struct d11txh *txh;
-	struct scb *scb = NULL;
-	bool free_pdu;
-	int tx_rts, tx_frame_count, tx_rts_count;
-	uint totlen, supr_status;
-	bool lastframe;
-	struct ieee80211_hdr *h;
-	u16 mcl;
-	struct ieee80211_tx_info *tx_info;
-	struct ieee80211_tx_rate *txrate;
-	int i;
-
-	/* Compiler reference to avoid unused variable warning */
-	(void)(frm_tx2);
-
-	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
-	 *   but the subsequent tx of DATA failed. so it will start rts/cts
-	 *   from the beginning (resetting the rts transmission count)
-	 */
-	if (!(txs->status & TX_STATUS_AMPDU)
-	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
-			  __func__);
-		return false;
-	}
-
-	queue = txs->frameid & TXFID_QUEUE_MASK;
-	if (queue >= NFIFO) {
-		p = NULL;
-		goto fatal;
-	}
-
-	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
-	if (wlc->war16165)
-		brcms_c_war16165(wlc, false);
-	if (p == NULL)
-		goto fatal;
-
-	txh = (struct d11txh *) (p->data);
-	mcl = le16_to_cpu(txh->MacTxControlLow);
-
-	if (txs->phyerr) {
-		if (brcm_msg_level & LOG_ERROR_VAL) {
-			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
-				  txs->phyerr, txh->MainRates);
-			brcms_c_print_txdesc(txh);
-		}
-		brcms_c_print_txstatus(txs);
-	}
-
-	if (txs->frameid != cpu_to_le16(txh->TxFrameID))
-		goto fatal;
-	tx_info = IEEE80211_SKB_CB(p);
-	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-
-	if (tx_info->control.sta)
-		scb = (struct scb *)tx_info->control.sta->drv_priv;
-
-	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
-		return false;
-	}
-
-	supr_status = txs->status & TX_STATUS_SUPR_MASK;
-	if (supr_status == TX_STATUS_SUPR_BADCH)
-		BCMMSG(wlc->wiphy,
-		       "%s: Pkt tx suppressed, possibly channel %d\n",
-		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
-
-	tx_rts = cpu_to_le16(txh->MacTxControlLow) & TXC_SENDRTS;
-	tx_frame_count =
-	    (txs->status & TX_STATUS_FRM_RTX_MASK) >> TX_STATUS_FRM_RTX_SHIFT;
-	tx_rts_count =
-	    (txs->status & TX_STATUS_RTS_RTX_MASK) >> TX_STATUS_RTS_RTX_SHIFT;
-
-	lastframe = !ieee80211_has_morefrags(h->frame_control);
-
-	if (!lastframe) {
-		wiphy_err(wlc->wiphy, "Not last frame!\n");
-	} else {
-		/*
-		 * Set information to be consumed by Minstrel ht.
-		 *
-		 * The "fallback limit" is the number of tx attempts a given
-		 * MPDU is sent at the "primary" rate. Tx attempts beyond that
-		 * limit are sent at the "secondary" rate.
-		 * A 'short frame' does not exceed RTS treshold.
-		 */
-		u16 sfbl,	/* Short Frame Rate Fallback Limit */
-		    lfbl,	/* Long Frame Rate Fallback Limit */
-		    fbl;
-
-		if (queue < AC_COUNT) {
-			sfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
-				      EDCF_SFB);
-			lfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
-				      EDCF_LFB);
-		} else {
-			sfbl = wlc->SFBL;
-			lfbl = wlc->LFBL;
-		}
-
-		txrate = tx_info->status.rates;
-		if (txrate[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-			fbl = lfbl;
-		else
-			fbl = sfbl;
-
-		ieee80211_tx_info_clear_status(tx_info);
-
-		if ((tx_frame_count > fbl) && (txrate[1].idx >= 0)) {
-			/*
-			 * rate selection requested a fallback rate
-			 * and we used it
-			 */
-			txrate[0].count = fbl;
-			txrate[1].count = tx_frame_count - fbl;
-		} else {
-			/*
-			 * rate selection did not request fallback rate, or
-			 * we didn't need it
-			 */
-			txrate[0].count = tx_frame_count;
-			/*
-			 * rc80211_minstrel.c:minstrel_tx_status() expects
-			 * unused rates to be marked with idx = -1
-			 */
-			txrate[1].idx = -1;
-			txrate[1].count = 0;
-		}
-
-		/* clear the rest of the rates */
-		for (i = 2; i < IEEE80211_TX_MAX_RATES; i++) {
-			txrate[i].idx = -1;
-			txrate[i].count = 0;
-		}
-
-		if (txs->status & TX_STATUS_ACK_RCV)
-			tx_info->flags |= IEEE80211_TX_STAT_ACK;
-	}
-
-	totlen = brcmu_pkttotlen(p);
-	free_pdu = true;
-
-	brcms_c_txfifo_complete(wlc, queue, 1);
-
-	if (lastframe) {
-		p->next = NULL;
-		p->prev = NULL;
-		/* remove PLCP & Broadcom tx descriptor header */
-		skb_pull(p, D11_PHY_HDR_LEN);
-		skb_pull(p, D11_TXH_LEN);
-		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
-	} else {
-		wiphy_err(wlc->wiphy, "%s: Not last frame => not calling "
-			  "tx_status\n", __func__);
-	}
-
-	return false;
-
- fatal:
-	if (p)
-		brcmu_pkt_buf_free_skb(p);
-
-	return true;
-
-}
-
 void
 brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index aa0bf03..1572e46 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -702,8 +702,6 @@ struct brcms_bss_cfg {
 extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
 extern void brcms_b_rpc_watchdog(struct brcms_c_info *wlc);
 extern void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p);
-extern bool brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs,
-			       u32 frm_tx2);
 extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   struct sk_buff *p,
 			   bool commit, s8 txpktpend);
-- 
1.7.1


