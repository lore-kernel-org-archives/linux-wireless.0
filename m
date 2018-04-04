Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbeDDFht (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 01:37:49 -0400
Subject: Re: [PATCH 1/3] wcn36xx: check for DMA mapping errors in
 wcn36xx_dxe_tx_frame()
To: Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc: loic.poulain@linaro.org, bjorn.andersson@linaro.org,
        kvalo@codeaurora.org, wcn36xx@lists.infradead.org
References: <20180403165154.18775-1-daniel@zonque.org>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <9838151f-910c-b240-2150-c0a8a70ebc81@codeaurora.org> (sfid-20180404_073754_149829_BA84869A)
Date: Wed, 4 Apr 2018 08:37:44 +0300
MIME-Version: 1.0
In-Reply-To: <20180403165154.18775-1-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4/3/2018 7:51 PM, Daniel Mack wrote:
> Bail out if the mapping fails. Even though this hasn't occured during
> tests, this unlikely case should still be handled.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/dxe.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
> index 6e9a3583c447..e8ad8f989ccd 100644
> --- a/drivers/net/wireless/ath/wcn36xx/dxe.c
> +++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
> @@ -707,6 +707,11 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
>  					  ctl->skb->data,
>  					  ctl->skb->len,
>  					  DMA_TO_DEVICE);
> +	if (dma_mapping_error(wcn->dev, desc->src_addr_l)) {
> +		dev_err(wcn->dev, "unable to DMA map src_addr_l\n");
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
>  
>  	desc->dst_addr_l = ch->dxe_wq;
>  	desc->fr_len = ctl->skb->len;
I have the exact patch ready for submission, you got a head of me :)
Acked-by: Ramon Fried <rfried@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
