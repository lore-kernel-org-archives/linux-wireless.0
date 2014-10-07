Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10236 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaJGQTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 12:19:12 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: add tracing for frame transmission
References: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 7 Oct 2014 19:19:05 +0300
In-Reply-To: <1412615346-18010-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 6 Oct 2014 22:39:06 +0530")
Message-ID: <87d2a3j1ja.fsf@kamboji.qca.qualcomm.com> (sfid-20141007_181923_968089_6363117D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Add tracing support to forward management and data frames to
> user space for packet inspection.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -291,6 +291,9 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
>  	htt->rx_ring.sw_rd_idx.msdu_payld = idx;
>  	htt->rx_ring.fill_cnt--;
>  
> +	trace_ath10k_htt_rx_pop_msdu(ar, msdu->data, msdu->len +
> +				     skb_tailroom(msdu));

Why add skb_tailroom() to the length? I think that deserves a comment.

-- 
Kalle Valo
