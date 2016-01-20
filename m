Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47688 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbcATTeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 14:34:12 -0500
Subject: Re: [PATCH 4/5] ath10k: clean up cont frag desc init code
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
 <1452693668-30030-5-git-send-email-michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <569FE132.7040006@candelatech.com> (sfid-20160120_203415_265538_87190404)
Date: Wed, 20 Jan 2016 11:34:10 -0800
MIME-Version: 1.0
In-Reply-To: <1452693668-30030-5-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2016 06:01 AM, Michal Kazior wrote:
> This makes the code easier to extend and re-use.
>
> While at it fix _warn to _err. Other than that
> there are no functional changes.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>   drivers/net/wireless/ath/ath10k/htt_tx.c | 58 ++++++++++++++++++++++----------
>   1 file changed, 41 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index b3adadb5f824..41a9811820e8 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -97,6 +97,41 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
>   	idr_remove(&htt->pending_tx, msdu_id);
>   }
>
> +static void ath10k_htt_tx_free_cont_frag_desc(struct ath10k_htt *htt)
> +{
> +	size_t size;
> +
> +	if (!htt->frag_desc.vaddr)
> +		return;
> +
> +	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
> +
> +	dma_free_coherent(htt->ar->dev,
> +			  size,
> +			  htt->frag_desc.vaddr,
> +			  htt->frag_desc.paddr);
> +}
> +
> +static int ath10k_htt_tx_alloc_cont_frag_desc(struct ath10k_htt *htt)
> +{
> +	struct ath10k *ar = htt->ar;
> +	size_t size;
> +
> +	if (!ar->hw_params.continuous_frag_desc)
> +		return 0;
> +
> +	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
> +	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
> +						  &htt->frag_desc.paddr,
> +						  GFP_DMA);

Did you mean to change GFP_KERNEL to GFP_DMA?

> -	size = htt->max_num_pending_tx * sizeof(struct htt_msdu_ext_desc);
> -	htt->frag_desc.vaddr = dma_alloc_coherent(ar->dev, size,
> -						  &htt->frag_desc.paddr,
> -						  GFP_KERNEL);
> -	if (!htt->frag_desc.vaddr) {
> -		ath10k_warn(ar, "failed to alloc fragment desc memory\n");
> -		ret = -ENOMEM;
> +	ret = ath10k_htt_tx_alloc_cont_frag_desc(htt);
> +	if (ret) {
> +		ath10k_err(ar, "failed to alloc cont frag desc: %d\n", ret);
>   		goto free_txbuf;
>   	}


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

