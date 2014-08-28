Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63824 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaH1QDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 12:03:39 -0400
Received: by mail-ig0-f170.google.com with SMTP id h3so750072igd.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 09:03:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwKheOAogaeeDd5pLNaRo=Zq0euURTT87BY-S1MdOWwVQ@mail.gmail.com>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<2859425.94ptgpItD3@wuerfel>
	<CACna6rx0E_s76wLLkDjj90sXH=Q3yzBemQM5Qrp96QiWCWr0qg@mail.gmail.com>
	<6633831.1CSHMPPLH1@wuerfel>
	<CACna6rwKheOAogaeeDd5pLNaRo=Zq0euURTT87BY-S1MdOWwVQ@mail.gmail.com>
Date: Thu, 28 Aug 2014 18:03:38 +0200
Message-ID: <CACna6ryEp0oFXy0ZOEU0yve8r74qg7cC1GDdFSbarr2qjz5-YA@mail.gmail.com> (sfid-20140828_180341_829888_052C9FAB)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2014 18:00, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 28 August 2014 17:32, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Thursday 28 August 2014 14:37:54 Rafał Miłecki wrote:
>>> To make booting possible, flash content is mapped to the memory. We're
>>> talking about read only access. This mapping allows CPU to get code
>>> (bootloader) and execute it as well as it allows CFE to get NVRAM
>>> content easily. You don't need flash driver (with erasing & writing
>>> support) to read NVRAM.
>>
>> Ok. Just out of curiosity, how does the system manage to map NAND
>> flash into physical address space? Is this a feature of the SoC
>> of the flash chip?
>
> I don't know exactly. Many (all?) device with BCM4706 SoC have two
> flashes. Serial flash (~2 MiB) with bootloader + nvram and NAND flash
> with the firmware. However Netgear WNR3500Lv2 (based on BCM47186B0)
> has only a NAND flash.

Btw. since NAND flashes tend to be huhe, they can't be fully mapped
into memory. This is where Broadcom's "nfl_boot_size" comes in. This
is a function saying how much of NAND content it mapped into memory.
It returns NFL_BOOT_SIZE (0x200000) or NFL_BIG_BOOT_SIZE (0x800000)
depending on the block size.
