Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55613 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751278Ab1EORus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 13:50:48 -0400
Received: from localhost.darmstadt.cn-net.local (laptopcn-vpn.darmstadt.cn-net.local [10.45.9.34])
	by rose.darmstadt.cn-net.local (8.14.4/8.14.4) with ESMTP id p4FHoNqb032087
	for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 19:50:24 +0200
Received: from localhost.darmstadt.cn-net.local (localhost [127.0.0.1])
	by localhost (8.14.4/8.14.4) with ESMTP id p4FH6ADM024689
	for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 19:06:30 +0200
From: Clemens Noss <cnoss@gmx.de>
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, rvossen@broadcom.com, henryp@broadcom.com,
	brudley@broadcom.com
Subject: [PATCH] staging: brcm80211: fix cast to pointer from integer
Date: Sun, 15 May 2011 19:04:20 +0200
Message-Id: <1305479060-22755-1-git-send-email-cnoss@gmx.de> (sfid-20110515_195053_309636_BDC703AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcm_pktq_flush and related functions only ever get 0 or a pointer for
arg, so make it a pointer.

This might fix a crash on 64bit.

Signed-off-by: Clemens Noss <cnoss@gmx.de>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |    4 ++--
 drivers/staging/brcm80211/include/bcmutils.h   |    6 +++---
 drivers/staging/brcm80211/util/bcmutils.c      |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8683eeb..a71c6f8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2845,7 +2845,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	dhdsdio_clkctl(bus, CLK_SDONLY, false);
 
 	/* Clear the data packet queues */
-	bcm_pktq_flush(&bus->txq, true, NULL, 0);
+	bcm_pktq_flush(&bus->txq, true, NULL, NULL);
 
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 5b041a6..0d93bd6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1225,7 +1225,7 @@ void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
 /*
  * callback function that helps flushing ampdu packets from a priority queue
  */
-static bool cb_del_ampdu_pkt(void *p, int arg_a)
+static bool cb_del_ampdu_pkt(void *p, void *arg_a)
 {
 	struct sk_buff *mpdu = (struct sk_buff *)p;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(mpdu);
@@ -1269,7 +1269,7 @@ void wlc_ampdu_flush(struct wlc_info *wlc,
 	ampdu_pars.tid = tid;
 	for (prec = 0; prec < pq->num_prec; prec++) {
 		bcm_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
-			    (int)&ampdu_pars);
+			    (void *)&ampdu_pars);
 	}
 	wlc_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 2fed0eb..926b01a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -2520,7 +2520,7 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		bcm_pktq_flush(&qi->q, true, NULL, 0);
+		bcm_pktq_flush(&qi->q, true, NULL, NULL);
 	}
 
 	callbacks += wlc_bmac_down_finish(wlc->hw);
@@ -8135,7 +8135,7 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 {
 	/* flush packet queue when requested */
 	if (drop)
-		bcm_pktq_flush(&wlc->pkt_queue->q, false, NULL, 0);
+		bcm_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
 	/* wait for queue and DMA fifos to run dry */
 	while (!pktq_empty(&wlc->pkt_queue->q) ||
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index aa00e83..1d57934 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -74,7 +74,7 @@
 #define PKTQ_PREC_ITER(pq, prec)        for (prec = (pq)->num_prec - 1; prec >= 0; prec--)
 
 /* fn(pkt, arg).  return true if pkt belongs to if */
-	typedef bool(*ifpkt_cb_t) (void *, int);
+	typedef bool(*ifpkt_cb_t) (void *, void *);
 
 /* operations on a specific precedence in packet queue */
 
@@ -100,7 +100,7 @@ extern void bcm_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
 extern void bcm_pktq_pflush(struct pktq *pq, int prec,
-	bool dir, ifpkt_cb_t fn, int arg);
+	bool dir, ifpkt_cb_t fn, void *arg);
 
 /* operations on a set of precedences in packet queue */
 
@@ -127,7 +127,7 @@ extern void bcm_pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
 extern struct sk_buff *bcm_pktq_peek_tail(struct pktq *pq, int *prec_out);
 extern void bcm_pktq_flush(struct pktq *pq, bool dir,
-	ifpkt_cb_t fn, int arg);
+	ifpkt_cb_t fn, void *arg);
 
 /* externs */
 /* packet */
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index e185e28..43e5bb3 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -231,7 +231,7 @@ EXPORT_SYMBOL(bcm_pktq_pdeq_tail);
 
 void
 bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
-	    ifpkt_cb_t fn, int arg)
+	    ifpkt_cb_t fn, void *arg)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev = NULL;
@@ -263,7 +263,7 @@ bcm_pktq_pflush(struct pktq *pq, int prec, bool dir,
 EXPORT_SYMBOL(bcm_pktq_pflush);
 
 void bcm_pktq_flush(struct pktq *pq, bool dir,
-		ifpkt_cb_t fn, int arg)
+		ifpkt_cb_t fn, void *arg)
 {
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
-- 
1.7.4.5

