Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2AA43DEA5;
	Tue, 15 Sep 2026 05:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451005; cv=pass; b=B/ynK7HPy1znspGReq0XwUF8IrDY9LGMgX9WS40y6X33huMfNUNB8+9c6dfouhh7WBV63RDoqZ16h5qTSYdocfISLCtHn+2ThmeiC2qayi2cv7ny6ne6qMqfmSDZz28yOO/RyrQBgb7N0R50SxYQKe00Lgk+ovPxLmLyYnxv7BE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451005; c=relaxed/simple;
	bh=mnCg6IjXPDA18F3gCIoGu45zsMeW4iiwBq36VbdhGrE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b6WvQHOFbFxBSc3t/ODFkFxFtw63dNOVsCUz5R/e4jUB1h0GiLWkaU3LH9WZk0jrnt7aW55m7ORaxA2/8IaPNQ4a5YjpZBucfhtyf4I9kC8H3RYFglqSgvplcEhfOdJ4w90ixYbrdXazv7dIphKndMj3tH9Dgf7Qi0tjnU7Tpu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=kFnBhZY/; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="kFnBhZY/"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWC91N9Pz49Q7r;
	Tue, 15 Sep 2026 08:43:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789450997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2arz6d4RrSmlewlrh+D8m1nv0qdMIfe9W1Or8yisS4=;
	b=kFnBhZY/tQMpsMbHRTD5iBa9Np4ys7eYe0BR3VJXDgmsVVd4DuPQE0M1BCk63yXmFLM0hU
	EuC8xlqKmvvZLHq9lQr4lclMLmf8I6ePNmCLJwrlMrapJsnGh0q7mGiGuMFZ7uBCWovgOd
	LFZKmtRptv8yt5osCenf1EuC+JATkEDkpGwN5J0Ecu26TFXNcuqRTVz/wX645fMip1Ccwn
	bEZkxpbzfjl+ZHwY92KItA8bcILGBhqwiRuHXxbLFgogSMpSj6+yQ3dH3Qpf7egKJ1oVUA
	0i7lIpgpI4koEkfqtVol/6dNv/FIOOZ0oZgaJ2tK8yqz+4X+d/oyT9DUvZwIUg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789450997;
	b=YXPpjGjFh5DM1a2DE+phDlSV2GEGVA/b3mz/XlD5TGGcWd5G+E+pJ4OjDu+wQt7R4n8qW2
	eE61rHyjIatpJUpPq0b/MZtrn8Kz+j0vHNM9lOBRrRqkUsrwzW6lglKtyqPlH70HqGJFK0
	r7vS28wY6u4ZommAEaoCsWk2wv8m1i6U+vleREY2S6v+JyytR0I+2CNfpLJwIScDbLTlOt
	vxo3Z24ZN6ol215Ky+/1Oh8Loo6KOL5VvGLqxy3vbBVplxDLpLtDkHeb0UvEPTYEF/+l2D
	aIVSTviuX707UZkj8iMv2MeXnB0akmwHdITGz0md6e6efBfSgV3/N8qcFiC06A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789450997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b2arz6d4RrSmlewlrh+D8m1nv0qdMIfe9W1Or8yisS4=;
	b=gsV4ysXa8lo/mTQrJGr+DIoC0/r18kN4QSzJPbGZE3ZBk13c4u8bk9zpDV7klZLwh6vgGt
	nH2EvTpCils+36yA7BxSb+SqsolHePd/oy+kekg2IJ6jff+ThIlFBPl7SDYuKngze7dWIl
	XLvLh9fKoGA9Se9nBg5vGuOH3Mej86dXNYGwh8U46ml2MHbBRusFF+uup4Eh50HGXkGF9s
	XkusyOHb+I+eFaXNmHwoEMZbuib8M66J8jawzAxVL1BCCkWYLMY214Sjuyo20YzfhHH/NA
	Prbbb2NQmbcGMRV1ExPC2ZCxu4vZgC7oW3i7edhHpCSUXlVrcygPOi6GO4cKWw==
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
Subject: [PATCH v7 02/15] net: qrtr: allocate and track endpoint ids
Date: Tue, 15 Sep 2026 08:41:54 +0300
Message-Id: <20260915054207.2513877-3-juha-matti.tilli@iki.fi>
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

Currently, QRTR endpoints are tracked solely by their pointer value,
which is sufficient as they are not exposed to user space and it is
assumed that each endpoint has a unique set of node identifiers
associated with it.  However, this assumption does not hold when
multiple devices of the same type are connected to the system.  For
example, multiple PCIe based 5G modems.  Such a setup results in
multiple endpoints with confliciting node identifiers.

To enable support for such scenarios, introduce the ability to track
and assign unique identifiers to QRTR endpoints. These identifiers
can then be exposed to user space, allowing for userspace clients to
identify which endpoint sent a given message, or to direct a message
to a specific endpoint.

A simple allocation strategy is used based on xa_alloc_cyclic.  Remote
endpoint ids start at 'qrtr_local_nid' + 1.  Since qrtr_local_nid is
currently always set to 1 and never changed, node identifiers start at
'1' for the local endpoint and 2..INT_MAX for remote endpoints.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c | 24 ++++++++++++++++++++++++
 net/qrtr/qrtr.h    |  1 +
 2 files changed, 25 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index a30fa56e6aa31..38b6def7c5272 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -22,6 +22,7 @@
 #define QRTR_MAX_EPH_SOCKET 0x7fff
 #define QRTR_EPH_PORT_RANGE \
 		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
+#define QRTR_ENDPOINT_RANGE XA_LIMIT(qrtr_local_nid + 1, INT_MAX)
 
 #define QRTR_PORT_CTRL_LEGACY 0xffff
 
@@ -109,6 +110,10 @@ static LIST_HEAD(qrtr_all_nodes);
 /* lock for qrtr_all_nodes and node reference */
 static DEFINE_MUTEX(qrtr_node_lock);
 
+/* endpoint id allocation management */
+static DEFINE_XARRAY_ALLOC(qrtr_endpoints);
+static u32 next_endpoint_id;
+
 /* local port allocation management */
 static DEFINE_XARRAY_ALLOC(qrtr_ports);
 
@@ -581,6 +586,8 @@ static struct sk_buff *qrtr_alloc_ctrl_packet(struct qrtr_ctrl_pkt **pkt,
 int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 {
 	struct qrtr_node *node;
+	u32 endpoint_id;
+	int rc;
 
 	if (!ep || !ep->xmit)
 		return -EINVAL;
@@ -589,6 +596,13 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	if (!node)
 		return -ENOMEM;
 
+	rc = xa_alloc_cyclic(&qrtr_endpoints, &endpoint_id, NULL,
+			     QRTR_ENDPOINT_RANGE, &next_endpoint_id,
+			     GFP_KERNEL);
+
+	if (rc < 0)
+		goto free_node;
+
 	kref_init(&node->ref);
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
@@ -604,8 +618,12 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	list_add(&node->item, &qrtr_all_nodes);
 	mutex_unlock(&qrtr_node_lock);
 	ep->node = node;
+	ep->id = endpoint_id;
 
 	return 0;
+free_node:
+	kfree(node);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(qrtr_endpoint_register);
 
@@ -625,8 +643,10 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	unsigned long flags;
 	unsigned long index;
 	void __rcu **slot;
+	u32 endpoint_id;
 
 	mutex_lock(&node->ep_lock);
+	endpoint_id = node->ep->id;
 	node->ep = NULL;
 	mutex_unlock(&node->ep_lock);
 
@@ -651,6 +671,10 @@ void qrtr_endpoint_unregister(struct qrtr_endpoint *ep)
 	mutex_unlock(&node->qrtr_tx_lock);
 
 	qrtr_node_release(node);
+
+	xa_erase(&qrtr_endpoints, endpoint_id);
+
+	ep->id = 0;
 	ep->node = NULL;
 }
 EXPORT_SYMBOL_GPL(qrtr_endpoint_unregister);
diff --git a/net/qrtr/qrtr.h b/net/qrtr/qrtr.h
index 3f2d28696062a..11b897af05e67 100644
--- a/net/qrtr/qrtr.h
+++ b/net/qrtr/qrtr.h
@@ -21,6 +21,7 @@ struct qrtr_endpoint {
 	int (*xmit)(struct qrtr_endpoint *ep, struct sk_buff *skb);
 	/* private: not for endpoint use */
 	struct qrtr_node *node;
+	u32 id;
 };
 
 int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid);
-- 
2.34.1

