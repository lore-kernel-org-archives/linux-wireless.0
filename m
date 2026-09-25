Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED09450906;
	Fri, 25 Sep 2026 07:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322188; cv=none; b=cQ1kTWChxDPkviZZooH6l//OsjW/frf+SMDr9us1txIfhQneJTFABT5+EF6O2N3k8Sjz6fep3SHQLSkqOZrwTDn0gLNYs+qZyoeRQrL1SCxSOEQBtysJy7lKHMbfpxBpYFJmLu1c0PH7so5lFA9W0EW/Fq7AyYrtStpZWqWQkk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322188; c=relaxed/simple;
	bh=YNXtFjvyb3GSbT9Bt0H5xnYR5fGff1etDl5cSWGXLzA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AsGn7A/nyhKKLSaHNTxumoGJDOoLMK8eeUYOK9oRbWTZ/9KXCD5VOUalU3Fh6tIEdqW2nJy7cfvzHFyptmbrBxC330Pe6zrjP5VC9mibJF7vfF/eMysbVvMhF8XufgiTQd/QL+PJO9SQSPgzZHZxkERfWZ0Cca0akNmk+iBQxFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mog7VeWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mog7VeWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0120D1F00893;
	Fri, 25 Sep 2026 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322186;
	bh=A+/ZOxHm6vyn+HPmLAm+mBLWT8aujPWodA4YaAiWG1w=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Mog7VeWGKlsX/h/H8y9ZneWEHujm/9eNGcq2Whb2dos7RQ8azpcuXnCuDhK5mv1Kf
	 MOTDiL9WWtqcfsljjiwYEo6MLA/K86nEA4zQSEeuhfl8oEqqWB9toFvZ7fqZmWWO1T
	 EurVyGcYFOg+xn/Qh+6NJQdZSXGebf7fEY0H6i3ymWdYuDwyOLS+iSCqbd1JlO3AQW
	 tvU3Zro8nD4ZbOM6MPCsJpQ19YbxNPUHw/LaLZ1IdO9bsr90KRpM5NCZeUMktiA9hR
	 knj3nFveIK3B/J7+JMmd6qkg4wGjr0j2qGducmhP0PS3Ll9jqct/6+DlEpLTm/+Jpj
	 ki2LIPfhHOqng==
Subject: Re: [PATCH v3 2/4] net: qrtr: Assign unique node id for MHI endpoints
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
Date: Fri, 25 Sep 2026 07:43:04 +0000
Message-ID: <179032218458.2160803.5581114155035045952@kernel.org>
In-Reply-To: <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-2-c00831e88957@oss.qualcomm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 2 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The reserved host node-id namespace introduced by this patch
  (`QRTR_NODE_HOST_BASE` = 0x10000, `qrtr_host_node_id()`) is only…
- [High] `qrtr_endpoint_register()` now performs the `qrtr_nodes` radix-
  tree insertion at registration time (because net/qrtr/mhi.c:131-132 is…

--

net: qrtr: Assign unique node id for MHI endpoints

This adds a new header, include/net/qrtr.h, defining QRTR_NODE_HOST_BASE
(0x10000) and a helper qrtr_host_node_id() that derives a host assigned
node id from a per-device index, and switches the MHI endpoint driver to
register with qrtr_host_node_id(mhi_dev->mhi_cntrl->index) instead of
QRTR_EP_NID_AUTO.

> diff --git a/include/net/qrtr.h b/include/net/qrtr.h
> new file mode 100644
> index 0000000000000..745d51b4a6ba6
> --- /dev/null
> +++ b/include/net/qrtr.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _NET_QRTR_H
> +#define _NET_QRTR_H
> +
> +#include <linux/types.h>
> +
> +/* The offset is chosen carefully to not collide with the node ids allocated by
> + * the remote nodes. All the remote nodes use node ids in range 0 to 0xffff.
> + */
> +#define QRTR_NODE_HOST_BASE 0x10000u

[Severity: High]
Is the "range 0 to 0xffff" property actually enforced anywhere, or is it
only a convention documented in this comment?

In qrtr_endpoint_post() the v1 path takes the full 32-bit id straight from
the wire with no upper bound:

net/qrtr/af_qrtr.c:qrtr_endpoint_post() {
	...
	cb->src_node = le32_to_cpu(v1->src_node_id);
	...
}

and the NEW_SERVER handling will insert any 32-bit value into the global
qrtr_nodes tree:

net/qrtr/af_qrtr.c:qrtr_endpoint_post() {
	...
	if (cb->type == QRTR_TYPE_NEW_SERVER) {
		/* Remote node endpoint can bridge other distant nodes */
		const struct qrtr_ctrl_pkt *pkt = data + hdrlen;
		unsigned int server_node = le32_to_cpu(pkt->server.node);

		if (server_node != node->ep_nid)
			qrtr_node_assign(node, server_node);
	}
	...
}

Can a remote endpoint (firmware over MHI, or a writer on /dev/qrtr-tun,
whose bytes reach qrtr_endpoint_post() unmodified via
qrtr_tun_write_iter()) therefore claim 0x10000 + controller_index before or
after the genuine MHI endpoint registers?

qrtr_node_assign() drops the insert result while still setting node->nid:

net/qrtr/af_qrtr.c:qrtr_node_assign() {
	...
	spin_lock_irqsave(&qrtr_nodes_lock, flags);
	radix_tree_insert(&qrtr_nodes, nid, node);
	if (node->nid == QRTR_EP_NID_AUTO)
		WRITE_ONCE(node->nid, nid);
	spin_unlock_irqrestore(&qrtr_nodes_lock, flags);
}

so if the id is already taken, does qrtr_node_lookup() resolve it to the
squatting node, sending unicast qrtr_sendmsg() and name service traffic
aimed at the host assigned id to the wrong endpoint while the real one
believes it owns that id?

Note also that qrtr_node_rewrite_ctrl() only rewrites ids equal to
node->ep_nid, so a bridged server.node of 0x10000 + k reaches the name
service unchanged and is stored as a server on that node id.

This matters for the rest of the series: the ath11k and ath12k changes use
the host node id as the device identity filter, for example

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_ops_new_server() {
	...
	node_id = ath12k_hif_get_qrtr_node_id(ab);
	if (node_id && service->node != node_id)
		return 0;
	...
}

If the id can be advertised by another endpoint, does the "device may
connect to the firmware running on the other device" case the series aims
to close remain reachable?  Would rejecting remote supplied ids >=
QRTR_NODE_HOST_BASE in qrtr_endpoint_post()/qrtr_node_assign() make the
documented invariant real?

> +
> +/* Compute host node id from a per-device index. The index must be unique
> + * among the host assigned endpoints and smaller than QRTR_NODE_HOST_BASE.
> + */
> +static inline unsigned int qrtr_host_node_id(unsigned int index)
> +{
> +	return QRTR_NODE_HOST_BASE + index;
> +}
> +
> +#endif /* _NET_QRTR_H */

> diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
> index 3990da1a65dc4..c920ab61f8487 100644
> --- a/net/qrtr/mhi.c
> +++ b/net/qrtr/mhi.c

[ ... ]

> @@ -127,7 +128,8 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
>  	if (rc)
>  		return rc;
>  
> -	rc = qrtr_endpoint_register(&qdev->ep, QRTR_EP_NID_AUTO);
> +	rc = qrtr_endpoint_register(&qdev->ep,
> +				    qrtr_host_node_id(mhi_dev->mhi_cntrl->index));
>  	if (rc)
>  		goto err_unprepare;

[Severity: High]
This is the first caller to pass a concrete nid rather than
QRTR_EP_NID_AUTO, which moves the qrtr_nodes insertion into the
registration path.  Should the failure of that insertion be detected here?

qrtr_endpoint_register() calls qrtr_node_assign() and ignores the outcome,
then publishes the endpoint and returns 0 unconditionally:

net/qrtr/af_qrtr.c:qrtr_endpoint_register() {
	...
	qrtr_node_assign(node, nid);

	mutex_lock(&qrtr_node_lock);
	list_add(&node->item, &qrtr_all_nodes);
	mutex_unlock(&qrtr_node_lock);
	ep->node = node;
	...
	return 0;
}

and qrtr_node_assign() discards radix_tree_insert()'s return value while
setting node->nid anyway:

net/qrtr/af_qrtr.c:qrtr_node_assign() {
	...
	radix_tree_insert(&qrtr_nodes, nid, node);
	if (node->nid == QRTR_EP_NID_AUTO)
		WRITE_ONCE(node->nid, nid);
	...
}

Are there two reachable failure modes here?

The tree is declared static RADIX_TREE(qrtr_nodes, GFP_ATOMIC) and the
insert runs under spin_lock_irqsave() with no radix_tree_preload(), so
inserting key 0x10000 needs to extend the tree height and can return
-ENOMEM under memory pressure.

-EEXIST looks reachable too: mhi_unregister_controller() does
ida_free(&mhi_controller_ida, mhi_cntrl->index), so indexes and the derived
node ids get recycled, while the previous qrtr_node's radix slots are only
removed in __qrtr_node_release() on the last kref drop, which a sender
blocked in qrtr_tx_wait() can delay.

In either case node->nid is 0x10000 + index but qrtr_nodes has no entry (or
a stale one) for it, and qcom_mhi_qrtr_probe() still returns 0.  Is the
state permanent?  The condition in qrtr_endpoint_post() that used to retry
the insert

	if (node->nid == QRTR_EP_NID_AUTO || node->nid == cb->src_node)
		qrtr_node_assign(node, cb->src_node);

can never be true for a host assigned nid, since 0x10000 + index never
equals the remote's own id.

That would leave every unicast qrtr_sendmsg() to this node id returning
-ECONNRESET from qrtr_node_lookup() for the life of the device, the receive
path still stamping cb->src_node = node->nid so servers are advertised on
an unroutable id, and qrtr_endpoint_unregister() (which walks radix slots
pointing at the node to build the QRTR_TYPE_BYE notification) emitting no
BYE at all.

Would it be better for qrtr_node_assign() to return the insert error and
qrtr_endpoint_register() to propagate it so probe fails visibly?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922-qrtr-multi-ep-v3-0-c00831e88957%40oss.qualcomm.com
