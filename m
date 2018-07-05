Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43615 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753615AbeGEJp7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:59 -0400
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
Subject: [PATCH 25/27] mtd: rawnand: jz4740: Allow selection of this driver when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:45:20 +0200
Message-Id: <20180705094522.12138-26-boris.brezillon@bootlin.com> (sfid-20180705_114627_579811_2592B643)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having MACH_JZ4740 enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 1579e62d8856..cd2c9f887270 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -492,7 +492,8 @@ config MTD_NAND_NUC900
 
 config MTD_NAND_JZ4740
 	tristate "Support for JZ4740 SoC NAND controller"
-	depends on MACH_JZ4740
+	depends on MACH_JZ4740 || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 		Enables support for NAND Flash on JZ4740 SoC based boards.
 
-- 
2.14.1
