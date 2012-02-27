Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19459 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2B0Ojl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 09:39:41 -0500
Message-ID: <4F4B95A7.2060809@qca.qualcomm.com> (sfid-20120227_153944_719234_1BB56D68)
Date: Mon, 27 Feb 2012 16:39:35 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 1/1] ath6kl: Check wow state before sending control
 and data pkt
References: <1328779916-7732-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1328779916-7732-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 11:31 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Below two scenarios are taken care in this patch which helped
> to fix the firmware crash during wow suspend/resume.
> 
> * TX operation (ctrl tx and data tx) has to be controlled based
>   on suspend state. i.e, with respect to WOW mode, control packets
>   are allowed to send from the host until the suspend state goes
>   ATH6KL_STATE_WOW and the data packets are allowed until WOW
>   suspend operation starts.
> 
> * Similarly, wow resume is NOT allowed if WOW suspend is in progress.
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
> ---
> V2 changes:
> 
> * Separate wow sub state introduced in V1 is removed and common
>   states (ATH6KL_STATE_SUSPENDING and ATH6KL_STATE_RESUMING)
>   are added in enum ath6kl_state.
> 
> * netdev queue is stopped while dropping skb in ath6kl_data_tx()
>   and resumed back in ath6kl_wow_resume().

[...]

> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index 4febee7..402087e 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -901,8 +901,12 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
>  
>  	case ATH6KL_STATE_WOW:
>  		break;
> +
>  	case ATH6KL_STATE_SCHED_SCAN:
>  		break;
> +
> +	default:
> +		break;
>  	}

Don't add the default case, instead add all states explicitly. That way
it's easier to track state changes.

> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -284,6 +284,9 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
>  	int status = 0;
>  	struct ath6kl_cookie *cookie = NULL;
>  
> +	if (ar->state == ATH6KL_STATE_WOW)
> +		return -EACCES;

Should this have WARN_ON_ONCE()?

> @@ -359,6 +362,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
>  		return 0;
>  	}
>  
> +	if (WARN_ON_ONCE(ar->state != ATH6KL_STATE_ON)) {
> +		set_bit(NETQ_STOPPED, &vif->flags);
> +		netif_stop_queue(dev);
> +		dev_kfree_skb(skb);
> +		return 0;
> +	}

Don't stop the queue here, dropping the packet is enough.

Kalle
