Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2185F3BFE4D;
	Thu, 24 Sep 2026 05:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790227575; cv=none; b=YhjhhFPE+15zErY/xsQgBrAkZjZEe8eHbBZJkdy3N7WEZXlL86vHxUb57QIDHou8U9iPtjJ1gEZed11wxAw54w2ZcHQM7ISZGDjoqmgWfi5Rks/WQOs9zzfHmkb6BmwaRMs92l8gFrNlb9m9fA/7P9s/Nl+JejoO8tao5cXVQKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790227575; c=relaxed/simple;
	bh=qDEICL1NI6XMAWooVpnT3ZZtb+maeVyyP3s4gahuDfc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oaqDmvnu+Dz082rcGp6G6R8PCbOLPsb5lu5xk25lN7BV97yvBsxsRwmOW/RHefRVJYqpriSM862tgZXacBAMk2dxolmAJ2XotNQdsbS4lFu2Lz4GV2tpUv+WRbNEZ2Ws+UX2n5JJEtVBX57dfvBiqdRopfK/QIJMEidL7wLrhMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJu52kUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJu52kUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478431F00898;
	Thu, 24 Sep 2026 05:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790227573;
	bh=/mcb9L3lJWShw32hnPivU4U8fBXyRc17xUv4CFb97zk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=MJu52kUa+bHCSqIEtpiQSjOnL0vs8+IahaPQ/7XqlXtzCFXyfx3l8eBSiK9wQIpHA
	 /kTCGO3HjuKwPlXgVeIQ1yqVLF8kzEuXduQqxraZ3nnUApZsgrkeQLEbOGf8uNgE7S
	 j41LuowTxxg+0KV+AYw+p9yYOiTytS//nL9RORYStno6n4khs8breNfcu7FV3rIz67
	 w7TnM0/mhZpjOuIc0HNLtBzjYxlxYxWPhVFCWuwhsHOFscyZNKDq2qWIjpM8/UJ4v2
	 JsHvsSgeyIbfwEMuAbGvkd9i3nIwWXl/lpdEdpW1ViEAsM2pkIzJbxN0wAjPSqG5Zu
	 tocgVuBrpR8+Q==
Subject: Re: [PATCH v2 3/4] wifi: ath11k: Connect to the QMI server belonging
 to the device owned by this driver
From: netdev-bot+sashiko@kernel.org
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: mani@kernel.org, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, jjohnson@kernel.org,
 linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org, andersson@kernel.org,
 christopher.lew@oss.qualcomm.com, deepak.singh@oss.qualcomm.com,
 raj.bhagat@oss.qualcomm.com, juha-matti.tilli@iki.fi,
 jeff.hugo@oss.qualcomm.com
Date: Thu, 24 Sep 2026 05:26:11 +0000
Message-ID: <179022757180.2160803.15859987957675595749@kernel.org>
In-Reply-To: <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete fix: ath11k_qmi_ops_new_server() returns 0 (success)
  when it decides to skip a WLFW server that belongs to the *other*…
- [Low] Concern that the commit fixes a real user-visible multi-device
  initialization bug (identical ath11k PCIe cards connecting to each…

--

wifi: ath11k: Connect to the QMI server belonging to the device owned by this driver

This adds a get_qrtr_node_id() HIF callback returning the QRTR node id
derived from the MHI controller index, and uses it in the QMI new_server
callback so a device only connects to the WLFW server running on its own
node. A node id of zero keeps the previous unfiltered behaviour.

[Severity: Low]
This isn't a bug, but the commit fixes a user-visible misbehaviour (two
identical ath11k PCIe cards connecting to each other's WLFW firmware) and
carries no Fixes: trailer.

The fix depends on qrtr_host_node_id()/QRTR_NODE_HOST_BASE in
include/net/qrtr.h and on the host-assigned node id plus the
NEW_SERVER/DEL_SERVER node rewrite from the preceding net/qrtr patches, so
a Fixes: tag pointing at the original ath11k commit would invite stable
tooling to pick this up without those dependencies.

Would it help to say so explicitly in the commit message, for example
"depends on the preceding net/qrtr changes; not suitable for stable on its
own", instead of leaving the tag out silently?

> diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
> index 7dc07339b9579..dadf78f30b897 100644
> --- a/drivers/net/wireless/ath/ath11k/qmi.c
> +++ b/drivers/net/wireless/ath/ath11k/qmi.c
> @@ -3170,8 +3170,18 @@ static int ath11k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
>  	struct ath11k_qmi *qmi = container_of(qmi_hdl, struct ath11k_qmi, handle);
>  	struct ath11k_base *ab = qmi->ab;
>  	struct sockaddr_qrtr *sq = &qmi->sq;
> +	int node_id;
>  	int ret;
>  
> +	/* Identical devices advertise the same QMI services, so connect only to
> +	 * the QMI server on this device's node. A node id of 0 means the
> +	 * transport has not assigned a unique node id, so accept the server
> +	 * unfiltered.
> +	 */
> +	node_id = ath11k_hif_get_qrtr_node_id(ab);
> +	if (node_id && service->node != node_id)
> +		return 0;
> +

[Severity: High]
Should this return a negative errno rather than 0 when the server belongs
to the other device's node?

The QMI core only drops the service record when ->new_server() returns a
negative value:

drivers/soc/qcom/qmi_interface.c:qmi_recv_new_server() {
	...
	ret = ops->new_server(qmi, svc);
	if (ret < 0)
		kfree(svc);
	else
		list_add(&svc->list_node, &qmi->lookup_results);
}

So returning 0 here keeps the foreign node's WLFW service on this handle's
lookup_results list, even though we deliberately did not connect to it.

When that foreign server later goes away (sibling firmware crash, unbind of
the other card, or its MHI endpoint unregistering), net/qrtr/ns.c
server_del()/ctrl_cmd_bye() call lookup_notify() for every lookup matching
the service/instance, which reaches this device's handle:

drivers/soc/qcom/qmi_interface.c:qmi_recv_del_server() {
	list_for_each_entry_safe(svc, tmp, &qmi->lookup_results, list_node) {
		if (node != -1 && svc->node != node)
			continue;
		...
		if (ops->del_server)
			ops->del_server(qmi, svc);
}

ath11k_qmi_ops_del_server() does no node filtering and posts
ATH11K_QMI_EVENT_SERVER_EXIT unconditionally, which in
ath11k_qmi_driver_event_work() does:

		case ATH11K_QMI_EVENT_SERVER_EXIT:
			set_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags);
			set_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags);

			if (!ab->is_reset)
				ath11k_core_pre_reconfigure_recovery(ab);

Can this drive crash-flush and recovery on the healthy device whose own
firmware never went down?  Since the new filter also rejects the foreign
node's re-announcement, no matching SERVER_ARRIVE follows, so does that
adapter stay stuck with ATH11K_FLAG_CRASH_FLUSH and ATH11K_FLAG_RECOVERY
set until the driver is reloaded?

Would returning a negative errno here (so the core frees the record), and/or
adding the same node id check to ath11k_qmi_ops_del_server(), cover the
del_server side of the cross-device confusion as well?

>  	sq->sq_family = AF_QIPCRTR;
>  	sq->sq_node = service->node;
>  	sq->sq_port = service->port;

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921-qrtr-multi-ep-v2-0-27dd80d841a0%40oss.qualcomm.com
