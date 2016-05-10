Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34259 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbcEJGsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 02:48:10 -0400
Date: Tue, 10 May 2016 12:18:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: greearb@candelatech.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/5] ath10k: Ensure txrx-compl-task is stopped when
 cleaning htt-tx.
Message-ID: <20160510064800.GC25626@atheros-ThinkPad-T61> (sfid-20160510_084814_360419_67A72C8F)
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Fri, Apr 01, 2016 at 02:12:08PM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, the txrx-compl-task may access some bad memory?

good to mention when this happens, will be helpful ifsome one recreates
the issue and matches your call trace

> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
> index 07b960e..58e88d3 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
> @@ -376,6 +376,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
>  {
>  	int size;
>  
> +	tasklet_kill(&htt->txrx_compl_task);
> +
>  	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
>  	idr_destroy(&htt->pending_tx);
>  
> -- 
> 2.4.3

regards,
shafi

> 
> 
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
