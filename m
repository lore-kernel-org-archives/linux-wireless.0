Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:57689 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab2CZS5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:57:06 -0400
Date: Mon, 26 Mar 2012 14:56:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Julian Calaby <julian.calaby@gmail.com>, <zajec5@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: fix build error on MIPS; implicit
 pcibios_enable_device
Message-ID: <20120326185641.GA22375@windriver.com> (sfid-20120326_205720_613971_2675F6A8)
References: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com>
 <CAGRGNgVBwKppzMa7HZeWm+ZW1a7u0JKwxxFS2xCRv=bpxXnk+Q@mail.gmail.com>
 <20120326012038.GA7722@windriver.com>
 <CAGRGNgVm_cNAdXZcSjj1oUz98vAVNEsdpZZ9L6=cc_sX_AZ8Rg@mail.gmail.com>
 <4F70543F.2010007@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F70543F.2010007@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following is seen during allmodconfig builds for MIPS:

drivers/bcma/driver_pci_host.c:518:2: error: implicit declaration
of function 'pcibios_enable_device' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[3]: *** [drivers/bcma/driver_pci_host.o] Error 1

Most likey introduced by commit 49dc9577155576b10ff79f0c1486c816b01f58bf

   "bcma: add PCIe host controller"

Add the header instead of implicitly assuming it will be present.
Sounds like a good idea, but that alone doesn't fix anything.

The real problem is that the Kconfig has settings related to whether
PCI is possible, i.e.

 config BCMA_HOST_PCI_POSSIBLE
       bool
       depends on BCMA && PCI = y
       default y

 config BCMA_HOST_PCI
       bool "Support for BCMA on PCI-host bus"
       depends on BCMA_HOST_PCI_POSSIBLE

...but what is missing is that BCMA_DRIVER_PCI_HOSTMODE doesn't
have any dependencies on the above.  Add one.

CC: Hauke Mehrtens <hauke@hauke-m.de>
CC: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[ v2: depend on BCMA_HOST_PCI_POSSIBLE, not BCMA_HOST_PCI ]

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index c1172da..6a0082d 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -29,7 +29,7 @@ config BCMA_HOST_PCI
 
 config BCMA_DRIVER_PCI_HOSTMODE
 	bool "Driver for PCI core working in hostmode"
-	depends on BCMA && MIPS
+	depends on BCMA && MIPS && BCMA_HOST_PCI_POSSIBLE
 	help
 	  PCI core hostmode operation (external PCI bus).
 
diff --git a/drivers/bcma/driver_pci_host.c b/drivers/bcma/driver_pci_host.c
index 4e20bcf..d2097a1 100644
--- a/drivers/bcma/driver_pci_host.c
+++ b/drivers/bcma/driver_pci_host.c
@@ -10,6 +10,7 @@
  */
 
 #include "bcma_private.h"
+#include <linux/pci.h>
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 #include <asm/paccess.h>
-- 
1.7.9.1
