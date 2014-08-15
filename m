Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56085 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaHOOFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2014 10:05:43 -0400
Message-ID: <53EE13B4.3030304@candelatech.com> (sfid-20140815_160547_166766_5ECCA111)
Date: Fri, 15 Aug 2014 07:05:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: extra logging for core-restart state change logic.
References: <1407272099-6271-1-git-send-email-greearb@candelatech.com> <87egwij6x0.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87egwij6x0.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/15/2014 05:04 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -700,6 +700,7 @@ static void ath10k_core_restart(struct work_struct *work)
>>   	switch (ar->state) {
>>   	case ATH10K_STATE_ON:
>>   		ar->state = ATH10K_STATE_RESTARTING;
>> +		ath10k_warn("core-restart, going to state RESTARTING from ON\n");
>>   		del_timer_sync(&ar->scan.timeout);
>>   		ath10k_reset_scan((unsigned long)ar);
>>   		ieee80211_restart_hw(ar->hw);
>> @@ -713,10 +714,11 @@ static void ath10k_core_restart(struct work_struct *work)
>>   		/* hw restart might be requested from multiple places */
>>   		break;
>>   	case ATH10K_STATE_RESTARTED:
>> -		ar->state = ATH10K_STATE_WEDGED;
>>   		/* fall through */
>>   	case ATH10K_STATE_WEDGED:
>> -		ath10k_warn("device is wedged, will not restart\n");
>> +		ath10k_warn("device is wedged, will not restart (state %d)\n",
>> +			ar->state);
>> +		ar->state = ATH10K_STATE_WEDGED;
>>   		break;
>>   	}
>
> I think state prints should be debug messages, not part of error
> messages. For example, we could add new debug level ATH10K_DBG_CORE or
> something like that.

I'll respin the patch accordingly when I get a chance.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
