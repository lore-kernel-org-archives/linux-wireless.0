Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:34098 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbCDWHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 17:07:46 -0500
Received: by wesq59 with SMTP id q59so49283496wes.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2015 14:07:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH next] bcma: prepare Kconfig symbol for PCI driver
Date: Wed,  4 Mar 2015 23:07:05 +0100
Message-Id: <1425506825-31844-1-git-send-email-zajec5@gmail.com> (sfid-20150304_230750_287966_29FF7646)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver for PCIe core requires PCI to be enabled, however we shouldn't
require it for the whole bus. Someone may be not interested in extra
PCI devices and what's more there are SoCs without any PCI at all (like
BCM5356C0, BCM5357*, BCM47186B0). For more details see Kconfig "help".
Please note this patch doesn't allow disabling PCI drivers yet, as it
requires more work on calls to bcma_core_pci_* functions.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig  | 17 +++++++++++++++++
 drivers/bcma/Makefile |  4 ++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 0ee48be..fee8d72 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -26,6 +26,7 @@ config BCMA_HOST_PCI_POSSIBLE
 config BCMA_HOST_PCI
 	bool "Support for BCMA on PCI-host bus"
 	depends on BCMA_HOST_PCI_POSSIBLE
+	select BCMA_DRIVER_PCI
 	default y
 
 config BCMA_DRIVER_PCI_HOSTMODE
@@ -44,6 +45,22 @@ config BCMA_HOST_SOC
 
 	  If unsure, say N
 
+# TODO: make it depend on PCI when ready
+config BCMA_DRIVER_PCI
+	bool
+	default y
+	help
+	  BCMA bus may have many versions of PCIe core. This driver
+	  supports:
+	  1) PCIe core working in clientmode
+	  2) PCIe Gen 2 clientmode core
+
+	  In general PCIe (Gen 2) clientmode core is required on PCIe
+	  hosted buses. It's responsible for initialization and basic
+	  hardware management.
+	  This driver is also prerequisite for a hostmode PCIe core
+	  support.
+
 config BCMA_DRIVER_MIPS
 	bool "BCMA Broadcom MIPS core driver"
 	depends on BCMA && MIPS
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 838b4b9..f32af9b 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -3,8 +3,8 @@ bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_chipcommon_b.o
 bcma-$(CONFIG_BCMA_SFLASH)		+= driver_chipcommon_sflash.o
 bcma-$(CONFIG_BCMA_NFLASH)		+= driver_chipcommon_nflash.o
-bcma-y					+= driver_pci.o
-bcma-y					+= driver_pcie2.o
+bcma-$(CONFIG_BCMA_DRIVER_PCI)		+= driver_pci.o
+bcma-$(CONFIG_BCMA_DRIVER_PCI)		+= driver_pcie2.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
 bcma-$(CONFIG_BCMA_DRIVER_GMAC_CMN)	+= driver_gmac_cmn.o
-- 
1.8.4.5

