Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41331 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933319AbeGIUKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:16 -0400
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
Subject: [PATCH v2 18/24] mtd: rawnand: fsl_ifc: Allow selection of this driver when COMPILE_TEST=y
Date: Mon,  9 Jul 2018 22:09:39 +0200
Message-Id: <20180709200945.30116-19-boris.brezillon@bootlin.com> (sfid-20180709_221048_219073_9BE6B8F6)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes maintainers' life easier by allowing them to compile-test
this driver without having FSL_SOC, ARCH_LAYERSCAPE or SOC_LS1021A
enabled.

We also need to add a dependency on HAS_IOMEM to make sure the
driver compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 29d360f984c9..dc6c5aff4172 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -408,7 +408,8 @@ config MTD_NAND_FSL_ELBC
 
 config MTD_NAND_FSL_IFC
 	tristate "NAND support for Freescale IFC controller"
-	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A
+	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
+	depends on HAS_IOMEM
 	select FSL_IFC
 	select MEMORY
 	help
-- 
2.14.1
