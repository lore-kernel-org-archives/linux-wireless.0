Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2018 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/13] brcmutil: add dequeue function with filtering
Date: Sun, 3 Mar 2013 12:45:31 +0100
Message-ID: <1362311132-29561-13-git-send-email-arend@broadcom.com> (sfid-20130303_124608_546363_275858C4)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding a packet dequeue function that will return packets that
pass the provided match function.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   25 ++++++++++++++++++++
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    4 +++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 3e6405e..bf5e50f 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -116,6 +116,31 @@ struct sk_buff *brcmu_pktq_pdeq(struct pktq *pq, int prec)
 }
 EXPORT_SYMBOL(brcmu_pktq_pdeq);
 
+/*
+ * precedence based dequeue with match function. Passing a NULL pointer
+ * for the match function parameter is considered to be a wildcard so
+ * any packet on the queue is returned. In that case it is no different
+ * from brcmu_pktq_pdeq() above.
+ */
+struct sk_buff *brcmu_pktq_pdeq_match(struct pktq *pq, int prec,
+				      bool (*match_fn)(struct sk_buff *skb,
+						       void *arg), void *arg)
+{
+	struct sk_buff_head *q;
+	struct sk_buff *p, *next;
+
+	q = &pq->q[prec].skblist;
+	skb_queue_walk_safe(q, p, next) {
+		if (match_fn == NULL || match_fn(p, arg)) {
+			skb_unlink(p, q);
+			pq->len--;
+			return p;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(brcmu_pktq_pdeq_match);
+
 struct sk_buff *brcmu_pktq_pdeq_tail(struct pktq *pq, int prec)
 {
 	struct sk_buff_head *q;
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index 82fcfe8..898cacb 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -120,6 +120,10 @@ extern struct sk_buff *brcmu_pktq_penq_head(struct pktq *pq, int prec,
 				      struct sk_buff *p);
 extern struct sk_buff *brcmu_pktq_pdeq(struct pktq *pq, int prec);
 extern struct sk_buff *brcmu_pktq_pdeq_tail(struct pktq *pq, int prec);
+extern struct sk_buff *brcmu_pktq_pdeq_match(struct pktq *pq, int prec,
+					     bool (*match_fn)(struct sk_buff *p,
+							      void *arg),
+					     void *arg);
 
 /* packet primitives */
 extern struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
-- 
1.7.6


