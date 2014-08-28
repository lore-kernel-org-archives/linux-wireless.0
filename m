Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:47878 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaH1VWi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 17:22:38 -0400
Message-ID: <53FF9D9B.30106@hauke-m.de> (sfid-20140828_232241_483624_7033BD1D)
Date: Thu, 28 Aug 2014 23:22:35 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com> <3921668.sgOLRYjGUr@wuerfel> <CACna6rwnz0TGZ8QgW39o4MPfXTp1a1h8naDJqEGVV4UqtkgaWw@mail.gmail.com> <2859425.94ptgpItD3@wuerfel>
In-Reply-To: <2859425.94ptgpItD3@wuerfel>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/2014 01:56 PM, Arnd Bergmann wrote:
> On Thursday 28 August 2014 13:39:55 Rafał Miłecki wrote:
>> On 28 August 2014 13:02, Arnd Bergmann <arnd@arndb.de> wrote:
>>> On Thursday 28 August 2014 12:47:29 Rafał Miłecki wrote:
>>>> On 28 August 2014 12:13, Arnd Bergmann <arnd@arndb.de> wrote:
>>>>> My impression is that all the information that you need in these early
>>>>> three steps is stuff that is already meant to be part of DT.
>>>>> This isn't surprising, because the bcm47xx serves a similar purpose
>>>>> to DT, it's just more specialized.
>>>>>
>>>>> This duplication is a bit unfortunate, but it seems that just using
>>>>> the respective information from DT would be easier here.
>>>>>
>>>>> Is any of the information you need early dynamic? It sounds that
>>>>> for a given SoC, it should never change and can just be statically
>>>>> encoded in DT.
>>>>
>>>> I'm not sure which info you exactly are talking about. I believe one
>>>> SoC model always use the same CPU, ChipCommon, embedded wireless and
>>>> PCIe + USB controllers. However amount of RAM, type of flash (serial
>>>> vs. NAND), size of flash, booting method, NVRAM location, etc. all
>>>> depend on vendor's choice. I think CPU speed could also depend on
>>>> vendor choice.
>>>
>>> But those would also be present in DT on ARM, right?
>>
>> Well, that depends. Hauke was planning to put info about flash in DT.
>> Me on the other hand suggested reading info about flash from the
>> board. See my reply:
>> https://www.mail-archive.com/devicetree@vger.kernel.org/msg39365.html
>>
>> My plan was to use patch like
>> [PATCH] bcma: get & store info about flash type SoC booted from
>> http://www.spinics.net/lists/linux-wireless/msg126163.html
>> (it would work on both: MIPS and ARM)
>> and then:
>>
>> switch (boot_device) {
>> case BCMA_BOOT_DEV_NAND:
>>     nvram_address = 0x1000dead;
>>     break;
>> case BCMA_BOOT_DEV_SERIAL:
>>     nvram_address = 0x1000c0de;
>>     break;
>> }
>>
> 
> I don't understand. Why does the nvram address depend on the boot
> device?
> 
>>>> Can you see any solution for making NVRAM support a standard platform
>>>> driver on MIPS and ARM? As I said, on MIPS we need access to the NVRAM
>>>> really early, before platform devices/drivers can operate.
>>>
>>> I think it would make sense to have a common driver that has both
>>> an 'early' init part used by MIPS and a regular init part used by
>>> ARM and potentially also on MIPS if we want. Most of the code can
>>> still be shared.
>>
>> OK, now it's clear what you meant.
>> The thing is that we may want to call probe function from
>> drivers/bcma/main.c. I think we never meant to call it directly from
>> arch code. This code in drivers/bcma/main.c is used on both: MIPS and
>> ARM. So I wonder if there is much sense in doing it like
>> #ifdev MIPS
>> bcm47xx_nvram_init(nvram_address);
>> #endif
>> #ifdef ARM
>> nvram_device.resource[0].start = nvram_address;
>> platform_device_register(nvram_device);
>> #endif
>>
>> What do you think about this?
> 
> I definitely don't want to see any manual platform_device_register()
> calls on ARM, any device should be either a platform_device probed
> from DT, or a bcma_device that comes from the bcma bus.
> 
> I suspect I'm still missing part of the story here. How is the
> nvram chip actually connected?

I think we have to provide an own device tree for every board, like it
is done for other arm boards. If we do so I do not see a problem to
specify the nvram address space in device tree.  I do not think the arm
guys do like some board files containing the gpio numbers of the leds
and buttons found on the board.

For the MIPS version of BCM47xx we are able to automatically detect
mostly everything, just for the gpio configuration we try to guess the
board name based on nvram content and then configure the gpios.

The ARM BCM47xx contains a standard ARM with GIC and other standard arm
things just the flash, Ethernet, PCIe, USB controller and their
interconnection are Braodcom specific.

My plan was to provide a nvram and sprom driver which registers as a
normal platform device and supports device tree, like the one I posted
and it would also be possible to call the function with the address of
the flash directly, this function would be used for MIPS, this way we
can share the code and do not have to change the mips stuff so much.

For ARM BCM47xx we do not need bcma at all to boot the device, so it
should also work when bcma is build as a module, this is different to
MIPS. The ARM BCM47xx code currently in mainline Linux boots for me into
user space with an initramfs, it just misses many parts like Ethernet,
flash PCIe, ...

The address of the console is already hard coded in device tree. It
would also be possible to automatically detect their address based on
some description in the AIX bus (bcma), but I think hard coding the
address in device tree is easier.

Hauke
