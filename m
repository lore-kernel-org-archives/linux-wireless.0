Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:4531 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753735AbdLVPoB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:44:01 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 07/11] ath10k: various fixes for high latency devices
Date: Fri, 22 Dec 2017 15:43:55 +0000
Message-ID: <87fu82ahtw.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_164405_351809_9EF5382E)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-8-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-8-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:09 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Several DMA related functions (such as the dma_map_xxx functions)
> are not used with high latency devices and don't need to be invoked
> in this case.
>
> A few other execution paths are not applicable for high latency
> devices and can be skipped.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

This and patch 6 are somehow connected but the division is not clear. I
think at least dma map/unmap changes should be split into their own
patch.=20

I recommend revisiting both patches 6 and 7. The htt layer can be quite
tricky so better to have smaller logical changes to make it easier
review them.

> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -409,6 +409,9 @@ int ath10k_htt_tx_start(struct ath10k_htt *htt)
>  	if (htt->tx_mem_allocated)
>  		return 0;
> =20
> +	if (ar->is_high_latency)
> +		return 0;
> +
>  	ret =3D ath10k_htt_tx_alloc_buf(htt);
>  	if (ret)
>  		goto free_idr_pending_tx;
> @@ -445,7 +448,8 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
>  		return;
> =20
>  	ath10k_htt_tx_free_cont_txbuf(htt);
> -	ath10k_htt_tx_free_txq(htt);
> +	if (!htt->ar->is_high_latency)
> +		ath10k_htt_tx_free_txq(htt);
>  	ath10k_htt_tx_free_cont_frag_desc(htt);
>  	ath10k_htt_tx_free_txdone_fifo(htt);
>  	htt->tx_mem_allocated =3D false;

These two don't look symmetric. You prevent calling these functions:

ath10k_htt_tx_alloc_cont_txbuf(htt);
ath10k_htt_tx_alloc_cont_frag_desc(htt);
ath10k_htt_tx_alloc_txq(htt);
ath10k_htt_tx_alloc_txdone_fifo(htt);

But during destroy you only prevent calling ath10k_htt_tx_free_txq(htt)
and allow these functions:

ath10k_htt_tx_free_cont_txbuf(htt);
ath10k_htt_tx_free_cont_frag_desc(htt);
ath10k_htt_tx_free_txdone_fifo(htt);

--=20
Kalle Valo=
