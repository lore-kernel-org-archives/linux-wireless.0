Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7213DA5A6;
	Thu, 24 Sep 2026 05:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790227577; cv=none; b=RzkRcqWtCE9eiMEwZIeF/g3sGAZqyMu/rAFBPLIUmOTZl6EraVt1g5Q+yeNrW0n0LtVjHozWX3zR4qf4H74Tpe7Oedqf21HelyCa5oXWozwEt15NkIoUybViqfO+NeMiiTyYde5/fRqPa4OojlbAq6NWiIVvMr3qa1/zqYQdg84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790227577; c=relaxed/simple;
	bh=MOKgxvK2GbhIjjjrUaXgUWYu0O0lvw7UNyE/oPgUvnM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LkjDBUixXqWxzvUWrnuWQhVKGe6C2Z8L0wPlrcTXRN1PbX8sm2H7N6AK5v634Hajlwq2f1bhl94dw6OzGD0jKDtm6Aun9rygTQWpzA9paWlFMJh2H41Kes99R6FKAJzxkuny165+Vj5yKJzqu3FkGUrFdWdrRjeDF1pYsIFE9xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbXQqI/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbXQqI/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1261D1F00893;
	Thu, 24 Sep 2026 05:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790227575;
	bh=xj4V+fXnbcxjErRUl+dCGZWJvwjDZHZzoGy9OkhOG5c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jbXQqI/y/urPczlU4Oa2VCznyxNw/OUiTntcne14N7fAaQYCEwxWhnU+jJvXDGjqM
	 hFXfJVYNp+ia7Z9XmoRt5D/a3sn3kud3Coz50zerA908aTebEP06d4/oBJDki4Gfdj
	 8tXbuM+eEPmr4VwE97IXLYa8MsOV4tul2qacLMP0QBmdsl3qO8mC2soLazSI0D3cf/
	 z0RXxRdeCyDrL0HU28zyxKPUeHU8MKWoNXs9yEm0bDE1xBe6rodq3dOO+hZm6flawJ
	 jP1XtmNrRLj9oMksHrrkzqjqOyWqqXNkN6rJDynOnBEUmcdSFKUTRWLiYjGiDkjufV
	 rzm/fDZ5VN3Dg==
Subject: Re: [PATCH v2 4/4] wifi: ath12k: Connect to the QMI server belonging
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
Date: Thu, 24 Sep 2026 05:26:13 +0000
Message-ID: <179022757362.2160803.12263317870884528935@kernel.org>
In-Reply-To: <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-4-27dd80d841a0@oss.qualcomm.com>
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

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Incomplete node-id filtering in ath12k_qmi_ops_new_server(): the
  foreign device's WLFW server is "skipped" by returning 0, which the…
- [Low] Concern as filed: the patch lacks a Fixes: tag and silently
  depends on a QRTR change that registers MHI endpoints with…

Pre-existing issues:
- [Medium] Pre-existing resource leak (unrelated to this patch's change):
  ath12k_qmi_init_service()…

--

wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver

This adds a get_qrtr_node_id() HIF callback that returns the QRTR node id
derived from the MHI controller index, and uses it in
ath12k_qmi_ops_new_server() so a device only connects to the WLFW server
running on its own node. A node id of zero keeps the previous behaviour for
transports that do not assign one.

> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
> index 6441927b53822..2b1b122bbb3ba 100644
> --- a/drivers/net/wireless/ath/ath12k/pci.c
> +++ b/drivers/net/wireless/ath/ath12k/pci.c

[ ... ]

> @@ -1491,6 +1492,13 @@ static int ath12k_pci_panic_handler(struct ath12k_base *ab)
>  	return NOTIFY_OK;
>  }
>  
> +static int ath12k_pci_get_qrtr_node_id(struct ath12k_base *ab)
> +{
> +	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
> +
> +	return qrtr_host_node_id(ab_pci->mhi_ctrl->index);
> +}

[Severity: Low]
This isn't a bug, but could the commit message name the prerequisite change
this depends on?

On PCIe this helper always returns a non-zero id
(QRTR_NODE_HOST_BASE + index), so the new filter in
ath12k_qmi_ops_new_server() is unconditionally active, and it only matches
because net/qrtr/mhi.c now registers endpoints with the same id:

net/qrtr/mhi.c:qcom_mhi_qrtr_probe() {
	rc = qrtr_endpoint_register(&qdev->ep,
				    qrtr_host_node_id(mhi_dev->mhi_cntrl->index));
}

That registration comes from "net: qrtr: Assign unique node id for MHI
endpoints" in this same series, and the message only says "But now, QRTR
provides each MHI endpoint a unique node id". Without the QRTR patch, this
helper returns an id that matches no advertised server and every WLFW
server would be skipped, so spelling out the ordering requirement (and that
this must not be backported alone) would help future backporters.

[ ... ]

> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
> index 280e50a1f31d8..22b8cbbbf4f45 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.c
> +++ b/drivers/net/wireless/ath/ath12k/qmi.c

[ ... ]

> @@ -3940,8 +3941,18 @@ static int ath12k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
>  	struct ath12k_qmi *qmi = container_of(qmi_hdl, struct ath12k_qmi, handle);
>  	struct ath12k_base *ab = qmi->ab;
>  	struct sockaddr_qrtr *sq = &qmi->sq;
> +	int node_id;
>  	int ret;
>  
> +	/* Identical devices advertise the same QMI services, so connect only to
> +	 * the QMI server on this device's node. A node id of 0 means the
> +	 * transport has not assigned a unique node id, so accept the server
> +	 * unfiltered.
> +	 */
> +	node_id = ath12k_hif_get_qrtr_node_id(ab);
> +	if (node_id && service->node != node_id)
> +		return 0;
> +

[Severity: High]
Should this return a negative errno instead of 0 for the foreign node?

The QMI core only discards the service when new_server() returns negative:

drivers/soc/qcom/qmi_interface.c:qmi_recv_new_server() {
	ret = ops->new_server(qmi, svc);
	if (ret < 0)
		kfree(svc);
	else
		list_add(&svc->list_node, &qmi->lookup_results);
}

With "return 0", the other device's server stays recorded in
qmi->lookup_results on this device's handle, even though this device never
connected to it.

The teardown half of the lifecycle has no node id check. When the peer
device's firmware dies or the peer is unbound, net/qrtr/ns.c:server_del()
notifies every lookup matching service and instance, with no node
filtering:

net/qrtr/ns.c:server_del() {
	list_for_each(li, &qrtr_ns.lookups) {
		lookup = container_of(li, struct qrtr_lookup, li);
		if (lookup->service && lookup->service != srv->service)
			continue;
		if (lookup->instance && lookup->instance != srv->instance)
			continue;

		lookup_notify(&lookup->sq, srv, false);
	}
}

qmi_recv_del_server() then finds the retained foreign entry (also reached
with node/port == -1 from qmi_handle_net_reset() and qmi_handle_release())
and calls into the driver:

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_ops_del_server() {
	ath12k_dbg(ab, ATH12K_DBG_QMI, "qmi wifi fw del server\n");
	ath12k_qmi_driver_event_post(qmi, ATH12K_QMI_EVENT_SERVER_EXIT, NULL);
}

so this healthy device gets a SERVER_EXIT with no matching ARRIVE:

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_driver_event_work() {
		case ATH12K_QMI_EVENT_SERVER_EXIT:
			set_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags);
}

Can that latch the healthy device into the crash-flush state permanently?
ATH12K_FLAG_CRASH_FLUSH makes ath12k_dp_tx() and management TX return
-ESHUTDOWN, and ath12k_wmi_cmd_send()/ath12k_ce_send() fail the same way:

drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c:ath12k_dp_tx() {
	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags))
		return -ESHUTDOWN;
}

The bit is only cleared on this device's own FW_READY or core start, and
neither happens because this device's firmware never crashed.

Would returning a negative errno (so the core never records the foreign
service) plus the same node id check in ath12k_qmi_ops_del_server() cover
both halves?

[Severity: Medium]
This isn't a bug introduced by this patch, but while looking at the QMI
handle lifecycle in the same file: does ath12k_qmi_init_service() leak the
QMI handle on its two failure paths after qmi_handle_init() succeeded?

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_init_service() {
	ab->qmi.event_wq = alloc_ordered_workqueue("ath12k_qmi_driver_event", 0);
	if (!ab->qmi.event_wq) {
		ath12k_err(ab, "failed to allocate workqueue\n");
		return -EFAULT;
	}
	...
	if (ret < 0) {
		ath12k_warn(ab, "failed to add qmi lookup\n");
		destroy_workqueue(ab->qmi.event_wq);
		return ret;
	}
}

Neither path calls qmi_handle_release(), so qmi->recv_buf, the
"qmi_msg_handler" workqueue and the kernel QRTR socket created by
qmi_handle_init() stay allocated.

ath12k_core_soc_create() returns before its err_qmi_deinit label, and the
unwind loop in ath12k_core_hw_group_create() skips the device that just
failed:

drivers/net/wireless/ath/ath12k/core.c:ath12k_core_hw_group_create() {
destroy:
	for (i--; i >= 0; i--) {
		ab = ag->ab[i];
		...
		ath12k_core_soc_destroy(ab);
}

Probe then reaches ath12k_core_free() which kfree()s ab, while the leaked
socket still holds sk->sk_user_data pointing at &ab->qmi:

drivers/soc/qcom/qmi_interface.c:qmi_sock_create() {
	sock->sk->sk_user_data = qmi;
	sock->sk->sk_data_ready = qmi_data_ready;
}

Both paths require an allocation failure at probe time, so this is a cold
path only.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260921-qrtr-multi-ep-v2-0-27dd80d841a0%40oss.qualcomm.com
