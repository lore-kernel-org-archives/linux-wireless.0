Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42840 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaG1U7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 16:59:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add support for 10.2 firmware
References: <1406287937-26507-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 28 Jul 2014 23:59:15 +0300
In-Reply-To: <1406287937-26507-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 25 Jul 2014 13:32:17 +0200")
Message-ID: <87oaw9jj30.fsf@kamboji.qca.qualcomm.com> (sfid-20140728_225927_383581_BCD0A30E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> The 10.2 firmware is a successor of 10.1 firmware
> (formerly identified as 10.x). Both share a lot
> but have some slight ABI differences that need to
> be taken care of.
>
> The 10.2 firmware introduces some new features but
> those can be added in subsequent patches. This
> patch makes ath10k boot and work with 10.2 with
> comparable functionality to 10.1.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied with minor changes:

> +static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
> +{
> +	struct wmi_cmd_hdr *cmd_hdr;
> +	enum wmi_10_2_event_id id;
> +
> +	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
> +	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
> +
> +	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
> +		return;
> +
> +	trace_ath10k_wmi_event(id, skb->data, skb->len);
> +
> +	switch (id) {
> +
> +
> +	case WMI_10_2_MGMT_RX_EVENTID:

checkpatch warned about extra newlines here.

> +static void
> +ath10k_wmi_peer_assoc_fill_main_636(struct ath10k *ar, void *buf,
> +				    const struct wmi_peer_assoc_complete_arg *arg)
> +{

And this was too long. I "fixed" it by s/main_636/main/. I think the 636
part was a bit redundant anyway.

-- 
Kalle Valo
