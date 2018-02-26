Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36774 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeBZQcx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:32:53 -0500
Received: by mail-oi0-f65.google.com with SMTP id u73so6543521oie.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 08:32:53 -0800 (PST)
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Bas Vermeulen <bvermeul@blackstar.nl>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <51632c24-c10c-0446-25e7-743a6a016ea7@lwfinger.net> (sfid-20180226_173257_065365_8C015B88)
Date: Mon, 26 Feb 2018 10:32:51 -0600
MIME-Version: 1.0
In-Reply-To: <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2018 04:07 AM, Bas Vermeulen wrote:
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
>>> +static int ath9k_endian_check;
>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness compatibility");
>>>   #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>   int ath9k_use_chanctx;
>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>           ether_addr_copy(common->macaddr, mac);
>>>       ah->ah_flags &= ~AH_USE_EEPROM;
>>> -    ah->ah_flags |= AH_NO_EEP_SWAP;
>>> +    if (!ath9k_endian_check)
>>> +        ah->ah_flags |= AH_NO_EEP_SWAP;
>> A bit annoying to have a module parameter, isn't there any automatic way
>> to detect/try this? But on the other hand I guess this isn't a common
>> problem as nobody has reported this before?
> There is an automatic way to detect this, but that is disabled by the 
> AH_NO_EEP_SWAP flag.
> The platform initialisation does not set this flag if the endian_check member of 
> pdata is set
> to true, but there is no way to not set this when using a device tree. I used a 
> module
> parameter instead of a device tree variable because I don't know of a way to 
> modify the
> device tree my PowerMac boots with.

Shouldn't you be able to set ath9k_endian_check inside #ifdef __BIG_ENDIAN ... 
#endif in the initialization? I think that would achieve the same functionality 
without requiring the user to set a module parameter.

I agree that you want to stay away from the device tree in a PPC computer.

Larry
