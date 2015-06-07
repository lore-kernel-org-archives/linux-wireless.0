Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:34068 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbbFGLPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 07:15:47 -0400
Received: by wibut5 with SMTP id ut5so58982787wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2015 04:15:46 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: lower dependency of BCMA_DRIVER_PCI_HOSTMODE
Date: Sun,  7 Jun 2015 13:15:31 +0200
Message-Id: <1433675731-16328-2-git-send-email-zajec5@gmail.com> (sfid-20150607_131933_485390_327CFFB3)
In-Reply-To: <1433675731-16328-1-git-send-email-zajec5@gmail.com>
References: <1433675731-16328-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This extension of BCMA_DRIVER_PCI has no reason to depend on
BCMA_HOST_PCI. User may just want to have PCI device attached to SoC
registered without enabling any extra client mode code.
This can be useful when having non-bcma PCI device attached or when
using other PCI driver.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index fc6ffcf..be5fffb 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -29,12 +29,6 @@ config BCMA_HOST_PCI
 	select BCMA_DRIVER_PCI
 	default y
 
-config BCMA_DRIVER_PCI_HOSTMODE
-	bool "Driver for PCI core working in hostmode"
-	depends on BCMA && MIPS && BCMA_HOST_PCI
-	help
-	  PCI core hostmode operation (external PCI bus).
-
 config BCMA_HOST_SOC
 	bool "Support for BCMA in a SoC"
 	depends on BCMA
@@ -61,6 +55,12 @@ config BCMA_DRIVER_PCI
 	  This driver is also prerequisite for a hostmode PCIe core
 	  support.
 
+config BCMA_DRIVER_PCI_HOSTMODE
+	bool "Driver for PCI core working in hostmode"
+	depends on BCMA && MIPS && BCMA_DRIVER_PCI
+	help
+	  PCI core hostmode operation (external PCI bus).
+
 config BCMA_DRIVER_MIPS
 	bool "BCMA Broadcom MIPS core driver"
 	depends on BCMA && MIPS
-- 
1.8.4.5

