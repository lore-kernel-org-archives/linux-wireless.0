Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34817 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbbJSLmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:42:36 -0400
Received: by wicll6 with SMTP id ll6so1365808wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 04:42:35 -0700 (PDT)
Date: Mon, 19 Oct 2015 14:42:31 +0300
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V3] staging: wilc1000: wilc_msgqueue.c : add goto
 statement
Message-ID: <20151019114231.GB12394@zed.strato> (sfid-20151019_134240_260913_5965A909)
References: <1445245395-9976-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445245395-9976-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 19, 2015 at 06:03:15PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch uses goto statement to separet error conditionals into release_lock
> and mem_free in wilc_mq_send. If unexpected errors happen, this function
> cannot up the semaphore, otherwise, if no errors, the semaphore should be
> released, but freeing memory is not needed in this function.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
> V3: use goto statement to seperate error types into release_lock and mem_free
> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index b13809a..bb4e93c 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -63,28 +63,31 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>  	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
>  		PRINT_ER("pHandle or pvSendBuffer is null\n");
>  		result = -EFAULT;
> -		goto ERRORHANDLER;
> +		goto out;

Here you can return -EFAULT beacuse no cleanup is required

>  	}
>  
>  	if (pHandle->bExiting) {
>  		PRINT_ER("pHandle fail\n");
>  		result = -EFAULT;
> -		goto ERRORHANDLER;
> +		goto out;
>  	}
  
Ditto

>  	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>  
>  	/* construct a new message */
>  	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> -	if (!pstrMessage)
> -		return -ENOMEM;
> +	if (!pstrMessage) {
> +		result = -ENOMEM;
> +		goto release_lock;
> +	}
> +

You can move the allocation outside the lock, then if the allocation
fails you can directly return -ENOMEM.


>  	pstrMessage->u32Length = u32SendBufferSize;
>  	pstrMessage->pstrNext = NULL;
>  	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
>  					GFP_ATOMIC);
>  	if (!pstrMessage->pvBuffer) {
>  		result = -ENOMEM;
> -		goto ERRORHANDLER;
> +		goto mem_free;
>  	}
>  
>  	/* add it to the message queue */
> @@ -103,13 +106,13 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>  
>  	up(&pHandle->hSem);
>  
> -ERRORHANDLER:
> -	/* error occured, free any allocations */
> -	if (pstrMessage) {
> -		kfree(pstrMessage->pvBuffer);
> -		kfree(pstrMessage);
> -	}
> +	return 0;
>  
> +mem_free:
> +	kfree(pstrMessage);
> +release_lock:
> +	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> +out:
>  	return result;
>  }
>  
> -- 
> 1.9.1

--
Sincerely yours,
Mike.
