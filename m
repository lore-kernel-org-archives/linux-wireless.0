Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:54551 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbJEDXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 23:23:43 -0400
Subject: Re: [PATCH 2/2] drivers: staging: wilc1000: Call kfree only for error
 cases
To: Chandra Gorentla <csgorentla@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
 <1443864450-18167-2-git-send-email-csgorentla@gmail.com>
 <20151004084457.GB24589@kroah.com> <20151004102859.GB27051@gcs-HP-Notebook>
CC: <dan.carpenter@oracle.com>, <johnny.kim@atmel.com>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
	<linux-kernel@vger.kernel.org>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5611ED2C.7080002@atmel.com> (sfid-20151005_052428_430187_AF789789)
Date: Mon, 5 Oct 2015 12:23:24 +0900
MIME-Version: 1.0
In-Reply-To: <20151004102859.GB27051@gcs-HP-Notebook>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 04일 19:28, Chandra Gorentla wrote:
> On Sun, Oct 04, 2015 at 09:44:57AM +0100, Greg KH wrote:
>> On Sat, Oct 03, 2015 at 02:57:30PM +0530, Chandra S Gorentla wrote:
>>>   - kfree is being called for the members of the queue without
>>>     de-queuing them; they are just inserted within this function;
>>>     they are supposed to be de-queued and freed in a function
>>>     for receiving the queue items
>>>   - goto statements are removed
>>>   - After kfree correction, there is no need for target block
>>>     of goto statement; hence it is removed
>>>
>>> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
>>> ---
>>>   drivers/staging/wilc1000/wilc_msgqueue.c | 22 ++++++----------------
>>>   1 file changed, 6 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
>>> index 284a3f5..eae90be 100644
>>> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
>>> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
>>> @@ -56,32 +56,30 @@ int wilc_mq_destroy(WILC_MsgQueueHandle *pHandle)
>>>   int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>>   			     const void *pvSendBuffer, u32 u32SendBufferSize)
>>>   {
>>> -	int result = 0;
>>>   	unsigned long flags;
>>>   	Message *pstrMessage = NULL;
>>>   
>>>   	if ((!pHandle) || (u32SendBufferSize == 0) || (!pvSendBuffer)) {
>>>   		PRINT_ER("pHandle or pvSendBuffer is null\n");
>>> -		result = -EFAULT;
>>> -		goto ERRORHANDLER;
>>> +		return -EFAULT;
>>>   	}
>>>   
>>>   	if (pHandle->bExiting) {
>>>   		PRINT_ER("pHandle fail\n");
>>> -		result = -EFAULT;
>>> -		goto ERRORHANDLER;
>>> +		return -EFAULT;
>>>   	}
>>>   
>>>   	/* construct a new message */
>>>   	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
>>>   	if (!pstrMessage)
>>>   		return -ENOMEM;
>>> +
>>>   	pstrMessage->u32Length = u32SendBufferSize;
>>>   	pstrMessage->pstrNext = NULL;
>>>   	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
>>>   	if (!pstrMessage->pvBuffer) {
>>> -		result = -ENOMEM;
>>> -		goto ERRORHANDLER;
>>> +		kfree(pstrMessage);
>>> +		return -ENOMEM;
>>>   	}
>>>   	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);
>>>   
>>> @@ -102,15 +100,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>>   	spin_unlock_irqrestore(&pHandle->strCriticalSection, flags);
>>>   
>>>   	up(&pHandle->hSem);
>>> -
>>> -ERRORHANDLER:
>>> -	/* error occured, free any allocations */
>>> -	if (pstrMessage) {
>>> -		kfree(pstrMessage->pvBuffer);
>>> -		kfree(pstrMessage);
>>> -	}
>>> -
>>> -	return result;
>>> +	return 0;
>> Aren't you now leaking memory as you aren't freeing pstrMessage and the
>> buffer on the "normal" return path?
> In the normal path kfree is called in a separate (wilc_mq_recv) function.
> The purpose of the currently modified function (wilc_mq_send) is to post
> a message to a queue by allocating memory for the message.  The receiver
> function is supposed to remove the message from the queue and free the
> memory.
>
This patch is reasonable and normal free is done in recv function as Chandra said.

Thanks,

Tony.

>> thanks,
>>
>> greg k-h
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

