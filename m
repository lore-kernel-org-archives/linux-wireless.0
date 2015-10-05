Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:54573 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbbJEDYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Oct 2015 23:24:06 -0400
Subject: Re: [PATCH 1/2] drivers: staging: wilc1000: Move spin lock to the
 start of critical section
To: Greg KH <gregkh@linuxfoundation.org>,
	Chandra S Gorentla <csgorentla@gmail.com>
References: <1443864450-18167-1-git-send-email-csgorentla@gmail.com>
 <20151004084335.GA24589@kroah.com>
CC: <rachel.kim@atmel.com>, <devel@driverdev.osuosl.org>,
	<chris.park@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <linux-kernel@vger.kernel.org>,
	<dan.carpenter@oracle.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5611ED46.7040800@atmel.com> (sfid-20151005_052429_048071_92E50CA2)
Date: Mon, 5 Oct 2015 12:23:50 +0900
MIME-Version: 1.0
In-Reply-To: <20151004084335.GA24589@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 04일 17:43, Greg KH wrote:
> On Sat, Oct 03, 2015 at 02:57:29PM +0530, Chandra S Gorentla wrote:
>> The spin_lock_irqsave is moved to just beginning of critical section.
>> This change moves a couple of return statements out of the lock.
>>
>> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
>> ---
>>   drivers/staging/wilc1000/wilc_msgqueue.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
>> index d5ebd6d..284a3f5 100644
>> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
>> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
>> @@ -72,8 +72,6 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>>   		goto ERRORHANDLER;
>>   	}
>>   
>> -	spin_lock_irqsave(&pHandle->strCriticalSection, flags);
>> -
>>   	/* construct a new message */
>>   	pstrMessage = kmalloc(sizeof(Message), GFP_ATOMIC);
> As you have moved the lock, can you also change this to GFP_KERNEL as
> well because we do not have a lock held?
>
> And how have you tested that this is ok?  What is this lock trying to
> protect?

This function is called even in interrupt context, so GFP_ATOMIC should be called. The spinlock
also should protect pstrMessage from allocating the memory, so we don't place it to the beginning
of critical section as Chandra said.

Thanks,
Tony.

> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

