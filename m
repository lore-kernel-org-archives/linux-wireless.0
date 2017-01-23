Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:43968 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750739AbdAWX2O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 18:28:14 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave07.hostedemail.com (Postfix) with ESMTP id 7BD5211AD25
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2017 23:19:33 +0000 (UTC)
Message-ID: <1485213569.12563.32.camel@perches.com> (sfid-20170124_002817_962986_AF8FC2BE)
Subject: Re: [PATCH 2/3] ath10k: use dma_zalloc_coherent()
From: Joe Perches <joe@perches.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2017 15:19:29 -0800
In-Reply-To: <1485183876-27080-2-git-send-email-srinivas.kandagatla@linaro.org>
References: <1485183876-27080-1-git-send-email-srinivas.kandagatla@linaro.org>
         <1485183876-27080-2-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-23 at 15:04 +0000, Srinivas Kandagatla wrote:
> use dma_zalloc_coherent() instead of dma_alloc_coherent and memset().
[]
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
[]
> @@ -896,7 +896,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
>  	 */
>  	alloc_nbytes = min_t(unsigned int, nbytes, DIAG_TRANSFER_LIMIT);
>  
> -	data_buf = (unsigned char *)dma_alloc_coherent(ar->dev,
> +	data_buf = (unsigned char *)dma_zalloc_coherent(ar->dev,
>  						       alloc_nbytes,
>  						       &ce_data_base,
>  						       GFP_ATOMIC);

trivia:

Nicer to realign arguments and remove the unnecessary cast.

Perhaps:

	data_buf = dma_zalloc_coherent(ar->dev, alloc_nbytes, &ce_data_base,
				       GFP_ATOMIC);
