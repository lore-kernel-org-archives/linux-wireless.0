Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21515 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757Ab2FFKID (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:03 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 23/29] NFC: Requeue lost LLCP frames
Date: Wed,  6 Jun 2012 12:16:40 +0200
Message-Id: <1338977806-30279-24-git-send-email-sameo@linux.intel.com> (sfid-20120606_120814_338365_8B3C2E75)
In-Reply-To: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
References: <1338977806-30279-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving an I or RR frame telling us that some of the pending queues
were not received, we should requeue them before the currently pending ones.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   86 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index b694313..0fc60da 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -411,28 +411,6 @@ int nfc_llcp_set_remote_gb(struct nfc_dev *dev, u8 *gb, u8 gb_len)
 				     local->remote_gb_len - 3);
 }
 
-static void nfc_llcp_tx_work(struct work_struct *work)
-{
-	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
-						    tx_work);
-	struct sk_buff *skb;
-
-	skb = skb_dequeue(&local->tx_queue);
-	if (skb != NULL) {
-		pr_debug("Sending pending skb\n");
-		print_hex_dump(KERN_DEBUG, "LLCP Tx: ", DUMP_PREFIX_OFFSET,
-			       16, 1, skb->data, skb->len, true);
-
-		nfc_data_exchange(local->dev, local->target_idx,
-				  skb, nfc_llcp_recv, local);
-	} else {
-		nfc_llcp_send_symm(local->dev);
-	}
-
-	mod_timer(&local->link_timer,
-		  jiffies + msecs_to_jiffies(local->remote_lto));
-}
-
 static u8 nfc_llcp_dsap(struct sk_buff *pdu)
 {
 	return (pdu->data[0] & 0xfc) >> 2;
@@ -465,6 +443,45 @@ static void nfc_llcp_set_nrns(struct nfc_llcp_sock *sock, struct sk_buff *pdu)
 	sock->recv_ack_n = (sock->recv_n - 1) % 16;
 }
 
+static void nfc_llcp_tx_work(struct work_struct *work)
+{
+	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
+						    tx_work);
+	struct sk_buff *skb;
+	struct sock *sk;
+	struct nfc_llcp_sock *llcp_sock;
+
+	skb = skb_dequeue(&local->tx_queue);
+	if (skb != NULL) {
+		sk = skb->sk;
+		llcp_sock = nfc_llcp_sock(sk);
+		if (llcp_sock != NULL) {
+			int ret;
+
+			pr_debug("Sending pending skb\n");
+			print_hex_dump(KERN_DEBUG, "LLCP Tx: ",
+				       DUMP_PREFIX_OFFSET, 16, 1,
+				       skb->data, skb->len, true);
+
+			ret = nfc_data_exchange(local->dev, local->target_idx,
+						skb, nfc_llcp_recv, local);
+
+			if (!ret && nfc_llcp_ptype(skb) == LLCP_PDU_I) {
+				skb = skb_get(skb);
+				skb_queue_tail(&llcp_sock->tx_pending_queue,
+					       skb);
+			}
+		} else {
+			nfc_llcp_send_symm(local->dev);
+		}
+	} else {
+		nfc_llcp_send_symm(local->dev);
+	}
+
+	mod_timer(&local->link_timer,
+		  jiffies + msecs_to_jiffies(2 * local->remote_lto));
+}
+
 static struct nfc_llcp_sock *nfc_llcp_connecting_sock_get(struct nfc_llcp_local *local,
 							  u8 ssap)
 {
@@ -705,7 +722,7 @@ int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 	/* Try to queue some I frames for transmission */
 	while (sock->remote_ready &&
 	       skb_queue_len(&sock->tx_pending_queue) < sock->rw) {
-		struct sk_buff *pdu, *pending_pdu;
+		struct sk_buff *pdu;
 
 		pdu = skb_dequeue(&sock->tx_queue);
 		if (pdu == NULL)
@@ -714,10 +731,7 @@ int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 		/* Update N(S)/N(R) */
 		nfc_llcp_set_nrns(sock, pdu);
 
-		pending_pdu = skb_clone(pdu, GFP_KERNEL);
-
 		skb_queue_tail(&local->tx_queue, pdu);
-		skb_queue_tail(&sock->tx_pending_queue, pending_pdu);
 		nr_frames++;
 	}
 
@@ -774,11 +788,21 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 
 		llcp_sock->send_ack_n = nr;
 
-		skb_queue_walk_safe(&llcp_sock->tx_pending_queue, s, tmp)
-			if (nfc_llcp_ns(s) <= nr) {
-				skb_unlink(s, &llcp_sock->tx_pending_queue);
-				kfree_skb(s);
-			}
+		/* Remove and free all skbs until ns == nr */
+		skb_queue_walk_safe(&llcp_sock->tx_pending_queue, s, tmp) {
+			skb_unlink(s, &llcp_sock->tx_pending_queue);
+			kfree_skb(s);
+
+			if (nfc_llcp_ns(s) == nr)
+				break;
+		}
+
+		/* Re-queue the remaining skbs for transmission */
+		skb_queue_reverse_walk_safe(&llcp_sock->tx_pending_queue,
+					    s, tmp) {
+			skb_unlink(s, &llcp_sock->tx_pending_queue);
+			skb_queue_head(&local->tx_queue, s);
+		}
 	}
 
 	if (ptype == LLCP_PDU_RR)
-- 
1.7.9.1

