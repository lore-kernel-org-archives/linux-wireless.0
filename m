Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:44353 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1CFO2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 09:28:17 -0500
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p26ESHc3026275
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Mar 2011 08:28:17 -0600
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH 07/15] wl12xx: 1281/1283 support - Set mem conf & dynamic mem
Date: Sun,  6 Mar 2011 16:32:12 +0200
Message-Id: <1299421940-26292-8-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
References: <1299421940-26292-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support dynamic TX mem blocks in the driver to wl128x FW that
supports moving TX mem blocks to RX in case the RX path is loaded.
The TX blocks available to use updated dynamically.

Thanks for Arik Nemtsov <arik@wizery.com> for helping simplify
wl1271_fw_status() code.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   32 ++++++++++++++--------
 drivers/net/wireless/wl12xx/conf.h   |    3 +-
 drivers/net/wireless/wl12xx/main.c   |   48 +++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl12xx.h |    5 +++
 4 files changed, 68 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index aa0fc12..f0345e6 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -965,10 +965,10 @@ int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 	}
 
 	/* memory config */
-	mem_conf->num_stations = wl->conf.mem.num_stations;
-	mem_conf->rx_mem_block_num = wl->conf.mem.rx_block_num;
-	mem_conf->tx_min_mem_block_num = wl->conf.mem.tx_min_block_num;
-	mem_conf->num_ssid_profiles = wl->conf.mem.ssid_profiles;
+	mem_conf->num_stations = wl->conf.mem_wl127x.num_stations;
+	mem_conf->rx_mem_block_num = wl->conf.mem_wl127x.rx_block_num;
+	mem_conf->tx_min_mem_block_num = wl->conf.mem_wl127x.tx_min_block_num;
+	mem_conf->num_ssid_profiles = wl->conf.mem_wl127x.ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
@@ -986,6 +986,7 @@ out:
 int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 {
 	struct wl1271_acx_sta_config_memory *mem_conf;
+	struct conf_memory_settings *mem;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
@@ -996,16 +997,21 @@ int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
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
@@ -1072,6 +1078,8 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
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
index 4bcac46..94f99ae 100644
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
@@ -308,6 +308,16 @@ static struct conf_drv_settings default_conf = {
 		.min_req_rx_blocks            = 22,
 		.tx_min                       = 27,
 	},
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
@@ -617,16 +627,27 @@ static void wl1271_fw_status(struct wl1271 *wl,
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
@@ -636,17 +657,30 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
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
+	 * By adding the freed blocks to tx_total_diff we are
+	 * actually moving them to RX poll
+	 */
+	wl->tx_total_diff += total;
+
+	/*
+	 * In case we have positive difference we can add the blocks to TX poll
+	 */
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
index ed4be73..1114b7c 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -267,6 +267,8 @@ struct wl1271_fw_sta_status {
 	u8  tx_total;
 	u8  reserved1;
 	__le16 reserved2;
+	/* Total structure size is 68 bytes */
+	u32 spare;
 } __packed;
 
 struct wl1271_fw_full_status {
@@ -397,6 +399,9 @@ struct wl1271 {
 	u32 tx_blocks_freed[NUM_TX_QUEUES];
 	u32 tx_blocks_available;
 	u32 tx_results_count;
+	/* Indicates How much Memory blocks should be moved to RX poll */
+	int tx_total_diff;
+	u32 tx_new_total;
 
 	/* Transmitted TX packets counter for chipset interface */
 	u32 tx_packets_count;
-- 
1.7.0.4

