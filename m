Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:44704 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbeDLSx0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 14:53:26 -0400
Received: by mail-oi0-f65.google.com with SMTP id j143-v6so6152556oih.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2018 11:53:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4d776721-a590-c9bd-75a4-7cddb00ac091@blackstar.nl>
References: <20180226090917.7iabysywbv6h4rqr@alienware17> <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl> <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com>
 <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl> <874lli7mk5.fsf@codeaurora.org>
 <4d776721-a590-c9bd-75a4-7cddb00ac091@blackstar.nl>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 12 Apr 2018 20:53:04 +0200
Message-ID: <CAFBinCC7L+jYHL3ur8czG6iwsRFe7Z0UGCfEsEo4npP7c9OPRg@mail.gmail.com> (sfid-20180412_205330_218723_BC320EAA)
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Bas Vermeulen <bvermeul@blackstar.nl>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Felix Fietkau <nbd@nbd.name>,
        arend.vanspriel@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Bas,

On Tue, Apr 10, 2018 at 11:05 AM, Bas Vermeulen <bvermeul@blackstar.nl> wrote:
> On 14-03-18 15:34, Kalle Valo wrote:
>>
>> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>>
>>>>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>>>>     module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>>>>     MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>>>>     +static int ath9k_endian_check;
>>>>>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>>>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness
>>>>>>> compatibility");
>>>>>>>     #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>>>>       int ath9k_use_chanctx;
>>>>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>>>>>                 ether_addr_copy(common->macaddr, mac);
>>>>>>>         ah->ah_flags &= ~AH_USE_EEPROM;
>>>>>>> -       ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>>> +       if (!ath9k_endian_check)
>>>>>>> +               ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>>
>>>>>> A bit annoying to have a module parameter, isn't there any automatic
>>>>>> way
>>>>>> to detect/try this? But on the other hand I guess this isn't a common
>>>>>> problem as nobody has reported this before?
>>>>>
>>>>> There is an automatic way to detect this, but that is disabled by the
>>>>> AH_NO_EEP_SWAP flag.
>>>>
>>>> Ah, I didn't check the code at all.
>>>>
>>>>> The platform initialisation does not set this flag if the endian_check
>>>>> member of pdata is set to true, but there is no way to not set this
>>>>> when using a device tree. I used a module parameter instead of a
>>>>> device tree variable because I don't know of a way to modify the
>>>>> device tree my PowerMac boots with.
>>>>
>>>> Ok, makes sense. A module parameter is not an ideal solution I guess
>>>> it's ok in this case.
>>>>
>>> Kalle: Are there any changes you want me to make in order to get this
>>> accepted? I didn't see anything for me to resolve, but I may have
>>> missed something.
>>>
>>> I can submit a patch to not set the AH_NO_EEP_SWAP flag by default if
>>> you prefer, as that would fix my problem as well. I am just not sure
>>> that doesn't break things for some platform/device I don't have.
>>
>> I'm not really sure what to do. Basically this is a choise between bad
>> for user experience (the module parameter) or risk of regressions
>> (disable AH_NO_EEP_SWAP by default). As ath9k is used in very exotic
>> hardware I'm starting to lean towards the module parameter approach
>> (your patch) but would like to know what others think, especially Felix
>> (CCed).
>>
>> Full patch here:
>>
>> https://patchwork.kernel.org/patch/10241731/
>
>
> Just another ping. As I understood things, all OpenWRT dts' use
> qca,no-eeprom, and perhaps we could
> move ~AH_USE_EEPROM and |= AH_NO_EEP_SWAP in that if block.
>
> This would solve my problem, as I need to have AH_NO_EEP_SWAP removed from
> flags for my card (which is a
> little endian eeprom/card used on a big endian machine).
>
> Would you like me to prepare a patch for this? Is there anyone who can test
> this on the various OpenWRT
> boards/soc and or other configurations? I don't want to break things for
> other people.
can you please prepare a patch for this?
if you want I can test it on two OpenWrt devices and see if it breaks
anything (please give me a few days to test though)


Regards
Martin
