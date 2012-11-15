Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58876 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOOI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:28 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 06/22] brcmsmac: Remove internal tx queue
Date: Thu, 15 Nov 2012 08:07:56 -0600
Message-Id: <1352988492-21340-7-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150846_984679_152EDB19)
In-Reply-To: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The brcmsmac internal tx buffering is problematic. The amount of
buffering is excessive (228 packets in addition to the 256 slots in each
DMA ring), and frames may be dropped due to a lack of flow control.

This patch reworks the transmit code path to remove the internal
buffering. Frames are immediately handed off to the DMA support rather
than passing through an intermediate queue. Non-aggregate frames are
queued immediately into the tx rings, and aggregate frames are queued
temporarily in an AMPDU session until ready for transmit.

Transmit flow control is also added to avoid dropping packets when the
tx rings are full. Conceptually this is a separate change, but it's
included in this commit because removing the tx queue without adding
flow control could cause significant problems.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |  167 +--------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  189 ++++++++--
 drivers/net/wireless/brcm80211/brcmsmac/dma.h   |    9 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c  |  459 ++++++++---------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h  |   33 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h   |   13 -
 drivers/net/wireless/brcm80211/brcmsmac/types.h |    1 -
 8 files changed, 316 insertions(+), 558 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 0b4a490..c62fd3d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -813,133 +813,6 @@ void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session)
 		session->ampdu_len);
 }
 
-int
-brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
-	      struct sk_buff **pdu, int prec)
-{
-	struct brcms_c_info *wlc;
-	struct sk_buff *p;
-	struct brcms_ampdu_session session;
-	int err = 0;
-	u8 tid;
-
-	uint count, fifo, seg_cnt = 0;
-	struct scb *scb;
-	struct scb_ampdu *scb_ampdu;
-	struct scb_ampdu_tid_ini *ini;
-	struct ieee80211_tx_info *tx_info;
-	u16 qlen;
-	struct wiphy *wiphy;
-
-	wlc = ampdu->wlc;
-	wiphy = wlc->wiphy;
-	p = *pdu;
-
-	tid = (u8) (p->priority);
-
-	scb = &wlc->pri_scb;
-	scb_ampdu = &scb->scb_ampdu;
-	ini = &scb_ampdu->ini[tid];
-
-	/* Let pressure continue to build ... */
-	qlen = pktq_plen(&qi->q, prec);
-	if (ini->tx_in_transit > 0 &&
-	    qlen < min(scb_ampdu->max_pdu, ini->ba_wsize))
-		/* Collect multiple MPDU's to be sent in the next AMPDU */
-		return -EBUSY;
-
-	/* at this point we intend to transmit an AMPDU */
-	brcms_c_ampdu_reset_session(&session, wlc);
-
-	while (p) {
-		struct ieee80211_tx_rate *txrate;
-
-		tx_info = IEEE80211_SKB_CB(p);
-		txrate = tx_info->status.rates;
-
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = brcms_c_prep_pdu(wlc, p, &fifo);
-		} else {
-			wiphy_err(wiphy, "%s: AMPDU flag is off!\n", __func__);
-			*pdu = NULL;
-			err = 0;
-			break;
-		}
-
-		if (err) {
-			if (err == -EBUSY) {
-				wiphy_err(wiphy, "wl%d: sendampdu: "
-					  "prep_xdu retry\n", wlc->pub->unit);
-				*pdu = p;
-				break;
-			}
-
-			/* error in the packet; reject it */
-			wiphy_err(wiphy, "wl%d: sendampdu: prep_xdu "
-				  "rejected\n", wlc->pub->unit);
-			*pdu = NULL;
-			break;
-		}
-
-		err = brcms_c_ampdu_add_frame(&session, p);
-		if (err == -ENOSPC) {
-			/*
-			 * No space for this packet in the AMPDU.
-			 * Requeue packet and proceed;
-			 */
-			*pdu = p;
-			break;
-		} else if (err) {
-			/* Unexpected error; reject packet */
-			wiphy_err(wiphy, "wl%d: sendampdu: add_frame rejected",
-				  wlc->pub->unit);
-			*pdu = NULL;
-			break;
-		}
-
-		seg_cnt += 1;
-
-		/*
-		 * check to see if the next pkt is
-		 * a candidate for aggregation
-		 */
-		p = pktq_ppeek(&qi->q, prec);
-		if (p) {
-			tx_info = IEEE80211_SKB_CB(p);
-			if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-				/*
-				 * check if there are enough
-				 * descriptors available
-				 */
-				if (*wlc->core->txavail[fifo] <= seg_cnt + 1) {
-					wiphy_err(wiphy, "%s: No fifo space "
-						  "!!\n", __func__);
-					p = NULL;
-					continue;
-				}
-				/* next packet fit for aggregation so dequeue */
-				p = brcmu_pktq_pdeq(&qi->q, prec);
-			} else {
-				p = NULL;
-			}
-		}
-	}			/* end while(p) */
-
-	count = skb_queue_len(&session.skb_list);
-	ini->tx_in_transit += count;
-
-	if (count) {
-		/* patch up first and last txh's */
-		brcms_c_ampdu_finalize(&session);
-
-		while ((p = skb_dequeue(&session.skb_list)) != NULL)
-			brcms_c_txfifo(wlc, fifo, p,
-				       skb_queue_empty(&session.skb_list));
-	}
-	/* endif (count) */
-	return err;
-}
-
 static void
 brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
 			  struct ieee80211_tx_info *tx_info,
@@ -1113,9 +986,16 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
 			if (retry && (ini->txretry[index] < (int)retry_limit)) {
+				int ret;
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
-				brcms_c_txq_enq(wlc, scb, p);
+				ret = brcms_c_txfifo(wlc, queue, p);
+				/*
+				 * We shouldn't be out of space in the DMA
+				 * ring here since we're reinserting a frame
+				 * that was just pulled out.
+				 */
+				WARN_ONCE(ret, "queue %d out of txds\n", queue);
 			} else {
 				/* Retry timeout */
 				ini->tx_in_transit--;
@@ -1142,12 +1022,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	}
-	brcms_c_send_q(wlc);
 
 	/* update rate state */
 	antselid = brcms_c_antsel_antsel2id(wlc->asi, mimoantsel);
-
-	brcms_c_txfifo_complete(wlc, queue);
 }
 
 void
@@ -1204,7 +1081,6 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			p = dma_getnexttxp(wlc->hw->di[queue],
 					   DMA_RANGE_TRANSMITTED);
 		}
-		brcms_c_txfifo_complete(wlc, queue);
 	}
 }
 
@@ -1244,23 +1120,6 @@ void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu)
 }
 
 /*
- * callback function that helps flushing ampdu packets from a priority queue
- */
-static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(mpdu);
-	struct cb_del_ampdu_pars *ampdu_pars =
-				 (struct cb_del_ampdu_pars *)arg_a;
-	bool rc;
-
-	rc = tx_info->flags & IEEE80211_TX_CTL_AMPDU ? true : false;
-	rc = rc && (tx_info->rate_driver_data[0] == NULL || ampdu_pars->sta == NULL ||
-		    tx_info->rate_driver_data[0] == ampdu_pars->sta);
-	rc = rc && ((u8)(mpdu->priority) == ampdu_pars->tid);
-	return rc;
-}
-
-/*
  * callback function that helps invalidating ampdu packets in a DMA queue
  */
 static void dma_cb_fn_ampdu(void *txi, void *arg_a)
@@ -1280,15 +1139,5 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct brcms_txq_info *qi = wlc->pkt_queue;
-	struct pktq *pq = &qi->q;
-	int prec;
-	struct cb_del_ampdu_pars ampdu_pars;
-
-	ampdu_pars.sta = sta;
-	ampdu_pars.tid = tid;
-	for (prec = 0; prec < pq->num_prec; prec++)
-		brcmu_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
-			    (void *)&ampdu_pars);
 	brcms_c_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
index 9a94923..73d01e5 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.h
@@ -45,9 +45,6 @@ extern void brcms_c_ampdu_finalize(struct brcms_ampdu_session *session);
 
 extern struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc);
 extern void brcms_c_ampdu_detach(struct ampdu_info *ampdu);
-extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
-			     struct brcms_txq_info *qi,
-			     struct sk_buff **aggp, int prec);
 extern void brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, struct tx_status *txs);
 extern void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.c b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
index 6444cf1..426b9a9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.c
@@ -19,12 +19,17 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <net/cfg80211.h>
+#include <net/mac80211.h>
 
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include "types.h"
+#include "main.h"
 #include "dma.h"
 #include "soc.h"
+#include "scb.h"
+#include "ampdu.h"
 
 /*
  * dma register field offset calculation
@@ -230,6 +235,9 @@ struct dma_info {
 	struct bcma_device *core;
 	struct device *dmadev;
 
+	/* session information for AMPDU */
+	struct brcms_ampdu_session ampdu_session;
+
 	bool dma64;	/* this dma engine is operating in 64-bit mode */
 	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
@@ -564,12 +572,13 @@ static bool _dma_alloc(struct dma_info *di, uint direction)
 	return dma64_alloc(di, direction);
 }
 
-struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-			   struct bcma_device *core,
+struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 			   uint txregbase, uint rxregbase, uint ntxd, uint nrxd,
 			   uint rxbufsize, int rxextheadroom,
 			   uint nrxpost, uint rxoffset, uint *msg_level)
 {
+	struct si_pub *sih = wlc->hw->sih;
+	struct bcma_device *core = wlc->hw->d11core;
 	struct dma_info *di;
 	u8 rev = core->id.rev;
 	uint size;
@@ -714,6 +723,9 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		}
 	}
 
+	/* Initialize AMPDU session */
+	brcms_c_ampdu_reset_session(&di->ampdu_session, wlc);
+
 	DMA_TRACE("ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x dataoffsethigh 0x%x addrext %d\n",
 		  di->ddoffsetlow, di->ddoffsethigh,
 		  di->dataoffsetlow, di->dataoffsethigh,
@@ -1016,6 +1028,17 @@ static bool dma64_rxidle(struct dma_info *di)
 		 D64_RS0_CD_MASK));
 }
 
+static bool dma64_txidle(struct dma_info *di)
+{
+	if (di->ntxd == 0)
+		return true;
+
+	return ((bcma_read32(di->core,
+			     DMA64TXREGOFFS(di, status0)) & D64_XS0_CD_MASK) ==
+		(bcma_read32(di->core, DMA64TXREGOFFS(di, ptr)) &
+		 D64_XS0_CD_MASK));
+}
+
 /*
  * post receive buffers
  *  return false is refill failed completely and ring is empty this will stall
@@ -1264,50 +1287,25 @@ bool dma_rxreset(struct dma_pub *pub)
 	return status == D64_RS0_RS_DISABLED;
 }
 
-/* Update count of available tx descriptors based on current DMA state */
-static void dma_update_txavail(struct dma_info *di)
+static void dma_txenq(struct dma_info *di, struct sk_buff *p)
 {
-	/*
-	 * Available space is number of descriptors less the number of
-	 * active descriptors and the number of queued AMPDU frames.
-	 */
-	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) - 1;
-}
-
-
-/*
- * !! tx entry routine
- * WARNING: call must check the return value for error.
- *   the error(toss frames) could be fatal and cause many subsequent hard
- *   to debug problems
- */
-int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
-{
-	struct dma_info *di = (struct dma_info *)pub;
 	unsigned char *data;
 	uint len;
 	u16 txout;
 	u32 flags = 0;
 	dma_addr_t pa;
 
-	DMA_TRACE("%s:\n", di->name);
-
 	txout = di->txout;
 
+	if (WARN_ON(nexttxd(di, txout) == di->txin))
+		return;
+
 	/*
 	 * obtain and initialize transmit descriptor entry.
 	 */
 	data = p->data;
 	len = p->len;
 
-	/* no use to transmit a zero length packet */
-	if (len == 0)
-		return 0;
-
-	/* return nonzero if out of tx descriptors */
-	if (nexttxd(di, txout) == di->txin)
-		goto outoftxd;
-
 	/* get physical address of buffer start */
 	pa = dma_map_single(di->dmadev, data, len, DMA_TO_DEVICE);
 
@@ -1329,15 +1327,106 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 
 	/* bump the tx descriptor index */
 	di->txout = txout;
+}
 
-	/* kick the chip */
-	if (commit)
-		bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
-		      di->xmtptrbase + I2B(txout, struct dma64desc));
+static void ampdu_finalize(struct dma_info *di)
+{
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	struct sk_buff *p;
+
+	if (WARN_ON(skb_queue_empty(&session->skb_list)))
+		return;
+
+	brcms_c_ampdu_finalize(session);
+
+	while (!skb_queue_empty(&session->skb_list)) {
+		p = skb_dequeue(&session->skb_list);
+		dma_txenq(di, p);
+	}
+
+	bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
+		     di->xmtptrbase + I2B(di->txout, struct dma64desc));
+	brcms_c_ampdu_reset_session(session, session->wlc);
+}
+
+static void prep_ampdu_frame(struct dma_info *di, struct sk_buff *p)
+{
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	int ret;
+
+	ret = brcms_c_ampdu_add_frame(session, p);
+	if (ret == -ENOSPC) {
+		/*
+		 * AMPDU cannot accomodate this frame. Close out the in-
+		 * progress AMPDU session and start a new one.
+		 */
+		ampdu_finalize(di);
+		ret = brcms_c_ampdu_add_frame(session, p);
+	}
+
+	WARN_ON(ret);
+}
+
+/* Update count of available tx descriptors based on current DMA state */
+static void dma_update_txavail(struct dma_info *di)
+{
+	/*
+	 * Available space is number of descriptors less the number of
+	 * active descriptors and the number of queued AMPDU frames.
+	 */
+	di->dma.txavail = di->ntxd - ntxdactive(di, di->txin, di->txout) -
+			  skb_queue_len(&di->ampdu_session.skb_list) - 1;
+}
+
+/*
+ * !! tx entry routine
+ * WARNING: call must check the return value for error.
+ *   the error(toss frames) could be fatal and cause many subsequent hard
+ *   to debug problems
+ */
+int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
+	       struct sk_buff *p)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+	struct ieee80211_tx_info *tx_info;
+	bool is_ampdu;
+
+	DMA_TRACE("%s:\n", di->name);
+
+	/* no use to transmit a zero length packet */
+	if (p->len == 0)
+		return 0;
+
+	/* return nonzero if out of tx descriptors */
+	if (di->dma.txavail == 0 || nexttxd(di, di->txout) == di->txin)
+		goto outoftxd;
+
+	tx_info = IEEE80211_SKB_CB(p);
+	is_ampdu = tx_info->flags & IEEE80211_TX_CTL_AMPDU;
+	if (is_ampdu)
+		prep_ampdu_frame(di, p);
+	else
+		dma_txenq(di, p);
 
 	/* tx flow control */
 	dma_update_txavail(di);
 
+	/* kick the chip */
+	if (is_ampdu) {
+		/*
+		 * Start sending data if we've got a full AMPDU, there's
+		 * no more space in the DMA ring, or the ring isn't
+		 * currently transmitting.
+		 */
+		if (skb_queue_len(&session->skb_list) == session->max_ampdu_frames ||
+		    di->dma.txavail == 0 || dma64_txidle(di))
+			ampdu_finalize(di);
+	} else {
+		bcma_write32(di->core, DMA64TXREGOFFS(di, ptr),
+			     di->xmtptrbase + I2B(di->txout, struct dma64desc));
+	}
+
 	return 0;
 
  outoftxd:
@@ -1345,7 +1434,35 @@ int dma_txfast(struct dma_pub *pub, struct sk_buff *p, bool commit)
 	brcmu_pkt_buf_free_skb(p);
 	di->dma.txavail = 0;
 	di->dma.txnobuf++;
-	return -1;
+	return -ENOSPC;
+}
+
+void dma_txflush(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+
+	if (!skb_queue_empty(&session->skb_list))
+		ampdu_finalize(di);
+}
+
+int dma_txpending(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	return ntxdactive(di, di->txin, di->txout);
+}
+
+/*
+ * If we have an active AMPDU session and are not transmitting,
+ * this function will force tx to start.
+ */
+void dma_kick_tx(struct dma_pub *pub)
+{
+	struct dma_info *di = (struct dma_info *)pub;
+	struct brcms_ampdu_session *session = &di->ampdu_session;
+
+	if (!skb_queue_empty(&session->skb_list) && dma64_txidle(di))
+		ampdu_finalize(di);
 }
 
 /*
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/dma.h b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
index cc269ee..459abf1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/dma.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/dma.h
@@ -74,8 +74,7 @@ struct dma_pub {
 	uint txnobuf;		/* tx out of dma descriptors */
 };
 
-extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
-				  struct bcma_device *d11core,
+extern struct dma_pub *dma_attach(char *name, struct brcms_c_info *wlc,
 				  uint txregbase, uint rxregbase,
 				  uint ntxd, uint nrxd,
 				  uint rxbufsize, int rxextheadroom,
@@ -87,7 +86,11 @@ bool dma_rxfill(struct dma_pub *pub);
 bool dma_rxreset(struct dma_pub *pub);
 bool dma_txreset(struct dma_pub *pub);
 void dma_txinit(struct dma_pub *pub);
-int dma_txfast(struct dma_pub *pub, struct sk_buff *p0, bool commit);
+int dma_txfast(struct brcms_c_info *wlc, struct dma_pub *pub,
+	       struct sk_buff *p0);
+void dma_txflush(struct dma_pub *pub);
+int dma_txpending(struct dma_pub *pub);
+void dma_kick_tx(struct dma_pub *pub);
 void dma_txsuspend(struct dma_pub *pub);
 bool dma_txsuspended(struct dma_pub *pub);
 void dma_txresume(struct dma_pub *pub);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8abf39d..2b8987c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -34,6 +34,7 @@
 #include "ucode_loader.h"
 #include "main.h"
 #include "soc.h"
+#include "dma.h"
 
 /* watchdog timer, in unit of ms */
 #define TIMER_INTERVAL_WATCHDOG		1000
@@ -236,12 +237,12 @@
 /* Max # of entries in Rx FIFO based on 4kb page size */
 #define NRXD				256
 
+/* Amount of headroom to leave in Tx FIFO */
+#define TX_HEADROOM			4
+
 /* try to keep this # rbufs posted to the chip */
 #define NRXBUFPOST			32
 
-/* data msg txq hiwat mark */
-#define BRCMS_DATAHIWAT			50
-
 /* max # frames to process in brcms_c_recv() */
 #define RXBND				8
 /* max # tx status to process in wlc_txstatus() */
@@ -303,6 +304,18 @@ static const u8 wme_ac2fifo[] = {
 	TX_AC_BK_FIFO
 };
 
+/* 802.1D Priority to precedence queue mapping */
+const u8 wlc_prio2prec_map[] = {
+	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
+	_BRCMS_PREC_BK,		/* 1 BK - Background */
+	_BRCMS_PREC_NONE,		/* 2 None = - */
+	_BRCMS_PREC_EE,		/* 3 EE - Excellent-effort */
+	_BRCMS_PREC_CL,		/* 4 CL - Controlled Load */
+	_BRCMS_PREC_VI,		/* 5 Vi - Video */
+	_BRCMS_PREC_VO,		/* 6 Vo - Voice */
+	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
+};
+
 static const u16 xmtfifo_sz[][NFIFO] = {
 	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
@@ -350,6 +363,14 @@ static const u8 ac_to_fifo_mapping[IEEE80211_NUM_ACS] = {
 	[IEEE80211_AC_BK]	= TX_AC_BK_FIFO,
 };
 
+/* Mapping of tx fifos to ieee80211 AC numbers */
+static const u8 fifo_to_ac_mapping[IEEE80211_NUM_ACS] = {
+	[TX_AC_BK_FIFO]	= IEEE80211_AC_BK,
+	[TX_AC_BE_FIFO]	= IEEE80211_AC_BE,
+	[TX_AC_VI_FIFO]	= IEEE80211_AC_VI,
+	[TX_AC_VO_FIFO]	= IEEE80211_AC_VO,
+};
+
 static u8 brcms_ac_to_fifo(u8 ac)
 {
 	if (ac >= ARRAY_SIZE(ac_to_fifo_mapping))
@@ -357,6 +378,13 @@ static u8 brcms_ac_to_fifo(u8 ac)
 	return ac_to_fifo_mapping[ac];
 }
 
+static u8 brcms_fifo_to_ac(u8 fifo)
+{
+	if (fifo >= ARRAY_SIZE(fifo_to_ac_mapping))
+		return IEEE80211_AC_BE;
+	return fifo_to_ac_mapping[fifo];
+}
+
 /* Find basic rate for a given rate */
 static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 {
@@ -401,10 +429,15 @@ static bool brcms_deviceremoved(struct brcms_c_info *wlc)
 }
 
 /* sum the individual fifo tx pending packet counts */
-static s16 brcms_txpktpendtot(struct brcms_c_info *wlc)
+static int brcms_txpktpendtot(struct brcms_c_info *wlc)
 {
-	return wlc->core->txpktpend[0] + wlc->core->txpktpend[1] +
-	       wlc->core->txpktpend[2] + wlc->core->txpktpend[3];
+	int i;
+	int pending = 0;
+
+	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
+		if (wlc->hw->di[i])
+			pending += dma_txpending(wlc->hw->di[i]);
+	return pending;
 }
 
 static bool brcms_is_mband_unlocked(struct brcms_c_info *wlc)
@@ -827,8 +860,9 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 static bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 {
-	struct sk_buff *p;
-	uint queue;
+	struct sk_buff *p = NULL;
+	uint queue = NFIFO;
+	struct dma_pub *dma = NULL;
 	struct d11txh *txh;
 	struct scb *scb = NULL;
 	bool free_pdu;
@@ -840,6 +874,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *txrate;
 	int i;
+	bool fatal = true;
 
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
@@ -849,18 +884,19 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
 		BCMMSG(wlc->wiphy, "INTERMEDIATE but not AMPDU\n");
-		return false;
+		fatal = false;
+		goto out;
 	}
 
 	queue = txs->frameid & TXFID_QUEUE_MASK;
-	if (queue >= NFIFO) {
-		p = NULL;
-		goto fatal;
-	}
+	if (queue >= NFIFO)
+		goto out;
+
+	dma = wlc->hw->di[queue];
 
 	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	if (p == NULL)
-		goto fatal;
+		goto out;
 
 	txh = (struct d11txh *) (p->data);
 	mcl = le16_to_cpu(txh->MacTxControlLow);
@@ -875,7 +911,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	}
 
 	if (txs->frameid != le16_to_cpu(txh->TxFrameID))
-		goto fatal;
+		goto out;
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
@@ -884,7 +920,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
-		return false;
+		fatal = false;
+		goto out;
 	}
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
@@ -968,8 +1005,6 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 	totlen = p->len;
 	free_pdu = true;
 
-	brcms_c_txfifo_complete(wlc, queue);
-
 	if (lastframe) {
 		/* remove PLCP & Broadcom tx descriptor header */
 		skb_pull(p, D11_PHY_HDR_LEN);
@@ -980,14 +1015,21 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 			  "tx_status\n", __func__);
 	}
 
-	return false;
+	fatal = false;
 
- fatal:
-	if (p)
+ out:
+	if (fatal && p)
 		brcmu_pkt_buf_free_skb(p);
 
-	return true;
+	if (dma && queue < NFIFO) {
+		u16 ac_queue = brcms_fifo_to_ac(queue);
+		if (dma->txavail > TX_HEADROOM && queue < TX_BCMC_FIFO &&
+		    ieee80211_queue_stopped(wlc->pub->ieee_hw, ac_queue))
+			ieee80211_wake_queue(wlc->pub->ieee_hw, ac_queue);
+		dma_kick_tx(dma);
+	}
 
+	return fatal;
 }
 
 /* process tx completion events in BMAC
@@ -1044,9 +1086,6 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	if (n >= max_tx_num)
 		morepending = true;
 
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
 	return morepending;
 }
 
@@ -1111,7 +1150,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_BK_FIFO (TX AC Background data packets)
 		 * RX: RX_FIFO (RX data packets)
 		 */
-		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[0] = dma_attach(name, wlc,
 					   (wme ? dmareg(DMA_TX, 0) : 0),
 					   dmareg(DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
@@ -1125,7 +1164,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 *   (legacy) TX_DATA_FIFO (TX data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[1] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 1), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1136,7 +1175,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VI_FIFO (TX AC Video data packets)
 		 * RX: UNUSED
 		 */
-		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[2] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 2), 0,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
@@ -1146,7 +1185,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * TX: TX_AC_VO_FIFO (TX AC Voice data packets)
 		 *   (legacy) TX_CTL_FIFO (TX control & mgmt packets)
 		 */
-		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih, wlc_hw->d11core,
+		wlc_hw->di[3] = dma_attach(name, wlc,
 					   dmareg(DMA_TX, 3),
 					   0, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
@@ -2870,12 +2909,14 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	uint i;
 
 	/* free any posted tx packets */
-	for (i = 0; i < NFIFO; i++)
+	for (i = 0; i < NFIFO; i++) {
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], DMA_RANGE_ALL);
-			wlc->core->txpktpend[i] = 0;
-			BCMMSG(wlc->wiphy, "pktpend fifo %d clrd\n", i);
+			if (i < TX_BCMC_FIFO)
+				ieee80211_wake_queue(wlc->pub->ieee_hw,
+						     brcms_fifo_to_ac(i));
 		}
+	}
 
 	/* free any posted rx packets */
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
@@ -3738,15 +3779,6 @@ brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 	return 0;
 }
 
-/*
- * Initialize the base precedence map for dequeueing
- * from txq based on WME settings
- */
-static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
-{
-	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
-}
-
 /* push sw hps and wake state through hardware */
 static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
@@ -4797,56 +4829,6 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 		bi->flags |= BRCMS_BSS_HT;
 }
 
-static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi, *p;
-
-	qi = kzalloc(sizeof(struct brcms_txq_info), GFP_ATOMIC);
-	if (qi != NULL) {
-		/*
-		 * Have enough room for control packets along with HI watermark
-		 * Also, add room to txq for total psq packets if all the SCBs
-		 * leave PS mode. The watermark for flowcontrol to OS packets
-		 * will remain the same
-		 */
-		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
-			  2 * BRCMS_DATAHIWAT + PKTQ_LEN_DEFAULT);
-
-		/* add this queue to the the global list */
-		p = wlc->tx_queues;
-		if (p == NULL) {
-			wlc->tx_queues = qi;
-		} else {
-			while (p->next != NULL)
-				p = p->next;
-			p->next = qi;
-		}
-	}
-	return qi;
-}
-
-static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi)
-{
-	struct brcms_txq_info *p;
-
-	if (qi == NULL)
-		return;
-
-	/* remove the queue from the linked list */
-	p = wlc->tx_queues;
-	if (p == qi)
-		wlc->tx_queues = p->next;
-	else {
-		while (p != NULL && p->next != qi)
-			p = p->next;
-		if (p != NULL)
-			p->next = p->next->next;
-	}
-
-	kfree(qi);
-}
-
 static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 {
 	uint i;
@@ -4966,10 +4948,6 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 
 	brcms_c_detach_module(wlc);
 
-
-	while (wlc->tx_queues != NULL)
-		brcms_c_txq_free(wlc, wlc->tx_queues);
-
 	brcms_c_detach_mfree(wlc);
 	return callbacks;
 }
@@ -5275,7 +5253,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	uint callbacks = 0;
 	int i;
 	bool dev_gone = false;
-	struct brcms_txq_info *qi;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -5314,10 +5291,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	wlc_phy_mute_upd(wlc->band->pi, false, PHY_MUTE_ALL);
 
-	/* flush tx queues */
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next)
-		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
-
 	callbacks += brcms_b_down_finish(wlc->hw);
 
 	/* brcms_b_down_finish has done brcms_c_coredisable(). so clk is off */
@@ -5991,85 +5964,6 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-static bool
-brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
-		      struct sk_buff *pkt, int prec, bool head)
-{
-	struct sk_buff *p;
-	int eprec = -1;		/* precedence to evict from */
-
-	/* Determine precedence from which to evict packet, if any */
-	if (pktq_pfull(q, prec))
-		eprec = prec;
-	else if (pktq_full(q)) {
-		p = brcmu_pktq_peek_tail(q, &eprec);
-		if (eprec > prec) {
-			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
-				  "\n", __func__, eprec, prec);
-			return false;
-		}
-	}
-
-	/* Evict if needed */
-	if (eprec >= 0) {
-		bool discard_oldest;
-
-		discard_oldest = ac_bitmap_tst(0, eprec);
-
-		/* Refuse newer packet unless configured to discard oldest */
-		if (eprec == prec && !discard_oldest) {
-			wiphy_err(wlc->wiphy, "%s: No where to go, prec == %d"
-				  "\n", __func__, prec);
-			return false;
-		}
-
-		/* Evict packet according to discard policy */
-		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
-			brcmu_pktq_pdeq_tail(q, eprec);
-		brcmu_pkt_buf_free_skb(p);
-	}
-
-	/* Enqueue */
-	if (head)
-		p = brcmu_pktq_penq_head(q, prec, pkt);
-	else
-		p = brcmu_pktq_penq(q, prec, pkt);
-
-	return true;
-}
-
-/*
- * Attempts to queue a packet onto a multiple-precedence queue,
- * if necessary evicting a lower precedence packet from the queue.
- *
- * 'prec' is the precedence number that has already been mapped
- * from the packet priority.
- *
- * Returns true if packet consumed (queued), false if not.
- */
-static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
-		      struct sk_buff *pkt, int prec)
-{
-	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
-}
-
-void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-		     struct sk_buff *sdu)
-{
-	struct brcms_txq_info *qi = wlc->pkt_queue;	/* Check me */
-	struct pktq *q = &qi->q;
-	uint prec;
-
-	prec = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
-	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
-		/*
-		 * we might hit this condtion in case
-		 * packet flooding from mac80211 stack
-		 */
-		brcmu_pkt_buf_free_skb(sdu);
-	}
-}
-
 /*
  * bcmc_fid_generate:
  * Generate frame ID for a BCMC packet.  The frag field is not used
@@ -7230,70 +7124,33 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
-			      struct ieee80211_hw *hw)
+static int brcms_c_tx(struct brcms_c_info *wlc, struct sk_buff *skb)
 {
-	uint fifo;
-	struct scb *scb = &wlc->pri_scb;
-
-	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
-	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
-		return;
-	brcms_c_txq_enq(wlc, scb, sdu);
-	brcms_c_send_q(wlc);
-}
-
-void brcms_c_send_q(struct brcms_c_info *wlc)
-{
-	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
-	int prec;
-	u16 prec_map;
-	int err = 0, i, count;
-	uint fifo;
-	struct brcms_txq_info *qi = wlc->pkt_queue;
-	struct pktq *q = &qi->q;
-	struct ieee80211_tx_info *tx_info;
+	struct dma_pub *dma;
+	int fifo, ret = -ENOSPC;
+	struct d11txh *txh;
+	u16 frameid = INVALIDFID;
 
-	prec_map = wlc->tx_prec_map;
+	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(skb));
+	dma = wlc->hw->di[fifo];
+	txh = (struct d11txh *)(skb->data);
 
-	/* Send all the enq'd pkts that we can.
-	 * Dequeue packets with precedence with empty HW fifo only
-	 */
-	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
-		tx_info = IEEE80211_SKB_CB(pkt[0]);
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = brcms_c_sendampdu(wlc->ampdu, qi, pkt, prec);
-		} else {
-			count = 1;
-			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
-			if (!err) {
-				for (i = 0; i < count; i++)
-					brcms_c_txfifo(wlc, fifo, pkt[i], true);
-			}
-		}
-
-		if (err == -EBUSY) {
-			brcmu_pktq_penq_head(q, prec, pkt[0]);
-			/*
-			 * If send failed due to any other reason than a
-			 * change in HW FIFO condition, quit. Otherwise,
-			 * read the new prec_map!
-			 */
-			if (prec_map == wlc->tx_prec_map)
-				break;
-			prec_map = wlc->tx_prec_map;
-		}
+	if (dma->txavail == 0) {
+		/*
+		 * We sometimes get a frame from mac80211 after stopping
+		 * the queues. This only ever seems to be a single frame
+		 * and is seems likely to be a race. TX_HEADROOM should
+		 * ensure that we have enough space to handle these stray
+		 * packets, so warn if there isn't. If we're out of space
+		 * in the tx ring and the tx queue isn't stopped then
+		 * we've really got a bug; warn loudly if that happens.
+		 */
+		wiphy_warn(wlc->wiphy,
+			   "Received frame for tx with no space in DMA ring\n");
+		WARN_ON(!ieee80211_queue_stopped(wlc->pub->ieee_hw,
+						 skb_get_queue_mapping(skb)));
+		return -ENOSPC;
 	}
-}
-
-void
-brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
-	       bool commit)
-{
-	u16 frameid = INVALIDFID;
-	struct d11txh *txh;
-
-	txh = (struct d11txh *) (p->data);
 
 	/* When a BC/MC frame is being committed to the BCMC fifo
 	 * via DMA (NOT PIO), update ucode or BSS info as appropriate.
@@ -7301,16 +7158,6 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
 
-	/*
-	 * Bump up pending count for if not using rpc. If rpc is
-	 * used, this will be handled in brcms_b_txfifo()
-	 */
-	if (commit) {
-		wlc->core->txpktpend[fifo] += 1;
-		BCMMSG(wlc->wiphy, "pktpend inc 1 to %d\n",
-			 wlc->core->txpktpend[fifo]);
-	}
-
 	/* Commit BCMC sequence number in the SHM frame ID location */
 	if (frameid != INVALIDFID) {
 		/*
@@ -7320,8 +7167,52 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 		brcms_b_write_shm(wlc->hw, M_BCMC_FID, frameid);
 	}
 
-	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
+	ret = brcms_c_txfifo(wlc, fifo, skb);
+	/*
+	 * The only reason for brcms_c_txfifo to fail is because
+	 * there weren't any DMA descriptors, but we've already
+	 * checked for that. So if it does fail yell loudly.
+	 */
+	WARN_ON_ONCE(ret);
+
+	return ret;
+}
+
+void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+			      struct ieee80211_hw *hw)
+{
+	uint fifo;
+	struct scb *scb = &wlc->pri_scb;
+
+	fifo = brcms_ac_to_fifo(skb_get_queue_mapping(sdu));
+	if (brcms_c_d11hdrs_mac80211(wlc, hw, sdu, scb, 0, 1, fifo, 0))
+		return;
+	if (brcms_c_tx(wlc, sdu))
+		dev_kfree_skb_any(sdu);
+}
+
+int
+brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p)
+{
+	struct dma_pub *dma = wlc->hw->di[fifo];
+	int ret;
+	u16 queue;
+
+	ret = dma_txfast(wlc, dma, p);
+	if (ret	< 0)
 		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
+
+	/*
+	 * Stop queue if DMA ring is full. Reserve some free descriptors,
+	 * as we sometimes receive a frame from mac80211 after the queues
+	 * are stopped.
+	 */
+	queue = skb_get_queue_mapping(p);
+	if (dma->txavail <= TX_HEADROOM && fifo < TX_BCMC_FIFO &&
+	    !ieee80211_queue_stopped(wlc->pub->ieee_hw, queue))
+		ieee80211_stop_queue(wlc->pub->ieee_hw, queue);
+
+	return ret;
 }
 
 u32
@@ -7371,19 +7262,6 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 	return rts_rspec;
 }
 
-void
-brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo)
-{
-	wlc->core->txpktpend[fifo] -= 1;
-	BCMMSG(wlc->wiphy, "pktpend dec 1 to %d\n",
-	       wlc->core->txpktpend[fifo]);
-
-	/* There is more room; mark precedences related to this FIFO sendable */
-	wlc->tx_prec_map |= 1 << fifo;
-
-	/* figure out which bsscfg is being worked on... */
-}
-
 /* Update beacon listen interval in shared memory */
 static void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
@@ -7831,35 +7709,6 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
-/* prepares pdu for transmission. returns BCM error codes */
-int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
-{
-	uint fifo;
-	struct d11txh *txh;
-	struct ieee80211_hdr *h;
-	struct scb *scb;
-
-	txh = (struct d11txh *) (pdu->data);
-	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-
-	/* get the pkt queue info. This was put at brcms_c_sendctl or
-	 * brcms_c_send for PDU */
-	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
-
-	scb = NULL;
-
-	*fifop = fifo;
-
-	/* return if insufficient dma resources */
-	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
-		/* Mark precedences related to this FIFO, unsendable */
-		/* A fifo is full. Clear precedences related to that FIFO */
-		wlc->tx_prec_map &= ~(1 << fifo);
-		return -EBUSY;
-	}
-	return 0;
-}
-
 int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
@@ -7925,13 +7774,15 @@ int brcms_c_get_curband(struct brcms_c_info *wlc)
 void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 {
 	int timeout = 20;
+	int i;
 
-	/* flush packet queue when requested */
-	if (drop)
-		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
+	/* Kick DMA to send any pending AMPDU */
+	for (i = 0; i < ARRAY_SIZE(wlc->hw->di); i++)
+		if (wlc->hw->di[i])
+			dma_txflush(wlc->hw->di[i]);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0) {
+	while (brcms_txpktpendtot(wlc) > 0) {
 		brcms_msleep(wlc->wl, 1);
 
 		if (--timeout == 0)
@@ -8159,10 +8010,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		brcms_rfkill_set_hw_state(wlc->wl);
 	}
 
-	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
 
@@ -8234,9 +8081,6 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	bcma_set16(core, D11REGOFFS(ifs_ctl), IFS_USEEDCF);
 	brcms_c_edcf_setparams(wlc, false);
 
-	/* Init precedence maps for empty FIFOs */
-	brcms_c_tx_prec_map_init(wlc);
-
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
 		wlc->ucode_rev =
@@ -8409,15 +8253,6 @@ brcms_c_attach(struct brcms_info *wl, struct bcma_device *core, uint unit,
 	 * Complete the wlc default state initializations..
 	 */
 
-	/* allocate our initial queue */
-	wlc->pkt_queue = brcms_c_txq_alloc(wlc);
-	if (wlc->pkt_queue == NULL) {
-		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
-			  unit, __func__);
-		err = 100;
-		goto fail;
-	}
-
 	wlc->bsscfg->wlc = wlc;
 
 	wlc->mimoft = FT_HT;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 4e3af67..8a58cc1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -239,7 +239,6 @@ struct brcms_core {
 
 	/* fifo */
 	uint *txavail[NFIFO];	/* # tx descriptors available */
-	s16 txpktpend[NFIFO];	/* tx admission control */
 
 	struct macstat *macstat_snapshot;	/* mac hw prev read values */
 };
@@ -379,19 +378,6 @@ struct brcms_hardware {
 				 */
 };
 
-/* TX Queue information
- *
- * Each flow of traffic out of the device has a TX Queue with independent
- * flow control. Several interfaces may be associated with a single TX Queue
- * if they belong to the same flow of traffic from the device. For multi-channel
- * operation there are independent TX Queues for each channel.
- */
-struct brcms_txq_info {
-	struct brcms_txq_info *next;
-	struct pktq q;
-	uint stopped;		/* tx flow control bits */
-};
-
 /*
  * Principal common driver data structure.
  *
@@ -432,11 +418,8 @@ struct brcms_txq_info {
  * WDlast: last time wlc_watchdog() was called.
  * edcf_txop[IEEE80211_NUM_ACS]: current txop for each ac.
  * wme_retries: per-AC retry limits.
- * tx_prec_map: Precedence map based on HW FIFO space.
- * fifo2prec_map[NFIFO]: pointer to fifo2_prec map based on WME.
  * bsscfg: set of BSS configurations, idx 0 is default and always valid.
  * cfg: the primary bsscfg (can be AP or STA).
- * tx_queues: common TX Queue list.
  * modulecb:
  * mimoft: SIGN or 11N.
  * cck_40txbw: 11N, cck tx b/w override when in 40MHZ mode.
@@ -466,7 +449,6 @@ struct brcms_txq_info {
  * tempsense_lasttime;
  * tx_duty_cycle_ofdm: maximum allowed duty cycle for OFDM.
  * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
- * pkt_queue: txq for transmit packets.
  * wiphy:
  * pri_scb: primary Station Control Block
  */
@@ -530,13 +512,9 @@ struct brcms_c_info {
 	u16 edcf_txop[IEEE80211_NUM_ACS];
 
 	u16 wme_retries[IEEE80211_NUM_ACS];
-	u16 tx_prec_map;
 
 	struct brcms_bss_cfg *bsscfg;
 
-	/* tx queue */
-	struct brcms_txq_info *tx_queues;
-
 	struct modulecb *modulecb;
 
 	u8 mimoft;
@@ -581,7 +559,6 @@ struct brcms_c_info {
 	u16 tx_duty_cycle_ofdm;
 	u16 tx_duty_cycle_cck;
 
-	struct brcms_txq_info *pkt_queue;
 	struct wiphy *wiphy;
 	struct scb pri_scb;
 };
@@ -633,11 +610,8 @@ struct brcms_bss_cfg {
 	struct brcms_bss_info *current_bss;
 };
 
-extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
-			   struct sk_buff *p, bool commit);
-extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo);
-extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
-			    struct sk_buff *sdu);
+extern int brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
+			   struct sk_buff *p);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
@@ -652,9 +626,6 @@ static inline void brcms_c_print_txdesc(struct d11txh *txh)
 
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
 extern void brcms_c_mac_promisc(struct brcms_c_info *wlc, uint filter_flags);
-extern void brcms_c_send_q(struct brcms_c_info *wlc);
-extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
-			    uint *fifo);
 extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 				uint mac_len);
 extern u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 40ccc69..0148dec 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -200,19 +200,6 @@ enum wlc_par_id {
 /* WL11N Support */
 #define AMPDU_AGG_HOST	1
 
-#define	BRCMS_PREC_COUNT	4	/* Max precedence level implemented */
-
-/* Mask to describe all precedence levels */
-#define BRCMS_PREC_BMP_ALL		MAXBITVAL(BRCMS_PREC_COUNT)
-
-/*
- * This maps priority to one precedence higher - Used by PS-Poll response
- * packets to simulate enqueue-at-head operation, but still maintain the
- * order on the queue
- */
-#define BRCMS_PRIO_TO_HI_PREC(pri)	min(BRCMS_PRIO_TO_PREC(pri) + 1,\
-					    BRCMS_PREC_COUNT - 1)
-
 /* network protection config */
 #define	BRCMS_PROT_G_SPEC		1	/* SPEC g protection */
 #define	BRCMS_PROT_G_OVR		2	/* SPEC g prot override */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index e11ae83..e3abc0e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -281,7 +281,6 @@ struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
 struct brcms_hardware;
-struct brcms_txq_info;
 struct brcms_band;
 struct dma_pub;
 struct si_pub;
-- 
1.7.9.5

