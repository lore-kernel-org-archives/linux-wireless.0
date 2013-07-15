Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55245 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3GOLPY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:24 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/5] bcma: add some more core names
Date: Mon, 15 Jul 2013 13:15:04 +0200
Message-Id: <1373886908-4460-2-git-send-email-hauke@hauke-m.de> (sfid-20130715_131527_692689_F38ABC3C)
In-Reply-To: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
References: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These cores were found on a BCM4708 (chipid 53010), this is a ARM SoC
with two Cortex A9 cores.

bcma: bus0: Found chip with id 0xCF12, rev 0x00 and package 0x02
bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2A, class 0x0)
bcma: bus0: Core 1 found: DMA (manuf 0x4BF, id 0x502, rev 0x01, class 0x0)
bcma: bus0: Core 2 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 3 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 4 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 5 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x04, class 0x0)
bcma: bus0: Core 6 found: PCIe Gen 2 (manuf 0x4BF, id 0x501, rev 0x01, class 0x0)
bcma: bus0: Core 7 found: PCIe Gen 2 (manuf 0x4BF, id 0x501, rev 0x01, class 0x0)
bcma: bus0: Core 8 found: ARM Cortex A9 core (ihost) (manuf 0x4BF, id 0x510, rev 0x01, class 0x0)
bcma: bus0: Core 9 found: USB 2.0 (manuf 0x4BF, id 0x504, rev 0x01, class 0x0)
bcma: bus0: Core 10 found: USB 3.0 (manuf 0x4BF, id 0x505, rev 0x01, class 0x0)
bcma: bus0: Core 11 found: SDIO3 (manuf 0x4BF, id 0x503, rev 0x01, class 0x0)
bcma: bus0: Core 12 found: ARM Cortex A9 JTAG (manuf 0x4BF, id 0x506, rev 0x01, class 0x0)
bcma: bus0: Core 13 found: Denali DDR2/DDR3 memory controller (manuf 0x4BF, id 0x507, rev 0x01, class 0x0)
bcma: bus0: Core 14 found: ROM (manuf 0x4BF, id 0x508, rev 0x01, class 0x0)
bcma: bus0: Core 15 found: NAND flash controller (manuf 0x4BF, id 0x509, rev 0x01, class 0x0)
bcma: bus0: Core 16 found: SPI flash controller (manuf 0x4BF, id 0x50A, rev 0x01, class 0x0)

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c       |   12 ++++++++++++
 include/linux/bcma/bcma.h |   12 ++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 8bffa5c..f2f1415 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -32,6 +32,18 @@ static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_4706_CHIPCOMMON, "BCM4706 ChipCommon" },
 	{ BCMA_CORE_4706_SOC_RAM, "BCM4706 SOC RAM" },
 	{ BCMA_CORE_4706_MAC_GBIT, "BCM4706 GBit MAC" },
+	{ BCMA_CORE_PCIEG2, "PCIe Gen 2" },
+	{ BCMA_CORE_DMA, "DMA" },
+	{ BCMA_CORE_SDIO3, "SDIO3" },
+	{ BCMA_CORE_USB20, "USB 2.0" },
+	{ BCMA_CORE_USB30, "USB 3.0" },
+	{ BCMA_CORE_A9JTAG, "ARM Cortex A9 JTAG" },
+	{ BCMA_CORE_DDR23, "Denali DDR2/DDR3 memory controller" },
+	{ BCMA_CORE_ROM, "ROM" },
+	{ BCMA_CORE_NAND, "NAND flash controller" },
+	{ BCMA_CORE_QSPI, "SPI flash controller" },
+	{ BCMA_CORE_CHIPCOMMON_B, "Chipcommon B" },
+	{ BCMA_CORE_ARMCA9, "ARM Cortex A9 core (ihost)" },
 	{ BCMA_CORE_AMEMC, "AMEMC (DDR)" },
 	{ BCMA_CORE_ALTA, "ALTA (I2S)" },
 	{ BCMA_CORE_INVALID, "Invalid" },
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 622fc50..8fee028 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -72,7 +72,19 @@ struct bcma_host_ops {
 /* Core-ID values. */
 #define BCMA_CORE_OOB_ROUTER		0x367	/* Out of band */
 #define BCMA_CORE_4706_CHIPCOMMON	0x500
+#define BCMA_CORE_PCIEG2		0x501
+#define BCMA_CORE_DMA			0x502
+#define BCMA_CORE_SDIO3			0x503
+#define BCMA_CORE_USB20			0x504
+#define BCMA_CORE_USB30			0x505
+#define BCMA_CORE_A9JTAG		0x506
+#define BCMA_CORE_DDR23			0x507
+#define BCMA_CORE_ROM			0x508
+#define BCMA_CORE_NAND			0x509
+#define BCMA_CORE_QSPI			0x50A
+#define BCMA_CORE_CHIPCOMMON_B		0x50B
 #define BCMA_CORE_4706_SOC_RAM		0x50E
+#define BCMA_CORE_ARMCA9		0x510
 #define BCMA_CORE_4706_MAC_GBIT		0x52D
 #define BCMA_CORE_AMEMC			0x52E	/* DDR1/2 memory controller core */
 #define BCMA_CORE_ALTA			0x534	/* I2S core */
-- 
1.7.10.4

