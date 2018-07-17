Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:44274 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731429AbeGQOVw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jul 2018 10:21:52 -0400
Subject: Re: [PATCH 2/2] nfc: st95hf: drop another illegal kfree_skb()
To: sameo@linux.intel.com, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org
References: <20180629124717.2011-1-daniel@zonque.org>
 <20180629124717.2011-2-daniel@zonque.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <2c3a389d-339e-4fe2-d0c8-1ab7775d3f2c@zonque.org> (sfid-20180717_154910_323035_2A8D3B4B)
Date: Tue, 17 Jul 2018 15:49:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180629124717.2011-2-daniel@zonque.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'll resend the two patches in this series as part of a bigger series 
soon, please ignore them for now.


Thanks,
Daniel



On Friday, June 29, 2018 02:47 PM, Daniel Mack wrote:
> In the error path of the IRQ handler, don't free the skb in flight. The
> callback in the digital core will do that for us, so this is another
> double-free that leads to memory corruptions.
> 
> The assignment of 'wtx' doesn't make sense as the variable is not read
> after it is written. Drop it.
> 
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>   drivers/nfc/st95hf/core.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
> index ef91ca8b53a4..e651e1aae5a3 100644
> --- a/drivers/nfc/st95hf/core.c
> +++ b/drivers/nfc/st95hf/core.c
> @@ -868,8 +868,6 @@ static irqreturn_t st95hf_irq_thread_handler(int irq, void  *st95hfcontext)
>   	return IRQ_HANDLED;
>   
>   end:
> -	kfree_skb(skb_resp);
> -	wtx = false;
>   	cb_arg->rats = false;
>   	skb_resp = ERR_PTR(result);
>   	/* call of callback with error */
> 
