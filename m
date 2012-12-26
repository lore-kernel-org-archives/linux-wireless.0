Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42729 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754232Ab2LZK75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2012 05:59:57 -0500
Message-ID: <50DAD8A6.8050405@hauke-m.de> (sfid-20121226_120000_250120_4FC93244)
Date: Wed, 26 Dec 2012 11:59:50 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][PATCH] ssb: add place for serial flash driver
References: <1356459816-2214-1-git-send-email-zajec5@gmail.com> <50DAD374.1090305@hauke-m.de> <CACna6rw00D+pVHPoYPgN9OoiQpHGumTw7oCXSmj+ECsqTVzR9Q@mail.gmail.com>
In-Reply-To: <CACna6rw00D+pVHPoYPgN9OoiQpHGumTw7oCXSmj+ECsqTVzR9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/26/2012 11:46 AM, Rafał Miłecki wrote:
> 2012/12/26 Hauke Mehrtens <hauke@hauke-m.de>:
>> On 12/25/2012 07:23 PM, Rafał Miłecki wrote:
>>> +#ifdef CONFIG_SSB_SFLASH
>>> +struct ssb_sflash {
>>> +     bool present;
>>> +};
>>> +#endif
>>
>> I assume you want to share some of the code for the serial flash driver
>> between bcma and ssb. You should create a file with the structure in
>> include/linux/platform_data/ and share that between bcma and ssb.
> 
> It's a small struct having about 5 trivial fields. We don't share
> sturcts for any other drivers (chipcommon/mips/pcie) so I think they
> should stay separated here as well.

When this structure is just used in ssb or bcma and in the nvram code of
arch/mips/bcm47x I would also prefer two structures one for bcma and one
for ssb.

> Plus the mtd driver will have to implement bus abstraction anyway.

If you have a structure describing the needs of the serial flash driver
in drivers/mtd/ you could write the flash driver without any ifdef
BCMA_* or SSB_* and if does not have to include linux/ssb/ssb.h or
linu/bcma/bcma.h, like I did this with the watchdog driver
include/linux/bcm47xx_wdt.h

Hauke
