Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58197 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab2CZLbP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 07:31:15 -0400
Message-ID: <4F705371.1020406@hauke-m.de> (sfid-20120326_133118_737149_87AA834D)
Date: Mon, 26 Mar 2012 14:30:57 +0300
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device
References: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 03:02 AM, Paul Gortmaker wrote:
> The following is seen during allmodconfig builds for MIPS:
> 
> drivers/bcma/driver_pci_host.c:518:2: error: implicit declaration
> of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/bcma/driver_pci_host.o] Error 1
> 
> Most likey introduced by commit 49dc9577155576b10ff79f0c1486c816b01f58bf
> 
>     "bcma: add PCIe host controller"
> 
> Add the header instead of implicitly assuming it will be present.
> Sounds like a good idea, but that alone doesn't fix anything.
> 
> The real problem is that the Kconfig has settings related to whether
> PCI is possible, i.e.
> 
>   config BCMA_HOST_PCI_POSSIBLE
>         bool
>         depends on BCMA && PCI = y
>         default y
> 
>   config BCMA_HOST_PCI
>         bool "Support for BCMA on PCI-host bus"
>         depends on BCMA_HOST_PCI_POSSIBLE
> 
> ...but what is missing is that BCMA_DRIVER_PCI_HOSTMODE doesn't
> have any dependencies on the above.  Add one.
> 
> CC: Hauke Mehrtens <hauke@hauke-m.de>
> CC: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index c1172da..fb7c80f 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -29,7 +29,7 @@ config BCMA_HOST_PCI
>  
>  config BCMA_DRIVER_PCI_HOSTMODE
>  	bool "Driver for PCI core working in hostmode"
> -	depends on BCMA && MIPS
> +	depends on BCMA && MIPS && BCMA_HOST_PCI
>  	help
>  	  PCI core hostmode operation (external PCI bus).
>  
> diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
> index 4e20bcf..d2097a1 100644
> --- a/drivers/bcma/driver_pci_host.c
> +++ b/drivers/bcma/driver_pci_host.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include "bcma_private.h"
> +#include <linux/pci.h>
>  #include <linux/export.h>
>  #include <linux/bcma/bcma.h>
>  #include <asm/paccess.h>

