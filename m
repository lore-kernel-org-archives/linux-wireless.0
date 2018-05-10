Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:38804 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965049AbeEJQHL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 12:07:11 -0400
Subject: Re: [PATCH 4.17 2/2] ssb: make SSB_PCICORE_HOSTMODE depend on SSB = y
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Matt Redfearn <matt.redfearn@mips.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180510111401.1161-1-zajec5@gmail.com>
 <20180510111401.1161-2-zajec5@gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <ff18cb0a-e878-dff4-777b-134f0f3fe2e5@lwfinger.net> (sfid-20180510_180726_248145_A89163FC)
Date: Thu, 10 May 2018 11:07:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180510111401.1161-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2018 06:14 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> SSB_PCICORE_HOSTMODE protects MIPS specific code that calls not exported
> symbols pcibios_enable_device and register_pci_controller. This code is
> supposed to be compiled only with ssb builtin.
> 
> This fixes:
> ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
> ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

This patch needs a "Reported-by: Matt Redfearn <matt.redfearn@mips.com>".

Applying both patches leads to a correct configuration for PCI. I cannot test on 
my present hardware, but the patches seem to be correct.

Reviewed-by: Larry Finger <Larry.Finger@lwfinger.net>

@Kalle: Please drop my patch from yesterday. This solution is much better.

Larry

> ---
>   drivers/ssb/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index b3f5cae98ea6..c574dd210500 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -131,7 +131,7 @@ config SSB_DRIVER_PCICORE
>   
>   config SSB_PCICORE_HOSTMODE
>   	bool "Hostmode support for SSB PCI core"
> -	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS
> +	depends on SSB_DRIVER_PCICORE && SSB_DRIVER_MIPS && SSB = y
>   	help
>   	  PCIcore hostmode operation (external PCI bus).
>   
> 
