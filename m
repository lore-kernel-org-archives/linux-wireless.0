Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55744 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab2BFOao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 09:30:44 -0500
Message-ID: <4F2FE40D.9020307@qca.qualcomm.com> (sfid-20120206_153047_963119_6E0BC2C2)
Date: Mon, 6 Feb 2012 16:30:37 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Check wow state before sending control and data
 pkt
References: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1328536613-17521-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2012 03:56 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> * TX operation (ctrl tx and data tx) has to be controlled based on
>   WOW suspend state. i.e, control packets are allowed to send from
>   the host until the suspend state goes ATH6KL_STATE_WOW and
>   the data packets are allowed until WOW suspend operation starts.
> 
> * Similary, wow resume is NOT allowed if WOW suspend is in progress.
> 
> Both of the above scenarios are taken care in this patch.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

What user visible bug are you fixing here?

> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -284,6 +284,10 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
>  	int status = 0;
>  	struct ath6kl_cookie *cookie = NULL;
>  
> +#ifdef CONFIG_PM
> +	if (ar->wow_state == ATH6KL_WOW_STATE_SUSPENDED)
> +		return -EACCES;
> +#endif
>  	spin_lock_bh(&ar->lock);
>  
>  	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
> @@ -352,7 +356,12 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>  	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
>  		   "%s: skb=0x%p, data=0x%p, len=0x%x\n", __func__,
>  		   skb, skb->data, skb->len);
> -
> +#ifdef CONFIG_PM
> +	if (ar->wow_state != ATH6KL_WOW_STATE_NONE) {
> +		dev_kfree_skb(skb);
> +		return 0;
> +	}
> +#endif

I think we should be more proactive than reactive. For example, we
should stop netdev queues to make sure that there are no data packets
transmitted. And we should do the same for ath6kl_control_tx() callers,
I guess that means cfg80211 ops?

But we could add warnings here to make sure that we are not transmitting
any packets in a wrong state.

Kalle
