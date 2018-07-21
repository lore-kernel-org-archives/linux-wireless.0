Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:37782 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbeGUKqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Jul 2018 06:46:46 -0400
Subject: Re: [PATCH] nfc: st95hf: remove redundant pointers 'dev' and
 'nfcddev'
To: Colin King <colin.king@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180720182431.24353-1-colin.king@canonical.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <8599f87b-8d71-37bc-cfbf-278a3359cf0b@zonque.org> (sfid-20180721_115451_518408_DC84B10B)
Date: Sat, 21 Jul 2018 11:54:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180720182431.24353-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, July 20, 2018 08:24 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Pointers 'dev' and 'nfcddev' are being assigned but are never used
> hence they are redundant and can be removed.
> 
> Cleans up clang warnings:
> warning: variable 'dev' set but not used [-Wunused-but-set-variable]
> warning: variable 'nfcddev' set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This seems correct.

I am currently working on a bigger series of patches for this driver 
that also touches code in the same area. I plan to post the series next 
week. If this patch is applied until then, I can rebase my changes upon 
it before sending.


Thanks,
Daniel





> ---
>   drivers/nfc/st95hf/core.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
> index a50a95cfcfd8..36ef0e905ba3 100644
> --- a/drivers/nfc/st95hf/core.c
> +++ b/drivers/nfc/st95hf/core.c
> @@ -781,9 +781,7 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
>   	int result = 0;
>   	int res_len;
>   	static bool wtx;
> -	struct device *dev;
>   	struct device *spidevice;
> -	struct nfc_digital_dev *nfcddev;
>   	struct sk_buff *skb_resp;
>   	struct st95hf_context *stcontext  =
>   		(struct st95hf_context *)st95hfcontext;
> @@ -828,8 +826,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
>   		goto end;
>   	}
>   
> -	dev = &stcontext->nfcdev->dev;
> -	nfcddev = stcontext->ddev;
>   	if (skb_resp->data[2] == WTX_REQ_FROM_TAG) {
>   		/* Request for new FWT from tag */
>   		result = st95hf_handle_wtx(stcontext, true, skb_resp->data[3]);
> 
