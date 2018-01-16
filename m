Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:38754 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750716AbeAPDLL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 22:11:11 -0500
Received: by mail-pl0-f65.google.com with SMTP id 13so5077572plb.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 19:11:11 -0800 (PST)
Subject: Re: [PATCH for-4.15] ssb: Disable PCI host for PCI_DRIVERS_GENERIC
To: James Hogan <jhogan@kernel.org>, Michael Buesch <m@bues.ch>,
        linux-wireless@vger.kernel.org, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>
References: <20180115211714.24009-1-jhogan@kernel.org>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <3fcbf2f9-bc54-36a6-51ef-26c070c1aa69@roeck-us.net> (sfid-20180116_041115_151283_342979D1)
Date: Mon, 15 Jan 2018 19:11:09 -0800
MIME-Version: 1.0
In-Reply-To: <20180115211714.24009-1-jhogan@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2018 01:17 PM, James Hogan wrote:
> Since commit d41e6858ba58 ("MIPS: Kconfig: Set default MIPS system type
> as generic") changed the default MIPS platform to the "generic"
> platform, which uses PCI_DRIVERS_GENERIC instead of PCI_DRIVERS_LEGACY,
> various files in drivers/ssb/ have failed to build.
> 
> This is particularly due to the existence of struct pci_controller being
> dependent on PCI_DRIVERS_LEGACY since commit c5611df96804 ("MIPS: PCI:
> Introduce CONFIG_PCI_DRIVERS_LEGACY"), so add that dependency to Kconfig
> to prevent these files being built for the "generic" platform including
> all{yes,mod}config builds.
> 
> Fixes: c5611df96804 ("MIPS: PCI: Introduce CONFIG_PCI_DRIVERS_LEGACY")
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-mips@linux-mips.org

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/ssb/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
> index d8e4219c2324..71c73766ee22 100644
> --- a/drivers/ssb/Kconfig
> +++ b/drivers/ssb/Kconfig
> @@ -32,7 +32,7 @@ config SSB_BLOCKIO
>   
>   config SSB_PCIHOST_POSSIBLE
>   	bool
> -	depends on SSB && (PCI = y || PCI = SSB)
> +	depends on SSB && (PCI = y || PCI = SSB) && PCI_DRIVERS_LEGACY
>   	default y
>   
>   config SSB_PCIHOST
> 
