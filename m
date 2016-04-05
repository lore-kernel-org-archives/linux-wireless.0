Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46187 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbcDEMsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 08:48:22 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 3/3] ath10k: fix unconditional num_mpdus_ready subtraction
Date: Tue, 5 Apr 2016 12:48:14 +0000
Message-ID: <87shz0b4s2.fsf@kamboji.qca.qualcomm.com> (sfid-20160405_144831_811773_D35E5FA9)
References: <1459352551-11773-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1459352551-11773-3-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 30 Mar 2016 21:12:31 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Decrement num_mpdus_ready only when rx amsdu is processed successfully.
> Not doing so, will result in leak and impact stabilty under low memory
> cases.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_rx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 96a7417..9696c2e 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -2412,14 +2412,12 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
>  	struct ath10k_htt *htt = (struct ath10k_htt *)ptr;
>  	struct ath10k *ar = htt->ar;
>  	struct htt_tx_done tx_done = {};
> -	struct sk_buff_head rx_q;
>  	struct sk_buff_head rx_ind_q;
>  	struct sk_buff_head tx_ind_q;
>  	struct sk_buff *skb;
>  	unsigned long flags;
>  	int num_mpdus;
>  
> -	__skb_queue_head_init(&rx_q);
>  	__skb_queue_head_init(&rx_ind_q);
>  	__skb_queue_head_init(&tx_ind_q);

I guess you are removing the unused rx_q just as a cleanup? It's good
practise to mention that in the commit log (or better yet in a separate
patch).

-- 
Kalle Valo