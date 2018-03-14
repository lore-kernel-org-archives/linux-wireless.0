Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:55448 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbeCNVeW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 17:34:22 -0400
Received: by mail-wm0-f52.google.com with SMTP id q83so6817042wme.5
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 14:34:22 -0700 (PDT)
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Kalle Valo <kvalo@codeaurora.org>,
        Bas Vermeulen <bvermeul@blackstar.nl>
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
 <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com>
 <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl>
 <874lli7mk5.fsf@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Felix Fietkau <nbd@nbd.name>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA99559.2070605@broadcom.com> (sfid-20180314_223427_036164_27CC0233)
Date: Wed, 14 Mar 2018 22:34:17 +0100
MIME-Version: 1.0
In-Reply-To: <874lli7mk5.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Martin

On 3/14/2018 3:34 PM, Kalle Valo wrote:
> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>
>>>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>>>     module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>>>     MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>>>     +static int ath9k_endian_check;
>>>>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness compatibility");
>>>>>>     #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>>>       int ath9k_use_chanctx;
>>>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>>>>     		ether_addr_copy(common->macaddr, mac);
>>>>>>       	ah->ah_flags &= ~AH_USE_EEPROM;
>>>>>> -	ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>> +	if (!ath9k_endian_check)
>>>>>> +		ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>> A bit annoying to have a module parameter, isn't there any automatic way
>>>>> to detect/try this? But on the other hand I guess this isn't a common
>>>>> problem as nobody has reported this before?
>>>>
>>>> There is an automatic way to detect this, but that is disabled by the
>>>> AH_NO_EEP_SWAP flag.
>>>
>>> Ah, I didn't check the code at all.
>>>
>>>> The platform initialisation does not set this flag if the endian_check
>>>> member of pdata is set to true, but there is no way to not set this
>>>> when using a device tree. I used a module parameter instead of a
>>>> device tree variable because I don't know of a way to modify the
>>>> device tree my PowerMac boots with.
>>>
>>> Ok, makes sense. A module parameter is not an ideal solution I guess
>>> it's ok in this case.
>>>
>> Kalle: Are there any changes you want me to make in order to get this
>> accepted? I didn't see anything for me to resolve, but I may have
>> missed something.
>>
>> I can submit a patch to not set the AH_NO_EEP_SWAP flag by default if
>> you prefer, as that would fix my problem as well. I am just not sure
>> that doesn't break things for some platform/device I don't have.
>
> I'm not really sure what to do. Basically this is a choise between bad
> for user experience (the module parameter) or risk of regressions
> (disable AH_NO_EEP_SWAP by default). As ath9k is used in very exotic
> hardware I'm starting to lean towards the module parameter approach
> (your patch) but would like to know what others think, especially Felix
> (CCed).

Hi Kalle,

Sorry for barging in, but I figured git history might tell us something. 
The flag was originally added by Felix (commit a59dadbeeaf7 ("ath9k: add 
support for endian swap of eeprom from platform data")) and the function 
ath9k_of_init() was added by Martin (CCed):

commit 138b41253d9c9f9a06c8b086880cd3e839a23d69
Author: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun Oct 16 22:59:07 2016 +0200

     ath9k: parse the device configuration from an OF node

Maybe he recalls what device(s) needed it.

Regards,
Arend
