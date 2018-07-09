Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41329 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933315AbeGIUKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
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
Subject: [PATCH v2 16/24] memory: fsl_ifc: Allow selection of this driver when COMPILE_TEST=y
Date: Mon,  9 Jul 2018 22:09:37 +0200
Message-Id: <20180709200945.30116-17-boris.brezillon@bootlin.com> (sfid-20180709_221047_373827_D102A985)
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
 drivers/memory/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index 8d731d6c3e54..78457ab2cbc4 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -116,7 +116,8 @@ config FSL_CORENET_CF
 
 config FSL_IFC
 	bool
-	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A
+	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
+	depends on HAS_IOMEM
 
 config JZ4780_NEMC
 	bool "Ingenic JZ4780 SoC NEMC driver"
-- 
2.14.1
