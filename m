Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:65491 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2CDX5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:57:35 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 05/22] NFC: LLCP socket sendmsg implemetation
Date: Mon,  5 Mar 2012 01:03:37 +0100
Message-Id: <1330905834-6994-6-git-send-email-sameo@linux.intel.com> (sfid-20120305_005738_477196_1B3789B6)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/llcp/commands.c |   31 +++++++++++++++++++++++++++++++
 net/nfc/llcp/llcp.h     |    2 ++
 net/nfc/llcp/sock.c     |   30 +++++++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/net/nfc/llcp/commands.c b/net/nfc/llcp/commands.c
index 151f2ef..f6c2257 100644
--- a/net/nfc/llcp/commands.c
+++ b/net/nfc/llcp/commands.c
@@ -397,3 +397,34 @@ int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock)
 
 	return 0;
 }
+
+int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
+				struct msghdr *msg, size_t len)
+{
+	struct sk_buff *pdu;
+	struct sock *sk;
+
+	pr_debug("Send I frame\n");
+
+	pdu = llcp_allocate_pdu(sock, LLCP_PDU_I, len + LLCP_SEQUENCE_SIZE);
+	if (pdu == NULL)
+		return -ENOMEM;
+
+	skb_put(pdu, LLCP_SEQUENCE_SIZE);
+
+	if (memcpy_fromiovec(skb_put(pdu, len), msg->msg_iov, len)) {
+		kfree_skb(pdu);
+		return -EFAULT;
+	}
+
+	skb_queue_head(&sock->tx_queue, pdu);
+
+	sk = &sock->sk;
+	lock_sock(sk);
+
+	nfc_llcp_queue_i_frames(sock);
+
+	release_sock(sk);
+
+	return 0;
+}
diff --git a/net/nfc/llcp/llcp.h b/net/nfc/llcp/llcp.h
index 0a72ee6..36d8572 100644
--- a/net/nfc/llcp/llcp.h
+++ b/net/nfc/llcp/llcp.h
@@ -188,6 +188,8 @@ int nfc_llcp_send_connect(struct nfc_llcp_sock *sock);
 int nfc_llcp_send_cc(struct nfc_llcp_sock *sock);
 int nfc_llcp_send_dm(struct nfc_llcp_local *local, u8 ssap, u8 dsap, u8 reason);
 int nfc_llcp_send_disconnect(struct nfc_llcp_sock *sock);
+int nfc_llcp_send_i_frame(struct nfc_llcp_sock *sock,
+				struct msghdr *msg, size_t len);
 
 /* Socket API */
 int __init nfc_llcp_sock_init(void);
diff --git a/net/nfc/llcp/sock.c b/net/nfc/llcp/sock.c
index f738ccd..b8bef36 100644
--- a/net/nfc/llcp/sock.c
+++ b/net/nfc/llcp/sock.c
@@ -482,6 +482,34 @@ error:
 	return ret;
 }
 
+static int llcp_sock_sendmsg(struct kiocb *iocb, struct socket *sock,
+				struct msghdr *msg, size_t len)
+{
+	struct sock *sk = sock->sk;
+	struct nfc_llcp_sock *llcp_sock = nfc_llcp_sock(sk);
+	int ret;
+
+	pr_debug("sock %p sk %p", sock, sk);
+
+	ret = sock_error(sk);
+	if (ret)
+		return ret;
+
+	if (msg->msg_flags & MSG_OOB)
+		return -EOPNOTSUPP;
+
+	lock_sock(sk);
+
+	if (sk->sk_state != LLCP_CONNECTED) {
+		release_sock(sk);
+		return -ENOTCONN;
+	}
+
+	release_sock(sk);
+
+	return nfc_llcp_send_i_frame(llcp_sock, msg, len);
+}
+
 static int llcp_sock_recvmsg(struct kiocb *iocb, struct socket *sock,
 			     struct msghdr *msg, size_t len, int flags)
 {
@@ -567,7 +595,7 @@ static const struct proto_ops llcp_sock_ops = {
 	.shutdown       = sock_no_shutdown,
 	.setsockopt     = sock_no_setsockopt,
 	.getsockopt     = sock_no_getsockopt,
-	.sendmsg        = sock_no_sendmsg,
+	.sendmsg        = llcp_sock_sendmsg,
 	.recvmsg        = llcp_sock_recvmsg,
 	.mmap           = sock_no_mmap,
 };
-- 
1.7.7.3

