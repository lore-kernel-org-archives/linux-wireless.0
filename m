Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61862 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab1AaQiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:38:07 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so5416771bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 08:38:06 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 3/4] wl12xx: use the conf struct instead of macros for memory configuration
Date: Mon, 31 Jan 2011 18:38:18 +0200
Message-Id: <1296491899-25440-4-git-send-email-eliad@wizery.com>
In-Reply-To: <1296491899-25440-1-git-send-email-eliad@wizery.com>
References: <1296491899-25440-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

make the configuration management more flexible by using the
conf struct, rather than predefined macros.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   16 ++++++++--------
 drivers/net/wireless/wl12xx/acx.h  |    4 ----
 drivers/net/wireless/wl12xx/conf.h |   12 ++++++++++++
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index f2fbda0..6ea19d7 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -961,10 +961,10 @@ int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 	}
 
 	/* memory config */
-	mem_conf->num_stations = DEFAULT_NUM_STATIONS;
-	mem_conf->rx_mem_block_num = ACX_RX_MEM_BLOCKS;
-	mem_conf->tx_min_mem_block_num = ACX_TX_MIN_MEM_BLOCKS;
-	mem_conf->num_ssid_profiles = ACX_NUM_SSID_PROFILES;
+	mem_conf->num_stations = wl->conf.mem.num_stations;
+	mem_conf->rx_mem_block_num = wl->conf.mem.rx_block_num;
+	mem_conf->tx_min_mem_block_num = wl->conf.mem.tx_min_block_num;
+	mem_conf->num_ssid_profiles = wl->conf.mem.ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
@@ -993,10 +993,10 @@ int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 	}
 
 	/* memory config */
-	mem_conf->num_stations = DEFAULT_NUM_STATIONS;
-	mem_conf->rx_mem_block_num = ACX_RX_MEM_BLOCKS;
-	mem_conf->tx_min_mem_block_num = ACX_TX_MIN_MEM_BLOCKS;
-	mem_conf->num_ssid_profiles = ACX_NUM_SSID_PROFILES;
+	mem_conf->num_stations = wl->conf.mem.num_stations;
+	mem_conf->rx_mem_block_num = wl->conf.mem.rx_block_num;
+	mem_conf->tx_min_mem_block_num = wl->conf.mem.tx_min_block_num;
+	mem_conf->num_ssid_profiles = wl->conf.mem.ssid_profiles;
 	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 	mem_conf->dyn_mem_enable = wl->conf.mem.dynamic_memory;
 	mem_conf->tx_free_req = wl->conf.mem.min_req_tx_blocks;
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index ba13d1b..9822e16 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -133,7 +133,6 @@ enum {
 
 #define DEFAULT_UCAST_PRIORITY          0
 #define DEFAULT_RX_Q_PRIORITY           0
-#define DEFAULT_NUM_STATIONS            1
 #define DEFAULT_RXQ_PRIORITY            0 /* low 0 .. 15 high  */
 #define DEFAULT_RXQ_TYPE                0x07    /* All frames, Data/Ctrl/Mgmt */
 #define TRACE_BUFFER_MAX_SIZE           256
@@ -797,10 +796,7 @@ struct acx_tx_config_options {
 	__le16 tx_compl_threshold;   /* number of packets */
 } __packed;
 
-#define ACX_RX_MEM_BLOCKS     70
-#define ACX_TX_MIN_MEM_BLOCKS 40
 #define ACX_TX_DESCRIPTORS    32
-#define ACX_NUM_SSID_PROFILES 1
 
 struct wl1271_acx_ap_config_memory {
 	struct acx_header header;
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index d8c1249..856a8a2 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1152,6 +1152,18 @@ struct conf_ht_setting {
 };
 
 struct conf_memory_settings {
+	/* Number of stations supported in IBSS mode */
+	u8 num_stations;
+
+	/* Number of ssid profiles used in IBSS mode */
+	u8 ssid_profiles;
+
+	/* Number of memory buffers allocated to rx pool */
+	u8 rx_block_num;
+
+	/* Minimum number of blocks allocated to tx pool */
+	u8 tx_min_block_num;
+
 	/* Disable/Enable dynamic memory */
 	u8 dynamic_memory;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index c8fe2b0..0f6786d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -299,6 +299,10 @@ static struct conf_drv_settings default_conf = {
 		.inactivity_timeout = 10000,
 	},
 	.mem = {
+		.num_stations                 = 1,
+		.ssid_profiles                = 1,
+		.rx_block_num                 = 70,
+		.tx_min_block_num             = 40,
 		.dynamic_memory               = 0,
 		.min_req_tx_blocks            = 104,
 		.min_req_rx_blocks            = 22,
-- 
1.7.0.4

