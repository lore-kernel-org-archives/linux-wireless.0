Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:46790 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbeCPJ2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 05:28:50 -0400
Subject: Re: [PATCH] wcn36xx: dequeue all pending indicator messages
To: Ramon Fried <rfried@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org
References: <20180315223725.28283-1-daniel@zonque.org>
 <3d6783ea-837c-a314-dea9-63906aeb0793@codeaurora.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <e4dfbb05-10c7-2dc5-6995-ea34bd5945bc@zonque.org> (sfid-20180316_102854_710041_05AA496C)
Date: Fri, 16 Mar 2018 10:28:48 +0100
MIME-Version: 1.0
In-Reply-To: <3d6783ea-837c-a314-dea9-63906aeb0793@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Friday, March 16, 2018 10:09 AM, Ramon Fried wrote:
> On 3/16/2018 12:37 AM, Daniel Mack wrote:
>> In case wcn36xx_smd_rsp_process() is called more than once before
>> hal_ind_work was dispatched, the messages will end up in hal_ind_queue,
>> but wcn36xx_ind_smd_work() will only look at the first message in that
>> list.
>>
>> Fix this by dequeing the messages from the list in a loop, and only stop
>> when it's empty.
> Interesting. does it solve a specific bug ? can you elaborate ?

I'm poking around in the driver to hopefully find issues that cause
instability and failures in joining networks, which I am seeing a lot.
There are a number of bug reports regarding this, for instance

  https://bugs.96boards.org/show_bug.cgi?id=538
  https://bugs.96boards.org/show_bug.cgi?id=319

I'm following your patches and also started to look into the driver
myself, and during review, I noticed that list handling issue. I have a
big fat warning locally that would tell me if the list ever contains
more than one entry, but that never happens, as the indicator messages
are way too infrequent to trigger the race. So this isn't a real-world
issue as far as I can tell, but it is still quite obviously a bug. Hence
I considered posting a patch.

I have another one that handles missed TX ACKs from the firmware (TODO
comment in wcn36xx_start_tx()), but that case doesn't happen either.

So I'll keep looking further, and will send things if I spot something.
In the meantime, as you seem to be familiar with the firmware internals,
I'd appreciate any pointer in how to narrow this down. It's extremely
important to us, as we want to release a product featuring the wcn36xx.


Thanks a lot for all your efforts!

Daniel


>>
>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>> ---
>>   drivers/net/wireless/ath/wcn36xx/smd.c | 95 +++++++++++++++++++---------------
>>   1 file changed, 52 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>> index 7cc29285e052..a6b5352f59e9 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>> @@ -2409,54 +2409,63 @@ static void wcn36xx_ind_smd_work(struct work_struct *work)
>>   {
>>   	struct wcn36xx *wcn =
>>   		container_of(work, struct wcn36xx, hal_ind_work);
>> -	struct wcn36xx_hal_msg_header *msg_header;
>> -	struct wcn36xx_hal_ind_msg *hal_ind_msg;
>> -	unsigned long flags;
>>   
>> -	spin_lock_irqsave(&wcn->hal_ind_lock, flags);
>> +	for (;;) {
>> +		struct wcn36xx_hal_msg_header *msg_header;
>> +		struct wcn36xx_hal_ind_msg *hal_ind_msg;
>> +		unsigned long flags;
>>   
>> -	hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
>> -				       struct wcn36xx_hal_ind_msg,
>> -				       list);
>> -	list_del(wcn->hal_ind_queue.next);
>> -	spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
>> +		spin_lock_irqsave(&wcn->hal_ind_lock, flags);
>>   
>> -	msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
>> +		if (list_empty(&wcn->hal_ind_queue)) {
>> +			spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
>> +			return;
>> +		}
>>   
>> -	switch (msg_header->msg_type) {
>> -	case WCN36XX_HAL_COEX_IND:
>> -	case WCN36XX_HAL_DEL_BA_IND:
>> -	case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
>> -		break;
>> -	case WCN36XX_HAL_OTA_TX_COMPL_IND:
>> -		wcn36xx_smd_tx_compl_ind(wcn,
>> -					 hal_ind_msg->msg,
>> -					 hal_ind_msg->msg_len);
>> -		break;
>> -	case WCN36XX_HAL_MISSED_BEACON_IND:
>> -		wcn36xx_smd_missed_beacon_ind(wcn,
>> -					      hal_ind_msg->msg,
>> -					      hal_ind_msg->msg_len);
>> -		break;
>> -	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
>> -		wcn36xx_smd_delete_sta_context_ind(wcn,
>> -						   hal_ind_msg->msg,
>> -						   hal_ind_msg->msg_len);
>> -		break;
>> -	case WCN36XX_HAL_PRINT_REG_INFO_IND:
>> -		wcn36xx_smd_print_reg_info_ind(wcn,
>> -					       hal_ind_msg->msg,
>> -					       hal_ind_msg->msg_len);
>> -		break;
>> -	case WCN36XX_HAL_SCAN_OFFLOAD_IND:
>> -		wcn36xx_smd_hw_scan_ind(wcn, hal_ind_msg->msg,
>> -					hal_ind_msg->msg_len);
>> -		break;
>> -	default:
>> -		wcn36xx_err("SMD_EVENT (%d) not supported\n",
>> -			      msg_header->msg_type);
>> +		hal_ind_msg = list_first_entry(&wcn->hal_ind_queue,
>> +					       struct wcn36xx_hal_ind_msg,
>> +					       list);
>> +		list_del(&hal_ind_msg->list);
>> +		spin_unlock_irqrestore(&wcn->hal_ind_lock, flags);
>> +
>> +		msg_header = (struct wcn36xx_hal_msg_header *)hal_ind_msg->msg;
>> +
>> +		switch (msg_header->msg_type) {
>> +		case WCN36XX_HAL_COEX_IND:
>> +		case WCN36XX_HAL_DEL_BA_IND:
>> +		case WCN36XX_HAL_AVOID_FREQ_RANGE_IND:
>> +			break;
>> +		case WCN36XX_HAL_OTA_TX_COMPL_IND:
>> +			wcn36xx_smd_tx_compl_ind(wcn,
>> +						 hal_ind_msg->msg,
>> +						 hal_ind_msg->msg_len);
>> +			break;
>> +		case WCN36XX_HAL_MISSED_BEACON_IND:
>> +			wcn36xx_smd_missed_beacon_ind(wcn,
>> +						      hal_ind_msg->msg,
>> +						      hal_ind_msg->msg_len);
>> +			break;
>> +		case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
>> +			wcn36xx_smd_delete_sta_context_ind(wcn,
>> +							   hal_ind_msg->msg,
>> +							   hal_ind_msg->msg_len);
>> +			break;
>> +		case WCN36XX_HAL_PRINT_REG_INFO_IND:
>> +			wcn36xx_smd_print_reg_info_ind(wcn,
>> +						       hal_ind_msg->msg,
>> +						       hal_ind_msg->msg_len);
>> +			break;
>> +		case WCN36XX_HAL_SCAN_OFFLOAD_IND:
>> +			wcn36xx_smd_hw_scan_ind(wcn, hal_ind_msg->msg,
>> +						hal_ind_msg->msg_len);
>> +			break;
>> +		default:
>> +			wcn36xx_err("SMD_EVENT (%d) not supported\n",
>> +				    msg_header->msg_type);
>> +		}
>> +
>> +		kfree(hal_ind_msg);
>>   	}
>> -	kfree(hal_ind_msg);
>>   }
>>   int wcn36xx_smd_open(struct wcn36xx *wcn)
>>   {
> 
