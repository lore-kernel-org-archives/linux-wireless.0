Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB01745198E;
	Fri, 25 Sep 2026 07:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322186; cv=none; b=LdoqGqf56tQqnVZv0H9nufD3+idlubOvdIKm5grWkSEnAtVBw3+AJlOpiQ1hJQDGdJi1zJ7kTTpwZHbYpYrQESLVTslWk7/5pDfs3/26bG3Zh4jKB4eZWLt4jsQX3LVsmP0m3+vG2W81h9+CmQXfgZoUQbV2wrvPKtzYb8lv0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322186; c=relaxed/simple;
	bh=jllz6hRfF1SGl97NqNA/qllNXwgefd0Qi0TWTDh3nfg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hPegsWOoUNvINNCCvrFiod5B1EutfyuHcQwKYi3X3RYM+kTOnaYj+Y32d0gLPX1T/FcEYuEHLK3htBzP4jZYIB3RvGflAruPfG+c5l1H1PVw4XD3S0j/4dA9Vgda4TXz1F7LLujdzcqjCvQS2CeLy6xXh9dSNSKgtGW6GD8P61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHc5u1cG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHc5u1cG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2A81F000FF;
	Fri, 25 Sep 2026 07:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322184;
	bh=cVANMQKZPjHd5wd5i5APPKVBqGOd+kRwHxJ+SOmJ9Xg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jHc5u1cG1I7YSnpE+wpgmnhdh7doW4yjw7my+gHGdNo+nZtFhTfsxoF89CxL9eo4U
	 ObfVbAm1UtihQpiZgqMGtpFFBYYto3mRdT6qSs8KFLXSP8404GuLJN/tToAIXQ2KdZ
	 RU3M9Xzay6sIIjEQ6XNUrmjPas/6uRFLMfZvfFw4vfc9/GKtDSPPB7ehMHpRGuy4qM
	 PVIFEHOgq4upd9igj5HJ2DetEGoqmdAO3WvTpiRRtyk5lCImH1EhI+L1ymdCvvniag
	 SPk/vzTv4PI326U6A/Pf6ROHobZaFO3lMIUJOFNfM1aHCSdTCWDzMudJjNT4YikUgN
	 rac+HIatu5FXA==
Subject:
 Re: [PATCH v3 1/4] net: qrtr: Allow the host QRTR to assign a unique node id
From: netdev-bot+sashiko@kernel.org
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: mani@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, jjohnson@kernel.org,
 linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, andersson@kernel.org,
 christopher.lew@oss.qualcomm.com, deepak.singh@oss.qualcomm.com,
 raj.bhagat@oss.qualcomm.com, juha-matti.tilli@iki.fi,
 jeff.hugo@oss.qualcomm.com, vasanthakumar.thiagarajan@oss.qualcomm.com
Date: Fri, 25 Sep 2026 07:43:02 +0000
Message-ID: <179032218286.2160803.9910557055402731112@kernel.org>
In-Reply-To: <20260922-qrtr-multi-ep-v3-1-c00831e88957@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-1-c00831e88957@oss.qualcomm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] qrtr_endpoint_post() (net/qrtr/af_qrtr.c:570) replaces the
  previously unconditional `qrtr_node_assign(node, cb->src_node)` with…
- [High] net: qrtr: bypass of node ID rewrite for short DEL_CLIENT
  packets
- [Medium] The lazy initialization of node->ep_nid in
  qrtr_endpoint_post() is an unlocked test-and-set: `if (node->ep_nid ==…
- [Low] The new gate `if (node->nid == QRTR_EP_NID_AUTO || node->nid ==
  cb->src_node)` at af_qrtr.c:570 reads node->nid with plain loads…

--

net: qrtr: Allow the host QRTR to assign a unique node id

This adds a per-node 'ep_nid' field holding the node id as received from
the remote endpoint, keeps 'nid' as the host-assigned radix tree key, and
translates between the two in qrtr_endpoint_post() and
qrtr_node_enqueue(). A few questions below about the changes to the node
id learning logic and about the locking around the new field.

> diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
> index 78347c937af76..6387b85a7a2c7 100644
> --- a/net/qrtr/af_qrtr.c
> +++ b/net/qrtr/af_qrtr.c

[ ... ]

> @@ -369,10 +372,14 @@ static int qrtr_node_enqueue(struct qrtr_node *node, struct sk_buff *skb,
>  	hdr->src_node_id = cpu_to_le32(from->sq_node);
>  	hdr->src_port_id = cpu_to_le32(from->sq_port);
>  	if (to->sq_port == QRTR_PORT_CTRL) {
> -		hdr->dst_node_id = cpu_to_le32(READ_ONCE(node->nid));
> +		hdr->dst_node_id = cpu_to_le32(READ_ONCE(node->ep_nid));
>  		hdr->dst_port_id = cpu_to_le32(QRTR_PORT_CTRL);
>  	} else {
> +		/* Put back the endpoint's own node id */
> +		dst_node = to->sq_node;
> +		if (dst_node == READ_ONCE(node->nid))
> +			dst_node = node->ep_nid;
> +		hdr->dst_node_id = cpu_to_le32(dst_node);
>  		hdr->dst_port_id = cpu_to_le32(to->sq_port);
>  	}

[ ... ]

> @@ -441,6 +448,32 @@ static void qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
>  	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
>  }
>  
> +/* Replace the node id in the control packet with 'node->nid', if both are
> + * different.
> + */
> +static void qrtr_node_rewrite_ctrl(struct qrtr_node *node, unsigned int type,
> +				   struct sk_buff *skb)
> +{
> +	struct qrtr_ctrl_pkt *pkt;
> +	__le32 *nid;
> +
> +	if (node->nid == node->ep_nid)
> +		return;
> +
> +	if (skb->len < sizeof(*pkt))
> +		return;
> +
> +	pkt = (struct qrtr_ctrl_pkt *)skb->data;
> +	if (type == QRTR_TYPE_DEL_CLIENT || type == QRTR_TYPE_RESUME_TX)
> +		nid = &pkt->client.node;
> +	else
> +		nid = &pkt->server.node;
> +
> +	/* Rewrite only the endpoint's node id, not those of bridged nodes */
> +	if (le32_to_cpu(*nid) == node->ep_nid)
> +		*nid = cpu_to_le32(node->nid);
> +}
> +

[Severity: High]
Does this length check skip the rewrite for DEL_CLIENT packets that
carry only the client part of the union?

sizeof(struct qrtr_ctrl_pkt) is 20 bytes because of the server member.
A DEL_CLIENT only needs cmd, client.node and client.port, which is 12
bytes. qrtr_endpoint_post() enforces the full struct size only for
QRTR_TYPE_NEW_SERVER and QRTR_TYPE_RESUME_TX. A 12 byte DEL_CLIENT from
the remote therefore passes validation and is queued to the control
port, but this function returns before it touches pkt->client.node.

qrtr_endpoint_post() has already translated cb->src_node from ep_nid to
nid a few lines earlier. The name service then sees a sender that does
not match the payload:

net/qrtr/ns.c:ctrl_cmd_del_client() {
	...
	/* Don't accept spoofed messages */
	if (from->sq_node != node_id)
		return -EINVAL;
	...
}

Here from->sq_node is node->nid and node_id is still node->ep_nid, so
the command is rejected. As a result:

- the lookups owned by that remote port are never removed;
- the server registered on that port under nid is never deleted;
- local servers are never told that the remote client went away.

Local clients keep being pointed at a server that no longer exists.
The packet length is chosen by the remote firmware or by a qrtr-tun
writer, so this does not depend on well-behaved peers.

This only matters once an endpoint registers with a nid that differs
from the id the remote uses, which is what this series enables.

Would it be better to check against the end of the member being
rewritten? That would mean offsetofend(struct qrtr_ctrl_pkt,
client.node) for DEL_CLIENT and RESUME_TX, and offsetofend(struct
qrtr_ctrl_pkt, server.node) for the server types.

Or, if short DEL_CLIENT packets are not supposed to exist, should
qrtr_endpoint_post() reject them up front instead of delivering an
untranslated payload to the control port?

[ ... ]

> @@ -531,16 +564,30 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>  
>  	skb_put_data(skb, data + hdrlen, size);
>  
> -	qrtr_node_assign(node, cb->src_node);
> +	if (node->ep_nid == QRTR_EP_NID_AUTO)
> +		WRITE_ONCE(node->ep_nid, cb->src_node);

[Severity: Medium]
Is this test-and-set of node->ep_nid safe against concurrent callers?

node->nid is initialized under qrtr_nodes_lock inside qrtr_node_assign(),
but ep_nid is written here with no lock, and the two fields are never
published as a pair. qrtr_endpoint_post() is an exported entry point that
qrtr_tun_write_iter() in net/qrtr/tun.c calls straight from write(2):

net/qrtr/tun.c:qrtr_tun_write_iter() {
	...
	ret = qrtr_endpoint_post(&tun->ep, kbuf, len);
	...
}

Two threads writing the same /dev/qrtr-tun descriptor reach this on the
same qrtr_node with no serialization:

CPU0 qrtr_endpoint_post(src=A)
    reads node->ep_nid == QRTR_EP_NID_AUTO

CPU1 qrtr_endpoint_post(src=B)
    reads node->ep_nid == QRTR_EP_NID_AUTO
    WRITE_ONCE(node->ep_nid, B)
    qrtr_node_assign(node, B) -> node->nid = B

CPU0
    WRITE_ONCE(node->ep_nid, A)

Doesn't that leave (nid = B, ep_nid = A) permanently for an endpoint that
passed QRTR_EP_NID_AUTO, which then switches on all the translation paths
-- the cb->src_node relabelling below, qrtr_node_rewrite_ctrl(), and the
dst_node rewrite in qrtr_node_enqueue()? The enqueue path would then put
ep_nid on the wire for a destination that the peer knows as nid.

Note node->ep_lock cannot be used for this, since qrtr_endpoint_post() is
also called from atomic context (net/qrtr/mhi.c downlink callback), so the
pair would have to be published under the IRQ-safe qrtr_nodes_lock or with
a cmpxchg.

On the reader side, the patch mixes annotations for the same field:
qrtr_node_enqueue() uses READ_ONCE(node->ep_nid) in the control-port case
but a plain load in the dst_node case, and qrtr_node_rewrite_ctrl() loads
ep_nid twice without annotation:

	if (node->nid == node->ep_nid)
		return;
	...
	if (le32_to_cpu(*nid) == node->ep_nid)
		*nid = cpu_to_le32(node->nid);

Can a concurrent update between those two loads let the function pass the
equality test and then rewrite the payload with a value inconsistent with
the cb->src_node translation done a few lines earlier?

> +
> +	if (node->nid == QRTR_EP_NID_AUTO || node->nid == cb->src_node)
> +		qrtr_node_assign(node, cb->src_node);

[Severity: High]
Does this gate drop the src_node based learning of bridged nodes?

Before this patch the call was unconditional, so every distinct src_node
seen on an endpoint was inserted into qrtr_nodes. Once node->nid is
latched -- which for a QRTR_EP_NID_AUTO endpoint happens on the very first
received packet, and for a host-assigned endpoint already happens in
qrtr_endpoint_register() -- the condition can only be true for that one
id, so no further source node id is ever inserted.

That src_node learning came in with commit e04df98adf7d7d, and the
multi-key-per-node model is still assumed elsewhere in the file:

net/qrtr/af_qrtr.c:__qrtr_node_release() {
	...
	/* If the node is a bridge for other nodes, there are possibly
	 * multiple entries pointing to our released node, delete them all.
	 */
	...
}

The QRTR_TYPE_NEW_SERVER branch below only learns pkt->server.node, so a
bridged node that never announces a server is never inserted. For such a
node, what happens to a local socket that already received a packet from
it? qrtr_recvmsg() hands that sq_node to userspace, but the reply path
looks the id up again:

net/qrtr/af_qrtr.c:qrtr_sendmsg() {
	...
		node = qrtr_node_lookup(addr->sq_node);
		if (!node) {
			release_sock(sk);
			return -ECONNRESET;
		}
	...
}

And if the received data had confirm_rx set, qrtr_recvmsg() ->
qrtr_send_resume_tx() hits the same lookup:

net/qrtr/af_qrtr.c:qrtr_send_resume_tx() {
	...
	node = qrtr_node_lookup(remote.sq_node);
	if (!node)
		return -EINVAL;
	...
}

so no QRTR_TYPE_RESUME_TX goes out and the remote's pending counter stays
at the high watermark, stalling transmission.

Given that, is the commit message statement still accurate?

    "Currently, all QRTR endpoint drivers pass 'QRTR_EP_NID_AUTO' as the
    'nid' during qrtr_endpoint_register(). So 'ep_nid' and 'nid' are same
    and the functionality is not changed."

The ids here are learned from remote packets, so this looks reachable with
ordinary traffic on the existing tun, smd and mhi endpoints.

[Severity: Low]
Should this decision be made inside qrtr_nodes_lock instead of as an
unlocked pre-check?

node->nid is written under qrtr_nodes_lock with WRITE_ONCE in
qrtr_node_assign(), and the other lockless readers in this file use
READ_ONCE, but the gate here uses plain loads and the check is not atomic
with the radix_tree_insert() plus nid latch it guards. With
node->nid == QRTR_EP_NID_AUTO and two concurrent qrtr_endpoint_post()
calls on the same node:

CPU0 (src=3)                      CPU1 (src=7)
  gate: nid == AUTO -> true         gate: nid == AUTO -> true
  qrtr_node_assign(node, 3)
    radix_tree_insert(.., 3, node)
    node->nid = 3
                                    qrtr_node_assign(node, 7)
                                      radix_tree_insert(.., 7, node)
                                      (inner re-check leaves nid = 3)

Doesn't that alias one node under two keys again and permanently occupy
key 7 -- radix_tree_insert()'s -EEXIST return is discarded -- so a
genuinely distinct remote with id 7 can no longer be inserted? That is the
aliasing the change is meant to prevent. Moving the test inside
qrtr_node_assign() under the spinlock would also remove the plain reads of
a WRITE_ONCE-written field that KCSAN would flag.

>  
>  	if (cb->type == QRTR_TYPE_NEW_SERVER) {
>  		/* Remote node endpoint can bridge other distant nodes */
> -		const struct qrtr_ctrl_pkt *pkt;
> +		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
> +		unsigned int server_node = le32_to_cpu(pkt->server.node);
>  
> -		pkt = data + hdrlen;
> -		qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
> +		if (server_node != node->ep_nid)
> +			qrtr_node_assign(node, server_node);
>  	}
>  
> +	if (cb->src_node == node->ep_nid)
> +		cb->src_node = node->nid;
> +
> +	if (cb->type == QRTR_TYPE_NEW_SERVER ||
> +	    cb->type == QRTR_TYPE_DEL_SERVER ||
> +	    cb->type == QRTR_TYPE_DEL_CLIENT ||
> +	    cb->type == QRTR_TYPE_RESUME_TX)
> +		qrtr_node_rewrite_ctrl(node, cb->type, skb);
> +
>  	if (cb->type == QRTR_TYPE_RESUME_TX) {
>  		qrtr_tx_resume(node, skb);
>  	} else {

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922-qrtr-multi-ep-v3-0-c00831e88957%40oss.qualcomm.com
