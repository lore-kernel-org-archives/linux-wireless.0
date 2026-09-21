Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E1648988D;
	Mon, 21 Sep 2026 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789989813; cv=none; b=XrZl2mWLWwuKwWaH4svFdUAkXWRJ/NEjJBHmssAXExh8DTzfK62bpqESXPo20ZF8vT2CYtbrSlXO8tHtBGNLzcUlxu704bZdN26tM0N7mH2In2HHJ3XboSA/+5zOOvKaY/rJ747LbF4Pmq7ZcmpiFGLpwCboQLtxpR7KJN/CJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789989813; c=relaxed/simple;
	bh=fdjlnrJ3LToW7onxkiWd5XchU6A7o130iGBmLyfFfkE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HNaCRmYITNPaKspKGD7KaFQZLdZvhKzZLZQEqzaH64taPBloBmqXYu8bHC5bbXWL163uLqeEycYxcIDuhIxJggqBdlDPNvGURzG9wj+ZVKUTm4avxRomMB8ZVy9jExONWGS083bbCTdTLiPpCZVkLAki0h7PnImRoKjDyoBgN0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ap+4NXlQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ap+4NXlQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1A03C2BCF6;
	Mon, 21 Sep 2026 11:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789989812;
	bh=fdjlnrJ3LToW7onxkiWd5XchU6A7o130iGBmLyfFfkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ap+4NXlQt7jA0vv+EHGlsWu6+W+JQiiR7XqVa56aCE+8/eEvr+pWvfYPpQy2tm67O
	 MjmwoplfurNTgCcsD+hibRmBJXNDd6Q3pmMTudbCqXmo2OBPP4+0V3etU5v+Lbo2N7
	 Q1U8rr/E50SKGDD+tLJi6yrRCpT7nIlpGiCq/3w/eCX376JdLG6N5YIr4LQ+Nxl5mP
	 lcrDuQjVsLQMwTaINf3e3Wex3zN8SIOmHquPmInmFm///c9dfori0YR6/XoeocdFpu
	 GOGyQKcbR/kglyJ0aPRk/y3vzYEE856sgV2PjoiIZEJaykCCH1UswOVRMsSm/0ur8a
	 g0TwB+SU3MD/Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA890C982E1;
	Mon, 21 Sep 2026 11:23:32 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Mon, 21 Sep 2026 13:23:27 +0200
Subject: [PATCH v2 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-qrtr-multi-ep-v2-1-27dd80d841a0@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5669;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=bkqF9LbWdL45ipEr0xLieI3UD5ICmD54p2NVl4pcadA=;
 b=owGbwMvMwMUYOl/w2b+J574ynlZLYsjaKLxx6fdy601hF/d6Hw+Y5NN8fVXRPPaXHRMEY8w0g
 nus9VR3djIaszAwcjHIiimypC911mr0OH1jSYT6dJhBrEwgUxi4OAVgIm+zORi6LMJ1ZvnvdRRQ
 W23spem4yGhS7/VgnvUpz3evO1m8r97gIavC/1c6nLkz/rxS2xWT4hiRavY95n3KhGlLy357Mtu
 9tHwR+9/r4HzXRu+WYxzuTmL9Mbc2S6TYcVdGTO1p2sf9U6Hd7Y1VT7nw0Q/sBd0nyxzOFztc36
 xvn+MswF/L5F6bJ5Gj0MBlHtvt6+/QkLR20VnP8HP7tBMurlQ9xSHxXNyee8+WzkuSD89xJb2pU
 Fm8Z1Ol2BGR1uMV9snm8i8WHGDal+WxO+QgQ7/EkZfZ6frbH/teEJ6fv3xbX0NDEIfQ3Om1H5sn
 nl3UezakNkJ0O5/nv+y/m3b1tPx5YRJTq9a5+vGD6cFzAQ==
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
index 78347c937af7..ad62f3caede8 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -118,7 +118,8 @@ static DEFINE_XARRAY_ALLOC(qrtr_ports);
  * @ep_lock: lock for endpoint management and callbacks
  * @ep: endpoint
  * @ref: reference count for node
- * @nid: node id
+ * @nid: node id assigned by the host QRTR
+ * @ep_nid: endpoint's own node id as received
  * @qrtr_tx_flow: xarray of qrtr_tx_flow, keyed by node << 32 | port
  * @qrtr_tx_lock: lock for qrtr_tx_flow inserts
  * @hello_sent: hello packet send successful
@@ -131,6 +132,7 @@ struct qrtr_node {
 	struct qrtr_endpoint *ep;
 	struct kref ref;
 	unsigned int nid;
+	unsigned int ep_nid;
 
 	struct xarray qrtr_tx_flow;
 	struct mutex qrtr_tx_lock; /* for qrtr_tx_flow */
@@ -347,6 +349,7 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 {
 	struct qrtr_hdr_v1 *hdr;
 	size_t len = skb->len;
+	unsigned int dst_node;
 	int rc, confirm_rx;
 
 	mutex_lock(&node->ep_lock);
@@ -369,10 +372,14 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 	hdr->src_node_id = cpu_to_le32(from->sq_node);
 	hdr->src_port_id = cpu_to_le32(from->sq_port);
 	if (to->sq_port == QRTR_PORT_CTRL) {
-		hdr->dst_node_id = cpu_to_le32(READ_ONCE(node->nid));
+		hdr->dst_node_id = cpu_to_le32(READ_ONCE(node->ep_nid));
 		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
 	} else {
-		hdr->dst_node_id = cpu_to_le32(to->sq_node);
+		/* Put back the endpoint's own node id */
+		dst_node = to->sq_node;
+		if (dst_node == READ_ONCE(node->nid))
+			dst_node = node->ep_nid;
+		hdr->dst_node_id = cpu_to_le32(dst_node);
 		hdr->dst_port_id = cpu_to_le32(to->sq_port);
 	}
 
@@ -441,6 +448,32 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
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
@@ -531,16 +564,29 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	skb_put_data(skb, data + hdrlen, size);
 
-	qrtr_node_assign(node, cb->src_node);
+	if (node->ep_nid == QRTR_EP_NID_AUTO)
+		WRITE_ONCE(node->ep_nid, cb->src_node);
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
@@ -646,6 +692,7 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
 	node->nid = QRTR_EP_NID_AUTO;
+	node->ep_nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
 	node->hello_sent = false;

-- 
2.43.0


