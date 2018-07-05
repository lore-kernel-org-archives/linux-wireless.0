Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43532 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753564AbeGEJps (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH 12/27] mtd: rawnand: mxc: Avoid inclusion of asm/mach headers
Date: Thu,  5 Jul 2018 11:45:07 +0200
Message-Id: <20180705094522.12138-13-boris.brezillon@bootlin.com> (sfid-20180705_114647_652564_935D1BB2)
In-Reply-To: <20180705094522.12138-1-boris.brezillon@bootlin.com>
References: <20180705094522.12138-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

asm/mach/flash.h does not seem to be needed, drop this #include to make
the code completely machine and arch independent and allow one to
compile it when COMPILE_TEST=y.

Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/mxc_nand.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/mxc_nand.c b/drivers/mtd/nand/raw/mxc_nand.c
index 90cfb5e730aa..14ec7d975593 100644
--- a/drivers/mtd/nand/raw/mxc_nand.c
+++ b/drivers/mtd/nand/raw/mxc_nand.c
@@ -34,8 +34,6 @@
 #include <linux/completion.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-
-#include <asm/mach/flash.h>
 #include <linux/platform_data/mtd-mxc_nand.h>
 
 #define DRIVER_NAME "mxc_nand"
-- 
2.14.1
