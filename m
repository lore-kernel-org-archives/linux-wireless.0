Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0048.outbound.protection.outlook.com ([104.47.41.48]:26269
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755515AbcK1Wks (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 17:40:48 -0500
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: Kyle McMartin <kyle@mcmartin.ca>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net>
 <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net>
 <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net>
 <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
 <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>, <btherthala@quantenna.com>,
        <hwang@quantenna.com>, <smaksimenko@quantenna.com>,
        <dlebed@quantenna.com>, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        "Sergey Matyukevich" <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <15e3a2fd-7201-29d8-c0e8-b8ac9e943da2@quantenna.com> (sfid-20161128_234053_995814_D2655D5A)
Date: Tue, 29 Nov 2016 01:07:09 +0300
MIME-Version: 1.0
In-Reply-To: <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2016 07:34 PM, Kyle McMartin wrote:
> On Tue, Nov 22, 2016 at 9:44 AM, IgorMitsyanko
> <igor.mitsyanko.os@quantenna.com> wrote:
>> Hi Ben, Kyle,
>> could you please share what is the position of linux-firmware regarding
>> firmware binaries that include GPL components? Does it require entire GPL
>> components codebase be present in linux-firmware tree, or maybe having this
>> clause in license file is enough:
>> +Open Source Software. The Software may include components that are licensed
>> +pursuant to open source software (“Open Source Components”). Information
>> +regarding the Open Source Components included with the Software is
>> available
>> +upon request to oslegal@quantenna.com. To the extent such Open Source
>> +Components are required to be licensed to you under the terms of a separate
>> +license (such as an open source license) then such other terms shall apply,
>> and
>> +nothing herein shall be deemed or interpreted to limit any rights you may
>> have
>> +under any such applicable license.
>>
>>  From technical perspective, size of the codebase used to build Quantenna
>> firmware is a few hundred MBs, it seems too much to include into
>> linux-firmware tree.
>>
> I don't have strong feelings one way or another. I'd prefer not having
> several hundred
> MB of source that's unlikely to change included in the linux-firmware
> git tree. I'm also not
> a lawyer, so I can't help you decide what would satisfy the
> distribution clause of the GPLv2.
> We already have one GPL firmware (carl9170fw) which includes the
> source, but just references
> a seperate toolchain for downloading, so it's only approximately 1MB
> in size in the tree.
>
> Is your firmware source really that large, or is it just including the
> entire build toolchain with it?

It does include Linux environment with userspace tools, toolchain and 
some other components that are not actually needed, you're right.
Maybe its possible to skip providing entire build environment, but 
simply provide GPL code and patches to 3-d party opensource components? 
Just state which version the patch is based on: for example, patch  to 
apply on top of Linux 3.14 sources, but no sources themselves. In this 
case, it won't be possible to build firmware manually, but GPL code 
modifications will be available.


>
> regards,
> --Kyle
>
>> On 11/11/2016 02:35 PM, Johannes Berg wrote:
>>> Adding linux-firmware people to Cc, since presumably they don't
>>> necessarily read linux-wireless...
>>>
>>>> Johannes, from that perspective, who are the "redistributors"?
>>>> Specifically, is linux-firmware git repository considered a
>>>> redistributor or its just hosting files? I mean, at what moment
>>>> someone else other then Quantenna will start to be legally obliged to
>>>> make GPL code used in firmware available for others?
>>> Look, I don't know. I'd assume people who ship it, like any regular
>>> distro, would be (re)distributors thereof. "Normal" (non-GPL) firmware
>>> images come with a redistribution license, but that obviously can't
>>> work here.
>>>
>>> There's some info from Ben here regarding the carl9170 case:
>>> http://lkml.iu.edu/hypermail/linux/kernel/1605.3/01176.html
>>>
>>>> Personally I still hope that linux-firmware itself is not legally
>>>> concerned with what is the content of firmware its hosting, but looks
>>>> like there already was a precedent case  with carl9170 driver and
>>>> we have to somehow deal with it.
>>> That's really all I wanted to bring up. I'm not involved with the
>>> linux-firmware git tree.
>>>
>>>> There still may be a difference though: Quantenna is semiconductor
>>>> company only, software
>>>> used on actual products based on Quantenna chipsets is released by
>>>> other
>>>> companies.
>>>> I just want to present our legal team with a clear case (and position
>>>> of
>>>> Linux maintainers) so that they can
>>>> work with it and make decision on how to proceed.
>>>>
>>>>    From technical perspective, as I mentioned, SDK is quite huge and
>>>> include a lot of opensource
>>>> components including full Linux, I don't think its reasonable to have
>>>> it
>>>> inside linux-firmware tree.
>>>> What are the options to share it other then providing it on request
>>>> basis:
>>>> - git repository
>>>> - store tarball somewhere on official website
>>> Clearly that wasn't deemed appropriate for carl9170, so I don't see why
>>> it'd be different here.
>>>
>>> johannes
>>
