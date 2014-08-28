Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:50477 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaH1Pcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 11:32:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
Date: Thu, 28 Aug 2014 17:32:38 +0200
Message-ID: <6633831.1CSHMPPLH1@wuerfel> (sfid-20140828_173246_691901_0A57C640)
In-Reply-To: <CACna6rx0E_s76wLLkDjj90sXH=Q3yzBemQM5Qrp96QiWCWr0qg@mail.gmail.com>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com> <2859425.94ptgpItD3@wuerfel> <CACna6rx0E_s76wLLkDjj90sXH=Q3yzBemQM5Qrp96QiWCWr0qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2014 14:37:54 Rafał Miłecki wrote:
> On 28 August 2014 13:56, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 28 August 2014 13:39:55 Rafał Miłecki wrote:
> >> switch (boot_device) {
> >> case BCMA_BOOT_DEV_NAND:
> >>     nvram_address = 0x1000dead;
> >>     break;
> >> case BCMA_BOOT_DEV_SERIAL:
> >>     nvram_address = 0x1000c0de;
> >>     break;
> >> }
> >>
> >
> > I don't understand. Why does the nvram address depend on the boot
> > device?
> 
> NVRAM is basically just a partition on flash, however there are few
> tricks applying to it.

Ah, that explains a lot! I was thinking of hardware nvram, which I assume
it was on some early hardware.

> To make booting possible, flash content is mapped to the memory. We're
> talking about read only access. This mapping allows CPU to get code
> (bootloader) and execute it as well as it allows CFE to get NVRAM
> content easily. You don't need flash driver (with erasing & writing
> support) to read NVRAM.

Ok. Just out of curiosity, how does the system manage to map NAND
flash into physical address space? Is this a feature of the SoC
of the flash chip?

I guess for writing you'd still use the full MTD driver, right?

> Depending on the boot flash device, content of flash is mapped at
> different offsets:
> 1) MIPS serial flash: SI_FLASH2 (0x1c000000)
> 2) MIPS NAND flash: SI_FLASH1 (0x1fc00000)
> 3) ARM serial flash: SI_NS_NORFLASH (0x1e000000)
> 4) ARM NAND flash: SI_NS_NANDFLASH (0x1c000000)
> 
> So on my ARM device with serial flash (connected over SPI) I was able
> to get NVRAM header this way:
> 
> void __iomem *iobase = ioremap_nocache(0x1e000000, 0x1000000);
> u8 *buf;
> 
> buf = (u8 *)(iobase + 0xff0000);
> pr_info("[NVRAM] %02X %02X %02X %02X\n", buf[0], buf[1], buf[2], buf[3]);
> 
> This resulted in:
> [NVRAM] 46 4C 53 48
> 
> (I hardcoded 0xff0000 above, normally you would need to try 0x10000,
> 0x20000, 0x30000 and so on...).

Does that mean the entire 0x1e000000-0x1f000000 area is mapped to
the flash and you are looking for the nvram in it, or that you don't
know where it is?

	Arnd
