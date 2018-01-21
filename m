Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25940 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbeAUJU6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Jan 2018 04:20:58 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Dedy Lansky <dlansky@codeaurora.org>
Subject: [PATCH v2 3/8] wil6210: add support for Talyn AHB address map
Date: Sun, 21 Jan 2018 11:14:38 +0200
Message-Id: <1516526083-31389-4-git-send-email-merez@codeaurora.org> (sfid-20180121_102105_100493_F63DE657)
In-Reply-To: <1516526083-31389-1-git-send-email-merez@codeaurora.org>
References: <1516526083-31389-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Talyn memory has changed, areas were increased and shifted
to new locations.
Use the appropriate address map according to the device JTAG ID.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |  6 ++-
 drivers/net/wireless/ath/wil6210/pcie_bus.c  | 18 +++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h   | 21 +++++++--
 drivers/net/wireless/ath/wil6210/wmi.c       | 64 ++++++++++++++++++++++++----
 4 files changed, 92 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index dcf87a7..1835187 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -395,8 +396,9 @@ static irqreturn_t wil6210_irq_misc(int irq, void *cookie)
 	wil6210_mask_irq_misc(wil, false);
 
 	if (isr & ISR_MISC_FW_ERROR) {
-		u32 fw_assert_code = wil_r(wil, RGF_FW_ASSERT_CODE);
-		u32 ucode_assert_code = wil_r(wil, RGF_UCODE_ASSERT_CODE);
+		u32 fw_assert_code = wil_r(wil, wil->rgf_fw_assert_code_addr);
+		u32 ucode_assert_code =
+			wil_r(wil, wil->rgf_ucode_assert_code_addr);
 
 		wil_err(wil,
 			"Firmware error detected, assert codes FW 0x%08x, UCODE 0x%08x\n",
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 2b3b1f7..6b153fe 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -36,7 +36,7 @@ static int wil6210_pm_notify(struct notifier_block *notify_block,
 			     unsigned long mode, void *unused);
 
 static
-void wil_set_capabilities(struct wil6210_priv *wil)
+int wil_set_capabilities(struct wil6210_priv *wil)
 {
 	const char *wil_fw_name;
 	u32 jtag_id = wil_r(wil, RGF_USER_JTAG_DEV_ID);
@@ -72,16 +72,24 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 			wil->hw_version = HW_VER_UNKNOWN;
 			break;
 		}
+		memcpy(fw_mapping, sparrow_fw_mapping,
+		       sizeof(sparrow_fw_mapping));
+		wil->rgf_fw_assert_code_addr = SPARROW_RGF_FW_ASSERT_CODE;
+		wil->rgf_ucode_assert_code_addr = SPARROW_RGF_UCODE_ASSERT_CODE;
 		break;
 	case JTAG_DEV_ID_TALYN:
 		wil->hw_name = "Talyn";
 		wil->hw_version = HW_VER_TALYN;
+		memcpy(fw_mapping, talyn_fw_mapping, sizeof(talyn_fw_mapping));
+		wil->rgf_fw_assert_code_addr = TALYN_RGF_FW_ASSERT_CODE;
+		wil->rgf_ucode_assert_code_addr = TALYN_RGF_UCODE_ASSERT_CODE;
 		break;
 	default:
 		wil_err(wil, "Unknown board hardware, chip_id 0x%08x, chip_revision 0x%08x\n",
 			jtag_id, chip_revision);
 		wil->hw_name = "Unknown";
 		wil->hw_version = HW_VER_UNKNOWN;
+		return -EINVAL;
 	}
 
 	wil_info(wil, "Board hardware is %s\n", wil->hw_name);
@@ -97,6 +105,8 @@ void wil_set_capabilities(struct wil6210_priv *wil)
 	/* extract FW capabilities from file without loading the FW */
 	wil_request_firmware(wil, wil->wil_fw_name, false);
 	wil_refresh_fw_capabilities(wil);
+
+	return 0;
 }
 
 void wil_disable_irq(struct wil6210_priv *wil)
@@ -307,7 +317,11 @@ static int wil_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* rollback to err_iounmap */
 	wil_info(wil, "CSR at %pR -> 0x%p\n", &pdev->resource[0], wil->csr);
 
-	wil_set_capabilities(wil);
+	rc = wil_set_capabilities(wil);
+	if (rc) {
+		wil_err(wil, "wil_set_capabilities failed, rc %d\n", rc);
+		goto err_iounmap;
+	}
 	wil6210_clear_irq(wil);
 
 	/* FW should raise IRQ when ready */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index a59a553..79356bb 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -295,8 +295,12 @@ struct RGF_ICR {
 	#define REVISION_ID_SPARROW_D0	(0x3)
 
 /* crash codes for FW/Ucode stored here */
-#define RGF_FW_ASSERT_CODE		(0x91f020)
-#define RGF_UCODE_ASSERT_CODE		(0x91f028)
+
+/* ASSERT RGFs */
+#define SPARROW_RGF_FW_ASSERT_CODE	(0x91f020)
+#define SPARROW_RGF_UCODE_ASSERT_CODE	(0x91f028)
+#define TALYN_RGF_FW_ASSERT_CODE	(0xa37020)
+#define TALYN_RGF_UCODE_ASSERT_CODE	(0xa37028)
 
 enum {
 	HW_VER_UNKNOWN,
@@ -318,6 +322,10 @@ enum {
 #define WIL_DATA_COMPLETION_TO_MS 200
 
 /* Hardware definitions end */
+#define SPARROW_FW_MAPPING_TABLE_SIZE 10
+#define TALYN_FW_MAPPING_TABLE_SIZE 13
+#define MAX_FW_MAPPING_TABLE_SIZE 13
+
 struct fw_map {
 	u32 from; /* linker address - from, inclusive */
 	u32 to;   /* linker address - to, exclusive */
@@ -327,7 +335,9 @@ struct fw_map {
 };
 
 /* array size should be in sync with actual definition in the wmi.c */
-extern const struct fw_map fw_mapping[10];
+extern const struct fw_map sparrow_fw_mapping[SPARROW_FW_MAPPING_TABLE_SIZE];
+extern const struct fw_map talyn_fw_mapping[TALYN_FW_MAPPING_TABLE_SIZE];
+extern struct fw_map fw_mapping[MAX_FW_MAPPING_TABLE_SIZE];
 
 /**
  * mk_cidxtid - construct @cidxtid field
@@ -723,7 +733,7 @@ struct wil6210_priv {
 	atomic_t isr_count_rx, isr_count_tx;
 	/* debugfs */
 	struct dentry *debug;
-	struct wil_blob_wrapper blobs[ARRAY_SIZE(fw_mapping)];
+	struct wil_blob_wrapper blobs[MAX_FW_MAPPING_TABLE_SIZE];
 	u8 discovery_mode;
 	u8 abft_len;
 	u8 wakeup_trigger;
@@ -758,6 +768,9 @@ struct wil6210_priv {
 	bool suspend_resp_comp;
 	u32 bus_request_kbps;
 	u32 bus_request_kbps_pre_suspend;
+
+	u32 rgf_fw_assert_code_addr;
+	u32 rgf_ucode_assert_code_addr;
 };
 
 #define wil_to_wiphy(i) (i->wdev->wiphy)
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2ab71bb..69da3c2 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -70,23 +71,23 @@
  * On the PCI bus, there is one BAR (BAR0) of 2Mb size, exposing
  * AHB addresses starting from 0x880000
  *
- * Internally, firmware uses addresses that allows faster access but
+ * Internally, firmware uses addresses that allow faster access but
  * are invisible from the host. To read from these addresses, alternative
  * AHB address must be used.
- *
- * Memory mapping
- * Linker address         PCI/Host address
- *                        0x880000 .. 0xa80000  2Mb BAR0
- * 0x800000 .. 0x807000   0x900000 .. 0x907000  28k DCCM
- * 0x840000 .. 0x857000   0x908000 .. 0x91f000  92k PERIPH
  */
 
 /**
- * @fw_mapping provides memory remapping table
+ * @sparrow_fw_mapping provides memory remapping table for sparrow
  *
  * array size should be in sync with the declaration in the wil6210.h
+ *
+ * Sparrow memory mapping:
+ * Linker address         PCI/Host address
+ *                        0x880000 .. 0xa80000  2Mb BAR0
+ * 0x800000 .. 0x808000   0x900000 .. 0x908000  32k DCCM
+ * 0x840000 .. 0x860000   0x908000 .. 0x928000  128k PERIPH
  */
-const struct fw_map fw_mapping[] = {
+const struct fw_map sparrow_fw_mapping[] = {
 	/* FW code RAM 256k */
 	{0x000000, 0x040000, 0x8c0000, "fw_code", true},
 	/* FW data RAM 32k */
@@ -112,6 +113,51 @@
 	{0x800000, 0x804000, 0x940000, "uc_data", false},
 };
 
+/**
+ * @talyn_fw_mapping provides memory remapping table for Talyn
+ *
+ * array size should be in sync with the declaration in the wil6210.h
+ *
+ * Talyn memory mapping:
+ * Linker address         PCI/Host address
+ *                        0x880000 .. 0xc80000  4Mb BAR0
+ * 0x800000 .. 0x820000   0xa00000 .. 0xa20000  128k DCCM
+ * 0x840000 .. 0x858000   0xa20000 .. 0xa38000  96k PERIPH
+ */
+const struct fw_map talyn_fw_mapping[] = {
+	/* FW code RAM 1M */
+	{0x000000, 0x100000, 0x900000, "fw_code", true},
+	/* FW data RAM 128k */
+	{0x800000, 0x820000, 0xa00000, "fw_data", true},
+	/* periph. data RAM 96k */
+	{0x840000, 0x858000, 0xa20000, "fw_peri", true},
+	/* various RGF 40k */
+	{0x880000, 0x88a000, 0x880000, "rgf", true},
+	/* AGC table 4k */
+	{0x88a000, 0x88b000, 0x88a000, "AGC_tbl", true},
+	/* Pcie_ext_rgf 4k */
+	{0x88b000, 0x88c000, 0x88b000, "rgf_ext", true},
+	/* mac_ext_rgf 1344b */
+	{0x88c000, 0x88c540, 0x88c000, "mac_rgf_ext", true},
+	/* ext USER RGF 4k */
+	{0x88d000, 0x88e000, 0x88d000, "ext_user_rgf", true},
+	/* OTP 4k */
+	{0x8a0000, 0x8a1000, 0x8a0000, "otp", true},
+	/* DMA EXT RGF 64k */
+	{0x8b0000, 0x8c0000, 0x8b0000, "dma_ext_rgf", true},
+	/* upper area 1536k */
+	{0x900000, 0xa80000, 0x900000, "upper", true},
+	/* UCODE areas - accessible by debugfs blobs but not by
+	 * wmi_addr_remap. UCODE areas MUST be added AFTER FW areas!
+	 */
+	/* ucode code RAM 256k */
+	{0x000000, 0x040000, 0xa38000, "uc_code", false},
+	/* ucode data RAM 32k */
+	{0x800000, 0x808000, 0xa78000, "uc_data", false},
+};
+
+struct fw_map fw_mapping[MAX_FW_MAPPING_TABLE_SIZE];
+
 struct blink_on_off_time led_blink_time[] = {
 	{WIL_LED_BLINK_ON_SLOW_MS, WIL_LED_BLINK_OFF_SLOW_MS},
 	{WIL_LED_BLINK_ON_MED_MS, WIL_LED_BLINK_OFF_MED_MS},
-- 
1.9.1
