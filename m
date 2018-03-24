Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:55749 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbeCXIHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 04:07:41 -0400
Received: by mail-wm0-f46.google.com with SMTP id t7so7243415wmh.5
        for <linux-wireless@vger.kernel.org>; Sat, 24 Mar 2018 01:07:40 -0700 (PDT)
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Bas Vermeulen <bvermeul@blackstar.nl>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Felix Fietkau <nbd@nbd.name>
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
 <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com>
 <6404ec30-b7f6-ff26-a668-2e656799b69b@blackstar.nl>
 <874lli7mk5.fsf@codeaurora.org> <5AA99559.2070605@broadcom.com>
 <CAFBinCB_eLN8Gn0fRmKSFWSa_Yrw3+BB05Hwp_yNyYwhsS+s5w@mail.gmail.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <6e805340-d81a-86df-2130-3d6d58372d2a@kresin.me> (sfid-20180324_090759_994910_B907ADB1)
Date: Sat, 24 Mar 2018 09:05:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAFBinCB_eLN8Gn0fRmKSFWSa_Yrw3+BB05Hwp_yNyYwhsS+s5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

19.03.2018 09:11, Martin Blumenstingl:
> Hello everyone,
> 
> On Wed, Mar 14, 2018 at 10:34 PM, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> + Martin
>>
>> On 3/14/2018 3:34 PM, Kalle Valo wrote:
>>>
>>> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>>>
>>>>>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>>>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>>>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>>>>>      module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>>>>>      MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>>>>>      +static int ath9k_endian_check;
>>>>>>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>>>>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness
>>>>>>>> compatibility");
>>>>>>>>      #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>>>>>        int ath9k_use_chanctx;
>>>>>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>>>>>>                  ether_addr_copy(common->macaddr, mac);
>>>>>>>>          ah->ah_flags &= ~AH_USE_EEPROM;
>>>>>>>> -       ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>>>> +       if (!ath9k_endian_check)
>>>>>>>> +               ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>>>
>>>>>>> A bit annoying to have a module parameter, isn't there any automatic
>>>>>>> way
>>>>>>> to detect/try this? But on the other hand I guess this isn't a common
>>>>>>> problem as nobody has reported this before?
>>>>>>
>>>>>>
>>>>>> There is an automatic way to detect this, but that is disabled by the
>>>>>> AH_NO_EEP_SWAP flag.
>>>>>
>>>>>
>>>>> Ah, I didn't check the code at all.
>>>>>
>>>>>> The platform initialisation does not set this flag if the endian_check
>>>>>> member of pdata is set to true, but there is no way to not set this
>>>>>> when using a device tree. I used a module parameter instead of a
>>>>>> device tree variable because I don't know of a way to modify the
>>>>>> device tree my PowerMac boots with.
>>>>>
>>>>>
>>>>> Ok, makes sense. A module parameter is not an ideal solution I guess
>>>>> it's ok in this case.
>>>>>
>>>> Kalle: Are there any changes you want me to make in order to get this
>>>> accepted? I didn't see anything for me to resolve, but I may have
>>>> missed something.
>>>>
>>>> I can submit a patch to not set the AH_NO_EEP_SWAP flag by default if
>>>> you prefer, as that would fix my problem as well. I am just not sure
>>>> that doesn't break things for some platform/device I don't have.
>>>
>>>
>>> I'm not really sure what to do. Basically this is a choise between bad
>>> for user experience (the module parameter) or risk of regressions
>>> (disable AH_NO_EEP_SWAP by default). As ath9k is used in very exotic
>>> hardware I'm starting to lean towards the module parameter approach
>>> (your patch) but would like to know what others think, especially Felix
>>> (CCed).
>>
>>
>> Hi Kalle,
>>
>> Sorry for barging in, but I figured git history might tell us something. The
>> flag was originally added by Felix (commit a59dadbeeaf7 ("ath9k: add support
>> for endian swap of eeprom from platform data")) and the function
>> ath9k_of_init() was added by Martin (CCed):
>>
>> commit 138b41253d9c9f9a06c8b086880cd3e839a23d69
>> Author: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Date:   Sun Oct 16 22:59:07 2016 +0200
>>
>>      ath9k: parse the device configuration from an OF node
>>
>> Maybe he recalls what device(s) needed it.
> lots embedded devices (supported by OpenWrt) use ath9k chips
> 
> my primary target was the BT HomeHub 5A and some AVM Fritz Box (all
> using a lantiq SoC, but there are many more). these typically ship
> with:
> - a generic ath9k EEPROM which is sometimes even stored on NAND (= not
> directly connected to the ath9k chipset), which is why we need the
> "qca,no-eeprom"
> - some ship with a broken EEPROM that enables the 5GHz band on a
> 2.4GHz-only card, which is why we need "qca,disable-5ghz"
> - some ship with an EEPROM that doesn't have a unique mac address (the
> mac address is sometimes also stored on NAND), which is why we support
> the "mac-address" property
> - some ship an EEPROM where only the magic bytes are swapped (but the
> content is not), while others have both (magic bytes and content)
> byte-swapped
> 
> looking at ath9k_of_init it seems that "ah->ah_flags &=
> ~AH_USE_EEPROM" and "ah->ah_flags |= AH_NO_EEP_SWAP" are called
> unconditionally.
> maybe these should be part of the "qca,no-eeprom" if-block a few lines above
> 
> I also added Mathias to the CC list
> @Mathias: I believe all our .dts files in OpenWrt which specify an
> ath9k chipset also set the "qca,no-eeprom" property, right (a quick
> check suggests "yes")?

Yes, they all should have the qca,no-eeprom property. If not, it is a 
bug in the OpenWrt dts files.

Mathias
