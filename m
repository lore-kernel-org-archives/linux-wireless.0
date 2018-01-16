Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37324 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750823AbeAPTPg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 14:15:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        James Hogan <jhogan@kernel.org>
Message-Id: <20180116191536.7CF82602BA@smtp.codeaurora.org> (sfid-20180116_201553_785117_BD97D221)
Date: Tue, 16 Jan 2018 19:15:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guenter Roeck <linux@roeck-us.net> wrote:

> Mips builds with BCMA host mode enabled fail in mainline and -next
> with:
> 
> In file included from include/linux/bcma/bcma.h:10:0,
>                  from drivers/bcma/bcma_private.h:9,
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
> Reviewed-by: James Hogan <jhogan@kernel.org>

Patch applied to wireless-drivers.git, thanks.

664eadd6f44b bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets

-- 
https://patchwork.kernel.org/patch/10162839/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
