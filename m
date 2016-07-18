Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56849 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbcGRRYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 13:24:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 6/9] mwifiex: process rxba_sync event
References: <1468248832-21969-1-git-send-email-akarwar@marvell.com>
	<1468248832-21969-7-git-send-email-akarwar@marvell.com>
Date: Mon, 18 Jul 2016 20:24:18 +0300
In-Reply-To: <1468248832-21969-7-git-send-email-akarwar@marvell.com>
	(Amitkumar Karwar's message of "Mon, 11 Jul 2016 20:23:49 +0530")
Message-ID: <87mvlex3jx.fsf@kamboji.qca.qualcomm.com> (sfid-20160718_192428_027546_74B696E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> Firmware may filter and drop packets under certain condition, for
> example, ARP SA=DA packet. this event will be used to synchronize
> the Rx Block Acknowledgment (BA) window bitmap and to fill any holes
> in driver side.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

[...]

> --- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
> @@ -78,8 +78,15 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
>   */
>  static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
>  {
> -	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
>  
> +	int ret;
> +
> +	if (payload == (void *)MWIFIEX_RX_PKT_DROPPED_IN_FW) {
> +		mwifiex_dbg(priv->adapter, INFO, "info: fw drop data\n");
> +		return 0;
> +	}

[...]

> +					mwifiex_dbg(priv->adapter, ERROR,
> +						    "drop packet,seq=%d\n",
> +						    seq_num);
> +
> +					ret = mwifiex_11n_rx_reorder_pkt
> +					(priv, seq_num, tlv_rxba->tid,
> +					 tlv_rxba->mac, 0,
> +					 (void *)MWIFIEX_RX_PKT_DROPPED_IN_FW);

[...]

> +/* Indicate packet has been dropped in FW */
> +#define MWIFIEX_RX_PKT_DROPPED_IN_FW             0xffffffff

That pointer magic is rather ugly, why not use a proper boolean?

-- 
Kalle Valo
