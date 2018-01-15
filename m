Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.210]:48222 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeAOLST (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 06:18:19 -0500
Subject: Re: [PATCH] bcma: Prevent build of PCI host features in module
To: Kalle Valo <kvalo@codeaurora.org>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Guenter Roeck" <linux@roeck-us.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
References: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com>
 <87zi5f1lm0.fsf@purkki.adurom.net>
From: Matt Redfearn <matt.redfearn@mips.com>
Message-ID: <85b96369-ebd6-1f04-13c2-1757ac716723@mips.com> (sfid-20180115_121837_612925_09125BFA)
Date: Mon, 15 Jan 2018 11:16:57 +0000
MIME-Version: 1.0
In-Reply-To: <87zi5f1lm0.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 15/01/18 10:07, Kalle Valo wrote:
> Matt Redfearn <matt.redfearn@mips.com> writes:
> 
>> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
>> a build error due to use of symbols not exported from vmlinux:
>>
>> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
>> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
>> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>>
>> To prevent this, don't allow the host mode feature to be built if
>> CONFIG_BCMA=m
>>
>> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>>
>> ---
>>
>>   drivers/bcma/Kconfig | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
>> index 02d78f6cecbb..4294784b9cf1 100644
>> --- a/drivers/bcma/Kconfig
>> +++ b/drivers/bcma/Kconfig
>> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>>   
>>   config BCMA_DRIVER_PCI_HOSTMODE
>>   	bool "Driver for PCI core working in hostmode"
>> -	depends on MIPS && BCMA_DRIVER_PCI
>> +	depends on MIPS && BCMA_DRIVER_PCI && BCMA = y
> 
> Is this a new regression? Do you know the commit which broke this?

As far as I can see, pcibios_enable_device and register_pci_controller 
have never being exported symbols from vmlinux, and an allmodconfig 
build with CONFIG_MIPS_COBALT=y (MIPS cobalt platform) which attempts to 
put this this functionality into a module would never have linked 
successfully. As such it can be traced back to when this functionality 
was added, 49dc9577155576b10ff79f0c1486c816b01f58bf ("bcma: add PCIe 
host controller").

> 
> Is it somehow related to this:
> 
> bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
> https://patchwork.kernel.org/patch/10162839/
> 
> Or are these two separate issues?
> 

Separate issues - that one fixes allmodconfig when CONFIG_MIPS_GENERIC=y 
(MIPS generic platform) which does not define the struct pci_controller 
- that error was really introduced when that struct definition was 
removed for the generic platform by 
c5611df968047fb0b38156497b4242730ef66108 ("MIPS: PCI: Introduce 
CONFIG_PCI_DRIVERS_LEGACY").

I think both patches are valid since they fix errors building 
allmodconfig on 2 separate MIPS platforms.

Thanks,
Matt
