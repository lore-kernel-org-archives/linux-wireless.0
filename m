Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60378 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbcEJOkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 10:40:01 -0400
Message-ID: <5731F2BF.90305@candelatech.com> (sfid-20160510_164006_586863_DCDB7A0A)
Date: Tue, 10 May 2016 07:39:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 1/5] ath10k: Ensure txrx-compl-task is stopped when
 cleaning htt-tx.
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com> <20160510064800.GC25626@atheros-ThinkPad-T61>
In-Reply-To: <20160510064800.GC25626@atheros-ThinkPad-T61>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/09/2016 11:48 PM, Mohammed Shafi Shajakhan wrote:
> Hi Ben,
>
> On Fri, Apr 01, 2016 at 02:12:08PM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, the txrx-compl-task may access some bad memory?
>
> good to mention when this happens, will be helpful ifsome one recreates
> the issue and matches your call trace

The backtraces were all over the place because the driver was writing to
memory after it was freed, so I am not sure they are worth while.  I'm sure I posted
some to the mailing lists around the time where I was working on this, but since
I was fighting several different problems, hard to know exactly what was what.

Thanks,
Ben

>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> index 07b960e..58e88d3 100644
>> --- a/drivers/net/wireless/ath/ath10k/htt_tx.c
>> +++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
>> @@ -376,6 +376,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
>>   {
>>   	int size;
>>
>> +	tasklet_kill(&htt->txrx_compl_task);
>> +
>>   	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
>>   	idr_destroy(&htt->pending_tx);
>>
>> --
>> 2.4.3
>
> regards,
> shafi
>
>>
>>
>> _______________________________________________
>> ath10k mailing list
>> ath10k@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/ath10k
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
