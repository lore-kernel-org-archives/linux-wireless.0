Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:42886 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbbJNF0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 01:26:23 -0400
Subject: Re: [PATCH 54/54] staging: wilc1000: wilc_msgqueue.c : remove the
 goto ERRORHANDER
To: Mike Rapoport <mike.rapoport@gmail.com>
References: <1444734132-17858-1-git-send-email-tony.cho@atmel.com>
 <1444734132-17858-9-git-send-email-tony.cho@atmel.com>
 <20151013140817.GA21195@zed.strato>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <561DE76D.1050308@atmel.com> (sfid-20151014_072627_435337_C200B934)
Date: Wed, 14 Oct 2015 14:26:05 +0900
MIME-Version: 1.0
In-Reply-To: <20151013140817.GA21195@zed.strato>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 13일 23:08, Mike Rapoport wrote:
> On Tue, Oct 13, 2015 at 08:02:12PM +0900, Tony Cho wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch removes goto ERRORHANDER and the result variable in wilc_mq_send.
>> Then, the error type is directly returned. If normal operation, freeing memory
>> is not needed in this function.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> ---
>>   drivers/staging/wilc1000/wilc_msgqueue.c | 20 +++++---------------
>>   1 file changed, 5 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
>> index b13809a..60539aa 100644
>> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
>> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
>> @@ -56,20 +56,17 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
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
>> @@ -83,8 +80,8 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>   	pstrMessage->pvBuffer = kmemdup(pvSendBuffer, u32SendBufferSize,
>>   					GFP_ATOMIC);
>>   	if (!pstrMessage->pvBuffer) {
>> -		result = -ENOMEM;
>> -		goto ERRORHANDLER;
>> +		kfree(pstrMessage);
>> +		return -ENOMEM;
> It seems that the error path returns from the function while still
> holding spinlock and semaphore. It would be better to rework allocation
> errors handling so that the locks will be released, rather than just
> remove goto...

Thanks for your review. I am going to send v2 for it.

Tony.

>>   	}
>>   
>>   	/* add it to the message queue */
>> @@ -103,14 +100,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
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

