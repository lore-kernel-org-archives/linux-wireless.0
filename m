Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12139 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2GFUAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 16:00:15 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 26/33] NFC: Handle LLCP Disconnected Mode frames
Date: Fri,  6 Jul 2012 22:09:46 +0200
Message-Id: <1341605393-32056-27-git-send-email-sameo@linux.intel.com> (sfid-20120706_220531_835009_34BA534C)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When receiving such frame, the sockets waiting for a connection to finish
should be woken up. Connecting to an unbound LLCP service will trigger a
DM as a response.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/llcp.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/net/nfc/llcp/llcp.c b/net/nfc/llcp/llcp.c
index 6094a20..f3bc0a9 100644
--- a/net/nfc/llcp/llcp.c
+++ b/net/nfc/llcp/llcp.c
@@ -958,6 +958,45 @@ static void nfc_llcp_recv_cc(struct nfc_llcp_local *local, struct sk_buff *skb)
 	nfc_llcp_sock_put(llcp_sock);
 }
 
+static void nfc_llcp_recv_dm(struct nfc_llcp_local *local, struct sk_buff *skb)
+{
+	struct nfc_llcp_sock *llcp_sock;
+	struct sock *sk;
+	u8 dsap, ssap, reason;
+
+	dsap = nfc_llcp_dsap(skb);
+	ssap = nfc_llcp_ssap(skb);
+	reason = skb->data[2];
+
+	pr_debug("%d %d reason %d\n", ssap, dsap, reason);
+
+	switch (reason) {
+	case LLCP_DM_NOBOUND:
+	case LLCP_DM_REJ:
+		llcp_sock = nfc_llcp_connecting_sock_get(local, dsap);
+		break;
+
+	default:
+		llcp_sock = nfc_llcp_sock_get(local, dsap, ssap);
+		break;
+	}
+
+	if (llcp_sock == NULL) {
+		pr_err("Invalid DM\n");
+		return;
+	}
+
+	sk = &llcp_sock->sk;
+
+	sk->sk_err = ENXIO;
+	sk->sk_state = LLCP_CLOSED;
+	sk->sk_state_change(sk);
+
+	nfc_llcp_sock_put(llcp_sock);
+
+	return;
+}
+
 static void nfc_llcp_rx_work(struct work_struct *work)
 {
 	struct nfc_llcp_local *local = container_of(work, struct nfc_llcp_local,
@@ -1001,6 +1040,11 @@ static void nfc_llcp_rx_work(struct work_struct *work)
 		nfc_llcp_recv_cc(local, skb);
 		break;
 
+	case LLCP_PDU_DM:
+		pr_debug("DM\n");
+		nfc_llcp_recv_dm(local, skb);
+		break;
+
 	case LLCP_PDU_I:
 	case LLCP_PDU_RR:
 	case LLCP_PDU_RNR:
-- 
1.7.10

