Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932121AbeAOKHX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 05:07:23 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcma: Prevent build of PCI host features in module
References: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com>
Date: Mon, 15 Jan 2018 12:07:19 +0200
In-Reply-To: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com> (Matt
        Redfearn's message of "Fri, 12 Jan 2018 14:25:18 +0000")
Message-ID: <87zi5f1lm0.fsf@purkki.adurom.net> (sfid-20180115_110739_239413_460FE087)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matt Redfearn <matt.redfearn@mips.com> writes:

> Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
> a build error due to use of symbols not exported from vmlinux:
>
> ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
> ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1
>
> To prevent this, don't allow the host mode feature to be built if
> CONFIG_BCMA=m
>
> Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
>
> ---
>
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index 02d78f6cecbb..4294784b9cf1 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>  
>  config BCMA_DRIVER_PCI_HOSTMODE
>  	bool "Driver for PCI core working in hostmode"
> -	depends on MIPS && BCMA_DRIVER_PCI
> +	depends on MIPS && BCMA_DRIVER_PCI && BCMA = y

Is this a new regression? Do you know the commit which broke this? 

Is it somehow related to this:

bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
https://patchwork.kernel.org/patch/10162839/

Or are these two separate issues?

-- 
Kalle Valo
