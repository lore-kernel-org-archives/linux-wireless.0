Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B744515986;
	Fri, 18 Sep 2026 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789748898; cv=none; b=vFgrfC6KVdSGUcOKEiXezXz9RztiHsfHH1sDcEW1tRCFkfcGCm0iQitv/eXEZi4kGff3jdofPkLl/hhUwegkZLhtDswvHyAhwAoGHX+/Pmp3DPmlyK7ZvRmEa+qFGwQj1HzBA/xwvJaET2/KhcjkLz15+bTEcs61MpiNK8z4ZCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789748898; c=relaxed/simple;
	bh=kgdfmuz91IKgYnHgaBlL+u6+Oxrtj0RHPEZmDVb08iM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JsAylNaTm+nFiREVyPtlzhhr9HNNRP+SAR5YIGGwumAd5A7ujK8jtxp9WPeAAy5F3oJx3yDsopYRVIgHT8P9bqF2E56oFHWpfzFv+8uJveHyyFB51KRob+BMIiQO2vOD7VhazZ01fNfF2IZL7fWWBtga4+bfcL+nhgRi9iHMuzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=my3ol6di; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="my3ol6di"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CB1F1C2BCF6;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789748897;
	bh=kgdfmuz91IKgYnHgaBlL+u6+Oxrtj0RHPEZmDVb08iM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=my3ol6diPdZXiMpX6J75k6YIoWCF+zEO/ORqEDzNZkO64T3DgoR+Y0fDtuq3d3A76
	 xGMXAtrrLe+B3JPAXXUmVsUuyrkxqk3GhfBla5j8CJ4tIhve4d4LJkktSvPG3uMwZO
	 TrpQVDax9evDrtPl3YjvOl8OiDdk+xYlpJFIUyCvBp53BexaPb0gYs+2dx8f4c2oqv
	 F6E69fCi8t5ct/36NAxZeeLBKDyg6cnHwcrejwGlbGFxOuxNNEkVgzLPrcmckyCEP/
	 le5ouEnF0myQGtRwgQG/bce/0UYlvQvrASI0vnEMuJ/lzPkruwUUra3y+RrpxHqEEK
	 WKSNvOqM7/q0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA47BC982D8;
	Fri, 18 Sep 2026 16:28:17 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Fri, 18 Sep 2026 18:28:13 +0200
Subject: [PATCH 1/4] net: qrtr: Allow the host QRTR to assign a unique node
 id
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-qrtr-multi-ep-v1-1-8a06caa368d3@oss.qualcomm.com>
References: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
In-Reply-To: <20260918-qrtr-multi-ep-v1-0-8a06caa368d3@oss.qualcomm.com>
To: Manivannan Sadhasivam <mani@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Jeff Johnson <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org, 
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
 Bjorn Andersson <andersson@kernel.org>, 
 Chris Lew <christopher.lew@oss.qualcomm.com>, 
 Deepak Kumar Singh <deepak.singh@oss.qualcomm.com>, 
 Raj Kumar Bhagat <raj.bhagat@oss.qualcomm.com>, 
 Juha-Matti Tilli <juha-matti.tilli@iki.fi>, 
 Jeff Hugo <jeff.hugo@oss.qualcomm.com>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5649;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=VlK8aLzhoboE7auu5vYc1UuZbxZZJt/VIyCXXZoWGMk=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBqrWae+4cO2dbojgbEw83G/jkwSyTeYs2aVPunn
 bpu4T/cpOSJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCaq1mngAKCRBVnxHm/pHO
 9dvxB/sEml7y3srDVsxk3N612+SBuPaMFgE7x7K16pMdyiONxuSfXJZuZQvbZ4dZ4ELLXK2jV6E
 tyhC640BsDeUh+ACPb6PIjnsRTJpA2sUUhhVoIxxSR+y/T+xEuf5UpOruLCEAXVRQ1KbvJ5i96x
 skU+8FvFo42HyZCSKCDUTonQ8DwE9SpGBD/Tuj25fJBcvuUkjAxK9sTP+IWtV09Fwoyjq0nzfHm
 n3oH6SnGLZh+kRe3neeowx+5+QaUBbjBrV1zHPbYNJNAEDQOTIbujWV/Oi7vYAXIdTn+SEIcmWg
 MaNTLsS4wuyjeTWxPqSuVv9gPSfQhXxqaLpXgUhLZfZ60279
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

Currently, QRTR identifies each remote node by the value of the
'src_node_id' field in the received packet and uses the node id as the key
to store the node to the internal 'qrtr_nodes' radix tree.

But this approach comes with a limitation. When more than one remote node
share the same id, then QRTR can only add the first node to the radix tree
and has to drop the successive nodes with the same node id as the 'key' in
radix tree has to be unique. This prevents connecting identical Qcom PCIe
WLAN devices to a single host at the same time.

To fix this limitation, allow the host QRTR to use the node id (nid)
received from the endpoint driver during qrtr_endpoint_register() as the
unique node id and use it as the 'key' for the internal radix tree. Also,
store the received 'src_id' in a new 'qrtr_node->ep_nid' field and replace
the 'ep_nid' with the unique 'nid' in the QRTR control packets if both
differ i.e., an endpoint driver has passed a unique 'nid' during
qrtr_endpoint_register(). To maintain symmetry, replace the 'nid' with the
'ep_nid' while sending the packet back to the remote node if both differ.

Currently, all QRTR endpoint drivers pass 'QRTR_EP_NID_AUTO' as the 'nid'
during qrtr_endpoint_register(). So 'ep_nid' and 'nid' are same and the
functionality is not changed.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 net/qrtr/af_qrtr.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 7 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index a30fa56e6aa3..af8ca65a7027 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -117,7 +117,8 @@ static DEFINE_XARRAY_ALLOC(qrtr_ports);
  * @ep_lock: lock for endpoint management and callbacks
  * @ep: endpoint
  * @ref: reference count for node
- * @nid: node id
+ * @nid: node id assigned by the host QRTR
+ * @ep_nid: endpoint's own node id as received
  * @qrtr_tx_flow: xarray of qrtr_tx_flow, keyed by node << 32 | port
  * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @rx_queue: receive queue
@@ -128,6 +129,7 @@ struct qrtr_node {
 	struct qrtr_endpoint *ep;
 	struct kref ref;
 	unsigned int nid;
+	unsigned int ep_nid;
 
 	struct xarray qrtr_tx_flow;
 	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
@@ -339,6 +341,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 {
 	struct qrtr_hdr_v1 *hdr;
 	size_t len = skb->len;
+	unsigned int dst_node;
 	int rc, confirm_rx;
 
 	confirm_rx = qrtr_tx_wait(node, to->sq_node, to->sq_port, type);
@@ -353,10 +356,14 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	hdr->src_node_id = cpu_to_le32(from->sq_node);
 	hdr->src_port_id = cpu_to_le32(from->sq_port);
 	if (to->sq_port == QRTR_PORT_CTRL) {
-		hdr->dst_node_id = cpu_to_le32(node->nid);
+		hdr->dst_node_id = cpu_to_le32(node->ep_nid);
 		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
 	} else {
-		hdr->dst_node_id = cpu_to_le32(to->sq_node);
+		/* Put back the endpoint's own node id */
+		dst_node = to->sq_node;
+		if (dst_node == node->nid)
+			dst_node = node->ep_nid;
+		hdr->dst_node_id = cpu_to_le32(dst_node);
 		hdr->dst_port_id = cpu_to_le32(to->sq_port);
 	}
 
@@ -420,6 +427,32 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
 }
 
+/* Replace the node id in the control packet with 'node->nid', if both are
+ * different.
+ */
+static void qrtr_node_rewrite_ctrl(struct qrtr_node *node, unsigned int type,
+				   struct sk_buff *skb)
+{
+	struct qrtr_ctrl_pkt *pkt;
+	__le32 *nid;
+
+	if (node->nid == node->ep_nid)
+		return;
+
+	if (skb->len < sizeof(*pkt))
+		return;
+
+	pkt = (struct qrtr_ctrl_pkt *)skb->data;
+	if (type == QRTR_TYPE_DEL_CLIENT)
+		nid = &pkt->client.node;
+	else
+		nid = &pkt->server.node;
+
+	/* Rewrite only the endpoint's node id, not those of bridged nodes */
+	if (le32_to_cpu(*nid) == node->ep_nid)
+		*nid = cpu_to_le32(node->nid);
+}
+
 /**
  * qrtr_endpoint_post() - post incoming data
  * @ep: endpoint handle
@@ -510,16 +543,29 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	skb_put_data(skb, data + hdrlen, size);
 
-	qrtr_node_assign(node, cb->src_node);
+	if (node->ep_nid == QRTR_EP_NID_AUTO)
+		node->ep_nid = cb->src_node;
+
+	if (node->nid == QRTR_EP_NID_AUTO || node->nid == cb->src_node)
+		qrtr_node_assign(node, cb->src_node);
 
 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
 		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt;
+		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+		unsigned int server_node = le32_to_cpu(pkt->server.node);
 
-		pkt = data + hdrlen;
-		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+		if (server_node != node->ep_nid)
+			qrtr_node_assign(node, server_node);
 	}
 
+	if (cb->src_node == node->ep_nid)
+		cb->src_node = node->nid;
+
+	if (cb->type == QRTR_TYPE_NEW_SERVER ||
+	    cb->type == QRTR_TYPE_DEL_SERVER ||
+	    cb->type == QRTR_TYPE_DEL_CLIENT)
+		qrtr_node_rewrite_ctrl(node, cb->type, skb);
+
 	if (cb->type == QRTR_TYPE_RESUME_TX) {
 		qrtr_tx_resume(node, skb);
 	} else {
@@ -593,6 +639,7 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
 	node->nid = QRTR_EP_NID_AUTO;
+	node->ep_nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
 	xa_init(&node->qrtr_tx_flow);

-- 
2.43.0


