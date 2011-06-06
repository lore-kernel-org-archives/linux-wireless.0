Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60056 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab1FFWNH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 18:13:07 -0400
Message-ID: <4DED50EC.3040401@hauke-m.de> (sfid-20110607_001311_554605_4E215766)
Date: Tue, 07 Jun 2011 00:13:00 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
	mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com
Subject: Re: [RFC][PATCH 09/10] bcm47xx: add support for bcma bus
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>	<1307311658-15853-10-git-send-email-hauke@hauke-m.de> <BANLkTi=ybf59NR1NA3TOuamsWzey9zx19A@mail.gmail.com>
In-Reply-To: <BANLkTi=ybf59NR1NA3TOuamsWzey9zx19A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 01:07 PM, Rafał Miłecki wrote:
> 2011/6/6 Hauke Mehrtens <hauke@hauke-m.de>:
>> This patch add support for the bcma bus. Broadcom uses only Mips 74K
>> CPUs on the new SoC and on the old ons using ssb bus there are no Mips
>> 74K CPUs.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  arch/mips/Kconfig                            |    4 +++
>>  arch/mips/bcm47xx/gpio.c                     |    9 ++++++++
>>  arch/mips/bcm47xx/nvram.c                    |    6 +++++
>>  arch/mips/bcm47xx/serial.c                   |   24 +++++++++++++++++++++++
>>  arch/mips/bcm47xx/setup.c                    |   27 ++++++++++++++++++++++++-
>>  arch/mips/bcm47xx/time.c                     |    3 ++
>>  arch/mips/include/asm/mach-bcm47xx/bcm47xx.h |    3 ++
>>  arch/mips/include/asm/mach-bcm47xx/gpio.h    |   18 +++++++++++++++++
>>  drivers/watchdog/bcm47xx_wdt.c               |    6 +++++
>>  9 files changed, 98 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> index 653da62..bdb0341 100644
>> --- a/arch/mips/Kconfig
>> +++ b/arch/mips/Kconfig
>> @@ -100,6 +100,10 @@ config BCM47XX
>>        select SSB_EMBEDDED
>>        select SSB_B43_PCI_BRIDGE if PCI
>>        select SSB_PCICORE_HOSTMODE if PCI
>> +       select BCMA
>> +       select BCMA_HOST_EMBEDDED
>> +       select BCMA_DRIVER_MIPS
>> +       select BCMA_PCICORE_HOSTMODE
> 
> I'm not involved in development for embedded devices but I believe
> that space is quite important for them.
> 
> You force compiling both: ssb and bcma for every device using bcm47xx.
> I think ppl may want to compile only one bus driver.
> 
Yes that has to be improved as there should also be an option to use the
compiler optimazions for the new MIPS 74K CPU core.

Hauke
