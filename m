Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36719 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbaG3VVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 17:21:18 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so1760023wgg.4
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2014 14:21:17 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: use NS prefix for names of Northstar specific cores
Date: Wed, 30 Jul 2014 23:21:06 +0200
Message-Id: <1406755266-26859-1-git-send-email-zajec5@gmail.com> (sfid-20140730_232121_906757_04D1902D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's cleaner and we don't have quite identical names like
BCMA_CORE_PCIEG2 and BCMA_CORE_PCIE2.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c       | 22 +++++++++++-----------
 include/linux/bcma/bcma.h | 22 +++++++++++-----------
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 3776840..b4764c6 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -32,17 +32,17 @@ static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_4706_CHIPCOMMON, "BCM4706 ChipCommon" },
 	{ BCMA_CORE_4706_SOC_RAM, "BCM4706 SOC RAM" },
 	{ BCMA_CORE_4706_MAC_GBIT, "BCM4706 GBit MAC" },
-	{ BCMA_CORE_PCIEG2, "PCIe Gen 2" },
-	{ BCMA_CORE_DMA, "DMA" },
-	{ BCMA_CORE_SDIO3, "SDIO3" },
-	{ BCMA_CORE_USB20, "USB 2.0" },
-	{ BCMA_CORE_USB30, "USB 3.0" },
-	{ BCMA_CORE_A9JTAG, "ARM Cortex A9 JTAG" },
-	{ BCMA_CORE_DDR23, "Denali DDR2/DDR3 memory controller" },
-	{ BCMA_CORE_ROM, "ROM" },
-	{ BCMA_CORE_NAND, "NAND flash controller" },
-	{ BCMA_CORE_QSPI, "SPI flash controller" },
-	{ BCMA_CORE_CHIPCOMMON_B, "Chipcommon B" },
+	{ BCMA_CORE_NS_PCIEG2, "PCIe Gen 2" },
+	{ BCMA_CORE_NS_DMA, "DMA" },
+	{ BCMA_CORE_NS_SDIO3, "SDIO3" },
+	{ BCMA_CORE_NS_USB20, "USB 2.0" },
+	{ BCMA_CORE_NS_USB30, "USB 3.0" },
+	{ BCMA_CORE_NS_A9JTAG, "ARM Cortex A9 JTAG" },
+	{ BCMA_CORE_NS_DDR23, "Denali DDR2/DDR3 memory controller" },
+	{ BCMA_CORE_NS_ROM, "ROM" },
+	{ BCMA_CORE_NS_NAND, "NAND flash controller" },
+	{ BCMA_CORE_NS_QSPI, "SPI flash controller" },
+	{ BCMA_CORE_NS_CHIPCOMMON_B, "Chipcommon B" },
 	{ BCMA_CORE_ARMCA9, "ARM Cortex A9 core (ihost)" },
 	{ BCMA_CORE_AMEMC, "AMEMC (DDR)" },
 	{ BCMA_CORE_ALTA, "ALTA (I2S)" },
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 70b8d88..0272e49 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -73,17 +73,17 @@ struct bcma_host_ops {
 /* Core-ID values. */
 #define BCMA_CORE_OOB_ROUTER		0x367	/* Out of band */
 #define BCMA_CORE_4706_CHIPCOMMON	0x500
-#define BCMA_CORE_PCIEG2		0x501
-#define BCMA_CORE_DMA			0x502
-#define BCMA_CORE_SDIO3			0x503
-#define BCMA_CORE_USB20			0x504
-#define BCMA_CORE_USB30			0x505
-#define BCMA_CORE_A9JTAG		0x506
-#define BCMA_CORE_DDR23			0x507
-#define BCMA_CORE_ROM			0x508
-#define BCMA_CORE_NAND			0x509
-#define BCMA_CORE_QSPI			0x50A
-#define BCMA_CORE_CHIPCOMMON_B		0x50B
+#define BCMA_CORE_NS_PCIEG2		0x501
+#define BCMA_CORE_NS_DMA		0x502
+#define BCMA_CORE_NS_SDIO3		0x503
+#define BCMA_CORE_NS_USB20		0x504
+#define BCMA_CORE_NS_USB30		0x505
+#define BCMA_CORE_NS_A9JTAG		0x506
+#define BCMA_CORE_NS_DDR23		0x507
+#define BCMA_CORE_NS_ROM		0x508
+#define BCMA_CORE_NS_NAND		0x509
+#define BCMA_CORE_NS_QSPI		0x50A
+#define BCMA_CORE_NS_CHIPCOMMON_B	0x50B
 #define BCMA_CORE_4706_SOC_RAM		0x50E
 #define BCMA_CORE_ARMCA9		0x510
 #define BCMA_CORE_4706_MAC_GBIT		0x52D
-- 
1.8.4.5

