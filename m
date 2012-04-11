Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:47938 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754493Ab2DKJiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:25 -0400
Received: by lahc1 with SMTP id c1so565136lah.26
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:22 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 08/16] wlcore/wl12xx: add chip-specific identify chip operation
Date: Wed, 11 Apr 2012 12:37:55 +0300
Message-Id: <1334137083-13490-9-git-send-email-coelho@ti.com> (sfid-20120411_113840_886490_9780D299)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the code that identifies the chip ID and selects the appropriate
firmware to an operation implemented by the lower driver.  Also move
the quirks definitions into wlcore.h and rename to WLCORE_QUIRK_*.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   65 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl12xx/reg.h    |    1 -
 drivers/net/wireless/ti/wlcore/boot.c   |    6 +-
 drivers/net/wireless/ti/wlcore/init.c   |    4 +-
 drivers/net/wireless/ti/wlcore/main.c   |   57 +++++----------------------
 drivers/net/wireless/ti/wlcore/rx.c     |    2 +-
 drivers/net/wireless/ti/wlcore/tx.c     |    4 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h |   11 -----
 drivers/net/wireless/ti/wlcore/wlcore.h |   18 ++++++++
 9 files changed, 99 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index ea8480c..83ed48d 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -29,9 +29,6 @@
 
 #include "reg.h"
 
-static struct wlcore_ops wl12xx_ops = {
-};
-
 static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
 		.mem = {
@@ -131,6 +128,62 @@ static const int wl12xx_rtable[REG_TABLE_LEN] = {
 	[REG_RAW_FW_STATUS_ADDR]	= FW_STATUS_ADDR,
 };
 
+/* TODO: maybe move to a new header file? */
+#define WL127X_FW_NAME_MULTI	"ti-connectivity/wl127x-fw-4-mr.bin"
+#define WL127X_FW_NAME_SINGLE	"ti-connectivity/wl127x-fw-4-sr.bin"
+#define WL127X_PLT_FW_NAME	"ti-connectivity/wl127x-fw-4-plt.bin"
+
+#define WL128X_FW_NAME_MULTI	"ti-connectivity/wl128x-fw-4-mr.bin"
+#define WL128X_FW_NAME_SINGLE	"ti-connectivity/wl128x-fw-4-sr.bin"
+#define WL128X_PLT_FW_NAME	"ti-connectivity/wl128x-fw-4-plt.bin"
+
+static int wl12xx_identify_chip(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	switch (wl->chip.id) {
+	case CHIP_ID_1271_PG10:
+		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
+			       wl->chip.id);
+
+		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
+		wl->plt_fw_name = WL127X_PLT_FW_NAME;
+		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
+		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+		break;
+
+	case CHIP_ID_1271_PG20:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
+			     wl->chip.id);
+
+		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
+		wl->plt_fw_name = WL127X_PLT_FW_NAME;
+		wl->sr_fw_name = WL127X_FW_NAME_SINGLE;
+		wl->mr_fw_name = WL127X_FW_NAME_MULTI;
+		break;
+
+	case CHIP_ID_1283_PG20:
+		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
+			     wl->chip.id);
+		wl->plt_fw_name = WL128X_PLT_FW_NAME;
+		wl->sr_fw_name = WL128X_FW_NAME_SINGLE;
+		wl->mr_fw_name = WL128X_FW_NAME_MULTI;
+		break;
+	case CHIP_ID_1283_PG10:
+	default:
+		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+static struct wlcore_ops wl12xx_ops = {
+	.identify_chip = wl12xx_identify_chip,
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -180,3 +233,9 @@ module_exit(wl12xx_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
+MODULE_FIRMWARE(WL127X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL127X_FW_NAME_MULTI);
+MODULE_FIRMWARE(WL127X_PLT_FW_NAME);
+MODULE_FIRMWARE(WL128X_FW_NAME_SINGLE);
+MODULE_FIRMWARE(WL128X_FW_NAME_MULTI);
+MODULE_FIRMWARE(WL128X_PLT_FW_NAME);
diff --git a/drivers/net/wireless/ti/wl12xx/reg.h b/drivers/net/wireless/ti/wl12xx/reg.h
index c6a4743..52012ca 100644
--- a/drivers/net/wireless/ti/wl12xx/reg.h
+++ b/drivers/net/wireless/ti/wl12xx/reg.h
@@ -447,7 +447,6 @@ b12-b0 - Supported Rate indicator bits as defined below.
 #define CLK_REQ_OUTN_SEL       0x700
 
 #define WU_COUNTER_PAUSE_VAL 0x3FF
-#define WELP_ARM_COMMAND_VAL 0x4
 
 /* PLL configuration algorithm for wl128x */
 #define SYS_CLK_CFG_REG              0x2200
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 69409ec..7c72e16 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -58,11 +58,11 @@ static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
 	/* Only new station firmwares support routing fw logs to the host */
 	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
 	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
-		quirks |= WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED;
+		quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
 
 	/* This feature is not yet supported for AP mode */
 	if (fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP)
-		quirks |= WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED;
+		quirks |= WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED;
 
 	return quirks;
 }
@@ -641,7 +641,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 clk;
 
 	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
-		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
+		wl->quirks |= WLCORE_QUIRK_END_OF_TRANSACTION;
 
 	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
 	    wl->ref_clock == CONF_REF_CLK_38_4_E ||
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index f3b6067..c146d8e 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -318,7 +318,7 @@ static int wl12xx_init_fwlog(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->quirks & WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED)
+	if (wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED)
 		return 0;
 
 	ret = wl12xx_cmd_config_fwlog(wl);
@@ -500,7 +500,7 @@ int wl1271_chip_specific_init(struct wl1271 *wl)
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
 
-		if (!(wl->quirks & WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT))
+		if (!(wl->quirks & WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT))
 			/* Enable SDIO padding */
 			host_cfg_bitmap |= HOST_IF_CFG_TX_PAD_TO_SDIO_BLK;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d3fde0a..95d2471 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1055,10 +1055,7 @@ static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 
 	if (plt) {
 		fw_type = WL12XX_FW_TYPE_PLT;
-		if (wl->chip.id == CHIP_ID_1283_PG20)
-			fw_name = WL128X_PLT_FW_NAME;
-		else
-			fw_name	= WL127X_PLT_FW_NAME;
+		fw_name = wl->plt_fw_name;
 	} else {
 		/*
 		 * we can't call wl12xx_get_vif_count() here because
@@ -1066,16 +1063,10 @@ static int wl12xx_fetch_firmware(struct wl1271 *wl, bool plt)
 		 */
 		if (wl->last_vif_count > 1) {
 			fw_type = WL12XX_FW_TYPE_MULTI;
-			if (wl->chip.id == CHIP_ID_1283_PG20)
-				fw_name = WL128X_FW_NAME_MULTI;
-			else
-				fw_name = WL127X_FW_NAME_MULTI;
+			fw_name = wl->mr_fw_name;
 		} else {
 			fw_type = WL12XX_FW_TYPE_NORMAL;
-			if (wl->chip.id == CHIP_ID_1283_PG20)
-				fw_name = WL128X_FW_NAME_SINGLE;
-			else
-				fw_name = WL127X_FW_NAME_SINGLE;
+			fw_name = wl->sr_fw_name;
 		}
 	}
 
@@ -1182,7 +1173,7 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	u32 first_addr;
 	u8 *block;
 
-	if ((wl->quirks & WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
+	if ((wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
 	    (wl->conf.fwlog.mode != WL12XX_FWLOG_ON_DEMAND) ||
 	    (wl->conf.fwlog.mem_blocks == 0))
 		return;
@@ -1356,43 +1347,17 @@ static int wl12xx_chip_wakeup(struct wl1271 *wl, bool plt)
 	 * chip types.
 	 */
 	if (!wl1271_set_block_size(wl))
-		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
-
-	switch (wl->chip.id) {
-	case CHIP_ID_1271_PG10:
-		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
-			       wl->chip.id);
+		wl->quirks |= WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
 
-		ret = wl1271_setup(wl);
-		if (ret < 0)
-			goto out;
-		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
-		break;
-
-	case CHIP_ID_1271_PG20:
-		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
-			     wl->chip.id);
-
-		ret = wl1271_setup(wl);
-		if (ret < 0)
-			goto out;
-		wl->quirks |= WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT;
-		break;
+	ret = wl->ops->identify_chip(wl);
+	if (ret < 0)
+		goto out;
 
-	case CHIP_ID_1283_PG20:
-		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
-			     wl->chip.id);
+	/* TODO: make sure the lower driver has set things up correctly */
 
-		ret = wl1271_setup(wl);
-		if (ret < 0)
-			goto out;
-		break;
-	case CHIP_ID_1283_PG10:
-	default:
-		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
-		ret = -ENODEV;
+	ret = wl1271_setup(wl);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl12xx_fetch_firmware(wl, plt);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index d7fab46..71c8d70 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -282,7 +282,7 @@ void wl12xx_rx(struct wl1271 *wl, struct wl12xx_fw_status *status)
 	 * Write the driver's packet counter to the FW. This is only required
 	 * for older hardware revisions
 	 */
-	if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+	if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION)
 		wl1271_write32(wl, WL12XX_REG_RX_DRIVER_COUNTER,
 			       wl->rx_counter);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 4e90c07..176b950 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -175,7 +175,7 @@ u8 wl12xx_tx_get_hlid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
 						unsigned int packet_length)
 {
-	if (wl->quirks & WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT)
+	if (wl->quirks & WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT)
 		return ALIGN(packet_length, WL1271_TX_ALIGN_TO);
 	else
 		return ALIGN(packet_length, WL12XX_BUS_BLOCK_SIZE);
@@ -767,7 +767,7 @@ out_ack:
 		 * Interrupt the firmware with the new packets. This is only
 		 * required for older hardware revisions
 		 */
-		if (wl->quirks & WL12XX_QUIRK_END_OF_TRANSACTION)
+		if (wl->quirks & WLCORE_QUIRK_END_OF_TRANSACTION)
 			wl1271_write32(wl, WL12XX_HOST_WR_ACCESS,
 				       wl->tx_packets_count);
 
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index c979920..b4db4cc 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -451,17 +451,6 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 #define HW_BG_RATES_MASK	0xffff
 #define HW_HT_RATES_OFFSET	16
 
-/* Quirks */
-
-/* Each RX/TX transaction requires an end-of-transaction transfer */
-#define WL12XX_QUIRK_END_OF_TRANSACTION		BIT(0)
-
-/* wl127x and SPI don't support SDIO block size alignment */
-#define WL12XX_QUIRK_NO_BLOCKSIZE_ALIGNMENT	BIT(2)
-
-/* Older firmwares did not implement the FW logger over bus feature */
-#define WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
-
 #define WL12XX_HW_BLOCK_SIZE	256
 
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f11e5c6..92455e9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -28,6 +28,7 @@
 #include "event.h"
 
 struct wlcore_ops {
+	int (*identify_chip)(struct wl1271 *wl);
 };
 
 enum wlcore_partitions {
@@ -291,6 +292,10 @@ struct wl1271 {
 	const struct wlcore_partition_set *ptable;
 	/* pointer to the lower driver register table */
 	const int *rtable;
+	/* name of the firmwares to load - for PLT, single role, multi-role */
+	const char *plt_fw_name;
+	const char *sr_fw_name;
+	const char *mr_fw_name;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
@@ -301,6 +306,17 @@ int wlcore_free_hw(struct wl1271 *wl);
 /* Firmware image load chunk size */
 #define CHUNK_SIZE	16384
 
+/* Quirks */
+
+/* Each RX/TX transaction requires an end-of-transaction transfer */
+#define WLCORE_QUIRK_END_OF_TRANSACTION		BIT(0)
+
+/* wl127x and SPI don't support SDIO block size alignment */
+#define WLCORE_QUIRK_NO_BLOCKSIZE_ALIGNMENT	BIT(2)
+
+/* Older firmwares did not implement the FW logger over bus feature */
+#define WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(4)
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
@@ -381,4 +397,6 @@ int wlcore_free_hw(struct wl1271 *wl);
 
 #define ECPU_CONTROL_HALT	0x00000101
 
+#define WELP_ARM_COMMAND_VAL	0x4
+
 #endif /* __WLCORE_H__ */
-- 
1.7.5.4

