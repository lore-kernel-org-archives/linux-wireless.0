Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41249 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933270AbeGIUKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:06 -0400
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
        linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 06/24] mtd: rawnand: orion: Allow selection of this driver when COMPILE_TEST=y
Date: Mon,  9 Jul 2018 22:09:27 +0200
Message-Id: <20180709200945.30116-7-boris.brezillon@bootlin.com> (sfid-20180709_221058_200696_57BB840A)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having PLAT_ORION enabled.

We add a dependency on HAS_IOMEM to make sure the driver compiles
correctly, and a dependency on !IA64 because the {read,write}s{bwl}()
accessors are not defined for this architecture.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index e01b3da726c0..efc5dcd5135c 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -289,7 +289,7 @@ config MTD_NAND_MARVELL
 	tristate "NAND controller support on Marvell boards"
 	depends on PXA3xx || ARCH_MMP || PLAT_ORION || ARCH_MVEBU || \
 		   COMPILE_TEST
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && !IA64
 	help
 	  This enables the NAND flash controller driver for Marvell boards,
 	  including:
@@ -381,7 +381,8 @@ config MTD_NAND_PLATFORM
 
 config MTD_NAND_ORION
 	tristate "NAND Flash support for Marvell Orion SoC"
-	depends on PLAT_ORION
+	depends on PLAT_ORION || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  This enables the NAND flash controller on Orion machines.
 
-- 
2.14.1
