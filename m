Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950243E48D;
	Tue, 15 Sep 2026 05:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451176; cv=pass; b=WE+pg/+IHZKqqWkc4WFmE/owqDlKFhvgn/QkbBWvJEqlLSXnaAlzpKlFqrxVxRrcq/22yGYKk8Oavf26j3GwiWAZZ9ZECkt/iva/hphDAeYIaDjEiP1ZRT5LxCffORJLwTpiFdP/6LtfQG79VyGBTMtUThY88N8y9j7mPUsJcvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451176; c=relaxed/simple;
	bh=tKWTf1cazHWaXntnYsiXxrJYnrU+iW5fvyj/sDkCDtc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AuX56gPdYPp6zEGUF29I2lBL4t+HVs/j14TfQFX3CK0DY27W9fso/e++zVOxIMrGD5ESkzvdISQddDBM3/SXuHSboV8x4zDigPFOdbRP1+O7LnfWulZjZNwdg2mUQu8s0lhqRWHNiga1/EaUWDUbWZC3GbO2jCc+zSrIJX5sgBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=LIhAK7gU; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="LIhAK7gU"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWGT1NHWz49Q32;
	Tue, 15 Sep 2026 08:46:09 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1zGVynj9H5SONi5WNNQRZuKnULVYkGJU/Lsk8iTgW0=;
	b=LIhAK7gUndGZcf4Yu+z3n6SHullxJtH1x/VxeLjY2AIYXB+MtqUcJBSoT0BJlV0fr3AyX+
	YBW+nhgG7TL+aZwNOBmhkyNlDQ8WQIlHcebIDqR6DBbExvEmDQmY4SzfYD0xQ/bb3XH04m
	/iVPCVo9EBZBua+lNam+AREsp3wxa/Ghr8q8WVRIjdDPn2LnmchStyF3FhB5CYbZ7H2LcW
	oJUjNKupL44SWz/em8tYrJvvfkhwRD6bOXkZ/7t1CQdSANPQqA5ZCTyG0v/Hi6UktaWEuU
	rXis+bRlzj1OYpb6bAzvYE0+vb2MCWgTSYSb71ICekctjeJPLfAZFZdrbWfXbA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451169;
	b=LHeP2tcneM0Dhi/1cZfiw9chfzytpozj9UnF7wS2cB2oAIvQExK8EYdCvyXSh7wftRcS4Y
	3Db06UtIhAVhB7tJ6CFkE9AEkLux4e4WAvfr8zHvCePy89xtOUqHkXcV2b/QRTcSF51FDl
	ctO7rBfyM82NlTUOUjtz9DMjK2IfvSAY/hnNPj8bnCgFWh6B/a78TobUF9M6oFZifiQymA
	Q51ocfJlpy+UEeAIAxmYTDp1Kt641+qOH1/M1wfAJ3oL690OOcIpMVHRLd/r68K+LEV0Om
	4wm4qWahTJ7o9ij/7yCBjG3sffpASdXwAx/kXzyy5xdze3kSMbo7cKMprH4J3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1zGVynj9H5SONi5WNNQRZuKnULVYkGJU/Lsk8iTgW0=;
	b=NWwWzXYbDbtaVPdCSzsVXqcOea/p41so3KB9GoikBkfacSm5GTrDX9iQFxPMkxAy5i1RwZ
	EVnrl1hpPs38vfZ+j5BXrL/Bd1wyl7whExVVkFq8v0I+F82kYPRhdNoFaEnwWFdBX6xTfE
	MAT/gtl5RCh1WiJFRcNfVmH1D4Q/zq+kLOfBH8hS03qKegp8KGn96uNYn11HgIjIjqVHNG
	MUNeC6H5jlvyKSfKAxOqTZOksHdUIcYS4s4CyQwonYOWfnhCt9FV7W9QzyZ5o0aa/NCfIP
	p5SrrJnphsjIbW7yTPuMKRfDtdMn3Zh7kWfDSIdJqqBy4+DNM7jejOEag5B1qg==
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
Subject: [PATCH v7 09/15] net: qrtr: allow socket endpoint binding
Date: Tue, 15 Sep 2026 08:42:01 +0300
Message-Id: <20260915054207.2513877-10-juha-matti.tilli@iki.fi>
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

Introduce the ability to bind a QIPCRTR family socket to a specific
endpoint.  When a socket is bound, only messages from the bound
endpoint can be received, and any messages sent from the socket are
by default directed to the bound endpoint.  Clients can bind a socket
by using the setsockopt system call with the QRTR_BIND_ENDPOINT option
set to the desired endpoint binding.

A previously set binding can be reset by setting QRTR_BIND_ENDPOINT
option to zero.  This behavior matches that of SO_BINDTOIFINDEX.

This functionality is useful for clients that need to communicate
with a specific device (i.e. endpoint), such as a PCIe-based 5G modem,
and are not interested in messages from other endpoints / nodes.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 include/uapi/linux/qrtr.h |  1 +
 net/qrtr/af_qrtr.c        | 56 ++++++++++++++++++++++++++++-----------
 2 files changed, 41 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/qrtr.h b/include/uapi/linux/qrtr.h
index 6d0911984a050..0a8667b049c3d 100644
--- a/include/uapi/linux/qrtr.h
+++ b/include/uapi/linux/qrtr.h
@@ -48,6 +48,7 @@ struct qrtr_ctrl_pkt {
 
 /* setsockopt / getsockopt */
 #define QRTR_REPORT_ENDPOINT 1
+#define QRTR_BIND_ENDPOINT 2
 
 /* CMSG */
 #define QRTR_ENDPOINT 1
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index d4a472f0ac4d1..ccfa3ed33a996 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -98,6 +98,7 @@ struct qrtr_sock {
 	struct sockaddr_qrtr us;
 	struct sockaddr_qrtr peer;
 	unsigned long flags;
+	u32 bound_endpoint;
 };
 
 static inline struct qrtr_sock *qrtr_sk(struct sock *sk)
@@ -656,10 +657,14 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 			goto err;
 		}
 
-		ret = sock_queue_rcv_skb(&ipc->sk, skb);
-		if (ret) {
-			qrtr_port_put(ipc);
-			goto err;
+		/* Sockets bound to an endpoint only rx from that endpoint */
+		if (!ipc->bound_endpoint ||
+		    ipc->bound_endpoint == cb->endpoint_id) {
+			ret = sock_queue_rcv_skb(&ipc->sk, skb);
+			if (ret) {
+				qrtr_port_put(ipc);
+				goto err;
+			}
 		}
 
 		qrtr_port_put(ipc);
@@ -999,29 +1004,41 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 {
 	struct qrtr_sock *ipc;
 	struct qrtr_cb *cb;
+	int ret = -ENODEV;
 
 	ipc = qrtr_port_lookup(to->sq_port);
-	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
-		if (ipc)
-			qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!ipc)
+		goto done;
+
+	if (&ipc->sk == skb->sk) /* do not send to self */
+		goto done;
+
+	/*
+	 * Filter out unwanted packets that are not on behalf of the bound
+	 * endpoint.  Certain special packets (such as an empty NEW_SERVER
+	 * packet that serves as a sentinel value) always go through.
+	 */
+	if (endpoint_id && ipc->bound_endpoint &&
+	    ipc->bound_endpoint != endpoint_id)
+		goto done;
 
 	cb = (struct qrtr_cb *)skb->cb;
 	cb->src_node = from->sq_node;
 	cb->src_port = from->sq_port;
 	cb->endpoint_id = endpoint_id;
 
-	if (sock_queue_rcv_skb(&ipc->sk, skb)) {
-		qrtr_port_put(ipc);
-		kfree_skb(skb);
-		return -ENOSPC;
-	}
+	ret = -ENOSPC;
+	if (sock_queue_rcv_skb(&ipc->sk, skb))
+		goto done;
 
 	qrtr_port_put(ipc);
 
 	return 0;
+done:
+	if (ipc)
+		qrtr_port_put(ipc);
+	kfree_skb(skb);
+	return ret;
 }
 
 /* Queue packet for broadcast. */
@@ -1107,7 +1124,8 @@ static int qrtr_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	} else if (addr->sq_node == ipc->us.sq_node) {
 		enqueue_fn = qrtr_local_enqueue;
 	} else {
-		endpoint_id = msg_endpoint_id;
+		endpoint_id = msg_endpoint_id ?
+			      msg_endpoint_id : ipc->bound_endpoint;
 
 		node = qrtr_node_lookup(endpoint_id, addr->sq_node);
 		if (!node) {
@@ -1385,6 +1403,9 @@ static int qrtr_setsockopt(struct socket *sock, int level, int optname,
 	case QRTR_REPORT_ENDPOINT:
 		assign_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags, val);
 		break;
+	case QRTR_BIND_ENDPOINT:
+		WRITE_ONCE(ipc->bound_endpoint, val);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 	}
@@ -1413,6 +1434,9 @@ static int qrtr_getsockopt(struct socket *sock, int level, int optname,
 	case QRTR_REPORT_ENDPOINT:
 		val = test_bit(QRTR_F_REPORT_ENDPOINT, &ipc->flags);
 		break;
+	case QRTR_BIND_ENDPOINT:
+		val = READ_ONCE(ipc->bound_endpoint);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 	}
-- 
2.34.1

