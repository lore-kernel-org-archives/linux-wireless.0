Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:46340 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3CBJpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 04:45:18 -0500
Received: by mail-oa0-f44.google.com with SMTP id h1so7042779oag.17
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2013 01:45:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5131C5CF.2090306@hauke-m.de>
References: <1362186865-20539-1-git-send-email-zajec5@gmail.com>
	<20130302050900.6e768a3e@milhouse>
	<CACna6rw1HLX8oP_mepfikpuKZ9zQ8j8+1=mOi_iCLQ49jUq-PA@mail.gmail.com>
	<5131C5CF.2090306@hauke-m.de>
Date: Sat, 2 Mar 2013 10:45:17 +0100
Message-ID: <CACna6rzJoihR5QtYLhWN+VNdCgc-CpEG30T2ju-Q8ro59f1BsQ@mail.gmail.com> (sfid-20130302_104559_193786_A69BF896)
Subject: Re: [PATCH] b43: HT-PHY: make it BCMA-only
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/2 Hauke Mehrtens <hauke@hauke-m.de>:
> On 03/02/2013 10:19 AM, Rafał Miłecki wrote:
>> 2013/3/2 Michael Büsch <m@bues.ch>:
>>> On Sat,  2 Mar 2013 02:14:25 +0100
>>> Rafał Miłecki <zajec5@gmail.com> wrote:
>>>
>>>> HT-PHY was found only on BCM4331 which is a BCMA-based chipset. This is
>>>> reallly unlikely we will ever see HT-PHY on SSB thus make the whole code
>>>> BCMA specific. This will allow us to call various BCMA-specific
>>>> functions directly (without extra checks).
>>>>
>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/b43/Kconfig  |    2 +-
>>>>  drivers/net/wireless/b43/phy_ht.c |    5 +++++
>>>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
>>>> index 7a28d21..09d315d 100644
>>>> --- a/drivers/net/wireless/b43/Kconfig
>>>> +++ b/drivers/net/wireless/b43/Kconfig
>>>> @@ -131,7 +131,7 @@ config B43_PHY_LP
>>>>
>>>>  config B43_PHY_HT
>>>>       bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
>>>> -     depends on B43 && EXPERIMENTAL
>>>> +     depends on B43 && B43_BCMA && EXPERIMENTAL
>>>
>>> Makes sense.
>>> What about removing EXPERIMENTAL? This flag is mostly useless these days.
>>
>> A little later, I've plan for some minor improvement :)
>
> There is already a patch [0] in Linus tree removing EXPERIMENTAL.
>
> Hauke
>
> [0]:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=afd19ef0b1a98f420ddcfc619182fd589034577f

Glad there was a b43-dev Cc...

John please drop this patch. I'll wait for you merging Linus's tree
and re-submit it rebased.

-- 
Rafał
