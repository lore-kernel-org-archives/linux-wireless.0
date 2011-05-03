Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1670 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab1ECJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 29/61] staging: brcm80211: rename active_queue
 identifier
Date: Tue, 3 May 2011 11:35:29 +0200
Message-ID: <1304415361-7813-30-git-send-email-arend@broadcom.com> (sfid-20110503_113808_140252_5A1E7C44)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue for pending transmit packets is called active_queue, but
the driver is only using one single queue. Therefor a more appro-
priate name has been given, ie. pkt_queue.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c  |    8 ++++----
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |   22 ++++++++++------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h  |    4 +---
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 04493e9..1a3f2ea6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1133,7 +1133,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = GETNEXTTXP(wlc, queue);
 	}
-	wlc_send_q(wlc, wlc->active_queue);
+	wlc_send_q(wlc, wlc->pkt_queue);
 
 	/* update rate state */
 	antselid = wlc_antsel_antsel2id(wlc->asi, mimoantsel);
@@ -1340,7 +1340,7 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
 void wlc_ampdu_flush(struct wlc_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct wlc_txq_info *qi = wlc->active_queue;
+	struct wlc_txq_info *qi = wlc->pkt_queue;
 	struct pktq *pq = &qi->q;
 	int prec;
 	struct cb_del_ampdu_pars ampdu_pars;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index e91be42..bf87343 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -419,8 +419,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
@@ -3087,8 +3087,8 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	if (n >= max_tx_num)
 		morepending = true;
 
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 
 	return morepending;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index c4e7178..adece8c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -1615,7 +1615,6 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	uint err = 0;
 	uint j;
 	struct wlc_pub *pub;
-	struct wlc_txq_info *qi;
 	uint n_disabled;
 
 	/* allocate struct wlc_info state and its substructures */
@@ -1781,14 +1780,13 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	 */
 
 	/* allocate our initial queue */
-	qi = wlc_txq_alloc(wlc);
-	if (qi == NULL) {
+	wlc->pkt_queue = wlc_txq_alloc(wlc);
+	if (wlc->pkt_queue == NULL) {
 		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
 			  unit, __func__);
 		err = 100;
 		goto fail;
 	}
-	wlc->active_queue = qi;
 
 	wlc->bsscfg[0] = wlc->cfg;
 	wlc->cfg->_idx = 0;
@@ -4879,7 +4877,7 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			     uint prec)
 {
 	struct wlc_info *wlc = (struct wlc_info *) ctx;
-	struct wlc_txq_info *qi = wlc->active_queue;	/* Check me */
+	struct wlc_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
 	int prio;
 
@@ -4935,7 +4933,7 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
 	wlc_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
-	wlc_send_q(wlc, wlc->active_queue);
+	wlc_send_q(wlc, wlc->pkt_queue);
 
 	wlc->pub->_cnt->ieee_tx++;
 	return 0;
@@ -4951,8 +4949,8 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi)
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
-	/* only do work for the active queue */
-	if (qi != wlc->active_queue)
+	/* only do work for the packet queue */
+	if (qi != wlc->pkt_queue)
 		return;
 
 	if (in_send_q)
@@ -6184,8 +6182,8 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	}
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->active_queue->q))
-		wlc_send_q(wlc, wlc->active_queue);
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		wlc_send_q(wlc, wlc->pkt_queue);
 }
 
 static void wlc_war16165(struct wlc_info *wlc, bool tx)
@@ -8109,10 +8107,10 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
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
index 6dc029e..0c185b5 100644
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
1.7.4.1


