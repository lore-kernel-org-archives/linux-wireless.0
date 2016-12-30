Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33368 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752421AbcL3Vhz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 16:37:55 -0500
MIME-Version: 1.0
In-Reply-To: <86a22b00-1a04-25e7-9d31-2c1fd9d04e48@broadcom.com>
References: <20161228155955.25518-1-zajec5@gmail.com> <20161228155955.25518-2-zajec5@gmail.com>
 <491a5af2-449d-4b2a-c4ed-af0e89b2ca78@broadcom.com> <CACna6rwKLr-makRauYQf51330p96QrSNEhtNqu927yHT_Xm7Wg@mail.gmail.com>
 <CACna6rzJV-UdydKrXTquEzrkCfNXXKsHBrsZGjTJ8F=BSRyUjA@mail.gmail.com>
 <46007537-835c-90db-a44f-c45c8e2ecaed@broadcom.com> <CACna6rwaUWEjpBdfXS6uJSxKXH_mCP7YMGd1KaJropNQgVS7PA@mail.gmail.com>
 <86a22b00-1a04-25e7-9d31-2c1fd9d04e48@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 30 Dec 2016 22:37:53 +0100
Message-ID: <CACna6rwV5vfV-rHh8FVRdQZ45ex69xahweUVvL4vf2eWGiKZEQ@mail.gmail.com> (sfid-20161230_223759_185961_8C2B4B27)
Subject: Re: [PATCH 2/2] cfg80211: reg: support ieee80211-(min|max)-center-freq
 DT properties
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 December 2016 at 21:20, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 29-12-16 10:43, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 29 December 2016 at 09:57, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 28-12-16 22:30, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>> On 28 December 2016 at 22:28, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.co=
m> wrote:
>>>>> On 28 December 2016 at 22:07, Arend van Spriel
>>>>> <arend.vanspriel@broadcom.com> wrote:
>>>>>> On 28-12-16 16:59, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>>>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>>>>>
>>>>>>> They allow specifying hardware limitations of supported channels. T=
his
>>>>>>> may be useful for specifying single band devices or devices that su=
pport
>>>>>>> only some part of the whole band.
>>>>>>> E.g. some tri-band routers have separated radios for lower and high=
er
>>>>>>> part of 5 GHz band.
>>>>>>>
>>>>>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>>>>> ---
>>>>>>>  net/wireless/reg.c | 34 ++++++++++++++++++++++++++++++++++
>>>>>>>  1 file changed, 34 insertions(+)
>>>>>>>
>>>>>>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>>>>>>> index 5dbac37..35ba5c7 100644
>>>>>>> --- a/net/wireless/reg.c
>>>>>>> +++ b/net/wireless/reg.c
>>>>>>> @@ -1123,6 +1123,26 @@ const char *reg_initiator_name(enum nl80211_=
reg_initiator initiator)
>>>>>>>  }
>>>>>>>  EXPORT_SYMBOL(reg_initiator_name);
>>>>>>>
>>>>>>> +static bool reg_center_freq_of_valid(struct wiphy *wiphy,
>>>>>>> +                                  struct ieee80211_channel *chan)
>>>>>>> +{
>>>>>>> +     struct device_node *np =3D wiphy_dev(wiphy)->of_node;
>>>>>>> +     u32 val;
>>>>>>> +
>>>>>>> +     if (!np)
>>>>>>> +             return true;
>>>>>>> +
>>>>>>> +     if (!of_property_read_u32(np, "ieee80211-min-center-freq", &v=
al) &&
>>>>>>> +         chan->center_freq < KHZ_TO_MHZ(val))
>>>>>>> +             return false;
>>>>>>> +
>>>>>>> +     if (!of_property_read_u32(np, "ieee80211-max-center-freq", &v=
al) &&
>>>>>>> +         chan->center_freq > KHZ_TO_MHZ(val))
>>>>>>> +             return false;
>>>>>>
>>>>>> I suspect these functions rely on CONFIG_OF. So might not build for
>>>>>> !CONFIG_OF.
>>>>>
>>>>> I compiled it with
>>>>> # CONFIG_OF is not set
>>>>>
>>>>> Can you test it and provide a non-working config if you see a
>>>>> compilation error, please?
>>>>
>>>> include/linux/of.h provides a lot of dummy static inline functions if
>>>> CONFIG_OF is not used (they also allow compiler to drop most of the
>>>> code).
>>>
>>> of_propeirty_read_u32 is static inline in of.h calling
>>> of_property_read_u32_array, which has a dummy variant in of.h returning
>>> -ENOSYS so -38. Pretty sure that is not what you want. At least it does
>>> not allow the compiler to drop any code so probably better to do:
>>>
>>> if (!IS_ENABLED(CONFIG_OF) || !np)
>>>         return true;
>>
>> Please verify that using a compiler. If there is a problem I'll be
>> happy to work on it, but I need a proof it exists.
>
> I am on vacation right now so not having much more than email and web
> browser to use as review reference.
>
>> If compilers sees a:
>> if (!-ENOSYS && chan->center_freq < KHZ_TO_MHZ(val))
>> condition, it's pretty clear it can be dropped. With both conditional
>> blocks dropped function always returns "true" and... can be dropped.
>>
>> Let me see if I can convince you with the following test:
>
> No need to convince me. I made a mistake reviewing the code. Thanks for
> clarifying it.
>
>> $ grep -m 1 CONFIG_OF .config
>> # CONFIG_OF is not set
>> $ objdump --syms net/wireless/reg.o | grep -c reg_center_freq_of_valid
>> 0
>>
>> $ grep -m 1 CONFIG_OF .config
>> CONFIG_OF=3Dy
>> $ objdump --syms net/wireless/reg.o | grep -c reg_center_freq_of_valid
>> 1
>>
>>
>>> So with this patch you change the channel to DISABLED. I am not very
>>> familiar with reg.c so do you know if this is done before or after
>>> calling regulatory notifier in the driver. brcmfmac will enable channel=
s
>>> querying the device upon regulatory notifier call, which may undo the
>>> behavior introduced by your patch.
>>
>> I'm not regulatory export, so I hope someone will review this patch.
>> So far I can say it works for me after trying it on SR400ac with
>> BCM43602.
>
> But you probably do not have a mapping table for mapping country code
> received in notifier to firmware regulatory code/revision. Only if you
> have that, brcmfmac will update the channels in the bands.

Thanks, I'll redo my tests.


> Giving this some more consideration I am not sure if this is the proper
> place to handle this. ieee80211-(min|max)-center-freq is platform
> specific configuration allowing multiple cards to be used in different
> (sub)bands. This has nothing to do with regulatory. So probably better
> to move it to core.c or chan.c.

I can see point in this, I'll see if I can put this code in a more
proper place. Thanks for your comment!

--=20
Rafa=C5=82
