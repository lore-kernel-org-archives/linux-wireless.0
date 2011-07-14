Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4354 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/35] staging: brcm80211: removed function declaration
 typedefs from brcmutil
Date: Thu, 14 Jul 2011 14:29:08 -0700
Message-ID: <1310678971-28952-13-git-send-email-frankyl@broadcom.com> (sfid-20110714_233239_496961_363F97D9)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac related code cleanup. Typedefs are undesirable according to the
CodingStyle document.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmutil/utils.c      |    4 ++--
 drivers/staging/brcm80211/include/brcmu_utils.h |    8 +++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 37b6b77..cad1600 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -219,7 +219,7 @@ EXPORT_SYMBOL(brcmu_pktq_pdeq_tail);
 
 void
 brcmu_pktq_pflush(struct pktq *pq, int prec, bool dir,
-	    ifpkt_cb_t fn, void *arg)
+		  bool (*fn)(struct sk_buff *, void *), void *arg)
 {
 	struct pktq_prec *q;
 	struct sk_buff *p, *prev = NULL;
@@ -251,7 +251,7 @@ brcmu_pktq_pflush(struct pktq *pq, int prec, bool dir,
 EXPORT_SYMBOL(brcmu_pktq_pflush);
 
 void brcmu_pktq_flush(struct pktq *pq, bool dir,
-		ifpkt_cb_t fn, void *arg)
+		      bool (*fn)(struct sk_buff *, void *), void *arg)
 {
 	int prec;
 	for (prec = 0; prec < pq->num_prec; prec++)
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 2d54cc5..8a340f0 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -72,9 +72,6 @@ struct pktq {
 	struct pktq_prec q[PKTQ_MAX_PREC];
 };
 
-/* fn(pkt, arg).  return true if pkt belongs to if */
-typedef bool(*ifpkt_cb_t) (struct sk_buff *, void *);
-
 /* operations on a specific precedence in packet queue */
 
 #define pktq_psetmax(pq, prec, _max)    ((pq)->q[prec].max = (_max))
@@ -98,8 +95,9 @@ extern struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
 extern void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
+/* callback function fn(pkt, arg) returns true if pkt belongs to if */
 extern void brcmu_pktq_pflush(struct pktq *pq, int prec,
-	bool dir, ifpkt_cb_t fn, void *arg);
+	bool dir, bool (*fn)(struct sk_buff *, void *), void *arg);
 
 /* operations on a set of precedences in packet queue */
 
@@ -127,7 +125,7 @@ extern void brcmu_pktq_init(struct pktq *pq, int num_prec, int max_len);
 /* prec_out may be NULL if caller is not interested in return value */
 extern struct sk_buff *brcmu_pktq_peek_tail(struct pktq *pq, int *prec_out);
 extern void brcmu_pktq_flush(struct pktq *pq, bool dir,
-	ifpkt_cb_t fn, void *arg);
+		bool (*fn)(struct sk_buff *, void *), void *arg);
 
 /* externs */
 /* packet */
-- 
1.7.1


