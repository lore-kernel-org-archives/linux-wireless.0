Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932931AbeAOKDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 05:03:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        James Hogan <jhogan@kernel.org>
Subject: Re: [PATCH] bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
Date: Mon, 15 Jan 2018 12:03:36 +0200
In-Reply-To: <1515965642-16259-1-git-send-email-linux@roeck-us.net> (Guenter
        Roeck's message of "Sun, 14 Jan 2018 13:34:02 -0800")
Message-ID: <874lnn30cn.fsf@purkki.adurom.net> (sfid-20180115_110358_195749_EDD07A4B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guenter Roeck <linux@roeck-us.net> writes:

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

So the first release for this commit was v4.15-rc1 so this is a recent
regression.

> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> Cc: James Hogan <jhogan@kernel.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> I am aware that this problem has been reported several times. I have
> not been able to find a fix, but I may have missed it. If so, my
> apologies for the noise.

As this fixes a build problem I'm planning to queue this for v4.15.

-- 
Kalle Valo
