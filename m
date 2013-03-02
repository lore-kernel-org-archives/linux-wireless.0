Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44721 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3CBJ0y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 04:26:54 -0500
Message-ID: <5131C5CF.2090306@hauke-m.de> (sfid-20130302_102707_304695_34E1D859)
Date: Sat, 02 Mar 2013 10:26:39 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: HT-PHY: make it BCMA-only
References: <1362186865-20539-1-git-send-email-zajec5@gmail.com> <20130302050900.6e768a3e@milhouse> <CACna6rw1HLX8oP_mepfikpuKZ9zQ8j8+1=mOi_iCLQ49jUq-PA@mail.gmail.com>
In-Reply-To: <CACna6rw1HLX8oP_mepfikpuKZ9zQ8j8+1=mOi_iCLQ49jUq-PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/02/2013 10:19 AM, Rafał Miłecki wrote:
> 2013/3/2 Michael Büsch <m@bues.ch>:
>> On Sat,  2 Mar 2013 02:14:25 +0100
>> Rafał Miłecki <zajec5@gmail.com> wrote:
>>
>>> HT-PHY was found only on BCM4331 which is a BCMA-based chipset. This is
>>> reallly unlikely we will ever see HT-PHY on SSB thus make the whole code
>>> BCMA specific. This will allow us to call various BCMA-specific
>>> functions directly (without extra checks).
>>>
>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>> ---
>>>  drivers/net/wireless/b43/Kconfig  |    2 +-
>>>  drivers/net/wireless/b43/phy_ht.c |    5 +++++
>>>  2 files changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
>>> index 7a28d21..09d315d 100644
>>> --- a/drivers/net/wireless/b43/Kconfig
>>> +++ b/drivers/net/wireless/b43/Kconfig
>>> @@ -131,7 +131,7 @@ config B43_PHY_LP
>>>
>>>  config B43_PHY_HT
>>>       bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
>>> -     depends on B43 && EXPERIMENTAL
>>> +     depends on B43 && B43_BCMA && EXPERIMENTAL
>>
>> Makes sense.
>> What about removing EXPERIMENTAL? This flag is mostly useless these days.
> 
> A little later, I've plan for some minor improvement :)

There is already a patch [0] in Linus tree removing EXPERIMENTAL.

Hauke

[0]:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=afd19ef0b1a98f420ddcfc619182fd589034577f
