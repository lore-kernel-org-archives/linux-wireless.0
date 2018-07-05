Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43561 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753596AbeGEJp5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:45:57 -0400
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
Subject: [PATCH 13/27] mtd: rawnand: mxc: Allow selection of this driver when COMPILE_TEST=y
Date: Thu,  5 Jul 2018 11:45:08 +0200
Message-Id: <20180705094522.12138-14-boris.brezillon@bootlin.com> (sfid-20180705_114627_009428_4F7AEBE1)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It just makes NAND maintainers' life easier by allowing them to
compile-test this driver without having ARCH_MXC enabled.

We also need to add a dependency on HAS_IOMEM to make sure the
driver compiles correctly.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index a28ffc4013b6..71e7542b6522 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -446,7 +446,8 @@ config MTD_NAND_VF610_NFC
 
 config MTD_NAND_MXC
 	tristate "MXC NAND support"
-	depends on ARCH_MXC
+	depends on ARCH_MXC || COMPILE_TEST
+	depends on HAS_IOMEM
 	help
 	  This enables the driver for the NAND flash controller on the
 	  MXC processors.
-- 
2.14.1
