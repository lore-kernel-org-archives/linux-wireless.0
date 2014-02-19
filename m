Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40426 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbaBSPKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 10:10:25 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 5/7] ath10k: batch htt tx/rx completions
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-6-git-send-email-michal.kazior@tieto.com>
Date: Wed, 19 Feb 2014 17:10:19 +0200
In-Reply-To: <1392629563-31046-6-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 17 Feb 2014 10:32:41 +0100")
Message-ID: <87lhx7xhno.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_161029_361883_9C45C4AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> HTT Rx endpoint processes both frame rx
> indications and frame tx completion indications.
>
> Those completions typically come in batches and
> may be mixed so it makes sense to defer processing
> hoping to get a bunch of them and take advantage
> of hot caches.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -270,7 +274,7 @@ static inline struct sk_buff *ath10k_htt_rx_netbuf_pop(struct ath10k_htt *htt)
>  	int idx;
>  	struct sk_buff *msdu;
>  
> -	spin_lock_bh(&htt->rx_ring.lock);
> +	lockdep_assert_held(&htt->rx_ring.lock);

There are some locking changes which I think would be better to have in
a separate patch.


>  	case HTT_T2H_MSG_TYPE_MGMT_TX_COMPLETION: {
> +		struct htt_resp *resp = (struct htt_resp *)skb->data;
>  		struct htt_tx_done tx_done = {};
>  		int status = __le32_to_cpu(resp->mgmt_tx_completion.status);
>  
> -		tx_done.msdu_id =
> -			__le32_to_cpu(resp->mgmt_tx_completion.desc_id);
> +		tx_done.msdu_id = __le32_to_cpu(resp->mgmt_tx_completion.desc_id);

I don't see any changes here.

-- 
Kalle Valo
