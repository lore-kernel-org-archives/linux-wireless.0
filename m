Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41207 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933165AbeGIUKF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 16:10:05 -0400
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
Subject: [PATCH v2 01/24] mtd: rawnand: atmel: Use uintptr_t casts instead of unsigned int
Date: Mon,  9 Jul 2018 22:09:22 +0200
Message-Id: <20180709200945.30116-2-boris.brezillon@bootlin.com> (sfid-20180709_221112_425211_ECF11BC8)
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When casting a pointer to an unsigned in, uintptr_t should be used to
cope with the pointer size differences between 32-bit and 64-bit
architectures.

This is needed if we want to allow compilation of this driver when
COMPILE_TEST=y.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index e686fe73159e..e8f7549d0354 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -2050,7 +2050,7 @@ atmel_smc_nand_controller_init(struct atmel_smc_nand_controller *nc)
 		return ret;
 	}
 
-	nc->ebi_csa_offs = (unsigned int)match->data;
+	nc->ebi_csa_offs = (uintptr_t)match->data;
 
 	/*
 	 * The at91sam9263 has 2 EBIs, if the NAND controller is under EBI1
-- 
2.14.1
