Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38616 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751050AbeEUXLj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 19:11:39 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 21 May 2018 16:11:38 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: transmit queued frames after waking queues
In-Reply-To: <20180521204359.23884-1-niklas.cassel@linaro.org>
References: <20180521204359.23884-1-niklas.cassel@linaro.org>
Message-ID: <8195be7603a8cd659d25a9c3d898b891@codeaurora.org> (sfid-20180522_011143_199655_CCCD2100)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-21 13:43, Niklas Cassel wrote:
> The following problem was observed when running iperf:
[...]
> 
> In order to avoid trying to flush the queue every time we free a frame,
> only do this when there are 3 or less frames pending, and while we
> actually have frames in the queue. This logic was copied from
> mt76_txq_schedule (mt76), one of few other drivers that are actually
> using wake_tx_queue.
> 
> Suggested-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> ---
> Changes since V1: use READ_ONCE() to disallow the compiler
> optimizing things in undesirable ways.
> 
>  drivers/net/wireless/ath/ath10k/txrx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/txrx.c
> b/drivers/net/wireless/ath/ath10k/txrx.c
> index cda164f6e9f6..264cf0bd5c00 100644
> --- a/drivers/net/wireless/ath/ath10k/txrx.c
> +++ b/drivers/net/wireless/ath/ath10k/txrx.c
> @@ -95,6 +95,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
>  		wake_up(&htt->empty_tx_wq);
>  	spin_unlock_bh(&htt->tx_lock);
> 
> +	if (READ_ONCE(htt->num_pending_tx) <= 3 && !list_empty(&ar->txqs))
> +		ath10k_mac_tx_push_pending(ar);
> +
Niklas,

Sorry for the late response. ath10k_mac_tx_push_pending is already 
called
at the end of NAPI handler. Isn't that enough to process pending frames?

Earlier we observed performance issues in calling push_pending from each
tx completion. IMHO this change may introduce the same problem again.

-Rajkumar
