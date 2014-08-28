Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36878 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaH1Mhz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 08:37:55 -0400
Received: by mail-ig0-f177.google.com with SMTP id r10so805736igi.4
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 05:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2859425.94ptgpItD3@wuerfel>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<3921668.sgOLRYjGUr@wuerfel>
	<CACna6rwnz0TGZ8QgW39o4MPfXTp1a1h8naDJqEGVV4UqtkgaWw@mail.gmail.com>
	<2859425.94ptgpItD3@wuerfel>
Date: Thu, 28 Aug 2014 14:37:54 +0200
Message-ID: <CACna6rx0E_s76wLLkDjj90sXH=Q3yzBemQM5Qrp96QiWCWr0qg@mail.gmail.com> (sfid-20140828_143758_682690_C214F76A)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 13:56, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 28 August 2014 13:39:55 Rafał Miłecki wrote:
>> On 28 August 2014 13:02, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Thursday 28 August 2014 12:47:29 Rafał Miłecki wrote:
>> >> On 28 August 2014 12:13, Arnd Bergmann <arnd@arndb.de> wrote:
>> >> > My impression is that all the information that you need in these early
>> >> > three steps is stuff that is already meant to be part of DT.
>> >> > This isn't surprising, because the bcm47xx serves a similar purpose
>> >> > to DT, it's just more specialized.
>> >> >
>> >> > This duplication is a bit unfortunate, but it seems that just using
>> >> > the respective information from DT would be easier here.
>> >> >
>> >> > Is any of the information you need early dynamic? It sounds that
>> >> > for a given SoC, it should never change and can just be statically
>> >> > encoded in DT.
>> >>
>> >> I'm not sure which info you exactly are talking about. I believe one
>> >> SoC model always use the same CPU, ChipCommon, embedded wireless and
>> >> PCIe + USB controllers. However amount of RAM, type of flash (serial
>> >> vs. NAND), size of flash, booting method, NVRAM location, etc. all
>> >> depend on vendor's choice. I think CPU speed could also depend on
>> >> vendor choice.
>> >
>> > But those would also be present in DT on ARM, right?
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

NVRAM is basically just a partition on flash, however there are few
tricks applying to it.

To make booting possible, flash content is mapped to the memory. We're
talking about read only access. This mapping allows CPU to get code
(bootloader) and execute it as well as it allows CFE to get NVRAM
content easily. You don't need flash driver (with erasing & writing
support) to read NVRAM.
Depending on the boot flash device, content of flash is mapped at
different offsets:
1) MIPS serial flash: SI_FLASH2 (0x1c000000)
2) MIPS NAND flash: SI_FLASH1 (0x1fc00000)
3) ARM serial flash: SI_NS_NORFLASH (0x1e000000)
4) ARM NAND flash: SI_NS_NANDFLASH (0x1c000000)

So on my ARM device with serial flash (connected over SPI) I was able
to get NVRAM header this way:

void __iomem *iobase = ioremap_nocache(0x1e000000, 0x1000000);
u8 *buf;

buf = (u8 *)(iobase + 0xff0000);
pr_info("[NVRAM] %02X %02X %02X %02X\n", buf[0], buf[1], buf[2], buf[3]);

This resulted in:
[NVRAM] 46 4C 53 48

(I hardcoded 0xff0000 above, normally you would need to try 0x10000,
0x20000, 0x30000 and so on...).
