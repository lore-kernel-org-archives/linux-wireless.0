Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56668 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1UmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 16:42:24 -0400
Received: by wibhm11 with SMTP id hm11so458752wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 13:42:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FECBEBA.8090401@hauke-m.de>
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	<1340912894.5257.0.camel@jlt3.sipsolutions.net>
	<CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com>
	<1340913949.2602.27.camel@joe2Laptop>
	<CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com>
	<4FECBEBA.8090401@hauke-m.de>
Date: Thu, 28 Jun 2012 22:42:22 +0200
Message-ID: <CACna6rzHr3vvqgjTXSAp_9vmMYBOZ4Fwj-X8pMOuwZhv3J4j_w@mail.gmail.com> (sfid-20120628_224254_771809_1E7389A8)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Joe Perches <joe@perches.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/28 Hauke Mehrtens <hauke@hauke-m.de>:
> On 06/28/2012 10:18 PM, Rafał Miłecki wrote:
>> 2012/6/28 Joe Perches <joe@perches.com>:
>>> On Thu, 2012-06-28 at 21:56 +0200, Rafał Miłecki wrote:
>>>> 2012/6/28 Johannes Berg <johannes@sipsolutions.net>:
>>>>> On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:
>>>>>
>>>>>> +#define bcma_err(fmt, ...) \
>>>>>> +     pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
>>>>>
>>>>> both of your options seem to rely on "bus" being a variable in the
>>>>> context, is that really a good idea?
>>>>
>>>> Yeah, I made that assumption to make calls nicer & shorter. We may
>>>> need to get reference to "bus" in function or two.
>>>>
>>>> I saw such a solution in "radeon" gpu driver, example:
>>>> value = RREG32(R600_AUDIO_STATUS_BITS);
>>>> (they assume "rdev" is available in every function calling RREG32).
>>>
>>> I think that radeon use is ugly myself.
>>>
>>>> If you believe it's ugly, I can change that. I also wonder what Joe
>>>> will respond.
>>>>
>>>> P.S.
>>>> Both patches are not signed yet and they are supposed to be RFC. Sorry
>>>> for missing that in subject line.
>>>
>>> I think it'd be better to add and use:
>>>
>>> #define bcma_bus_err(bus, fmt, ...)                             \
>>>        pr_err("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>>>
>>> #define bcma_bus_info(bus, fmt, ...)                            \
>>>        pr_info("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>>>
>>> or some other equivalent use if you're wedded
>>> to wanting "bcma-%d:" prefixed output.
>>>
>>> I'd rather have the prefix be something like "bcma: <bus#>: ",
>>> so a dmesg grep pattern can be "^bcma:" but hey, it ain't my code.
>>
>> OK, thanks for your opinion. Just to be sure, did you mean:
>> bcma: bus0: FOO BAR
>> or
>> bcma: <bus0>: FOO BAR
>> ?
>>
>> Personally I don't really care, but maybe there is already similar
>> case in some other driver you know about? It could be nice to be
>> consistent across the kernel.
>>
> In b43 it looks like this if you have multiple devices logging, but if
> there is some common way of doing it bcma should use that.
>
> b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 6
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 11
> b43-phy1: Broadcom 4716 WLAN found (core revision 17)
> b43-phy1 debug: Found PHY: Analog 8, Type 4, Revision 5
> b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 7

I don't think we should follow b43 way. For example I remember myself
logging "debug" and "error" strings in early bcma times. I was told to
avoid that and just use correct pr_<level> calls.

-- 
Rafał
