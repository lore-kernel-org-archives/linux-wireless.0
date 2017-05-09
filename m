Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61722 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbdEIMV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 08:21:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wireless: ath: ath9k: remove unnecessary code
Date: Tue, 9 May 2017 12:21:54 +0000
Message-ID: <87shkez0da.fsf@kamboji.qca.qualcomm.com> (sfid-20170509_142234_890138_359A6E6B)
References: <20170509034814.GA18034@embeddedgus>
        <87efvy1d07.fsf@kamboji.qca.qualcomm.com>
        <20170509070158.Horde.dYleVB-aK1cNNyQpdVsVMNp@gator4166.hostgator.com>
In-Reply-To: <20170509070158.Horde.dYleVB-aK1cNNyQpdVsVMNp@gator4166.hostgator.com>
        (Gustavo A. R. Silva's message of "Tue, 9 May 2017 07:01:58 -0500")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:

> Hi Kalle,
>
> Quoting Kalle Valo <kvalo@qca.qualcomm.com>:
>
>> "Gustavo A. R. Silva" <garsilva@embeddedor.com> writes:
>>
>>> The name of an array used by itself will always return the array's addr=
ess.
>>> So this test will always evaluate as true.
>>>
>>> Addresses-Coverity-ID: 1364903
>>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/eeprom.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/eeprom.c
>>> b/drivers/net/wireless/ath/ath9k/eeprom.c
>>> index fb80ec8..5c3bc28 100644
>>> --- a/drivers/net/wireless/ath/ath9k/eeprom.c
>>> +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
>>> @@ -143,7 +143,7 @@ bool ath9k_hw_nvram_read(struct ath_hw *ah, u32
>>> off, u16 *data)
>>>
>>>  	if (ah->eeprom_blob)
>>>  		ret =3D ath9k_hw_nvram_read_firmware(ah->eeprom_blob, off, data);
>>> -	else if (pdata && !pdata->use_eeprom && pdata->eeprom_data)
>>> +	else if (pdata && !pdata->use_eeprom)
>>>  		ret =3D ath9k_hw_nvram_read_pdata(pdata, off, data);
>>>  	else
>>>  		ret =3D common->bus_ops->eeprom_read(common, off, data);
>>
>> The patch may very well be valid (didn't check yet) but the commit log
>> is gibberish for me.
>>
>
> Let me correct that and I'll send the patch again.

Thanks.

Also no need to have that long "net: wireless: ath:" prefix, "ath9k: "
or "ath10k: " is enough.

--=20
Kalle Valo=
