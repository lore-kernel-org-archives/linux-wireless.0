Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:42229 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751586AbeBZVnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 16:43:10 -0500
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Dan Williams <dcbw@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
 <51632c24-c10c-0446-25e7-743a6a016ea7@lwfinger.net>
 <c6519a95-40b1-1ca8-469a-418f6e62a2d0@blackstar.nl>
 <1519666924.30355.30.camel@redhat.com>
From: Bas Vermeulen <bvermeul@blackstar.nl>
Message-ID: <a26aab24-cbb5-6393-e160-79cf5d39a51c@blackstar.nl> (sfid-20180226_224336_149337_DDF2F017)
Date: Mon, 26 Feb 2018 22:42:23 +0100
MIME-Version: 1.0
In-Reply-To: <1519666924.30355.30.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-2-2018 18:42, Dan Williams wrote:
> On Mon, 2018-02-26 at 17:44 +0100, Bas Vermeulen wrote:
>> On 26-02-18 17:32, Larry Finger wrote:
>>> On 02/26/2018 04:07 AM, Bas Vermeulen wrote:
>>>> On 26-02-18 10:54, Kalle Valo wrote:
>>>>> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>>>>>
>>>>>> A random (little endian eeprom'd) ar9278 card didn't work on
>>>>>> my
>>>>>> PowerMac G5 without allowing the driver to byte-swap the
>>>>>> eeprom.
>>>>>>
>>>>>> Introduce a module parameter endian_check to allow this to
>>>>>> happen,
>>>>>> and the PCIe card to function correctly on BE powerpc.
>>>>>>
>>>>>> Signed-off-by: Bas Vermeulen <bvermeul@blackstar.nl>
>>>>>> ---
>>>>>>    drivers/net/wireless/ath/ath9k/init.c | 6 +++++-
>>>>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/ath/ath9k/init.c
>>>>>> b/drivers/net/wireless/ath/ath9k/init.c
>>>>>> index fa58a32227f5..421039dc060a 100644
>>>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>>>    module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>>>    MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>>> +static int ath9k_endian_check;
>>>>>> +module_param_named(endian_check, ath9k_endian_check, int,
>>>>>> 0444);
>>>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness
>>>>>> compatibility");
>>>>>>    #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>>>    int ath9k_use_chanctx;
>>>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc
>>>>>> *sc)
>>>>>>            ether_addr_copy(common->macaddr, mac);
>>>>>>        ah->ah_flags &= ~AH_USE_EEPROM;
>>>>>> -    ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>>> +    if (!ath9k_endian_check)
>>>>>> +        ah->ah_flags |= AH_NO_EEP_SWAP;
>>>>> A bit annoying to have a module parameter, isn't there any
>>>>> automatic
>>>>> way
>>>>> to detect/try this? But on the other hand I guess this isn't a
>>>>> common
>>>>> problem as nobody has reported this before?
>>>> There is an automatic way to detect this, but that is disabled by
>>>> the
>>>> AH_NO_EEP_SWAP flag.
>>>> The platform initialisation does not set this flag if the
>>>> endian_check member of pdata is set
>>>> to true, but there is no way to not set this when using a device
>>>> tree. I used a module
>>>> parameter instead of a device tree variable because I don't know
>>>> of a
>>>> way to modify the
>>>> device tree my PowerMac boots with.
>>> Shouldn't you be able to set ath9k_endian_check inside #ifdef
>>> __BIG_ENDIAN ... #endif in the initialization? I think that would
>>> achieve the same functionality without requiring the user to set a
>>> module parameter.
>> I could have done that, but didn't want to change the default
>> behaviour.
>> This patch keeps the
>> current behaviour on all platforms if the module parameter is not
>> set. I
>> don't have the means
>> to test mips and other platforms this could be used on. I don't mind
>> having to set a module
>> parameter, I mind not being able to change the behaviour
> Still, module parameters are an awful user experience because you need
> to know that they exist, what they do, and whether you need it or not.
> It doesn't just work.
>
> Is there no way to autodetect the endian-ness of the firmware itself,
> and if the known machine endian-ness isn't the same then swap?  This
> seems like a solvable problem.

The problem is already solved, but the solution is disabled by the 
AH_NO_EEP_SWAP
flag set in both initialization functions. See ath9k/init.c and 
ath9k/eeprom.c.
My patch just disables the flag when a module parameter is set, which 
enables the solution.

I can disable the flag without a problem, but that might have unintended 
side effects
on some platforms. If the consensus is that's the better solution I can 
prepare a patch,
but that would have to come from someone more knowledgeable than me.

Bas Vermeulen

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
