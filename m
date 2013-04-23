Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4044 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3DWKzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 06:55:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/5] brcmfmac: add credit borrowing mechanism
Date: Tue, 23 Apr 2013 12:53:15 +0200
Message-ID: <1366714395-13416-6-git-send-email-arend@broadcom.com> (sfid-20130423_125550_927726_B64B3337)
In-Reply-To: <1366714395-13416-1-git-send-email-arend@broadcom.com>
References: <1366714395-13416-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware provides credits to the driver per WMM-AC. When
only AC_BE are to be transmitted to the firmware the driver
may use credits from other priorities to send AC_BE packets
towards the firmware.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   95 ++++++++++++++++++--
 1 file changed, 87 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index f9153b1..5352dc1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -21,6 +21,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/err.h>
+#include <linux/jiffies.h>
 #include <uapi/linux/nl80211.h>
 #include <net/cfg80211.h>
 
@@ -271,6 +272,9 @@ struct brcmf_skbuff_cb {
 	brcmu_maskget32(txs, BRCMF_FWS_TXSTAT_ ## field ## _MASK, \
 			BRCMF_FWS_TXSTAT_ ## field ## _SHIFT)
 
+/* How long to defer borrowing in jiffies */
+#define BRCMF_FWS_BORROW_DEFER_PERIOD		(HZ / 10)
+
 /**
  * enum brcmf_fws_fifo - fifo indices used by dongle firmware.
  *
@@ -425,9 +429,11 @@ struct brcmf_fws_info {
 	struct work_struct fws_dequeue_work;
 	u32 fifo_enqpkt[BRCMF_FWS_FIFO_COUNT];
 	int fifo_credit[BRCMF_FWS_FIFO_COUNT];
+	int credits_borrowed[BRCMF_FWS_FIFO_AC_VO + 1];
 	int deq_node_pos[BRCMF_FWS_FIFO_COUNT];
 	u32 fifo_credit_map;
 	u32 fifo_delay_map;
+	unsigned long borrow_defer_timestamp;
 };
 
 /*
@@ -997,9 +1003,34 @@ static int brcmf_fws_request_indicate(struct brcmf_fws_info *fws, u8 type,
 static void brcmf_fws_return_credits(struct brcmf_fws_info *fws,
 				     u8 fifo, u8 credits)
 {
+	int lender_ac;
+	int *borrowed;
+	int *fifo_credit;
+
 	if (!credits)
 		return;
 
+	if ((fifo == BRCMF_FWS_FIFO_AC_BE) &&
+	    (fws->credits_borrowed[0])) {
+		for (lender_ac = BRCMF_FWS_FIFO_AC_VO; lender_ac >= 0;
+		     lender_ac--) {
+			borrowed = &fws->credits_borrowed[lender_ac];
+			if (*borrowed) {
+				fws->fifo_credit_map |= (1 << lender_ac);
+				fifo_credit = &fws->fifo_credit[lender_ac];
+				if (*borrowed >= credits) {
+					*borrowed -= credits;
+					*fifo_credit += credits;
+					return;
+				} else {
+					credits -= *borrowed;
+					*fifo_credit += *borrowed;
+					*borrowed = 0;
+				}
+			}
+		}
+	}
+
 	fws->fifo_credit_map |= 1 << fifo;
 	fws->fifo_credit[fifo] += credits;
 }
@@ -1658,6 +1689,26 @@ fail:
 		fws->stats.rollback_success++;
 }
 
+static int brcmf_fws_borrow_credit(struct brcmf_fws_info *fws)
+{
+	int lender_ac;
+
+	if (time_after(fws->borrow_defer_timestamp, jiffies))
+		return -ENAVAIL;
+
+	for (lender_ac = 0; lender_ac <= BRCMF_FWS_FIFO_AC_VO; lender_ac++) {
+		if (fws->fifo_credit[lender_ac]) {
+			fws->credits_borrowed[lender_ac]++;
+			fws->fifo_credit[lender_ac]--;
+			if (fws->fifo_credit[lender_ac] == 0)
+				fws->fifo_credit_map &= ~(1 << lender_ac);
+			brcmf_dbg(TRACE, "borrow credit from: %d\n", lender_ac);
+			return 0;
+		}
+	}
+	return -ENAVAIL;
+}
+
 static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 				    struct sk_buff *skb)
 {
@@ -1691,8 +1742,17 @@ static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
 		return 0;
 	}
 
+	if (fifo != BRCMF_FWS_FIFO_AC_BE)
+		fws->borrow_defer_timestamp = jiffies +
+					      BRCMF_FWS_BORROW_DEFER_PERIOD;
+
 	if (!(*credit)) {
-		brcmf_dbg(TRACE, "exit: credits depleted\n");
+		/* Try to borrow a credit from other queue */
+		if (fifo == BRCMF_FWS_FIFO_AC_BE &&
+		    brcmf_fws_borrow_credit(fws) == 0)
+			return 0;
+
+		brcmf_dbg(TRACE, "exit: ac=%d, credits depleted\n", fifo);
 		return -ENAVAIL;
 	}
 	(*credit)--;
@@ -1741,6 +1801,7 @@ rollback:
 int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_fws_info *fws = drvr->fws;
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
 	ulong flags;
@@ -1755,7 +1816,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	if (ntohs(eh->h_proto) == ETH_P_PAE)
 		atomic_inc(&ifp->pend_8021x_cnt);
 
-	if (!brcmf_fws_fc_active(drvr->fws)) {
+	if (!brcmf_fws_fc_active(fws)) {
 		/* If the protocol uses a data header, apply it */
 		brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
 
@@ -1765,7 +1826,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	/* set control buffer information */
 	skcb->if_flags = 0;
-	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifp, eh->h_dest);
+	skcb->mac = brcmf_fws_find_mac_desc(fws, ifp, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
 	if (!multicast)
@@ -1777,15 +1838,17 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	brcmf_fws_lock(drvr, flags);
 	if (skcb->mac->suppressed ||
-	    brcmf_fws_mac_desc_closed(drvr->fws, skcb->mac, fifo) ||
+	    brcmf_fws_mac_desc_closed(fws, skcb->mac, fifo) ||
 	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo * 2)) ||
 	    (!multicast &&
-	     brcmf_fws_consume_credit(drvr->fws, fifo, skb) < 0)) {
+	     brcmf_fws_consume_credit(fws, fifo, skb) < 0)) {
 		/* enqueue the packet in delayQ */
 		drvr->fws->fifo_delay_map |= 1 << fifo;
-		brcmf_fws_enq(drvr->fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
+		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 	} else {
-		brcmf_fws_commit_skb(drvr->fws, fifo, skb);
+		if (brcmf_fws_commit_skb(fws, fifo, skb))
+			if (!multicast)
+				brcmf_skb_pick_up_credit(fws, fifo, skb);
 	}
 	brcmf_fws_unlock(drvr, flags);
 	return 0;
@@ -1858,7 +1921,23 @@ static void brcmf_fws_dequeue_worker(struct work_struct *worker)
 			    BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)
 				credit++;
 		}
-		fws->fifo_credit[fifo] -= credit;
+		if ((fifo == BRCMF_FWS_FIFO_AC_BE) &&
+		    (credit == fws->fifo_credit[fifo])) {
+			fws->fifo_credit[fifo] -= credit;
+			while (brcmf_fws_borrow_credit(fws) == 0) {
+				skb = brcmf_fws_deq(fws, fifo);
+				if (!skb) {
+					brcmf_fws_return_credits(fws, fifo, 1);
+					break;
+				}
+				if (brcmf_fws_commit_skb(fws, fifo, skb)) {
+					brcmf_fws_return_credits(fws, fifo, 1);
+					break;
+				}
+			}
+		} else {
+			fws->fifo_credit[fifo] -= credit;
+		}
 	}
 	brcmf_fws_unlock(fws->drvr, flags);
 }
-- 
1.7.10.4


