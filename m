Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37642 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752316AbcL2I5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 03:57:15 -0500
Received: by mail-wm0-f42.google.com with SMTP id t79so328003132wmt.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2016 00:57:14 -0800 (PST)
Subject: Re: [PATCH 2/2] cfg80211: reg: support
 ieee80211-(min|max)-center-freq DT properties
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20161228155955.25518-1-zajec5@gmail.com>
 <20161228155955.25518-2-zajec5@gmail.com>
 <491a5af2-449d-4b2a-c4ed-af0e89b2ca78@broadcom.com>
 <CACna6rwKLr-makRauYQf51330p96QrSNEhtNqu927yHT_Xm7Wg@mail.gmail.com>
 <CACna6rzJV-UdydKrXTquEzrkCfNXXKsHBrsZGjTJ8F=BSRyUjA@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <46007537-835c-90db-a44f-c45c8e2ecaed@broadcom.com> (sfid-20161229_095718_997311_6D551DC0)
Date: Thu, 29 Dec 2016 09:57:12 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rzJV-UdydKrXTquEzrkCfNXXKsHBrsZGjTJ8F=BSRyUjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28-12-16 22:30, Rafał Miłecki wrote:
> On 28 December 2016 at 22:28, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On 28 December 2016 at 22:07, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 28-12-16 16:59, Rafał Miłecki wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> They allow specifying hardware limitations of supported channels. This
>>>> may be useful for specifying single band devices or devices that support
>>>> only some part of the whole band.
>>>> E.g. some tri-band routers have separated radios for lower and higher
>>>> part of 5 GHz band.
>>>>
>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>> ---
>>>>  net/wireless/reg.c | 34 ++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 34 insertions(+)
>>>>
>>>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>>>> index 5dbac37..35ba5c7 100644
>>>> --- a/net/wireless/reg.c
>>>> +++ b/net/wireless/reg.c
>>>> @@ -1123,6 +1123,26 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
>>>>  }
>>>>  EXPORT_SYMBOL(reg_initiator_name);
>>>>
>>>> +static bool reg_center_freq_of_valid(struct wiphy *wiphy,
>>>> +                                  struct ieee80211_channel *chan)
>>>> +{
>>>> +     struct device_node *np = wiphy_dev(wiphy)->of_node;
>>>> +     u32 val;
>>>> +
>>>> +     if (!np)
>>>> +             return true;
>>>> +
>>>> +     if (!of_property_read_u32(np, "ieee80211-min-center-freq", &val) &&
>>>> +         chan->center_freq < KHZ_TO_MHZ(val))
>>>> +             return false;
>>>> +
>>>> +     if (!of_property_read_u32(np, "ieee80211-max-center-freq", &val) &&
>>>> +         chan->center_freq > KHZ_TO_MHZ(val))
>>>> +             return false;
>>>
>>> I suspect these functions rely on CONFIG_OF. So might not build for
>>> !CONFIG_OF.
>>
>> I compiled it with
>> # CONFIG_OF is not set
>>
>> Can you test it and provide a non-working config if you see a
>> compilation error, please?
> 
> include/linux/of.h provides a lot of dummy static inline functions if
> CONFIG_OF is not used (they also allow compiler to drop most of the
> code).

of_propeirty_read_u32 is static inline in of.h calling
of_property_read_u32_array, which has a dummy variant in of.h returning
-ENOSYS so -38. Pretty sure that is not what you want. At least it does
not allow the compiler to drop any code so probably better to do:

if (!IS_ENABLED(CONFIG_OF) || !np)
	return true;

So with this patch you change the channel to DISABLED. I am not very
familiar with reg.c so do you know if this is done before or after
calling regulatory notifier in the driver. brcmfmac will enable channels
querying the device upon regulatory notifier call, which may undo the
behavior introduced by your patch.

Regards,
Arend
