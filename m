Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.228]:26352 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752049AbdEIM07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:26:59 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 31747485B
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2017 07:01:59 -0500 (CDT)
Date: Tue, 09 May 2017 07:01:58 -0500
Message-ID: <20170509070158.Horde.dYleVB-aK1cNNyQpdVsVMNp@gator4166.hostgator.com> (sfid-20170509_142702_466051_9B63FA1E)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath: ath9k: remove unnecessary code
References: <20170509034814.GA18034@embeddedgus>
 <87efvy1d07.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87efvy1d07.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Quoting Kalle Valo <kvalo@qca.qualcomm.com>:

> "Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:
>
>> The name of an array used by itself will always return the array's address.
>> So this test will always evaluate as true.
>>
>> Addresses-Coverity-ID: 1364903
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/eeprom.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c  
>> b/drivers/net/wireless/ath/ath9k/eeprom.c
>> index fb80ec8..5c3bc28 100644
>> --- a/drivers/net/wireless/ath/ath9k/eeprom.c
>> +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
>> @@ -143,7 +143,7 @@ bool ath9k_hw_nvram_read(struct ath_hw *ah, u32  
>> off, u16 *data)
>>
>>  	if (ah->eeprom_blob)
>>  		ret = ath9k_hw_nvram_read_firmware(ah->eeprom_blob, off, data);
>> -	else if (pdata && !pdata->use_eeprom && pdata->eeprom_data)
>> +	else if (pdata && !pdata->use_eeprom)
>>  		ret = ath9k_hw_nvram_read_pdata(pdata, off, data);
>>  	else
>>  		ret = common->bus_ops->eeprom_read(common, off, data);
>
> The patch may very well be valid (didn't check yet) but the commit log
> is gibberish for me.
>

Let me correct that and I'll send the patch again.

Thanks!
--
Gustavo A. R. Silva
