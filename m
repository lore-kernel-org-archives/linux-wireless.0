Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966621AbeCAKqC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:46:02 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Matt Redfearn <matt.redfearn@mips.com>
Cc: <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <jhogan@kernel.org>
Subject: Re: [PATCH v2] bcma: Prevent build of PCI host features in module
References: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com>
Date: Thu, 01 Mar 2018 12:45:57 +0200
In-Reply-To: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com> (Matt
        Redfearn's message of "Thu, 1 Mar 2018 09:58:12 +0000")
Message-ID: <87lgfcnkey.fsf@kamboji.qca.qualcomm.com> (sfid-20180301_114608_394202_566D779C)
MIME-Version: 1.0
Content-Type: text/plain
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
> Changes in v2:
> Rebase on v4.16-rc1
>
>  drivers/bcma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index ba8acca036df..cb0f1aad20b7 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
>  
>  config BCMA_DRIVER_PCI_HOSTMODE
>  	bool "Driver for PCI core working in hostmode"
> -	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
> +	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY && BCMA = y

Due to the recent regression in bcma I would prefer extra careful review
before I apply this. So does this look ok to everyone?

-- 
Kalle Valo
