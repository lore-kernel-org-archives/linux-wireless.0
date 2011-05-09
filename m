Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3188 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab1EIOdI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:08 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Henry Ptasinski" <henryp@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 2/4] staging: brcm80211: use common pktq_flush functions
Date: Mon, 9 May 2011 16:32:54 +0200
Message-ID: <1304951576-2351-3-git-send-email-arend@broadcom.com> (sfid-20110509_163606_940113_F02389FE)
In-Reply-To: <1304951576-2351-1-git-send-email-arend@broadcom.com>
References: <1304951576-2351-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The softmac and fullmac drivers can use the same implementation of
pktq_flush(), so remove the unnecessary version.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    2 +-
 drivers/staging/brcm80211/include/bcmutils.h  |   13 +----------
 drivers/staging/brcm80211/util/bcmutils.c     |   27 -------------------------
 3 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4bfd8d8..c1d22c8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2835,7 +2835,7 @@ void dhd_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	dhdsdio_clkctl(bus, CLK_SDONLY, false);
 
 	/* Clear the data packet queues */
-	pktq_flush(&bus->txq, true);
+	pktq_flush(&bus->txq, true, NULL, 0);
 
 	/* Clear any held glomming stuff */
 	if (bus->glomd)
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 0dd63a2..d83a504 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -99,13 +99,8 @@ extern struct sk_buff *pkt_buf_get_skb(uint len);
 extern void pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
-#ifdef BRCM_FULLMAC
-	extern void pktq_pflush(struct pktq *pq, int prec,
-		bool dir);
-#else
-	extern void pktq_pflush(struct pktq *pq, int prec,
-		bool dir, ifpkt_cb_t fn, int arg);
-#endif /* BRCM_FULLMAC */
+extern void pktq_pflush(struct pktq *pq, int prec,
+	bool dir, ifpkt_cb_t fn, int arg);
 
 /* operations on a set of precedences in packet queue */
 
@@ -130,12 +125,8 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 	extern void pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
 	extern struct sk_buff *pktq_peek_tail(struct pktq *pq, int *prec_out);
-#ifdef BRCM_FULLMAC
-	extern void pktq_flush(struct pktq *pq, bool dir);
-#else
 	extern void pktq_flush(struct pktq *pq, bool dir,
 		ifpkt_cb_t fn, int arg);
-#endif
 
 /* externs */
 /* packet */
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 7337a75..95214cf 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -213,32 +213,6 @@ struct sk_buff *BCMFASTPATH pktq_pdeq_tail(struct pktq *pq, int prec)
 	return p;
 }
 
-#ifdef BRCM_FULLMAC
-void pktq_pflush(struct pktq *pq, int prec, bool dir)
-{
-	struct pktq_prec *q;
-	struct sk_buff *p;
-
-	q = &pq->q[prec];
-	p = q->head;
-	while (p) {
-		q->head = p->prev;
-		p->prev = NULL;
-		pkt_buf_free_skb(p);
-		q->len--;
-		pq->len--;
-		p = q->head;
-	}
-	q->tail = NULL;
-}
-
-void pktq_flush(struct pktq *pq, bool dir)
-{
-	int prec;
-	for (prec = 0; prec < pq->num_prec; prec++)
-		pktq_pflush(pq, prec, dir);
-}
-#else /* !BRCM_FULLMAC */
 void
 pktq_pflush(struct pktq *pq, int prec, bool dir,
 	    ifpkt_cb_t fn, int arg)
@@ -278,7 +252,6 @@ void pktq_flush(struct pktq *pq, bool dir,
 	for (prec = 0; prec < pq->num_prec; prec++)
 		pktq_pflush(pq, prec, dir, fn, arg);
 }
-#endif /* BRCM_FULLMAC */
 
 void pktq_init(struct pktq *pq, int num_prec, int max_len)
 {
-- 
1.7.4.1


