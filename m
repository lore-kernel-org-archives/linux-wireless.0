Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42692 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab2K0Nwn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:43 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqgxH031470
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:42 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqgwZ014247
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:42 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 1/6] wlcore/wl12xx: move wl12xx chip ID defines to the lower driver
Date: Tue, 27 Nov 2012 15:51:56 +0200
Message-ID: <1354024321-20635-2-git-send-email-coelho@ti.com> (sfid-20121127_145246_936701_4F5C4415)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wl12xx-specific chip ID macros to the wl12xx driver and rename
them to 127X and 128X for clarity since both the "1" (2.4GHz) and the
"3" (2.4GHz and 5GHz) variants use the same chip ID.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   26 +++++++++++++-------------
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    6 ++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    6 ------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index dadf1db..0b11029 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -601,7 +601,7 @@ static int wl127x_prepare_read(struct wl1271 *wl, u32 rx_desc, u32 len)
 {
 	int ret;
 
-	if (wl->chip.id != CHIP_ID_1283_PG20) {
+	if (wl->chip.id != CHIP_ID_128X_PG20) {
 		struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
 		struct wl127x_rx_mem_pool_addr rx_mem_addr;
 
@@ -631,7 +631,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 	int ret = 0;
 
 	switch (wl->chip.id) {
-	case CHIP_ID_1271_PG10:
+	case CHIP_ID_127X_PG10:
 		wl1271_warning("chip id 0x%x (1271 PG10) support is obsolete",
 			       wl->chip.id);
 
@@ -651,7 +651,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 				      WL127X_MINOR_VER);
 		break;
 
-	case CHIP_ID_1271_PG20:
+	case CHIP_ID_127X_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1271 PG20)",
 			     wl->chip.id);
 
@@ -672,7 +672,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 				      WL127X_MINOR_VER);
 		break;
 
-	case CHIP_ID_1283_PG20:
+	case CHIP_ID_128X_PG20:
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (1283 PG20)",
 			     wl->chip.id);
 		wl->plt_fw_name = WL128X_PLT_FW_NAME;
@@ -688,7 +688,7 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 				      WL128X_MAJOR_VER, WL128X_SUBTYPE_VER,
 				      WL128X_MINOR_VER);
 		break;
-	case CHIP_ID_1283_PG10:
+	case CHIP_ID_128X_PG10:
 	default:
 		wl1271_warning("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
@@ -1067,7 +1067,7 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 	u32 clk;
 	int selected_clock = -1;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		ret = wl128x_boot_clk(wl, &selected_clock);
 		if (ret < 0)
 			goto out;
@@ -1098,7 +1098,7 @@ static int wl12xx_pre_boot(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_BOOT, "clk2 0x%x", clk);
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
+	if (wl->chip.id == CHIP_ID_128X_PG20)
 		clk |= ((selected_clock & 0x3) << 1) << 4;
 	else
 		clk |= (priv->ref_clock << 1) << 4;
@@ -1152,7 +1152,7 @@ static int wl12xx_pre_upload(struct wl1271 *wl)
 	/* WL1271: The reference driver skips steps 7 to 10 (jumps directly
 	 * to upload_fw) */
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		ret = wl12xx_top_reg_write(wl, SDIO_IO_DS, HCI_IO_DS_6MA);
 		if (ret < 0)
 			goto out;
@@ -1261,7 +1261,7 @@ static void
 wl12xx_set_tx_desc_blocks(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 			  u32 blks, u32 spare_blks)
 {
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		desc->wl128x_mem.total_mem_blocks = blks;
 	} else {
 		desc->wl127x_mem.extra_blocks = spare_blks;
@@ -1275,7 +1275,7 @@ wl12xx_set_tx_desc_data_len(struct wl1271 *wl, struct wl1271_tx_hw_descr *desc,
 {
 	u32 aligned_len = wlcore_calc_packet_alignment(wl, skb->len);
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		desc->wl128x_mem.extra_bytes = aligned_len - skb->len;
 		desc->length = cpu_to_le16(aligned_len >> 2);
 
@@ -1339,7 +1339,7 @@ static int wl12xx_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		u32 host_cfg_bitmap = HOST_IF_CFG_RX_FIFO_ENABLE;
 
 		ret = wl128x_cmd_general_parms(wl);
@@ -1426,7 +1426,7 @@ static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
 	bool supported = false;
 	u8 major, minor;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20) {
+	if (wl->chip.id == CHIP_ID_128X_PG20) {
 		major = WL128X_PG_GET_MAJOR(wl->hw_pg_ver);
 		minor = WL128X_PG_GET_MINOR(wl->hw_pg_ver);
 
@@ -1482,7 +1482,7 @@ static int wl12xx_get_pg_ver(struct wl1271 *wl, s8 *ver)
 	u16 die_info;
 	int ret;
 
-	if (wl->chip.id == CHIP_ID_1283_PG20)
+	if (wl->chip.id == CHIP_ID_128X_PG20)
 		ret = wl12xx_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1,
 					  &die_info);
 	else
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 7182bbf..634ad00 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -24,6 +24,12 @@
 
 #include "conf.h"
 
+/* WiLink 6/7 chip IDs */
+#define CHIP_ID_127X_PG10              (0x04030101)
+#define CHIP_ID_127X_PG20              (0x04030111)
+#define CHIP_ID_128X_PG10              (0x05030101)
+#define CHIP_ID_128X_PG20              (0x05030111)
+
 /* minimum FW required for driver for wl127x */
 #define WL127X_CHIP_VER		6
 #define WL127X_IFTYPE_VER	3
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 68584aa..96af4a1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -477,12 +477,6 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* separate probe response templates for one-shot and sched scans */
 #define WLCORE_QUIRK_DUAL_PROBE_TMPL		BIT(10)
 
-/* TODO: move to the lower drivers when all usages are abstracted */
-#define CHIP_ID_1271_PG10              (0x4030101)
-#define CHIP_ID_1271_PG20              (0x4030111)
-#define CHIP_ID_1283_PG10              (0x05030101)
-#define CHIP_ID_1283_PG20              (0x05030111)
-
 /* TODO: move all these common registers and values elsewhere */
 #define HW_ACCESS_ELP_CTRL_REG		0x1FFFC
 
-- 
1.7.10.4

