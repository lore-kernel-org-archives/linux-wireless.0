Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.150.225]:33909 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967338AbeCAKNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 05:13:12 -0500
From: Matt Redfearn <matt.redfearn@mips.com>
To: <kvalo@codeaurora.org>
CC: <zajec5@gmail.com>, <linux-wireless@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <jhogan@kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>
Subject: [PATCH v2] bcma: Prevent build of PCI host features in module
Date: Thu, 1 Mar 2018 09:58:12 +0000
Message-ID: <1519898292-12155-1-git-send-email-matt.redfearn@mips.com> (sfid-20180301_111339_320599_FE5448DF)
MIME-Version: 1.0
Content-Type: text/plain
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

Changes in v2:
Rebase on v4.16-rc1

 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index ba8acca036df..cb0f1aad20b7 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
 
 config BCMA_DRIVER_PCI_HOSTMODE
 	bool "Driver for PCI core working in hostmode"
-	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
+	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY && BCMA = y
 	help
 	  PCI core hostmode operation (external PCI bus).
 
-- 
2.7.4
