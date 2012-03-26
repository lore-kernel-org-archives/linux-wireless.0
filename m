Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:59751 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2CZADg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 20:03:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: zajec5@gmail.com
Cc: linux-wireless@vger.kernel.org,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] bcma: fix build error on MIPS; implicit pcibios_enable_device
Date: Sun, 25 Mar 2012 20:02:55 -0400
Message-Id: <1332720175-7659-1-git-send-email-paul.gortmaker@windriver.com> (sfid-20120326_020407_439568_76860937)
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

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index c1172da..fb7c80f 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -29,7 +29,7 @@ config BCMA_HOST_PCI
 
 config BCMA_DRIVER_PCI_HOSTMODE
 	bool "Driver for PCI core working in hostmode"
-	depends on BCMA && MIPS
+	depends on BCMA && MIPS && BCMA_HOST_PCI
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
1.7.9.4

