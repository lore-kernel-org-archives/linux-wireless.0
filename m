Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeCNOez (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 10:34:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bas Vermeulen <bvermeul@blackstar.nl>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
        <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
        <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
        <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com>
        <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl>
Date: Wed, 14 Mar 2018 16:34:50 +0200
In-Reply-To: <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl> (Bas
        Vermeulen's message of "Wed, 14 Mar 2018 13:42:35 +0100")
Message-ID: <874lli7mk5.fsf@codeaurora.org> (sfid-20180314_153459_331262_F5D948CF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bas Vermeulen <bvermeul@blackstar.nl> writes:

>>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>>    module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>>    MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>>    +static int ath9k_endian_check;
>>>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness compatibility");
>>>>>    #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>>      int ath9k_use_chanctx;
>>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>>>    		ether_addr_copy(common->macaddr, mac);
>>>>>      	ah->ah_flags &= ~AH_USE_EEPROM;
>>>>> -	ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>> +	if (!ath9k_endian_check)
>>>>> +		ah->ah_flags |= AH_NO_EEP_SWAP;
>>>> A bit annoying to have a module parameter, isn't there any automatic way
>>>> to detect/try this? But on the other hand I guess this isn't a common
>>>> problem as nobody has reported this before?
>>>
>>> There is an automatic way to detect this, but that is disabled by the
>>> AH_NO_EEP_SWAP flag.
>>
>> Ah, I didn't check the code at all.
>>
>>> The platform initialisation does not set this flag if the endian_check
>>> member of pdata is set to true, but there is no way to not set this
>>> when using a device tree. I used a module parameter instead of a
>>> device tree variable because I don't know of a way to modify the
>>> device tree my PowerMac boots with.
>>
>> Ok, makes sense. A module parameter is not an ideal solution I guess
>> it's ok in this case.
>>
> Kalle: Are there any changes you want me to make in order to get this
> accepted? I didn't see anything for me to resolve, but I may have
> missed something.
>
> I can submit a patch to not set the AH_NO_EEP_SWAP flag by default if
> you prefer, as that would fix my problem as well. I am just not sure
> that doesn't break things for some platform/device I don't have.

I'm not really sure what to do. Basically this is a choise between bad
for user experience (the module parameter) or risk of regressions
(disable AH_NO_EEP_SWAP by default). As ath9k is used in very exotic
hardware I'm starting to lean towards the module parameter approach
(your patch) but would like to know what others think, especially Felix
(CCed).

Full patch here:

https://patchwork.kernel.org/patch/10241731/

-- 
Kalle Valo
