Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41052 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbeDUIFB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Apr 2018 04:05:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id g21-v6so903478wrb.8
        for <linux-wireless@vger.kernel.org>; Sat, 21 Apr 2018 01:05:00 -0700 (PDT)
Subject: Re: [PATCH 9/9] brcmfmac: use request_firmware_nowait2 to load
 firmware without warnings
To: Kalle Valo <kvalo@codeaurora.org>,
        Andres Rodriguez <andresx7@gmail.com>
References: <20180417153307.3693-1-andresx7@gmail.com>
 <20180417153307.3693-10-andresx7@gmail.com>
 <87h8o6i36l.fsf@kamboji.qca.qualcomm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com,
        ckoenig.leichtzumerken@gmail.com, linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5ADAF0A9.2090604@broadcom.com> (sfid-20180421_100524_526351_9D34848F)
Date: Sat, 21 Apr 2018 10:04:57 +0200
MIME-Version: 1.0
In-Reply-To: <87h8o6i36l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/20/2018 12:26 PM, Kalle Valo wrote:
> Andres Rodriguez <andresx7@gmail.com> writes:
>
>> This reduces the unnecessary spew when trying to load optional firmware:
>> "Direct firmware load for ... failed with error -2"

So what happened with the request_firmware_nowarn() api (discussed in 
another thread). Did it get lost with your kidney stones ;-) ? It seems 
we start having the same discussion about the asynchronous variant as 
well here which is a bit counter productive.

Let's get back to the issue of the message above. So when is the message 
unnecessary. To me there are actually to cases in which the message can 
confuse people searching the log for hints on a issue they have with a 
device. 1) when the driver requests a sequence of files and only needs 
one, and 2) when the driver request can be handled by fallback. Why not 
only issue the error message when the device driver uses 
request_firmware_direct() or when there is no fallback.

Also this patch does not seem to be made against latest code as I did a 
major rework that went in v4.17-rc1.

>> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> With wireless patches always CC linux-wireless list, please. Adding it
> now.
>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> index 091b52979e03..26db3ebd52dc 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>> @@ -503,8 +503,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>>   		goto done;
>>
>>   	fwctx->code = fw;
>> -	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
>> -				      fwctx->dev, GFP_KERNEL, fwctx,
>> +	ret = request_firmware_nowait(THIS_MODULE, true, false,
>
> A perfect example why enums should be in function calls instead of
> booleans, that "true, false" tells nothing to me and it would be time
> consuming to check from headers files what it means. If you had proper
> enums, for example "FIRMWARE_MODE_FOO, FIRMWARE_STATE_BAR", it would be
> immediately obvious for the reader what the parameters are. Of course
> the first boolean was already there before, but maybe change the new
> boolean to an enum?

I can not fully agree here. While being a bit more descriptive even with 
enums wrong enum values can be used due to copy-paste errors for 
instance. Also when reviewing code, sometime looking up function 
prototypes and type definitions are part of the fun. Tools like ctags or 
elixir website make it pretty easy.

Now regarding this part of the patch the driver is requesting nvram 
file, which is not always optional. For SDIO devices it is required and 
for PCIe it is optional so firmware.c module is instructed about this 
with a flag. So here that flag should be used to pass the proper 
boolean/call the appropriate function. Actually in the latest code the 
nvram is request synchronously.

>> +				      fwctx->nvram_name, fwctx->dev,
>> +				      GFP_KERNEL, fwctx,
>>   				      brcmf_fw_request_nvram_done);
>>
>>   	/* pass NULL to nvram callback for bcm47xx fallback */
>> @@ -547,7 +548,7 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
>>   	fwctx->domain_nr = domain_nr;
>>   	fwctx->bus_nr = bus_nr;
>>
>> -	return request_firmware_nowait(THIS_MODULE, true, code, dev,
>> +	return request_firmware_nowait2(THIS_MODULE, true, false, code, dev,
>>   				       GFP_KERNEL, fwctx,
>>   				       brcmf_fw_request_code_done);
>>   }
>
> Also the number two in the function name is not really telling anything.
> I think that something like request_firmware_nowait_nowarn() would be
> better, even if it's so ugly.

This is requesting the actual firmware that is run by the cpu on the 
chip so it is not optional.

Again, the firmware.c module has been reworked quite a bit in v4.17-rc1 
so this patch is outdated.

Regards,
Arend
