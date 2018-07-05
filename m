Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43482 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753518AbeGEJph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH 04/27] mtd: rawnand: omap2: Allow selection of this driver when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:44:59 +0200
Message-Id: <20180705094522.12138-5-boris.brezillon@bootlin.com> (sfid-20180705_114649_333939_38509062)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having ARCH_OMAP2PLUS or ARCH_KEYSTONE
enabled.

We also need to add a dependency on HAS_IOMEM to make sure the driver
compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 52a1aa42eacf..c6764992cdfc 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -77,7 +77,8 @@ config MTD_NAND_AMS_DELTA
 
 config MTD_NAND_OMAP2
 	tristate "NAND Flash device on OMAP2, OMAP3, OMAP4 and Keystone"
-	depends on (ARCH_OMAP2PLUS || ARCH_KEYSTONE)
+	depends on ARCH_OMAP2PLUS || ARCH_KEYSTONE || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
           Support for NAND flash on Texas Instruments OMAP2, OMAP3, OMAP4
 	  and Keystone platforms.
-- 
2.14.1
