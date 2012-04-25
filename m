Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s12.blu0.hotmail.com ([65.55.111.87]:63356 "EHLO
	blu0-omc2-s12.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758075Ab2DYGPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:15:34 -0400
Message-ID: <BLU0-SMTP82C0BC8A30291EC08FBF14AC270@phx.gbl> (sfid-20120425_081536_947546_DCC89692)
From: Nathan Hintz <nlhintz@hotmail.com>
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, hauke@hauke-m.de,
	Nathan Hintz <nlhintz@hotmail.com>
Subject: [PATCH 1/6] bcma: Find names of non BCM cores
Date: Tue, 24 Apr 2012 23:15:14 -0700
In-Reply-To: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
References: <1335334519-18820-1-git-send-email-nlhintz@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/scan.c |   54 +++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index f94cccc..e19e987 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -19,7 +19,14 @@ struct bcma_device_id_name {
 	u16 id;
 	const char *name;
 };
-struct bcma_device_id_name bcma_device_names[] = {
+
+static const struct bcma_device_id_name bcma_arm_device_names[] = {
+	{ BCMA_CORE_ARM_1176, "ARM 1176" },
+	{ BCMA_CORE_ARM_7TDMI, "ARM 7TDMI" },
+	{ BCMA_CORE_ARM_CM3, "ARM CM3" },
+};
+
+static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_OOB_ROUTER, "OOB Router" },
 	{ BCMA_CORE_INVALID, "Invalid" },
 	{ BCMA_CORE_CHIPCOMMON, "ChipCommon" },
@@ -27,7 +34,6 @@ struct bcma_device_id_name bcma_device_names[] = {
 	{ BCMA_CORE_SRAM, "SRAM" },
 	{ BCMA_CORE_SDRAM, "SDRAM" },
 	{ BCMA_CORE_PCI, "PCI" },
-	{ BCMA_CORE_MIPS, "MIPS" },
 	{ BCMA_CORE_ETHERNET, "Fast Ethernet" },
 	{ BCMA_CORE_V90, "V90" },
 	{ BCMA_CORE_USB11_HOSTDEV, "USB 1.1 Hostdev" },
@@ -44,7 +50,6 @@ struct bcma_device_id_name bcma_device_names[] = {
 	{ BCMA_CORE_PHY_A, "PHY A" },
 	{ BCMA_CORE_PHY_B, "PHY B" },
 	{ BCMA_CORE_PHY_G, "PHY G" },
-	{ BCMA_CORE_MIPS_3302, "MIPS 3302" },
 	{ BCMA_CORE_USB11_HOST, "USB 1.1 Host" },
 	{ BCMA_CORE_USB11_DEV, "USB 1.1 Device" },
 	{ BCMA_CORE_USB20_HOST, "USB 2.0 Host" },
@@ -58,15 +63,11 @@ struct bcma_device_id_name bcma_device_names[] = {
 	{ BCMA_CORE_PHY_N, "PHY N" },
 	{ BCMA_CORE_SRAM_CTL, "SRAM Controller" },
 	{ BCMA_CORE_MINI_MACPHY, "Mini MACPHY" },
-	{ BCMA_CORE_ARM_1176, "ARM 1176" },
-	{ BCMA_CORE_ARM_7TDMI, "ARM 7TDMI" },
 	{ BCMA_CORE_PHY_LP, "PHY LP" },
 	{ BCMA_CORE_PMU, "PMU" },
 	{ BCMA_CORE_PHY_SSN, "PHY SSN" },
 	{ BCMA_CORE_SDIO_DEV, "SDIO Device" },
-	{ BCMA_CORE_ARM_CM3, "ARM CM3" },
 	{ BCMA_CORE_PHY_HT, "PHY HT" },
-	{ BCMA_CORE_MIPS_74K, "MIPS 74K" },
 	{ BCMA_CORE_MAC_GBIT, "GBit MAC" },
 	{ BCMA_CORE_DDR12_MEM_CTL, "DDR1/DDR2 Memory Controller" },
 	{ BCMA_CORE_PCIE_RC, "PCIe Root Complex" },
@@ -79,16 +80,41 @@ struct bcma_device_id_name bcma_device_names[] = {
 	{ BCMA_CORE_SHIM, "SHIM" },
 	{ BCMA_CORE_DEFAULT, "Default" },
 };
-const char *bcma_device_name(struct bcma_device_id *id)
+
+static const struct bcma_device_id_name bcma_mips_device_names[] = {
+	{ BCMA_CORE_MIPS, "MIPS" },
+	{ BCMA_CORE_MIPS_3302, "MIPS 3302" },
+	{ BCMA_CORE_MIPS_74K, "MIPS 74K" },
+};
+
+static const char *bcma_device_name(const struct bcma_device_id *id)
 {
-	int i;
+	const struct bcma_device_id_name *names;
+	int size, i;
+
+	/* search manufacturer specific names */
+	switch (id->manuf) {
+	case BCMA_MANUF_ARM:
+		names = bcma_arm_device_names;
+		size = ARRAY_SIZE(bcma_arm_device_names);
+		break;
+	case BCMA_MANUF_BCM:
+		names = bcma_bcm_device_names;
+		size = ARRAY_SIZE(bcma_bcm_device_names);
+		break;
+	case BCMA_MANUF_MIPS:
+		names = bcma_mips_device_names;
+		size = ARRAY_SIZE(bcma_mips_device_names);
+		break;
+	default:
+		return "UNKNOWN";
+	}
 
-	if (id->manuf == BCMA_MANUF_BCM) {
-		for (i = 0; i < ARRAY_SIZE(bcma_device_names); i++) {
-			if (bcma_device_names[i].id == id->id)
-				return bcma_device_names[i].name;
-		}
+	for (i = 0; i < size; i++) {
+		if (names[i].id == id->id)
+			return names[i].name;
 	}
+
 	return "UNKNOWN";
 }
 
-- 
1.7.7.6

