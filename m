Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41330 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933320AbeGIUKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH v2 15/24] mtd: rawnand: fsmc: Allow selection of this driver when COMPILE_TEST=y
Date: Mon,  9 Jul 2018 22:09:36 +0200
Message-Id: <20180709200945.30116-16-boris.brezillon@bootlin.com> (sfid-20180709_221049_649009_2E70B1F8)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having PLAT_SPEAR, ARCH_NOMADIK,
ARCH_U8500 or MACH_U300 enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index ee836f7d7b8b..29d360f984c9 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -503,8 +503,9 @@ config MTD_NAND_JZ4780
 
 config MTD_NAND_FSMC
 	tristate "Support for NAND on ST Micros FSMC"
-	depends on OF
-	depends on PLAT_SPEAR || ARCH_NOMADIK || ARCH_U8500 || MACH_U300
+	depends on OF && HAS_IOMEM
+	depends on PLAT_SPEAR || ARCH_NOMADIK || ARCH_U8500 || MACH_U300 || \
+		   COMPILE_TEST
 	help
 	  Enables support for NAND Flash chips on the ST Microelectronics
 	  Flexible Static Memory Controller (FSMC)
-- 
2.14.1
