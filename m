Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44903 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaH2PVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 11:21:19 -0400
Received: by mail-ie0-f179.google.com with SMTP id tr6so2936672ieb.38
        for <linux-wireless@vger.kernel.org>; Fri, 29 Aug 2014 08:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53FF9D9B.30106@hauke-m.de>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<3921668.sgOLRYjGUr@wuerfel>
	<CACna6rwnz0TGZ8QgW39o4MPfXTp1a1h8naDJqEGVV4UqtkgaWw@mail.gmail.com>
	<2859425.94ptgpItD3@wuerfel>
	<53FF9D9B.30106@hauke-m.de>
Date: Fri, 29 Aug 2014 17:21:18 +0200
Message-ID: <CACna6rzaXHww2UXoP4Fi-zA3uNve4NQ48DeChF8zoBS-_-mtyw@mail.gmail.com> (sfid-20140829_172122_818611_2754A01B)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 23:22, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/28/2014 01:56 PM, Arnd Bergmann wrote:
>> On Thursday 28 August 2014 13:39:55 Rafał Miłecki wrote:
>>> Well, that depends. Hauke was planning to put info about flash in DT.
>>>> I think it would make sense to have a common driver that has both
>>>> an 'early' init part used by MIPS and a regular init part used by
>>>> ARM and potentially also on MIPS if we want. Most of the code can
>>>> still be shared.
>>>
>>> OK, now it's clear what you meant.
>>> The thing is that we may want to call probe function from
>>> drivers/bcma/main.c. I think we never meant to call it directly from
>>> arch code. This code in drivers/bcma/main.c is used on both: MIPS and
>>> ARM. So I wonder if there is much sense in doing it like
>>> #ifdev MIPS
>>> bcm47xx_nvram_init(nvram_address);
>>> #endif
>>> #ifdef ARM
>>> nvram_device.resource[0].start = nvram_address;
>>> platform_device_register(nvram_device);
>>> #endif
>>>
>>> What do you think about this?
>>
>> I definitely don't want to see any manual platform_device_register()
>> calls on ARM, any device should be either a platform_device probed
>> from DT, or a bcma_device that comes from the bcma bus.
>>
>> I suspect I'm still missing part of the story here. How is the
>> nvram chip actually connected?
>
> I think we have to provide an own device tree for every board, like it
> is done for other arm boards. If we do so I do not see a problem to
> specify the nvram address space in device tree.

Alright, I think we should try to answer one main question at this
point: how much data we want to put in DTS? It's still not clear to
me.

What about this flash memory mapping? You added this in your RFC:
reg = <0x1c000000 0x01000000>;

As I described, the first part (address 0x1c000000) could be extracted
on runtime. For that you need my patch:
[PATCH] bcma: get & store info about flash type SoC booted from
http://www.spinics.net/lists/linux-wireless/msg126163.html

And then add some simple "swtich" like:
switch (boot_device) {
case BCMA_BOOT_DEV_NAND:
    nvram_address = 0x1c000000;
    break;
case BCMA_BOOT_DEV_SERIAL:
    nvram_address = 0x1e000000;
    break;
}

So... should we handle it on runtime? Or do we really want this in DTS?
I was thinking about doing this on runtime. This would limit amount of
DTS entries and this is what makes more sense to me. The same way
don't hardcode many other hardware details. For example we don't store
flash size, block size, erase size in DTS. We simply use JEDEC and
mtd's spi-nor framework database.

-- 
Rafał
