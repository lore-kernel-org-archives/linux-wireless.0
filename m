Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:42453 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754258AbeCRWt2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 18:49:28 -0400
Received: by mail-pl0-f66.google.com with SMTP id w15-v6so9102966plq.9
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2018 15:49:27 -0700 (PDT)
Date: Sun, 18 Mar 2018 15:49:29 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org, kvalo@codeaurora.org
Subject: Re: [PATCH] wcn36xx: dequeue all pending indicator messages
Message-ID: <20180318224929.GN5626@tuxbook-pro> (sfid-20180318_234936_791860_DA989FA2)
References: <20180315223725.28283-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180315223725.28283-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 15 Mar 15:37 PDT 2018, Daniel Mack wrote:

> In case wcn36xx_smd_rsp_process() is called more than once before
> hal_ind_work was dispatched, the messages will end up in hal_ind_queue,
> but wcn36xx_ind_smd_work() will only look at the first message in that
> list.
> 
> Fix this by dequeing the messages from the list in a loop, and only stop
> when it's empty.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Thanks for fixing this, I thought I already had done that.

Regards,
Bjorn

> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 95 +++++++++++++++++++---------------
>  1 file changed, 52 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 7cc29285e052..a6b5352f59e9 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2409,54 +2409,63 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
>  {
>  	struct wcn36xx *wcn =
>  		container_of(work, struct wcn36xx, hal_ind_work);
> -	struct wcn36xx_hal_msg_header *msg_header;
> -	struct wcn36xx_hal_ind_msg *hal_ind_msg;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&wcn->hal_ind_lock, flags);
> +	for (;;) {
> +		struct wcn36xx_hal_msg_header *msg_header;
> +		struct wcn36xx_hal_ind_msg *hal_ind_msg;
> +		unsigned long flags;
>  
> -	hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
> -				       struct wcn36xx_hal_ind_msg,
> -				       list);
> -	list_del(wcn->hal_ind_queue.next);
> -	spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
> +		spin_lock_irqsave(&wcn->hal_ind_lock, flags);
>  
> -	msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
> +		if (list_empty(&wcn->hal_ind_queue)) {
> +			spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
> +			return;
> +		}
>  
> -	switch (msg_header->msg_type) {
> -	case WCN36XX_HAL_COEX_IND:
> -	case WCN36XX_HAL_DEL_BA_IND:
> -	case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
> -		break;
> -	case WCN36XX_HAL_OTA_TX_COMPL_IND:
> -		wcn36xx_smd_tx_compl_ind(wcn,
> -					 hal_ind_msg->msg,
> -					 hal_ind_msg->msg_len);
> -		break;
> -	case WCN36XX_HAL_MISSED_BEACON_IND:
> -		wcn36xx_smd_missed_beacon_ind(wcn,
> -					      hal_ind_msg->msg,
> -					      hal_ind_msg->msg_len);
> -		break;
> -	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
> -		wcn36xx_smd_delete_sta_context_ind(wcn,
> -						   hal_ind_msg->msg,
> -						   hal_ind_msg->msg_len);
> -		break;
> -	case WCN36XX_HAL_PRINT_REG_INFO_IND:
> -		wcn36xx_smd_print_reg_info_ind(wcn,
> -					       hal_ind_msg->msg,
> -					       hal_ind_msg->msg_len);
> -		break;
> -	case WCN36XX_HAL_SCAN_OFFLOAD_IND:
> -		wcn36xx_smd_hw_scan_ind(wcn, hal_ind_msg->msg,
> -					hal_ind_msg->msg_len);
> -		break;
> -	default:
> -		wcn36xx_err("SMD_EVENT (%d) not supported\n",
> -			      msg_header->msg_type);
> +		hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
> +					       struct wcn36xx_hal_ind_msg,
> +					       list);
> +		list_del(&hal_ind_msg->list);
> +		spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
> +
> +		msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
> +
> +		switch (msg_header->msg_type) {
> +		case WCN36XX_HAL_COEX_IND:
> +		case WCN36XX_HAL_DEL_BA_IND:
> +		case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
> +			break;
> +		case WCN36XX_HAL_OTA_TX_COMPL_IND:
> +			wcn36xx_smd_tx_compl_ind(wcn,
> +						 hal_ind_msg->msg,
> +						 hal_ind_msg->msg_len);
> +			break;
> +		case WCN36XX_HAL_MISSED_BEACON_IND:
> +			wcn36xx_smd_missed_beacon_ind(wcn,
> +						      hal_ind_msg->msg,
> +						      hal_ind_msg->msg_len);
> +			break;
> +		case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
> +			wcn36xx_smd_delete_sta_context_ind(wcn,
> +							   hal_ind_msg->msg,
> +							   hal_ind_msg->msg_len);
> +			break;
> +		case WCN36XX_HAL_PRINT_REG_INFO_IND:
> +			wcn36xx_smd_print_reg_info_ind(wcn,
> +						       hal_ind_msg->msg,
> +						       hal_ind_msg->msg_len);
> +			break;
> +		case WCN36XX_HAL_SCAN_OFFLOAD_IND:
> +			wcn36xx_smd_hw_scan_ind(wcn, hal_ind_msg->msg,
> +						hal_ind_msg->msg_len);
> +			break;
> +		default:
> +			wcn36xx_err("SMD_EVENT (%d) not supported\n",
> +				    msg_header->msg_type);
> +		}
> +
> +		kfree(hal_ind_msg);
>  	}
> -	kfree(hal_ind_msg);
>  }
>  int wcn36xx_smd_open(struct wcn36xx *wcn)
>  {
> -- 
> 2.14.3
> 
> 
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
