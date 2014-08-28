Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:62074 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1Lj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 07:39:56 -0400
Received: by mail-ig0-f178.google.com with SMTP id hn18so726286igb.17
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 04:39:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3921668.sgOLRYjGUr@wuerfel>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<3222444.6Ji0x5QqTP@wuerfel>
	<CACna6rwO4qOR_pg-aOt87cdb=HfgdeOeMV_KGvsUyR7kDjnKWg@mail.gmail.com>
	<3921668.sgOLRYjGUr@wuerfel>
Date: Thu, 28 Aug 2014 13:39:55 +0200
Message-ID: <CACna6rwnz0TGZ8QgW39o4MPfXTp1a1h8naDJqEGVV4UqtkgaWw@mail.gmail.com> (sfid-20140828_134000_125368_71FF44C2)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 13:02, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 28 August 2014 12:47:29 Rafał Miłecki wrote:
>> On 28 August 2014 12:13, Arnd Bergmann <arnd@arndb.de> wrote:
>> > My impression is that all the information that you need in these early
>> > three steps is stuff that is already meant to be part of DT.
>> > This isn't surprising, because the bcm47xx serves a similar purpose
>> > to DT, it's just more specialized.
>> >
>> > This duplication is a bit unfortunate, but it seems that just using
>> > the respective information from DT would be easier here.
>> >
>> > Is any of the information you need early dynamic? It sounds that
>> > for a given SoC, it should never change and can just be statically
>> > encoded in DT.
>>
>> I'm not sure which info you exactly are talking about. I believe one
>> SoC model always use the same CPU, ChipCommon, embedded wireless and
>> PCIe + USB controllers. However amount of RAM, type of flash (serial
>> vs. NAND), size of flash, booting method, NVRAM location, etc. all
>> depend on vendor's choice. I think CPU speed could also depend on
>> vendor choice.
>
> But those would also be present in DT on ARM, right?

Well, that depends. Hauke was planning to put info about flash in DT.
Me on the other hand suggested reading info about flash from the
board. See my reply:
https://www.mail-archive.com/devicetree@vger.kernel.org/msg39365.html

My plan was to use patch like
[PATCH] bcma: get & store info about flash type SoC booted from
http://www.spinics.net/lists/linux-wireless/msg126163.html
(it would work on both: MIPS and ARM)
and then:

switch (boot_device) {
case BCMA_BOOT_DEV_NAND:
    nvram_address = 0x1000dead;
    break;
case BCMA_BOOT_DEV_SERIAL:
    nvram_address = 0x1000c0de;
    break;
}


>> >> 4) At some point we need to register bcma devices, device_initcall can
>> >> be used for that
>> >>
>> >> As you can see, we need access to the NVRAM quite early (step 3,
>> >> plat_time_init, or even earlier), but device_add (platform
>> >> devices/drivers) is not available then yet. So I'm afraid we won't be
>> >> able to use this common way to write NVRAM driver.
>> >>
>> >>
>> >> So there I want to present my plan for the NVRAM improvements. If you
>> >> don't agree with any part of it, or you can see any better solution,
>> >> please speak up!
>> >>
>> >> 1) I won't make nvram.c a platform driver. Instead I would like to
>> >> make it less bcm47xx specific. I don't want to touch bcm47xx_bus in
>> >> this file. Instead I want to add a generic function that will accept
>> >> address and size of memory where NVRAM should be found. Then I'd like
>> >> to move this file out of "mips" arch (drivers/misc/?
>> >> drivers/bcma/nvram/?) and allow using it for bcm53xx.
>> >
>> > In general, I'd try to avoid adding any platform specific code on ARM
>> > when it needs to run as something other than a device driver.
>> > Moving the code out of arch/mips and making it more generic definitely
>> > sounds good to me, but I'd prefer to have an actual platform_driver
>> > for it.
>>
>> Sure, I didn't want to add NVRAM driver into arch/arm/ :)
>
> What I meant is that I'd prefer to not even call a probe function
> for this driver from arch/arm. I may have misunderstood what you meant
> though.
>
>> Can you see any solution for making NVRAM support a standard platform
>> driver on MIPS and ARM? As I said, on MIPS we need access to the NVRAM
>> really early, before platform devices/drivers can operate.
>
> I think it would make sense to have a common driver that has both
> an 'early' init part used by MIPS and a regular init part used by
> ARM and potentially also on MIPS if we want. Most of the code can
> still be shared.

OK, now it's clear what you meant.
The thing is that we may want to call probe function from
drivers/bcma/main.c. I think we never meant to call it directly from
arch code. This code in drivers/bcma/main.c is used on both: MIPS and
ARM. So I wonder if there is much sense in doing it like
#ifdev MIPS
bcm47xx_nvram_init(nvram_address);
#endif
#ifdef ARM
nvram_device.resource[0].start = nvram_address;
platform_device_register(nvram_device);
#endif

What do you think about this?

-- 
Rafał
