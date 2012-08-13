Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59442 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab2HMO5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 10:57:16 -0400
Message-ID: <502915C5.30503@qca.qualcomm.com> (sfid-20120813_165729_854360_7DBF34CE)
Date: Mon, 13 Aug 2012 17:57:09 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: Fix potential memory leak in ath6kl_tx_complete()
References: <1344865738-2416-1-git-send-email-vthiagar@qca.qualcomm.com> <1344865738-2416-2-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1344865738-2416-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2012 04:48 PM, Vasanthakumar Thiagarajan wrote:
> We bail out from ath6kl_tx_complete() if any of the sanity
> checks on skb and ath6kl_cookie fails. By doing this we
> potentially leak few remaining buffers in packet_queue.
> Make sure to proceed processing the remaining buffers
> as well. This issue is found during code review.
> 
> Reported-by: Wang yufeng <yufengw@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/txrx.c |   25 ++++++++++++++-----------
>  1 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
> index aab8251..4b26ba0 100644
> --- a/drivers/net/wireless/ath/ath6kl/txrx.c
> +++ b/drivers/net/wireless/ath/ath6kl/txrx.c
> @@ -698,21 +698,29 @@ void ath6kl_tx_complete(struct htc_target *target,
>  		list_del(&packet->list);
>  
>  		ath6kl_cookie = (struct ath6kl_cookie *)packet->pkt_cntxt;
> -		if (!ath6kl_cookie)
> -			goto fatal;
> +		if (!ath6kl_cookie) {
> +			WARN_ON(1);
> +			continue;
> +		}

Please use WARN_ON_ONCE() to avoid excess log messages (as this is in
data path) and put the WARN_ON() inside if:

if (WARN_ON_ONCE(!ath6kl_cookie))
	continue;

> +		if (!skb || !skb->data) {
> +			WARN_ON(1);
> +			dev_kfree_skb(skb);
> +			ath6kl_free_cookie(ar, ath6kl_cookie);
> +			continue;
> +		}

Same here.

Kalle
