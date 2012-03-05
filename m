Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755049Ab2CDX6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:01 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 03/22] NFC: Factorize the I frame queueing routine
Date: Mon,  5 Mar 2012 01:03:35 +0100
Message-Id: <1330905834-6994-4-git-send-email-sameo@linux.intel.com> (sfid-20120305_005805_044458_EFED83B4)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This one will be called from the I frame command sending.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   45 ++++++++++++++++++++++++++++-----------------
 net/nfc/llcp/llcp.h |    1 +
 2 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 1d32680..8510a2f 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -616,6 +616,33 @@ fail:
 
 }
 
+void nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
+{
+	struct nfc_llcp_local *local = sock->local;
+
+	pr_debug("Remote ready %d tx queue len %d remote rw %d",
+		sock->remote_ready, skb_queue_len(&sock->tx_pending_queue),
+		local->remote_rw);
+
+	/* Try to queue some I frames for transmission */
+	while (sock->remote_ready &&
+		skb_queue_len(&sock->tx_pending_queue) < local->remote_rw) {
+		struct sk_buff *pdu, *pending_pdu;
+
+		pdu = skb_dequeue(&sock->tx_queue);
+		if (pdu == NULL)
+			break;
+
+		/* Update N(S)/N(R) */
+		nfc_llcp_set_nrns(sock, pdu);
+
+		pending_pdu = skb_clone(pdu, GFP_KERNEL);
+
+		skb_queue_tail(&local->tx_queue, pdu);
+		skb_queue_tail(&sock->tx_pending_queue, pending_pdu);
+	}
+}
+
 static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 				struct sk_buff *skb)
 {
@@ -673,23 +700,7 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 			}
 	}
 
-	/* Queue some I frames for transmission */
-	while (llcp_sock->remote_ready &&
-		skb_queue_len(&llcp_sock->tx_pending_queue) <= local->remote_rw) {
-		struct sk_buff *pdu, *pending_pdu;
-
-		pdu = skb_dequeue(&llcp_sock->tx_queue);
-		if (pdu == NULL)
-			break;
-
-		/* Update N(S)/N(R) */
-		nfc_llcp_set_nrns(llcp_sock, pdu);
-
-		pending_pdu = skb_clone(pdu, GFP_KERNEL);
-
-		skb_queue_tail(&local->tx_queue, pdu);
-		skb_queue_tail(&llcp_sock->tx_pending_queue, pending_pdu);
-	}
+	nfc_llcp_queue_i_frames(llcp_sock);
 
 	release_sock(sk);
 	nfc_llcp_sock_put(llcp_sock);
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 0ad2e33..0a72ee6 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -165,6 +165,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 				struct nfc_llcp_sock *sock);
 u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local);
 void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap);
+void nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock);
 
 /* Sock API */
 struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp);
-- 
1.7.7.3

