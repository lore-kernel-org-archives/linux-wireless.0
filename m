Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:31012 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbbJNIxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 04:53:14 -0400
Subject: Re: [PATCH V2] staging: wilc1000: wilc_msgqueue.c : remove the goto
 ERRORHANDER
To: Mike Rapoport <mike.rapoport@gmail.com>
References: <1444802143-6298-1-git-send-email-tony.cho@atmel.com>
 <20151014083221.GA25667@zed.strato>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <561E17E7.2080407@atmel.com> (sfid-20151014_105324_155693_CACF622D)
Date: Wed, 14 Oct 2015 17:52:55 +0900
MIME-Version: 1.0
In-Reply-To: <20151014083221.GA25667@zed.strato>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 14일 17:32, Mike Rapoport wrote:
> On Wed, Oct 14, 2015 at 02:55:43PM +0900, Tony Cho wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
>> Then, the error type is directly returned. If normal operation, freeing memory
>> is not needed in this function.
>> If an error occurs, returns an error after releasing the spin lock.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> ---
>> V2: add releasing spinlock before returnig an error when an error happens.
>> ---
>>   drivers/staging/wilc1000/wilc_msgqueue.c | 28 ++++++++++++----------------
>>   1 file changed, 12 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
>> index b13809a..4dfd476 100644
>> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
>> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
>> @@ -56,35 +56,38 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
>>   int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>   			     const void *pvSendBuffer, u32 u32SendBufferSize)
>>   {
>> -	int result = 0;
>>   	unsigned long flags;
>>   	Message *pstrMessage = NULL;
>>   
>>   	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
>>   		PRINT_ER("pHandle or pvSendBuffer is null\n");
>> -		result = -EFAULT;
>> -		goto ERRORHANDLER;
>> +		return -EFAULT;
>>   	}
>>   
>>   	if (pHandle->bExiting) {
>>   		PRINT_ER("pHandle fail\n");
>> -		result = -EFAULT;
>> -		goto ERRORHANDLER;
>> +		return -EFAULT;
>>   	}
>>   
>>   	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>>   
>>   	/* construct a new message */
>>   	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> You can make this allocation outisde the spinlock, then there won't be
> need to release it if the allocation fails.
>
>> -	if (!pstrMessage)
>> +
>> +	if (!pstrMessage) {
>> +		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>>   		return -ENOMEM;
>> +	}
>> +
>>   	pstrMessage->u32Length = u32SendBufferSize;
>>   	pstrMessage->pstrNext = NULL;
>>   	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
>>   					GFP_ATOMIC);
>> +
>>   	if (!pstrMessage->pvBuffer) {
>> -		result = -ENOMEM;
>> -		goto ERRORHANDLER;
>> +		spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> You are still holding pHandle->hSem here. Moreover, all error paths
> return while still holding pHandle->hSem.

Can you explain to me what you mean for holding hsem here? Basically, this function cannot release

the semaphore (of course, this synchronization mechanism will be changed, anyway) if errors happen.

The thread will do his work when it is released without unexpected situations.

> I'd suggest, that instead of trying to return immediately, you'd better
> move error handling code to the end of the function and use goto and
> several labels to do appropriate cleanups depending on when the error
> was caught. E.g.

I don't want to use goto statement as possible as I can. Do you concern semaphore uses in this function?
Thanks for your review,
Tony.

>
> mem_free:
> 	kfree(pstrMessage);
> release_lock:	
> 	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
> release_sem:
> 	up(&pHandle->sem);
> out:
> 	return result;
>
>> +		kfree(pstrMessage);
>> +		return -ENOMEM;
>>   	}
>>   
>>   	/* add it to the message queue */
>> @@ -103,14 +106,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>   
>>   	up(&pHandle->hSem);
>>   
>> -ERRORHANDLER:
>> -	/* error occured, free any allocations */
>> -	if (pstrMessage) {
>> -		kfree(pstrMessage->pvBuffer);
>> -		kfree(pstrMessage);
>> -	}
>> -
>> -	return result;
>> +	return 0;
>>   }
>>   
>>   /*!
>> -- 
>> 1.9.1
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

