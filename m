Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43505 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753548AbeGEJpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:47 -0400
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
Subject: [PATCH 08/27] mtd: rawnand: lpc32xx: Allow selection of these drivers when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:45:03 +0200
Message-Id: <20180705094522.12138-9-boris.brezillon@bootlin.com> (sfid-20180705_114559_775617_E534047E)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test these drivers without having ARCH_LPC32XX enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 4ff21c8e05d4..d396bb69d515 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -299,7 +299,8 @@ config MTD_NAND_MARVELL
 
 config MTD_NAND_SLC_LPC32XX
 	tristate "NXP LPC32xx SLC Controller"
-	depends on ARCH_LPC32XX
+	depends on ARCH_LPC32XX || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Enables support for NXP's LPC32XX SLC (i.e. for Single Level Cell
 	  chips) NAND controller. This is the default for the PHYTEC 3250
@@ -310,7 +311,8 @@ config MTD_NAND_SLC_LPC32XX
 
 config MTD_NAND_MLC_LPC32XX
 	tristate "NXP LPC32xx MLC Controller"
-	depends on ARCH_LPC32XX
+	depends on ARCH_LPC32XX || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  Uses the LPC32XX MLC (i.e. for Multi Level Cell chips) NAND
 	  controller. This is the default for the WORK92105 controller
-- 
2.14.1
