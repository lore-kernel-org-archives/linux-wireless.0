Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49007 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab2F1U3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 16:29:53 -0400
Message-ID: <4FECBEBA.8090401@hauke-m.de> (sfid-20120628_222957_024307_92514F72)
Date: Thu, 28 Jun 2012 22:29:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Joe Perches <joe@perches.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH option A] bcma: use custom printing functions
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com> <1340912894.5257.0.camel@jlt3.sipsolutions.net> <CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com> <1340913949.2602.27.camel@joe2Laptop> <CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com>
In-Reply-To: <CACna6rwV3Cffm0nG_kHmE8ZO9oHOqSpfSysd9H1pgAHK71iLFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/28/2012 10:18 PM, Rafał Miłecki wrote:
> 2012/6/28 Joe Perches <joe@perches.com>:
>> On Thu, 2012-06-28 at 21:56 +0200, Rafał Miłecki wrote:
>>> 2012/6/28 Johannes Berg <johannes@sipsolutions.net>:
>>>> On Thu, 2012-06-28 at 21:44 +0200, Rafał Miłecki wrote:
>>>>
>>>>> +#define bcma_err(fmt, ...) \
>>>>> +     pr_err(KBUILD_MODNAME "-%d: " fmt, bus->num, ##__VA_ARGS__)
>>>>
>>>> both of your options seem to rely on "bus" being a variable in the
>>>> context, is that really a good idea?
>>>
>>> Yeah, I made that assumption to make calls nicer & shorter. We may
>>> need to get reference to "bus" in function or two.
>>>
>>> I saw such a solution in "radeon" gpu driver, example:
>>> value = RREG32(R600_AUDIO_STATUS_BITS);
>>> (they assume "rdev" is available in every function calling RREG32).
>>
>> I think that radeon use is ugly myself.
>>
>>> If you believe it's ugly, I can change that. I also wonder what Joe
>>> will respond.
>>>
>>> P.S.
>>> Both patches are not signed yet and they are supposed to be RFC. Sorry
>>> for missing that in subject line.
>>
>> I think it'd be better to add and use:
>>
>> #define bcma_bus_err(bus, fmt, ...)                             \
>>        pr_err("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>>
>> #define bcma_bus_info(bus, fmt, ...)                            \
>>        pr_info("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>>
>> or some other equivalent use if you're wedded
>> to wanting "bcma-%d:" prefixed output.
>>
>> I'd rather have the prefix be something like "bcma: <bus#>: ",
>> so a dmesg grep pattern can be "^bcma:" but hey, it ain't my code.
> 
> OK, thanks for your opinion. Just to be sure, did you mean:
> bcma: bus0: FOO BAR
> or
> bcma: <bus0>: FOO BAR
> ?
> 
> Personally I don't really care, but maybe there is already similar
> case in some other driver you know about? It could be nice to be
> consistent across the kernel.
> 
In b43 it looks like this if you have multiple devices logging, but if
there is some common way of doing it bcma should use that.

b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 6
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 11
b43-phy1: Broadcom 4716 WLAN found (core revision 17)
b43-phy1 debug: Found PHY: Analog 8, Type 4, Revision 5
b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 7

Hauke
