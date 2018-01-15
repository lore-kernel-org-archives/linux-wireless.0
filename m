Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45176 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAOU62 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 15:58:28 -0500
Subject: Re: [PATCH] bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
To: James Hogan <james.hogan@mips.com>
Cc: Paul Burton <paul.burton@mips.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
 <20180115102336.GC29126@saruman>
 <20180115171053.6nvstoufw4y6ar4s@pburton-laptop>
 <61e41256-f0d3-11f7-06ca-768fab84914d@roeck-us.net>
 <20180115203022.GE5027@jhogan-linux.mipstec.com>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <97487871-c234-4b4c-9b75-52dda484b05a@roeck-us.net> (sfid-20180115_215844_446115_A4FC8632)
Date: Mon, 15 Jan 2018 12:58:20 -0800
MIME-Version: 1.0
In-Reply-To: <20180115203022.GE5027@jhogan-linux.mipstec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2018 12:30 PM, James Hogan wrote:
> On Mon, Jan 15, 2018 at 12:05:48PM -0800, Guenter Roeck wrote:
>> On 01/15/2018 09:10 AM, Paul Burton wrote:
>>> Hello,
>>>
>>> On Mon, Jan 15, 2018 at 10:23:37AM +0000, James Hogan wrote:
>>>> On Sun, Jan 14, 2018 at 01:34:02PM -0800, Guenter Roeck wrote:
>>>>> Mips builds with BCMA host mode enabled fail in mainline and -next
>>>>> with:
>>>>>
>>>>> In file included from include/linux/bcma/bcma.h:10:0,
>>>>>                    from drivers/bcma/bcma_private.h:9,
>>>>> 		 from drivers/bcma/main.c:8:
>>>>> include/linux/bcma/bcma_driver_pci.h:218:24: error:
>>>>> 	field 'pci_controller' has incomplete type
>>>>>
>>>>> Bisect points to commit d41e6858ba58c ("MIPS: Kconfig: Set default MIPS
>>>>> system type as generic") as the culprit. Analysis shows that the commmit
>>>>> changes PCI configuration and enables PCI_DRIVERS_GENERIC. This in turn
>>>>> disables PCI_DRIVERS_LEGACY. 'struct pci_controller' is, however, only
>>>>> defined if PCI_DRIVERS_LEGACY is enabled.
>>>>>
>>>>> Ultimately that means that BCMA_DRIVER_PCI_HOSTMODE depends on
>>>>> PCI_DRIVERS_LEGACY. Add the missing dependency.
>>>>>
>>>>> Fixes: d41e6858ba58c ("MIPS: Kconfig: Set default MIPS system type as ...")
>>>>
>>>> Well, technically I think commit c5611df96804 ("MIPS: PCI: Introduce
>>>> CONFIG_PCI_DRIVERS_LEGACY") is to blame (Cc'ing paul), and the first bad
>>>> commit would be commit eed0eabd12ef ("MIPS: generic: Introduce generic
>>>> DT-based board support") which selects PCI_DRIVERS_GENERIC and is the
>>>> only platform to do so. Both commits were first in v4.9-rc1 and I can
>>>> reproduce this problem at that latter commit with the appropriate
>>>> configuration.
>>>
>>> Ah - yes if I recall correctly my assumption was that the MIPS-specific
>>> struct pci_controller was only used by the MIPS-specific PCI drivers
>>> under arch/mips/pci/, which are only built when configured for the
>>> appropriate platform.
>>>
>>> In this case use of that MIPS-specific struct pci_controller has spread
>>> beyond arch/mips/ & the user can be configured in for platforms other
>>> than the one that will actually use the driver, including the generic
>>> platform which moves towards more generic PCI drivers in
>>> drivers/pci/host/.
>>>
>>>> But yes clearly the mentioned commit does also expose that existing
>>>> problem more widely and to the default allmodconfig, and it looks like a
>>>> reasonable approach for now, so if some mention of the other two commits
>>>> is added:
>>>>
>>>> Reviewed-by: James Hogan <jhogan@kernel.org>
>>>
>>> Likewise, with the "Fixes:" tag fixed:
>>>
>>>       Reviewed-by: Paul Burton <paul.burton@mips.com>
>>>
>>
>> Unfortunately, that alone doesn't fix the problem. SSB driver dependencies
>> are also broken, and in much worse shape. I had to add dependencies in five
>> places to get it to build, and the result is so messy that I won't even try
>> to submit it.
> 
> Oh, thats interesting. When I tried this earlier I just added "&&
> PCI_DRIVERS_LEGACY" to the SSB_PCIHOST_POSSIBLE dependencies, but I was
> waiting for Paul's feedback before submitting a similar patch.
> 

You are right, that is much more straightforward than my attempted fix,
and it works.

> But that wasn't -next, it was mainline + mips fixes branch + individual
> fixes:
> 

Mine is mainline plus "MIPS: Fix CPS SMP NS16550 UART defaults"
which for some reason never made it into mainline. For the nightly builds,
I ended up modifying my buildripts to fix that up manually in the created
configuration file.

>> And if that is fixed, mips:allmodconfig still doesn't build -
>> the next error is an undefined reference to physical_memsize in
>> arch/mips/kernel/vpe-mt.o.
> 
> That one is fairly easy to fix properly, I'll hopefully submit something
> this evening.
> 
>>
>> I wonder if I should just stop trying to build allmodconfig for mips.
>> Any thoughts ?
> 
> With a few fixes applied it should be buildable I think. Sorry its been
> late in the cycle before we've been able to get fixes merged.
> 
Ok, I'll wait a bit longer before giving up on it.

Thanks,
Guenter
