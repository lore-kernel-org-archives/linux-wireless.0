Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39113 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaKYJES (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 04:04:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: don't drop corrupted mgmt frames
References: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 25 Nov 2014 11:04:12 +0200
In-Reply-To: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 24 Nov 2014 15:34:08 +0100")
Message-ID: <87egsr1wj7.fsf@kamboji.qca.qualcomm.com> (sfid-20141125_100423_812846_86960266)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1381,6 +1381,8 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
>  {
>  	struct sk_buff *msdu;
>  	struct htt_rx_desc *rxd;
> +	bool is_mgmt;
> +	bool has_fcs_err;
>  
>  	msdu = skb_peek(amsdu);
>  	rxd = (void *)msdu->data - sizeof(*rxd);
> @@ -1394,12 +1396,19 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
>  		return false;
>  	}
>  
> +	is_mgmt = !!(rxd->attention.flags &
> +		     __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE));
> +	has_fcs_err = !!(rxd->attention.flags &
> +			 __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));

I think I asked this before in some other patch, but isn't '!!' operator
useless here? is_mgmt is a boolean so the compiler should convert it
correctly without '!!' anyway, right?

-- 
Kalle Valo
