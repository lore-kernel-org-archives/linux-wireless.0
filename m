Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:41555 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751903AbeBZMWw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 07:22:52 -0500
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <4936d4c0-ab52-add5-828b-9509eabd8ad0@dd-wrt.com>
From: Bas Vermeulen <bvermeul@blackstar.nl>
Message-ID: <2fc14584-21e3-356c-c357-158ae90bdaa5@blackstar.nl> (sfid-20180226_132335_495089_94C19BFC)
Date: Mon, 26 Feb 2018 13:21:29 +0100
MIME-Version: 1.0
In-Reply-To: <4936d4c0-ab52-add5-828b-9509eabd8ad0@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-02-18 12:28, Sebastian Gottschall wrote:
> Am 26.02.2018 um 10:54 schrieb Kalle Valo:
>> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>>
>>> A random (little endian eeprom'd) ar9278 card didn't work on my
>>> PowerMac G5 without allowing the driver to byte-swap the eeprom.
>>>
>>> Introduce a module parameter endian_check to allow this to happen,
>>> and the PCIe card to function correctly on BE powerpc.
>>>
>>> Signed-off-by: Bas Vermeulen <bvermeul@blackstar.nl>
>>> ---
>>>   drivers/net/wireless/ath/ath9k/init.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/init.c 
>>> b/drivers/net/wireless/ath/ath9k/init.c
>>> index fa58a32227f5..421039dc060a 100644
>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>   +static int ath9k_endian_check;
>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness 
>>> compatibility");
>>>   #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>     int ath9k_use_chanctx;
>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>           ether_addr_copy(common->macaddr, mac);
>>>         ah->ah_flags &= ~AH_USE_EEPROM;
>>> -    ah->ah_flags |= AH_NO_EEP_SWAP;
>>> +    if (!ath9k_endian_check)
>>> +        ah->ah_flags |= AH_NO_EEP_SWAP;
>> A bit annoying to have a module parameter, isn't there any automatic way
>> to detect/try this? But on the other hand I guess this isn't a common
>> problem as nobody has reported this before?
> There is a way by simply checking the eeprom magic on this chipset

I am well aware.

The AH_NO_EEP_SWAP flag disables fixing the eeprom by swapping the data 
read from eeprom.
AH_NO_EEP_SWAP is enabled by default in ath9k_of_init() without this patch.
I am happy if the AH_NO_EEP_SWAP flag is not set, that would fix my 
problem, but changes the
current behaviour. I wanted to keep the current behaviour by default, 
and give me and others a
way to make it work on big endian machines with cards with little endian 
eeproms.

Bas Vermeulen

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
