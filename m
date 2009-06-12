Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39181 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559AbZFLLSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:18:12 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 31/33] wl1251: use wl1251 prefix everywhere
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:39 +0300
Message-ID: <20090612111739.8877.69435.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Last we can change all code prefixes from wl12xx/WL12XX to
wl1251/WL1251.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251.h         |  102 +++---
 drivers/net/wireless/wl12xx/wl1251_acx.c     |  229 ++++++------
 drivers/net/wireless/wl12xx/wl1251_acx.h     |   76 ++--
 drivers/net/wireless/wl12xx/wl1251_boot.c    |  106 +++---
 drivers/net/wireless/wl12xx/wl1251_boot.h    |   10 -
 drivers/net/wireless/wl12xx/wl1251_cmd.c     |  133 ++++---
 drivers/net/wireless/wl12xx/wl1251_cmd.h     |   78 ++--
 drivers/net/wireless/wl12xx/wl1251_debugfs.c |   48 +--
 drivers/net/wireless/wl12xx/wl1251_debugfs.h |   14 -
 drivers/net/wireless/wl12xx/wl1251_event.c   |   46 +--
 drivers/net/wireless/wl12xx/wl1251_event.h   |   12 -
 drivers/net/wireless/wl12xx/wl1251_init.c    |   72 ++--
 drivers/net/wireless/wl12xx/wl1251_init.h    |   24 +
 drivers/net/wireless/wl12xx/wl1251_main.c    |  477 +++++++++++++-------------
 drivers/net/wireless/wl12xx/wl1251_netlink.c |  400 +++++++++++-----------
 drivers/net/wireless/wl12xx/wl1251_netlink.h |   12 -
 drivers/net/wireless/wl12xx/wl1251_ops.c     |  190 +++++-----
 drivers/net/wireless/wl12xx/wl1251_ops.h     |    4 
 drivers/net/wireless/wl12xx/wl1251_ps.c      |   56 ++-
 drivers/net/wireless/wl12xx/wl1251_ps.h      |   14 -
 drivers/net/wireless/wl12xx/wl1251_rx.c      |   52 +--
 drivers/net/wireless/wl12xx/wl1251_rx.h      |   20 +
 drivers/net/wireless/wl12xx/wl1251_spi.c     |  107 +++---
 drivers/net/wireless/wl12xx/wl1251_spi.h     |   44 +-
 drivers/net/wireless/wl12xx/wl1251_tx.c      |   70 ++--
 drivers/net/wireless/wl12xx/wl1251_tx.h      |    6 
 26 files changed, 1203 insertions(+), 1199 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index c673cdb..665aca0 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008-2009 Nokia Corporation
@@ -22,15 +22,15 @@
  *
  */
 
-#ifndef __WL12XX_H__
-#define __WL12XX_H__
+#ifndef __WL1251_H__
+#define __WL1251_H__
 
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/bitops.h>
 #include <net/mac80211.h>
 
-#define DRIVER_NAME "wl12xx"
+#define DRIVER_NAME "wl1251"
 #define DRIVER_PREFIX DRIVER_NAME ": "
 
 enum {
@@ -56,25 +56,25 @@ enum {
 
 #define DEBUG_DUMP_LIMIT 1024
 
-#define wl12xx_error(fmt, arg...) \
+#define wl1251_error(fmt, arg...) \
 	printk(KERN_ERR DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
 
-#define wl12xx_warning(fmt, arg...) \
+#define wl1251_warning(fmt, arg...) \
 	printk(KERN_WARNING DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
 
-#define wl12xx_notice(fmt, arg...) \
+#define wl1251_notice(fmt, arg...) \
 	printk(KERN_INFO DRIVER_PREFIX fmt "\n", ##arg)
 
-#define wl12xx_info(fmt, arg...) \
+#define wl1251_info(fmt, arg...) \
 	printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg)
 
-#define wl12xx_debug(level, fmt, arg...) \
+#define wl1251_debug(level, fmt, arg...) \
 	do { \
 		if (level & DEBUG_LEVEL) \
 			printk(KERN_DEBUG DRIVER_PREFIX fmt "\n", ##arg); \
 	} while (0)
 
-#define wl12xx_dump(level, prefix, buf, len)	\
+#define wl1251_dump(level, prefix, buf, len)	\
 	do { \
 		if (level & DEBUG_LEVEL) \
 			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
@@ -84,7 +84,7 @@ enum {
 				       0);				\
 	} while (0)
 
-#define wl12xx_dump_ascii(level, prefix, buf, len)	\
+#define wl1251_dump_ascii(level, prefix, buf, len)	\
 	do { \
 		if (level & DEBUG_LEVEL) \
 			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
@@ -94,10 +94,10 @@ enum {
 				       true);				\
 	} while (0)
 
-#define WL12XX_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
+#define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
 				  CFG_BSSID_FILTER_EN)
 
-#define WL12XX_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
+#define WL1251_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
 				  CFG_RX_MGMT_EN |  \
 				  CFG_RX_DATA_EN |  \
 				  CFG_RX_CTL_EN |   \
@@ -105,7 +105,7 @@ enum {
 				  CFG_RX_AUTH_EN |  \
 				  CFG_RX_ASSOC_EN)
 
-#define WL12XX_BUSY_WORD_LEN 8
+#define WL1251_BUSY_WORD_LEN 8
 
 struct boot_attr {
 	u32 radio_type;
@@ -117,13 +117,13 @@ struct boot_attr {
 	u32 bugfix;
 };
 
-enum wl12xx_state {
-	WL12XX_STATE_OFF,
-	WL12XX_STATE_ON,
-	WL12XX_STATE_PLT,
+enum wl1251_state {
+	WL1251_STATE_OFF,
+	WL1251_STATE_ON,
+	WL1251_STATE_PLT,
 };
 
-enum wl12xx_partition_type {
+enum wl1251_partition_type {
 	PART_DOWN,
 	PART_WORK,
 	PART_DRPW,
@@ -131,20 +131,20 @@ enum wl12xx_partition_type {
 	PART_TABLE_LEN
 };
 
-struct wl12xx_partition {
+struct wl1251_partition {
 	u32 size;
 	u32 start;
 };
 
-struct wl12xx_partition_set {
-	struct wl12xx_partition mem;
-	struct wl12xx_partition reg;
+struct wl1251_partition_set {
+	struct wl1251_partition mem;
+	struct wl1251_partition reg;
 };
 
-struct wl12xx;
+struct wl1251;
 
 /* FIXME: I'm not sure about this structure name */
-struct wl12xx_chip {
+struct wl1251_chip {
 	u32 id;
 
 	const char *fw_filename;
@@ -156,23 +156,23 @@ struct wl12xx_chip {
 	int intr_cmd_complete;
 	int intr_init_complete;
 
-	int (*op_upload_fw)(struct wl12xx *wl);
-	int (*op_upload_nvs)(struct wl12xx *wl);
-	int (*op_boot)(struct wl12xx *wl);
-	void (*op_set_ecpu_ctrl)(struct wl12xx *wl, u32 flag);
-	void (*op_target_enable_interrupts)(struct wl12xx *wl);
-	int (*op_hw_init)(struct wl12xx *wl);
-	int (*op_plt_init)(struct wl12xx *wl);
-	void (*op_tx_flush)(struct wl12xx *wl);
-	void (*op_fw_version)(struct wl12xx *wl);
-	int (*op_cmd_join)(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+	int (*op_upload_fw)(struct wl1251 *wl);
+	int (*op_upload_nvs)(struct wl1251 *wl);
+	int (*op_boot)(struct wl1251 *wl);
+	void (*op_set_ecpu_ctrl)(struct wl1251 *wl, u32 flag);
+	void (*op_target_enable_interrupts)(struct wl1251 *wl);
+	int (*op_hw_init)(struct wl1251 *wl);
+	int (*op_plt_init)(struct wl1251 *wl);
+	void (*op_tx_flush)(struct wl1251 *wl);
+	void (*op_fw_version)(struct wl1251 *wl);
+	int (*op_cmd_join)(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
 			    u16 beacon_interval, u8 wait);
 
-	struct wl12xx_partition_set *p_table;
+	struct wl1251_partition_set *p_table;
 	enum wl12xx_acx_int_reg *acx_reg_table;
 };
 
-struct wl12xx_stats {
+struct wl1251_stats {
 	struct acx_statistics *fw_stats;
 	unsigned long fw_stats_update;
 
@@ -180,7 +180,7 @@ struct wl12xx_stats {
 	unsigned int excessive_retries;
 };
 
-struct wl12xx_debugfs {
+struct wl1251_debugfs {
 	struct dentry *rootdir;
 	struct dentry *fw_statistics;
 
@@ -281,7 +281,7 @@ struct wl12xx_debugfs {
 	struct dentry *excessive_retries;
 };
 
-struct wl12xx {
+struct wl1251 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
 
@@ -290,7 +290,7 @@ struct wl12xx {
 	void (*set_power)(bool enable);
 	int irq;
 
-	enum wl12xx_state state;
+	enum wl1251_state state;
 	struct mutex mutex;
 
 	int physical_mem_addr;
@@ -298,7 +298,7 @@ struct wl12xx {
 	int virtual_mem_addr;
 	int virtual_reg_addr;
 
-	struct wl12xx_chip chip;
+	struct wl1251_chip chip;
 
 	int cmd_box_addr;
 	int event_box_addr;
@@ -385,31 +385,31 @@ struct wl12xx {
 	/* in dBm */
 	int power_level;
 
-	struct wl12xx_stats stats;
-	struct wl12xx_debugfs debugfs;
+	struct wl1251_stats stats;
+	struct wl1251_debugfs debugfs;
 
 	u32 buffer_32;
 	u32 buffer_cmd;
-	u8 buffer_busyword[WL12XX_BUSY_WORD_LEN];
-	struct wl12xx_rx_descriptor *rx_descriptor;
+	u8 buffer_busyword[WL1251_BUSY_WORD_LEN];
+	struct wl1251_rx_descriptor *rx_descriptor;
 };
 
-int wl12xx_plt_start(struct wl12xx *wl);
-int wl12xx_plt_stop(struct wl12xx *wl);
+int wl1251_plt_start(struct wl1251 *wl);
+int wl1251_plt_stop(struct wl1251 *wl);
 
 #define DEFAULT_HW_GEN_MODULATION_TYPE    CCK_LONG /* Long Preamble */
 #define DEFAULT_HW_GEN_TX_RATE          RATE_2MBPS
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
-#define WL12XX_DEFAULT_POWER_LEVEL 20
+#define WL1251_DEFAULT_POWER_LEVEL 20
 
-#define WL12XX_TX_QUEUE_MAX_LENGTH 20
+#define WL1251_TX_QUEUE_MAX_LENGTH 20
 
 /* Different chips need different sleep times after power on.  WL1271 needs
  * 200ms, WL1251 needs only 10ms.  By default we use 200ms, but as soon as we
- * know the chip ID, we change the sleep value in the wl12xx chip structure,
+ * know the chip ID, we change the sleep value in the wl1251 chip structure,
  * so in subsequent power ons, we don't waste more time then needed.  */
-#define WL12XX_DEFAULT_POWER_ON_SLEEP 200
+#define WL1251_DEFAULT_POWER_ON_SLEEP 200
 
 #define CHIP_ID_1251_PG10	           (0x7010101)
 #define CHIP_ID_1251_PG11	           (0x7020101)
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 1a840fa..5a8d21c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -5,18 +5,17 @@
 #include <linux/spi/spi.h>
 
 #include "wl1251.h"
-#include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 #include "wl1251_ps.h"
 
-int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
+int wl1251_acx_frame_rates(struct wl1251 *wl, u8 ctrl_rate, u8 ctrl_mod,
 			   u8 mgt_rate, u8 mgt_mod)
 {
 	struct acx_fw_gen_frame_rates *rates;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx frame rates");
+	wl1251_debug(DEBUG_ACX, "acx frame rates");
 
 	rates = kzalloc(sizeof(*rates), GFP_KERNEL);
 	if (!rates) {
@@ -29,10 +28,10 @@ int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
 	rates->tx_mgt_frame_rate = mgt_rate;
 	rates->tx_mgt_frame_mod = mgt_mod;
 
-	ret = wl12xx_cmd_configure(wl, ACX_FW_GEN_FRAME_RATES,
+	ret = wl1251_cmd_configure(wl, ACX_FW_GEN_FRAME_RATES,
 				   rates, sizeof(*rates));
 	if (ret < 0) {
-		wl12xx_error("Failed to set FW rates and modulation");
+		wl1251_error("Failed to set FW rates and modulation");
 		goto out;
 	}
 
@@ -42,12 +41,12 @@ out:
 }
 
 
-int wl12xx_acx_station_id(struct wl12xx *wl)
+int wl1251_acx_station_id(struct wl1251 *wl)
 {
 	struct acx_dot11_station_id *mac;
 	int ret, i;
 
-	wl12xx_debug(DEBUG_ACX, "acx dot11_station_id");
+	wl1251_debug(DEBUG_ACX, "acx dot11_station_id");
 
 	mac = kzalloc(sizeof(*mac), GFP_KERNEL);
 	if (!mac) {
@@ -58,7 +57,7 @@ int wl12xx_acx_station_id(struct wl12xx *wl)
 	for (i = 0; i < ETH_ALEN; i++)
 		mac->mac[i] = wl->mac_addr[ETH_ALEN - 1 - i];
 
-	ret = wl12xx_cmd_configure(wl, DOT11_STATION_ID, mac, sizeof(*mac));
+	ret = wl1251_cmd_configure(wl, DOT11_STATION_ID, mac, sizeof(*mac));
 	if (ret < 0)
 		goto out;
 
@@ -67,12 +66,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id)
+int wl1251_acx_default_key(struct wl1251 *wl, u8 key_id)
 {
 	struct acx_dot11_default_key *default_key;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx dot11_default_key (%d)", key_id);
+	wl1251_debug(DEBUG_ACX, "acx dot11_default_key (%d)", key_id);
 
 	default_key = kzalloc(sizeof(*default_key), GFP_KERNEL);
 	if (!default_key) {
@@ -82,10 +81,10 @@ int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id)
 
 	default_key->id = key_id;
 
-	ret = wl12xx_cmd_configure(wl, DOT11_DEFAULT_KEY,
+	ret = wl1251_cmd_configure(wl, DOT11_DEFAULT_KEY,
 				   default_key, sizeof(*default_key));
 	if (ret < 0) {
-		wl12xx_error("Couldnt set default key");
+		wl1251_error("Couldnt set default key");
 		goto out;
 	}
 
@@ -96,13 +95,13 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+int wl1251_acx_wake_up_conditions(struct wl1251 *wl, u8 wake_up_event,
 				  u8 listen_interval)
 {
 	struct acx_wake_up_condition *wake_up;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx wake up conditions");
+	wl1251_debug(DEBUG_ACX, "acx wake up conditions");
 
 	wake_up = kzalloc(sizeof(*wake_up), GFP_KERNEL);
 	if (!wake_up) {
@@ -113,10 +112,10 @@ int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
 	wake_up->wake_up_event = wake_up_event;
 	wake_up->listen_interval = listen_interval;
 
-	ret = wl12xx_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
+	ret = wl1251_cmd_configure(wl, ACX_WAKE_UP_CONDITIONS,
 				   wake_up, sizeof(*wake_up));
 	if (ret < 0) {
-		wl12xx_warning("could not set wake up conditions: %d", ret);
+		wl1251_warning("could not set wake up conditions: %d", ret);
 		goto out;
 	}
 
@@ -125,12 +124,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth)
+int wl1251_acx_sleep_auth(struct wl1251 *wl, u8 sleep_auth)
 {
 	struct acx_sleep_auth *auth;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx sleep auth");
+	wl1251_debug(DEBUG_ACX, "acx sleep auth");
 
 	auth = kzalloc(sizeof(*auth), GFP_KERNEL);
 	if (!auth) {
@@ -140,7 +139,7 @@ int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth)
 
 	auth->sleep_auth = sleep_auth;
 
-	ret = wl12xx_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
+	ret = wl1251_cmd_configure(wl, ACX_SLEEP_AUTH, auth, sizeof(*auth));
 	if (ret < 0)
 		return ret;
 
@@ -149,12 +148,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
+int wl1251_acx_fw_version(struct wl1251 *wl, char *buf, size_t len)
 {
 	struct acx_revision *rev;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx fw rev");
+	wl1251_debug(DEBUG_ACX, "acx fw rev");
 
 	rev = kzalloc(sizeof(*rev), GFP_KERNEL);
 	if (!rev) {
@@ -162,9 +161,9 @@ int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len)
 		goto out;
 	}
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
+	ret = wl1251_cmd_interrogate(wl, ACX_FW_REV, rev, sizeof(*rev));
 	if (ret < 0) {
-		wl12xx_warning("ACX_FW_REV interrogate failed");
+		wl1251_warning("ACX_FW_REV interrogate failed");
 		goto out;
 	}
 
@@ -183,12 +182,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
+int wl1251_acx_tx_power(struct wl1251 *wl, int power)
 {
 	struct acx_current_tx_power *acx;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
+	wl1251_debug(DEBUG_ACX, "acx dot11_cur_tx_pwr");
 
 	if (power < 0 || power > 25)
 		return -EINVAL;
@@ -201,9 +200,9 @@ int wl12xx_acx_tx_power(struct wl12xx *wl, int power)
 
 	acx->current_tx_power = power * 10;
 
-	ret = wl12xx_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
+	ret = wl1251_cmd_configure(wl, DOT11_CUR_TX_PWR, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_warning("configure of tx power failed: %d", ret);
+		wl1251_warning("configure of tx power failed: %d", ret);
 		goto out;
 	}
 
@@ -212,12 +211,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_feature_cfg(struct wl12xx *wl)
+int wl1251_acx_feature_cfg(struct wl1251 *wl)
 {
 	struct acx_feature_config *feature;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx feature cfg");
+	wl1251_debug(DEBUG_ACX, "acx feature cfg");
 
 	feature = kzalloc(sizeof(*feature), GFP_KERNEL);
 	if (!feature) {
@@ -229,10 +228,10 @@ int wl12xx_acx_feature_cfg(struct wl12xx *wl)
 	feature->data_flow_options = 0;
 	feature->options = 0;
 
-	ret = wl12xx_cmd_configure(wl, ACX_FEATURE_CFG,
+	ret = wl1251_cmd_configure(wl, ACX_FEATURE_CFG,
 				   feature, sizeof(*feature));
 	if (ret < 0) {
-		wl12xx_error("Couldnt set HW encryption");
+		wl1251_error("Couldnt set HW encryption");
 		goto out;
 	}
 
@@ -241,27 +240,27 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_mem_map(struct wl12xx *wl, struct acx_header *mem_map,
+int wl1251_acx_mem_map(struct wl1251 *wl, struct acx_header *mem_map,
 		       size_t len)
 {
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx mem map");
+	wl1251_debug(DEBUG_ACX, "acx mem map");
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
+	ret = wl1251_cmd_interrogate(wl, ACX_MEM_MAP, mem_map, len);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_acx_data_path_params(struct wl12xx *wl,
+int wl1251_acx_data_path_params(struct wl1251 *wl,
 				struct acx_data_path_params_resp *resp)
 {
 	struct acx_data_path_params *params;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx data path params");
+	wl1251_debug(DEBUG_ACX, "acx data path params");
 
 	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (!params) {
@@ -281,20 +280,20 @@ int wl12xx_acx_data_path_params(struct wl12xx *wl,
 
 	params->tx_complete_timeout = DP_TX_COMPLETE_TIME_OUT;
 
-	ret = wl12xx_cmd_configure(wl, ACX_DATA_PATH_PARAMS,
+	ret = wl1251_cmd_configure(wl, ACX_DATA_PATH_PARAMS,
 				   params, sizeof(*params));
 	if (ret < 0)
 		goto out;
 
 	/* FIXME: shouldn't this be ACX_DATA_PATH_RESP_PARAMS? */
-	ret = wl12xx_cmd_interrogate(wl, ACX_DATA_PATH_PARAMS,
+	ret = wl1251_cmd_interrogate(wl, ACX_DATA_PATH_PARAMS,
 				     resp, sizeof(*resp));
 
 	if (ret < 0) {
-		wl12xx_warning("failed to read data path parameters: %d", ret);
+		wl1251_warning("failed to read data path parameters: %d", ret);
 		goto out;
 	} else if (resp->header.cmd.status != CMD_STATUS_SUCCESS) {
-		wl12xx_warning("data path parameter acx status failed");
+		wl1251_warning("data path parameter acx status failed");
 		ret = -EIO;
 		goto out;
 	}
@@ -304,12 +303,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
+int wl1251_acx_rx_msdu_life_time(struct wl1251 *wl, u32 life_time)
 {
 	struct acx_rx_msdu_lifetime *acx;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx rx msdu life time");
+	wl1251_debug(DEBUG_ACX, "acx rx msdu life time");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -318,10 +317,10 @@ int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time)
 	}
 
 	acx->lifetime = life_time;
-	ret = wl12xx_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
+	ret = wl1251_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
 				   acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_warning("failed to set rx msdu life time: %d", ret);
+		wl1251_warning("failed to set rx msdu life time: %d", ret);
 		goto out;
 	}
 
@@ -330,12 +329,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter)
+int wl1251_acx_rx_config(struct wl1251 *wl, u32 config, u32 filter)
 {
 	struct acx_rx_config *rx_config;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx rx config");
+	wl1251_debug(DEBUG_ACX, "acx rx config");
 
 	rx_config = kzalloc(sizeof(*rx_config), GFP_KERNEL);
 	if (!rx_config) {
@@ -346,10 +345,10 @@ int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter)
 	rx_config->config_options = config;
 	rx_config->filter_options = filter;
 
-	ret = wl12xx_cmd_configure(wl, ACX_RX_CFG,
+	ret = wl1251_cmd_configure(wl, ACX_RX_CFG,
 				   rx_config, sizeof(*rx_config));
 	if (ret < 0) {
-		wl12xx_warning("failed to set rx config: %d", ret);
+		wl1251_warning("failed to set rx config: %d", ret);
 		goto out;
 	}
 
@@ -358,12 +357,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_pd_threshold(struct wl12xx *wl)
+int wl1251_acx_pd_threshold(struct wl1251 *wl)
 {
 	struct acx_packet_detection *pd;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx data pd threshold");
+	wl1251_debug(DEBUG_ACX, "acx data pd threshold");
 
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd) {
@@ -373,9 +372,9 @@ int wl12xx_acx_pd_threshold(struct wl12xx *wl)
 
 	/* FIXME: threshold value not set */
 
-	ret = wl12xx_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
+	ret = wl1251_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
 	if (ret < 0) {
-		wl12xx_warning("failed to set pd threshold: %d", ret);
+		wl1251_warning("failed to set pd threshold: %d", ret);
 		goto out;
 	}
 
@@ -384,12 +383,12 @@ out:
 	return 0;
 }
 
-int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time)
+int wl1251_acx_slot(struct wl1251 *wl, enum acx_slot_type slot_time)
 {
 	struct acx_slot *slot;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx slot");
+	wl1251_debug(DEBUG_ACX, "acx slot");
 
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
@@ -400,9 +399,9 @@ int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time)
 	slot->wone_index = STATION_WONE_INDEX;
 	slot->slot_time = slot_time;
 
-	ret = wl12xx_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
+	ret = wl1251_cmd_configure(wl, ACX_SLOT, slot, sizeof(*slot));
 	if (ret < 0) {
-		wl12xx_warning("failed to set slot time: %d", ret);
+		wl1251_warning("failed to set slot time: %d", ret);
 		goto out;
 	}
 
@@ -411,12 +410,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_group_address_tbl(struct wl12xx *wl)
+int wl1251_acx_group_address_tbl(struct wl1251 *wl)
 {
 	struct acx_dot11_grp_addr_tbl *acx;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx group address tbl");
+	wl1251_debug(DEBUG_ACX, "acx group address tbl");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -429,10 +428,10 @@ int wl12xx_acx_group_address_tbl(struct wl12xx *wl)
 	acx->num_groups = 0;
 	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
 
-	ret = wl12xx_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
+	ret = wl1251_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
 				   acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_warning("failed to set group addr table: %d", ret);
+		wl1251_warning("failed to set group addr table: %d", ret);
 		goto out;
 	}
 
@@ -441,7 +440,7 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_service_period_timeout(struct wl12xx *wl)
+int wl1251_acx_service_period_timeout(struct wl1251 *wl)
 {
 	struct acx_rx_timeout *rx_timeout;
 	int ret;
@@ -452,15 +451,15 @@ int wl12xx_acx_service_period_timeout(struct wl12xx *wl)
 		goto out;
 	}
 
-	wl12xx_debug(DEBUG_ACX, "acx service period timeout");
+	wl1251_debug(DEBUG_ACX, "acx service period timeout");
 
 	rx_timeout->ps_poll_timeout = RX_TIMEOUT_PS_POLL_DEF;
 	rx_timeout->upsd_timeout = RX_TIMEOUT_UPSD_DEF;
 
-	ret = wl12xx_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
+	ret = wl1251_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
 				   rx_timeout, sizeof(*rx_timeout));
 	if (ret < 0) {
-		wl12xx_warning("failed to set service period timeout: %d",
+		wl1251_warning("failed to set service period timeout: %d",
 			       ret);
 		goto out;
 	}
@@ -470,12 +469,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold)
+int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold)
 {
 	struct acx_rts_threshold *rts;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx rts threshold");
+	wl1251_debug(DEBUG_ACX, "acx rts threshold");
 
 	rts = kzalloc(sizeof(*rts), GFP_KERNEL);
 	if (!rts) {
@@ -485,9 +484,9 @@ int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold)
 
 	rts->threshold = rts_threshold;
 
-	ret = wl12xx_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
+	ret = wl1251_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
 	if (ret < 0) {
-		wl12xx_warning("failed to set rts threshold: %d", ret);
+		wl1251_warning("failed to set rts threshold: %d", ret);
 		goto out;
 	}
 
@@ -496,12 +495,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl)
+int wl1251_acx_beacon_filter_opt(struct wl1251 *wl)
 {
 	struct acx_beacon_filter_option *beacon_filter;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx beacon filter opt");
+	wl1251_debug(DEBUG_ACX, "acx beacon filter opt");
 
 	beacon_filter = kzalloc(sizeof(*beacon_filter), GFP_KERNEL);
 	if (!beacon_filter) {
@@ -512,10 +511,10 @@ int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl)
 	beacon_filter->enable = 0;
 	beacon_filter->max_num_beacons = 0;
 
-	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
+	ret = wl1251_cmd_configure(wl, ACX_BEACON_FILTER_OPT,
 				   beacon_filter, sizeof(*beacon_filter));
 	if (ret < 0) {
-		wl12xx_warning("failed to set beacon filter opt: %d", ret);
+		wl1251_warning("failed to set beacon filter opt: %d", ret);
 		goto out;
 	}
 
@@ -524,12 +523,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_beacon_filter_table(struct wl12xx *wl)
+int wl1251_acx_beacon_filter_table(struct wl1251 *wl)
 {
 	struct acx_beacon_filter_ie_table *ie_table;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx beacon filter table");
+	wl1251_debug(DEBUG_ACX, "acx beacon filter table");
 
 	ie_table = kzalloc(sizeof(*ie_table), GFP_KERNEL);
 	if (!ie_table) {
@@ -540,10 +539,10 @@ int wl12xx_acx_beacon_filter_table(struct wl12xx *wl)
 	ie_table->num_ie = 0;
 	memset(ie_table->table, 0, BEACON_FILTER_TABLE_MAX_SIZE);
 
-	ret = wl12xx_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
+	ret = wl1251_cmd_configure(wl, ACX_BEACON_FILTER_TABLE,
 				   ie_table, sizeof(*ie_table));
 	if (ret < 0) {
-		wl12xx_warning("failed to set beacon filter table: %d", ret);
+		wl1251_warning("failed to set beacon filter table: %d", ret);
 		goto out;
 	}
 
@@ -552,12 +551,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_sg_enable(struct wl12xx *wl)
+int wl1251_acx_sg_enable(struct wl1251 *wl)
 {
 	struct acx_bt_wlan_coex *pta;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx sg enable");
+	wl1251_debug(DEBUG_ACX, "acx sg enable");
 
 	pta = kzalloc(sizeof(*pta), GFP_KERNEL);
 	if (!pta) {
@@ -567,9 +566,9 @@ int wl12xx_acx_sg_enable(struct wl12xx *wl)
 
 	pta->enable = SG_ENABLE;
 
-	ret = wl12xx_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
+	ret = wl1251_cmd_configure(wl, ACX_SG_ENABLE, pta, sizeof(*pta));
 	if (ret < 0) {
-		wl12xx_warning("failed to set softgemini enable: %d", ret);
+		wl1251_warning("failed to set softgemini enable: %d", ret);
 		goto out;
 	}
 
@@ -578,12 +577,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_sg_cfg(struct wl12xx *wl)
+int wl1251_acx_sg_cfg(struct wl1251 *wl)
 {
 	struct acx_bt_wlan_coex_param *param;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx sg cfg");
+	wl1251_debug(DEBUG_ACX, "acx sg cfg");
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
 	if (!param) {
@@ -621,9 +620,9 @@ int wl12xx_acx_sg_cfg(struct wl12xx *wl)
 	param->pta_auto_mode_enable = PTA_AUTO_MODE_NO_CTS_DEF;
 	param->bt_hp_respected_num = PTA_BT_HP_RESPECTED_DEF;
 
-	ret = wl12xx_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
+	ret = wl1251_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
 	if (ret < 0) {
-		wl12xx_warning("failed to set sg config: %d", ret);
+		wl1251_warning("failed to set sg config: %d", ret);
 		goto out;
 	}
 
@@ -632,12 +631,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_cca_threshold(struct wl12xx *wl)
+int wl1251_acx_cca_threshold(struct wl1251 *wl)
 {
 	struct acx_energy_detection *detection;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx cca threshold");
+	wl1251_debug(DEBUG_ACX, "acx cca threshold");
 
 	detection = kzalloc(sizeof(*detection), GFP_KERNEL);
 	if (!detection) {
@@ -648,10 +647,10 @@ int wl12xx_acx_cca_threshold(struct wl12xx *wl)
 	detection->rx_cca_threshold = CCA_THRSH_DISABLE_ENERGY_D;
 	detection->tx_energy_detection = 0;
 
-	ret = wl12xx_cmd_configure(wl, ACX_CCA_THRESHOLD,
+	ret = wl1251_cmd_configure(wl, ACX_CCA_THRESHOLD,
 				   detection, sizeof(*detection));
 	if (ret < 0) {
-		wl12xx_warning("failed to set cca threshold: %d", ret);
+		wl1251_warning("failed to set cca threshold: %d", ret);
 		return ret;
 	}
 
@@ -660,12 +659,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl)
+int wl1251_acx_bcn_dtim_options(struct wl1251 *wl)
 {
 	struct acx_beacon_broadcast *bb;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx bcn dtim options");
+	wl1251_debug(DEBUG_ACX, "acx bcn dtim options");
 
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb) {
@@ -678,9 +677,9 @@ int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl)
 	bb->rx_broadcast_in_ps = RX_BROADCAST_IN_PS_DEF_VALUE;
 	bb->ps_poll_threshold = CONSECUTIVE_PS_POLL_FAILURE_DEF;
 
-	ret = wl12xx_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
+	ret = wl1251_cmd_configure(wl, ACX_BCN_DTIM_OPTIONS, bb, sizeof(*bb));
 	if (ret < 0) {
-		wl12xx_warning("failed to set rx config: %d", ret);
+		wl1251_warning("failed to set rx config: %d", ret);
 		goto out;
 	}
 
@@ -689,12 +688,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_aid(struct wl12xx *wl, u16 aid)
+int wl1251_acx_aid(struct wl1251 *wl, u16 aid)
 {
 	struct acx_aid *acx_aid;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx aid");
+	wl1251_debug(DEBUG_ACX, "acx aid");
 
 	acx_aid = kzalloc(sizeof(*acx_aid), GFP_KERNEL);
 	if (!acx_aid) {
@@ -704,9 +703,9 @@ int wl12xx_acx_aid(struct wl12xx *wl, u16 aid)
 
 	acx_aid->aid = aid;
 
-	ret = wl12xx_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
+	ret = wl1251_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
 	if (ret < 0) {
-		wl12xx_warning("failed to set aid: %d", ret);
+		wl1251_warning("failed to set aid: %d", ret);
 		goto out;
 	}
 
@@ -715,12 +714,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
+int wl1251_acx_event_mbox_mask(struct wl1251 *wl, u32 event_mask)
 {
 	struct acx_event_mask *mask;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx event mbox mask");
+	wl1251_debug(DEBUG_ACX, "acx event mbox mask");
 
 	mask = kzalloc(sizeof(*mask), GFP_KERNEL);
 	if (!mask) {
@@ -733,10 +732,10 @@ int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
 
 	mask->event_mask = event_mask;
 
-	ret = wl12xx_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
+	ret = wl1251_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
 				   mask, sizeof(*mask));
 	if (ret < 0) {
-		wl12xx_warning("failed to set acx_event_mbox_mask: %d", ret);
+		wl1251_warning("failed to set acx_event_mbox_mask: %d", ret);
 		goto out;
 	}
 
@@ -745,12 +744,12 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble)
+int wl1251_acx_set_preamble(struct wl1251 *wl, enum acx_preamble_type preamble)
 {
 	struct acx_preamble *acx;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx_set_preamble");
+	wl1251_debug(DEBUG_ACX, "acx_set_preamble");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -760,9 +759,9 @@ int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble)
 
 	acx->preamble = preamble;
 
-	ret = wl12xx_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
+	ret = wl1251_cmd_configure(wl, ACX_PREAMBLE_TYPE, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_warning("Setting of preamble failed: %d", ret);
+		wl1251_warning("Setting of preamble failed: %d", ret);
 		goto out;
 	}
 
@@ -771,13 +770,13 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_cts_protect(struct wl12xx *wl,
+int wl1251_acx_cts_protect(struct wl1251 *wl,
 			   enum acx_ctsprotect_type ctsprotect)
 {
 	struct acx_ctsprotect *acx;
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx_set_ctsprotect");
+	wl1251_debug(DEBUG_ACX, "acx_set_ctsprotect");
 
 	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
 	if (!acx) {
@@ -787,9 +786,9 @@ int wl12xx_acx_cts_protect(struct wl12xx *wl,
 
 	acx->ctsprotect = ctsprotect;
 
-	ret = wl12xx_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
+	ret = wl1251_cmd_configure(wl, ACX_CTS_PROTECTION, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_warning("Setting of ctsprotect failed: %d", ret);
+		wl1251_warning("Setting of ctsprotect failed: %d", ret);
 		goto out;
 	}
 
@@ -798,7 +797,7 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime)
+int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime)
 {
 	struct acx_tsf_info *tsf_info;
 	int ret;
@@ -809,10 +808,10 @@ int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime)
 		goto out;
 	}
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_TSF_INFO,
+	ret = wl1251_cmd_interrogate(wl, ACX_TSF_INFO,
 				     tsf_info, sizeof(*tsf_info));
 	if (ret < 0) {
-		wl12xx_warning("ACX_FW_REV interrogate failed");
+		wl1251_warning("ACX_FW_REV interrogate failed");
 		goto out;
 	}
 
@@ -824,16 +823,16 @@ out:
 	return ret;
 }
 
-int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats)
+int wl1251_acx_statistics(struct wl1251 *wl, struct acx_statistics *stats)
 {
 	int ret;
 
-	wl12xx_debug(DEBUG_ACX, "acx statistics");
+	wl1251_debug(DEBUG_ACX, "acx statistics");
 
-	ret = wl12xx_cmd_interrogate(wl, ACX_STATISTICS, stats,
+	ret = wl1251_cmd_interrogate(wl, ACX_STATISTICS, stats,
 				     sizeof(*stats));
 	if (ret < 0) {
-		wl12xx_warning("acx statistics failed: %d", ret);
+		wl1251_warning("acx statistics failed: %d", ret);
 		return -ENOMEM;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index a239120..2e7b193 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -22,15 +22,15 @@
  *
  */
 
-#ifndef __WL12XX_ACX_H__
-#define __WL12XX_ACX_H__
+#ifndef __WL1251_ACX_H__
+#define __WL1251_ACX_H__
 
 #include "wl1251.h"
 #include "wl1251_cmd.h"
 
 /* Target's information element */
 struct acx_header {
-	struct wl12xx_cmd_header cmd;
+	struct wl1251_cmd_header cmd;
 
 	/* acx (or information element) header */
 	u16 id;
@@ -91,15 +91,15 @@ struct acx_revision {
 	u32 hw_version;
 } __attribute__ ((packed));
 
-enum wl12xx_psm_mode {
+enum wl1251_psm_mode {
 	/* Active mode */
-	WL12XX_PSM_CAM = 0,
+	WL1251_PSM_CAM = 0,
 
 	/* Power save mode */
-	WL12XX_PSM_PS = 1,
+	WL1251_PSM_PS = 1,
 
 	/* Extreme low power */
-	WL12XX_PSM_ELP = 2,
+	WL1251_PSM_ELP = 2,
 };
 
 struct acx_sleep_auth {
@@ -1108,39 +1108,39 @@ enum {
 };
 
 
-int wl12xx_acx_frame_rates(struct wl12xx *wl, u8 ctrl_rate, u8 ctrl_mod,
+int wl1251_acx_frame_rates(struct wl1251 *wl, u8 ctrl_rate, u8 ctrl_mod,
 			   u8 mgt_rate, u8 mgt_mod);
-int wl12xx_acx_station_id(struct wl12xx *wl);
-int wl12xx_acx_default_key(struct wl12xx *wl, u8 key_id);
-int wl12xx_acx_wake_up_conditions(struct wl12xx *wl, u8 wake_up_event,
+int wl1251_acx_station_id(struct wl1251 *wl);
+int wl1251_acx_default_key(struct wl1251 *wl, u8 key_id);
+int wl1251_acx_wake_up_conditions(struct wl1251 *wl, u8 wake_up_event,
 				  u8 listen_interval);
-int wl12xx_acx_sleep_auth(struct wl12xx *wl, u8 sleep_auth);
-int wl12xx_acx_fw_version(struct wl12xx *wl, char *buf, size_t len);
-int wl12xx_acx_tx_power(struct wl12xx *wl, int power);
-int wl12xx_acx_feature_cfg(struct wl12xx *wl);
-int wl12xx_acx_mem_map(struct wl12xx *wl,
+int wl1251_acx_sleep_auth(struct wl1251 *wl, u8 sleep_auth);
+int wl1251_acx_fw_version(struct wl1251 *wl, char *buf, size_t len);
+int wl1251_acx_tx_power(struct wl1251 *wl, int power);
+int wl1251_acx_feature_cfg(struct wl1251 *wl);
+int wl1251_acx_mem_map(struct wl1251 *wl,
 		       struct acx_header *mem_map, size_t len);
-int wl12xx_acx_data_path_params(struct wl12xx *wl,
+int wl1251_acx_data_path_params(struct wl1251 *wl,
 				struct acx_data_path_params_resp *data_path);
-int wl12xx_acx_rx_msdu_life_time(struct wl12xx *wl, u32 life_time);
-int wl12xx_acx_rx_config(struct wl12xx *wl, u32 config, u32 filter);
-int wl12xx_acx_pd_threshold(struct wl12xx *wl);
-int wl12xx_acx_slot(struct wl12xx *wl, enum acx_slot_type slot_time);
-int wl12xx_acx_group_address_tbl(struct wl12xx *wl);
-int wl12xx_acx_service_period_timeout(struct wl12xx *wl);
-int wl12xx_acx_rts_threshold(struct wl12xx *wl, u16 rts_threshold);
-int wl12xx_acx_beacon_filter_opt(struct wl12xx *wl);
-int wl12xx_acx_beacon_filter_table(struct wl12xx *wl);
-int wl12xx_acx_sg_enable(struct wl12xx *wl);
-int wl12xx_acx_sg_cfg(struct wl12xx *wl);
-int wl12xx_acx_cca_threshold(struct wl12xx *wl);
-int wl12xx_acx_bcn_dtim_options(struct wl12xx *wl);
-int wl12xx_acx_aid(struct wl12xx *wl, u16 aid);
-int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask);
-int wl12xx_acx_set_preamble(struct wl12xx *wl, enum acx_preamble_type preamble);
-int wl12xx_acx_cts_protect(struct wl12xx *wl,
+int wl1251_acx_rx_msdu_life_time(struct wl1251 *wl, u32 life_time);
+int wl1251_acx_rx_config(struct wl1251 *wl, u32 config, u32 filter);
+int wl1251_acx_pd_threshold(struct wl1251 *wl);
+int wl1251_acx_slot(struct wl1251 *wl, enum acx_slot_type slot_time);
+int wl1251_acx_group_address_tbl(struct wl1251 *wl);
+int wl1251_acx_service_period_timeout(struct wl1251 *wl);
+int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold);
+int wl1251_acx_beacon_filter_opt(struct wl1251 *wl);
+int wl1251_acx_beacon_filter_table(struct wl1251 *wl);
+int wl1251_acx_sg_enable(struct wl1251 *wl);
+int wl1251_acx_sg_cfg(struct wl1251 *wl);
+int wl1251_acx_cca_threshold(struct wl1251 *wl);
+int wl1251_acx_bcn_dtim_options(struct wl1251 *wl);
+int wl1251_acx_aid(struct wl1251 *wl, u16 aid);
+int wl1251_acx_event_mbox_mask(struct wl1251 *wl, u32 event_mask);
+int wl1251_acx_set_preamble(struct wl1251 *wl, enum acx_preamble_type preamble);
+int wl1251_acx_cts_protect(struct wl1251 *wl,
 			    enum acx_ctsprotect_type ctsprotect);
-int wl12xx_acx_statistics(struct wl12xx *wl, struct acx_statistics *stats);
-int wl12xx_acx_tsf_info(struct wl12xx *wl, u64 *mactime);
+int wl1251_acx_statistics(struct wl1251 *wl, struct acx_statistics *stats);
+int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime);
 
-#endif /* __WL12XX_ACX_H__ */
+#endif /* __WL1251_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index c52a208..d8a155d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -28,37 +28,37 @@
 #include "wl1251_spi.h"
 #include "wl1251_event.h"
 
-static void wl12xx_boot_enable_interrupts(struct wl12xx *wl)
+static void wl1251_boot_enable_interrupts(struct wl1251 *wl)
 {
 	enable_irq(wl->irq);
 }
 
-void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl)
+void wl1251_boot_target_enable_interrupts(struct wl1251 *wl)
 {
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
-	wl12xx_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
+	wl1251_reg_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
 }
 
-int wl12xx_boot_soft_reset(struct wl12xx *wl)
+int wl1251_boot_soft_reset(struct wl1251 *wl)
 {
 	unsigned long timeout;
 	u32 boot_data;
 
 	/* perform soft reset */
-	wl12xx_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
+	wl1251_reg_write32(wl, ACX_REG_SLV_SOFT_RESET, ACX_SLV_SOFT_RESET_BIT);
 
 	/* SOFT_RESET is self clearing */
 	timeout = jiffies + usecs_to_jiffies(SOFT_RESET_MAX_TIME);
 	while (1) {
-		boot_data = wl12xx_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
-		wl12xx_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
+		boot_data = wl1251_reg_read32(wl, ACX_REG_SLV_SOFT_RESET);
+		wl1251_debug(DEBUG_BOOT, "soft reset bootdata 0x%x", boot_data);
 		if ((boot_data & ACX_SLV_SOFT_RESET_BIT) == 0)
 			break;
 
 		if (time_after(jiffies, timeout)) {
 			/* 1.2 check pWhalBus->uSelfClearTime if the
 			 * timeout was reached */
-			wl12xx_error("soft reset timeout");
+			wl1251_error("soft reset timeout");
 			return -1;
 		}
 
@@ -66,15 +66,15 @@ int wl12xx_boot_soft_reset(struct wl12xx *wl)
 	}
 
 	/* disable Rx/Tx */
-	wl12xx_reg_write32(wl, ENABLE, 0x0);
+	wl1251_reg_write32(wl, ENABLE, 0x0);
 
 	/* disable auto calibration on start*/
-	wl12xx_reg_write32(wl, SPARE_A2, 0xffff);
+	wl1251_reg_write32(wl, SPARE_A2, 0xffff);
 
 	return 0;
 }
 
-int wl12xx_boot_init_seq(struct wl12xx *wl)
+int wl1251_boot_init_seq(struct wl1251 *wl)
 {
 	u32 scr_pad6, init_data, tmp, elp_cmd, ref_freq;
 
@@ -96,23 +96,23 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	};
 
 	/* read NVS params */
-	scr_pad6 = wl12xx_reg_read32(wl, SCR_PAD6);
-	wl12xx_debug(DEBUG_BOOT, "scr_pad6 0x%x", scr_pad6);
+	scr_pad6 = wl1251_reg_read32(wl, SCR_PAD6);
+	wl1251_debug(DEBUG_BOOT, "scr_pad6 0x%x", scr_pad6);
 
 	/* read ELP_CMD */
-	elp_cmd = wl12xx_reg_read32(wl, ELP_CMD);
-	wl12xx_debug(DEBUG_BOOT, "elp_cmd 0x%x", elp_cmd);
+	elp_cmd = wl1251_reg_read32(wl, ELP_CMD);
+	wl1251_debug(DEBUG_BOOT, "elp_cmd 0x%x", elp_cmd);
 
 	/* set the BB calibration time to be 300 usec (PLL_CAL_TIME) */
 	ref_freq = scr_pad6 & 0x000000FF;
-	wl12xx_debug(DEBUG_BOOT, "ref_freq 0x%x", ref_freq);
+	wl1251_debug(DEBUG_BOOT, "ref_freq 0x%x", ref_freq);
 
-	wl12xx_reg_write32(wl, PLL_CAL_TIME, 0x9);
+	wl1251_reg_write32(wl, PLL_CAL_TIME, 0x9);
 
 	/*
 	 * PG 1.2: set the clock buffer time to be 210 usec (CLK_BUF_TIME)
 	 */
-	wl12xx_reg_write32(wl, CLK_BUF_TIME, 0x6);
+	wl1251_reg_write32(wl, CLK_BUF_TIME, 0x6);
 
 	/*
 	 * set the clock detect feature to work in the restart wu procedure
@@ -120,18 +120,18 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	 * (ELP_CFG_MODE[13:12])
 	 */
 	tmp = ((scr_pad6 & 0x0000FF00) << 4) | 0x00004000;
-	wl12xx_reg_write32(wl, ELP_CFG_MODE, tmp);
+	wl1251_reg_write32(wl, ELP_CFG_MODE, tmp);
 
 	/* PG 1.2: enable the BB PLL fix. Enable the PLL_LIMP_CLK_EN_CMD */
 	elp_cmd |= 0x00000040;
-	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd);
+	wl1251_reg_write32(wl, ELP_CMD, elp_cmd);
 
 	/* PG 1.2: Set the BB PLL stable time to be 1000usec
 	 * (PLL_STABLE_TIME) */
-	wl12xx_reg_write32(wl, CFG_PLL_SYNC_CNT, 0x20);
+	wl1251_reg_write32(wl, CFG_PLL_SYNC_CNT, 0x20);
 
 	/* PG 1.2: read clock request time */
-	init_data = wl12xx_reg_read32(wl, CLK_REQ_TIME);
+	init_data = wl1251_reg_read32(wl, CLK_REQ_TIME);
 
 	/*
 	 * PG 1.2: set the clock request time to be ref_clk_settling_time -
@@ -141,35 +141,35 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 		tmp = init_data - 0x21;
 	else
 		tmp = 0;
-	wl12xx_reg_write32(wl, CLK_REQ_TIME, tmp);
+	wl1251_reg_write32(wl, CLK_REQ_TIME, tmp);
 
 	/* set BB PLL configurations in RF AFE */
-	wl12xx_reg_write32(wl, 0x003058cc, 0x4B5);
+	wl1251_reg_write32(wl, 0x003058cc, 0x4B5);
 
 	/* set RF_AFE_REG_5 */
-	wl12xx_reg_write32(wl, 0x003058d4, 0x50);
+	wl1251_reg_write32(wl, 0x003058d4, 0x50);
 
 	/* set RF_AFE_CTRL_REG_2 */
-	wl12xx_reg_write32(wl, 0x00305948, 0x11c001);
+	wl1251_reg_write32(wl, 0x00305948, 0x11c001);
 
 	/*
 	 * change RF PLL and BB PLL divider for VCO clock and adjust VCO
 	 * bais current(RF_AFE_REG_13)
 	 */
-	wl12xx_reg_write32(wl, 0x003058f4, 0x1e);
+	wl1251_reg_write32(wl, 0x003058f4, 0x1e);
 
 	/* set BB PLL configurations */
 	tmp = LUT[ref_freq][LUT_PARAM_INTEGER_DIVIDER] | 0x00017000;
-	wl12xx_reg_write32(wl, 0x00305840, tmp);
+	wl1251_reg_write32(wl, 0x00305840, tmp);
 
 	/* set fractional divider according to Appendix C-BB PLL
 	 * Calculations
 	 */
 	tmp = LUT[ref_freq][LUT_PARAM_FRACTIONAL_DIVIDER];
-	wl12xx_reg_write32(wl, 0x00305844, tmp);
+	wl1251_reg_write32(wl, 0x00305844, tmp);
 
 	/* set the initial data for the sigma delta */
-	wl12xx_reg_write32(wl, 0x00305848, 0x3039);
+	wl1251_reg_write32(wl, 0x00305848, 0x3039);
 
 	/*
 	 * set the accumulator attenuation value, calibration loop1
@@ -178,14 +178,14 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	 */
 	tmp = (LUT[ref_freq][LUT_PARAM_ATTN_BB] << 16) |
 		(LUT[ref_freq][LUT_PARAM_ALPHA_BB] << 12) | 0x1;
-	wl12xx_reg_write32(wl, 0x00305854, tmp);
+	wl1251_reg_write32(wl, 0x00305854, tmp);
 
 	/*
 	 * set the calibration stop time after holdoff time expires and set
 	 * settling time HOLD_OFF_TIME_BB
 	 */
 	tmp = LUT[ref_freq][LUT_PARAM_STOP_TIME_BB] | 0x000A0000;
-	wl12xx_reg_write32(wl, 0x00305858, tmp);
+	wl1251_reg_write32(wl, 0x00305858, tmp);
 
 	/*
 	 * set BB PLL Loop filter capacitor3- BB_C3[2:0] and set BB PLL
@@ -193,7 +193,7 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	 * BB_ILOOPF[7:3]
 	 */
 	tmp = LUT[ref_freq][LUT_PARAM_BB_PLL_LOOP_FILTER] | 0x00000030;
-	wl12xx_reg_write32(wl, 0x003058f8, tmp);
+	wl1251_reg_write32(wl, 0x003058f8, tmp);
 
 	/*
 	 * set regulator output voltage for n divider to
@@ -201,10 +201,10 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	 * set BB PLL Loop filter capacitor2- BB_C2[7:5], set gain of BB
 	 * PLL auto-call to normal mode- BB_CALGAIN_3DB[8]
 	 */
-	wl12xx_reg_write32(wl, 0x003058f0, 0x29);
+	wl1251_reg_write32(wl, 0x003058f0, 0x29);
 
 	/* enable restart wakeup sequence (ELP_CMD[0]) */
-	wl12xx_reg_write32(wl, ELP_CMD, elp_cmd | 0x1);
+	wl1251_reg_write32(wl, ELP_CMD, elp_cmd | 0x1);
 
 	/* restart sequence completed */
 	udelay(2000);
@@ -212,19 +212,19 @@ int wl12xx_boot_init_seq(struct wl12xx *wl)
 	return 0;
 }
 
-int wl12xx_boot_run_firmware(struct wl12xx *wl)
+int wl1251_boot_run_firmware(struct wl1251 *wl)
 {
 	int loop, ret;
 	u32 chip_id, interrupt;
 
 	wl->chip.op_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
-	chip_id = wl12xx_reg_read32(wl, CHIP_ID_B);
+	chip_id = wl1251_reg_read32(wl, CHIP_ID_B);
 
-	wl12xx_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
+	wl1251_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
 	if (chip_id != wl->chip.id) {
-		wl12xx_error("chip id doesn't match after firmware boot");
+		wl1251_error("chip id doesn't match after firmware boot");
 		return -EIO;
 	}
 
@@ -232,41 +232,41 @@ int wl12xx_boot_run_firmware(struct wl12xx *wl)
 	loop = 0;
 	while (loop++ < INIT_LOOP) {
 		udelay(INIT_LOOP_DELAY);
-		interrupt = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		interrupt = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 
 		if (interrupt == 0xffffffff) {
-			wl12xx_error("error reading hardware complete "
+			wl1251_error("error reading hardware complete "
 				     "init indication");
 			return -EIO;
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
 		else if (interrupt & wl->chip.intr_init_complete) {
-			wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+			wl1251_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
 					   wl->chip.intr_init_complete);
 			break;
 		}
 	}
 
 	if (loop >= INIT_LOOP) {
-		wl12xx_error("timeout waiting for the hardware to "
+		wl1251_error("timeout waiting for the hardware to "
 			     "complete initialization");
 		return -EIO;
 	}
 
 	/* get hardware config command mail box */
-	wl->cmd_box_addr = wl12xx_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
+	wl->cmd_box_addr = wl1251_reg_read32(wl, REG_COMMAND_MAILBOX_PTR);
 
 	/* get hardware config event mail box */
-	wl->event_box_addr = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->event_box_addr = wl1251_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
-	wl12xx_set_partition(wl,
+	wl1251_set_partition(wl,
 			     wl->chip.p_table[PART_WORK].mem.start,
 			     wl->chip.p_table[PART_WORK].mem.size,
 			     wl->chip.p_table[PART_WORK].reg.start,
 			     wl->chip.p_table[PART_WORK].reg.size);
 
-	wl12xx_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
+	wl1251_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
 
 	wl->chip.op_fw_version(wl);
@@ -277,20 +277,20 @@ int wl12xx_boot_run_firmware(struct wl12xx *wl)
 	 */
 
 	/* enable gpio interrupts */
-	wl12xx_boot_enable_interrupts(wl);
+	wl1251_boot_enable_interrupts(wl);
 
 	wl->chip.op_target_enable_interrupts(wl);
 
 	/* unmask all mbox events  */
 	wl->event_mask = 0xffffffff;
 
-	ret = wl12xx_event_unmask(wl);
+	ret = wl1251_event_unmask(wl);
 	if (ret < 0) {
-		wl12xx_error("EVENT mask setting failed");
+		wl1251_error("EVENT mask setting failed");
 		return ret;
 	}
 
-	wl12xx_event_mbox_config(wl);
+	wl1251_event_mbox_config(wl);
 
 	/* firmware startup completed */
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl12xx/wl1251_boot.h
index 3e2b766..798362d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -26,10 +26,10 @@
 
 #include "wl1251.h"
 
-int wl12xx_boot_soft_reset(struct wl12xx *wl);
-int wl12xx_boot_init_seq(struct wl12xx *wl);
-int wl12xx_boot_run_firmware(struct wl12xx *wl);
-void wl12xx_boot_target_enable_interrupts(struct wl12xx *wl);
+int wl1251_boot_soft_reset(struct wl1251 *wl);
+int wl1251_boot_init_seq(struct wl1251 *wl);
+int wl1251_boot_run_firmware(struct wl1251 *wl);
+void wl1251_boot_target_enable_interrupts(struct wl1251 *wl);
 
 /* number of times we try to read the INIT interrupt */
 #define INIT_LOOP 20000
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index 92c7fb6..dc04d1f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -5,7 +5,6 @@
 #include <linux/spi/spi.h>
 
 #include "wl1251.h"
-#include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 #include "wl1251_ps.h"
@@ -19,9 +18,9 @@
  * @buf: buffer containing the command, must work with dma
  * @len: length of the buffer
  */
-int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
+int wl1251_cmd_send(struct wl1251 *wl, u16 id, void *buf, size_t len)
 {
-	struct wl12xx_cmd_header *cmd;
+	struct wl1251_cmd_header *cmd;
 	unsigned long timeout;
 	u32 intr;
 	int ret = 0;
@@ -32,26 +31,26 @@ int wl12xx_cmd_send(struct wl12xx *wl, u16 id, void *buf, size_t len)
 
 	WARN_ON(len % 4 != 0);
 
-	wl12xx_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
+	wl1251_spi_mem_write(wl, wl->cmd_box_addr, buf, len);
 
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_CMD);
 
-	timeout = jiffies + msecs_to_jiffies(WL12XX_COMMAND_TIMEOUT);
+	timeout = jiffies + msecs_to_jiffies(WL1251_COMMAND_TIMEOUT);
 
-	intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+	intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	while (!(intr & wl->chip.intr_cmd_complete)) {
 		if (time_after(jiffies, timeout)) {
-			wl12xx_error("command complete timeout");
+			wl1251_error("command complete timeout");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
 
 		msleep(1);
 
-		intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
+		intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
 
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
 			   wl->chip.intr_cmd_complete);
 
 out:
@@ -66,33 +65,33 @@ out:
  * @len: length of the buffer
  * @answer: is answer needed
  */
-int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
+int wl1251_cmd_test(struct wl1251 *wl, void *buf, size_t buf_len, u8 answer)
 {
 	int ret;
 
-	wl12xx_debug(DEBUG_CMD, "cmd test");
+	wl1251_debug(DEBUG_CMD, "cmd test");
 
-	ret = wl12xx_cmd_send(wl, CMD_TEST, buf, buf_len);
+	ret = wl1251_cmd_send(wl, CMD_TEST, buf, buf_len);
 
 	if (ret < 0) {
-		wl12xx_warning("TEST command failed");
+		wl1251_warning("TEST command failed");
 		return ret;
 	}
 
 	if (answer) {
-		struct wl12xx_command *cmd_answer;
+		struct wl1251_command *cmd_answer;
 
 		/*
 		 * The test command got in, we can read the answer.
-		 * The answer would be a wl12xx_command, where the
+		 * The answer would be a wl1251_command, where the
 		 * parameter array contains the actual answer.
 		 */
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
+		wl1251_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
 		cmd_answer = buf;
 
 		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
-			wl12xx_error("TEST command answer error: %d",
+			wl1251_error("TEST command answer error: %d",
 				     cmd_answer->header.status);
 	}
 
@@ -107,30 +106,30 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
  * @buf: buffer for the response, including all headers, must work with dma
  * @len: lenght of buf
  */
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len)
+int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void *buf, size_t len)
 {
 	struct acx_header *acx = buf;
 	int ret;
 
-	wl12xx_debug(DEBUG_CMD, "cmd interrogate");
+	wl1251_debug(DEBUG_CMD, "cmd interrogate");
 
 	acx->id = id;
 
 	/* payload length, does not include any headers */
 	acx->len = len - sizeof(*acx);
 
-	ret = wl12xx_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
+	ret = wl1251_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
 	if (ret < 0) {
-		wl12xx_error("INTERROGATE command failed");
+		wl1251_error("INTERROGATE command failed");
 		goto out;
 	}
 
 	/* the interrogate command got in, we can read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
+	wl1251_spi_mem_read(wl, wl->cmd_box_addr, buf, len);
 
 	acx = buf;
 	if (acx->cmd.status != CMD_STATUS_SUCCESS)
-		wl12xx_error("INTERROGATE command error: %d",
+		wl1251_error("INTERROGATE command error: %d",
 			     acx->cmd.status);
 
 out:
@@ -145,34 +144,34 @@ out:
  * @buf: buffer containing acx, including all headers, must work with dma
  * @len: length of buf
  */
-int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len)
+int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len)
 {
 	struct acx_header *acx = buf;
 	int ret;
 
-	wl12xx_debug(DEBUG_CMD, "cmd configure");
+	wl1251_debug(DEBUG_CMD, "cmd configure");
 
 	acx->id = id;
 
 	/* payload length, does not include any headers */
 	acx->len = len - sizeof(*acx);
 
-	ret = wl12xx_cmd_send(wl, CMD_CONFIGURE, acx, len);
+	ret = wl1251_cmd_send(wl, CMD_CONFIGURE, acx, len);
 	if (ret < 0) {
-		wl12xx_warning("CONFIGURE command NOK");
+		wl1251_warning("CONFIGURE command NOK");
 		return ret;
 	}
 
 	return 0;
 }
 
-int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
+int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control)
 {
-	struct wl12xx_cmd_vbm_update *vbm;
+	struct wl1251_cmd_vbm_update *vbm;
 	int ret;
 
-	wl12xx_debug(DEBUG_CMD, "cmd vbm");
+	wl1251_debug(DEBUG_CMD, "cmd vbm");
 
 	vbm = kzalloc(sizeof(*vbm), GFP_KERNEL);
 	if (!vbm) {
@@ -183,7 +182,7 @@ int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
 	/* Count and period will be filled by the target */
 	vbm->tim.bitmap_ctrl = bitmap_control;
 	if (bitmap_len > PARTIAL_VBM_MAX) {
-		wl12xx_warning("cmd vbm len is %d B, truncating to %d",
+		wl1251_warning("cmd vbm len is %d B, truncating to %d",
 			       bitmap_len, PARTIAL_VBM_MAX);
 		bitmap_len = PARTIAL_VBM_MAX;
 	}
@@ -193,9 +192,9 @@ int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
 
 	vbm->len = cpu_to_le16(bitmap_len + 5);
 
-	ret = wl12xx_cmd_send(wl, CMD_VBM, vbm, sizeof(*vbm));
+	ret = wl1251_cmd_send(wl, CMD_VBM, vbm, sizeof(*vbm));
 	if (ret < 0) {
-		wl12xx_error("VBM command failed");
+		wl1251_error("VBM command failed");
 		goto out;
 	}
 
@@ -204,13 +203,13 @@ out:
 	return 0;
 }
 
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable)
+int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable)
 {
 	struct cmd_enabledisable_path *cmd;
 	int ret;
 	u16 cmd_rx, cmd_tx;
 
-	wl12xx_debug(DEBUG_CMD, "cmd data path");
+	wl1251_debug(DEBUG_CMD, "cmd data path");
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
@@ -228,24 +227,24 @@ int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable)
 		cmd_tx = CMD_DISABLE_TX;
 	}
 
-	ret = wl12xx_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
+	ret = wl1251_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
 	if (ret < 0) {
-		wl12xx_error("rx %s cmd for channel %d failed",
+		wl1251_error("rx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
 		goto out;
 	}
 
-	wl12xx_debug(DEBUG_BOOT, "rx %s cmd channel %d",
+	wl1251_debug(DEBUG_BOOT, "rx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
-	ret = wl12xx_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
+	ret = wl1251_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
 	if (ret < 0) {
-		wl12xx_error("tx %s cmd for channel %d failed",
+		wl1251_error("tx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
 		return ret;
 	}
 
-	wl12xx_debug(DEBUG_BOOT, "tx %s cmd channel %d",
+	wl1251_debug(DEBUG_BOOT, "tx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
 out:
@@ -253,7 +252,7 @@ out:
 	return ret;
 }
 
-int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait)
 {
 	unsigned long timeout;
@@ -268,14 +267,14 @@ int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 	}
 
 	/* FIXME: this should be in main.c */
-	ret = wl12xx_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
+	ret = wl1251_acx_frame_rates(wl, DEFAULT_HW_GEN_TX_RATE,
 				     DEFAULT_HW_GEN_MODULATION_TYPE,
 				     wl->tx_mgmt_frm_rate,
 				     wl->tx_mgmt_frm_mod);
 	if (ret < 0)
 		goto out;
 
-	wl12xx_debug(DEBUG_CMD, "cmd join");
+	wl1251_debug(DEBUG_CMD, "cmd join");
 
 	/* Reverse order BSSID */
 	bssid = (u8 *) &join->bssid_lsb;
@@ -294,9 +293,9 @@ int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
 	join->channel = wl->channel;
 	join->ctrl = JOIN_CMD_CTRL_TX_FLUSH;
 
-	ret = wl12xx_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
+	ret = wl1251_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
 	if (ret < 0) {
-		wl12xx_error("failed to initiate cmd join");
+		wl1251_error("failed to initiate cmd join");
 		goto out;
 	}
 
@@ -314,20 +313,20 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
+int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode)
 {
-	struct wl12xx_cmd_ps_params *ps_params = NULL;
+	struct wl1251_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
 
 	/* FIXME: this should be in ps.c */
-	ret = wl12xx_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
+	ret = wl1251_acx_wake_up_conditions(wl, WAKE_UP_EVENT_DTIM_BITMAP,
 					    wl->listen_int);
 	if (ret < 0) {
-		wl12xx_error("couldn't set wake up conditions");
+		wl1251_error("couldn't set wake up conditions");
 		goto out;
 	}
 
-	wl12xx_debug(DEBUG_CMD, "cmd set ps mode");
+	wl1251_debug(DEBUG_CMD, "cmd set ps mode");
 
 	ps_params = kzalloc(sizeof(*ps_params), GFP_KERNEL);
 	if (!ps_params) {
@@ -341,10 +340,10 @@ int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode)
 	ps_params->hang_over_period = 128;
 	ps_params->null_data_rate = 1; /* 1 Mbps */
 
-	ret = wl12xx_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
+	ret = wl1251_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params));
 	if (ret < 0) {
-		wl12xx_error("cmd set_ps_mode failed");
+		wl1251_error("cmd set_ps_mode failed");
 		goto out;
 	}
 
@@ -353,13 +352,13 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len)
 {
 	struct cmd_read_write_memory *cmd;
 	int ret = 0;
 
-	wl12xx_debug(DEBUG_CMD, "cmd read memory");
+	wl1251_debug(DEBUG_CMD, "cmd read memory");
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
@@ -373,17 +372,17 @@ int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
 	cmd->addr = addr;
 	cmd->size = len;
 
-	ret = wl12xx_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
+	ret = wl1251_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
 	if (ret < 0) {
-		wl12xx_error("read memory command failed: %d", ret);
+		wl1251_error("read memory command failed: %d", ret);
 		goto out;
 	}
 
 	/* the read command got in, we can now read the answer */
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
+	wl1251_spi_mem_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd));
 
 	if (cmd->header.status != CMD_STATUS_SUCCESS)
-		wl12xx_error("error in read command result: %d",
+		wl1251_error("error in read command result: %d",
 			     cmd->header.status);
 
 	memcpy(answer, cmd->value, len);
@@ -393,17 +392,17 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
+int wl1251_cmd_template_set(struct wl1251 *wl, u16 cmd_id,
 			    void *buf, size_t buf_len)
 {
-	struct wl12xx_cmd_packet_template *cmd;
+	struct wl1251_cmd_packet_template *cmd;
 	size_t cmd_len;
 	int ret = 0;
 
-	wl12xx_debug(DEBUG_CMD, "cmd template %d", cmd_id);
+	wl1251_debug(DEBUG_CMD, "cmd template %d", cmd_id);
 
-	WARN_ON(buf_len > WL12XX_MAX_TEMPLATE_SIZE);
-	buf_len = min_t(size_t, buf_len, WL12XX_MAX_TEMPLATE_SIZE);
+	WARN_ON(buf_len > WL1251_MAX_TEMPLATE_SIZE);
+	buf_len = min_t(size_t, buf_len, WL1251_MAX_TEMPLATE_SIZE);
 	cmd_len = ALIGN(sizeof(*cmd) + buf_len, 4);
 
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
@@ -417,9 +416,9 @@ int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
 	if (buf)
 		memcpy(cmd->data, buf, buf_len);
 
-	ret = wl12xx_cmd_send(wl, cmd_id, cmd, cmd_len);
+	ret = wl1251_cmd_send(wl, cmd_id, cmd, cmd_len);
 	if (ret < 0) {
-		wl12xx_warning("cmd set_template failed: %d", ret);
+		wl1251_warning("cmd set_template failed: %d", ret);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.h b/drivers/net/wireless/wl12xx/wl1251_cmd.h
index b252ad2..64f228d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -22,32 +22,32 @@
  *
  */
 
-#ifndef __WL12XX_CMD_H__
-#define __WL12XX_CMD_H__
+#ifndef __WL1251_CMD_H__
+#define __WL1251_CMD_H__
 
 #include "wl1251.h"
 
 struct acx_header;
 
-int wl12xx_cmd_send(struct wl12xx *wl, u16 type, void *buf, size_t buf_len);
-int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer);
-int wl12xx_cmd_interrogate(struct wl12xx *wl, u16 id, void *buf, size_t len);
-int wl12xx_cmd_configure(struct wl12xx *wl, u16 id, void *buf, size_t len);
-int wl12xx_cmd_vbm(struct wl12xx *wl, u8 identity,
+int wl1251_cmd_send(struct wl1251 *wl, u16 type, void *buf, size_t buf_len);
+int wl1251_cmd_test(struct wl1251 *wl, void *buf, size_t buf_len, u8 answer);
+int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void *buf, size_t len);
+int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len);
+int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
-int wl12xx_cmd_data_path(struct wl12xx *wl, u8 channel, bool enable);
-int wl1251_cmd_join(struct wl12xx *wl, u8 bss_type, u8 dtim_interval,
+int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
+int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
 		    u16 beacon_interval, u8 wait);
-int wl12xx_cmd_ps_mode(struct wl12xx *wl, u8 ps_mode);
-int wl12xx_cmd_read_memory(struct wl12xx *wl, u32 addr, void *answer,
+int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
+int wl1251_cmd_read_memory(struct wl1251 *wl, u32 addr, void *answer,
 			   size_t len);
-int wl12xx_cmd_template_set(struct wl12xx *wl, u16 cmd_id,
+int wl1251_cmd_template_set(struct wl1251 *wl, u16 cmd_id,
 			    void *buf, size_t buf_len);
 
 /* unit ms */
-#define WL12XX_COMMAND_TIMEOUT 2000
+#define WL1251_COMMAND_TIMEOUT 2000
 
-enum wl12xx_commands {
+enum wl1251_commands {
 	CMD_RESET           = 0,
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
 	CMD_CONFIGURE       = 2,    /*use this to write information elements*/
@@ -95,15 +95,15 @@ enum wl12xx_commands {
 
 #define MAX_CMD_PARAMS 572
 
-struct wl12xx_cmd_header {
+struct wl1251_cmd_header {
 	u16 id;
 	u16 status;
 	/* payload */
 	u8 data[0];
 } __attribute__ ((packed));
 
-struct  wl12xx_command {
-	struct wl12xx_cmd_header header;
+struct  wl1251_command {
+	struct wl1251_cmd_header header;
 	u8  parameters[MAX_CMD_PARAMS];
 };
 
@@ -145,7 +145,7 @@ enum {
 #define MAX_READ_SIZE 256
 
 struct cmd_read_write_memory {
-	struct wl12xx_cmd_header header;
+	struct wl1251_cmd_header header;
 
 	/* The address of the memory to read from or write to.*/
 	u32 addr;
@@ -214,7 +214,7 @@ struct basic_scan_channel_parameters {
 #define SCAN_MAX_NUM_OF_CHANNELS 16
 
 struct cmd_scan {
-	struct wl12xx_cmd_header header;
+	struct wl1251_cmd_header header;
 
 	struct basic_scan_parameters params;
 	struct basic_scan_channel_parameters channels[SCAN_MAX_NUM_OF_CHANNELS];
@@ -232,7 +232,7 @@ enum {
 
 
 struct cmd_join {
-	struct wl12xx_cmd_header header;
+	struct wl1251_cmd_header header;
 
 	u32 bssid_lsb;
 	u16 bssid_msb;
@@ -269,16 +269,16 @@ struct cmd_join {
 } __attribute__ ((packed));
 
 struct cmd_enabledisable_path {
-	struct wl12xx_cmd_header header;
+	struct wl1251_cmd_header header;
 
 	u8 channel;
 	u8 padding[3];
 } __attribute__ ((packed));
 
-#define WL12XX_MAX_TEMPLATE_SIZE 300
+#define WL1251_MAX_TEMPLATE_SIZE 300
 
-struct wl12xx_cmd_packet_template {
-	struct wl12xx_cmd_header header;
+struct wl1251_cmd_packet_template {
+	struct wl1251_cmd_header header;
 
 	__le16 size;
 	u8 data[0];
@@ -287,7 +287,7 @@ struct wl12xx_cmd_packet_template {
 #define TIM_ELE_ID    5
 #define PARTIAL_VBM_MAX    251
 
-struct wl12xx_tim {
+struct wl1251_tim {
 	u8 identity;
 	u8 length;
 	u8 dtim_count;
@@ -297,20 +297,20 @@ struct wl12xx_tim {
 } __attribute__ ((packed));
 
 /* Virtual Bit Map update */
-struct wl12xx_cmd_vbm_update {
-	struct wl12xx_cmd_header header;
+struct wl1251_cmd_vbm_update {
+	struct wl1251_cmd_header header;
 	__le16 len;
 	u8  padding[2];
-	struct wl12xx_tim tim;
+	struct wl1251_tim tim;
 } __attribute__ ((packed));
 
-enum wl12xx_cmd_ps_mode {
+enum wl1251_cmd_ps_mode {
 	STATION_ACTIVE_MODE,
 	STATION_POWER_SAVE_MODE
 };
 
-struct wl12xx_cmd_ps_params {
-	struct wl12xx_cmd_header header;
+struct wl1251_cmd_ps_params {
+	struct wl1251_cmd_header header;
 
 	u8 ps_mode; /* STATION_* */
 	u8 send_null_data; /* Do we have to send NULL data packet ? */
@@ -325,8 +325,8 @@ struct wl12xx_cmd_ps_params {
 	u8 pad[2];
 } __attribute__ ((packed));
 
-struct wl12xx_cmd_trigger_scan_to {
-	struct wl12xx_cmd_header header;
+struct wl1251_cmd_trigger_scan_to {
+	struct wl1251_cmd_header header;
 
 	u32 timeout;
 };
@@ -340,14 +340,14 @@ struct wl12xx_cmd_trigger_scan_to {
 /* When set, disable HW decryption */
 #define DF_SNIFF_MODE_ENABLE       0x80
 
-enum wl12xx_cmd_key_action {
+enum wl1251_cmd_key_action {
 	KEY_ADD_OR_REPLACE = 1,
 	KEY_REMOVE         = 2,
 	KEY_SET_ID         = 3,
 	MAX_KEY_ACTION     = 0xffff,
 };
 
-enum wl12xx_cmd_key_type {
+enum wl1251_cmd_key_type {
 	KEY_WEP_DEFAULT       = 0,
 	KEY_WEP_ADDR          = 1,
 	KEY_AES_GROUP         = 4,
@@ -374,8 +374,8 @@ enum wl12xx_cmd_key_type {
  *
  */
 
-struct wl12xx_cmd_set_keys {
-	struct wl12xx_cmd_header header;
+struct wl1251_cmd_set_keys {
+	struct wl1251_cmd_header header;
 
 	/* Ignored for default WEP key */
 	u8 addr[ETH_ALEN];
@@ -404,4 +404,4 @@ struct wl12xx_cmd_set_keys {
 } __attribute__ ((packed));
 
 
-#endif /* __WL12XX_CMD_H__ */
+#endif /* __WL1251_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.c b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
index 866303d..a007230 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.c
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2009 Nokia Corporation
  *
@@ -30,7 +30,7 @@
 #include "wl1251_ps.h"
 
 /* ms */
-#define WL12XX_DEBUGFS_STATS_LIFETIME 1000
+#define WL1251_DEBUGFS_STATS_LIFETIME 1000
 
 /* debugfs macros idea from mac80211 */
 
@@ -38,7 +38,7 @@
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
-	struct wl12xx *wl = file->private_data;				\
+	struct wl1251 *wl = file->private_data;				\
 	char buf[buflen];						\
 	int res;							\
 									\
@@ -48,7 +48,7 @@ static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 									\
 static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
-	.open = wl12xx_open_file_generic,				\
+	.open = wl1251_open_file_generic,				\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
@@ -71,11 +71,11 @@ static ssize_t sub## _ ##name## _read(struct file *file,		\
 				      char __user *userbuf,		\
 				      size_t count, loff_t *ppos)	\
 {									\
-	struct wl12xx *wl = file->private_data;				\
+	struct wl1251 *wl = file->private_data;				\
 	char buf[buflen];						\
 	int res;							\
 									\
-	wl12xx_debugfs_update_stats(wl);				\
+	wl1251_debugfs_update_stats(wl);				\
 									\
 	res = scnprintf(buf, buflen, fmt "\n",				\
 			wl->stats.fw_stats->sub.name);			\
@@ -84,7 +84,7 @@ static ssize_t sub## _ ##name## _read(struct file *file,		\
 									\
 static const struct file_operations sub## _ ##name## _ops = {		\
 	.read = sub## _ ##name## _read,					\
-	.open = wl12xx_open_file_generic,				\
+	.open = wl1251_open_file_generic,				\
 };
 
 #define DEBUGFS_FWSTATS_ADD(sub, name)				\
@@ -93,30 +93,30 @@ static const struct file_operations sub## _ ##name## _ops = {		\
 #define DEBUGFS_FWSTATS_DEL(sub, name)				\
 	DEBUGFS_DEL(sub## _ ##name)
 
-static void wl12xx_debugfs_update_stats(struct wl12xx *wl)
+static void wl1251_debugfs_update_stats(struct wl1251 *wl)
 {
 	int ret;
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	if (wl->state == WL12XX_STATE_ON &&
+	if (wl->state == WL1251_STATE_ON &&
 	    time_after(jiffies, wl->stats.fw_stats_update +
-		       msecs_to_jiffies(WL12XX_DEBUGFS_STATS_LIFETIME))) {
-		wl12xx_acx_statistics(wl, wl->stats.fw_stats);
+		       msecs_to_jiffies(WL1251_DEBUGFS_STATS_LIFETIME))) {
+		wl1251_acx_statistics(wl, wl->stats.fw_stats);
 		wl->stats.fw_stats_update = jiffies;
 	}
 
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl12xx_open_file_generic(struct inode *inode, struct file *file)
+static int wl1251_open_file_generic(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
 	return 0;
@@ -221,7 +221,7 @@ DEBUGFS_READONLY_FILE(excessive_retries, 20, "%u",
 static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 				 size_t count, loff_t *ppos)
 {
-	struct wl12xx *wl = file->private_data;
+	struct wl1251 *wl = file->private_data;
 	u32 queue_len;
 	char buf[20];
 	int res;
@@ -234,10 +234,10 @@ static ssize_t tx_queue_len_read(struct file *file, char __user *userbuf,
 
 static const struct file_operations tx_queue_len_ops = {
 	.read = tx_queue_len_read,
-	.open = wl12xx_open_file_generic,
+	.open = wl1251_open_file_generic,
 };
 
-static void wl12xx_debugfs_delete_files(struct wl12xx *wl)
+static void wl1251_debugfs_delete_files(struct wl1251 *wl)
 {
 	DEBUGFS_FWSTATS_DEL(tx, internal_desc_overflow);
 
@@ -335,7 +335,7 @@ static void wl12xx_debugfs_delete_files(struct wl12xx *wl)
 	DEBUGFS_DEL(excessive_retries);
 }
 
-static int wl12xx_debugfs_add_files(struct wl12xx *wl)
+static int wl1251_debugfs_add_files(struct wl1251 *wl)
 {
 	int ret = 0;
 
@@ -436,19 +436,19 @@ static int wl12xx_debugfs_add_files(struct wl12xx *wl)
 
 out:
 	if (ret < 0)
-		wl12xx_debugfs_delete_files(wl);
+		wl1251_debugfs_delete_files(wl);
 
 	return ret;
 }
 
-void wl12xx_debugfs_reset(struct wl12xx *wl)
+void wl1251_debugfs_reset(struct wl1251 *wl)
 {
 	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
 	wl->stats.retry_count = 0;
 	wl->stats.excessive_retries = 0;
 }
 
-int wl12xx_debugfs_init(struct wl12xx *wl)
+int wl1251_debugfs_init(struct wl1251 *wl)
 {
 	int ret;
 
@@ -479,7 +479,7 @@ int wl12xx_debugfs_init(struct wl12xx *wl)
 
 	wl->stats.fw_stats_update = jiffies;
 
-	ret = wl12xx_debugfs_add_files(wl);
+	ret = wl1251_debugfs_add_files(wl);
 
 	if (ret < 0)
 		goto err_file;
@@ -502,9 +502,9 @@ err:
 	return ret;
 }
 
-void wl12xx_debugfs_exit(struct wl12xx *wl)
+void wl1251_debugfs_exit(struct wl1251 *wl)
 {
-	wl12xx_debugfs_delete_files(wl);
+	wl1251_debugfs_delete_files(wl);
 
 	kfree(wl->stats.fw_stats);
 	wl->stats.fw_stats = NULL;
diff --git a/drivers/net/wireless/wl12xx/wl1251_debugfs.h b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
index 37653eb..6dc3d08 100644
--- a/drivers/net/wireless/wl12xx/wl1251_debugfs.h
+++ b/drivers/net/wireless/wl12xx/wl1251_debugfs.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2009 Nokia Corporation
  *
@@ -21,13 +21,13 @@
  *
  */
 
-#ifndef WL12XX_DEBUGFS_H
-#define WL12XX_DEBUGFS_H
+#ifndef WL1251_DEBUGFS_H
+#define WL1251_DEBUGFS_H
 
 #include "wl1251.h"
 
-int wl12xx_debugfs_init(struct wl12xx *wl);
-void wl12xx_debugfs_exit(struct wl12xx *wl);
-void wl12xx_debugfs_reset(struct wl12xx *wl);
+int wl1251_debugfs_init(struct wl1251 *wl);
+void wl1251_debugfs_exit(struct wl1251 *wl);
+void wl1251_debugfs_reset(struct wl1251 *wl);
 
-#endif /* WL12XX_DEBUGFS_H */
+#endif /* WL1251_DEBUGFS_H */
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index a6d9234..1a0a0bc 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -28,10 +28,10 @@
 #include "wl1251_event.h"
 #include "wl1251_ps.h"
 
-static int wl12xx_event_scan_complete(struct wl12xx *wl,
+static int wl1251_event_scan_complete(struct wl1251 *wl,
 				      struct event_mailbox *mbox)
 {
-	wl12xx_debug(DEBUG_EVENT, "status: 0x%x, channels: %d",
+	wl1251_debug(DEBUG_EVENT, "status: 0x%x, channels: %d",
 		     mbox->scheduled_scan_status,
 		     mbox->scheduled_scan_channels);
 
@@ -45,34 +45,34 @@ static int wl12xx_event_scan_complete(struct wl12xx *wl,
 	return 0;
 }
 
-static void wl12xx_event_mbox_dump(struct event_mailbox *mbox)
+static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
 {
-	wl12xx_debug(DEBUG_EVENT, "MBOX DUMP:");
-	wl12xx_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
-	wl12xx_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
+	wl1251_debug(DEBUG_EVENT, "MBOX DUMP:");
+	wl1251_debug(DEBUG_EVENT, "\tvector: 0x%x", mbox->events_vector);
+	wl1251_debug(DEBUG_EVENT, "\tmask: 0x%x", mbox->events_mask);
 }
 
-static int wl12xx_event_process(struct wl12xx *wl, struct event_mailbox *mbox)
+static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 {
 	int ret;
 	u32 vector;
 
-	wl12xx_event_mbox_dump(mbox);
+	wl1251_event_mbox_dump(mbox);
 
 	vector = mbox->events_vector & ~(mbox->events_mask);
-	wl12xx_debug(DEBUG_EVENT, "vector: 0x%x", vector);
+	wl1251_debug(DEBUG_EVENT, "vector: 0x%x", vector);
 
 	if (vector & SCAN_COMPLETE_EVENT_ID) {
-		ret = wl12xx_event_scan_complete(wl, mbox);
+		ret = wl1251_event_scan_complete(wl, mbox);
 		if (ret < 0)
 			return ret;
 	}
 
 	if (vector & BSS_LOSE_EVENT_ID) {
-		wl12xx_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
+		wl1251_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
 
 		if (wl->psm_requested && wl->psm) {
-			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
 			if (ret < 0)
 				return ret;
 		}
@@ -81,47 +81,47 @@ static int wl12xx_event_process(struct wl12xx *wl, struct event_mailbox *mbox)
 	return 0;
 }
 
-int wl12xx_event_unmask(struct wl12xx *wl)
+int wl1251_event_unmask(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_event_mbox_mask(wl, ~(wl->event_mask));
+	ret = wl1251_acx_event_mbox_mask(wl, ~(wl->event_mask));
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-void wl12xx_event_mbox_config(struct wl12xx *wl)
+void wl1251_event_mbox_config(struct wl1251 *wl)
 {
-	wl->mbox_ptr[0] = wl12xx_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
+	wl->mbox_ptr[0] = wl1251_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
 	wl->mbox_ptr[1] = wl->mbox_ptr[0] + sizeof(struct event_mailbox);
 
-	wl12xx_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
+	wl1251_debug(DEBUG_EVENT, "MBOX ptrs: 0x%x 0x%x",
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 }
 
-int wl12xx_event_handle(struct wl12xx *wl, u8 mbox_num)
+int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 {
 	struct event_mailbox mbox;
 	int ret;
 
-	wl12xx_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
+	wl1251_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
 
 	if (mbox_num > 1)
 		return -EINVAL;
 
 	/* first we read the mbox descriptor */
-	wl12xx_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
+	wl1251_spi_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
 			    sizeof(struct event_mailbox));
 
 	/* process the descriptor */
-	ret = wl12xx_event_process(wl, &mbox);
+	ret = wl1251_event_process(wl, &mbox);
 	if (ret < 0)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.h b/drivers/net/wireless/wl12xx/wl1251_event.h
index 1f4c2f7..be0ac54 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.h
+++ b/drivers/net/wireless/wl12xx/wl1251_event.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -22,8 +22,8 @@
  *
  */
 
-#ifndef __WL12XX_EVENT_H__
-#define __WL12XX_EVENT_H__
+#ifndef __WL1251_EVENT_H__
+#define __WL1251_EVENT_H__
 
 /*
  * Mbox events
@@ -114,8 +114,8 @@ struct event_mailbox {
 	u8 padding[19];
 } __attribute__ ((packed));
 
-int wl12xx_event_unmask(struct wl12xx *wl);
-void wl12xx_event_mbox_config(struct wl12xx *wl);
-int wl12xx_event_handle(struct wl12xx *wl, u8 mbox);
+int wl1251_event_unmask(struct wl1251 *wl);
+void wl1251_event_mbox_config(struct wl1251 *wl);
+int wl1251_event_handle(struct wl1251 *wl, u8 mbox);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index 0929461..df6c60f 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2009 Nokia Corporation
  *
@@ -29,59 +29,59 @@
 #include "wl1251_acx.h"
 #include "wl1251_cmd.h"
 
-int wl12xx_hw_init_hwenc_config(struct wl12xx *wl)
+int wl1251_hw_init_hwenc_config(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_feature_cfg(wl);
+	ret = wl1251_acx_feature_cfg(wl);
 	if (ret < 0) {
-		wl12xx_warning("couldn't set feature config");
+		wl1251_warning("couldn't set feature config");
 		return ret;
 	}
 
-	ret = wl12xx_acx_default_key(wl, wl->default_key);
+	ret = wl1251_acx_default_key(wl, wl->default_key);
 	if (ret < 0) {
-		wl12xx_warning("couldn't set default key");
+		wl1251_warning("couldn't set default key");
 		return ret;
 	}
 
 	return 0;
 }
 
-int wl12xx_hw_init_templates_config(struct wl12xx *wl)
+int wl1251_hw_init_templates_config(struct wl1251 *wl)
 {
 	int ret;
 	u8 partial_vbm[PARTIAL_VBM_MAX];
 
 	/* send empty templates for fw memory reservation */
-	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_PROBE_REQ, NULL,
 				      sizeof(struct wl12xx_probe_req_template));
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_template_set(wl, CMD_NULL_DATA, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template));
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_template_set(wl, CMD_PS_POLL, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_PS_POLL, NULL,
 				      sizeof(struct wl12xx_ps_poll_template));
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_template_set(wl, CMD_QOS_NULL_DATA, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_QOS_NULL_DATA, NULL,
 				      sizeof
 				      (struct wl12xx_qos_null_data_template));
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_PROBE_RESP, NULL,
 				      sizeof
 				      (struct wl12xx_probe_resp_template));
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_template_set(wl, CMD_BEACON, NULL,
+	ret = wl1251_cmd_template_set(wl, CMD_BEACON, NULL,
 				      sizeof
 				      (struct wl12xx_beacon_template));
 	if (ret < 0)
@@ -89,112 +89,112 @@ int wl12xx_hw_init_templates_config(struct wl12xx *wl)
 
 	/* tim templates, first reserve space then allocate an empty one */
 	memset(partial_vbm, 0, PARTIAL_VBM_MAX);
-	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, PARTIAL_VBM_MAX, 0);
+	ret = wl1251_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, PARTIAL_VBM_MAX, 0);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, 1, 0);
+	ret = wl1251_cmd_vbm(wl, TIM_ELE_ID, partial_vbm, 1, 0);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter)
+int wl1251_hw_init_rx_config(struct wl1251 *wl, u32 config, u32 filter)
 {
 	int ret;
 
-	ret = wl12xx_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
+	ret = wl1251_acx_rx_msdu_life_time(wl, RX_MSDU_LIFETIME_DEF);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_rx_config(wl, config, filter);
+	ret = wl1251_acx_rx_config(wl, config, filter);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_phy_config(struct wl12xx *wl)
+int wl1251_hw_init_phy_config(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_pd_threshold(wl);
+	ret = wl1251_acx_pd_threshold(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_slot(wl, DEFAULT_SLOT_TIME);
+	ret = wl1251_acx_slot(wl, DEFAULT_SLOT_TIME);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_group_address_tbl(wl);
+	ret = wl1251_acx_group_address_tbl(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_service_period_timeout(wl);
+	ret = wl1251_acx_service_period_timeout(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
+	ret = wl1251_acx_rts_threshold(wl, RTS_THRESHOLD_DEF);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_beacon_filter(struct wl12xx *wl)
+int wl1251_hw_init_beacon_filter(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_beacon_filter_opt(wl);
+	ret = wl1251_acx_beacon_filter_opt(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_beacon_filter_table(wl);
+	ret = wl1251_acx_beacon_filter_table(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_pta(struct wl12xx *wl)
+int wl1251_hw_init_pta(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_sg_enable(wl);
+	ret = wl1251_acx_sg_enable(wl);
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_acx_sg_cfg(wl);
+	ret = wl1251_acx_sg_cfg(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_energy_detection(struct wl12xx *wl)
+int wl1251_hw_init_energy_detection(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_cca_threshold(wl);
+	ret = wl1251_acx_cca_threshold(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl)
+int wl1251_hw_init_beacon_broadcast(struct wl1251 *wl)
 {
 	int ret;
 
-	ret = wl12xx_acx_bcn_dtim_options(wl);
+	ret = wl1251_acx_bcn_dtim_options(wl);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-int wl12xx_hw_init_power_auth(struct wl12xx *wl)
+int wl1251_hw_init_power_auth(struct wl1251 *wl)
 {
-	return wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
+	return wl1251_acx_sleep_auth(wl, WL1251_PSM_CAM);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index 2b6268e..8596188 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2009 Nokia Corporation
  *
@@ -21,19 +21,19 @@
  *
  */
 
-#ifndef __WL12XX_INIT_H__
-#define __WL12XX_INIT_H__
+#ifndef __WL1251_INIT_H__
+#define __WL1251_INIT_H__
 
 #include "wl1251.h"
 
-int wl12xx_hw_init_hwenc_config(struct wl12xx *wl);
-int wl12xx_hw_init_templates_config(struct wl12xx *wl);
-int wl12xx_hw_init_rx_config(struct wl12xx *wl, u32 config, u32 filter);
-int wl12xx_hw_init_phy_config(struct wl12xx *wl);
-int wl12xx_hw_init_beacon_filter(struct wl12xx *wl);
-int wl12xx_hw_init_pta(struct wl12xx *wl);
-int wl12xx_hw_init_energy_detection(struct wl12xx *wl);
-int wl12xx_hw_init_beacon_broadcast(struct wl12xx *wl);
-int wl12xx_hw_init_power_auth(struct wl12xx *wl);
+int wl1251_hw_init_hwenc_config(struct wl1251 *wl);
+int wl1251_hw_init_templates_config(struct wl1251 *wl);
+int wl1251_hw_init_rx_config(struct wl1251 *wl, u32 config, u32 filter);
+int wl1251_hw_init_phy_config(struct wl1251 *wl);
+int wl1251_hw_init_beacon_filter(struct wl1251 *wl);
+int wl1251_hw_init_pta(struct wl1251 *wl);
+int wl1251_hw_init_energy_detection(struct wl1251 *wl);
+int wl1251_hw_init_beacon_broadcast(struct wl1251 *wl);
+int wl1251_hw_init_power_auth(struct wl1251 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 41b9c61..f4bc579 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008-2009 Nokia Corporation
  *
@@ -43,26 +43,26 @@
 #include "wl1251_init.h"
 #include "wl1251_debugfs.h"
 
-static void wl12xx_disable_interrupts(struct wl12xx *wl)
+static void wl1251_disable_interrupts(struct wl1251 *wl)
 {
 	disable_irq(wl->irq);
 }
 
-static void wl12xx_power_off(struct wl12xx *wl)
+static void wl1251_power_off(struct wl1251 *wl)
 {
 	wl->set_power(false);
 }
 
-static void wl12xx_power_on(struct wl12xx *wl)
+static void wl1251_power_on(struct wl1251 *wl)
 {
 	wl->set_power(true);
 }
 
-static irqreturn_t wl12xx_irq(int irq, void *cookie)
+static irqreturn_t wl1251_irq(int irq, void *cookie)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 
-	wl12xx_debug(DEBUG_IRQ, "IRQ");
+	wl1251_debug(DEBUG_IRQ, "IRQ");
 
 	wl = cookie;
 
@@ -71,7 +71,7 @@ static irqreturn_t wl12xx_irq(int irq, void *cookie)
 	return IRQ_HANDLED;
 }
 
-static int wl12xx_fetch_firmware(struct wl12xx *wl)
+static int wl1251_fetch_firmware(struct wl1251 *wl)
 {
 	const struct firmware *fw;
 	int ret;
@@ -79,12 +79,12 @@ static int wl12xx_fetch_firmware(struct wl12xx *wl)
 	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
 
 	if (ret < 0) {
-		wl12xx_error("could not get firmware: %d", ret);
+		wl1251_error("could not get firmware: %d", ret);
 		return ret;
 	}
 
 	if (fw->size % 4) {
-		wl12xx_error("firmware size is not multiple of 32 bits: %zu",
+		wl1251_error("firmware size is not multiple of 32 bits: %zu",
 			     fw->size);
 		ret = -EILSEQ;
 		goto out;
@@ -94,7 +94,7 @@ static int wl12xx_fetch_firmware(struct wl12xx *wl)
 	wl->fw = kmalloc(wl->fw_len, GFP_KERNEL);
 
 	if (!wl->fw) {
-		wl12xx_error("could not allocate memory for the firmware");
+		wl1251_error("could not allocate memory for the firmware");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -109,7 +109,7 @@ out:
 	return ret;
 }
 
-static int wl12xx_fetch_nvs(struct wl12xx *wl)
+static int wl1251_fetch_nvs(struct wl1251 *wl)
 {
 	const struct firmware *fw;
 	int ret;
@@ -117,12 +117,12 @@ static int wl12xx_fetch_nvs(struct wl12xx *wl)
 	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
 
 	if (ret < 0) {
-		wl12xx_error("could not get nvs file: %d", ret);
+		wl1251_error("could not get nvs file: %d", ret);
 		return ret;
 	}
 
 	if (fw->size % 4) {
-		wl12xx_error("nvs size is not multiple of 32 bits: %zu",
+		wl1251_error("nvs size is not multiple of 32 bits: %zu",
 			     fw->size);
 		ret = -EILSEQ;
 		goto out;
@@ -132,7 +132,7 @@ static int wl12xx_fetch_nvs(struct wl12xx *wl)
 	wl->nvs = kmalloc(wl->nvs_len, GFP_KERNEL);
 
 	if (!wl->nvs) {
-		wl12xx_error("could not allocate memory for the nvs file");
+		wl1251_error("could not allocate memory for the nvs file");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -147,49 +147,49 @@ out:
 	return ret;
 }
 
-static void wl12xx_fw_wakeup(struct wl12xx *wl)
+static void wl1251_fw_wakeup(struct wl1251 *wl)
 {
 	u32 elp_reg;
 
 	elp_reg = ELPCTRL_WAKE_UP;
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
-	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, elp_reg);
+	elp_reg = wl1251_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
 
 	if (!(elp_reg & ELPCTRL_WLAN_READY)) {
-		wl12xx_warning("WLAN not ready");
+		wl1251_warning("WLAN not ready");
 	}
 }
 
-static int wl12xx_chip_wakeup(struct wl12xx *wl)
+static int wl1251_chip_wakeup(struct wl1251 *wl)
 {
 	int ret = 0;
 
-	wl12xx_power_on(wl);
+	wl1251_power_on(wl);
 	msleep(wl->chip.power_on_sleep);
-	wl12xx_spi_reset(wl);
-	wl12xx_spi_init(wl);
+	wl1251_spi_reset(wl);
+	wl1251_spi_init(wl);
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
-	wl12xx_set_partition(wl,
+	wl1251_set_partition(wl,
 			     0x00000000,
 			     0x00000000,
 			     REGISTERS_BASE,
 			     REGISTERS_DOWN_SIZE);
 
 	/* ELP module wake up */
-	wl12xx_fw_wakeup(wl);
+	wl1251_fw_wakeup(wl);
 
 	/* whal_FwCtrl_BootSm() */
 
 	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl12xx_reg_read32(wl, CHIP_ID_B);
+	wl->chip.id = wl1251_reg_read32(wl, CHIP_ID_B);
 
 	/* 1. check if chip id is valid */
 
 	switch (wl->chip.id) {
 	case CHIP_ID_1251_PG12:
-		wl12xx_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
+		wl1251_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
 			     wl->chip.id);
 
 		wl1251_setup(wl);
@@ -198,20 +198,20 @@ static int wl12xx_chip_wakeup(struct wl12xx *wl)
 	case CHIP_ID_1251_PG10:
 	case CHIP_ID_1251_PG11:
 	default:
-		wl12xx_error("unsupported chip id: 0x%x", wl->chip.id);
+		wl1251_error("unsupported chip id: 0x%x", wl->chip.id);
 		ret = -ENODEV;
 		goto out;
 	}
 
 	if (wl->fw == NULL) {
-		ret = wl12xx_fetch_firmware(wl);
+		ret = wl1251_fetch_firmware(wl);
 		if (ret < 0)
 			goto out;
 	}
 
 	/* No NVS from netlink, try to get it from the filesystem */
 	if (wl->nvs == NULL) {
-		ret = wl12xx_fetch_nvs(wl);
+		ret = wl1251_fetch_nvs(wl);
 		if (ret < 0)
 			goto out;
 	}
@@ -220,18 +220,18 @@ out:
 	return ret;
 }
 
-static void wl12xx_filter_work(struct work_struct *work)
+static void wl1251_filter_work(struct work_struct *work)
 {
-	struct wl12xx *wl =
-		container_of(work, struct wl12xx, filter_work);
+	struct wl1251 *wl =
+		container_of(work, struct wl1251, filter_work);
 	int ret;
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state == WL12XX_STATE_OFF)
+	if (wl->state == WL1251_STATE_OFF)
 		goto out;
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -241,27 +241,29 @@ static void wl12xx_filter_work(struct work_struct *work)
 		goto out_sleep;
 
 out_sleep:
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
 }
 
-int wl12xx_plt_start(struct wl12xx *wl)
+int wl1251_plt_start(struct wl1251 *wl)
 {
 	int ret;
 
-	wl12xx_notice("power up");
+	mutex_lock(&wl->mutex);
+
+	wl1251_notice("power up");
 
-	if (wl->state != WL12XX_STATE_OFF) {
-		wl12xx_error("cannot go into PLT state because not "
+	if (wl->state != WL1251_STATE_OFF) {
+		wl1251_error("cannot go into PLT state because not "
 			     "in off state: %d", wl->state);
 		return -EBUSY;
 	}
 
-	wl->state = WL12XX_STATE_PLT;
+	wl->state = WL1251_STATE_PLT;
 
-	ret = wl12xx_chip_wakeup(wl);
+	ret = wl1251_chip_wakeup(wl);
 	if (ret < 0)
 		return ret;
 
@@ -269,7 +271,7 @@ int wl12xx_plt_start(struct wl12xx *wl)
 	if (ret < 0)
 		return ret;
 
-	wl12xx_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
+	wl1251_notice("firmware booted in PLT mode (%s)", wl->chip.fw_ver);
 
 	ret = wl->chip.op_plt_init(wl);
 	if (ret < 0)
@@ -278,28 +280,30 @@ int wl12xx_plt_start(struct wl12xx *wl)
 	return 0;
 }
 
-int wl12xx_plt_stop(struct wl12xx *wl)
+int wl1251_plt_stop(struct wl1251 *wl)
 {
-	wl12xx_notice("power down");
+	mutex_lock(&wl->mutex);
+
+	wl1251_notice("power down");
 
-	if (wl->state != WL12XX_STATE_PLT) {
-		wl12xx_error("cannot power down because not in PLT "
+	if (wl->state != WL1251_STATE_PLT) {
+		wl1251_error("cannot power down because not in PLT "
 			     "state: %d", wl->state);
 		return -EBUSY;
 	}
 
-	wl12xx_disable_interrupts(wl);
-	wl12xx_power_off(wl);
+	wl1251_disable_interrupts(wl);
+	wl1251_power_off(wl);
 
-	wl->state = WL12XX_STATE_OFF;
+	wl->state = WL1251_STATE_OFF;
 
 	return 0;
 }
 
 
-static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
+static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 
 	skb_queue_tail(&wl->tx_queue, skb);
 
@@ -314,7 +318,7 @@ static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (skb_queue_len(&wl->tx_queue) >= WL12XX_TX_QUEUE_MAX_LENGTH) {
+	if (skb_queue_len(&wl->tx_queue) >= WL1251_TX_QUEUE_MAX_LENGTH) {
 		ieee80211_stop_queues(wl->hw);
 
 		/*
@@ -328,23 +332,23 @@ static int wl12xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return NETDEV_TX_OK;
 }
 
-static int wl12xx_op_start(struct ieee80211_hw *hw)
+static int wl1251_op_start(struct ieee80211_hw *hw)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 	int ret = 0;
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 start");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 start");
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->state != WL12XX_STATE_OFF) {
-		wl12xx_error("cannot start because not in off state: %d",
+	if (wl->state != WL1251_STATE_OFF) {
+		wl1251_error("cannot start because not in off state: %d",
 			     wl->state);
 		ret = -EBUSY;
 		goto out;
 	}
 
-	ret = wl12xx_chip_wakeup(wl);
+	ret = wl1251_chip_wakeup(wl);
 	if (ret < 0)
 		return ret;
 
@@ -356,34 +360,34 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_acx_station_id(wl);
+	ret = wl1251_acx_station_id(wl);
 	if (ret < 0)
 		goto out;
 
-	wl->state = WL12XX_STATE_ON;
+	wl->state = WL1251_STATE_ON;
 
-	wl12xx_info("firmware booted (%s)", wl->chip.fw_ver);
+	wl1251_info("firmware booted (%s)", wl->chip.fw_ver);
 
 out:
 	if (ret < 0)
-		wl12xx_power_off(wl);
+		wl1251_power_off(wl);
 
 	mutex_unlock(&wl->mutex);
 
 	return ret;
 }
 
-static void wl12xx_op_stop(struct ieee80211_hw *hw)
+static void wl1251_op_stop(struct ieee80211_hw *hw)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 
-	wl12xx_info("down");
+	wl1251_info("down");
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 stop");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 stop");
 
 	mutex_lock(&wl->mutex);
 
-	WARN_ON(wl->state != WL12XX_STATE_ON);
+	WARN_ON(wl->state != WL1251_STATE_ON);
 
 	if (wl->scanning) {
 		mutex_unlock(&wl->mutex);
@@ -392,9 +396,9 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 		wl->scanning = false;
 	}
 
-	wl->state = WL12XX_STATE_OFF;
+	wl->state = WL1251_STATE_OFF;
 
-	wl12xx_disable_interrupts(wl);
+	wl1251_disable_interrupts(wl);
 
 	mutex_unlock(&wl->mutex);
 
@@ -406,7 +410,7 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl->chip.op_tx_flush(wl);
-	wl12xx_power_off(wl);
+	wl1251_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
 	wl->listen_int = 1;
@@ -421,21 +425,21 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 	wl->elp = false;
 	wl->psm = 0;
 	wl->tx_queue_stopped = false;
-	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
+	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 
-	wl12xx_debugfs_reset(wl);
+	wl1251_debugfs_reset(wl);
 
 	mutex_unlock(&wl->mutex);
 }
 
-static int wl12xx_op_add_interface(struct ieee80211_hw *hw,
+static int wl1251_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_if_init_conf *conf)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 	DECLARE_MAC_BUF(mac);
 	int ret = 0;
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
+	wl1251_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %s",
 		     conf->type, print_mac(mac, conf->mac_addr));
 
 	mutex_lock(&wl->mutex);
@@ -455,7 +459,7 @@ static int wl12xx_op_add_interface(struct ieee80211_hw *hw,
 	if (memcmp(wl->mac_addr, conf->mac_addr, ETH_ALEN)) {
 		memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 		SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
-		ret = wl12xx_acx_station_id(wl);
+		ret = wl1251_acx_station_id(wl);
 		if (ret < 0)
 			goto out;
 	}
@@ -465,13 +469,13 @@ out:
 	return ret;
 }
 
-static void wl12xx_op_remove_interface(struct ieee80211_hw *hw,
+static void wl1251_op_remove_interface(struct ieee80211_hw *hw,
 					 struct ieee80211_if_init_conf *conf)
 {
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 remove interface");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 remove interface");
 }
 
-static int wl12xx_build_null_data(struct wl12xx *wl)
+static int wl1251_build_null_data(struct wl1251 *wl)
 {
 	struct wl12xx_null_data_template template;
 
@@ -487,12 +491,12 @@ static int wl12xx_build_null_data(struct wl12xx *wl)
 	template.header.frame_ctl = cpu_to_le16(IEEE80211_FTYPE_DATA |
 						IEEE80211_STYPE_NULLFUNC);
 
-	return wl12xx_cmd_template_set(wl, CMD_NULL_DATA, &template,
+	return wl1251_cmd_template_set(wl, CMD_NULL_DATA, &template,
 				       sizeof(template));
 
 }
 
-static int wl12xx_build_ps_poll(struct wl12xx *wl, u16 aid)
+static int wl1251_build_ps_poll(struct wl1251 *wl, u16 aid)
 {
 	struct wl12xx_ps_poll_template template;
 
@@ -501,27 +505,27 @@ static int wl12xx_build_ps_poll(struct wl12xx *wl, u16 aid)
 	template.aid = aid;
 	template.fc = cpu_to_le16(IEEE80211_FTYPE_CTL | IEEE80211_STYPE_PSPOLL);
 
-	return wl12xx_cmd_template_set(wl, CMD_PS_POLL, &template,
+	return wl1251_cmd_template_set(wl, CMD_PS_POLL, &template,
 				       sizeof(template));
 
 }
 
-static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
+static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 
 	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
+	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
 		     channel,
 		     conf->flags & IEEE80211_CONF_PS ? "on" : "off",
 		     conf->power_level);
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -534,12 +538,12 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->channel = channel;
 	}
 
-	ret = wl12xx_build_null_data(wl);
+	ret = wl1251_build_null_data(wl);
 	if (ret < 0)
 		goto out_sleep;
 
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
-		wl12xx_info("psm enabled");
+		wl1251_info("psm enabled");
 
 		wl->psm_requested = true;
 
@@ -548,19 +552,19 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 		 * If we're not, we'll enter it when joining an SSID,
 		 * through the bss_info_changed() hook.
 		 */
-		ret = wl12xx_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 	} else if (!(conf->flags & IEEE80211_CONF_PS) &&
 		   wl->psm_requested) {
-		wl12xx_info("psm disabled");
+		wl1251_info("psm disabled");
 
 		wl->psm_requested = false;
 
 		if (wl->psm)
-			ret = wl12xx_ps_set_mode(wl, STATION_ACTIVE_MODE);
+			ret = wl1251_ps_set_mode(wl, STATION_ACTIVE_MODE);
 	}
 
 	if (conf->power_level != wl->power_level) {
-		ret = wl12xx_acx_tx_power(wl, conf->power_level);
+		ret = wl1251_acx_tx_power(wl, conf->power_level);
 		if (ret < 0)
 			goto out;
 
@@ -568,7 +572,7 @@ static int wl12xx_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 out_sleep:
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -576,25 +580,25 @@ out:
 	return ret;
 }
 
-#define WL12XX_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
+#define WL1251_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
 				  FIF_ALLMULTI | \
 				  FIF_FCSFAIL | \
 				  FIF_BCN_PRBRESP_PROMISC | \
 				  FIF_CONTROL | \
 				  FIF_OTHER_BSS)
 
-static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
+static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
 				       unsigned int *total,
 				       int mc_count,
 				       struct dev_addr_list *mc_list)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 configure filter");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 configure filter");
 
-	*total &= WL12XX_SUPPORTED_FILTERS;
-	changed &= WL12XX_SUPPORTED_FILTERS;
+	*total &= WL1251_SUPPORTED_FILTERS;
+	changed &= WL1251_SUPPORTED_FILTERS;
 
 	if (changed == 0)
 		/* no filters which we support changed */
@@ -602,8 +606,8 @@ static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
 
 	/* FIXME: wl->rx_config and wl->rx_filter are not protected */
 
-	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
+	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
 
 	if (*total & FIF_PROMISC_IN_BSS) {
 		wl->rx_config |= CFG_BSSID_FILTER_EN;
@@ -635,8 +639,8 @@ static void wl12xx_op_configure_filter(struct ieee80211_hw *hw,
 }
 
 /* HW encryption */
-static int wl12xx_set_key_type(struct wl12xx *wl,
-			       struct wl12xx_cmd_set_keys *key,
+static int wl1251_set_key_type(struct wl1251 *wl,
+			       struct wl1251_cmd_set_keys *key,
 			       enum set_key_cmd cmd,
 			       struct ieee80211_key_conf *mac80211_key,
 			       const u8 *addr)
@@ -666,27 +670,27 @@ static int wl12xx_set_key_type(struct wl12xx *wl,
 		mac80211_key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		break;
 	default:
-		wl12xx_error("Unknown key algo 0x%x", mac80211_key->alg);
+		wl1251_error("Unknown key algo 0x%x", mac80211_key->alg);
 		return -EOPNOTSUPP;
 	}
 
 	return 0;
 }
 
-static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+static int wl1251_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			     struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta,
 			     struct ieee80211_key_conf *key)
 {
-	struct wl12xx *wl = hw->priv;
-	struct wl12xx_cmd_set_keys *wl_cmd;
+	struct wl1251 *wl = hw->priv;
+	struct wl1251_cmd_set_keys *wl_cmd;
 	const u8 *addr;
 	int ret;
 
 	static const u8 bcast_addr[ETH_ALEN] =
 		{ 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 set key");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 set key");
 
 	wl_cmd = kzalloc(sizeof(*wl_cmd), GFP_KERNEL);
 	if (!wl_cmd) {
@@ -696,11 +700,11 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	addr = sta ? sta->addr : bcast_addr;
 
-	wl12xx_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
-	wl12xx_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
-	wl12xx_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
+	wl1251_debug(DEBUG_CRYPT, "CMD: 0x%x", cmd);
+	wl1251_dump(DEBUG_CRYPT, "ADDR: ", addr, ETH_ALEN);
+	wl1251_debug(DEBUG_CRYPT, "Key: algo:0x%x, id:%d, len:%d flags 0x%x",
 		     key->alg, key->keyidx, key->keylen, key->flags);
-	wl12xx_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
+	wl1251_dump(DEBUG_CRYPT, "KEY: ", key->key, key->keylen);
 
 	if (is_zero_ether_addr(addr)) {
 		/* We dont support TX only encryption */
@@ -710,7 +714,7 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out_unlock;
 
@@ -722,13 +726,13 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		wl_cmd->key_action = KEY_REMOVE;
 		break;
 	default:
-		wl12xx_error("Unsupported key cmd 0x%x", cmd);
+		wl1251_error("Unsupported key cmd 0x%x", cmd);
 		break;
 	}
 
-	ret = wl12xx_set_key_type(wl, wl_cmd, cmd, key, addr);
+	ret = wl1251_set_key_type(wl, wl_cmd, cmd, key, addr);
 	if (ret < 0) {
-		wl12xx_error("Set KEY type failed");
+		wl1251_error("Set KEY type failed");
 		goto out_sleep;
 	}
 
@@ -755,16 +759,16 @@ static int wl12xx_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	wl_cmd->id = key->keyidx;
 	wl_cmd->ssid_profile = 0;
 
-	wl12xx_dump(DEBUG_CRYPT, "TARGET KEY: ", wl_cmd, sizeof(*wl_cmd));
+	wl1251_dump(DEBUG_CRYPT, "TARGET KEY: ", wl_cmd, sizeof(*wl_cmd));
 
-	ret = wl12xx_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
+	ret = wl1251_cmd_send(wl, CMD_SET_KEYS, wl_cmd, sizeof(*wl_cmd));
 	if (ret < 0) {
-		wl12xx_warning("could not set keys");
+		wl1251_warning("could not set keys");
 		goto out_sleep;
 	}
 
 out_sleep:
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out_unlock:
 	mutex_unlock(&wl->mutex);
@@ -775,7 +779,7 @@ out:
 	return ret;
 }
 
-static int wl12xx_build_basic_rates(char *rates)
+static int wl1251_build_basic_rates(char *rates)
 {
 	u8 index = 0;
 
@@ -787,7 +791,7 @@ static int wl12xx_build_basic_rates(char *rates)
 	return index;
 }
 
-static int wl12xx_build_extended_rates(char *rates)
+static int wl1251_build_extended_rates(char *rates)
 {
 	u8 index = 0;
 
@@ -804,7 +808,7 @@ static int wl12xx_build_extended_rates(char *rates)
 }
 
 
-static int wl12xx_build_probe_req(struct wl12xx *wl, u8 *ssid, size_t ssid_len)
+static int wl1251_build_probe_req(struct wl1251 *wl, u8 *ssid, size_t ssid_len)
 {
 	struct wl12xx_probe_req_template template;
 	struct wl12xx_ie_rates *rates;
@@ -831,27 +835,27 @@ static int wl12xx_build_probe_req(struct wl12xx *wl, u8 *ssid, size_t ssid_len)
 	/* Basic Rates */
 	rates = (struct wl12xx_ie_rates *)ptr;
 	rates->header.id = WLAN_EID_SUPP_RATES;
-	rates->header.len = wl12xx_build_basic_rates(rates->rates);
+	rates->header.len = wl1251_build_basic_rates(rates->rates);
 	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
 	ptr += sizeof(struct wl12xx_ie_header) + rates->header.len;
 
 	/* Extended rates */
 	rates = (struct wl12xx_ie_rates *)ptr;
 	rates->header.id = WLAN_EID_EXT_SUPP_RATES;
-	rates->header.len = wl12xx_build_extended_rates(rates->rates);
+	rates->header.len = wl1251_build_extended_rates(rates->rates);
 	size += sizeof(struct wl12xx_ie_header) + rates->header.len;
 
-	wl12xx_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
+	wl1251_dump(DEBUG_SCAN, "PROBE REQ: ", &template, size);
 
-	return wl12xx_cmd_template_set(wl, CMD_PROBE_REQ, &template,
+	return wl1251_cmd_template_set(wl, CMD_PROBE_REQ, &template,
 				      size);
 }
 
-static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
+static int wl1251_hw_scan(struct wl1251 *wl, u8 *ssid, size_t len,
 			  u8 active_scan, u8 high_prio, u8 num_channels,
 			  u8 probe_requests)
 {
-	struct wl12xx_cmd_trigger_scan_to *trigger = NULL;
+	struct wl1251_cmd_trigger_scan_to *trigger = NULL;
 	struct cmd_scan *params = NULL;
 	int i, ret;
 	u16 scan_options = 0;
@@ -902,9 +906,9 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 		memset(params->params.ssid, 0, 32);
 	}
 
-	ret = wl12xx_build_probe_req(wl, ssid, len);
+	ret = wl1251_build_probe_req(wl, ssid, len);
 	if (ret < 0) {
-		wl12xx_error("PROBE request template failed");
+		wl1251_error("PROBE request template failed");
 		goto out;
 	}
 
@@ -914,25 +918,25 @@ static int wl12xx_hw_scan(struct wl12xx *wl, u8 *ssid, size_t len,
 
 	trigger->timeout = 0;
 
-	ret = wl12xx_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+	ret = wl1251_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
 			      sizeof(*trigger));
 	if (ret < 0) {
-		wl12xx_error("trigger scan to failed for hw scan");
+		wl1251_error("trigger scan to failed for hw scan");
 		goto out;
 	}
 
-	wl12xx_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
+	wl1251_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
 
 	wl->scanning = true;
 
-	ret = wl12xx_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
+	ret = wl1251_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
 	if (ret < 0)
-		wl12xx_error("SCAN failed");
+		wl1251_error("SCAN failed");
 
-	wl12xx_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
+	wl1251_spi_mem_read(wl, wl->cmd_box_addr, params, sizeof(*params));
 
 	if (params->header.status != CMD_STATUS_SUCCESS) {
-		wl12xx_error("TEST command answer error: %d",
+		wl1251_error("TEST command answer error: %d",
 			     params->header.status);
 		wl->scanning = false;
 		ret = -EIO;
@@ -945,15 +949,15 @@ out:
 
 }
 
-static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
+static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 			     struct cfg80211_scan_request *req)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 	int ret;
 	u8 *ssid = NULL;
 	size_t ssid_len = 0;
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 hw scan");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
 	if (req->n_ssids) {
 		ssid = req->ssids[0].ssid;
@@ -962,13 +966,13 @@ static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
+	ret = wl1251_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
 
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -976,22 +980,22 @@ out:
 	return ret;
 }
 
-static int wl12xx_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+static int wl1251_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
-	struct wl12xx *wl = hw->priv;
+	struct wl1251 *wl = hw->priv;
 	int ret;
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_acx_rts_threshold(wl, (u16) value);
+	ret = wl1251_acx_rts_threshold(wl, (u16) value);
 	if (ret < 0)
-		wl12xx_warning("wl12xx_op_set_rts_threshold failed: %d", ret);
+		wl1251_warning("wl1251_op_set_rts_threshold failed: %d", ret);
 
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -999,21 +1003,21 @@ out:
 	return ret;
 }
 
-static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
+static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
 				       u32 changed)
 {
-	enum wl12xx_cmd_ps_mode mode;
-	struct wl12xx *wl = hw->priv;
+	enum wl1251_cmd_ps_mode mode;
+	struct wl1251 *wl = hw->priv;
 	struct sk_buff *beacon;
 	int ret;
 
-	wl12xx_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+	wl1251_debug(DEBUG_MAC80211, "mac80211 bss info changed");
 
 	mutex_lock(&wl->mutex);
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
@@ -1021,18 +1025,18 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
 
-			ret = wl12xx_build_ps_poll(wl, wl->aid);
+			ret = wl1251_build_ps_poll(wl, wl->aid);
 			if (ret < 0)
 				goto out_sleep;
 
-			ret = wl12xx_acx_aid(wl, wl->aid);
+			ret = wl1251_acx_aid(wl, wl->aid);
 			if (ret < 0)
 				goto out_sleep;
 
 			/* If we want to go in PSM but we're not there yet */
 			if (wl->psm_requested && !wl->psm) {
 				mode = STATION_POWER_SAVE_MODE;
-				ret = wl12xx_ps_set_mode(wl, mode);
+				ret = wl1251_ps_set_mode(wl, mode);
 				if (ret < 0)
 					goto out_sleep;
 			}
@@ -1040,50 +1044,52 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
 		if (bss_conf->use_short_slot)
-			ret = wl12xx_acx_slot(wl, SLOT_TIME_SHORT);
+			ret = wl1251_acx_slot(wl, SLOT_TIME_SHORT);
 		else
-			ret = wl12xx_acx_slot(wl, SLOT_TIME_LONG);
+			ret = wl1251_acx_slot(wl, SLOT_TIME_LONG);
 		if (ret < 0) {
-			wl12xx_warning("Set slot time failed %d", ret);
+			wl1251_warning("Set slot time failed %d", ret);
 			goto out_sleep;
 		}
 	}
 
 	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
 		if (bss_conf->use_short_preamble)
-			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
+			wl1251_acx_set_preamble(wl, ACX_PREAMBLE_SHORT);
 		else
-			wl12xx_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
+			wl1251_acx_set_preamble(wl, ACX_PREAMBLE_LONG);
 	}
 
 	if (changed & BSS_CHANGED_ERP_CTS_PROT) {
 		if (bss_conf->use_cts_prot)
-			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_ENABLE);
+			ret = wl1251_acx_cts_protect(wl, CTSPROTECT_ENABLE);
 		else
-			ret = wl12xx_acx_cts_protect(wl, CTSPROTECT_DISABLE);
+			ret = wl1251_acx_cts_protect(wl, CTSPROTECT_DISABLE);
 		if (ret < 0) {
-			wl12xx_warning("Set ctsprotect failed %d", ret);
-			goto out_sleep;
+			wl1251_warning("Set ctsprotect failed %d", ret);
+			goto out;
 		}
 	}
 
 	if (changed & BSS_CHANGED_BSSID) {
 		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 
-		ret = wl12xx_build_null_data(wl);
+		ret = wl1251_build_null_data(wl);
 		if (ret < 0)
 			goto out;
 
 		if (wl->bss_type != BSS_TYPE_IBSS) {
-			ret = wl->chip.op_cmd_join(wl, wl->bss_type, 5, 100, 1);
+			ret = wl1251_cmd_join(wl, wl->bss_type, 5, 100, 1);
 			if (ret < 0)
-				goto out;
+				goto out_sleep;
+			wl1251_warning("Set ctsprotect failed %d", ret);
+			goto out_sleep;
 		}
 	}
 
 	if (changed & BSS_CHANGED_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
-		ret = wl12xx_cmd_template_set(wl, CMD_BEACON, beacon->data,
+		ret = wl1251_cmd_template_set(wl, CMD_BEACON, beacon->data,
 					      beacon->len);
 
 		if (ret < 0) {
@@ -1091,7 +1097,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 			goto out;
 		}
 
-		ret = wl12xx_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
+		ret = wl1251_cmd_template_set(wl, CMD_PROBE_RESP, beacon->data,
 					      beacon->len);
 
 		dev_kfree_skb(beacon);
@@ -1106,7 +1112,7 @@ static void wl12xx_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 out_sleep:
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -1114,7 +1120,7 @@ out:
 
 
 /* can't be const, mac80211 writes to this */
-static struct ieee80211_rate wl12xx_rates[] = {
+static struct ieee80211_rate wl1251_rates[] = {
 	{ .bitrate = 10,
 	  .hw_value = 0x1,
 	  .hw_value_short = 0x1, },
@@ -1157,7 +1163,7 @@ static struct ieee80211_rate wl12xx_rates[] = {
 };
 
 /* can't be const, mac80211 writes to this */
-static struct ieee80211_channel wl12xx_channels[] = {
+static struct ieee80211_channel wl1251_channels[] = {
 	{ .hw_value = 1, .center_freq = 2412},
 	{ .hw_value = 2, .center_freq = 2417},
 	{ .hw_value = 3, .center_freq = 2422},
@@ -1174,28 +1180,28 @@ static struct ieee80211_channel wl12xx_channels[] = {
 };
 
 /* can't be const, mac80211 writes to this */
-static struct ieee80211_supported_band wl12xx_band_2ghz = {
-	.channels = wl12xx_channels,
-	.n_channels = ARRAY_SIZE(wl12xx_channels),
-	.bitrates = wl12xx_rates,
-	.n_bitrates = ARRAY_SIZE(wl12xx_rates),
+static struct ieee80211_supported_band wl1251_band_2ghz = {
+	.channels = wl1251_channels,
+	.n_channels = ARRAY_SIZE(wl1251_channels),
+	.bitrates = wl1251_rates,
+	.n_bitrates = ARRAY_SIZE(wl1251_rates),
 };
 
-static const struct ieee80211_ops wl12xx_ops = {
-	.start = wl12xx_op_start,
-	.stop = wl12xx_op_stop,
-	.add_interface = wl12xx_op_add_interface,
-	.remove_interface = wl12xx_op_remove_interface,
-	.config = wl12xx_op_config,
-	.configure_filter = wl12xx_op_configure_filter,
-	.tx = wl12xx_op_tx,
-	.set_key = wl12xx_op_set_key,
-	.hw_scan = wl12xx_op_hw_scan,
-	.bss_info_changed = wl12xx_op_bss_info_changed,
-	.set_rts_threshold = wl12xx_op_set_rts_threshold,
+static const struct ieee80211_ops wl1251_ops = {
+	.start = wl1251_op_start,
+	.stop = wl1251_op_stop,
+	.add_interface = wl1251_op_add_interface,
+	.remove_interface = wl1251_op_remove_interface,
+	.config = wl1251_op_config,
+	.configure_filter = wl1251_op_configure_filter,
+	.tx = wl1251_op_tx,
+	.set_key = wl1251_op_set_key,
+	.hw_scan = wl1251_op_hw_scan,
+	.bss_info_changed = wl1251_op_bss_info_changed,
+	.set_rts_threshold = wl1251_op_set_rts_threshold,
 };
 
-static int wl12xx_register_hw(struct wl12xx *wl)
+static int wl1251_register_hw(struct wl1251 *wl)
 {
 	int ret;
 
@@ -1206,18 +1212,18 @@ static int wl12xx_register_hw(struct wl12xx *wl)
 
 	ret = ieee80211_register_hw(wl->hw);
 	if (ret < 0) {
-		wl12xx_error("unable to register mac80211 hw: %d", ret);
+		wl1251_error("unable to register mac80211 hw: %d", ret);
 		return ret;
 	}
 
 	wl->mac80211_registered = true;
 
-	wl12xx_notice("loaded");
+	wl1251_notice("loaded");
 
 	return 0;
 }
 
-static int wl12xx_init_ieee80211(struct wl12xx *wl)
+static int wl1251_init_ieee80211(struct wl1251 *wl)
 {
 	/* The tx descriptor buffer and the TKIP space */
 	wl->hw->extra_tx_headroom = sizeof(struct tx_double_buffer_desc)
@@ -1232,31 +1238,31 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	wl->hw->wiphy->max_scan_ssids = 1;
-	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
+	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1251_band_2ghz;
 
 	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
 
 	return 0;
 }
 
-#define WL12XX_DEFAULT_CHANNEL 1
-static int __devinit wl12xx_probe(struct spi_device *spi)
+#define WL1251_DEFAULT_CHANNEL 1
+static int __devinit wl1251_probe(struct spi_device *spi)
 {
 	struct wl12xx_platform_data *pdata;
 	struct ieee80211_hw *hw;
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	int ret, i;
 	static const u8 nokia_oui[3] = {0x00, 0x1f, 0xdf};
 
 	pdata = spi->dev.platform_data;
 	if (!pdata) {
-		wl12xx_error("no platform data");
+		wl1251_error("no platform data");
 		return -ENODEV;
 	}
 
-	hw = ieee80211_alloc_hw(sizeof(*wl), &wl12xx_ops);
+	hw = ieee80211_alloc_hw(sizeof(*wl), &wl1251_ops);
 	if (!hw) {
-		wl12xx_error("could not alloc ieee80211_hw");
+		wl1251_error("could not alloc ieee80211_hw");
 		return -ENOMEM;
 	}
 
@@ -1271,8 +1277,8 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	skb_queue_head_init(&wl->tx_queue);
 
-	INIT_WORK(&wl->filter_work, wl12xx_filter_work);
-	wl->channel = WL12XX_DEFAULT_CHANNEL;
+	INIT_WORK(&wl->filter_work, wl1251_filter_work);
+	wl->channel = WL1251_DEFAULT_CHANNEL;
 	wl->scanning = false;
 	wl->default_key = 0;
 	wl->listen_int = 1;
@@ -1280,17 +1286,17 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	wl->rx_handled = 0;
 	wl->rx_current_buffer = 0;
 	wl->rx_last_id = 0;
-	wl->rx_config = WL12XX_DEFAULT_RX_CONFIG;
-	wl->rx_filter = WL12XX_DEFAULT_RX_FILTER;
+	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
 	wl->elp = false;
 	wl->psm = 0;
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
-	wl->power_level = WL12XX_DEFAULT_POWER_LEVEL;
+	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 
 	/* We use the default power on sleep time until we know which chip
 	 * we're using */
-	wl->chip.power_on_sleep = WL12XX_DEFAULT_POWER_ON_SLEEP;
+	wl->chip.power_on_sleep = WL1251_DEFAULT_POWER_ON_SLEEP;
 
 	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
 		wl->tx_frames[i] = NULL;
@@ -1304,7 +1310,7 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	memcpy(wl->mac_addr, nokia_oui, 3);
 	get_random_bytes(wl->mac_addr + 3, 3);
 
-	wl->state = WL12XX_STATE_OFF;
+	wl->state = WL1251_STATE_OFF;
 	mutex_init(&wl->mutex);
 
 	wl->tx_mgmt_frm_rate = DEFAULT_HW_GEN_TX_RATE;
@@ -1312,7 +1318,7 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	wl->rx_descriptor = kmalloc(sizeof(*wl->rx_descriptor), GFP_KERNEL);
 	if (!wl->rx_descriptor) {
-		wl12xx_error("could not allocate memory for rx descriptor");
+		wl1251_error("could not allocate memory for rx descriptor");
 		ret = -ENOMEM;
 		goto out_free;
 	}
@@ -1323,27 +1329,27 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
-		wl12xx_error("spi_setup failed");
+		wl1251_error("spi_setup failed");
 		goto out_free;
 	}
 
 	wl->set_power = pdata->set_power;
 	if (!wl->set_power) {
-		wl12xx_error("set power function missing in platform data");
+		wl1251_error("set power function missing in platform data");
 		ret = -ENODEV;
 		goto out_free;
 	}
 
 	wl->irq = spi->irq;
 	if (wl->irq < 0) {
-		wl12xx_error("irq missing in platform data");
+		wl1251_error("irq missing in platform data");
 		ret = -ENODEV;
 		goto out_free;
 	}
 
-	ret = request_irq(wl->irq, wl12xx_irq, 0, DRIVER_NAME, wl);
+	ret = request_irq(wl->irq, wl1251_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
-		wl12xx_error("request_irq() failed: %d", ret);
+		wl1251_error("request_irq() failed: %d", ret);
 		goto out_free;
 	}
 
@@ -1351,17 +1357,17 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	disable_irq(wl->irq);
 
-	ret = wl12xx_init_ieee80211(wl);
+	ret = wl1251_init_ieee80211(wl);
 	if (ret)
 		goto out_irq;
 
-	ret = wl12xx_register_hw(wl);
+	ret = wl1251_register_hw(wl);
 	if (ret)
 		goto out_irq;
 
-	wl12xx_debugfs_init(wl);
+	wl1251_debugfs_init(wl);
 
-	wl12xx_notice("initialized");
+	wl1251_notice("initialized");
 
 	return 0;
 
@@ -1377,13 +1383,13 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	return ret;
 }
 
-static int __devexit wl12xx_remove(struct spi_device *spi)
+static int __devexit wl1251_remove(struct spi_device *spi)
 {
-	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
+	struct wl1251 *wl = dev_get_drvdata(&spi->dev);
 
 	ieee80211_unregister_hw(wl->hw);
 
-	wl12xx_debugfs_exit(wl);
+	wl1251_debugfs_exit(wl);
 
 	free_irq(wl->irq, wl);
 	kfree(wl->target_mem_map);
@@ -1402,24 +1408,25 @@ static int __devexit wl12xx_remove(struct spi_device *spi)
 }
 
 
-static struct spi_driver wl12xx_spi_driver = {
+static struct spi_driver wl1251_spi_driver = {
 	.driver = {
+		/* FIXME: use wl12xx name to not break the user space */
 		.name		= "wl12xx",
 		.bus		= &spi_bus_type,
 		.owner		= THIS_MODULE,
 	},
 
-	.probe		= wl12xx_probe,
-	.remove		= __devexit_p(wl12xx_remove),
+	.probe		= wl1251_probe,
+	.remove		= __devexit_p(wl1251_remove),
 };
 
-static int __init wl12xx_init(void)
+static int __init wl1251_init(void)
 {
 	int ret;
 
-	ret = spi_register_driver(&wl12xx_spi_driver);
+	ret = spi_register_driver(&wl1251_spi_driver);
 	if (ret < 0) {
-		wl12xx_error("failed to register spi driver: %d", ret);
+		wl1251_error("failed to register spi driver: %d", ret);
 		goto out;
 	}
 
@@ -1427,15 +1434,15 @@ out:
 	return ret;
 }
 
-static void __exit wl12xx_exit(void)
+static void __exit wl1251_exit(void)
 {
-	spi_unregister_driver(&wl12xx_spi_driver);
+	spi_unregister_driver(&wl1251_spi_driver);
 
-	wl12xx_notice("unloaded");
+	wl1251_notice("unloaded");
 }
 
-module_init(wl12xx_init);
-module_exit(wl12xx_exit);
+module_init(wl1251_init);
+module_exit(wl1251_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kalle Valo <Kalle.Valo@nokia.com>, "
diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.c b/drivers/net/wireless/wl12xx/wl1251_netlink.c
index ca9a856..67d3d5a 100644
--- a/drivers/net/wireless/wl12xx/wl1251_netlink.c
+++ b/drivers/net/wireless/wl12xx/wl1251_netlink.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -35,52 +35,52 @@
 #include "wl1251_acx.h"
 
 /* FIXME: this should be changed as soon as user space catches up */
-#define WL12XX_NL_NAME "wl1251"
-#define WL12XX_NL_VERSION 1
-
-#define WL12XX_MAX_TEST_LENGTH 1024
-#define WL12XX_MAX_NVS_LENGTH 1024
-
-enum wl12xx_nl_commands {
-	WL12XX_NL_CMD_UNSPEC,
-	WL12XX_NL_CMD_TEST,
-	WL12XX_NL_CMD_INTERROGATE,
-	WL12XX_NL_CMD_CONFIGURE,
-	WL12XX_NL_CMD_PHY_REG_READ,
-	WL12XX_NL_CMD_NVS_PUSH,
-	WL12XX_NL_CMD_REG_WRITE,
-	WL12XX_NL_CMD_REG_READ,
-	WL12XX_NL_CMD_SET_PLT_MODE,
-
-	__WL12XX_NL_CMD_AFTER_LAST
+#define WL1251_NL_NAME "wl1251"
+#define WL1251_NL_VERSION 1
+
+#define WL1251_MAX_TEST_LENGTH 1024
+#define WL1251_MAX_NVS_LENGTH 1024
+
+enum wl1251_nl_commands {
+	WL1251_NL_CMD_UNSPEC,
+	WL1251_NL_CMD_TEST,
+	WL1251_NL_CMD_INTERROGATE,
+	WL1251_NL_CMD_CONFIGURE,
+	WL1251_NL_CMD_PHY_REG_READ,
+	WL1251_NL_CMD_NVS_PUSH,
+	WL1251_NL_CMD_REG_WRITE,
+	WL1251_NL_CMD_REG_READ,
+	WL1251_NL_CMD_SET_PLT_MODE,
+
+	__WL1251_NL_CMD_AFTER_LAST
 };
-#define WL12XX_NL_CMD_MAX (__WL12XX_NL_CMD_AFTER_LAST - 1)
-
-enum wl12xx_nl_attrs {
-	WL12XX_NL_ATTR_UNSPEC,
-	WL12XX_NL_ATTR_IFNAME,
-	WL12XX_NL_ATTR_CMD_TEST_PARAM,
-	WL12XX_NL_ATTR_CMD_TEST_ANSWER,
-	WL12XX_NL_ATTR_CMD_IE,
-	WL12XX_NL_ATTR_CMD_IE_LEN,
-	WL12XX_NL_ATTR_CMD_IE_BUFFER,
-	WL12XX_NL_ATTR_CMD_IE_ANSWER,
-	WL12XX_NL_ATTR_REG_ADDR,
-	WL12XX_NL_ATTR_REG_VAL,
-	WL12XX_NL_ATTR_NVS_BUFFER,
-	WL12XX_NL_ATTR_NVS_LEN,
-	WL12XX_NL_ATTR_PLT_MODE,
-
-	__WL12XX_NL_ATTR_AFTER_LAST
+#define WL1251_NL_CMD_MAX (__WL1251_NL_CMD_AFTER_LAST - 1)
+
+enum wl1251_nl_attrs {
+	WL1251_NL_ATTR_UNSPEC,
+	WL1251_NL_ATTR_IFNAME,
+	WL1251_NL_ATTR_CMD_TEST_PARAM,
+	WL1251_NL_ATTR_CMD_TEST_ANSWER,
+	WL1251_NL_ATTR_CMD_IE,
+	WL1251_NL_ATTR_CMD_IE_LEN,
+	WL1251_NL_ATTR_CMD_IE_BUFFER,
+	WL1251_NL_ATTR_CMD_IE_ANSWER,
+	WL1251_NL_ATTR_REG_ADDR,
+	WL1251_NL_ATTR_REG_VAL,
+	WL1251_NL_ATTR_NVS_BUFFER,
+	WL1251_NL_ATTR_NVS_LEN,
+	WL1251_NL_ATTR_PLT_MODE,
+
+	__WL1251_NL_ATTR_AFTER_LAST
 };
-#define WL12XX_NL_ATTR_MAX (__WL12XX_NL_ATTR_AFTER_LAST - 1)
+#define WL1251_NL_ATTR_MAX (__WL1251_NL_ATTR_AFTER_LAST - 1)
 
-static struct genl_family wl12xx_nl_family = {
+static struct genl_family wl1251_nl_family = {
 	.id = GENL_ID_GENERATE,
-	.name = WL12XX_NL_NAME,
+	.name = WL1251_NL_NAME,
 	.hdrsize = 0,
-	.version = WL12XX_NL_VERSION,
-	.maxattr = WL12XX_NL_ATTR_MAX,
+	.version = WL1251_NL_VERSION,
+	.maxattr = WL1251_NL_ATTR_MAX,
 };
 
 static struct net_device *ifname_to_netdev(struct net *net,
@@ -88,17 +88,17 @@ static struct net_device *ifname_to_netdev(struct net *net,
 {
 	char *ifname;
 
-	if (!info->attrs[WL12XX_NL_ATTR_IFNAME])
+	if (!info->attrs[WL1251_NL_ATTR_IFNAME])
 		return NULL;
 
-	ifname = nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]);
+	ifname = nla_data(info->attrs[WL1251_NL_ATTR_IFNAME]);
 
-	wl12xx_debug(DEBUG_NETLINK, "Looking for %s", ifname);
+	wl1251_debug(DEBUG_NETLINK, "Looking for %s", ifname);
 
 	return dev_get_by_name(net, ifname);
 }
 
-static struct wl12xx *ifname_to_wl12xx(struct net *net, struct genl_info *info)
+static struct wl1251 *ifname_to_wl1251(struct net *net, struct genl_info *info)
 {
 	struct net_device *netdev;
 	struct wireless_dev *wdev;
@@ -107,25 +107,25 @@ static struct wl12xx *ifname_to_wl12xx(struct net *net, struct genl_info *info)
 
 	netdev = ifname_to_netdev(net, info);
 	if (netdev == NULL) {
-		wl12xx_error("Wrong interface");
+		wl1251_error("Wrong interface");
 		return NULL;
 	}
 
 	wdev = netdev->ieee80211_ptr;
 	if (wdev == NULL) {
-		wl12xx_error("ieee80211_ptr is NULL");
+		wl1251_error("ieee80211_ptr is NULL");
 		return NULL;
 	}
 
 	wiphy = wdev->wiphy;
 	if (wiphy == NULL) {
-		wl12xx_error("wiphy is NULL");
+		wl1251_error("wiphy is NULL");
 		return NULL;
 	}
 
 	hw = wiphy_priv(wiphy);
 	if (hw == NULL) {
-		wl12xx_error("hw is NULL");
+		wl1251_error("hw is NULL");
 		return NULL;
 	}
 
@@ -134,20 +134,20 @@ static struct wl12xx *ifname_to_wl12xx(struct net *net, struct genl_info *info)
 	return hw->priv;
 }
 
-static int wl12xx_nl_test_cmd(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_test_cmd(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
-	struct wl12xx_command *cmd;
+	struct wl1251 *wl;
+	struct wl1251_command *cmd;
 	char *buf;
 	int buf_len, ret, cmd_len;
 	u8 answer;
 
-	if (!info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM])
+	if (!info->attrs[WL1251_NL_ATTR_CMD_TEST_PARAM])
 		return -EINVAL;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		return -EINVAL;
 	}
 
@@ -155,20 +155,20 @@ static int wl12xx_nl_test_cmd(struct sk_buff *skb, struct genl_info *info)
 	if (!cmd)
 		return -ENOMEM;
 
-	buf = nla_data(info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM]);
-	buf_len = nla_len(info->attrs[WL12XX_NL_ATTR_CMD_TEST_PARAM]);
-	answer = nla_get_u8(info->attrs[WL12XX_NL_ATTR_CMD_TEST_ANSWER]);
+	buf = nla_data(info->attrs[WL1251_NL_ATTR_CMD_TEST_PARAM]);
+	buf_len = nla_len(info->attrs[WL1251_NL_ATTR_CMD_TEST_PARAM]);
+	answer = nla_get_u8(info->attrs[WL1251_NL_ATTR_CMD_TEST_ANSWER]);
 
 	cmd->header.id = CMD_TEST;
 	memcpy(cmd->parameters, buf, buf_len);
-	cmd_len = sizeof(struct wl12xx_cmd_header) + buf_len;
+	cmd_len = sizeof(struct wl1251_cmd_header) + buf_len;
 
 	mutex_lock(&wl->mutex);
-	ret = wl12xx_cmd_test(wl, cmd, cmd_len, answer);
+	ret = wl1251_cmd_test(wl, cmd, cmd_len, answer);
 	mutex_unlock(&wl->mutex);
 
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto out;
 	}
 
@@ -183,49 +183,49 @@ static int wl12xx_nl_test_cmd(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
-				  &wl12xx_nl_family, 0, WL12XX_NL_CMD_TEST);
+				  &wl1251_nl_family, 0, WL1251_NL_CMD_TEST);
 		if (IS_ERR(hdr)) {
 			ret = PTR_ERR(hdr);
 			goto nla_put_failure;
 		}
 
-		NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
-			       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
-		NLA_PUT(msg, WL12XX_NL_ATTR_CMD_TEST_ANSWER,
+		NLA_PUT_STRING(msg, WL1251_NL_ATTR_IFNAME,
+			       nla_data(info->attrs[WL1251_NL_ATTR_IFNAME]));
+		NLA_PUT(msg, WL1251_NL_ATTR_CMD_TEST_ANSWER,
 			sizeof(*cmd), cmd);
 
 		ret = genlmsg_end(msg, hdr);
 		if (ret < 0) {
-			wl12xx_error("%s() failed", __func__);
+			wl1251_error("%s() failed", __func__);
 			goto nla_put_failure;
 		}
 
-		wl12xx_debug(DEBUG_NETLINK, "TEST cmd sent, answer");
+		wl1251_debug(DEBUG_NETLINK, "TEST cmd sent, answer");
 		ret = genlmsg_reply(msg, info);
 		goto out;
 
  nla_put_failure:
 		nlmsg_free(msg);
 	} else
-		wl12xx_debug(DEBUG_NETLINK, "TEST cmd sent");
+		wl1251_debug(DEBUG_NETLINK, "TEST cmd sent");
 
 out:
 	kfree(cmd);
 	return ret;
 }
 
-static int wl12xx_nl_interrogate(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_interrogate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	struct sk_buff *msg;
 	int ret = -ENOBUFS, cmd_ie, cmd_ie_len;
-	struct wl12xx_command *cmd;
+	struct wl1251_command *cmd;
 	void *hdr;
 
-	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE])
+	if (!info->attrs[WL1251_NL_ATTR_CMD_IE])
 		return -EINVAL;
 
-	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN])
+	if (!info->attrs[WL1251_NL_ATTR_CMD_IE_LEN])
 		return -EINVAL;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -236,45 +236,45 @@ static int wl12xx_nl_interrogate(struct sk_buff *skb, struct genl_info *info)
 	if (!msg)
 		return -ENOMEM;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		ret = -EINVAL;
 		goto nla_put_failure;
 	}
 
 	/* acx id */
-	cmd_ie = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE]);
+	cmd_ie = nla_get_u32(info->attrs[WL1251_NL_ATTR_CMD_IE]);
 
 	/* maximum length of acx, including all headers */
-	cmd_ie_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN]);
+	cmd_ie_len = nla_get_u32(info->attrs[WL1251_NL_ATTR_CMD_IE_LEN]);
 
-	wl12xx_debug(DEBUG_NETLINK, "Getting IE 0x%x (len %d)",
+	wl1251_debug(DEBUG_NETLINK, "Getting IE 0x%x (len %d)",
 		     cmd_ie, cmd_ie_len);
 
 	mutex_lock(&wl->mutex);
-	ret = wl12xx_cmd_interrogate(wl, cmd_ie, cmd, cmd_ie_len);
+	ret = wl1251_cmd_interrogate(wl, cmd_ie, cmd, cmd_ie_len);
 	mutex_unlock(&wl->mutex);
 
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
 	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
-			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_INTERROGATE);
+			  &wl1251_nl_family, 0, WL1251_NL_CMD_INTERROGATE);
 	if (IS_ERR(hdr)) {
 		ret = PTR_ERR(hdr);
 		goto nla_put_failure;
 	}
 
-	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
-		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
-	NLA_PUT(msg, WL12XX_NL_ATTR_CMD_IE_ANSWER, cmd_ie_len, cmd);
+	NLA_PUT_STRING(msg, WL1251_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL1251_NL_ATTR_IFNAME]));
+	NLA_PUT(msg, WL1251_NL_ATTR_CMD_IE_ANSWER, cmd_ie_len, cmd);
 
 	ret = genlmsg_end(msg, hdr);
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
@@ -288,36 +288,36 @@ static int wl12xx_nl_interrogate(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int wl12xx_nl_configure(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_configure(struct sk_buff *skb, struct genl_info *info)
 {
 	int ret = 0, cmd_ie_len, acx_len;
 	struct acx_header *acx = NULL;
 	struct sk_buff *msg;
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	void *cmd_ie;
 	u16 *id;
 
-	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_BUFFER])
+	if (!info->attrs[WL1251_NL_ATTR_CMD_IE_BUFFER])
 		return -EINVAL;
 
-	if (!info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN])
+	if (!info->attrs[WL1251_NL_ATTR_CMD_IE_LEN])
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		ret = -EINVAL;
 		goto nla_put_failure;
 	}
 
 	/* contains the acx header but not the cmd header */
-	cmd_ie = nla_data(info->attrs[WL12XX_NL_ATTR_CMD_IE_BUFFER]);
+	cmd_ie = nla_data(info->attrs[WL1251_NL_ATTR_CMD_IE_BUFFER]);
 
-	cmd_ie_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_CMD_IE_LEN]);
+	cmd_ie_len = nla_get_u32(info->attrs[WL1251_NL_ATTR_CMD_IE_LEN]);
 
 	/* acx id is in the first two bytes */
 	id = cmd_ie;
@@ -334,15 +334,15 @@ static int wl12xx_nl_configure(struct sk_buff *skb, struct genl_info *info)
 	memcpy(&acx->id, cmd_ie, cmd_ie_len);
 
 	mutex_lock(&wl->mutex);
-	ret = wl12xx_cmd_configure(wl, *id, acx, acx_len);
+	ret = wl1251_cmd_configure(wl, *id, acx, acx_len);
 	mutex_unlock(&wl->mutex);
 
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
-	wl12xx_debug(DEBUG_NETLINK, "CONFIGURE cmd sent");
+	wl1251_debug(DEBUG_NETLINK, "CONFIGURE cmd sent");
 
  nla_put_failure:
 	kfree(acx);
@@ -351,24 +351,24 @@ static int wl12xx_nl_configure(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int wl12xx_nl_phy_reg_read(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_phy_reg_read(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	struct sk_buff *msg;
 	u32 reg_addr, *reg_value = NULL;
 	int ret = 0;
 	void *hdr;
 
-	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+	if (!info->attrs[WL1251_NL_ATTR_REG_ADDR])
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		ret = -EINVAL;
 		goto nla_put_failure;
 	}
@@ -379,36 +379,36 @@ static int wl12xx_nl_phy_reg_read(struct sk_buff *skb, struct genl_info *info)
 		goto nla_put_failure;
 	}
 
-	reg_addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
+	reg_addr = nla_get_u32(info->attrs[WL1251_NL_ATTR_REG_ADDR]);
 
-	wl12xx_debug(DEBUG_NETLINK, "Reading PHY reg 0x%x", reg_addr);
+	wl1251_debug(DEBUG_NETLINK, "Reading PHY reg 0x%x", reg_addr);
 
 	mutex_lock(&wl->mutex);
-	ret = wl12xx_cmd_read_memory(wl, reg_addr, reg_value,
+	ret = wl1251_cmd_read_memory(wl, reg_addr, reg_value,
 				     sizeof(*reg_value));
 	mutex_unlock(&wl->mutex);
 
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
 
 	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
-			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_PHY_REG_READ);
+			  &wl1251_nl_family, 0, WL1251_NL_CMD_PHY_REG_READ);
 	if (IS_ERR(hdr)) {
 		ret = PTR_ERR(hdr);
 		goto nla_put_failure;
 	}
 
-	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
-		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+	NLA_PUT_STRING(msg, WL1251_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL1251_NL_ATTR_IFNAME]));
 
-	NLA_PUT_U32(msg, WL12XX_NL_ATTR_REG_VAL, *reg_value);
+	NLA_PUT_U32(msg, WL1251_NL_ATTR_REG_VAL, *reg_value);
 
 	ret = genlmsg_end(msg, hdr);
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
@@ -423,27 +423,27 @@ static int wl12xx_nl_phy_reg_read(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int wl12xx_nl_nvs_push(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_nvs_push(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	int ret = 0;
 
-	if (!info->attrs[WL12XX_NL_ATTR_NVS_BUFFER])
+	if (!info->attrs[WL1251_NL_ATTR_NVS_BUFFER])
 		return -EINVAL;
 
-	if (!info->attrs[WL12XX_NL_ATTR_NVS_LEN])
+	if (!info->attrs[WL1251_NL_ATTR_NVS_LEN])
 		return -EINVAL;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		return -EINVAL;
 	}
 
 	mutex_lock(&wl->mutex);
-	wl->nvs_len = nla_get_u32(info->attrs[WL12XX_NL_ATTR_NVS_LEN]);
+	wl->nvs_len = nla_get_u32(info->attrs[WL1251_NL_ATTR_NVS_LEN]);
 	if (wl->nvs_len % 4) {
-		wl12xx_error("NVS size is not multiple of 32: %d", wl->nvs_len);
+		wl1251_error("NVS size is not multiple of 32: %d", wl->nvs_len);
 		ret = -EILSEQ;
 		goto out;
 	}
@@ -453,16 +453,16 @@ static int wl12xx_nl_nvs_push(struct sk_buff *skb, struct genl_info *info)
 
 	wl->nvs = kzalloc(wl->nvs_len, GFP_KERNEL);
 	if (wl->nvs == NULL) {
-		wl12xx_error("Can't allocate NVS");
+		wl1251_error("Can't allocate NVS");
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	memcpy(wl->nvs,
-	       nla_data(info->attrs[WL12XX_NL_ATTR_NVS_BUFFER]),
+	       nla_data(info->attrs[WL1251_NL_ATTR_NVS_BUFFER]),
 	       wl->nvs_len);
 
-	wl12xx_debug(DEBUG_NETLINK, "got NVS from userspace, %d bytes",
+	wl1251_debug(DEBUG_NETLINK, "got NVS from userspace, %d bytes",
 		     wl->nvs_len);
 
 out:
@@ -471,48 +471,48 @@ out:
 	return ret;
 }
 
-static int wl12xx_nl_reg_read(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_reg_read(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	u32 addr, val;
 	int ret = 0;
 	struct sk_buff *msg;
 	void *hdr;
 
-	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+	if (!info->attrs[WL1251_NL_ATTR_REG_ADDR])
 		return -EINVAL;
 
 	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		return -EINVAL;
 	}
 
-	addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
+	addr = nla_get_u32(info->attrs[WL1251_NL_ATTR_REG_ADDR]);
 
 	mutex_lock(&wl->mutex);
-	val = wl12xx_reg_read32(wl, addr);
+	val = wl1251_reg_read32(wl, addr);
 	mutex_unlock(&wl->mutex);
 
 	hdr = genlmsg_put(msg, info->snd_pid, info->snd_seq,
-			  &wl12xx_nl_family, 0, WL12XX_NL_CMD_PHY_REG_READ);
+			  &wl1251_nl_family, 0, WL1251_NL_CMD_PHY_REG_READ);
 	if (IS_ERR(hdr)) {
 		ret = PTR_ERR(hdr);
 		goto nla_put_failure;
 	}
 
-	NLA_PUT_STRING(msg, WL12XX_NL_ATTR_IFNAME,
-		       nla_data(info->attrs[WL12XX_NL_ATTR_IFNAME]));
+	NLA_PUT_STRING(msg, WL1251_NL_ATTR_IFNAME,
+		       nla_data(info->attrs[WL1251_NL_ATTR_IFNAME]));
 
-	NLA_PUT_U32(msg, WL12XX_NL_ATTR_REG_VAL, val);
+	NLA_PUT_U32(msg, WL1251_NL_ATTR_REG_VAL, val);
 
 	ret = genlmsg_end(msg, hdr);
 	if (ret < 0) {
-		wl12xx_error("%s() failed", __func__);
+		wl1251_error("%s() failed", __func__);
 		goto nla_put_failure;
 	}
 
@@ -524,56 +524,56 @@ static int wl12xx_nl_reg_read(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static int wl12xx_nl_reg_write(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_reg_write(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	u32 addr, val;
 
-	if (!info->attrs[WL12XX_NL_ATTR_REG_ADDR])
+	if (!info->attrs[WL1251_NL_ATTR_REG_ADDR])
 		return -EINVAL;
 
-	if (!info->attrs[WL12XX_NL_ATTR_REG_VAL])
+	if (!info->attrs[WL1251_NL_ATTR_REG_VAL])
 		return -EINVAL;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		return -EINVAL;
 	}
 
-	addr = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_ADDR]);
-	val = nla_get_u32(info->attrs[WL12XX_NL_ATTR_REG_VAL]);
+	addr = nla_get_u32(info->attrs[WL1251_NL_ATTR_REG_ADDR]);
+	val = nla_get_u32(info->attrs[WL1251_NL_ATTR_REG_VAL]);
 
 	mutex_lock(&wl->mutex);
-	wl12xx_reg_write32(wl, addr, val);
+	wl1251_reg_write32(wl, addr, val);
 	mutex_unlock(&wl->mutex);
 
 	return 0;
 }
 
-static int wl12xx_nl_set_plt_mode(struct sk_buff *skb, struct genl_info *info)
+static int wl1251_nl_set_plt_mode(struct sk_buff *skb, struct genl_info *info)
 {
-	struct wl12xx *wl;
+	struct wl1251 *wl;
 	u32 val;
 	int ret;
 
-	if (!info->attrs[WL12XX_NL_ATTR_PLT_MODE])
+	if (!info->attrs[WL1251_NL_ATTR_PLT_MODE])
 		return -EINVAL;
 
-	wl = ifname_to_wl12xx(&init_net, info);
+	wl = ifname_to_wl1251(&init_net, info);
 	if (wl == NULL) {
-		wl12xx_error("wl12xx not found");
+		wl1251_error("wl1251 not found");
 		return -EINVAL;
 	}
 
-	val = nla_get_u32(info->attrs[WL12XX_NL_ATTR_PLT_MODE]);
+	val = nla_get_u32(info->attrs[WL1251_NL_ATTR_PLT_MODE]);
 
 	switch (val) {
 	case 0:
-		ret = wl12xx_plt_stop(wl);
+		ret = wl1251_plt_stop(wl);
 		break;
 	case 1:
-		ret = wl12xx_plt_start(wl);
+		ret = wl1251_plt_start(wl);
 		break;
 	default:
 		ret = -EINVAL;
@@ -583,97 +583,97 @@ static int wl12xx_nl_set_plt_mode(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
-static struct nla_policy wl12xx_nl_policy[WL12XX_NL_ATTR_MAX + 1] = {
-	[WL12XX_NL_ATTR_IFNAME] =            { .type = NLA_NUL_STRING,
+static struct nla_policy wl1251_nl_policy[WL1251_NL_ATTR_MAX + 1] = {
+	[WL1251_NL_ATTR_IFNAME] =            { .type = NLA_NUL_STRING,
 					       .len = IFNAMSIZ-1 },
-	[WL12XX_NL_ATTR_CMD_TEST_PARAM] =    { .type = NLA_BINARY,
-					       .len = WL12XX_MAX_TEST_LENGTH },
-	[WL12XX_NL_ATTR_CMD_TEST_ANSWER] =   { .type = NLA_U8 },
-	[WL12XX_NL_ATTR_CMD_IE] =            { .type = NLA_U32 },
-	[WL12XX_NL_ATTR_CMD_IE_LEN] =        { .type = NLA_U32 },
-	[WL12XX_NL_ATTR_CMD_IE_BUFFER] =     { .type = NLA_BINARY,
-					       .len = WL12XX_MAX_TEST_LENGTH },
-	[WL12XX_NL_ATTR_CMD_IE_ANSWER] =     { .type = NLA_BINARY,
-					       .len = WL12XX_MAX_TEST_LENGTH },
-	[WL12XX_NL_ATTR_REG_ADDR] =          { .type = NLA_U32 },
-	[WL12XX_NL_ATTR_REG_VAL] =           { .type = NLA_U32 },
-	[WL12XX_NL_ATTR_NVS_BUFFER] =        { .type = NLA_BINARY,
-					       .len = WL12XX_MAX_NVS_LENGTH },
-	[WL12XX_NL_ATTR_NVS_LEN] =           { .type = NLA_U32 },
-	[WL12XX_NL_ATTR_PLT_MODE] =          { .type = NLA_U32 },
+	[WL1251_NL_ATTR_CMD_TEST_PARAM] =    { .type = NLA_BINARY,
+					       .len = WL1251_MAX_TEST_LENGTH },
+	[WL1251_NL_ATTR_CMD_TEST_ANSWER] =   { .type = NLA_U8 },
+	[WL1251_NL_ATTR_CMD_IE] =            { .type = NLA_U32 },
+	[WL1251_NL_ATTR_CMD_IE_LEN] =        { .type = NLA_U32 },
+	[WL1251_NL_ATTR_CMD_IE_BUFFER] =     { .type = NLA_BINARY,
+					       .len = WL1251_MAX_TEST_LENGTH },
+	[WL1251_NL_ATTR_CMD_IE_ANSWER] =     { .type = NLA_BINARY,
+					       .len = WL1251_MAX_TEST_LENGTH },
+	[WL1251_NL_ATTR_REG_ADDR] =          { .type = NLA_U32 },
+	[WL1251_NL_ATTR_REG_VAL] =           { .type = NLA_U32 },
+	[WL1251_NL_ATTR_NVS_BUFFER] =        { .type = NLA_BINARY,
+					       .len = WL1251_MAX_NVS_LENGTH },
+	[WL1251_NL_ATTR_NVS_LEN] =           { .type = NLA_U32 },
+	[WL1251_NL_ATTR_PLT_MODE] =          { .type = NLA_U32 },
 };
 
-static struct genl_ops wl12xx_nl_ops[] = {
+static struct genl_ops wl1251_nl_ops[] = {
 	{
-		.cmd = WL12XX_NL_CMD_TEST,
-		.doit = wl12xx_nl_test_cmd,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_TEST,
+		.doit = wl1251_nl_test_cmd,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_INTERROGATE,
-		.doit = wl12xx_nl_interrogate,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_INTERROGATE,
+		.doit = wl1251_nl_interrogate,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_CONFIGURE,
-		.doit = wl12xx_nl_configure,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_CONFIGURE,
+		.doit = wl1251_nl_configure,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_PHY_REG_READ,
-		.doit = wl12xx_nl_phy_reg_read,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_PHY_REG_READ,
+		.doit = wl1251_nl_phy_reg_read,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_NVS_PUSH,
-		.doit = wl12xx_nl_nvs_push,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_NVS_PUSH,
+		.doit = wl1251_nl_nvs_push,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_REG_WRITE,
-		.doit = wl12xx_nl_reg_write,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_REG_WRITE,
+		.doit = wl1251_nl_reg_write,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_REG_READ,
-		.doit = wl12xx_nl_reg_read,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_REG_READ,
+		.doit = wl1251_nl_reg_read,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
-		.cmd = WL12XX_NL_CMD_SET_PLT_MODE,
-		.doit = wl12xx_nl_set_plt_mode,
-		.policy = wl12xx_nl_policy,
+		.cmd = WL1251_NL_CMD_SET_PLT_MODE,
+		.doit = wl1251_nl_set_plt_mode,
+		.policy = wl1251_nl_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 };
 
-int wl12xx_nl_register(void)
+int wl1251_nl_register(void)
 {
 	int err, i;
 
-	err = genl_register_family(&wl12xx_nl_family);
+	err = genl_register_family(&wl1251_nl_family);
 	if (err)
 		return err;
 
-	for (i = 0; i < ARRAY_SIZE(wl12xx_nl_ops); i++) {
-		err = genl_register_ops(&wl12xx_nl_family, &wl12xx_nl_ops[i]);
+	for (i = 0; i < ARRAY_SIZE(wl1251_nl_ops); i++) {
+		err = genl_register_ops(&wl1251_nl_family, &wl1251_nl_ops[i]);
 		if (err)
 			goto err_out;
 	}
 	return 0;
  err_out:
-	genl_unregister_family(&wl12xx_nl_family);
+	genl_unregister_family(&wl1251_nl_family);
 	return err;
 }
 
-void wl12xx_nl_unregister(void)
+void wl1251_nl_unregister(void)
 {
-	genl_unregister_family(&wl12xx_nl_family);
+	genl_unregister_family(&wl1251_nl_family);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_netlink.h b/drivers/net/wireless/wl12xx/wl1251_netlink.h
index acfbd02..ee36695 100644
--- a/drivers/net/wireless/wl12xx/wl1251_netlink.h
+++ b/drivers/net/wireless/wl12xx/wl1251_netlink.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2009 Nokia Corporation
  *
@@ -21,10 +21,10 @@
  *
  */
 
-#ifndef __WL12XX_NETLINK_H__
-#define __WL12XX_NETLINK_H__
+#ifndef __WL1251_NETLINK_H__
+#define __WL1251_NETLINK_H__
 
-int wl12xx_nl_register(void);
-void wl12xx_nl_unregister(void);
+int wl1251_nl_register(void);
+void wl1251_nl_unregister(void);
 
-#endif /* __WL12XX_NETLINK_H__ */
+#endif /* __WL1251_NETLINK_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.c b/drivers/net/wireless/wl12xx/wl1251_ops.c
index cdfd2c2..96a45f5 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008-2009 Nokia Corporation
  *
@@ -35,7 +35,7 @@
 #include "wl1251_ps.h"
 #include "wl1251_init.h"
 
-static struct wl12xx_partition_set wl1251_part_table[PART_TABLE_LEN] = {
+static struct wl1251_partition_set wl1251_part_table[PART_TABLE_LEN] = {
 	[PART_DOWN] = {
 		.mem = {
 			.start = 0x00000000,
@@ -75,31 +75,31 @@ static enum wl12xx_acx_int_reg wl1251_acx_reg_table[ACX_REG_TABLE_LEN] = {
 	[ACX_REG_ECPU_CONTROL]       = (REGISTERS_BASE + 0x0804)
 };
 
-static int wl1251_upload_firmware(struct wl12xx *wl)
+static int wl1251_upload_firmware(struct wl1251 *wl)
 {
-	struct wl12xx_partition_set *p_table = wl->chip.p_table;
+	struct wl1251_partition_set *p_table = wl->chip.p_table;
 	int addr, chunk_num, partition_limit;
 	size_t fw_data_len;
 	u8 *p;
 
 	/* whal_FwCtrl_LoadFwImageSm() */
 
-	wl12xx_debug(DEBUG_BOOT, "chip id before fw upload: 0x%x",
-		     wl12xx_reg_read32(wl, CHIP_ID_B));
+	wl1251_debug(DEBUG_BOOT, "chip id before fw upload: 0x%x",
+		     wl1251_reg_read32(wl, CHIP_ID_B));
 
 	/* 10.0 check firmware length and set partition */
 	fw_data_len =  (wl->fw[4] << 24) | (wl->fw[5] << 16) |
 		(wl->fw[6] << 8) | (wl->fw[7]);
 
-	wl12xx_debug(DEBUG_BOOT, "fw_data_len %zu chunk_size %d", fw_data_len,
+	wl1251_debug(DEBUG_BOOT, "fw_data_len %zu chunk_size %d", fw_data_len,
 		CHUNK_SIZE);
 
 	if ((fw_data_len % 4) != 0) {
-		wl12xx_error("firmware length not multiple of four");
+		wl1251_error("firmware length not multiple of four");
 		return -EIO;
 	}
 
-	wl12xx_set_partition(wl,
+	wl1251_set_partition(wl,
 			     p_table[PART_DOWN].mem.start,
 			     p_table[PART_DOWN].mem.size,
 			     p_table[PART_DOWN].reg.start,
@@ -118,7 +118,7 @@ static int wl1251_upload_firmware(struct wl12xx *wl)
 				chunk_num * CHUNK_SIZE;
 			partition_limit = chunk_num * CHUNK_SIZE +
 				p_table[PART_DOWN].mem.size;
-			wl12xx_set_partition(wl,
+			wl1251_set_partition(wl,
 					     addr,
 					     p_table[PART_DOWN].mem.size,
 					     p_table[PART_DOWN].reg.start,
@@ -128,9 +128,9 @@ static int wl1251_upload_firmware(struct wl12xx *wl)
 		/* 10.3 upload the chunk */
 		addr = p_table[PART_DOWN].mem.start + chunk_num * CHUNK_SIZE;
 		p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
-		wl12xx_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
+		wl1251_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
 			     p, addr);
-		wl12xx_spi_mem_write(wl, addr, p, CHUNK_SIZE);
+		wl1251_spi_mem_write(wl, addr, p, CHUNK_SIZE);
 
 		chunk_num++;
 	}
@@ -138,14 +138,14 @@ static int wl1251_upload_firmware(struct wl12xx *wl)
 	/* 10.4 upload the last chunk */
 	addr = p_table[PART_DOWN].mem.start + chunk_num * CHUNK_SIZE;
 	p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
-	wl12xx_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
+	wl1251_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
 		     fw_data_len % CHUNK_SIZE, p, addr);
-	wl12xx_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+	wl1251_spi_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
 
 	return 0;
 }
 
-static int wl1251_upload_nvs(struct wl12xx *wl)
+static int wl1251_upload_nvs(struct wl1251 *wl)
 {
 	size_t nvs_len, nvs_bytes_written, burst_len;
 	int nvs_start, i;
@@ -181,10 +181,10 @@ static int wl1251_upload_nvs(struct wl12xx *wl)
 			val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
 			       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
 
-			wl12xx_debug(DEBUG_BOOT,
+			wl1251_debug(DEBUG_BOOT,
 				     "nvs burst write 0x%x: 0x%x",
 				     dest_addr, val);
-			wl12xx_mem_write32(wl, dest_addr, val);
+			wl1251_mem_write32(wl, dest_addr, val);
 
 			nvs_ptr += 4;
 			dest_addr += 4;
@@ -200,7 +200,7 @@ static int wl1251_upload_nvs(struct wl12xx *wl)
 	nvs_len = ALIGN(nvs_len, 4);
 
 	/* Now we must set the partition correctly */
-	wl12xx_set_partition(wl, nvs_start,
+	wl1251_set_partition(wl, nvs_start,
 			     wl->chip.p_table[PART_DOWN].mem.size,
 			     wl->chip.p_table[PART_DOWN].reg.start,
 			     wl->chip.p_table[PART_DOWN].reg.size);
@@ -213,10 +213,10 @@ static int wl1251_upload_nvs(struct wl12xx *wl)
 
 		val = cpu_to_le32(val);
 
-		wl12xx_debug(DEBUG_BOOT,
+		wl1251_debug(DEBUG_BOOT,
 			     "nvs write table 0x%x: 0x%x",
 			     nvs_start, val);
-		wl12xx_mem_write32(wl, nvs_start, val);
+		wl1251_mem_write32(wl, nvs_start, val);
 
 		nvs_ptr += 4;
 		nvs_bytes_written += 4;
@@ -226,12 +226,12 @@ static int wl1251_upload_nvs(struct wl12xx *wl)
 	return 0;
 }
 
-static int wl1251_boot(struct wl12xx *wl)
+static int wl1251_boot(struct wl1251 *wl)
 {
 	int ret = 0, minor_minor_e2_ver;
 	u32 tmp, boot_data;
 
-	ret = wl12xx_boot_soft_reset(wl);
+	ret = wl1251_boot_soft_reset(wl);
 	if (ret < 0)
 		goto out;
 
@@ -242,39 +242,39 @@ static int wl1251_boot(struct wl12xx *wl)
 
 	/* write firmware's last address (ie. it's length) to
 	 * ACX_EEPROMLESS_IND_REG */
-	wl12xx_reg_write32(wl, ACX_EEPROMLESS_IND_REG, wl->fw_len);
+	wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, wl->fw_len);
 
 	/* 6. read the EEPROM parameters */
-	tmp = wl12xx_reg_read32(wl, SCR_PAD2);
+	tmp = wl1251_reg_read32(wl, SCR_PAD2);
 
 	/* 7. read bootdata */
 	wl->boot_attr.radio_type = (tmp & 0x0000FF00) >> 8;
 	wl->boot_attr.major = (tmp & 0x00FF0000) >> 16;
-	tmp = wl12xx_reg_read32(wl, SCR_PAD3);
+	tmp = wl1251_reg_read32(wl, SCR_PAD3);
 
 	/* 8. check bootdata and call restart sequence */
 	wl->boot_attr.minor = (tmp & 0x00FF0000) >> 16;
 	minor_minor_e2_ver = (tmp & 0xFF000000) >> 24;
 
-	wl12xx_debug(DEBUG_BOOT, "radioType 0x%x majorE2Ver 0x%x "
+	wl1251_debug(DEBUG_BOOT, "radioType 0x%x majorE2Ver 0x%x "
 		     "minorE2Ver 0x%x minor_minor_e2_ver 0x%x",
 		     wl->boot_attr.radio_type, wl->boot_attr.major,
 		     wl->boot_attr.minor, minor_minor_e2_ver);
 
-	ret = wl12xx_boot_init_seq(wl);
+	ret = wl1251_boot_init_seq(wl);
 	if (ret < 0)
 		goto out;
 
 	/* 9. NVS processing done */
-	boot_data = wl12xx_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+	boot_data = wl1251_reg_read32(wl, ACX_REG_ECPU_CONTROL);
 
-	wl12xx_debug(DEBUG_BOOT, "halt boot_data 0x%x", boot_data);
+	wl1251_debug(DEBUG_BOOT, "halt boot_data 0x%x", boot_data);
 
 	/* 10. check that ECPU_CONTROL_HALT bits are set in
 	 * pWhalBus->uBootData and start uploading firmware
 	 */
 	if ((boot_data & ECPU_CONTROL_HALT) == 0) {
-		wl12xx_error("boot failed, ECPU_CONTROL_HALT not set");
+		wl1251_error("boot failed, ECPU_CONTROL_HALT not set");
 		ret = -EIO;
 		goto out;
 	}
@@ -284,7 +284,7 @@ static int wl1251_boot(struct wl12xx *wl)
 		goto out;
 
 	/* 10.5 start firmware */
-	ret = wl12xx_boot_run_firmware(wl);
+	ret = wl1251_boot_run_firmware(wl);
 	if (ret < 0)
 		goto out;
 
@@ -292,12 +292,12 @@ out:
 	return ret;
 }
 
-static int wl1251_mem_cfg(struct wl12xx *wl)
+static int wl1251_mem_cfg(struct wl1251 *wl)
 {
 	struct wl1251_acx_config_memory *mem_conf;
 	int ret, i;
 
-	wl12xx_debug(DEBUG_ACX, "wl1251 mem cfg");
+	wl1251_debug(DEBUG_ACX, "wl1251 mem cfg");
 
 	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
 	if (!mem_conf) {
@@ -327,10 +327,10 @@ static int wl1251_mem_cfg(struct wl12xx *wl)
 		mem_conf->tx_queue_config[i].attributes = i;
 	}
 
-	ret = wl12xx_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
+	ret = wl1251_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
 				   sizeof(*mem_conf));
 	if (ret < 0) {
-		wl12xx_warning("wl1251 mem config failed: %d", ret);
+		wl1251_warning("wl1251 mem config failed: %d", ret);
 		goto out;
 	}
 
@@ -339,7 +339,7 @@ out:
 	return ret;
 }
 
-static int wl1251_hw_init_mem_config(struct wl12xx *wl)
+static int wl1251_hw_init_mem_config(struct wl1251 *wl)
 {
 	int ret;
 
@@ -350,15 +350,15 @@ static int wl1251_hw_init_mem_config(struct wl12xx *wl)
 	wl->target_mem_map = kzalloc(sizeof(struct wl1251_acx_mem_map),
 					  GFP_KERNEL);
 	if (!wl->target_mem_map) {
-		wl12xx_error("couldn't allocate target memory map");
+		wl1251_error("couldn't allocate target memory map");
 		return -ENOMEM;
 	}
 
 	/* we now ask for the firmware built memory map */
-	ret = wl12xx_acx_mem_map(wl, wl->target_mem_map,
+	ret = wl1251_acx_mem_map(wl, wl->target_mem_map,
 				 sizeof(struct wl1251_acx_mem_map));
 	if (ret < 0) {
-		wl12xx_error("couldn't retrieve firmware memory map");
+		wl1251_error("couldn't retrieve firmware memory map");
 		kfree(wl->target_mem_map);
 		wl->target_mem_map = NULL;
 		return ret;
@@ -367,19 +367,19 @@ static int wl1251_hw_init_mem_config(struct wl12xx *wl)
 	return 0;
 }
 
-static void wl1251_set_ecpu_ctrl(struct wl12xx *wl, u32 flag)
+static void wl1251_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
 {
 	u32 cpu_ctrl;
 
 	/* 10.5.0 run the firmware (I) */
-	cpu_ctrl = wl12xx_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+	cpu_ctrl = wl1251_reg_read32(wl, ACX_REG_ECPU_CONTROL);
 
 	/* 10.5.1 run the firmware (II) */
 	cpu_ctrl &= ~flag;
-	wl12xx_reg_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+	wl1251_reg_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
 }
 
-static void wl1251_target_enable_interrupts(struct wl12xx *wl)
+static void wl1251_target_enable_interrupts(struct wl1251 *wl)
 {
 	/* Enable target's interrupts */
 	wl->intr_mask = WL1251_ACX_INTR_RX0_DATA |
@@ -388,60 +388,60 @@ static void wl1251_target_enable_interrupts(struct wl12xx *wl)
 		WL1251_ACX_INTR_EVENT_A |
 		WL1251_ACX_INTR_EVENT_B |
 		WL1251_ACX_INTR_INIT_COMPLETE;
-	wl12xx_boot_target_enable_interrupts(wl);
+	wl1251_boot_target_enable_interrupts(wl);
 }
 
-static void wl1251_fw_version(struct wl12xx *wl)
+static void wl1251_fw_version(struct wl1251 *wl)
 {
-	wl12xx_acx_fw_version(wl, wl->chip.fw_ver, sizeof(wl->chip.fw_ver));
+	wl1251_acx_fw_version(wl, wl->chip.fw_ver, sizeof(wl->chip.fw_ver));
 }
 
 static void wl1251_irq_work(struct work_struct *work)
 {
 	u32 intr;
-	struct wl12xx *wl =
-		container_of(work, struct wl12xx, irq_work);
+	struct wl1251 *wl =
+		container_of(work, struct wl1251, irq_work);
 	int ret;
 
 	mutex_lock(&wl->mutex);
 
-	wl12xx_debug(DEBUG_IRQ, "IRQ work");
+	wl1251_debug(DEBUG_IRQ, "IRQ work");
 
-	if (wl->state == WL12XX_STATE_OFF)
+	if (wl->state == WL1251_STATE_OFF)
 		goto out;
 
-	ret = wl12xx_ps_elp_wakeup(wl);
+	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1251_ACX_INTR_ALL);
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1251_ACX_INTR_ALL);
 
-	intr = wl12xx_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
-	wl12xx_debug(DEBUG_IRQ, "intr: 0x%x", intr);
+	intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+	wl1251_debug(DEBUG_IRQ, "intr: 0x%x", intr);
 
 	if (wl->data_path) {
 		wl->rx_counter =
-			wl12xx_mem_read32(wl, wl->data_path->rx_control_addr);
+			wl1251_mem_read32(wl, wl->data_path->rx_control_addr);
 
 		/* We handle a frmware bug here */
 		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
 		case 0:
-			wl12xx_debug(DEBUG_IRQ, "RX: FW and host in sync");
+			wl1251_debug(DEBUG_IRQ, "RX: FW and host in sync");
 			intr &= ~WL1251_ACX_INTR_RX0_DATA;
 			intr &= ~WL1251_ACX_INTR_RX1_DATA;
 			break;
 		case 1:
-			wl12xx_debug(DEBUG_IRQ, "RX: FW +1");
+			wl1251_debug(DEBUG_IRQ, "RX: FW +1");
 			intr |= WL1251_ACX_INTR_RX0_DATA;
 			intr &= ~WL1251_ACX_INTR_RX1_DATA;
 			break;
 		case 2:
-			wl12xx_debug(DEBUG_IRQ, "RX: FW +2");
+			wl1251_debug(DEBUG_IRQ, "RX: FW +2");
 			intr |= WL1251_ACX_INTR_RX0_DATA;
 			intr |= WL1251_ACX_INTR_RX1_DATA;
 			break;
 		default:
-			wl12xx_warning("RX: FW and host out of sync: %d",
+			wl1251_warning("RX: FW and host out of sync: %d",
 				       wl->rx_counter - wl->rx_handled);
 			break;
 		}
@@ -449,49 +449,49 @@ static void wl1251_irq_work(struct work_struct *work)
 		wl->rx_handled = wl->rx_counter;
 
 
-		wl12xx_debug(DEBUG_IRQ, "RX counter: %d", wl->rx_counter);
+		wl1251_debug(DEBUG_IRQ, "RX counter: %d", wl->rx_counter);
 	}
 
 	intr &= wl->intr_mask;
 
 	if (intr == 0) {
-		wl12xx_debug(DEBUG_IRQ, "INTR is 0");
-		wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+		wl1251_debug(DEBUG_IRQ, "INTR is 0");
+		wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
 				   ~(wl->intr_mask));
 
 		goto out_sleep;
 	}
 
 	if (intr & WL1251_ACX_INTR_RX0_DATA) {
-		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX0_DATA");
-		wl12xx_rx(wl);
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX0_DATA");
+		wl1251_rx(wl);
 	}
 
 	if (intr & WL1251_ACX_INTR_RX1_DATA) {
-		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX1_DATA");
-		wl12xx_rx(wl);
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX1_DATA");
+		wl1251_rx(wl);
 	}
 
 	if (intr & WL1251_ACX_INTR_TX_RESULT) {
-		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
 		wl1251_tx_complete(wl);
 	}
 
 	if (intr & (WL1251_ACX_INTR_EVENT_A | WL1251_ACX_INTR_EVENT_B)) {
-		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)", intr);
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)", intr);
 		if (intr & WL1251_ACX_INTR_EVENT_A)
-			wl12xx_event_handle(wl, 0);
+			wl1251_event_handle(wl, 0);
 		else
-			wl12xx_event_handle(wl, 1);
+			wl1251_event_handle(wl, 1);
 	}
 
 	if (intr & WL1251_ACX_INTR_INIT_COMPLETE)
-		wl12xx_debug(DEBUG_IRQ, "WL1251_ACX_INTR_INIT_COMPLETE");
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_INIT_COMPLETE");
 
-	wl12xx_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
 
 out_sleep:
-	wl12xx_ps_elp_sleep(wl);
+	wl1251_ps_elp_sleep(wl);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -529,20 +529,20 @@ static int wl1251_hw_init_txq_fill(u8 qid,
 			(QOS_TX_LOW_VO_DEF * num_blocks) / 100;
 		break;
 	default:
-		wl12xx_error("Invalid TX queue id: %d", qid);
+		wl1251_error("Invalid TX queue id: %d", qid);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static int wl1251_hw_init_tx_queue_config(struct wl12xx *wl)
+static int wl1251_hw_init_tx_queue_config(struct wl1251 *wl)
 {
 	struct acx_tx_queue_qos_config *config;
 	struct wl1251_acx_mem_map *wl_mem_map = wl->target_mem_map;
 	int ret, i;
 
-	wl12xx_debug(DEBUG_ACX, "acx tx queue config");
+	wl1251_debug(DEBUG_ACX, "acx tx queue config");
 
 	config = kzalloc(sizeof(*config), GFP_KERNEL);
 	if (!config) {
@@ -556,7 +556,7 @@ static int wl1251_hw_init_tx_queue_config(struct wl12xx *wl)
 		if (ret < 0)
 			goto out;
 
-		ret = wl12xx_cmd_configure(wl, ACX_TX_QUEUE_CFG,
+		ret = wl1251_cmd_configure(wl, ACX_TX_QUEUE_CFG,
 					   config, sizeof(*config));
 		if (ret < 0)
 			goto out;
@@ -567,7 +567,7 @@ out:
 	return ret;
 }
 
-static int wl1251_hw_init_data_path_config(struct wl12xx *wl)
+static int wl1251_hw_init_data_path_config(struct wl1251 *wl)
 {
 	int ret;
 
@@ -575,11 +575,11 @@ static int wl1251_hw_init_data_path_config(struct wl12xx *wl)
 	wl->data_path = kzalloc(sizeof(struct acx_data_path_params_resp),
 				GFP_KERNEL);
 	if (!wl->data_path) {
-		wl12xx_error("Couldnt allocate data path parameters");
+		wl1251_error("Couldnt allocate data path parameters");
 		return -ENOMEM;
 	}
 
-	ret = wl12xx_acx_data_path_params(wl, wl->data_path);
+	ret = wl1251_acx_data_path_params(wl, wl->data_path);
 	if (ret < 0) {
 		kfree(wl->data_path);
 		wl->data_path = NULL;
@@ -589,17 +589,17 @@ static int wl1251_hw_init_data_path_config(struct wl12xx *wl)
 	return 0;
 }
 
-static int wl1251_hw_init(struct wl12xx *wl)
+static int wl1251_hw_init(struct wl1251 *wl)
 {
 	struct wl1251_acx_mem_map *wl_mem_map;
 	int ret;
 
-	ret = wl12xx_hw_init_hwenc_config(wl);
+	ret = wl1251_hw_init_hwenc_config(wl);
 	if (ret < 0)
 		return ret;
 
 	/* Template settings */
-	ret = wl12xx_hw_init_templates_config(wl);
+	ret = wl1251_hw_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
 
@@ -614,7 +614,7 @@ static int wl1251_hw_init(struct wl12xx *wl)
 		goto out_free_memmap;
 
 	/* RX config */
-	ret = wl12xx_hw_init_rx_config(wl,
+	ret = wl1251_hw_init_rx_config(wl,
 				       RX_CFG_PROMISCUOUS | RX_CFG_TSF,
 				       RX_FILTER_OPTION_DEF);
 	/* RX_CONFIG_OPTION_ANY_DST_ANY_BSS,
@@ -628,42 +628,42 @@ static int wl1251_hw_init(struct wl12xx *wl)
 		goto out_free_data_path;
 
 	/* PHY layer config */
-	ret = wl12xx_hw_init_phy_config(wl);
+	ret = wl1251_hw_init_phy_config(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Beacon filtering */
-	ret = wl12xx_hw_init_beacon_filter(wl);
+	ret = wl1251_hw_init_beacon_filter(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Bluetooth WLAN coexistence */
-	ret = wl12xx_hw_init_pta(wl);
+	ret = wl1251_hw_init_pta(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Energy detection */
-	ret = wl12xx_hw_init_energy_detection(wl);
+	ret = wl1251_hw_init_energy_detection(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Beacons and boradcast settings */
-	ret = wl12xx_hw_init_beacon_broadcast(wl);
+	ret = wl1251_hw_init_beacon_broadcast(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Enable data path */
-	ret = wl12xx_cmd_data_path(wl, wl->channel, 1);
+	ret = wl1251_cmd_data_path(wl, wl->channel, 1);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	/* Default power state */
-	ret = wl12xx_hw_init_power_auth(wl);
+	ret = wl1251_hw_init_power_auth(wl);
 	if (ret < 0)
 		goto out_free_data_path;
 
 	wl_mem_map = wl->target_mem_map;
-	wl12xx_info("%d tx blocks at 0x%x, %d rx blocks at 0x%x",
+	wl1251_info("%d tx blocks at 0x%x, %d rx blocks at 0x%x",
 		    wl_mem_map->num_tx_mem_blocks,
 		    wl->data_path->tx_control_addr,
 		    wl_mem_map->num_rx_mem_blocks,
@@ -680,7 +680,7 @@ static int wl1251_hw_init(struct wl12xx *wl)
 	return ret;
 }
 
-static int wl1251_plt_init(struct wl12xx *wl)
+static int wl1251_plt_init(struct wl1251 *wl)
 {
 	int ret;
 
@@ -688,14 +688,14 @@ static int wl1251_plt_init(struct wl12xx *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl12xx_cmd_data_path(wl, wl->channel, 1);
+	ret = wl1251_cmd_data_path(wl, wl->channel, 1);
 	if (ret < 0)
 		return ret;
 
 	return 0;
 }
 
-void wl1251_setup(struct wl12xx *wl)
+void wl1251_setup(struct wl1251 *wl)
 {
 	/* FIXME: Is it better to use strncpy here or is this ok? */
 	wl->chip.fw_filename = WL1251_FW_NAME;
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.h b/drivers/net/wireless/wl12xx/wl1251_ops.h
index c5c997b..68183c4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ops.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ops.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -34,7 +34,7 @@
 
 #define WL1251_POWER_ON_SLEEP 10 /* in miliseconds */
 
-void wl1251_setup(struct wl12xx *wl);
+void wl1251_setup(struct wl1251 *wl);
 
 
 struct wl1251_acx_memory {
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.c b/drivers/net/wireless/wl12xx/wl1251_ps.c
index 83baaa2..68ff7f1 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -25,22 +25,22 @@
 #include "wl1251_ps.h"
 #include "wl1251_spi.h"
 
-#define WL12XX_WAKEUP_TIMEOUT 2000
+#define WL1251_WAKEUP_TIMEOUT 2000
 
 /* Routines to toggle sleep mode while in ELP */
-void wl12xx_ps_elp_sleep(struct wl12xx *wl)
+void wl1251_ps_elp_sleep(struct wl1251 *wl)
 {
 	if (wl->elp || !wl->psm)
 		return;
 
-	wl12xx_debug(DEBUG_PSM, "chip to elp");
+	wl1251_debug(DEBUG_PSM, "chip to elp");
 
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
+	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
 
 	wl->elp = true;
 }
 
-int wl12xx_ps_elp_wakeup(struct wl12xx *wl)
+int wl1251_ps_elp_wakeup(struct wl1251 *wl)
 {
 	unsigned long timeout;
 	u32 elp_reg;
@@ -48,13 +48,13 @@ int wl12xx_ps_elp_wakeup(struct wl12xx *wl)
 	if (!wl->elp)
 		return 0;
 
-	wl12xx_debug(DEBUG_PSM, "waking up chip from elp");
+	wl1251_debug(DEBUG_PSM, "waking up chip from elp");
 
-	timeout = jiffies + msecs_to_jiffies(WL12XX_WAKEUP_TIMEOUT);
+	timeout = jiffies + msecs_to_jiffies(WL1251_WAKEUP_TIMEOUT);
 
-	wl12xx_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
+	wl1251_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_WAKE_UP);
 
-	elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+	elp_reg = wl1251_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
 
 	/*
 	 * FIXME: we should wait for irq from chip but, as a temporary
@@ -62,36 +62,36 @@ int wl12xx_ps_elp_wakeup(struct wl12xx *wl)
 	 */
 	while (!(elp_reg & ELPCTRL_WLAN_READY)) {
 		if (time_after(jiffies, timeout)) {
-			wl12xx_error("elp wakeup timeout");
+			wl1251_error("elp wakeup timeout");
 			return -ETIMEDOUT;
 		}
 		msleep(1);
-		elp_reg = wl12xx_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
+		elp_reg = wl1251_read32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR);
 	}
 
-	wl12xx_debug(DEBUG_PSM, "wakeup time: %u ms",
+	wl1251_debug(DEBUG_PSM, "wakeup time: %u ms",
 		     jiffies_to_msecs(jiffies) -
-		     (jiffies_to_msecs(timeout) - WL12XX_WAKEUP_TIMEOUT));
+		     (jiffies_to_msecs(timeout) - WL1251_WAKEUP_TIMEOUT));
 
 	wl->elp = false;
 
 	return 0;
 }
 
-static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
+static int wl1251_ps_set_elp(struct wl1251 *wl, bool enable)
 {
 	int ret;
 
 	if (enable) {
-		wl12xx_debug(DEBUG_PSM, "sleep auth psm/elp");
+		wl1251_debug(DEBUG_PSM, "sleep auth psm/elp");
 
-		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_ELP);
+		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_ELP);
 		if (ret < 0)
 			return ret;
 
-		wl12xx_ps_elp_sleep(wl);
+		wl1251_ps_elp_sleep(wl);
 	} else {
-		wl12xx_debug(DEBUG_PSM, "sleep auth cam");
+		wl1251_debug(DEBUG_PSM, "sleep auth cam");
 
 		/*
 		 * When the target is in ELP, we can only
@@ -100,9 +100,9 @@ static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
 		 * changing the power authorization.
 		 */
 
-		wl12xx_ps_elp_wakeup(wl);
+		wl1251_ps_elp_wakeup(wl);
 
-		ret = wl12xx_acx_sleep_auth(wl, WL12XX_PSM_CAM);
+		ret = wl1251_acx_sleep_auth(wl, WL1251_PSM_CAM);
 		if (ret < 0)
 			return ret;
 	}
@@ -110,18 +110,18 @@ static int wl12xx_ps_set_elp(struct wl12xx *wl, bool enable)
 	return 0;
 }
 
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode)
+int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode)
 {
 	int ret;
 
 	switch (mode) {
 	case STATION_POWER_SAVE_MODE:
-		wl12xx_debug(DEBUG_PSM, "entering psm");
-		ret = wl12xx_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
+		wl1251_debug(DEBUG_PSM, "entering psm");
+		ret = wl1251_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
 
-		ret = wl12xx_ps_set_elp(wl, true);
+		ret = wl1251_ps_set_elp(wl, true);
 		if (ret < 0)
 			return ret;
 
@@ -129,12 +129,12 @@ int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode)
 		break;
 	case STATION_ACTIVE_MODE:
 	default:
-		wl12xx_debug(DEBUG_PSM, "leaving psm");
-		ret = wl12xx_ps_set_elp(wl, false);
+		wl1251_debug(DEBUG_PSM, "leaving psm");
+		ret = wl1251_ps_set_elp(wl, false);
 		if (ret < 0)
 			return ret;
 
-		ret = wl12xx_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
+		ret = wl1251_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/wl1251_ps.h b/drivers/net/wireless/wl12xx/wl1251_ps.h
index 8877842..db036fe 100644
--- a/drivers/net/wireless/wl12xx/wl1251_ps.h
+++ b/drivers/net/wireless/wl12xx/wl1251_ps.h
@@ -1,8 +1,8 @@
-#ifndef __WL12XX_PS_H__
-#define __WL12XX_PS_H__
+#ifndef __WL1251_PS_H__
+#define __WL1251_PS_H__
 
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -28,9 +28,9 @@
 #include "wl1251.h"
 #include "wl1251_acx.h"
 
-int wl12xx_ps_set_mode(struct wl12xx *wl, enum wl12xx_cmd_ps_mode mode);
-void wl12xx_ps_elp_sleep(struct wl12xx *wl);
-int wl12xx_ps_elp_wakeup(struct wl12xx *wl);
+int wl1251_ps_set_mode(struct wl1251 *wl, enum wl1251_cmd_ps_mode mode);
+void wl1251_ps_elp_sleep(struct wl1251 *wl);
+int wl1251_ps_elp_wakeup(struct wl1251 *wl);
 
 
-#endif /* __WL12XX_PS_H__ */
+#endif /* __WL1251_PS_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.c b/drivers/net/wireless/wl12xx/wl1251_rx.c
index 280fc18..48fa39e 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -31,8 +31,8 @@
 #include "wl1251_rx.h"
 #include "wl1251_acx.h"
 
-static void wl12xx_rx_header(struct wl12xx *wl,
-			     struct wl12xx_rx_descriptor *desc)
+static void wl1251_rx_header(struct wl1251 *wl,
+			     struct wl1251_rx_descriptor *desc)
 {
 	u32 rx_packet_ring_addr;
 
@@ -40,11 +40,11 @@ static void wl12xx_rx_header(struct wl12xx *wl,
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
+	wl1251_spi_mem_read(wl, rx_packet_ring_addr, desc, sizeof(*desc));
 }
 
-static void wl12xx_rx_status(struct wl12xx *wl,
-			     struct wl12xx_rx_descriptor *desc,
+static void wl1251_rx_status(struct wl1251 *wl,
+			     struct wl1251_rx_descriptor *desc,
 			     struct ieee80211_rx_status *status,
 			     u8 beacon)
 {
@@ -65,14 +65,14 @@ static void wl12xx_rx_status(struct wl12xx *wl,
 	 * this one must be atomic, while our SPI routines can sleep.
 	 */
 	if ((wl->bss_type == BSS_TYPE_IBSS) && beacon) {
-		ret = wl12xx_acx_tsf_info(wl, &mactime);
+		ret = wl1251_acx_tsf_info(wl, &mactime);
 		if (ret == 0)
 			status->mactime = mactime;
 	}
 
 	status->signal = desc->rssi;
-	status->qual = (desc->rssi - WL12XX_RX_MIN_RSSI) * 100 /
-		(WL12XX_RX_MAX_RSSI - WL12XX_RX_MIN_RSSI);
+	status->qual = (desc->rssi - WL1251_RX_MIN_RSSI) * 100 /
+		(WL1251_RX_MAX_RSSI - WL1251_RX_MIN_RSSI);
 	status->qual = min(status->qual, 100);
 	status->qual = max(status->qual, 0);
 
@@ -103,8 +103,8 @@ static void wl12xx_rx_status(struct wl12xx *wl,
 	/* FIXME: set status->rate_idx */
 }
 
-static void wl12xx_rx_body(struct wl12xx *wl,
-			   struct wl12xx_rx_descriptor *desc)
+static void wl1251_rx_body(struct wl1251 *wl,
+			   struct wl1251_rx_descriptor *desc)
 {
 	struct sk_buff *skb;
 	struct ieee80211_rx_status status;
@@ -112,12 +112,12 @@ static void wl12xx_rx_body(struct wl12xx *wl,
 	u16 length, *fc;
 	u32 curr_id, last_id_inc, rx_packet_ring_addr;
 
-	length = WL12XX_RX_ALIGN(desc->length  - PLCP_HEADER_LENGTH);
+	length = WL1251_RX_ALIGN(desc->length  - PLCP_HEADER_LENGTH);
 	curr_id = (desc->flags & RX_DESC_SEQNUM_MASK) >> RX_DESC_PACKETID_SHIFT;
 	last_id_inc = (wl->rx_last_id + 1) % (RX_MAX_PACKET_ID + 1);
 
 	if (last_id_inc != curr_id) {
-		wl12xx_warning("curr ID:%d, last ID inc:%d",
+		wl1251_warning("curr ID:%d, last ID inc:%d",
 			       curr_id, last_id_inc);
 		wl->rx_last_id = curr_id;
 	} else {
@@ -125,18 +125,18 @@ static void wl12xx_rx_body(struct wl12xx *wl,
 	}
 
 	rx_packet_ring_addr = wl->data_path->rx_packet_ring_addr +
-		sizeof(struct wl12xx_rx_descriptor) + 20;
+		sizeof(struct wl1251_rx_descriptor) + 20;
 	if (wl->rx_current_buffer)
 		rx_packet_ring_addr += wl->data_path->rx_packet_ring_chunk_size;
 
 	skb = dev_alloc_skb(length);
 	if (!skb) {
-		wl12xx_error("Couldn't allocate RX frame");
+		wl1251_error("Couldn't allocate RX frame");
 		return;
 	}
 
 	rx_buffer = skb_put(skb, length);
-	wl12xx_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
+	wl1251_spi_mem_read(wl, rx_packet_ring_addr, rx_buffer, length);
 
 	/* The actual lenght doesn't include the target's alignment */
 	skb->len = desc->length  - PLCP_HEADER_LENGTH;
@@ -146,15 +146,15 @@ static void wl12xx_rx_body(struct wl12xx *wl,
 	if ((*fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON)
 		beacon = 1;
 
-	wl12xx_rx_status(wl, desc, &status, beacon);
+	wl1251_rx_status(wl, desc, &status, beacon);
 
-	wl12xx_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
+	wl1251_debug(DEBUG_RX, "rx skb 0x%p: %d B %s", skb, skb->len,
 		     beacon ? "beacon" : "");
 
 	ieee80211_rx(wl->hw, skb, &status);
 }
 
-static void wl12xx_rx_ack(struct wl12xx *wl)
+static void wl1251_rx_ack(struct wl1251 *wl)
 {
 	u32 data, addr;
 
@@ -166,30 +166,30 @@ static void wl12xx_rx_ack(struct wl12xx *wl)
 		data = INTR_TRIG_RX_PROC0;
 	}
 
-	wl12xx_reg_write32(wl, addr, data);
+	wl1251_reg_write32(wl, addr, data);
 
 	/* Toggle buffer ring */
 	wl->rx_current_buffer = !wl->rx_current_buffer;
 }
 
 
-void wl12xx_rx(struct wl12xx *wl)
+void wl1251_rx(struct wl1251 *wl)
 {
-	struct wl12xx_rx_descriptor *rx_desc;
+	struct wl1251_rx_descriptor *rx_desc;
 
-	if (wl->state != WL12XX_STATE_ON)
+	if (wl->state != WL1251_STATE_ON)
 		return;
 
 	rx_desc = wl->rx_descriptor;
 
 	/* We first read the frame's header */
-	wl12xx_rx_header(wl, rx_desc);
+	wl1251_rx_header(wl, rx_desc);
 
 	/* Now we can read the body */
-	wl12xx_rx_body(wl, rx_desc);
+	wl1251_rx_body(wl, rx_desc);
 
 	/* Finally, we need to ACK the RX */
-	wl12xx_rx_ack(wl);
+	wl1251_rx_ack(wl);
 
 	return;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_rx.h b/drivers/net/wireless/wl12xx/wl1251_rx.h
index 4379c53..81156b9 100644
--- a/drivers/net/wireless/wl12xx/wl1251_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_rx.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -22,8 +22,8 @@
  *
  */
 
-#ifndef __WL12XX_RX_H__
-#define __WL12XX_RX_H__
+#ifndef __WL1251_RX_H__
+#define __WL1251_RX_H__
 
 #include <linux/bitops.h>
 
@@ -45,12 +45,12 @@
  * 4) The target prepares the next RX packet.
  */
 
-#define WL12XX_RX_MAX_RSSI -30
-#define WL12XX_RX_MIN_RSSI -95
+#define WL1251_RX_MAX_RSSI -30
+#define WL1251_RX_MIN_RSSI -95
 
-#define WL12XX_RX_ALIGN_TO 4
-#define WL12XX_RX_ALIGN(len) (((len) + WL12XX_RX_ALIGN_TO - 1) & \
-			     ~(WL12XX_RX_ALIGN_TO - 1))
+#define WL1251_RX_ALIGN_TO 4
+#define WL1251_RX_ALIGN(len) (((len) + WL1251_RX_ALIGN_TO - 1) & \
+			     ~(WL1251_RX_ALIGN_TO - 1))
 
 #define SHORT_PREAMBLE_BIT   BIT(0)
 #define OFDM_RATE_BIT        BIT(6)
@@ -74,7 +74,7 @@
 #define	RX_DESC_MIC_FAIL	  0x2000
 #define	RX_DESC_DECRYPT_FAIL	  0x4000
 
-struct wl12xx_rx_descriptor {
+struct wl1251_rx_descriptor {
 	u32 timestamp; /* In microseconds */
 	u16 length; /* Paylod length, including headers */
 	u16 flags;
@@ -119,6 +119,6 @@ struct wl12xx_rx_descriptor {
 	u8 snr; /* in dB */
 } __attribute__ ((packed));
 
-void wl12xx_rx(struct wl12xx *wl);
+void wl1251_rx(struct wl1251 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 5b4889e..c5da79d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (C) 2008 Nokia Corporation
  *
@@ -26,11 +26,10 @@
 #include <linux/spi/spi.h>
 
 #include "wl1251.h"
-#include "wl12xx_80211.h"
 #include "reg.h"
 #include "wl1251_spi.h"
 
-static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
+static int wl1251_translate_reg_addr(struct wl1251 *wl, int addr)
 {
 	/* If the address is lower than REGISTERS_BASE, it means that this is
 	 * a chip-specific register address, so look it up in the registers
@@ -38,7 +37,7 @@ static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
 	if (addr < REGISTERS_BASE) {
 		/* Make sure we don't go over the table */
 		if (addr >= ACX_REG_TABLE_LEN) {
-			wl12xx_error("address out of range (%d)", addr);
+			wl1251_error("address out of range (%d)", addr);
 			return -EINVAL;
 		}
 		addr = wl->chip.acx_reg_table[addr];
@@ -47,13 +46,13 @@ static int wl12xx_translate_reg_addr(struct wl12xx *wl, int addr)
 	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
 }
 
-static int wl12xx_translate_mem_addr(struct wl12xx *wl, int addr)
+static int wl1251_translate_mem_addr(struct wl1251 *wl, int addr)
 {
 	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
 }
 
 
-void wl12xx_spi_reset(struct wl12xx *wl)
+void wl1251_spi_reset(struct wl1251 *wl)
 {
 	u8 *cmd;
 	struct spi_transfer t;
@@ -61,7 +60,7 @@ void wl12xx_spi_reset(struct wl12xx *wl)
 
 	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
-		wl12xx_error("could not allocate cmd for spi reset");
+		wl1251_error("could not allocate cmd for spi reset");
 		return;
 	}
 
@@ -76,10 +75,10 @@ void wl12xx_spi_reset(struct wl12xx *wl)
 
 	spi_sync(wl->spi, &m);
 
-	wl12xx_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+	wl1251_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
-void wl12xx_spi_init(struct wl12xx *wl)
+void wl1251_spi_init(struct wl1251 *wl)
 {
 	u8 crc[WSPI_INIT_CMD_CRC_LEN], *cmd;
 	struct spi_transfer t;
@@ -87,7 +86,7 @@ void wl12xx_spi_init(struct wl12xx *wl)
 
 	cmd = kzalloc(WSPI_INIT_CMD_LEN, GFP_KERNEL);
 	if (!cmd) {
-		wl12xx_error("could not allocate cmd for spi init");
+		wl1251_error("could not allocate cmd for spi init");
 		return;
 	}
 
@@ -130,7 +129,7 @@ void wl12xx_spi_init(struct wl12xx *wl)
 
 	spi_sync(wl->spi, &m);
 
-	wl12xx_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
+	wl1251_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
 }
 
 /* Set the SPI partitions to access the chip addresses
@@ -166,18 +165,18 @@ void wl12xx_spi_init(struct wl12xx *wl)
  *                                    |    |
  *
  */
-int wl12xx_set_partition(struct wl12xx *wl,
+int wl1251_set_partition(struct wl1251 *wl,
 			  u32 mem_start, u32 mem_size,
 			  u32 reg_start, u32 reg_size)
 {
-	struct wl12xx_partition *partition;
+	struct wl1251_partition *partition;
 	struct spi_transfer t;
 	struct spi_message m;
 	size_t len, cmd_len;
 	u32 *cmd;
 	int addr;
 
-	cmd_len = sizeof(u32) + 2 * sizeof(struct wl12xx_partition);
+	cmd_len = sizeof(u32) + 2 * sizeof(struct wl1251_partition);
 	cmd = kzalloc(cmd_len, GFP_KERNEL);
 	if (!cmd)
 		return -ENOMEM;
@@ -185,28 +184,28 @@ int wl12xx_set_partition(struct wl12xx *wl,
 	spi_message_init(&m);
 	memset(&t, 0, sizeof(t));
 
-	partition = (struct wl12xx_partition *) (cmd + 1);
+	partition = (struct wl1251_partition *) (cmd + 1);
 	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl12xx_partition);
+	len = 2 * sizeof(struct wl1251_partition);
 
 	*cmd |= WSPI_CMD_WRITE;
 	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
 	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
-	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+	wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 		     mem_start, mem_size);
-	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+	wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
 		     reg_start, reg_size);
 
 	/* Make sure that the two partitions together don't exceed the
 	 * address range */
 	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+		wl1251_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
 			     " address range.  Truncating partition[0].");
 		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
 			     reg_start, reg_size);
 	}
 
@@ -214,23 +213,23 @@ int wl12xx_set_partition(struct wl12xx *wl,
 	    ((mem_start + mem_size) > reg_start)) {
 		/* Guarantee that the memory partition doesn't overlap the
 		 * registers partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
+		wl1251_debug(DEBUG_SPI, "End of partition[0] is "
 			     "overlapping partition[1].  Adjusted.");
 		mem_size = reg_start - mem_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
 			     reg_start, reg_size);
 	} else if ((reg_start < mem_start) &&
 		   ((reg_start + reg_size) > mem_start)) {
 		/* Guarantee that the register partition doesn't overlap the
 		 * memory partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
+		wl1251_debug(DEBUG_SPI, "End of partition[1] is"
 			     " overlapping partition[0].  Adjusted.");
 		reg_size = mem_start - reg_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
 			     reg_start, reg_size);
 	}
 
@@ -256,7 +255,7 @@ int wl12xx_set_partition(struct wl12xx *wl,
 	return 0;
 }
 
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 		     size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
@@ -284,7 +283,7 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 
 	/* Busy and non busy words read */
 	t[1].rx_buf = busy_buf;
-	t[1].len = WL12XX_BUSY_WORD_LEN;
+	t[1].len = WL1251_BUSY_WORD_LEN;
 	spi_message_add_tail(&t[1], &m);
 
 	t[2].rx_buf = buf;
@@ -295,11 +294,11 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 
 	/* FIXME: check busy words */
 
-	wl12xx_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
-	wl12xx_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
+	wl1251_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
+	wl1251_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
 		      size_t len, bool fixed)
 {
 	struct spi_transfer t[2];
@@ -329,66 +328,66 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 
 	spi_sync(wl->spi, &m);
 
-	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
-	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
+	wl1251_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
+	wl1251_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf,
 			 size_t len)
 {
 	int physical;
 
-	physical = wl12xx_translate_mem_addr(wl, addr);
+	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_read(wl, physical, buf, len, false);
+	wl1251_spi_read(wl, physical, buf, len, false);
 }
 
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf,
 			  size_t len)
 {
 	int physical;
 
-	physical = wl12xx_translate_mem_addr(wl, addr);
+	physical = wl1251_translate_mem_addr(wl, addr);
 
-	wl12xx_spi_write(wl, physical, buf, len, false);
+	wl1251_spi_write(wl, physical, buf, len, false);
 }
 
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len,
 			 bool fixed)
 {
 	int physical;
 
-	physical = wl12xx_translate_reg_addr(wl, addr);
+	physical = wl1251_translate_reg_addr(wl, addr);
 
-	wl12xx_spi_read(wl, physical, buf, len, fixed);
+	wl1251_spi_read(wl, physical, buf, len, fixed);
 }
 
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len,
 			  bool fixed)
 {
 	int physical;
 
-	physical = wl12xx_translate_reg_addr(wl, addr);
+	physical = wl1251_translate_reg_addr(wl, addr);
 
-	wl12xx_spi_write(wl, physical, buf, len, fixed);
+	wl1251_spi_write(wl, physical, buf, len, fixed);
 }
 
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr)
+u32 wl1251_mem_read32(struct wl1251 *wl, int addr)
 {
-	return wl12xx_read32(wl, wl12xx_translate_mem_addr(wl, addr));
+	return wl1251_read32(wl, wl1251_translate_mem_addr(wl, addr));
 }
 
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val)
+void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val)
 {
-	wl12xx_write32(wl, wl12xx_translate_mem_addr(wl, addr), val);
+	wl1251_write32(wl, wl1251_translate_mem_addr(wl, addr), val);
 }
 
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr)
+u32 wl1251_reg_read32(struct wl1251 *wl, int addr)
 {
-	return wl12xx_read32(wl, wl12xx_translate_reg_addr(wl, addr));
+	return wl1251_read32(wl, wl1251_translate_reg_addr(wl, addr));
 }
 
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
+void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val)
 {
-	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
+	wl1251_write32(wl, wl1251_translate_reg_addr(wl, addr), val);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index 82b009c..6e8daf4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -22,8 +22,8 @@
  *
  */
 
-#ifndef __WL12XX_SPI_H__
-#define __WL12XX_SPI_H__
+#ifndef __WL1251_SPI_H__
+#define __WL1251_SPI_H__
 
 #include "wl1251_cmd.h"
 #include "wl1251_acx.h"
@@ -66,50 +66,50 @@
 #define WSPI_INIT_CMD_LEN           8
 
 #define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
-		((WL12XX_BUSY_WORD_LEN - 4) / sizeof(u32))
+		((WL1251_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
 
 /* Raw target IO, address is not translated */
-void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_write(struct wl1251 *wl, int addr, void *buf,
 		      size_t len, bool fixed);
-void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
+void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 		     size_t len, bool fixed);
 
 /* Memory target IO, address is tranlated to partition 0 */
-void wl12xx_spi_mem_read(struct wl12xx *wl, int addr, void *buf, size_t len);
-void wl12xx_spi_mem_write(struct wl12xx *wl, int addr, void *buf, size_t len);
-u32 wl12xx_mem_read32(struct wl12xx *wl, int addr);
-void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
+void wl1251_spi_mem_read(struct wl1251 *wl, int addr, void *buf, size_t len);
+void wl1251_spi_mem_write(struct wl1251 *wl, int addr, void *buf, size_t len);
+u32 wl1251_mem_read32(struct wl1251 *wl, int addr);
+void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val);
 
 /* Registers IO */
-void wl12xx_spi_reg_read(struct wl12xx *wl, int addr, void *buf, size_t len,
+void wl1251_spi_reg_read(struct wl1251 *wl, int addr, void *buf, size_t len,
 			 bool fixed);
-void wl12xx_spi_reg_write(struct wl12xx *wl, int addr, void *buf, size_t len,
+void wl1251_spi_reg_write(struct wl1251 *wl, int addr, void *buf, size_t len,
 			  bool fixed);
-u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
-void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
+u32 wl1251_reg_read32(struct wl1251 *wl, int addr);
+void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val);
 
 /* INIT and RESET words */
-void wl12xx_spi_reset(struct wl12xx *wl);
-void wl12xx_spi_init(struct wl12xx *wl);
-int wl12xx_set_partition(struct wl12xx *wl,
+void wl1251_spi_reset(struct wl1251 *wl);
+void wl1251_spi_init(struct wl1251 *wl);
+int wl1251_set_partition(struct wl1251 *wl,
 			 u32 part_start, u32 part_size,
 			 u32 reg_start,  u32 reg_size);
 
-static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
+static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
-	wl12xx_spi_read(wl, addr, &wl->buffer_32,
+	wl1251_spi_read(wl, addr, &wl->buffer_32,
 			sizeof(wl->buffer_32), false);
 
 	return wl->buffer_32;
 }
 
-static inline void wl12xx_write32(struct wl12xx *wl, int addr, u32 val)
+static inline void wl1251_write32(struct wl1251 *wl, int addr, u32 val)
 {
 	wl->buffer_32 = val;
-	wl12xx_spi_write(wl, addr, &wl->buffer_32,
+	wl1251_spi_write(wl, addr, &wl->buffer_32,
 			 sizeof(wl->buffer_32), false);
 }
 
-#endif /* __WL12XX_SPI_H__ */
+#endif /* __WL1251_SPI_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.c b/drivers/net/wireless/wl12xx/wl1251_tx.c
index 00c5649..2652a22 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.c
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -31,7 +31,7 @@
 #include "wl1251_tx.h"
 #include "wl1251_ps.h"
 
-static bool wl1251_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
+static bool wl1251_tx_double_buffer_busy(struct wl1251 *wl, u32 data_out_count)
 {
 	int used, data_in_count;
 
@@ -52,13 +52,13 @@ static bool wl1251_tx_double_buffer_busy(struct wl12xx *wl, u32 data_out_count)
 		return false;
 }
 
-static int wl1251_tx_path_status(struct wl12xx *wl)
+static int wl1251_tx_path_status(struct wl1251 *wl)
 {
 	u32 status, addr, data_out_count;
 	bool busy;
 
 	addr = wl->data_path->tx_control_addr;
-	status = wl12xx_mem_read32(wl, addr);
+	status = wl1251_mem_read32(wl, addr);
 	data_out_count = status & TX_STATUS_DATA_OUT_COUNT_MASK;
 	busy = wl1251_tx_double_buffer_busy(wl, data_out_count);
 
@@ -68,7 +68,7 @@ static int wl1251_tx_path_status(struct wl12xx *wl)
 	return 0;
 }
 
-static int wl1251_tx_id(struct wl12xx *wl, struct sk_buff *skb)
+static int wl1251_tx_id(struct wl1251 *wl, struct sk_buff *skb)
 {
 	int i;
 
@@ -142,7 +142,7 @@ static void wl1251_tx_frag_block_num(struct tx_double_buffer_desc *tx_hdr)
 	tx_hdr->num_mem_blocks = mem_blocks;
 }
 
-static int wl1251_tx_fill_hdr(struct wl12xx *wl, struct sk_buff *skb,
+static int wl1251_tx_fill_hdr(struct wl1251 *wl, struct sk_buff *skb,
 			      struct ieee80211_tx_info *control)
 {
 	struct tx_double_buffer_desc *tx_hdr;
@@ -177,7 +177,7 @@ static int wl1251_tx_fill_hdr(struct wl12xx *wl, struct sk_buff *skb,
 }
 
 /* We copy the packet to the target */
-static int wl1251_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
+static int wl1251_tx_send_packet(struct wl1251 *wl, struct sk_buff *skb,
 				 struct ieee80211_tx_info *control)
 {
 	struct tx_double_buffer_desc *tx_hdr;
@@ -211,7 +211,7 @@ static int wl1251_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
 	*/
 	if (unlikely((long)skb->data & 0x03)) {
 		int offset = (4 - (long)skb->data) & 0x03;
-		wl12xx_debug(DEBUG_TX, "skb offset %d", offset);
+		wl1251_debug(DEBUG_TX, "skb offset %d", offset);
 
 		/* check whether the current skb can be used */
 		if (!skb_cloned(skb) && (skb_tailroom(skb) >= offset)) {
@@ -221,7 +221,7 @@ static int wl1251_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
 			skb_reserve(skb, offset);
 			memmove(skb->data, src, skb->len);
 		} else {
-			wl12xx_info("No handler, fixme!");
+			wl1251_info("No handler, fixme!");
 			return -EINVAL;
 		}
 	}
@@ -235,15 +235,15 @@ static int wl1251_tx_send_packet(struct wl12xx *wl, struct sk_buff *skb,
 	else
 		addr = wl->data_path->tx_packet_ring_addr;
 
-	wl12xx_spi_mem_write(wl, addr, skb->data, len);
+	wl1251_spi_mem_write(wl, addr, skb->data, len);
 
-	wl12xx_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
+	wl1251_debug(DEBUG_TX, "tx id %u skb 0x%p payload %u rate 0x%x",
 		     tx_hdr->id, skb, tx_hdr->length, tx_hdr->rate);
 
 	return 0;
 }
 
-static void wl1251_tx_trigger(struct wl12xx *wl)
+static void wl1251_tx_trigger(struct wl1251 *wl)
 {
 	u32 data, addr;
 
@@ -255,7 +255,7 @@ static void wl1251_tx_trigger(struct wl12xx *wl)
 		data = INTR_TRIG_TX_PROC0;
 	}
 
-	wl12xx_reg_write32(wl, addr, data);
+	wl1251_reg_write32(wl, addr, data);
 
 	/* Bumping data in */
 	wl->data_in_count = (wl->data_in_count + 1) &
@@ -263,7 +263,7 @@ static void wl1251_tx_trigger(struct wl12xx *wl)
 }
 
 /* caller must hold wl->mutex */
-static int wl1251_tx_frame(struct wl12xx *wl, struct sk_buff *skb)
+static int wl1251_tx_frame(struct wl1251 *wl, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info;
 	int ret = 0;
@@ -274,7 +274,7 @@ static int wl1251_tx_frame(struct wl12xx *wl, struct sk_buff *skb)
 	if (info->control.hw_key) {
 		idx = info->control.hw_key->hw_key_idx;
 		if (unlikely(wl->default_key != idx)) {
-			ret = wl12xx_acx_default_key(wl, idx);
+			ret = wl1251_acx_default_key(wl, idx);
 			if (ret < 0)
 				return ret;
 		}
@@ -299,19 +299,19 @@ static int wl1251_tx_frame(struct wl12xx *wl, struct sk_buff *skb)
 
 void wl1251_tx_work(struct work_struct *work)
 {
-	struct wl12xx *wl = container_of(work, struct wl12xx, tx_work);
+	struct wl1251 *wl = container_of(work, struct wl1251, tx_work);
 	struct sk_buff *skb;
 	bool woken_up = false;
 	int ret;
 
 	mutex_lock(&wl->mutex);
 
-	if (unlikely(wl->state == WL12XX_STATE_OFF))
+	if (unlikely(wl->state == WL1251_STATE_OFF))
 		goto out;
 
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		if (!woken_up) {
-			ret = wl12xx_ps_elp_wakeup(wl);
+			ret = wl1251_ps_elp_wakeup(wl);
 			if (ret < 0)
 				goto out;
 			woken_up = true;
@@ -320,7 +320,7 @@ void wl1251_tx_work(struct work_struct *work)
 		ret = wl1251_tx_frame(wl, skb);
 		if (ret == -EBUSY) {
 			/* firmware buffer is full, stop queues */
-			wl12xx_debug(DEBUG_TX, "tx_work: fw buffer full, "
+			wl1251_debug(DEBUG_TX, "tx_work: fw buffer full, "
 				     "stop queues");
 			ieee80211_stop_queues(wl->hw);
 			wl->tx_queue_stopped = true;
@@ -334,7 +334,7 @@ void wl1251_tx_work(struct work_struct *work)
 
 out:
 	if (woken_up)
-		wl12xx_ps_elp_sleep(wl);
+		wl1251_ps_elp_sleep(wl);
 
 	mutex_unlock(&wl->mutex);
 }
@@ -367,7 +367,7 @@ static const char *wl1251_tx_parse_status(u8 status)
 	return buf;
 }
 
-static void wl1251_tx_packet_cb(struct wl12xx *wl,
+static void wl1251_tx_packet_cb(struct wl1251 *wl,
 				struct tx_result *result)
 {
 	struct ieee80211_tx_info *info;
@@ -377,7 +377,7 @@ static void wl1251_tx_packet_cb(struct wl12xx *wl,
 
 	skb = wl->tx_frames[result->id];
 	if (skb == NULL) {
-		wl12xx_error("SKB for packet %d is NULL", result->id);
+		wl1251_error("SKB for packet %d is NULL", result->id);
 		return;
 	}
 
@@ -402,7 +402,7 @@ static void wl1251_tx_packet_cb(struct wl12xx *wl,
 		skb_pull(skb, WL1251_TKIP_IV_SPACE);
 	}
 
-	wl12xx_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
+	wl1251_debug(DEBUG_TX, "tx status id %u skb 0x%p failures %u rate 0x%x"
 		     " status 0x%x (%s)",
 		     result->id, skb, result->ack_failures, result->rate,
 		     result->status, wl1251_tx_parse_status(result->status));
@@ -413,7 +413,7 @@ static void wl1251_tx_packet_cb(struct wl12xx *wl,
 	wl->tx_frames[result->id] = NULL;
 
 	if (wl->tx_queue_stopped) {
-		wl12xx_debug(DEBUG_TX, "cb: queue was stopped");
+		wl1251_debug(DEBUG_TX, "cb: queue was stopped");
 
 		skb = skb_dequeue(&wl->tx_queue);
 
@@ -425,7 +425,7 @@ static void wl1251_tx_packet_cb(struct wl12xx *wl,
 			ret = wl1251_tx_frame(wl, skb);
 			if (ret == -EBUSY) {
 				/* firmware buffer is still full */
-				wl12xx_debug(DEBUG_TX, "cb: fw buffer "
+				wl1251_debug(DEBUG_TX, "cb: fw buffer "
 					     "still full");
 				skb_queue_head(&wl->tx_queue, skb);
 				return;
@@ -435,23 +435,23 @@ static void wl1251_tx_packet_cb(struct wl12xx *wl,
 			}
 		}
 
-		wl12xx_debug(DEBUG_TX, "cb: waking queues");
+		wl1251_debug(DEBUG_TX, "cb: waking queues");
 		ieee80211_wake_queues(wl->hw);
 		wl->tx_queue_stopped = false;
 	}
 }
 
 /* Called upon reception of a TX complete interrupt */
-void wl1251_tx_complete(struct wl12xx *wl)
+void wl1251_tx_complete(struct wl1251 *wl)
 {
 	int i, result_index, num_complete = 0;
 	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
 
-	if (unlikely(wl->state != WL12XX_STATE_ON))
+	if (unlikely(wl->state != WL1251_STATE_ON))
 		return;
 
 	/* First we read the result */
-	wl12xx_spi_mem_read(wl, wl->data_path->tx_complete_addr,
+	wl1251_spi_mem_read(wl, wl->data_path->tx_complete_addr,
 			    result, sizeof(result));
 
 	result_index = wl->next_tx_complete;
@@ -482,7 +482,7 @@ void wl1251_tx_complete(struct wl12xx *wl)
 		 */
 		if (result_index > wl->next_tx_complete) {
 			/* Only 1 write is needed */
-			wl12xx_spi_mem_write(wl,
+			wl1251_spi_mem_write(wl,
 					     wl->data_path->tx_complete_addr +
 					     (wl->next_tx_complete *
 					      sizeof(struct tx_result)),
@@ -493,7 +493,7 @@ void wl1251_tx_complete(struct wl12xx *wl)
 
 		} else if (result_index < wl->next_tx_complete) {
 			/* 2 writes are needed */
-			wl12xx_spi_mem_write(wl,
+			wl1251_spi_mem_write(wl,
 					     wl->data_path->tx_complete_addr +
 					     (wl->next_tx_complete *
 					      sizeof(struct tx_result)),
@@ -502,7 +502,7 @@ void wl1251_tx_complete(struct wl12xx *wl)
 					      wl->next_tx_complete) *
 					     sizeof(struct tx_result));
 
-			wl12xx_spi_mem_write(wl,
+			wl1251_spi_mem_write(wl,
 					     wl->data_path->tx_complete_addr,
 					     result,
 					     (num_complete -
@@ -512,7 +512,7 @@ void wl1251_tx_complete(struct wl12xx *wl)
 
 		} else {
 			/* We have to write the whole array */
-			wl12xx_spi_mem_write(wl,
+			wl1251_spi_mem_write(wl,
 					     wl->data_path->tx_complete_addr,
 					     result,
 					     FW_TX_CMPLT_BLOCK_SIZE *
@@ -525,7 +525,7 @@ void wl1251_tx_complete(struct wl12xx *wl)
 }
 
 /* caller must hold wl->mutex */
-void wl1251_tx_flush(struct wl12xx *wl)
+void wl1251_tx_flush(struct wl1251 *wl)
 {
 	int i;
 	struct sk_buff *skb;
@@ -537,7 +537,7 @@ void wl1251_tx_flush(struct wl12xx *wl)
 	while ((skb = skb_dequeue(&wl->tx_queue))) {
 		info = IEEE80211_SKB_CB(skb);
 
-		wl12xx_debug(DEBUG_TX, "flushing skb 0x%p", skb);
+		wl1251_debug(DEBUG_TX, "flushing skb 0x%p", skb);
 
 		if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS))
 				continue;
diff --git a/drivers/net/wireless/wl12xx/wl1251_tx.h b/drivers/net/wireless/wl12xx/wl1251_tx.h
index a5d4c82..7c1c166 100644
--- a/drivers/net/wireless/wl12xx/wl1251_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_tx.h
@@ -1,5 +1,5 @@
 /*
- * This file is part of wl12xx
+ * This file is part of wl1251
  *
  * Copyright (c) 1998-2007 Texas Instruments Incorporated
  * Copyright (C) 2008 Nokia Corporation
@@ -210,7 +210,7 @@ struct tx_result {
 } __attribute__ ((packed));
 
 void wl1251_tx_work(struct work_struct *work);
-void wl1251_tx_complete(struct wl12xx *wl);
-void wl1251_tx_flush(struct wl12xx *wl);
+void wl1251_tx_complete(struct wl1251 *wl);
+void wl1251_tx_flush(struct wl1251 *wl);
 
 #endif

