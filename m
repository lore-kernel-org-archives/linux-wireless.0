Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:46149 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbaIWPA6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 11:00:58 -0400
Message-ID: <54218B29.40806@candelatech.com> (sfid-20140923_170114_922533_C9C7853C)
Date: Tue, 23 Sep 2014 08:00:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/2] ath10k:  make firmware text debug messages more verbose.
References: <1411419245-25799-1-git-send-email-greearb@candelatech.com> <87zjdqcwef.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zjdqcwef.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/23/2014 06:13 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> There are not many of these messages producted by the
>> firmware, but they are generally fairly useful, so print
>> them at info level.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index cd60940..6be62ac 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -2050,7 +2050,7 @@ static void ath10k_wmi_event_debug_print(struct ath10k *ar,
>>   	/* the last byte is always reserved for the null character */
>>   	buf[i] = '\0';
>>
>> -	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi event debug print '%s'\n", buf);
>> +	ath10k_info(ar, "wmi event debug print '%s'\n", buf);
>
> This does not bring any extra value to normal users, it's only useful to
> firmware engineers. That's why it needs to stay as a debug message.
> Maybe we should add a new debug level just for these events, would that
> help?

It will help users trying to tune the maximum resource combinations (vdevs + peers + tx-descriptors + skid-len, etc)
because my firmware prints out remaining RAM/IRAM after booting up.

But, a separate debug flag would be fine.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
