Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BF04519BB;
	Fri, 25 Sep 2026 07:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322192; cv=none; b=RHuGKjcQ2gwBKZHLKVCH0aHrDFAmv02FnkYq+OlEvbsmB0tbeKGhSc9FEUj7wKtGo6DP2Y9XTxneleK4ublSUEJMo+S4yfg7T9QAf+5gZh9wYNV819LB9N0HXik96+iFvAKL/sm+ZXC59xBj6/JVBl8AUV3bus4WnQds0kLNYHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322192; c=relaxed/simple;
	bh=xPEe5jkdF5YSoL1E6T96XLS5oifDoBhy6Tiwt4Lc3h8=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d3ZWT9uRFiYU5BOhcBm/hssjRojThxgdn7LcL4/l0QZJesor1xMil5Zzkm0EOmfuQV4xGGCLP3Jq51VATIc0LiAW/IwsSp6W2CAM1y2fZuRAvE36Wt76x784K4nrTkg7xwyAQ0B6jXyimd95i9cxhy95ifJnOu7bVQccYCl+Sh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZNaeOYUA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZNaeOYUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE041F00893;
	Fri, 25 Sep 2026 07:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322189;
	bh=J4wdaguWE/ZqpPdeXzSQfiixTrYmLIJekiR1g9Uc47M=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZNaeOYUARCnFTkJ8RwGy8wachYINCt+qUCQS5bJWdcwyeFetQTq814utR/08JM1mh
	 01xyv0JJioI067Lbp1B1xzh1RLTyxO9VhOAvpItUBEXyW3wniNOMUfaubbxRs1Li1i
	 C/IIoKGPkesLPZ0KwyNss+6DzyyhC3lVEgdcGAq+W6qEIG9E/0+bJqOKUjxWrb8iTa
	 UBdjL6pQqiEMyceB6aoYdIwI6su5pDzhcqa/CdrXPoaf74g6xmWMBQ5ycEKm4wLH1W
	 HPLMfmvo34gFHphnxLn/NgMOxmoWVR5BgkT3VjmS4sE7VJfNk75klCKQWE0JXY5muK
	 zg4kZQyQh042A==
Subject: Re: [PATCH v3 4/4] wifi: ath12k: Connect to the QMI server belonging
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
 jeff.hugo@oss.qualcomm.com, vasanthakumar.thiagarajan@oss.qualcomm.com
Date: Fri, 25 Sep 2026 07:43:07 +0000
Message-ID: <179032218792.2160803.6446248222489442159@kernel.org>
In-Reply-To: <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
References: <20260922-qrtr-multi-ep-v3-4-c00831e88957@oss.qualcomm.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Asymmetric node-id filtering in ath12k QMI:
  ath12k_qmi_ops_new_server()…

--

wifi: ath12k: Connect to the QMI server belonging to the device owned by this driver

This patch adds a get_qrtr_node_id() HIF callback that returns the QRTR node
id derived from the MHI controller index, and uses it in the QMI new_server
callback to skip WLFW services that live on a different node. A node id of
zero keeps the previous unfiltered behaviour.

> diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
> index 280e50a1f31d8..e1e75cc9d1441 100644
> --- a/drivers/net/wireless/ath/ath12k/qmi.c
> +++ b/drivers/net/wireless/ath/ath12k/qmi.c

[ ... ]

> @@ -3940,8 +3941,18 @@ static int ath12k_qmi_ops_new_server(struct qmi_handle *qmi_hdl,
>  	struct ath12k_qmi *qmi = container_of(qmi_hdl, struct ath12k_qmi, handle);
>  	struct ath12k_base *ab = qmi->ab;
>  	struct sockaddr_qrtr *sq = &qmi->sq;
> +	unsigned int node_id;
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

In drivers/soc/qcom/qmi_interface.c, qmi_recv_new_server() only discards the
service record when the callback returns a negative value:

	ret = ops->new_server(qmi, svc);
	if (ret < 0)
		kfree(svc);
	else
		list_add(&svc->list_node, &qmi->lookup_results);

With the return 0 above, the other device's WLFW service stays in this
handle's lookup_results even though this device never connected to it.

The matching teardown path in the same qmi_ops table has no node id check:

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_ops_del_server() {
	struct ath12k_qmi *qmi = container_of(qmi_hdl, struct ath12k_qmi, handle);
	struct ath12k_base *ab = qmi->ab;

	ath12k_dbg(ab, ATH12K_DBG_QMI, "qmi wifi fw del server\n");
	ath12k_qmi_driver_event_post(qmi, ATH12K_QMI_EVENT_SERVER_EXIT, NULL);
}

and qmi_recv_del_server() invokes it for every retained entry whose node
matches, with qmi_recv_bye() passing port == -1 to match all ports on the
dying node:

drivers/soc/qcom/qmi_interface.c:qmi_recv_del_server() {
	list_for_each_entry_safe(svc, tmp, &qmi->lookup_results, list_node) {
		if (node != -1 && svc->node != node)
			continue;
		if (port != -1 && svc->port != port)
			continue;

		if (ops->del_server)
			ops->del_server(qmi, svc);
	...
}

net/qrtr/ns.c:server_del() notifies every lookup matching service/instance
regardless of node, so device A's handle does receive DEL_SERVER or BYE for
device B's node when device B's firmware crashes or that card is unbound or
hot-removed.

Can that spuriously fault the healthy device? The event worker reacts to
SERVER_EXIT unconditionally:

drivers/net/wireless/ath/ath12k/qmi.c:ath12k_qmi_driver_event_work() {
	...
		case ATH12K_QMI_EVENT_SERVER_EXIT:
			set_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags);
	...
}

ATH12K_FLAG_CRASH_FLUSH makes CE sends, WMI sends, data TX
(ath12k_wifi7_dp_tx()) and mgmt TX return -ESHUTDOWN, and it makes
ath12k_core_stop() skip ath12k_dp_reoq_lut_addr_reset() and
ath12k_qmi_firmware_stop() on a device whose firmware is still running:

drivers/net/wireless/ath/ath12k/core.c:ath12k_core_stop() {
	if (!test_bit(ATH12K_FLAG_CRASH_FLUSH, &ab->dev_flags)) {
		ath12k_dp_reoq_lut_addr_reset(ath12k_ab_to_dp(ab));
		ath12k_qmi_firmware_stop(ab);
	}
	...
}

The flag is only cleared on a later FW_READY event or on core reconfigure,
so the untouched device can stay in this state indefinitely.

Would returning a negative errno here (so the foreign service is never
tracked), and/or adding the same service->node check to
ath12k_qmi_ops_del_server(), cover the teardown direction as well?

There is a second effect from the retained entries: each filtered
NEW_SERVER adds another node of the foreign device into lookup_results,
so a foreign device in a firmware restart loop accumulates duplicate
entries that each later produce their own SERVER_EXIT post.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260922-qrtr-multi-ep-v3-0-c00831e88957%40oss.qualcomm.com
