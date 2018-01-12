Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.211]:42853 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933846AbeALOZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 09:25:42 -0500
From: Matt Redfearn <matt.redfearn@mips.com>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
CC: <linux-wireless@vger.kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] bcma: Prevent build of PCI host features in module
Date: Fri, 12 Jan 2018 14:25:18 +0000
Message-ID: <1515767119-17117-1-git-send-email-matt.redfearn@mips.com> (sfid-20180112_152604_633120_44574D35)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attempting to build bcma.ko with BCMA_DRIVER_PCI_HOSTMODE=y results in
a build error due to use of symbols not exported from vmlinux:

ERROR: "pcibios_enable_device" [drivers/bcma/bcma.ko] undefined!
ERROR: "register_pci_controller" [drivers/bcma/bcma.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1

To prevent this, don't allow the host mode feature to be built if
CONFIG_BCMA=m

Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>

---

 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 02d78f6cecbb..4294784b9cf1 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
 
 config BCMA_DRIVER_PCI_HOSTMODE
 	bool "Driver for PCI core working in hostmode"
-	depends on MIPS && BCMA_DRIVER_PCI
+	depends on MIPS && BCMA_DRIVER_PCI && BCMA = y
 	help
 	  PCI core hostmode operation (external PCI bus).
 
-- 
2.7.4
