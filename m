Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33895 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751321AbeANVkw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Jan 2018 16:40:52 -0500
Subject: Re: [PATCH] bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        James Hogan <jhogan@kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <db5915ed-fc50-292f-c86b-4da7f3f0eddd@roeck-us.net> (sfid-20180114_224121_724805_6481C179)
Date: Sun, 14 Jan 2018 13:40:50 -0800
MIME-Version: 1.0
In-Reply-To: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ copying linux-mips ]

On 01/14/2018 01:34 PM, Guenter Roeck wrote:
> Mips builds with BCMA host mode enabled fail in mainline and -next
> with:
> 
> In file included from include/linux/bcma/bcma.h:10:0,
>                   from drivers/bcma/bcma_private.h:9,
> 		 from drivers/bcma/main.c:8:
> include/linux/bcma/bcma_driver_pci.h:218:24: error:
> 	field 'pci_controller' has incomplete type
> 
> Bisect points to commit d41e6858ba58c ("MIPS: Kconfig: Set default MIPS
> system type as generic") as the culprit. Analysis shows that the commmit
> changes PCI configuration and enables PCI_DRIVERS_GENERIC. This in turn
> disables PCI_DRIVERS_LEGACY. 'struct pci_controller' is, however, only
> defined if PCI_DRIVERS_LEGACY is enabled.
> 
> Ultimately that means that BCMA_DRIVER_PCI_HOSTMODE depends on
> PCI_DRIVERS_LEGACY. Add the missing dependency.
> 
> Fixes: d41e6858ba58c ("MIPS: Kconfig: Set default MIPS system type as ...")
> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> Cc: James Hogan <jhogan@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> I am aware that this problem has been reported several times. I have
> not been able to find a fix, but I may have missed it. If so, my
> apologies for the noise.
> 
I should have said "I have not been able to find a patch fixing it".

> Also note that this is not the only fix required; commit d41e6858ba58c,
> as simple as it looks like, does a pretty good job messing up
> "mips:allmodconfig" builds.
> 
... nor did I find patch(es) fixing the other build problem(s) introduced
by d41e6858ba58c.

Guenter

>   drivers/bcma/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 02d78f6cecbb..ba8acca036df 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>   
>   config BCMA_DRIVER_PCI_HOSTMODE
>   	bool "Driver for PCI core working in hostmode"
> -	depends on MIPS && BCMA_DRIVER_PCI
> +	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
>   	help
>   	  PCI core hostmode operation (external PCI bus).
>   
> 
