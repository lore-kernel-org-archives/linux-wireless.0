Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3591 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753693Ab1DRNcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:32:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] staging: brcm80211: rename active_queue identifier
Date: Mon, 18 Apr 2011 15:31:47 +0200
Message-ID: <1303133511-8300-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1303133511-8300-1-git-send-email-arend@broadcom.com>
References: <1303133511-8300-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue for pending transmit packets is called active_queue, but
the driver is only using one single queue. Therefor a more appro-
priate name has been given, ie. pkt_queue.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c  |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |   22 ++++++++++------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h  |    4 +---
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index dfdcc83..1950ae0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1140,7 +1140,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = GETNEXTTXP(wlc, queue);
 	}
-	wlc_send_q(wlc, wlc->active_queue);
+	wlc_send_q(wlc, wlc->pkt_queue);
 
 	/* update rate state */
 	antselid = wlc_antsel_antsel2id(wlc->asi, mimoantsel);
@@ -1347,7 +1347,7 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 void wlc_ampdu_flush(struct wlc_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct wlc_txq_info *qi = wlc->active_queue;
+	struct wlc_txq_info *qi = wlc->pkt_queue;
 	struct pktq *pq = &qi->q;
 	int prec;
 	struct cb_del_ampdu_pars ampdu_pars;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 7be3fa1..a8520ee 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -417,8 +417,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
@@ -3077,8 +3077,8 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	if (n >= max_tx_num)
 		morepending = true;
 
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 
 	return morepending;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 3e5d884..b01c9f5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -1612,7 +1612,6 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	uint err = 0;
 	uint j;
 	struct wlc_pub *pub;
-	struct wlc_txq_info *qi;
 	uint n_disabled;
 
 	no_printk("wl%d: %s: vendor 0x%x device 0x%x\n",
@@ -1781,14 +1780,13 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	 */
 
 	/* allocate our initial queue */
-	qi = wlc_txq_alloc(wlc);
-	if (qi == NULL) {
+	wlc->pkt_queue = wlc_txq_alloc(wlc);
+	if (wlc->pkt_queue == NULL) {
 		dev_err(dev, "wl%d: %s: failed to malloc tx queue\n",
 			 unit, __func__);
 		err = 100;
 		goto fail;
 	}
-	wlc->active_queue = qi;
 
 	wlc->bsscfg[0] = wlc->cfg;
 	wlc->cfg->_idx = 0;
@@ -4886,7 +4884,7 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			     uint prec)
 {
 	struct wlc_info *wlc = (struct wlc_info *) ctx;
-	struct wlc_txq_info *qi = wlc->active_queue;	/* Check me */
+	struct wlc_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
 	int prio;
 
@@ -4942,7 +4940,7 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
 	wlc_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
-	wlc_send_q(wlc, wlc->active_queue);
+	wlc_send_q(wlc, wlc->pkt_queue);
 
 	wlc->pub->_cnt->ieee_tx++;
 	return 0;
@@ -4958,8 +4956,8 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi)
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
-	/* only do work for the active queue */
-	if (qi != wlc->active_queue)
+	/* only do work for the packet queue */
+	if (qi != wlc->pkt_queue)
 		return;
 
 	if (in_send_q)
@@ -6183,8 +6181,8 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	}
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 }
 
 static void wlc_war16165(struct wlc_info *wlc, bool tx)
@@ -8102,10 +8100,10 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 {
 	/* flush packet queue when requested */
 	if (drop)
-		pktq_flush(&wlc->active_queue->q, false, NULL, 0);
+		pktq_flush(&wlc->pkt_queue->q, false, NULL, 0);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->active_queue->q) ||
+	while (!pktq_empty(&wlc->pkt_queue->q) ||
 	       TXPKTPENDTOT(wlc) > 0) {
 		wl_msleep(wlc->wl, 1);
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 3a34870..3d7df6f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -743,9 +743,7 @@ struct wlc_info {
 	u16 next_bsscfg_ID;
 
 	struct wlc_if *wlcif_list;	/* linked list of wlc_if structs */
-	struct wlc_txq_info *active_queue; /* txq for the currently active
-					    * transmit context
-					    */
+	struct wlc_txq_info *pkt_queue; /* txq for transmit packets */
 	u32 mpc_dur;		/* total time (ms) in mpc mode except for the
 				 * portion since radio is turned off last time
 				 */
-- 
1.7.1


