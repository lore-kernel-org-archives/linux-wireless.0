Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:37168 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751301AbeFALXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Jun 2018 07:23:44 -0400
Subject: Re: [PATCH] ath10k: fix incorrect size of dma_free_coherent in
 ath10k_ce_alloc_src_ring_64
To: <davem@davemloft.net>, <kvalo@codeaurora.org>
References: <20180601111602.24108-1-yuehaibing@huawei.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <06f13277-19dc-2ee3-bad8-ab064b2aa5a7@huawei.com> (sfid-20180601_132408_129503_DEE3121D)
Date: Fri, 1 Jun 2018 19:23:35 +0800
MIME-Version: 1.0
In-Reply-To: <20180601111602.24108-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018/6/1 19:16, YueHaibing wrote:
> sizeof(struct ce_desc) should be a copy-paste mistake
> just use sizeof(struct ce_desc_64) to avoid mem leak
> 
> Fixes: b7ba83f7c414 ("ath10k: add support for shadow register for WNC3990")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/ath/ath10k/ce.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
> index 3b96a43..35dec2a 100644
> --- a/drivers/net/wireless/ath/ath10k/ce.c
> +++ b/drivers/net/wireless/ath/ath10k/ce.c
> @@ -1512,7 +1512,7 @@ ath10k_ce_alloc_src_ring_64(struct ath10k *ar, unsigned int ce_id,
>  		ret = ath10k_ce_alloc_shadow_base(ar, src_ring, nentries);
>  		if (ret) {
>  			dma_free_coherent(ar->dev,
> -					  (nentries * sizeof(struct ce_desc) +
> +					  (nentries * sizeof(struct ce_desc64) +

sorry ,I post the wrong patch,will send V2
>  					   CE_DESC_RING_ALIGN),
>  					  src_ring->base_addr_owner_space_unaligned,
>  					  base_addr);
> 
