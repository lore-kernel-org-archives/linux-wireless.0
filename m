Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43454 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753512AbeGEJph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH 01/27] mtd: rawnand: gpmi: Remove useless dependency on MTD_NAND
Date: Thu,  5 Jul 2018 11:44:56 +0200
Message-Id: <20180705094522.12138-2-boris.brezillon@bootlin.com> (sfid-20180705_114556_786907_A1672CFF)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The MTD_NAND_GPMI_NAND entry is already defined in an 'if MTD_NAND'
block, no need to add an extra "depends on MTD_NAND".

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 6074a946708a..58dad80eb174 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -340,7 +340,7 @@ config MTD_NAND_NANDSIM
 
 config MTD_NAND_GPMI_NAND
         tristate "GPMI NAND Flash Controller driver"
-        depends on MTD_NAND && MXS_DMA
+        depends on MXS_DMA
         help
 	 Enables NAND Flash support for IMX23, IMX28 or IMX6.
 	 The GPMI controller is very powerful, with the help of BCH
-- 
2.14.1
