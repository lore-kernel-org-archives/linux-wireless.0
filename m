Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:53438 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2LZMYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 07:24:41 -0500
Received: by mail-we0-f177.google.com with SMTP id x48so3958871wey.22
        for <linux-wireless@vger.kernel.org>; Wed, 26 Dec 2012 04:24:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rwS0Ueu3kvKjM_rGB9ZqJ_UbDZv4wwMdWX4W4_4GkK9Zg@mail.gmail.com>
References: <1356459816-2214-1-git-send-email-zajec5@gmail.com>
	<50DAD374.1090305@hauke-m.de>
	<CACna6rw00D+pVHPoYPgN9OoiQpHGumTw7oCXSmj+ECsqTVzR9Q@mail.gmail.com>
	<50DAD8A6.8050405@hauke-m.de>
	<CACna6rwS0Ueu3kvKjM_rGB9ZqJ_UbDZv4wwMdWX4W4_4GkK9Zg@mail.gmail.com>
Date: Wed, 26 Dec 2012 13:24:39 +0100
Message-ID: <CACna6rwoKyVcvB2KS8uuN2PDtgBGe_6QbCh0rV9NvUx5jDhwQA@mail.gmail.com> (sfid-20121226_132445_094698_E9825B0E)
Subject: Re: [RFC][PATCH] ssb: add place for serial flash driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/12/26 Rafał Miłecki <zajec5@gmail.com>:
> 2012/12/26 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 12/26/2012 11:46 AM, Rafał Miłecki wrote:
>>> 2012/12/26 Hauke Mehrtens <hauke@hauke-m.de>:
>>>> On 12/25/2012 07:23 PM, Rafał Miłecki wrote:
>>>>> +#ifdef CONFIG_SSB_SFLASH
>>>>> +struct ssb_sflash {
>>>>> +     bool present;
>>>>> +};
>>>>> +#endif
>>>>
>>>> I assume you want to share some of the code for the serial flash driver
>>>> between bcma and ssb. You should create a file with the structure in
>>>> include/linux/platform_data/ and share that between bcma and ssb.
>>>
>>> It's a small struct having about 5 trivial fields. We don't share
>>> sturcts for any other drivers (chipcommon/mips/pcie) so I think they
>>> should stay separated here as well.
>>
>> When this structure is just used in ssb or bcma and in the nvram code of
>> arch/mips/bcm47x I would also prefer two structures one for bcma and one
>> for ssb.
>>
>>> Plus the mtd driver will have to implement bus abstraction anyway.
>>
>> If you have a structure describing the needs of the serial flash driver
>> in drivers/mtd/ you could write the flash driver without any ifdef
>> BCMA_* or SSB_* and if does not have to include linux/ssb/ssb.h or
>> linu/bcma/bcma.h, like I did this with the watchdog driver
>> include/linux/bcm47xx_wdt.h
>
> OK, I've analyzed your bcm47xx_wdt. I can see you abstract bus here
> and implement some simple ops.
>
> We could add similar extra layer for sflash, but I wonder what we
> could put in that. For full sflash support we need 2 things:
> 1) Hardware info (u32 window, u32 blocksize, u16 numblocks)
> 2) Chipcommon access (read32, write32)
>
> In total that are only ~5 fields in some struct. I wonder if it makes
> sense to move that abstracting code to an extra layer? Maybe we can
> just do that in bcm47xxsflash with few ifdefs?

Hm, the advantage is that we could fill that struct directly instead
copying values in bcm47xxsflash probe function. Still not sure which
path to follow.

-- 
Rafał
