Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753418AbeBZOwj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 09:52:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Bas Vermeulen <bvermeul@blackstar.nl>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
        <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
        <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
Date: Mon, 26 Feb 2018 16:52:33 +0200
In-Reply-To: <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl> (Bas
        Vermeulen's message of "Mon, 26 Feb 2018 11:07:27 +0100")
Message-ID: <87a7vvu7ke.fsf@kamboji.qca.qualcomm.com> (sfid-20180226_155244_109249_28399A07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bas Vermeulen <bvermeul@blackstar.nl> writes:

> On 26-02-18 10:54, Kalle Valo wrote:
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
>>>   drivers/net/wireless/ath/ath9k/init.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>>> index fa58a32227f5..421039dc060a 100644
>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>   +static int ath9k_endian_check;
>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness compatibility");
>>>   #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>     int ath9k_use_chanctx;
>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>   		ether_addr_copy(common->macaddr, mac);
>>>     	ah->ah_flags &= ~AH_USE_EEPROM;
>>> -	ah->ah_flags |= AH_NO_EEP_SWAP;
>>> +	if (!ath9k_endian_check)
>>> +		ah->ah_flags |= AH_NO_EEP_SWAP;
>> A bit annoying to have a module parameter, isn't there any automatic way
>> to detect/try this? But on the other hand I guess this isn't a common
>> problem as nobody has reported this before?
>
> There is an automatic way to detect this, but that is disabled by the
> AH_NO_EEP_SWAP flag.

Ah, I didn't check the code at all.

> The platform initialisation does not set this flag if the endian_check
> member of pdata is set to true, but there is no way to not set this
> when using a device tree. I used a module parameter instead of a
> device tree variable because I don't know of a way to modify the
> device tree my PowerMac boots with.

Ok, makes sense. A module parameter is not an ideal solution I guess
it's ok in this case.

-- 
Kalle Valo
