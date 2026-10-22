Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792691002;
	b=GkdaXpTKi/JpbL2qZclra8A7RQ7AKO6kMJa0UFUSepb/hXdwjM5kVzZih4aZNGeWbJRI
	 EvzrgMMZqFaJns4rVcAhsyT8pDVVywtvlSkLnNb7S8joytLSPp5J5UY/cEXLRan/YvVQL
	 LM+ZXTOcCJTDTe64QUv03daZ1iDPA2deXDe/90Z3RWNXvqNwBE/Y3RgSeHqHeDt4TRcvF
	 Jh7f28Hr+g/Dl3yz8eL16mmlppWIsUeodXgbzVhoE4a4ERztMkG+EKahV17I7IQOjf7/m
	 lxJtlJZ37Htz/JNRLbFRUkE9++rlSCGZt0tQ8aGC0ECCt7IxZ1ZphqY1hqFasWCUzIA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792691002;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jKb7PqEa1GSJ89rT7jFbAIuoNyWYfDLHZ2mm84JIv2M=;
	b=YQlKi59/GEpLnIrbpr4infdRcVc4HTTUibg8E9m25xm0x1sBIA/qWMKX7lBZg5vieZQb
	 MEidhEQ/wmmBw7exD13urIryc3m+F/+xvQNORDD37klw8VSpzndfhWzLZdnyFoweFHeUm
	 7OQPPP8HTdaD+x5nqjl2Lnv8WWbQoGA5416P/p0VNWM6RPE/yFghaeedUnOtlyo0ICIGP
	 85TfUdNmimX8KZamAFtmdVxKZl/hXFAd3VnW7vcX13yLzooAFi58TzlaSslswhwVEaGXp
	 g6b0cG75OA3DRPet40I2R3sLNgyKbmjLWWzzgUxYjqWmBDV6QyHYeezF/oWcWO6hXnA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMR7KVvj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5AF606A331;
	Thu, 22 Oct 2026 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMR7KVvj
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792691001;
	b=GO6lt3CmN85kUkUyGhNiQaUwbmioRqoygI8gmghifMxQ5c//h/pPfV5a9A7De6Z3Bnxp
	 mkV6HR+ATK2ry4dRi+nK6XlKpjrTooeNNFb0swW73AZmLc5olj1e1hYgnCTy2Rh0cayQn
	 VYZh5eJKM77lew0bfIws+JAxsoD9kGgsZU3kJsFl8rHvh4NDYz5IW45LaX+E1ek6Hdd44
	 mQcvsJIZ3AxU48E85A0YePGzDGaerliBL+qOj0ke1BB9cj1BAweI7VfitXpUj9DYSa/xD
	 k9Qt/rRqLJMInDytMLAgGockB8u+VuWyLAsmFibIAP7D+VsyCOFm4S+48FNgiuEojSA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792691001;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=jKb7PqEa1GSJ89rT7jFbAIuoNyWYfDLHZ2mm84JIv2M=;
	b=H8psT42uTkJR/wbkliT4NgI78sXpqwNzCE4B06NNrpPCogLTMzK62ogX23a514Ad5rzl
	 ScQq4hkuGWQgviQdzM8xmJbJJgVYGYwnqsCvC2IdFCCwiekKiz+CTUctkr+iPO5BwFdiL
	 gY6dIJCuc47OC/VVmuWteq6kBiJWJ4w/ZT12vL+CdCRPbxc+5J2MOai6ohUTKSxFW8fRk
	 auPzuxWZBDSVxfIO2htvc1fDCSpDK5J8O+Zj5qaaNI4KznU5Rotuf8KYQzPd2E4rc0/JG
	 gVSfxH0sRs6XeFR7Nlk0H/BsfTHjEN4Trl4Do6BdvvcvfilXWRkRGWhES1v0iyNxb7A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 686811F031E3;
	Thu, 22 Oct 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792691000;
	bh=jKb7PqEa1GSJ89rT7jFbAIuoNyWYfDLHZ2mm84JIv2M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=VMR7KVvj2pe8VMYslGnehE8wuKikbZCqnu39KLm1EXHv/Ci5WJ+Ux/z7Pk6RWw/FY
	 /t6MOR4rJHfUx3ScnFB4LU1VKXWdAwAUoo4z41Req2DOk3RVTbM4mN2zNgamMu/mGY
	 v2lgOwSVhdH158hFTXnWNYvcBBQvzg5Ww4Lm+1QlJ6k97pK3BHX79xbmnkKQcKtU5E
	 S1BEC7FrmvnNVS1PCUEAwHKrQQRLWFlVl+7B2h1YdtJNndIPwJLhWCrY3Gjw2/TJL/
	 W0bXFJXF3WK9nRoJfvp9IssZHa96DgsFt/FjYojqbp2XDxKvOZZP5okjXprx+nc/Vc
	 vRnzc1C887TyQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C479341E8B;
	Thu, 22 Oct 2026 17:43:18 +0000 (UTC)
From: Manivannan Sadhasivam via B4 Relay <devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org>
Date: Thu, 22 Oct 2026 19:43:07 +0200
Subject: [PATCH v4 1/4] net: qrtr: Allow the host QRTR to assign a unique
 node id
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-qrtr-multi-ep-v4-1-c6fdb75fcd3e@oss.qualcomm.com>
References: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
In-Reply-To: <20261022-qrtr-multi-ep-v4-0-c6fdb75fcd3e@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9505;
 i=manivannan.sadhasivam@oss.qualcomm.com; h=from:subject:message-id;
 bh=KLyae5JhzWJr1Ty/Ia71KAfnJGB3RZ0IsPqDBQfCnU4=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBq2ks0GD1Td2Xxp2JqfTRjc77Qd5QF+mdgJwIga
 35gfmzznbKJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCatpLNAAKCRBVnxHm/pHO
 9VQ5CACp26rDMZXRGNVYqvtBgRQwlhxWH4v4CXcarYpuYIVcciouusfB4yNmqAsSLrUMe55WAPn
 aW8KG1fxggu0brxP52FBgirU7tThCs2IwZg1uY/UK4/RMieSEi1229J4J5AA0XwifpI6jFls6T5
 m9e3fBOz9hDOXCs8GQ7Ln04DSX6ilKIz8njuQts/bwc0lJPxY+hSdIzS5NzZGF943+8LpFB3zaE
 Y63XKHAksApUH66btBGXBxIHn/jn7IO5XONlQvJlPyLKwbmxe8zrYi4ZHnvyQTMV6sm3gDab5Yo
 F8LuDgBS6znS3yyHVjqvXk0oEAD2btCmEbBGpk6TCR4xVhbV
X-Developer-Key: i=manivannan.sadhasivam@oss.qualcomm.com; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008
X-Endpoint-Received: by B4 Relay for
 manivannan.sadhasivam@oss.qualcomm.com/default with auth_id=461
X-Original-From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reply-To: manivannan.sadhasivam@oss.qualcomm.com
Content-Transfer-Encoding: 7bit

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

A node can also bridge other distant nodes, so the source id of an
incoming packet is not always the id the endpoint advertises for itself.
Keep adding such ids to the radix tree as additional keys for the same
node, as it was done before this change. Otherwise the bridged nodes would
lose their route and qrtr_sendmsg() would start failing with -ECONNRESET
for them.

Currently, all QRTR endpoint drivers pass 'QRTR_EP_NID_AUTO' as the 'nid'
during qrtr_endpoint_register(). So 'ep_nid' and 'nid' are same and the
routing behavior is not changed.

Finally, since qrtr_node_rewrite_ctrl() dereferences the control packet for
DEL_SERVER and DEL_CLIENT as well, extend the existing length check in
qrtr_endpoint_post() to cover both types.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
---
 net/qrtr/af_qrtr.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 116 insertions(+), 16 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 78347c937af7..efa70b95f8a7 100644
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
+			dst_node = READ_ONCE(node->ep_nid);
+		hdr->dst_node_id = cpu_to_le32(dst_node);
 		hdr->dst_port_id = cpu_to_le32(to->sq_port);
 	}
 
@@ -422,23 +429,72 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int nid)
 	return node;
 }
 
-/* Assign node id to node.
+/* Add 'nid' as a lookup key for 'node', and adopt it as the node's own id if
+ * the node does not have one yet.
+ *
+ * Callers must hold 'qrtr_nodes_lock'.
  *
- * This is mostly useful for automatic node id assignment, based on
- * the source id in the incoming packet.
+ * Return: 0 on success; negative error code on failure
  */
-static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
+static int __qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 {
-	unsigned long flags;
+	int rc;
 
 	if (nid == QRTR_EP_NID_AUTO)
-		return;
+		return 0;
+
+	if (radix_tree_lookup(&qrtr_nodes, nid) == node)
+		return 0;
+
+	rc = radix_tree_insert(&qrtr_nodes, nid, node);
+	if (rc)
+		return rc;
 
-	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-	radix_tree_insert(&qrtr_nodes, nid, node);
 	if (node->nid == QRTR_EP_NID_AUTO)
 		WRITE_ONCE(node->nid, nid);
+
+	return 0;
+}
+
+/* Assign node id to node.
+ *
+ * Return: 0 on success; negative error code on failure
+ */
+static int qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+	rc = __qrtr_node_assign(node, nid);
 	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+
+	return rc;
+}
+
+/* Replace the node id in the control packet with 'node->nid', if both are
+ * different.
+ */
+static void qrtr_node_rewrite_ctrl(struct qrtr_node *node, unsigned int type,
+				   struct sk_buff *skb)
+{
+	unsigned int ep_nid = READ_ONCE(node->ep_nid);
+	unsigned int host_nid = READ_ONCE(node->nid);
+	struct qrtr_ctrl_pkt *pkt;
+	__le32 *nid;
+
+	if (host_nid == ep_nid)
+		return;
+
+	pkt = (struct qrtr_ctrl_pkt *)skb->data;
+	if (type == QRTR_TYPE_DEL_CLIENT || type == QRTR_TYPE_RESUME_TX)
+		nid = &pkt->client.node;
+	else
+		nid = &pkt->server.node;
+
+	/* Rewrite only the endpoint's node id, not those of bridged nodes */
+	if (le32_to_cpu(*nid) == ep_nid)
+		*nid = cpu_to_le32(host_nid);
 }
 
 /**
@@ -457,9 +513,12 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	struct qrtr_sock *ipc;
 	struct sk_buff *skb;
 	struct qrtr_cb *cb;
+	unsigned long flags;
 	size_t size;
 	unsigned int ver;
+	unsigned int nid;
 	size_t hdrlen;
+	int rc = 0;
 
 	if (len == 0 || len & 3)
 		return -EINVAL;
@@ -521,6 +580,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 
 	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
+	     cb->type == QRTR_TYPE_DEL_SERVER ||
+	     cb->type == QRTR_TYPE_DEL_CLIENT ||
 	     cb->type == QRTR_TYPE_RESUME_TX) &&
 	    size < sizeof(struct qrtr_ctrl_pkt))
 		goto err;
@@ -531,16 +592,46 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	skb_put_data(skb, data + hdrlen, size);
 
-	qrtr_node_assign(node, cb->src_node);
+	nid = cb->src_node;
+
+	spin_lock_irqsave(&qrtr_nodes_lock, flags);
+
+	if (node->ep_nid == QRTR_EP_NID_AUTO)
+		WRITE_ONCE(node->ep_nid, nid);
+
+	/* Add the source id to the lookup table only if 'node->nid' is auto
+	 * assigned or the packet came from a bridged node.
+	 */
+	if (node->nid == QRTR_EP_NID_AUTO || nid != node->ep_nid)
+		rc = __qrtr_node_assign(node, nid);
+
+	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
+
+	if (rc)
+		goto err_nid;
 
 	if (cb->type == QRTR_TYPE_NEW_SERVER) {
 		/* Remote node endpoint can bridge other distant nodes */
-		const struct qrtr_ctrl_pkt *pkt;
+		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
+
+		nid = le32_to_cpu(pkt->server.node);
 
-		pkt = data + hdrlen;
-		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
+		if (nid != READ_ONCE(node->ep_nid)) {
+			rc = qrtr_node_assign(node, nid);
+			if (rc)
+				goto err_nid;
+		}
 	}
 
+	if (cb->src_node == READ_ONCE(node->ep_nid))
+		cb->src_node = READ_ONCE(node->nid);
+
+	if (cb->type == QRTR_TYPE_NEW_SERVER ||
+	    cb->type == QRTR_TYPE_DEL_SERVER ||
+	    cb->type == QRTR_TYPE_DEL_CLIENT ||
+	    cb->type == QRTR_TYPE_RESUME_TX)
+		qrtr_node_rewrite_ctrl(node, cb->type, skb);
+
 	if (cb->type == QRTR_TYPE_RESUME_TX) {
 		qrtr_tx_resume(node, skb);
 	} else {
@@ -558,6 +649,8 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 
 	return 0;
 
+err_nid:
+	pr_err_ratelimited("qrtr: cannot route node id %u: %d\n", nid, rc);
 err:
 	kfree_skb(skb);
 	return -EINVAL;
@@ -634,6 +727,7 @@ static void qrtr_hello_work(struct work_struct *work)
 int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 {
 	struct qrtr_node *node;
+	int rc;
 
 	if (!ep || !ep->xmit)
 		return -EINVAL;
@@ -646,6 +740,7 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	mutex_init(&node->ep_lock);
 	skb_queue_head_init(&node->rx_queue);
 	node->nid = QRTR_EP_NID_AUTO;
+	node->ep_nid = QRTR_EP_NID_AUTO;
 	node->ep = ep;
 
 	node->hello_sent = false;
@@ -654,7 +749,12 @@ int qrtr_endpoint_register(struct qrtr_endpoint *ep, unsigned int nid)
 	xa_init(&node->qrtr_tx_flow);
 	mutex_init(&node->qrtr_tx_lock);
 
-	qrtr_node_assign(node, nid);
+	rc = qrtr_node_assign(node, nid);
+	if (rc) {
+		pr_err("qrtr: cannot assign node id %u: %d\n", nid, rc);
+		kfree(node);
+		return rc;
+	}
 
 	mutex_lock(&qrtr_node_lock);
 	list_add(&node->item, &qrtr_all_nodes);

-- 
2.43.0


