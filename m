Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41320 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaIAHst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:48:49 -0400
Received: by mail-ie0-f171.google.com with SMTP id rp18so5717595iec.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 00:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6rwmNtS1JSi=VHXWHu6mOM72Y8sBrr5EqCRbpYUHFrMnCg@mail.gmail.com>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<53FF9D9B.30106@hauke-m.de>
	<CACna6rzaXHww2UXoP4Fi-zA3uNve4NQ48DeChF8zoBS-_-mtyw@mail.gmail.com>
	<5882203.GXbhhcHqjK@wuerfel>
	<CACna6rwmNtS1JSi=VHXWHu6mOM72Y8sBrr5EqCRbpYUHFrMnCg@mail.gmail.com>
Date: Mon, 1 Sep 2014 09:48:48 +0200
Message-ID: <CACna6rwMovK133ZoFYsLcsnH39umU7=UAoyG6jmgM8ZVq0AYRA@mail.gmail.com> (sfid-20140901_094902_888997_4C13DDEF)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 August 2014 11:20, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 29 August 2014 22:04, Arnd Bergmann <arnd@arndb.de> wrote:
>> You mentioned that the 'boot_device' variable in your code snippet
>> comes from a hardware register that can be accessed easily, right?
>> A possible way to handle it would then be to have two DT entries
>> like
>>
>>         nvram@1c000000 {
>>                 compatible = "bcm,bcm4710-nvram";
>>                 reg = <0x1c000000 0x1000000>;
>>                 bcm,boot-device = BCMA_BOOT_DEV_NAND;
>>         };
>>
>>         nvram@1c000000 {
>>                 compatible = "bcm,bcm4710-nvram";
>>                 reg = <0x1e000000 0x1000000>;
>>                 bcm,boot-device = BCMA_BOOT_DEV_SERIAL;
>>         };
>
> This sounds like a nice consensus for me! Actually it seems to be
> similar to what we already do for other hardware parts.
>
> E.g. in bcm4708.dtsi Hauke put registers location of 4 Ethernet cores
> (gmac@0, gmac@1, gmac@2, gmac@3). I believe this board is ready for 4
> Ethernet cores so DT matches hardware capabilities. Then most vendors
> use/activate only one (maybe up to 2?) Ethernet cores. It's up to the
> driver to detect if core is activated/used.
>
> AFAIU having two flash mappings (as suggested above) would follow this
> logic. It would match hardware capabilities. And then it would be up
> to driver to detect which one mapping is really in use for this
> particular board.
>
> Does it make sense?

I've just realized something. When Broadcom's code reads NVRAM content
it uses "hndnand_checkbadb" to skip bad blocks. It seems NVRAM doesn't
lay in 100% reliable flash sectors.

Above function comes from shared/ which (the directory) provides tons
of low level stuff without using any kernel API. OFC it won't be
acceptable for us to implement low level NAND stuff in the nvram
driver (this would mean duplicating NAND driver code). It seems we
won't be able to use NAND flash mapping to the memory (this magic
0x1c000000) at all...

So I think we'll need to change our vision of flash access in
bcm74xx_nvram driver. I guess we will have to:
1) Register NAND core early
2) Initialize NAND driver
3) Use mtd/nand API in bcm47xx_nvram

-- 
Rafał
