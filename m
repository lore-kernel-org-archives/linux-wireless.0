Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4625 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab1KJTaz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:55 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/19] brcm80211: util: use sk_buff_head in precedence
 queue functions
Date: Thu, 10 Nov 2011 20:30:27 +0100
Message-ID: <1320953434-16859-14-git-send-email-arend@broadcom.com> (sfid-20111110_203123_755833_43B74246)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of dealing with sk_buff prev pointers the queue functions
now make use of the sk_buff_head functions provided by the kernel.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |  121 +++++--------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |   16 +--
 2 files changed, 39 insertions(+), 98 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 12b795f..57e656f 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -86,21 +86,13 @@ EXPORT_SYMBOL(brcmu_pkttotlen);
 struct sk_buff *brcmu_pktq_penq(struct pktq *pq, int prec,
 				      struct sk_buff *p)
 {
-	struct pktq_prec *q;
+	struct sk_buff_head *q;
 
 	if (pktq_full(pq) || pktq_pfull(pq, prec))
 		return NULL;
 
-	q = &pq->q[prec];
-
-	if (q->head)
-		q->tail->prev = p;
-	else
-		q->head = p;
-
-	q->tail = p;
-	q->len++;
-
+	q = &pq->q[prec].skblist;
+	skb_queue_tail(q, p);
 	pq->len++;
 
 	if (pq->hi_prec < prec)
@@ -113,20 +105,13 @@ EXPORT_SYMBOL(brcmu_pktq_penq);
 struct sk_buff *brcmu_pktq_penq_head(struct pktq *pq, int prec,
 					   struct sk_buff *p)
 {
-	struct pktq_prec *q;
+	struct sk_buff_head *q;
 
 	if (pktq_full(pq) || pktq_pfull(pq, prec))
 		return NULL;
 
-	q = &pq->q[prec];
-
-	if (q->head == NULL)
-		q->tail = p;
-
-	p->prev = q->head;
-	q->head = p;
-	q->len++;
-
+	q = &pq->q[prec].skblist;
+	skb_queue_head(q, p);
 	pq->len++;
 
 	if (pq->hi_prec < prec)
@@ -138,53 +123,30 @@ EXPORT_SYMBOL(brcmu_pktq_penq_head);
 
 struct sk_buff *brcmu_pktq_pdeq(struct pktq *pq, int prec)
 {
-	struct pktq_prec *q;
+	struct sk_buff_head *q;
 	struct sk_buff *p;
 
-	q = &pq->q[prec];
-
-	p = q->head;
+	q = &pq->q[prec].skblist;
+	p = skb_dequeue(q);
 	if (p == NULL)
 		return NULL;
 
-	q->head = p->prev;
-	if (q->head == NULL)
-		q->tail = NULL;
-
-	q->len--;
-
 	pq->len--;
-
-	p->prev = NULL;
-
 	return p;
 }
 EXPORT_SYMBOL(brcmu_pktq_pdeq);
 
 struct sk_buff *brcmu_pktq_pdeq_tail(struct pktq *pq, int prec)
 {
-	struct pktq_prec *q;
-	struct sk_buff *p, *prev;
-
-	q = &pq->q[prec];
+	struct sk_buff_head *q;
+	struct sk_buff *p;
 
-	p = q->head;
+	q = &pq->q[prec].skblist;
+	p = skb_dequeue_tail(q);
 	if (p == NULL)
 		return NULL;
 
-	for (prev = NULL; p != q->tail; p = p->prev)
-		prev = p;
-
-	if (prev)
-		prev->prev = NULL;
-	else
-		q->head = NULL;
-
-	q->tail = prev;
-	q->len--;
-
 	pq->len--;
-
 	return p;
 }
 EXPORT_SYMBOL(brcmu_pktq_pdeq_tail);
@@ -193,31 +155,17 @@ void
 brcmu_pktq_pflush(struct pktq *pq, int prec, bool dir,
 		  bool (*fn)(struct sk_buff *, void *), void *arg)
 {
-	struct pktq_prec *q;
-	struct sk_buff *p, *prev = NULL;
+	struct sk_buff_head *q;
+	struct sk_buff *p, *next;
 
-	q = &pq->q[prec];
-	p = q->head;
-	while (p) {
+	q = &pq->q[prec].skblist;
+	skb_queue_walk_safe(q, p, next) {
 		if (fn == NULL || (*fn) (p, arg)) {
-			bool head = (p == q->head);
-			if (head)
-				q->head = p->prev;
-			else
-				prev->prev = p->prev;
-			p->prev = NULL;
+			skb_unlink(p, q);
 			brcmu_pkt_buf_free_skb(p);
-			q->len--;
 			pq->len--;
-			p = (head ? q->head : prev->prev);
-		} else {
-			prev = p;
-			p = p->prev;
 		}
 	}
-
-	if (q->head == NULL)
-		q->tail = NULL;
 }
 EXPORT_SYMBOL(brcmu_pktq_pflush);
 
@@ -242,8 +190,10 @@ void brcmu_pktq_init(struct pktq *pq, int num_prec, int max_len)
 
 	pq->max = (u16) max_len;
 
-	for (prec = 0; prec < num_prec; prec++)
+	for (prec = 0; prec < num_prec; prec++) {
 		pq->q[prec].max = pq->max;
+		skb_queue_head_init(&pq->q[prec].skblist);
+	}
 }
 EXPORT_SYMBOL(brcmu_pktq_init);
 
@@ -255,13 +205,13 @@ struct sk_buff *brcmu_pktq_peek_tail(struct pktq *pq, int *prec_out)
 		return NULL;
 
 	for (prec = 0; prec < pq->hi_prec; prec++)
-		if (pq->q[prec].head)
+		if (!skb_queue_empty(&pq->q[prec].skblist))
 			break;
 
 	if (prec_out)
 		*prec_out = prec;
 
-	return pq->q[prec].tail;
+	return skb_peek_tail(&pq->q[prec].skblist);
 }
 EXPORT_SYMBOL(brcmu_pktq_peek_tail);
 
@@ -274,7 +224,7 @@ int brcmu_pktq_mlen(struct pktq *pq, uint prec_bmp)
 
 	for (prec = 0; prec <= pq->hi_prec; prec++)
 		if (prec_bmp & (1 << prec))
-			len += pq->q[prec].len;
+			len += pq->q[prec].skblist.qlen;
 
 	return len;
 }
@@ -284,39 +234,32 @@ EXPORT_SYMBOL(brcmu_pktq_mlen);
 struct sk_buff *brcmu_pktq_mdeq(struct pktq *pq, uint prec_bmp,
 				      int *prec_out)
 {
-	struct pktq_prec *q;
+	struct sk_buff_head *q;
 	struct sk_buff *p;
 	int prec;
 
 	if (pq->len == 0)
 		return NULL;
 
-	while ((prec = pq->hi_prec) > 0 && pq->q[prec].head == NULL)
+	while ((prec = pq->hi_prec) > 0 &&
+	       skb_queue_empty(&pq->q[prec].skblist))
 		pq->hi_prec--;
 
-	while ((prec_bmp & (1 << prec)) == 0 || pq->q[prec].head == NULL)
+	while ((prec_bmp & (1 << prec)) == 0 ||
+	       skb_queue_empty(&pq->q[prec].skblist))
 		if (prec-- == 0)
 			return NULL;
 
-	q = &pq->q[prec];
-
-	p = q->head;
+	q = &pq->q[prec].skblist;
+	p = skb_dequeue(q);
 	if (p == NULL)
 		return NULL;
 
-	q->head = p->prev;
-	if (q->head == NULL)
-		q->tail = NULL;
-
-	q->len--;
+	pq->len--;
 
 	if (prec_out)
 		*prec_out = prec;
 
-	pq->len--;
-
-	p->prev = NULL;
-
 	return p;
 }
 EXPORT_SYMBOL(brcmu_pktq_mdeq);
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index ccf6015..cae4e51 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -65,9 +65,7 @@
 #define ETHER_ADDR_STR_LEN	18
 
 struct pktq_prec {
-	struct sk_buff *head;	/* first packet to dequeue */
-	struct sk_buff *tail;	/* last packet to dequeue */
-	u16 len;		/* number of queued packets */
+	struct sk_buff_head skblist;
 	u16 max;		/* maximum number of queued packets */
 };
 
@@ -88,32 +86,32 @@ struct pktq {
 
 static inline int pktq_plen(struct pktq *pq, int prec)
 {
-	return pq->q[prec].len;
+	return pq->q[prec].skblist.qlen;
 }
 
 static inline int pktq_pavail(struct pktq *pq, int prec)
 {
-	return pq->q[prec].max - pq->q[prec].len;
+	return pq->q[prec].max - pq->q[prec].skblist.qlen;
 }
 
 static inline bool pktq_pfull(struct pktq *pq, int prec)
 {
-	return pq->q[prec].len >= pq->q[prec].max;
+	return pq->q[prec].skblist.qlen >= pq->q[prec].max;
 }
 
 static inline bool pktq_pempty(struct pktq *pq, int prec)
 {
-	return pq->q[prec].len == 0;
+	return skb_queue_empty(&pq->q[prec].skblist);
 }
 
 static inline struct sk_buff *pktq_ppeek(struct pktq *pq, int prec)
 {
-	return pq->q[prec].head;
+	return skb_peek(&pq->q[prec].skblist);
 }
 
 static inline struct sk_buff *pktq_ppeek_tail(struct pktq *pq, int prec)
 {
-	return pq->q[prec].tail;
+	return skb_peek_tail(&pq->q[prec].skblist);
 }
 
 extern struct sk_buff *brcmu_pktq_penq(struct pktq *pq, int prec,
-- 
1.7.5.4


