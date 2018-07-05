Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43463 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753514AbeGEJph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:37 -0400
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 02/27] mtd: rawnand: Add 'depends on HAS_IOMEM' where missing
Date: Thu,  5 Jul 2018 11:44:57 +0200
Message-Id: <20180705094522.12138-3-boris.brezillon@bootlin.com> (sfid-20180705_114556_219330_C68063D5)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When COMPILE_TEST is allowed and the platform needs uses the iomem API
we need to add an explicit dependency on HAS_IOMEM to avoid selection
of these drivers when building for an arch that has no iomem support
(this is the case of arch/um).

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 58dad80eb174..bfd28c1b72a3 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -152,6 +152,7 @@ config MTD_NAND_S3C2410_CLKSTOP
 config MTD_NAND_TANGO
 	tristate "NAND Flash support for Tango chips"
 	depends on ARCH_TANGO || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Enables the NAND Flash controller on Tango chips.
 
@@ -513,6 +514,7 @@ config MTD_NAND_SUNXI
 config MTD_NAND_HISI504
 	tristate "Support for NAND controller on Hisilicon SoC Hip04"
 	depends on ARCH_HISI || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Enables support for NAND controller on Hisilicon SoC Hip04.
 
@@ -526,6 +528,7 @@ config MTD_NAND_QCOM
 config MTD_NAND_MTK
 	tristate "Support for NAND controller on MTK SoCs"
 	depends on ARCH_MEDIATEK || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Enables support for NAND controller on MTK SoCs.
 	  This controller is found on mt27xx, mt81xx, mt65xx SoCs.
@@ -533,6 +536,7 @@ config MTD_NAND_MTK
 config MTD_NAND_TEGRA
 	tristate "Support for NAND controller on NVIDIA Tegra"
 	depends on ARCH_TEGRA || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Enables support for NAND flash controller on NVIDIA Tegra SoC.
 	  The driver has been developed and tested on a Tegra 2 SoC. DMA
-- 
2.14.1
