Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blackstar.xs4all.nl ([83.163.96.30]:41569 "EHLO
        blackstar.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751022AbeBZM06 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 07:26:58 -0500
Subject: Re: [PATCH] ath9k: introduce endian_check module parameter
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
References: <20180226090917.7iabysywbv6h4rqr@alienware17>
 <87y3jgt6sp.fsf@kamboji.qca.qualcomm.com>
 <7d6af051-2724-5dfc-cf69-376c0b501626@blackstar.nl>
 <7c6eef8c-cb7a-5441-6f50-1df3efdafb16@dd-wrt.com>
From: Bas Vermeulen <bvermeul@blackstar.nl>
Message-ID: <2a37a358-f6b2-62f8-aef4-fab382e8c3aa@blackstar.nl> (sfid-20180226_132703_103598_610AEDCC)
Date: Mon, 26 Feb 2018 13:26:10 +0100
MIME-Version: 1.0
In-Reply-To: <7c6eef8c-cb7a-5441-6f50-1df3efdafb16@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-02-18 12:30, Sebastian Gottschall wrote:
> Am 26.02.2018 um 11:07 schrieb Bas Vermeulen:
>> On 26-02-18 10:54, Kalle Valo wrote:
>>> Bas Vermeulen <bvermeul@blackstar.nl> writes:
>>>
>>>> A random (little endian eeprom'd) ar9278 card didn't work on my
>>>> PowerMac G5 without allowing the driver to byte-swap the eeprom.
>>>>
>>>> Introduce a module parameter endian_check to allow this to happen,
>>>> and the PCIe card to function correctly on BE powerpc.
>>>>
>>>> Signed-off-by: Bas Vermeulen <bvermeul@blackstar.nl>
>>>> ---
>>>>   drivers/net/wireless/ath/ath9k/init.c | 6 +++++-
>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/ath/ath9k/init.c 
>>>> b/drivers/net/wireless/ath/ath9k/init.c
>>>> index fa58a32227f5..421039dc060a 100644
>>>> --- a/drivers/net/wireless/ath/ath9k/init.c
>>>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>>>> @@ -67,6 +67,9 @@ static int ath9k_ps_enable;
>>>>   module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
>>>>   MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
>>>>   +static int ath9k_endian_check;
>>>> +module_param_named(endian_check, ath9k_endian_check, int, 0444);
>>>> +MODULE_PARM_DESC(endian_check, "Check EEPROM for endianness 
>>>> compatibility");
>>>>   #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
>>>>     int ath9k_use_chanctx;
>>>> @@ -587,7 +590,8 @@ static int ath9k_of_init(struct ath_softc *sc)
>>>>           ether_addr_copy(common->macaddr, mac);
>>>>         ah->ah_flags &= ~AH_USE_EEPROM;
>>>> -    ah->ah_flags |= AH_NO_EEP_SWAP;
>>>> +    if (!ath9k_endian_check)
>>>> +        ah->ah_flags |= AH_NO_EEP_SWAP;
>>> A bit annoying to have a module parameter, isn't there any automatic 
>>> way
>>> to detect/try this? But on the other hand I guess this isn't a common
>>> problem as nobody has reported this before?
>> There is an automatic way to detect this, but that is disabled by the 
>> AH_NO_EEP_SWAP flag.
>> The platform initialisation does not set this flag if the 
>> endian_check member of pdata is set
>> to true, but there is no way to not set this when using a device 
>> tree. I used a module
>> parameter instead of a device tree variable because I don't know of a 
>> way to modify the
>> device tree my PowerMac boots with.
> have you tried to compile it without device tree support? since its 
> just a pcie card, i dont think that devicetree is required here
> it should run fine without it.

The driver will still set AH_NO_EEP_SWAP regardless, and will still not 
swap the eeprom from
little endian to big endian on big endian machines. See 
drivers/net/wireless/ath/ath9k/eeprom.c:188
and drivers/net/wireless/ath/ath9k/init.c (lines 593 and 645).

The reason I'm talking about device trees here is because I could have 
used a device tree parameter
instead of a module parameter.

Bas Vermeulen

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.
