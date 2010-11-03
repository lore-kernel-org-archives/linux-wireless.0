Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:59932 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab0KCLqo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 07:46:44 -0400
Message-ID: <4CD14B9D.1070305@ti.com>
Date: Wed, 03 Nov 2010 13:46:37 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Luciano Coelho <luciano.coelho@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wl1271: Change wl12xx Files Names
References: <1288505649-28733-1-git-send-email-shahar_levi@ti.com> <1288772739.1164.10.camel@chilepepper>
In-Reply-To: <1288772739.1164.10.camel@chilepepper>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2010 10:25 AM, Luciano Coelho wrote:
> On Sun, 2010-10-31 at 07:14 +0100, ext Shahar Levi wrote:
>> All files name prefix removed due to the fuct that wl12xx driver supports
>> wl1271 and wl1273.
>> Also the definition in Kconfig and header files changed respectively.
>>
>> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
>> ---
>
> Some more comments.
Hi,

>> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
>> index 1b3b7bd..6941618 100644
>> --- a/drivers/net/wireless/wl12xx/Kconfig
>> +++ b/drivers/net/wireless/wl12xx/Kconfig
>> @@ -1,56 +1,57 @@
>> -menuconfig WL12XX
>> +menuconfig WL12XX_MENU
>
> Actually we don't have WL1251 here anymore, so maybe this could be
> removed instead? But that can go in a separate patch.
OK, i will implement separate patch after that one will apply.

>> -config WL1271_SPI
>> -       tristate "TI wl1271 SPI support"
>> -       depends on WL1271&&  SPI_MASTER
>> +config WL12XX_SPI
>> +       tristate "TI wl12xx SPI support"
>> +       depends on WL12XX&&  SPI_MASTER
>>          ---help---
>>            This module adds support for the SPI interface of adapters using
>> -         TI wl1271 chipset.  Select this if your platform is using
>> -         the SPI bus.
>> +         TI wl12xx chipsets.  Select this if your platform is using
>> +         the wl12xx_spi bus.
>
> Change wl12xx_spi bus back to SPI bus.
Will be fix on v3.

>> -         If you choose to build a module, it'll be called wl1251_spi.
>> +         If you choose to build a module, it'll be called spi.
>
> "it will be called wl1271_spi".
Will be fix on v3.

>> -config WL1271_SDIO
>> -       tristate "TI wl1271 SDIO support"
>> -       depends on WL1271&&  MMC
>> +config WL12XX_SDIO
>> +       tristate "TI wl12xx SDIO support"
>> +       depends on WL12XX&&  MMC
>>          ---help---
>>            This module adds support for the SDIO interface of adapters using
>> -         TI wl1271 chipset.  Select this if your platform is using
>> -         the SDIO bus.
>> +         TI wl12xx chipsets.  Select this if your platform is using
>> +         the wl12xx_sdio bus.
>
> Change back to SDIO bus.
Will be fix on v3.

>> -         If you choose to build a module, it'll be called
>> -         wl1271_sdio. Say N if unsure.
>> +         If you choose to build a module, it'll be called sdio.
>> +         Say N if unsure.
>
> "it will be called wl12xx_sdio".
Will be fix on v3.

> I'm also getting two checkpatch warnings:
>
> WARNING: please, no space for starting a line,
> 				excluding comments
> #669: FILE: drivers/net/wireless/wl12xx/main.c:2227:
> +       .ht_cap = WL12XX_HT_CAP,$
This is weird. In order to find those warning i ran:
"./scripts/checkpatch.pl 
wl12xx-files-prefix-v2/0001-wl1271-Change-wl12xx-Files-Names.patch
total: 0 errors, 0 warnings, 598 lines checked

wl12xx-files-prefix-v2/0001-wl1271-Change-wl12xx-Files-Names.patch has 
no obvious style problems and is ready for submission."

On that patch it didn't find warning.
Is there more efficient way to validate those issue?

> WARNING: please, no space for starting a line,
> 				excluding comments
> #678: FILE: drivers/net/wireless/wl12xx/main.c:2342:
> +       .ht_cap = WL12XX_HT_CAP,$
the same as above

> And due to other changes in the code, this patch doesn't apply cleanly
> anymore.  Can you please rebase it on the latest wl12xx code?
No problem, i will rebase  it to latest.

I greatly appreciate your review and help.
Shahar



