Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2GKT3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 15:29:55 -0400
Message-ID: <4FFDD42E.6010401@qca.qualcomm.com> (sfid-20120711_212959_180092_C42542DC)
Date: Wed, 11 Jul 2012 22:29:50 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: support TX error rate notification
References: <1342034589-3979-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1342034589-3979-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2012 10:23 PM, Thomas Pedersen wrote:
> The ath6kl firmware can monitor a connection and report when a certain
> TX failure threshold is crossed. Support this configuration and event
> reporting on compatible firmwares.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

[...]

> +	ev = (struct wmi_txe_notify_event *) datap;
> +	rate = le32_to_cpu(ev->rate);
> +	pkts = le32_to_cpu(ev->pkts);
> +	ath6kl_dbg(ATH6KL_DBG_WMI, "TXE notify event: peer %pM rate %d pkts %d\n",
> +		   vif->bssid, rate, pkts);

Empty line before the ath6kl_dbg() call, please.

> +int ath6kl_wmi_set_txe_notify(struct wmi *wmi, u8 idx,
> +			      u32 rate, u32 pkts, u32 intvl)
> +{
> +	struct sk_buff *skb;
> +	struct wmi_txe_notify_cmd *cmd;
> +
> +	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (struct wmi_txe_notify_cmd *) skb->data;
> +	cmd->rate = rate;
> +	cmd->pkts = pkts;
> +	cmd->intvl = intvl;

cpu_to_le32()?

> +/* WMI_SET_TXE_NOTIFY_CMD */
> +struct wmi_txe_notify_cmd {
> +	u32 rate;
> +	u32 pkts;
> +	u32 intvl;
> +} __packed;
> +
> +/* WMI_TXE_NOTIFY_EVENTID */
> +struct wmi_txe_notify_event {
> +	u32 rate;
> +	u32 pkts;
> +} __packed;

Endian annotation?

Kalle
