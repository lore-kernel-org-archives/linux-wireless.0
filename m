Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59761 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1AaQjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:39:13 -0500
Received: by bwz15 with SMTP id 15so5417799bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 08:39:12 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/4] wl12xx: move to new firmware (6.1.3.50.49)
Date: Mon, 31 Jan 2011 18:38:17 +0200
Message-Id: <1296491899-25440-3-git-send-email-eliad@wizery.com>
In-Reply-To: <1296491899-25440-1-git-send-email-eliad@wizery.com>
References: <1296491899-25440-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the new wl12xx firmware (Rev 6.1.3.50.49)

Since this fw is not backward compatible with previous fw versions,
a new fw (with different name) is being fetched.

(the patch is big because it contains all the required fw api changes.
splitting it into multiple patches will result in corrupted intermediate
commits)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |   44 +++++++++++++++++++++++++++++----
 drivers/net/wireless/wl12xx/acx.h    |   26 +++++++++++++++----
 drivers/net/wireless/wl12xx/cmd.c    |   13 ++++++----
 drivers/net/wireless/wl12xx/cmd.h    |   14 +++-------
 drivers/net/wireless/wl12xx/conf.h   |   29 ++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.c  |   14 ----------
 drivers/net/wireless/wl12xx/event.h  |    2 -
 drivers/net/wireless/wl12xx/init.c   |   13 ++++++++++
 drivers/net/wireless/wl12xx/main.c   |   22 +++++++++++++----
 drivers/net/wireless/wl12xx/ps.c     |    6 +---
 drivers/net/wireless/wl12xx/rx.c     |    6 ++--
 drivers/net/wireless/wl12xx/rx.h     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |   31 ++++++++++++++++++++---
 13 files changed, 162 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 84d94b2..f2fbda0 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -947,9 +947,9 @@ out:
 	return ret;
 }
 
-int wl1271_acx_mem_cfg(struct wl1271 *wl)
+int wl1271_acx_ap_mem_cfg(struct wl1271 *wl)
 {
-	struct wl1271_acx_config_memory *mem_conf;
+	struct wl1271_acx_ap_config_memory *mem_conf;
 	int ret;
 
 	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
@@ -979,13 +979,45 @@ out:
 	return ret;
 }
 
-int wl1271_acx_init_mem_config(struct wl1271 *wl)
+int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 {
+	struct wl1271_acx_sta_config_memory *mem_conf;
 	int ret;
 
-	ret = wl1271_acx_mem_cfg(wl);
-	if (ret < 0)
-		return ret;
+	wl1271_debug(DEBUG_ACX, "wl1271 mem cfg");
+
+	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
+	if (!mem_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* memory config */
+	mem_conf->num_stations = DEFAULT_NUM_STATIONS;
+	mem_conf->rx_mem_block_num = ACX_RX_MEM_BLOCKS;
+	mem_conf->tx_min_mem_block_num = ACX_TX_MIN_MEM_BLOCKS;
+	mem_conf->num_ssid_profiles = ACX_NUM_SSID_PROFILES;
+	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
+	mem_conf->dyn_mem_enable = wl->conf.mem.dynamic_memory;
+	mem_conf->tx_free_req = wl->conf.mem.min_req_tx_blocks;
+	mem_conf->rx_free_req = wl->conf.mem.min_req_rx_blocks;
+	mem_conf->tx_min = wl->conf.mem.tx_min;
+
+	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
+				   sizeof(*mem_conf));
+	if (ret < 0) {
+		wl1271_warning("wl1271 mem config failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(mem_conf);
+	return ret;
+}
+
+int wl1271_acx_init_mem_config(struct wl1271 *wl)
+{
+	int ret;
 
 	wl->target_mem_map = kzalloc(sizeof(struct wl1271_acx_mem_map),
 				     GFP_KERNEL);
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index af36b16..ba13d1b 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -802,7 +802,7 @@ struct acx_tx_config_options {
 #define ACX_TX_DESCRIPTORS    32
 #define ACX_NUM_SSID_PROFILES 1
 
-struct wl1271_acx_config_memory {
+struct wl1271_acx_ap_config_memory {
 	struct acx_header header;
 
 	u8 rx_mem_block_num;
@@ -812,6 +812,20 @@ struct wl1271_acx_config_memory {
 	__le32 total_tx_descriptors;
 } __packed;
 
+struct wl1271_acx_sta_config_memory {
+	struct acx_header header;
+
+	u8 rx_mem_block_num;
+	u8 tx_min_mem_block_num;
+	u8 num_stations;
+	u8 num_ssid_profiles;
+	__le32 total_tx_descriptors;
+	u8 dyn_mem_enable;
+	u8 tx_free_req;
+	u8 rx_free_req;
+	u8 tx_min;
+} __packed;
+
 struct wl1271_acx_mem_map {
 	struct acx_header header;
 
@@ -1202,6 +1216,8 @@ enum {
 	ACX_HT_BSS_OPERATION        = 0x0058,
 	ACX_COEX_ACTIVITY           = 0x0059,
 	ACX_SET_DCO_ITRIM_PARAMS    = 0x0061,
+	ACX_GEN_FW_CMD              = 0x0070,
+	ACX_HOST_IF_CFG_BITMAP      = 0x0071,
 	ACX_MAX_TX_FAILURE          = 0x0072,
 	DOT11_RX_MSDU_LIFE_TIME     = 0x1004,
 	DOT11_CUR_TX_PWR            = 0x100D,
@@ -1210,10 +1226,7 @@ enum {
 	DOT11_GROUP_ADDRESS_TBL     = 0x1014,
 	ACX_PM_CONFIG               = 0x1016,
 	ACX_CONFIG_PS               = 0x1017,
-
-	MAX_DOT11_IE = DOT11_GROUP_ADDRESS_TBL,
-
-	MAX_IE = 0xFFFF
+	ACX_CONFIG_HANGOVER         = 0x1018,
 };
 
 
@@ -1255,7 +1268,8 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl, u8 queue_id, u8 channel_type,
 		       u32 apsd_conf0, u32 apsd_conf1);
 int wl1271_acx_frag_threshold(struct wl1271 *wl, u16 frag_threshold);
 int wl1271_acx_tx_config_options(struct wl1271 *wl);
-int wl1271_acx_mem_cfg(struct wl1271 *wl);
+int wl1271_acx_ap_mem_cfg(struct wl1271 *wl);
+int wl1271_acx_sta_mem_cfg(struct wl1271 *wl);
 int wl1271_acx_init_mem_config(struct wl1271 *wl);
 int wl1271_acx_init_rx_interrupt(struct wl1271 *wl);
 int wl1271_acx_smart_reflex(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 1bb8be5..66d15e7 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -286,6 +286,13 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
 	join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
+	/*
+	 * for supported_rate_set, we should use wl->rate_set. however,
+	 * it seems that acx_rate_policies doesn't affect full_rate, and
+	 * since we want to avoid additional join, we'll use a 0xffffffff value,
+	 * and let the fw find the actual supported rates
+	 */
+	join->supported_rate_set = cpu_to_le32(0xffffffff);
 
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
@@ -454,7 +461,7 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send)
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 {
 	struct wl1271_cmd_ps_params *ps_params = NULL;
 	int ret = 0;
@@ -468,10 +475,6 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send)
 	}
 
 	ps_params->ps_mode = ps_mode;
-	ps_params->send_null_data = send;
-	ps_params->retries = wl->conf.conn.psm_entry_nullfunc_retries;
-	ps_params->hang_over_period = wl->conf.conn.psm_entry_hangover_period;
-	ps_params->null_data_rate = cpu_to_le32(rates);
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params), 0);
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 7512814..54c12e7 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -39,7 +39,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
-int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, u32 rates, bool send);
+int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
@@ -140,6 +140,7 @@ enum cmd_templ {
 				  * For CTS-to-self (FastCTS) mechanism
 				  * for BT/WLAN coexistence (SoftGemini). */
 	CMD_TEMPL_ARP_RSP,
+	CMD_TEMPL_LINK_MEASUREMENT_REPORT,
 
 	/* AP-mode specific */
 	CMD_TEMPL_AP_BEACON = 13,
@@ -216,6 +217,7 @@ struct wl1271_cmd_join {
 	 * ACK or CTS frames).
 	 */
 	__le32 basic_rate_set;
+	__le32 supported_rate_set;
 	u8 dtim_interval;
 	/*
 	 * bits 0-2: This bitwise field specifies the type
@@ -278,15 +280,7 @@ struct wl1271_cmd_ps_params {
 	struct wl1271_cmd_header header;
 
 	u8 ps_mode; /* STATION_* */
-	u8 send_null_data; /* Do we have to send NULL data packet ? */
-	u8 retries; /* Number of retires for the initial NULL data packet */
-
-	 /*
-	  * TUs during which the target stays awake after switching
-	  * to power save mode.
-	  */
-	u8 hang_over_period;
-	__le32 null_data_rate;
+	u8 padding[3];
 } __packed;
 
 /* HW encryption keys */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index c81aecd..d8c1249 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1151,6 +1151,34 @@ struct conf_ht_setting {
 	u16 inactivity_timeout;
 };
 
+struct conf_memory_settings {
+	/* Disable/Enable dynamic memory */
+	u8 dynamic_memory;
+
+	/*
+	 * Minimum required free tx memory blocks in order to assure optimum
+	 * performence
+	 *
+	 * Range: 0-120
+	 */
+	u8 min_req_tx_blocks;
+
+	/*
+	 * Minimum required free rx memory blocks in order to assure optimum
+	 * performence
+	 *
+	 * Range: 0-120
+	 */
+	u8 min_req_rx_blocks;
+
+	/*
+	 * Minimum number of mem blocks (free+used) guaranteed for TX
+	 *
+	 * Range: 0-120
+	 */
+	u8 tx_min;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1162,6 +1190,7 @@ struct conf_drv_settings {
 	struct conf_scan_settings scan;
 	struct conf_rf_settings rf;
 	struct conf_ht_setting ht;
+	struct conf_memory_settings mem;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 3376a5d..1b170c5 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -135,20 +135,6 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 		/* go to extremely low power mode */
 		wl1271_ps_elp_sleep(wl);
 		break;
-	case EVENT_EXIT_POWER_SAVE_FAIL:
-		wl1271_debug(DEBUG_PSM, "PSM exit failed");
-
-		if (test_bit(WL1271_FLAG_PSM, &wl->flags)) {
-			wl->psm_entry_retry = 0;
-			break;
-		}
-
-		/* make sure the firmware goes to active mode - the frame to
-		   be sent next will indicate to the AP, that we are active. */
-		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
-					 wl->basic_rate, false);
-		break;
-	case EVENT_EXIT_POWER_SAVE_SUCCESS:
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 1d5ef67..0e80886 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -75,8 +75,6 @@ enum {
 enum {
 	EVENT_ENTER_POWER_SAVE_FAIL = 0,
 	EVENT_ENTER_POWER_SAVE_SUCCESS,
-	EVENT_EXIT_POWER_SAVE_FAIL,
-	EVENT_EXIT_POWER_SAVE_SUCCESS,
 };
 
 struct event_debug_report {
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 70b3dc8..62dc983 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -325,6 +325,11 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* PS config */
+	ret = wl1271_acx_config_ps(wl);
+	if (ret < 0)
+		return ret;
+
 	ret = wl1271_sta_init_templates_config(wl);
 	if (ret < 0)
 		return ret;
@@ -367,6 +372,10 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_acx_sta_mem_cfg(wl);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
@@ -433,6 +442,10 @@ static int wl1271_ap_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wl1271_acx_ap_mem_cfg(wl);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index ec82dd0..c8fe2b0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -298,6 +298,12 @@ static struct conf_drv_settings default_conf = {
 		.tx_ba_win_size = 64,
 		.inactivity_timeout = 10000,
 	},
+	.mem = {
+		.dynamic_memory               = 0,
+		.min_req_tx_blocks            = 104,
+		.min_req_rx_blocks            = 22,
+		.tx_min                       = 27,
+	}
 };
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl);
@@ -524,13 +530,19 @@ static int wl1271_plt_init(struct wl1271 *wl)
 }
 
 static void wl1271_fw_status(struct wl1271 *wl,
-			     struct wl1271_fw_status *status)
+			     struct wl1271_fw_full_status *full_status)
 {
+	struct wl1271_fw_common_status *status = &full_status->common;
 	struct timespec ts;
 	u32 total = 0;
 	int i;
 
-	wl1271_raw_read(wl, FW_STATUS_ADDR, status, sizeof(*status), false);
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
+				sizeof(struct wl1271_fw_ap_status), false);
+	else
+		wl1271_raw_read(wl, FW_STATUS_ADDR, status,
+				sizeof(struct wl1271_fw_sta_status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -589,7 +601,7 @@ static void wl1271_irq_work(struct work_struct *work)
 		loopcount--;
 
 		wl1271_fw_status(wl, wl->fw_status);
-		intr = le32_to_cpu(wl->fw_status->intr);
+		intr = le32_to_cpu(wl->fw_status->common.intr);
 		if (!intr) {
 			wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
 			spin_lock_irqsave(&wl->wl_lock, flags);
@@ -611,7 +623,7 @@ static void wl1271_irq_work(struct work_struct *work)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
 			/* check for tx results */
-			if (wl->fw_status->tx_results_counter !=
+			if (wl->fw_status->common.tx_results_counter !=
 			    (wl->tx_results_count & 0xff))
 				wl1271_tx_complete(wl);
 
@@ -625,7 +637,7 @@ static void wl1271_irq_work(struct work_struct *work)
 				wl1271_tx_work_locked(wl);
 			}
 
-			wl1271_rx(wl, wl->fw_status);
+			wl1271_rx(wl, &wl->fw_status->common);
 		}
 
 		if (intr & WL1271_ACX_INTR_EVENT_A) {
diff --git a/drivers/net/wireless/wl12xx/ps.c b/drivers/net/wireless/wl12xx/ps.c
index 60a3738..2d3086a 100644
--- a/drivers/net/wireless/wl12xx/ps.c
+++ b/drivers/net/wireless/wl12xx/ps.c
@@ -139,8 +139,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 			return ret;
 		}
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE,
-					 rates, send);
+		ret = wl1271_cmd_ps_mode(wl, STATION_POWER_SAVE_MODE);
 		if (ret < 0)
 			return ret;
 
@@ -163,8 +162,7 @@ int wl1271_ps_set_mode(struct wl1271 *wl, enum wl1271_cmd_ps_mode mode,
 		if (ret < 0)
 			return ret;
 
-		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE,
-					 rates, send);
+		ret = wl1271_cmd_ps_mode(wl, STATION_ACTIVE_MODE);
 		if (ret < 0)
 			return ret;
 
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index d9f80c4..029597b 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -29,14 +29,14 @@
 #include "rx.h"
 #include "io.h"
 
-static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
+static u8 wl1271_rx_get_mem_block(struct wl1271_fw_common_status *status,
 				  u32 drv_rx_counter)
 {
 	return le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
 		RX_MEM_BLOCK_MASK;
 }
 
-static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
+static u32 wl1271_rx_get_buf_size(struct wl1271_fw_common_status *status,
 				 u32 drv_rx_counter)
 {
 	return (le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
@@ -134,7 +134,7 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	return 0;
 }
 
-void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status)
 {
 	struct wl1271_acx_mem_map *wl_mem_map = wl->target_mem_map;
 	u32 buf_size;
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 8d048b3..4cef8fa 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -119,7 +119,7 @@ struct wl1271_rx_descriptor {
 	u8  reserved;
 } __packed;
 
-void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status);
+void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_common_status *status);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 void wl1271_set_default_filters(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index ed245c2..39adcdf 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -130,7 +130,7 @@ extern u32 wl12xx_debug_level;
 
 
 
-#define WL1271_FW_NAME "wl1271-fw.bin"
+#define WL1271_FW_NAME "wl1271-fw-2.bin"
 #define WL1271_AP_FW_NAME "wl1271-fw-ap.bin"
 
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
@@ -214,8 +214,8 @@ struct wl1271_stats {
 /* Broadcast and Global links + links to stations */
 #define AP_MAX_LINKS               (AP_MAX_STATIONS + 2)
 
-/* FW status registers */
-struct wl1271_fw_status {
+/* FW status registers common for AP/STA */
+struct wl1271_fw_common_status {
 	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
@@ -224,6 +224,11 @@ struct wl1271_fw_status {
 	__le32 rx_pkt_descs[NUM_RX_PKT_DESC];
 	__le32 tx_released_blks[NUM_TX_QUEUES];
 	__le32 fw_localtime;
+} __packed;
+
+/* FW status registers for AP */
+struct wl1271_fw_ap_status {
+	struct wl1271_fw_common_status common;
 
 	/* Next fields valid only in AP FW */
 
@@ -238,6 +243,24 @@ struct wl1271_fw_status {
 	u8 padding_1[1];
 } __packed;
 
+/* FW status registers for STA */
+struct wl1271_fw_sta_status {
+	struct wl1271_fw_common_status common;
+
+	u8  tx_total;
+	u8  reserved1;
+	__le16 reserved2;
+} __packed;
+
+struct wl1271_fw_full_status {
+	union {
+		struct wl1271_fw_common_status common;
+		struct wl1271_fw_sta_status sta;
+		struct wl1271_fw_ap_status ap;
+	};
+} __packed;
+
+
 struct wl1271_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
@@ -445,7 +468,7 @@ struct wl1271 {
 	u32 buffer_cmd;
 	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 
-	struct wl1271_fw_status *fw_status;
+	struct wl1271_fw_full_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
 	struct ieee80211_vif *vif;
-- 
1.7.0.4

