Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:32805 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbJNIc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 04:32:27 -0400
Received: by wicge5 with SMTP id ge5so90165725wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 01:32:26 -0700 (PDT)
Date: Wed, 14 Oct 2015 11:32:21 +0300
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V2] staging: wilc1000: wilc_msgqueue.c : remove the goto
 ERRORHANDER
Message-ID: <20151014083221.GA25667@zed.strato> (sfid-20151014_103234_213708_EA187637)
References: <1444802143-6298-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444802143-6298-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 14, 2015 at 02:55:43PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
> Then, the error type is directly returned. If normal operation, freeing memory
> is not needed in this function.
> If an error occurs, returns an error after releasing the spin lock.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
> V2: add releasing spinlock before returnig an error when an error happens.
> ---
>  drivers/staging/wilc1000/wilc_msgqueue.c | 28 ++++++++++++----------------
>  1 file changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index b13809a..4dfd476 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -56,35 +56,38 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
>  int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>  			     const void *pvSendBuffer, u32 u32SendBufferSize)
>  {
> -	int result = 0;
>  	unsigned long flags;
>  	Message *pstrMessage = NULL;
>  
>  	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
>  		PRINT_ER("pHandle or pvSendBuffer is null\n");
> -		result = -EFAULT;
> -		goto ERRORHANDLER;
> +		return -EFAULT;
>  	}
>  
>  	if (pHandle->bExiting) {
>  		PRINT_ER("pHandle fail\n");
> -		result = -EFAULT;
> -		goto ERRORHANDLER;
> +		return -EFAULT;
>  	}
>  
>  	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>  
>  	/* construct a new message */
>  	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);

You can make this allocation outisde the spinlock, then there won't be
need to release it if the allocation fails.

> -	if (!pstrMessage)
> +
> +	if (!pstrMessage) {
> +		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>  		return -ENOMEM;
> +	}
> +
>  	pstrMessage->u32Length = u32SendBufferSize;
>  	pstrMessage->pstrNext = NULL;
>  	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
>  					GFP_ATOMIC);
> +
>  	if (!pstrMessage->pvBuffer) {
> -		result = -ENOMEM;
> -		goto ERRORHANDLER;
> +		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);

You are still holding pHandle->hSem here. Moreover, all error paths
return while still holding pHandle->hSem.
I'd suggest, that instead of trying to return immediately, you'd better
move error handling code to the end of the function and use goto and
several labels to do appropriate cleanups depending on when the error
was caught. E.g.

mem_free:
	kfree(pstrMessage);
release_lock:	
	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
release_sem:
	up(&pHandle->sem);
out:
	return result;

> +		kfree(pstrMessage);
> +		return -ENOMEM;
>  	}
>  
>  	/* add it to the message queue */
> @@ -103,14 +106,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>  
>  	up(&pHandle->hSem);
>  
> -ERRORHANDLER:
> -	/* error occured, free any allocations */
> -	if (pstrMessage) {
> -		kfree(pstrMessage->pvBuffer);
> -		kfree(pstrMessage);
> -	}
> -
> -	return result;
> +	return 0;
>  }
>  
>  /*!
> -- 
> 1.9.1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
