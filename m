Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33244 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbbI1JAr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 05:00:47 -0400
Date: Mon, 28 Sep 2015 11:59:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	sudipm.mukherjee@gmail.com
Subject: Re: [PATCH] drivers: staging: wilc1000: Replace message queue with
 standard Linux lists
Message-ID: <20150928085931.GB7340@mwanda> (sfid-20150928_110111_563631_4437F160)
References: <1443363198-4384-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443363198-4384-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2015 at 07:43:18PM +0530, Chandra S Gorentla wrote:
> The message queue is replaced with standard Linux linked list.  A check for
> return value of receive method is added.
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c |  7 +++-
>  drivers/staging/wilc1000/wilc_msgqueue.c  | 62 ++++++++++++++-----------------
>  drivers/staging/wilc1000/wilc_platform.h  |  5 ++-
>  3 files changed, 36 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 62f4a8a..8d0776f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -4304,11 +4304,16 @@ static int hostIFthread(void *pvArg)
>  	u32 u32Ret;
>  	struct host_if_msg msg;
>  	tstrWILC_WFIDrv *pstrWFIDrv;
> +	int recv_ret;

Name it "ret".

	int ret;

>  
>  	memset(&msg, 0, sizeof(struct host_if_msg));
>  
>  	while (1) {
> -		wilc_mq_recv(&gMsgQHostIF, &msg, sizeof(struct host_if_msg), &u32Ret);
> +		recv_ret = wilc_mq_recv(&gMsgQHostIF, &msg,
> +					sizeof(struct host_if_msg), &u32Ret);
> +		if (recv_ret)
> +			continue;

This looks like a forever loop.

> +
>  		pstrWFIDrv = (tstrWILC_WFIDrv *)msg.drvHandler;
>  		if (msg.id == HOST_IF_MSG_EXIT) {
>  			PRINT_D(GENERIC_DBG, "THREAD: Exiting HostIfThread\n");
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index 869736a..67617d5 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -12,9 +12,15 @@
>   */
>  int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
>  {
> +	pHandle->msg_cache = kmem_cache_create("wilc_message_queue",
> +						sizeof(Message),
> +						0, SLAB_POISON, NULL);
> +	if (!pHandle->msg_cache)
> +		return -ENOMEM;

This is a separate thing from using list macros.  Or maybe it's not but
that isn't explained in the changelog.  Do one thing per patch so it's
easier to review.

> +
>  	spin_lock_init(&pHandle->strCriticalSection);
>  	sema_init(&pHandle->hSem, 0);
> -	pHandle->pstrMessageList = NULL;
> +	INIT_LIST_HEAD(&pHandle->msg_list_head);
>  	pHandle->u32ReceiversCount = 0;
>  	pHandle->bExiting = false;
>  	return 0;
> @@ -28,6 +34,7 @@ int wilc_mq_create(WILC_MsgQueueHandle *pHandle)
>   */
>  int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
>  {
> +	Message *msg;
>  	pHandle->bExiting = true;
>  
>  	/* Release any waiting receiver thread. */
> @@ -36,13 +43,16 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
>  		pHandle->u32ReceiversCount--;
>  	}
>  
> -	while (pHandle->pstrMessageList) {
> -		Message *pstrMessge = pHandle->pstrMessageList->pstrNext;
> -
> -		kfree(pHandle->pstrMessageList);
> -		pHandle->pstrMessageList = pstrMessge;
> +	while (!list_empty(&pHandle->msg_list_head)) {
> +		msg = list_first_entry(&pHandle->msg_list_head,
> +					Message, link);
> +		list_del(&msg->link);
> +		kfree(msg->pvBuffer);
> +		kmem_cache_free(pHandle->msg_cache, msg);
>  	}
>  
> +	kmem_cache_destroy(pHandle->msg_cache);
> +
>  	return 0;
>  }
>  
> @@ -74,41 +84,28 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>  	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>  
>  	/* construct a new message */
> -	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> -	if (!pstrMessage)
> +	pstrMessage = kmem_cache_zalloc(pHandle->msg_cache, GFP_ATOMIC);
> +	if (!pstrMessage) {
> +		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>  		return -ENOMEM;
> +	}

Do the allocation outside the lock so it doesn't have to be atomic.

>  	pstrMessage->u32Length = u32SendBufferSize;
> -	pstrMessage->pstrNext = NULL;
>  	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
>  	if (!pstrMessage->pvBuffer) {
> +		kmem_cache_free(pHandle->msg_cache, pstrMessage);
>  		result = -ENOMEM;
>  		goto ERRORHANDLER;

This goto is meaningless now that it doesn't handle any errors.  Just do
a direct return.  Except, wait, aren't we holding a couple locks?  This
looks buggy.

>  	}
>  	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
>  
>  	/* add it to the message queue */
> -	if (!pHandle->pstrMessageList) {
> -		pHandle->pstrMessageList  = pstrMessage;
> -	} else {
> -		Message *pstrTailMsg = pHandle->pstrMessageList;
> -
> -		while (pstrTailMsg->pstrNext)
> -			pstrTailMsg = pstrTailMsg->pstrNext;
> -
> -		pstrTailMsg->pstrNext = pstrMessage;
> -	}
> +	list_add_tail(&pstrMessage->link, &pHandle->msg_list_head);
>  
>  	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>  
>  	up(&pHandle->hSem);
>  
>  ERRORHANDLER:
> -	/* error occured, free any allocations */
> -	if (pstrMessage) {
> -		kfree(pstrMessage->pvBuffer);
> -		kfree(pstrMessage);
> -	}
> -
>  	return result;
>  }
>  
> @@ -144,11 +141,6 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
>  	down(&pHandle->hSem);
>  
>  	/* other non-timeout scenarios */
> -	if (result) {
> -		PRINT_ER("Non-timeout\n");
> -		return result;
> -	}
> -

This is correct, but not related to list macros.  Do it in a separate
patch.

>  	if (pHandle->bExiting) {
>  		PRINT_ER("pHandle fail\n");
>  		return -EFAULT;
> @@ -156,12 +148,13 @@ int wilc_mq_recv(WILC_MsgQueueHandle *pHandle,
>  
>  	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>  
> -	pstrMessage = pHandle->pstrMessageList;
> -	if (!pstrMessage) {
> +	if (list_empty(&pHandle->msg_list_head)) {
>  		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>  		PRINT_ER("pstrMessage is null\n");

This printk is outdated now.

>  		return -EFAULT;
>  	}
> +

regards,
dan carpenter

