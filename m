Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65491 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2CDX5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:31 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 04/22] NFC: Handle Receiver Not Ready LLCP frame
Date: Mon,  5 Mar 2012 01:03:36 +0100
Message-Id: <1330905834-6994-5-git-send-email-sameo@linux.intel.com> (sfid-20120305_005734_938948_0AAAB98B)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 8510a2f..bbfaa27 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -671,15 +671,15 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 		nfc_llcp_sock_put(llcp_sock);
 	}
 
-	if (ns == llcp_sock->recv_n)
-		llcp_sock->recv_n = (llcp_sock->recv_n + 1) % 16;
-	else
-		pr_err("Received out of sequence I PDU\n");
-
 	/* Pass the payload upstream */
 	if (ptype == LLCP_PDU_I) {
 		pr_debug("I frame, queueing on %p\n", &llcp_sock->sk);
 
+		if (ns == llcp_sock->recv_n)
+			llcp_sock->recv_n = (llcp_sock->recv_n + 1) % 16;
+		else
+			pr_err("Received out of sequence I PDU\n");
+
 		skb_pull(skb, LLCP_HEADER_SIZE + LLCP_SEQUENCE_SIZE);
 		if (sock_queue_rcv_skb(&llcp_sock->sk, skb)) {
 			pr_err("receive queue is full\n");
@@ -700,6 +700,11 @@ static void nfc_llcp_recv_hdlc(struct nfc_llcp_local *local,
 			}
 	}
 
+	if (ptype == LLCP_PDU_RR)
+		llcp_sock->remote_ready = true;
+        else if (ptype == LLCP_PDU_RNR)
+		llcp_sock->remote_ready = false;
+
 	nfc_llcp_queue_i_frames(llcp_sock);
 
 	release_sock(sk);
@@ -813,6 +818,7 @@ static void nfc_llcp_rx_work(struct work_struct *work)
 
 	case LLCP_PDU_I:
 	case LLCP_PDU_RR:
+	case LLCP_PDU_RNR:
 		pr_debug("I frame\n");
 		nfc_llcp_recv_hdlc(local, skb);
 		break;
-- 
1.7.7.3

