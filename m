Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43531 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753558AbeGEJps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:48 -0400
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
Subject: [PATCH 11/27] mtd: rawnand: orion: Allow selection of this driver when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:45:06 +0200
Message-Id: <20180705094522.12138-12-boris.brezillon@bootlin.com> (sfid-20180705_114648_217891_81BBBDE4)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having PLAT_ORION enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index b1934b415067..a28ffc4013b6 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
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
