Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755113AbeDWNyj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 09:54:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com,
        ckoenig.leichtzumerken@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] brcmfmac: use request_firmware_nowait2 to load firmware without warnings
References: <20180417153307.3693-1-andresx7@gmail.com>
        <20180417153307.3693-10-andresx7@gmail.com>
        <87h8o6i36l.fsf@kamboji.qca.qualcomm.com>
        <5ADAF0A9.2090604@broadcom.com>
Date: Mon, 23 Apr 2018 16:54:32 +0300
In-Reply-To: <5ADAF0A9.2090604@broadcom.com> (Arend van Spriel's message of
        "Sat, 21 Apr 2018 10:04:57 +0200")
Message-ID: <87k1sydo4n.fsf@kamboji.qca.qualcomm.com> (sfid-20180423_155443_940344_AB68AB1C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 4/20/2018 12:26 PM, Kalle Valo wrote:
>> Andres Rodriguez <andresx7@gmail.com> writes:
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> index 091b52979e03..26db3ebd52dc 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
>>> @@ -503,8 +503,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
>>>   		goto done;
>>>
>>>   	fwctx->code = fw;
>>> -	ret = request_firmware_nowait(THIS_MODULE, true, fwctx->nvram_name,
>>> -				      fwctx->dev, GFP_KERNEL, fwctx,
>>> +	ret = request_firmware_nowait(THIS_MODULE, true, false,
>>
>> A perfect example why enums should be in function calls instead of
>> booleans, that "true, false" tells nothing to me and it would be time
>> consuming to check from headers files what it means. If you had proper
>> enums, for example "FIRMWARE_MODE_FOO, FIRMWARE_STATE_BAR", it would be
>> immediately obvious for the reader what the parameters are. Of course
>> the first boolean was already there before, but maybe change the new
>> boolean to an enum?
>
> I can not fully agree here. While being a bit more descriptive even
> with enums wrong enum values can be used due to copy-paste errors for
> instance.

Well, you can also copy paste booleans wrong. I would claim that it's
even easier to copy paste booleans wrong than enums.

> Also when reviewing code, sometime looking up function prototypes and
> type definitions are part of the fun. Tools like ctags or elixir
> website make it pretty easy.

Hehe :) But when reviewing patches ctags doesn't really help. But yeah,
booleans vs enums in function parameters is just a matter of taste. I
prefer enums but I'm sure there are people who prefer booleans.

-- 
Kalle Valo
