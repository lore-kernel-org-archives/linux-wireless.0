Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3900 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbcCXNIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 09:08:15 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 1/9] ath10k: speedup htt rx descriptor processing for tx
 completion
Date: Thu, 24 Mar 2016 13:08:05 +0000
Message-ID: <8760wcdnws.fsf@kamboji.qca.qualcomm.com> (sfid-20160324_140832_819725_78A9BD27)
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1458647539-17213-2-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1458647539-17213-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 22 Mar 2016 17:22:11 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> To optimize CPU usage htt rx descriptors will be reused instead of
> refilling it for htt rx copy engine (CE5). To support that all htt rx
> indications should be processed at same context. FIFO queue is used
> to maintain tx completion status for each msdu. This helps to retain
> the order of tx completion.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> @@ -1712,7 +1710,20 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
>  	for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
>  		msdu_id = resp->data_tx_completion.msdus[i];
>  		tx_done.msdu_id = __le16_to_cpu(msdu_id);
> -		ath10k_txrx_tx_unref(htt, &tx_done);
> +
> +		/* kfifo_put: In practice firmware shouldn't fire off per-CE
> +		 * interrupt and main interrupt (MSI/-X range case) for the same
> +		 * HTC service so it should be safe to use kfifo_put w/o lock.
> +		 *
> +		 * From kfifo_put() documentation:
> +		 *  Note that with only one concurrent reader and one concurrent
> +		 *  writer, you don't need extra locking to use these macro.
> +		 */
> +		if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
> +			ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
> +				    tx_done.msdu_id, tx_done.status);
> +			ath10k_txrx_tx_unref(htt, &tx_done);
> +		}

I see two new warnings on the kfifo_put() call:

drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast to non-scalar
drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast from non-scalar

But I suspect they are false warnings due to my old compiler:

gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3

Opinions?

-- 
Kalle Valo