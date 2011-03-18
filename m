Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:48140 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756744Ab1CROUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 10:20:23 -0400
Received: by wwa36 with SMTP id 36so4671046wwa.25
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 07:20:20 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: shahar_levi@ti.com, ruthyz@ti.com
Subject: [PATCH v2 09/14] wl12xx: 1281/1283 support - use dynamic memory for the RX/TX pools
Date: Fri, 18 Mar 2011 16:19:24 +0200
Message-Id: <1300457969-19601-10-git-send-email-coelho@ti.com>
In-Reply-To: <1300457969-19601-1-git-send-email-coelho@ti.com>
References: <1300457969-19601-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Levi <shahar_levi@ti.com>

Separate the memory configuration to chip-specific structures and
implement dynamic memory for wl128x.

This feature allows us to move TX memory blocks to the RX pool when
the RX path is overloaded.

Thanks for Arik Nemtsov <arik@wizery.com> for helping simplify the
wl1271_fw_status() code.

[Rewrote the commit subject and message for clarity; improved some
comments and changed "spare" to "padding" for consistency; added a
FIXME for the AP memory configuration -- Luca]

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
Reviewed-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   35 ++++++++++++++++--------
 drivers/net/wireless/wl12xx/conf.h   |    3 +-
 drivers/net/wireless/wl12xx/main.c   |   48 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    5 +++
 4 files changed, 70 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 50676b3..fc62e68 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -965,10 +965,13 @@ int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 	}
 
 	/* memory config */
-	mem_conf->num_stations = wl->conf.mem.num_stations;
-	mem_conf->rx_mem_block_num = wl->conf.mem.rx_block_num;
-	mem_conf->tx_min_mem_block_num = wl->conf.mem.tx_min_block_num;
-	mem_conf->num_ssid_profiles = wl->conf.mem.ssid_profiles;
+	/* FIXME: for now we always use mem_wl127x for AP, because it
+	 * doesn't support dynamic memory and we don't have the
+	 * optimal values for wl128x without dynamic memory yet */ 
+	mem_conf->num_stations = wl->conf.mem_wl127x.num_stations;
+	mem_conf->rx_mem_block_num = wl->conf.mem_wl127x.rx_block_num;
+	mem_conf->tx_min_mem_block_num = wl->conf.mem_wl127x.tx_min_block_num;
+	mem_conf->num_ssid_profiles = wl->conf.mem_wl127x.ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
@@ -986,6 +989,7 @@ out:
 int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 {
 	struct wl1271_acx_sta_config_memory *mem_conf;
+	struct conf_memory_settings *mem;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
@@ -996,16 +1000,21 @@ int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 		goto out;
 	}
 
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		mem = &wl->conf.mem_wl128x;
+	else
+		mem = &wl->conf.mem_wl127x;
+
 	/* memory config */
-	mem_conf->num_stations = wl->conf.mem.num_stations;
-	mem_conf->rx_mem_block_num = wl->conf.mem.rx_block_num;
-	mem_conf->tx_min_mem_block_num = wl->conf.mem.tx_min_block_num;
-	mem_conf->num_ssid_profiles = wl->conf.mem.ssid_profiles;
+	mem_conf->num_stations = mem->num_stations;
+	mem_conf->rx_mem_block_num = mem->rx_block_num;
+	mem_conf->tx_min_mem_block_num = mem->tx_min_block_num;
+	mem_conf->num_ssid_profiles = mem->ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
-	mem_conf->dyn_mem_enable = wl->conf.mem.dynamic_memory;
-	mem_conf->tx_free_req = wl->conf.mem.min_req_tx_blocks;
-	mem_conf->rx_free_req = wl->conf.mem.min_req_rx_blocks;
-	mem_conf->tx_min = wl->conf.mem.tx_min;
+	mem_conf->dyn_mem_enable = mem->dynamic_memory;
+	mem_conf->tx_free_req = mem->min_req_tx_blocks;
+	mem_conf->rx_free_req = mem->min_req_rx_blocks;
+	mem_conf->tx_min = mem->tx_min;
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
 				   sizeof(*mem_conf));
@@ -1072,6 +1081,8 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
 	wl1271_debug(DEBUG_TX, "available tx blocks: %d",
 		     wl->tx_blocks_available);
 
+	wl->tx_new_total = wl->tx_blocks_available;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index a00f22c..743bd0b 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1204,7 +1204,8 @@ struct conf_drv_settings {
 	struct conf_scan_settings scan;
 	struct conf_rf_settings rf;
 	struct conf_ht_setting ht;
-	struct conf_memory_settings mem;
+	struct conf_memory_settings mem_wl127x;
+	struct conf_memory_settings mem_wl128x;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fe0cf47..3c381ce 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -298,7 +298,7 @@ static struct conf_drv_settings default_conf = {
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
 	},
-	.mem = {
+	.mem_wl127x = {
 		.num_stations                 = 1,
 		.ssid_profiles                = 1,
 		.rx_block_num                 = 70,
@@ -307,7 +307,17 @@ static struct conf_drv_settings default_conf = {
 		.min_req_tx_blocks            = 100,
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
-	}
+	},
+	.mem_wl128x = {
+		.num_stations                 = 1,
+		.ssid_profiles                = 1,
+		.rx_block_num                 = 40,
+		.tx_min_block_num             = 40,
+		.dynamic_memory               = 1,
+		.min_req_tx_blocks            = 45,
+		.min_req_rx_blocks            = 22,
+		.tx_min                       = 27,
+	},
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -608,16 +618,27 @@ static void wl1271_fw_status(struct wl1271 *wl,
 {
 	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
+	u32 old_tx_blk_count = wl->tx_blocks_available;
 	u32 total = 0;
 	int i;
 
-	if (wl->bss_type == BSS_TYPE_AP_BSS)
+	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
 				sizeof(struct wl1271_fw_ap_status), false);
-	else
+	} else {
 		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
 				sizeof(struct wl1271_fw_sta_status), false);
 
+		/* Update tx total blocks change */
+		wl->tx_total_diff +=
+			((struct wl1271_fw_sta_status *)status)->tx_total -
+			wl->tx_new_total;
+
+		/* Update total tx blocks */
+		wl->tx_new_total =
+			((struct wl1271_fw_sta_status *)status)->tx_total;
+	}
+
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
 		     status->intr,
@@ -627,17 +648,28 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
 	/* update number of available TX blocks */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		u32 cnt = le32_to_cpu(status->tx_released_blks[i]) -
+		total += le32_to_cpu(status->tx_released_blks[i]) -
 			wl->tx_blocks_freed[i];
 
 		wl->tx_blocks_freed[i] =
 			le32_to_cpu(status->tx_released_blks[i]);
-		wl->tx_blocks_available += cnt;
-		total += cnt;
+
+	}
+
+	/*
+	 * By adding the freed blocks to tx_total_diff we are actually
+	 * moving them to the RX pool.
+	 */
+	wl->tx_total_diff += total;
+
+	/* if we have positive difference, add the blocks to the TX pool */
+	if (wl->tx_total_diff >= 0) {
+		wl->tx_blocks_available += wl->tx_total_diff;
+		wl->tx_total_diff = 0;
 	}
 
 	/* if more blocks are available now, tx work can be scheduled */
-	if (total)
+	if (wl->tx_blocks_available > old_tx_blk_count)
 		clear_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags);
 
 	/* for AP update num of allocated TX blocks per link and ps status */
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4b55677..ad04b83 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -267,6 +267,8 @@ struct wl1271_fw_sta_status {
 	u8  tx_total;
 	u8  reserved1;
 	__le16 reserved2;
+	/* Total structure size is 68 bytes */
+	u32 padding;
 } __packed;
 
 struct wl1271_fw_full_status {
@@ -397,6 +399,9 @@ struct wl1271 {
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
 	u32 tx_results_count;
+	/* Indicates how many memory blocks should be moved to the RX pool */
+	int tx_total_diff;
+	u32 tx_new_total;
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
-- 
1.7.1

