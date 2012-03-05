Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab2CDX56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:58 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 12/22] NFC: Fragment LLCP I frames
Date: Mon,  5 Mar 2012 01:03:44 +0100
Message-Id: <1330905834-6994-13-git-send-email-sameo@linux.intel.com> (sfid-20120305_005801_388163_C0C73437)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the receiver MIU, we have to fragment the frame to be
transmitted.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   57 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index a02292b..bfe35b8 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -444,29 +444,58 @@ int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
 				struct msghdr *msg, size_t len)
 {
 	struct sk_buff *pdu;
-	struct sock *sk;
+	struct sock *sk = &sock->sk;
+	struct nfc_llcp_local *local;
+	size_t frag_len = 0, remaining_len;
+	u8 *msg_data, *msg_ptr;
 
-	pr_debug("Send I frame\n");
+	pr_debug("Send I frame len %zd\n", len);
 
-	pdu = llcp_allocate_pdu(sock, LLCP_PDU_I, len + LLCP_SEQUENCE_SIZE);
-	if (pdu == NULL)
-		return -ENOMEM;
+	local = sock->local;
+	if (local == NULL)
+		return -ENODEV;
 
-	skb_put(pdu, LLCP_SEQUENCE_SIZE);
+	msg_data = kzalloc(len, GFP_KERNEL);
+	if (msg_data == NULL)
+		return -ENOMEM;
 
-	if (memcpy_fromiovec(skb_put(pdu, len), msg->msg_iov, len)) {
-		kfree_skb(pdu);
-		return -EFAULT;
+	if (memcpy_fromiovec(msg_data, msg->msg_iov, len)) {
+			kfree(msg_data);
+			return -EFAULT;
 	}
 
-	skb_queue_head(&sock->tx_queue, pdu);
+	remaining_len = len;
+	msg_ptr = msg_data;
+
+	while (remaining_len > 0) {
+
+		frag_len = min_t(u16, local->remote_miu, remaining_len);
 
-	sk = &sock->sk;
-	lock_sock(sk);
+		pr_debug("Fragment %zd bytes remaining %zd",
+			 frag_len, remaining_len);
 
-	nfc_llcp_queue_i_frames(sock);
+		pdu = llcp_allocate_pdu(sock, LLCP_PDU_I,
+					frag_len + LLCP_SEQUENCE_SIZE);
+		if (pdu == NULL)
+			return -ENOMEM;
+
+		skb_put(pdu, LLCP_SEQUENCE_SIZE);
+
+		memcpy(skb_put(pdu, frag_len), msg_ptr, frag_len);
+
+		skb_queue_head(&sock->tx_queue, pdu);
+
+		lock_sock(sk);
+
+		nfc_llcp_queue_i_frames(sock);
+
+		release_sock(sk);
+
+		remaining_len -= frag_len;
+		msg_ptr += len;
+	}
 
-	release_sock(sk);
+	kfree(msg_data);
 
 	return 0;
 }
-- 
1.7.7.3

