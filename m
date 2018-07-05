Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43485 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753512AbeGEJpq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:46 -0400
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
Subject: [PATCH 05/27] mtd: rawnand: s3c2410: Allow selection of this driver when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:45:00 +0200
Message-Id: <20180705094522.12138-6-boris.brezillon@bootlin.com> (sfid-20180705_114557_944326_FA67AEEF)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having ARCH_S3C24XX or ARCH_S3C64XX
enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index c6764992cdfc..033900c0c618 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -119,7 +119,8 @@ config MTD_NAND_AU1550
 
 config MTD_NAND_S3C2410
 	tristate "NAND Flash support for Samsung S3C SoCs"
-	depends on ARCH_S3C24XX || ARCH_S3C64XX
+	depends on ARCH_S3C24XX || ARCH_S3C64XX || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  This enables the NAND flash controller on the S3C24xx and S3C64xx
 	  SoCs
-- 
2.14.1
