Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAF243DED9;
	Tue, 15 Sep 2026 05:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451103; cv=pass; b=uk2iYCoDhIII+/J0xj2kxFZcGj6anO9JAhG4yOftu7Sohpaxrmlyq1ZArI2kZr+s6nekoumj3sTRuGkBttJfvRlJOmGyWPQfUQ3yefUbXyULIpVd0Rvj+coxOAV0Fp/48ADpaysfzZjyH6hcd1jwUXqiEAAK5YXnF9rbF8kOKCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451103; c=relaxed/simple;
	bh=v+x6s0wezmJshrC2OL6alpuAOOKBGPsX+k/o8KtBl1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XjuwnIZvwFyhJegviB307quw0bwNYOX51SSRqa0Xk8KwvkEp9G8R/RcTOCJChnO1L5SDxG/IP5+m/IjzYPMcz2NGaAsLAJZ+QM0rH6JMZV9VPvueRVxxpvQWrspZnDPma7e0KyDpoqz4AmwGGKul/iv79RsHKK2+atZ+WDYejB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=ndqTK2vn; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="ndqTK2vn"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkWF336f3zyQw;
	Tue, 15 Sep 2026 08:44:55 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789451095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UuXlxW26jpQ7eMuCzH4wvKP0Ct5qqrTEGsSRFeVotqM=;
	b=ndqTK2vnCDhCV3uv89+twARk3BrX/YGDctr51X/QzpGEoJuUpDPNk3sirZFz1eiSAT4o1p
	PglbzZJU/pqzTorfmIuBezQYl3qVTZkITEl2BZH+0S1yo1A+lqI4kfdKrLKgVOet10jpUJ
	q5YFnTx8S+mhpGC3eESXedIiNAI4Oe8=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789451095;
	b=DoyUuV7aQYxDulFrFTU/WelxAMsjqgIbSQwP92NdyxeN5YOkCIi2tLtpp0VT/KrGca+v2n
	qwW8wtBlgJz9+EruxzJrY3NKURIEaEptbNX3NuEzMi40dMj3sTKPXp9FndooInuqWG2b1L
	EpRDm7A4tFxmqx5w3uxl4k6zFJiwMWI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789451095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UuXlxW26jpQ7eMuCzH4wvKP0Ct5qqrTEGsSRFeVotqM=;
	b=xFZglM/LTkp+ddScFu+GRg6UPGW2S9vOfL5KO5iXqK3yYY1k6M1mGzU08k5MoieKmNf4Y1
	1YUcbuiNR96hrQTqvcWsSIa2o1xJt6254wMf2DfWKnztaQIwkZJ1n7lZ2YT696Z36lxD2k
	73ETjStKH5gcn+ctZ6WuAf9jUX4VY0w=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Manivannan Sadhasivam <mani@kernel.org>,
	linux-arm-msm@vger.kernel.org
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Andy Gross <agross@kernel.org>,
	linux-kernel@vger.kernel.org,
	mhi@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH v7 06/15] net: qrtr: Report sender endpoint in aux data
Date: Tue, 15 Sep 2026 08:41:58 +0300
Message-Id: <20260915054207.2513877-7-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Kenzior <denkenz@gmail.com>

Introduce support for reporting the remote endpoint that generated a
given QRTR message to clients using AF_QIPCRTR family sockets. This is
achieved by including QRTR_ENDPOINT auxiliary data, which carries the
endpoint identifier of the message sender.  To receive this auxiliary
data, clients must explicitly opt-in by using setsockopt with the
QRTR_REPORT_ENDPOINT option enabled.

Implementation of getsockopt and setsockopt is provided.  An additional
level 'SOL_QRTR' is added to socket.h for use by AF_QIPCRTR family
sockets.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 include/linux/socket.h    |  1 +
 include/uapi/linux/qrtr.h |  6 +++
 net/qrtr/af_qrtr.c        | 77 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 5a5eb12501032..d4e2ba3bd6b39 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -400,6 +400,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_QRTR	288
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/qrtr.h b/include/uapi/linux/qrtr.h
index f7e2fb3d752b5..6d0911984a050 100644
--- a/include/uapi/linux/qrtr.h
+++ b/include/uapi/linux/qrtr.h
@@ -46,4 +46,10 @@ struct qrtr_ctrl_pkt {
 	};
 } __packed;
 
+/* setsockopt / getsockopt */
+#define QRTR_REPORT_ENDPOINT 1
+
+/* CMSG */
+#define QRTR_ENDPOINT 1
+
 #endif /* _LINUX_QRTR_H */
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 43e48b89b5cb6..897ecc8dc304d 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -26,6 +26,10 @@
 
 #define QRTR_PORT_CTRL_LEGACY 0xffff
 
+enum {
+	QRTR_F_REPORT_ENDPOINT,
+};
+
 /**
  * struct qrtr_hdr_v1 - (I|R)PCrouter packet header version 1
  * @version: protocol version
@@ -79,6 +83,7 @@ struct qrtr_cb {
 	u32 src_port;
 	u32 dst_node;
 	u32 dst_port;
+	u32 endpoint_id;
 
 	u8 type;
 	u8 confirm_rx;
@@ -92,6 +97,7 @@ struct qrtr_sock {
 	struct sock sk;
 	struct sockaddr_qrtr us;
 	struct sockaddr_qrtr peer;
+	unsigned long flags;
 };
 
 static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
@@ -567,6 +573,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (cb->dst_port == QRTR_PORT_CTRL_LEGACY)
 		cb->dst_port = QRTR_PORT_CTRL;
 
+	cb->endpoint_id = ep->id;
+
 	if (!size || size > len || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
@@ -1130,6 +1138,7 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 			size_t size, int flags)
 {
 	DECLARE_SOCKADDR(struct sockaddr_qrtr *, addr, msg->msg_name);
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
@@ -1155,6 +1164,10 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 		msg->msg_flags |= MSG_TRUNC;
 	}
 
+	if (cb->endpoint_id && test_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags))
+		put_cmsg(msg, SOL_QRTR, QRTR_ENDPOINT,
+			 sizeof(cb->endpoint_id), &cb->endpoint_id);
+
 	rc = skb_copy_datagram_msg(skb, 0, msg, copied);
 	if (rc < 0)
 		goto out;
@@ -1300,6 +1313,68 @@ static int qrtr_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	return rc;
 }
 
+static int qrtr_setsockopt(struct socket *sock, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	unsigned int val = 0;
+	int rc = 0;
+
+	if (level != SOL_QRTR)
+		return -ENOPROTOOPT;
+
+	if (optlen >= sizeof(val) &&
+	    copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	switch (optname) {
+	case QRTR_REPORT_ENDPOINT:
+		assign_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags, val);
+		break;
+	default:
+		rc = -ENOPROTOOPT;
+	}
+
+	return rc;
+}
+
+static int qrtr_getsockopt(struct socket *sock, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	struct qrtr_sock *ipc = qrtr_sk(sock->sk);
+	unsigned int val;
+	int len;
+	int rc = 0;
+
+	if (level != SOL_QRTR)
+		return -ENOPROTOOPT;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	if (len < sizeof(val))
+		return -EINVAL;
+
+	switch (optname) {
+	case QRTR_REPORT_ENDPOINT:
+		val = test_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags);
+		break;
+	default:
+		rc = -ENOPROTOOPT;
+	}
+
+	if (rc)
+		return rc;
+
+	len = sizeof(int);
+
+	if (put_user(len, optlen) ||
+	    copy_to_user(optval, &val, len))
+		rc = -EFAULT;
+
+	return rc;
+}
+
 static int qrtr_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -1347,6 +1422,8 @@ static const struct proto_ops qrtr_proto_ops = {
 	.shutdown	= sock_no_shutdown,
 	.release	= qrtr_release,
 	.mmap		= sock_no_mmap,
+	.setsockopt	= qrtr_setsockopt,
+	.getsockopt	= qrtr_getsockopt,
 };
 
 static struct proto qrtr_proto = {
-- 
2.34.1

