Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:33212 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933033AbcK1Qei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 11:34:38 -0500
Received: by mail-yb0-f174.google.com with SMTP id v132so439217yba.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2016 08:34:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478706966.18306.1.camel@sipsolutions.net> <2fcb5f28-808e-f296-7e91-e5185e7577c9@quantenna.com>
 <1478725543.21403.4.camel@sipsolutions.net> <d1cfaf8a-55a6-3a7c-9e9d-ec810fe5b80d@quantenna.com>
 <1478864146.4129.4.camel@sipsolutions.net> <ec6a249c-ef57-40d8-0cd2-31613f046e23@quantenna.com>
From: Kyle McMartin <kyle@mcmartin.ca>
Date: Mon, 28 Nov 2016 11:34:36 -0500
Message-ID: <CANLJ0sm_iBfXB5TkjwTNO8RyYK3W7z8ecOrZo5f65qjb4WMXKQ@mail.gmail.com> (sfid-20161128_173455_905751_CE334FE1)
Subject: Re: [RFC] qtn: add FullMAC firmware for Quantenna QSR10G wifi device
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
        Kyle McMartin <kyle@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, btherthala@quantenna.com,
        hwang@quantenna.com, smaksimenko@quantenna.com,
        dlebed@quantenna.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2016 at 9:44 AM, IgorMitsyanko
<igor.mitsyanko.os@quantenna.com> wrote:
> Hi Ben, Kyle,
> could you please share what is the position of linux-firmware regarding
> firmware binaries that include GPL components? Does it require entire GPL
> components codebase be present in linux-firmware tree, or maybe having th=
is
> clause in license file is enough:
> +Open Source Software. The Software may include components that are licen=
sed
> +pursuant to open source software (=E2=80=9COpen Source Components=E2=80=
=9D). Information
> +regarding the Open Source Components included with the Software is
> available
> +upon request to oslegal@quantenna.com. To the extent such Open Source
> +Components are required to be licensed to you under the terms of a separ=
ate
> +license (such as an open source license) then such other terms shall app=
ly,
> and
> +nothing herein shall be deemed or interpreted to limit any rights you ma=
y
> have
> +under any such applicable license.
>
> From technical perspective, size of the codebase used to build Quantenna
> firmware is a few hundred MBs, it seems too much to include into
> linux-firmware tree.
>

I don't have strong feelings one way or another. I'd prefer not having
several hundred
MB of source that's unlikely to change included in the linux-firmware
git tree. I'm also not
a lawyer, so I can't help you decide what would satisfy the
distribution clause of the GPLv2.
We already have one GPL firmware (carl9170fw) which includes the
source, but just references
a seperate toolchain for downloading, so it's only approximately 1MB
in size in the tree.

Is your firmware source really that large, or is it just including the
entire build toolchain with it?

regards,
--Kyle

> On 11/11/2016 02:35 PM, Johannes Berg wrote:
>>
>> Adding linux-firmware people to Cc, since presumably they don't
>> necessarily read linux-wireless...
>>
>>> Johannes, from that perspective, who are the "redistributors"?
>>> Specifically, is linux-firmware git repository considered a
>>> redistributor or its just hosting files? I mean, at what moment
>>> someone else other then Quantenna will start to be legally obliged to
>>> make GPL code used in firmware available for others?
>>
>> Look, I don't know. I'd assume people who ship it, like any regular
>> distro, would be (re)distributors thereof. "Normal" (non-GPL) firmware
>> images come with a redistribution license, but that obviously can't
>> work here.
>>
>> There's some info from Ben here regarding the carl9170 case:
>> http://lkml.iu.edu/hypermail/linux/kernel/1605.3/01176.html
>>
>>> Personally I still hope that linux-firmware itself is not legally
>>> concerned with what is the content of firmware its hosting, but looks
>>> like there already was a precedent case  with carl9170 driver and
>>> we have to somehow deal with it.
>>
>> That's really all I wanted to bring up. I'm not involved with the
>> linux-firmware git tree.
>>
>>> There still may be a difference though: Quantenna is semiconductor
>>> company only, software
>>> used on actual products based on Quantenna chipsets is released by
>>> other
>>> companies.
>>> I just want to present our legal team with a clear case (and position
>>> of
>>> Linux maintainers) so that they can
>>> work with it and make decision on how to proceed.
>>>
>>>   From technical perspective, as I mentioned, SDK is quite huge and
>>> include a lot of opensource
>>> components including full Linux, I don't think its reasonable to have
>>> it
>>> inside linux-firmware tree.
>>> What are the options to share it other then providing it on request
>>> basis:
>>> - git repository
>>> - store tarball somewhere on official website
>>
>> Clearly that wasn't deemed appropriate for carl9170, so I don't see why
>> it'd be different here.
>>
>> johannes
>
>
