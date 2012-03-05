Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:10004 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837Ab2CDX5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:51 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/22] NFC: Send LLCP RR frames to acknowledge received I frames
Date: Mon,  5 Mar 2012 01:03:42 +0100
Message-Id: <1330905834-6994-11-git-send-email-sameo@linux.intel.com> (sfid-20120305_005754_858755_CD36AD63)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to acknowledge an I frame, we have to either queue pending local
I frames or queue a receiver ready frame.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   24 ++++++++++++++++++++++++
 net/nfc/llcp/llcp.c     |    9 +++++++--
 net/nfc/llcp/llcp.h     |    3 ++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index f6c2257..8ebd322 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -428,3 +428,27 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 
 	return 0;
 }
+
+int nfc_llcp_send_rr(struct nfc_llcp_sock *sock)
+{
+	struct sk_buff *skb;
+	struct nfc_llcp_local *local;
+
+	pr_debug("Send rr nr %d\n", sock->recv_n);
+
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
+
+	skb = llcp_allocate_pdu(sock, LLCP_PDU_RR, LLCP_SEQUENCE_SIZE);
+	if (skb == NULL)
+		return -ENOMEM;
+
+	skb_put(skb, LLCP_SEQUENCE_SIZE);
+
+	skb->data[2] = sock->recv_n % 16;
+
+	skb_queue_head(&local->tx_queue, skb);
+
+	return 0;
+}
diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 2506810..a0cb133 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -627,8 +627,9 @@ fail:
 
 }
 
-void nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
+int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 {
+	int nr_frames = 0;
 	struct nfc_llcp_local *local = sock->local;
 
 	pr_debug("Remote ready %d tx queue len %d remote rw %d",
@@ -651,7 +652,10 @@ void nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock)
 
 		skb_queue_tail(&local->tx_queue, pdu);
 		skb_queue_tail(&sock->tx_pending_queue, pending_pdu);
+		nr_frames++;
 	}
+
+	return nr_frames;
 }
 
 static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
@@ -716,7 +720,8 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
         else if (ptype == LLCP_PDU_RNR)
 		llcp_sock->remote_ready = false;
 
-	nfc_llcp_queue_i_frames(llcp_sock);
+	if (nfc_llcp_queue_i_frames(llcp_sock) == 0)
+		nfc_llcp_send_rr(llcp_sock);
 
 	release_sock(sk);
 	nfc_llcp_sock_put(llcp_sock);
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 36d8572..054c64f 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -165,7 +165,7 @@ u8 nfc_llcp_get_sdp_ssap(struct nfc_llcp_local *local,
 				struct nfc_llcp_sock *sock);
 u8 nfc_llcp_get_local_ssap(struct nfc_llcp_local *local);
 void nfc_llcp_put_ssap(struct nfc_llcp_local *local, u8 ssap);
-void nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock);
+int nfc_llcp_queue_i_frames(struct nfc_llcp_sock *sock);
 
 /* Sock API */
 struct sock *nfc_llcp_sock_alloc(struct socket *sock, int type, gfp_t gfp);
@@ -190,6 +190,7 @@ int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason);
 int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock);
 int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 				struct msghdr *msg, size_t len);
+int nfc_llcp_send_rr(struct nfc_llcp_sock *sock);
 
 /* Socket API */
 int __init nfc_llcp_sock_init(void);
-- 
1.7.7.3

