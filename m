Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40831 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3A1UPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 15:15:11 -0500
Message-ID: <5106DC46.5030809@hauke-m.de> (sfid-20130128_211515_483924_E3474E93)
Date: Mon, 28 Jan 2013 21:15:02 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Jonas Gorski <jonas.gorski@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	linux-wireless@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: Handling serial flashes on Broadcom SOCs
References: <CACna6ry0xPuzEAcDRB=hrTT71A5+WoJTZMGwaUS3RjSE4CcgLw@mail.gmail.com>
In-Reply-To: <CACna6ry0xPuzEAcDRB=hrTT71A5+WoJTZMGwaUS3RjSE4CcgLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2013 12:37 PM, Rafał Miłecki wrote:
> Broadcom SOCs have flash memories, some of them are serial flashes.
> They are detected by ssb/bcma and need to be handled by some extra
> drivers.
> 
> Access to that flash memories is specific to the Broadcom devices.
> Reading is simple, as they are memory mapped. Writing is done with the
> ChipCommon (bus device/core) registers.
> 
> The initial idea was to register platform device in ssb/bcma and then
> access it in a separated driver placed in the mtd tree. However at
> some point it was noticed (by Paul?) that (some of?) the chipsets
> available at ssb/bcma buses are known from other devices. They are
> usually available over SPI bus, and there are available drivers for
> them. An example can be m25p80.c.
> 
> I can't say yet how much m25p80.c is compatible with chipsets on
> Broadcom devices. Not all of them are available in m25p80.c, I'm
> especially worried about Atmel flashes. There is only one Atmel entry
> in m25p80.c and according to the SSB/BCMA code that devices require
> different programming way.
> 
> I don't think extending m25p80.c to support SSB/BCMA is acceptable, so
> we've two options now:
> 
> 1) Just implement serial flashes support in separated driver operating
> on ssb/bcma buses.
> Easy to do, but requires some code duplication with m25p80.c
> 
> 2) Fake SPI master in ssb & bcma and use m25p80.c
> I think it's much more complicated, as there probably isn't any real
> SPI on Broadcom devices. We have to fake/emulate it's operations. From
> early overview, some words-tips are: struct spi_master,
> spi_alloc_master, spi_register_master.
> I also don't know well m25p80.c is going to support chipsets on
> Broadcom devices. With some luck, we will have to extend it's database
> only. But it may happen we will have to add some/many modifications in
> m25p80.c as well.
> Another problem is early flash access. To boot properly we need to
> access serial flash very early to read NVRAM from it (plain text
> partition with board settings). This may be required even before we
> get "alloc" available, which may require additional extra hacks in
> m25p80.c.
> 
> Personally I'm for the first option. It's much simpler, doesn't
> require a lot of research (how to correctly emulate SPI calls?). I'm
> also afraid that emulating SPI bus and adding extra hacks into
> m25p80.c will require more code than simple duplication in a ssb/bcma
> focused driver. I also can't predict how well serial flash will behave
> in case of accessing it over emulated SPI. Is this going to be working
> correct? Is this going to be slower/faster?
> 
> I wish we discuss this situation and take a one solid decision. I'm
> afraid of second solution, but maybe someone of you sees additional
> advantages and/or has some experience in that matter.
> 

I just had a quick look into the m25p80 driver, but emulating a spi
controller does not sounds easy to me and m25p80 still has to be
extended. The current code used in OpenWrt with kernel 2.6 supports all
serial flash chip connected to these SoC I have see I would also go with
duplicating some code and writing an own driver.

This driver should be written to support the serial flash chips found on
SoCs using ssb and bcma and it should share more code than the current
implementation used in OpenWrt with kernel 3.6.

Hauke
