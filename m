Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A2EC169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 05:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF66D20989
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 05:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfA2Fx0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 00:53:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3231 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725497AbfA2FxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 00:53:25 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 909ACCA1622480F15CF3;
        Tue, 29 Jan 2019 13:53:23 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 13:53:21 +0800
Subject: Re: [PATCH] ath10k: snoc: remove set but not used variable 'ar_snoc'
To:     Kalle Valo <kvalo@codeaurora.org>
References: <1536200965-121172-1-git-send-email-yuehaibing@huawei.com>
CC:     <ath10k@lists.infradead.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <4b16caf3-9a25-99d0-5b35-f27d6e5a5c65@huawei.com>
Date:   Tue, 29 Jan 2019 13:53:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1536200965-121172-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ping...

On 2018/9/6 10:29, YueHaibing wrote:
> From: Yue Haibing <yuehaibing@huawei.com>
> 
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/ath/ath10k/snoc.c: In function 'ath10k_snoc_tx_pipe_cleanup':
> drivers/net/wireless/ath/ath10k/snoc.c:681:22: warning:
>  variable 'ar_snoc' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index fa1843a..2d6ae00 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -678,13 +678,11 @@ static void ath10k_snoc_tx_pipe_cleanup(struct ath10k_snoc_pipe *snoc_pipe)
>  {
>  	struct ath10k_ce_pipe *ce_pipe;
>  	struct ath10k_ce_ring *ce_ring;
> -	struct ath10k_snoc *ar_snoc;
>  	struct sk_buff *skb;
>  	struct ath10k *ar;
>  	int i;
>  
>  	ar = snoc_pipe->hif_ce_state;
> -	ar_snoc = ath10k_snoc_priv(ar);
>  	ce_pipe = snoc_pipe->ce_hdl;
>  	ce_ring = ce_pipe->src_ring;
> 
> 
> .
> 

