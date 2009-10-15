Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:64720 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875AbZJOHfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 03:35:25 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] wl1271: fix endianess issues
Date: Thu, 15 Oct 2009 10:33:29 +0300
Message-Id: <1255592010-10287-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
References: <1255592010-10287-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were not handling endianess correctly.  The wl1271 chip runs on
little-endian values.  This patch makes sure that all the communication with
the wl1271 firmware is done in little-endian by using cpu_to_le* and
le*_to_cpu where appropriate.

Also, all the struct definitions for data exchanged with the firmware has
been changed to use __le16/32 types instead of u16/32.

This fixes a few sparse warnings, such as these:

drivers/net/wireless/wl12xx/wl1271_cmd.c:554:42: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:555:42: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:577:58: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:579:58: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:676:18: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:787:22: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_cmd.c:789:21: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_tx.c:98:47: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/wl12xx/wl1271_acx.c:932:32: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_boot.c:191:32: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/wl12xx/wl1271_boot.c:197:38: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/wl12xx/wl1271_boot.c:199:37: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/wl12xx/wl1271_init.c:255:40: warning: incorrect type in assignment (different base types)
drivers/net/wireless/wl12xx/wl1271_init.c:275:53: warning: incorrect type in assignment (different base types)

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |   10 +-
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   72 ++++----
 drivers/net/wireless/wl12xx/wl1271_acx.h   |  286 ++++++++++++++--------------
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    6 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |   74 ++++----
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   68 ++++----
 drivers/net/wireless/wl12xx/wl1271_event.c |    3 +-
 drivers/net/wireless/wl12xx/wl1271_event.h |   28 ++--
 drivers/net/wireless/wl12xx/wl1271_init.h  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   12 +-
 drivers/net/wireless/wl12xx/wl1271_rx.c    |   11 +-
 drivers/net/wireless/wl12xx/wl1271_rx.h    |    4 +-
 drivers/net/wireless/wl12xx/wl1271_tx.c    |   22 ++-
 drivers/net/wireless/wl12xx/wl1271_tx.h    |   18 +-
 drivers/net/wireless/wl12xx/wl12xx_80211.h |    4 +-
 15 files changed, 318 insertions(+), 304 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 1309b20..566f152 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -283,15 +283,15 @@ struct wl1271_debugfs {
 
 /* FW status registers */
 struct wl1271_fw_status {
-	u32 intr;
+	__le32 intr;
 	u8  fw_rx_counter;
 	u8  drv_rx_counter;
 	u8  reserved;
 	u8  tx_results_counter;
-	u32 rx_pkt_descs[NUM_RX_PKT_DESC];
-	u32 tx_released_blks[NUM_TX_QUEUES];
-	u32 fw_localtime;
-	u32 padding[2];
+	__le32 rx_pkt_descs[NUM_RX_PKT_DESC];
+	__le32 tx_released_blks[NUM_TX_QUEUES];
+	__le32 fw_localtime;
+	__le32 padding[2];
 } __attribute__ ((packed));
 
 struct wl1271_rx_mem_pool_addr {
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index e891cd5..bf5a868 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -210,7 +210,7 @@ int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->lifetime = wl->conf.rx.rx_msdu_life_time;
+	acx->lifetime = cpu_to_le32(wl->conf.rx.rx_msdu_life_time);
 	ret = wl1271_cmd_configure(wl, DOT11_RX_MSDU_LIFE_TIME,
 				   acx, sizeof(*acx));
 	if (ret < 0) {
@@ -236,8 +236,8 @@ int wl1271_acx_rx_config(struct wl1271 *wl, u32 config, u32 filter)
 		goto out;
 	}
 
-	rx_config->config_options = config;
-	rx_config->filter_options = filter;
+	rx_config->config_options = cpu_to_le32(config);
+	rx_config->filter_options = cpu_to_le32(filter);
 
 	ret = wl1271_cmd_configure(wl, ACX_RX_CFG,
 				   rx_config, sizeof(*rx_config));
@@ -264,7 +264,7 @@ int wl1271_acx_pd_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	pd->threshold = wl->conf.rx.packet_detection_threshold;
+	pd->threshold = cpu_to_le32(wl->conf.rx.packet_detection_threshold);
 
 	ret = wl1271_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
 	if (ret < 0) {
@@ -348,8 +348,8 @@ int wl1271_acx_service_period_timeout(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_ACX, "acx service period timeout");
 
-	rx_timeout->ps_poll_timeout = wl->conf.rx.ps_poll_timeout;
-	rx_timeout->upsd_timeout = wl->conf.rx.upsd_timeout;
+	rx_timeout->ps_poll_timeout = cpu_to_le16(wl->conf.rx.ps_poll_timeout);
+	rx_timeout->upsd_timeout = cpu_to_le16(wl->conf.rx.upsd_timeout);
 
 	ret = wl1271_cmd_configure(wl, ACX_SERVICE_PERIOD_TIMEOUT,
 				   rx_timeout, sizeof(*rx_timeout));
@@ -377,7 +377,7 @@ int wl1271_acx_rts_threshold(struct wl1271 *wl, u16 rts_threshold)
 		goto out;
 	}
 
-	rts->threshold = rts_threshold;
+	rts->threshold = cpu_to_le16(rts_threshold);
 
 	ret = wl1271_cmd_configure(wl, DOT11_RTS_THRESHOLD, rts, sizeof(*rts));
 	if (ret < 0) {
@@ -494,8 +494,8 @@ int wl1271_acx_conn_monit_params(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->synch_fail_thold = wl->conf.conn.synch_fail_thold;
-	acx->bss_lose_timeout = wl->conf.conn.bss_lose_timeout;
+	acx->synch_fail_thold = cpu_to_le32(wl->conf.conn.synch_fail_thold);
+	acx->bss_lose_timeout = cpu_to_le32(wl->conf.conn.bss_lose_timeout);
 
 	ret = wl1271_cmd_configure(wl, ACX_CONN_MONIT_PARAMS,
 				   acx, sizeof(*acx));
@@ -552,16 +552,18 @@ int wl1271_acx_sg_cfg(struct wl1271 *wl)
 	}
 
 	/* BT-WLAN coext parameters */
-	param->per_threshold = c->per_threshold;
-	param->max_scan_compensation_time = c->max_scan_compensation_time;
-	param->nfs_sample_interval = c->nfs_sample_interval;
+	param->per_threshold = cpu_to_le32(c->per_threshold);
+	param->max_scan_compensation_time =
+		cpu_to_le32(c->max_scan_compensation_time);
+	param->nfs_sample_interval = cpu_to_le16(c->nfs_sample_interval);
 	param->load_ratio = c->load_ratio;
 	param->auto_ps_mode = c->auto_ps_mode;
 	param->probe_req_compensation = c->probe_req_compensation;
 	param->scan_window_compensation = c->scan_window_compensation;
 	param->antenna_config = c->antenna_config;
 	param->beacon_miss_threshold = c->beacon_miss_threshold;
-	param->rate_adaptation_threshold = c->rate_adaptation_threshold;
+	param->rate_adaptation_threshold =
+		cpu_to_le32(c->rate_adaptation_threshold);
 	param->rate_adaptation_snr = c->rate_adaptation_snr;
 
 	ret = wl1271_cmd_configure(wl, ACX_SG_CFG, param, sizeof(*param));
@@ -588,7 +590,7 @@ int wl1271_acx_cca_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	detection->rx_cca_threshold = wl->conf.rx.rx_cca_threshold;
+	detection->rx_cca_threshold = cpu_to_le16(wl->conf.rx.rx_cca_threshold);
 	detection->tx_energy_detection = wl->conf.tx.tx_energy_detection;
 
 	ret = wl1271_cmd_configure(wl, ACX_CCA_THRESHOLD,
@@ -616,8 +618,8 @@ int wl1271_acx_bcn_dtim_options(struct wl1271 *wl)
 		goto out;
 	}
 
-	bb->beacon_rx_timeout = wl->conf.conn.beacon_rx_timeout;
-	bb->broadcast_timeout = wl->conf.conn.broadcast_timeout;
+	bb->beacon_rx_timeout = cpu_to_le16(wl->conf.conn.beacon_rx_timeout);
+	bb->broadcast_timeout = cpu_to_le16(wl->conf.conn.broadcast_timeout);
 	bb->rx_broadcast_in_ps = wl->conf.conn.rx_broadcast_in_ps;
 	bb->ps_poll_threshold = wl->conf.conn.ps_poll_threshold;
 
@@ -645,7 +647,7 @@ int wl1271_acx_aid(struct wl1271 *wl, u16 aid)
 		goto out;
 	}
 
-	acx_aid->aid = aid;
+	acx_aid->aid = cpu_to_le16(aid);
 
 	ret = wl1271_cmd_configure(wl, ACX_AID, acx_aid, sizeof(*acx_aid));
 	if (ret < 0) {
@@ -672,9 +674,8 @@ int wl1271_acx_event_mbox_mask(struct wl1271 *wl, u32 event_mask)
 	}
 
 	/* high event mask is unused */
-	mask->high_event_mask = 0xffffffff;
-
-	mask->event_mask = event_mask;
+	mask->high_event_mask = cpu_to_le32(0xffffffff);
+	mask->event_mask = cpu_to_le32(event_mask);
 
 	ret = wl1271_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
 				   mask, sizeof(*mask));
@@ -773,8 +774,8 @@ int wl1271_acx_rate_policies(struct wl1271 *wl, u32 enabled_rates)
 	}
 
 	/* configure one default (one-size-fits-all) rate class */
-	acx->rate_class_cnt = 1;
-	acx->rate_class[0].enabled_rates = enabled_rates;
+	acx->rate_class_cnt = cpu_to_le32(1);
+	acx->rate_class[0].enabled_rates = cpu_to_le32(enabled_rates);
 	acx->rate_class[0].short_retry_limit = c->short_retry_limit;
 	acx->rate_class[0].long_retry_limit = c->long_retry_limit;
 	acx->rate_class[0].aflags = c->aflags;
@@ -808,10 +809,10 @@ int wl1271_acx_ac_cfg(struct wl1271 *wl)
 		struct conf_tx_ac_category *c = &(wl->conf.tx.ac_conf[i]);
 		acx->ac = c->ac;
 		acx->cw_min = c->cw_min;
-		acx->cw_max = c->cw_max;
+		acx->cw_max = cpu_to_le16(c->cw_max);
 		acx->aifsn = c->aifsn;
 		acx->reserved = 0;
-		acx->tx_op_limit = c->tx_op_limit;
+		acx->tx_op_limit = cpu_to_le16(c->tx_op_limit);
 
 		ret = wl1271_cmd_configure(wl, ACX_AC_CFG, acx, sizeof(*acx));
 		if (ret < 0) {
@@ -847,8 +848,8 @@ int wl1271_acx_tid_cfg(struct wl1271 *wl)
 		acx->tsid = c->tsid;
 		acx->ps_scheme = c->ps_scheme;
 		acx->ack_policy = c->ack_policy;
-		acx->apsd_conf[0] = c->apsd_conf[0];
-		acx->apsd_conf[1] = c->apsd_conf[1];
+		acx->apsd_conf[0] = cpu_to_le32(c->apsd_conf[0]);
+		acx->apsd_conf[1] = cpu_to_le32(c->apsd_conf[1]);
 
 		ret = wl1271_cmd_configure(wl, ACX_TID_CFG, acx, sizeof(*acx));
 		if (ret < 0) {
@@ -876,7 +877,7 @@ int wl1271_acx_frag_threshold(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->frag_threshold = wl->conf.tx.frag_threshold;
+	acx->frag_threshold = cpu_to_le16(wl->conf.tx.frag_threshold);
 	ret = wl1271_cmd_configure(wl, ACX_FRAG_CFG, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of frag threshold failed: %d", ret);
@@ -902,8 +903,8 @@ int wl1271_acx_tx_config_options(struct wl1271 *wl)
 		goto out;
 	}
 
-	acx->tx_compl_timeout = wl->conf.tx.tx_compl_timeout;
-	acx->tx_compl_threshold = wl->conf.tx.tx_compl_threshold;
+	acx->tx_compl_timeout = cpu_to_le16(wl->conf.tx.tx_compl_timeout);
+	acx->tx_compl_threshold = cpu_to_le16(wl->conf.tx.tx_compl_threshold);
 	ret = wl1271_cmd_configure(wl, ACX_TX_CONFIG_OPT, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of tx options failed: %d", ret);
@@ -929,11 +930,11 @@ int wl1271_acx_mem_cfg(struct wl1271 *wl)
 	}
 
 	/* memory config */
-	mem_conf->num_stations = cpu_to_le16(DEFAULT_NUM_STATIONS);
+	mem_conf->num_stations = DEFAULT_NUM_STATIONS;
 	mem_conf->rx_mem_block_num = ACX_RX_MEM_BLOCKS;
 	mem_conf->tx_min_mem_block_num = ACX_TX_MIN_MEM_BLOCKS;
 	mem_conf->num_ssid_profiles = ACX_NUM_SSID_PROFILES;
-	mem_conf->total_tx_descriptors = ACX_TX_DESCRIPTORS;
+	mem_conf->total_tx_descriptors = cpu_to_le32(ACX_TX_DESCRIPTORS);
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
 				   sizeof(*mem_conf));
@@ -973,7 +974,8 @@ int wl1271_acx_init_mem_config(struct wl1271 *wl)
 	}
 
 	/* initialize TX block book keeping */
-	wl->tx_blocks_available = wl->target_mem_map->num_tx_mem_blocks;
+	wl->tx_blocks_available =
+		le32_to_cpu(wl->target_mem_map->num_tx_mem_blocks);
 	wl1271_debug(DEBUG_TX, "available tx blocks: %d",
 		     wl->tx_blocks_available);
 
@@ -993,9 +995,9 @@ int wl1271_acx_init_rx_interrupt(struct wl1271 *wl)
 		goto out;
 	}
 
-	rx_conf->threshold = wl->conf.rx.irq_pkt_threshold;
-	rx_conf->timeout = wl->conf.rx.irq_timeout;
-	rx_conf->mblk_threshold = wl->conf.rx.irq_blk_threshold;
+	rx_conf->threshold = cpu_to_le16(wl->conf.rx.irq_pkt_threshold);
+	rx_conf->timeout = cpu_to_le16(wl->conf.rx.irq_timeout);
+	rx_conf->mblk_threshold = cpu_to_le16(wl->conf.rx.irq_blk_threshold);
 	rx_conf->queue_type = wl->conf.rx.queue_type;
 
 	ret = wl1271_cmd_configure(wl, ACX_RX_CONFIG_OPT, rx_conf,
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 5085497..2ce0a81 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -71,10 +71,10 @@ struct acx_header {
 	struct wl1271_cmd_header cmd;
 
 	/* acx (or information element) header */
-	u16 id;
+	__le16 id;
 
 	/* payload length (not including headers */
-	u16 len;
+	__le16 len;
 } __attribute__ ((packed));
 
 struct acx_error_counter {
@@ -83,21 +83,21 @@ struct acx_error_counter {
 	/* The number of PLCP errors since the last time this */
 	/* information element was interrogated. This field is */
 	/* automatically cleared when it is interrogated.*/
-	u32 PLCP_error;
+	__le32 PLCP_error;
 
 	/* The number of FCS errors since the last time this */
 	/* information element was interrogated. This field is */
 	/* automatically cleared when it is interrogated.*/
-	u32 FCS_error;
+	__le32 FCS_error;
 
 	/* The number of MPDUs without PLCP header errors received*/
 	/* since the last time this information element was interrogated. */
 	/* This field is automatically cleared when it is interrogated.*/
-	u32 valid_frame;
+	__le32 valid_frame;
 
 	/* the number of missed sequence numbers in the squentially */
 	/* values of frames seq numbers */
-	u32 seq_num_miss;
+	__le32 seq_num_miss;
 } __attribute__ ((packed));
 
 struct acx_revision {
@@ -126,7 +126,7 @@ struct acx_revision {
 	 *              (1 = first spin, 2 = second spin, and so on).
 	 * bits 24 - 31: Chip ID - The WiLink chip ID.
 	 */
-	u32 hw_version;
+	__le32 hw_version;
 } __attribute__ ((packed));
 
 enum wl1271_psm_mode {
@@ -186,7 +186,7 @@ struct acx_rx_msdu_lifetime {
 	 * The maximum amount of time, in TU, before the
 	 * firmware discards the MSDU.
 	 */
-	u32 lifetime;
+	__le32 lifetime;
 } __attribute__ ((packed));
 
 /*
@@ -273,14 +273,14 @@ struct acx_rx_msdu_lifetime {
 struct acx_rx_config {
 	struct acx_header header;
 
-	u32 config_options;
-	u32 filter_options;
+	__le32 config_options;
+	__le32 filter_options;
 } __attribute__ ((packed));
 
 struct acx_packet_detection {
 	struct acx_header header;
 
-	u32 threshold;
+	__le32 threshold;
 } __attribute__ ((packed));
 
 
@@ -317,14 +317,14 @@ struct acx_dot11_grp_addr_tbl {
 struct acx_rx_timeout {
 	struct acx_header header;
 
-	u16 ps_poll_timeout;
-	u16 upsd_timeout;
+	__le16 ps_poll_timeout;
+	__le16 upsd_timeout;
 } __attribute__ ((packed));
 
 struct acx_rts_threshold {
 	struct acx_header header;
 
-	u16 threshold;
+	__le16 threshold;
 	u8 pad[2];
 } __attribute__ ((packed));
 
@@ -388,8 +388,8 @@ struct acx_beacon_filter_ie_table {
 struct acx_conn_monit_params {
        struct acx_header header;
 
-       u32 synch_fail_thold; /* number of beacons missed */
-       u32 bss_lose_timeout; /* number of TU's from synch fail */
+       __le32 synch_fail_thold; /* number of beacons missed */
+       __le32 bss_lose_timeout; /* number of TU's from synch fail */
 } __attribute__ ((packed));
 
 enum {
@@ -466,16 +466,16 @@ struct acx_smart_reflex_config_params {
 struct acx_bt_wlan_coex_param {
 	struct acx_header header;
 
-	u32 per_threshold;
-	u32 max_scan_compensation_time;
-	u16 nfs_sample_interval;
+	__le32 per_threshold;
+	__le32 max_scan_compensation_time;
+	__le16 nfs_sample_interval;
 	u8 load_ratio;
 	u8 auto_ps_mode;
 	u8 probe_req_compensation;
 	u8 scan_window_compensation;
 	u8 antenna_config;
 	u8 beacon_miss_threshold;
-	u32 rate_adaptation_threshold;
+	__le32 rate_adaptation_threshold;
 	s8 rate_adaptation_snr;
 	u8 padding[3];
 } __attribute__ ((packed));
@@ -484,7 +484,7 @@ struct acx_energy_detection {
 	struct acx_header header;
 
 	/* The RX Clear Channel Assessment threshold in the PHY */
-	u16 rx_cca_threshold;
+	__le16 rx_cca_threshold;
 	u8 tx_energy_detection;
 	u8 pad;
 } __attribute__ ((packed));
@@ -492,8 +492,8 @@ struct acx_energy_detection {
 struct acx_beacon_broadcast {
 	struct acx_header header;
 
-	u16 beacon_rx_timeout;
-	u16 broadcast_timeout;
+	__le16 beacon_rx_timeout;
+	__le16 broadcast_timeout;
 
 	/* Enables receiving of broadcast packets in PS mode */
 	u8 rx_broadcast_in_ps;
@@ -506,8 +506,8 @@ struct acx_beacon_broadcast {
 struct acx_event_mask {
 	struct acx_header header;
 
-	u32 event_mask;
-	u32 high_event_mask; /* Unused */
+	__le32 event_mask;
+	__le32 high_event_mask; /* Unused */
 } __attribute__ ((packed));
 
 #define CFG_RX_FCS		BIT(2)
@@ -551,8 +551,8 @@ struct acx_event_mask {
 struct acx_feature_config {
 	struct acx_header header;
 
-	u32 options;
-	u32 data_flow_options;
+	__le32 options;
+	__le32 data_flow_options;
 } __attribute__ ((packed));
 
 struct acx_current_tx_power {
@@ -576,7 +576,7 @@ struct acx_aid {
 	/*
 	 * To be set when associated with an AP.
 	 */
-	u16 aid;
+	__le16 aid;
 	u8 pad[2];
 } __attribute__ ((packed));
 
@@ -608,152 +608,152 @@ struct acx_ctsprotect {
 } __attribute__ ((packed));
 
 struct acx_tx_statistics {
-	u32 internal_desc_overflow;
+	__le32 internal_desc_overflow;
 }  __attribute__ ((packed));
 
 struct acx_rx_statistics {
-	u32 out_of_mem;
-	u32 hdr_overflow;
-	u32 hw_stuck;
-	u32 dropped;
-	u32 fcs_err;
-	u32 xfr_hint_trig;
-	u32 path_reset;
-	u32 reset_counter;
+	__le32 out_of_mem;
+	__le32 hdr_overflow;
+	__le32 hw_stuck;
+	__le32 dropped;
+	__le32 fcs_err;
+	__le32 xfr_hint_trig;
+	__le32 path_reset;
+	__le32 reset_counter;
 } __attribute__ ((packed));
 
 struct acx_dma_statistics {
-	u32 rx_requested;
-	u32 rx_errors;
-	u32 tx_requested;
-	u32 tx_errors;
+	__le32 rx_requested;
+	__le32 rx_errors;
+	__le32 tx_requested;
+	__le32 tx_errors;
 }  __attribute__ ((packed));
 
 struct acx_isr_statistics {
 	/* host command complete */
-	u32 cmd_cmplt;
+	__le32 cmd_cmplt;
 
 	/* fiqisr() */
-	u32 fiqs;
+	__le32 fiqs;
 
 	/* (INT_STS_ND & INT_TRIG_RX_HEADER) */
-	u32 rx_headers;
+	__le32 rx_headers;
 
 	/* (INT_STS_ND & INT_TRIG_RX_CMPLT) */
-	u32 rx_completes;
+	__le32 rx_completes;
 
 	/* (INT_STS_ND & INT_TRIG_NO_RX_BUF) */
-	u32 rx_mem_overflow;
+	__le32 rx_mem_overflow;
 
 	/* (INT_STS_ND & INT_TRIG_S_RX_RDY) */
-	u32 rx_rdys;
+	__le32 rx_rdys;
 
 	/* irqisr() */
-	u32 irqs;
+	__le32 irqs;
 
 	/* (INT_STS_ND & INT_TRIG_TX_PROC) */
-	u32 tx_procs;
+	__le32 tx_procs;
 
 	/* (INT_STS_ND & INT_TRIG_DECRYPT_DONE) */
-	u32 decrypt_done;
+	__le32 decrypt_done;
 
 	/* (INT_STS_ND & INT_TRIG_DMA0) */
-	u32 dma0_done;
+	__le32 dma0_done;
 
 	/* (INT_STS_ND & INT_TRIG_DMA1) */
-	u32 dma1_done;
+	__le32 dma1_done;
 
 	/* (INT_STS_ND & INT_TRIG_TX_EXC_CMPLT) */
-	u32 tx_exch_complete;
+	__le32 tx_exch_complete;
 
 	/* (INT_STS_ND & INT_TRIG_COMMAND) */
-	u32 commands;
+	__le32 commands;
 
 	/* (INT_STS_ND & INT_TRIG_RX_PROC) */
-	u32 rx_procs;
+	__le32 rx_procs;
 
 	/* (INT_STS_ND & INT_TRIG_PM_802) */
-	u32 hw_pm_mode_changes;
+	__le32 hw_pm_mode_changes;
 
 	/* (INT_STS_ND & INT_TRIG_ACKNOWLEDGE) */
-	u32 host_acknowledges;
+	__le32 host_acknowledges;
 
 	/* (INT_STS_ND & INT_TRIG_PM_PCI) */
-	u32 pci_pm;
+	__le32 pci_pm;
 
 	/* (INT_STS_ND & INT_TRIG_ACM_WAKEUP) */
-	u32 wakeups;
+	__le32 wakeups;
 
 	/* (INT_STS_ND & INT_TRIG_LOW_RSSI) */
-	u32 low_rssi;
+	__le32 low_rssi;
 } __attribute__ ((packed));
 
 struct acx_wep_statistics {
 	/* WEP address keys configured */
-	u32 addr_key_count;
+	__le32 addr_key_count;
 
 	/* default keys configured */
-	u32 default_key_count;
+	__le32 default_key_count;
 
-	u32 reserved;
+	__le32 reserved;
 
 	/* number of times that WEP key not found on lookup */
-	u32 key_not_found;
+	__le32 key_not_found;
 
 	/* number of times that WEP key decryption failed */
-	u32 decrypt_fail;
+	__le32 decrypt_fail;
 
 	/* WEP packets decrypted */
-	u32 packets;
+	__le32 packets;
 
 	/* WEP decrypt interrupts */
-	u32 interrupt;
+	__le32 interrupt;
 } __attribute__ ((packed));
 
 #define ACX_MISSED_BEACONS_SPREAD 10
 
 struct acx_pwr_statistics {
 	/* the amount of enters into power save mode (both PD & ELP) */
-	u32 ps_enter;
+	__le32 ps_enter;
 
 	/* the amount of enters into ELP mode */
-	u32 elp_enter;
+	__le32 elp_enter;
 
 	/* the amount of missing beacon interrupts to the host */
-	u32 missing_bcns;
+	__le32 missing_bcns;
 
 	/* the amount of wake on host-access times */
-	u32 wake_on_host;
+	__le32 wake_on_host;
 
 	/* the amount of wake on timer-expire */
-	u32 wake_on_timer_exp;
+	__le32 wake_on_timer_exp;
 
 	/* the number of packets that were transmitted with PS bit set */
-	u32 tx_with_ps;
+	__le32 tx_with_ps;
 
 	/* the number of packets that were transmitted with PS bit clear */
-	u32 tx_without_ps;
+	__le32 tx_without_ps;
 
 	/* the number of received beacons */
-	u32 rcvd_beacons;
+	__le32 rcvd_beacons;
 
 	/* the number of entering into PowerOn (power save off) */
-	u32 power_save_off;
+	__le32 power_save_off;
 
 	/* the number of entries into power save mode */
-	u16 enable_ps;
+	__le16 enable_ps;
 
 	/*
 	 * the number of exits from power save, not including failed PS
 	 * transitions
 	 */
-	u16 disable_ps;
+	__le16 disable_ps;
 
 	/*
 	 * the number of times the TSF counter was adjusted because
 	 * of drift
 	 */
-	u32 fix_tsf_ps;
+	__le32 fix_tsf_ps;
 
 	/* Gives statistics about the spread continuous missed beacons.
 	 * The 16 LSB are dedicated for the PS mode.
@@ -764,53 +764,53 @@ struct acx_pwr_statistics {
 	 * ...
 	 * cont_miss_bcns_spread[9] - ten and more continuous missed beacons.
 	*/
-	u32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
+	__le32 cont_miss_bcns_spread[ACX_MISSED_BEACONS_SPREAD];
 
 	/* the number of beacons in awake mode */
-	u32 rcvd_awake_beacons;
+	__le32 rcvd_awake_beacons;
 } __attribute__ ((packed));
 
 struct acx_mic_statistics {
-	u32 rx_pkts;
-	u32 calc_failure;
+	__le32 rx_pkts;
+	__le32 calc_failure;
 } __attribute__ ((packed));
 
 struct acx_aes_statistics {
-	u32 encrypt_fail;
-	u32 decrypt_fail;
-	u32 encrypt_packets;
-	u32 decrypt_packets;
-	u32 encrypt_interrupt;
-	u32 decrypt_interrupt;
+	__le32 encrypt_fail;
+	__le32 decrypt_fail;
+	__le32 encrypt_packets;
+	__le32 decrypt_packets;
+	__le32 encrypt_interrupt;
+	__le32 decrypt_interrupt;
 } __attribute__ ((packed));
 
 struct acx_event_statistics {
-	u32 heart_beat;
-	u32 calibration;
-	u32 rx_mismatch;
-	u32 rx_mem_empty;
-	u32 rx_pool;
-	u32 oom_late;
-	u32 phy_transmit_error;
-	u32 tx_stuck;
+	__le32 heart_beat;
+	__le32 calibration;
+	__le32 rx_mismatch;
+	__le32 rx_mem_empty;
+	__le32 rx_pool;
+	__le32 oom_late;
+	__le32 phy_transmit_error;
+	__le32 tx_stuck;
 } __attribute__ ((packed));
 
 struct acx_ps_statistics {
-	u32 pspoll_timeouts;
-	u32 upsd_timeouts;
-	u32 upsd_max_sptime;
-	u32 upsd_max_apturn;
-	u32 pspoll_max_apturn;
-	u32 pspoll_utilization;
-	u32 upsd_utilization;
+	__le32 pspoll_timeouts;
+	__le32 upsd_timeouts;
+	__le32 upsd_max_sptime;
+	__le32 upsd_max_apturn;
+	__le32 pspoll_max_apturn;
+	__le32 pspoll_utilization;
+	__le32 upsd_utilization;
 } __attribute__ ((packed));
 
 struct acx_rxpipe_statistics {
-	u32 rx_prep_beacon_drop;
-	u32 descr_host_int_trig_rx_data;
-	u32 beacon_buffer_thres_host_int_trig_rx_data;
-	u32 missed_beacon_host_int_trig_rx_data;
-	u32 tx_xfr_host_int_trig_rx_data;
+	__le32 rx_prep_beacon_drop;
+	__le32 descr_host_int_trig_rx_data;
+	__le32 beacon_buffer_thres_host_int_trig_rx_data;
+	__le32 missed_beacon_host_int_trig_rx_data;
+	__le32 tx_xfr_host_int_trig_rx_data;
 } __attribute__ ((packed));
 
 struct acx_statistics {
@@ -830,7 +830,7 @@ struct acx_statistics {
 } __attribute__ ((packed));
 
 struct acx_rate_class {
-	u32 enabled_rates;
+	__le32 enabled_rates;
 	u8 short_retry_limit;
 	u8 long_retry_limit;
 	u8 aflags;
@@ -840,7 +840,7 @@ struct acx_rate_class {
 struct acx_rate_policy {
 	struct acx_header header;
 
-	u32 rate_class_cnt;
+	__le32 rate_class_cnt;
 	struct acx_rate_class rate_class[CONF_TX_MAX_RATE_CLASSES];
 } __attribute__ ((packed));
 
@@ -848,10 +848,10 @@ struct acx_ac_cfg {
 	struct acx_header header;
 	u8 ac;
 	u8 cw_min;
-	u16 cw_max;
+	__le16 cw_max;
 	u8 aifsn;
 	u8 reserved;
-	u16 tx_op_limit;
+	__le16 tx_op_limit;
 } __attribute__ ((packed));
 
 struct acx_tid_config {
@@ -862,19 +862,19 @@ struct acx_tid_config {
 	u8 ps_scheme;
 	u8 ack_policy;
 	u8 padding[3];
-	u32 apsd_conf[2];
+	__le32 apsd_conf[2];
 } __attribute__ ((packed));
 
 struct acx_frag_threshold {
 	struct acx_header header;
-	u16 frag_threshold;
+	__le16 frag_threshold;
 	u8 padding[2];
 } __attribute__ ((packed));
 
 struct acx_tx_config_options {
 	struct acx_header header;
-	u16 tx_compl_timeout;     /* msec */
-	u16 tx_compl_threshold;   /* number of packets */
+	__le16 tx_compl_timeout;     /* msec */
+	__le16 tx_compl_threshold;   /* number of packets */
 } __attribute__ ((packed));
 
 #define ACX_RX_MEM_BLOCKS     64
@@ -889,59 +889,59 @@ struct wl1271_acx_config_memory {
 	u8 tx_min_mem_block_num;
 	u8 num_stations;
 	u8 num_ssid_profiles;
-	u32 total_tx_descriptors;
+	__le32 total_tx_descriptors;
 } __attribute__ ((packed));
 
 struct wl1271_acx_mem_map {
 	struct acx_header header;
 
-	void *code_start;
-	void *code_end;
+	__le32 code_start;
+	__le32 code_end;
 
-	void *wep_defkey_start;
-	void *wep_defkey_end;
+	__le32 wep_defkey_start;
+	__le32 wep_defkey_end;
 
-	void *sta_table_start;
-	void *sta_table_end;
+	__le32 sta_table_start;
+	__le32 sta_table_end;
 
-	void *packet_template_start;
-	void *packet_template_end;
+	__le32 packet_template_start;
+	__le32 packet_template_end;
 
 	/* Address of the TX result interface (control block) */
-	u32 tx_result;
-	u32 tx_result_queue_start;
+	__le32 tx_result;
+	__le32 tx_result_queue_start;
 
-	void *queue_memory_start;
-	void *queue_memory_end;
+	__le32 queue_memory_start;
+	__le32 queue_memory_end;
 
-	u32 packet_memory_pool_start;
-	u32 packet_memory_pool_end;
+	__le32 packet_memory_pool_start;
+	__le32 packet_memory_pool_end;
 
-	void *debug_buffer1_start;
-	void *debug_buffer1_end;
+	__le32 debug_buffer1_start;
+	__le32 debug_buffer1_end;
 
-	void *debug_buffer2_start;
-	void *debug_buffer2_end;
+	__le32 debug_buffer2_start;
+	__le32 debug_buffer2_end;
 
 	/* Number of blocks FW allocated for TX packets */
-	u32 num_tx_mem_blocks;
+	__le32 num_tx_mem_blocks;
 
 	/* Number of blocks FW allocated for RX packets */
-	u32 num_rx_mem_blocks;
+	__le32 num_rx_mem_blocks;
 
 	/* the following 4 fields are valid in SLAVE mode only */
 	u8 *tx_cbuf;
 	u8 *rx_cbuf;
-	void *rx_ctrl;
-	void *tx_ctrl;
+	__le32 rx_ctrl;
+	__le32 tx_ctrl;
 } __attribute__ ((packed));
 
 struct wl1271_acx_rx_config_opt {
 	struct acx_header header;
 
-	u16 mblk_threshold;
-	u16 threshold;
-	u16 timeout;
+	__le16 mblk_threshold;
+	__le16 threshold;
+	__le16 timeout;
 	u8 queue_type;
 	u8 reserved;
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 41a3050..ba4a2b4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -188,15 +188,15 @@ static int wl1271_boot_upload_firmware(struct wl1271 *wl)
 	u8 *fw;
 
 	fw = wl->fw;
-	chunks = be32_to_cpup((u32 *) fw);
+	chunks = be32_to_cpup((__be32 *) fw);
 	fw += sizeof(u32);
 
 	wl1271_debug(DEBUG_BOOT, "firmware chunks to be uploaded: %u", chunks);
 
 	while (chunks--) {
-		addr = be32_to_cpup((u32 *) fw);
+		addr = be32_to_cpup((__be32 *) fw);
 		fw += sizeof(u32);
-		len = be32_to_cpup((u32 *) fw);
+		len = be32_to_cpup((__be32 *) fw);
 		fw += sizeof(u32);
 
 		if (len > 300000) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 195eee7..0666328 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -50,7 +50,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	int ret = 0;
 
 	cmd = buf;
-	cmd->id = id;
+	cmd->id = cpu_to_le16(id);
 	cmd->status = 0;
 
 	WARN_ON(len % 4 != 0);
@@ -217,8 +217,8 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	for (i = 0; i < ETH_ALEN; i++)
 		bssid[i] = wl->bssid[ETH_ALEN - i - 1];
 
-	join->rx_config_options = wl->rx_config;
-	join->rx_filter_options = wl->rx_filter;
+	join->rx_config_options = cpu_to_le32(wl->rx_config);
+	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = wl->bss_type;
 
 	/*
@@ -227,21 +227,22 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	 * association. The filter logic needs to be implemented properly
 	 * and once that is done, this hack can be removed.
 	 */
-	join->rx_config_options = 0;
-	join->rx_filter_options = WL1271_DEFAULT_RX_FILTER;
+	join->rx_config_options = cpu_to_le32(0);
+	join->rx_filter_options = cpu_to_le32(WL1271_DEFAULT_RX_FILTER);
 
 	if (wl->band == IEEE80211_BAND_2GHZ)
-		join->basic_rate_set =
-			CONF_HW_BIT_RATE_1MBPS | CONF_HW_BIT_RATE_2MBPS |
-		CONF_HW_BIT_RATE_5_5MBPS | CONF_HW_BIT_RATE_11MBPS;
+		join->basic_rate_set = cpu_to_le32(CONF_HW_BIT_RATE_1MBPS   |
+						   CONF_HW_BIT_RATE_2MBPS   |
+						   CONF_HW_BIT_RATE_5_5MBPS |
+						   CONF_HW_BIT_RATE_11MBPS);
 	else {
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
-		join->basic_rate_set =
-			CONF_HW_BIT_RATE_6MBPS | CONF_HW_BIT_RATE_12MBPS |
-			CONF_HW_BIT_RATE_24MBPS;
+		join->basic_rate_set = cpu_to_le32(CONF_HW_BIT_RATE_6MBPS  |
+						   CONF_HW_BIT_RATE_12MBPS |
+						   CONF_HW_BIT_RATE_24MBPS);
 	}
 
-	join->beacon_interval = WL1271_DEFAULT_BEACON_INT;
+	join->beacon_interval = cpu_to_le16(WL1271_DEFAULT_BEACON_INT);
 	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
 
 	join->channel = wl->channel;
@@ -305,6 +306,7 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 
 	if (answer) {
 		struct wl1271_command *cmd_answer;
+		u16 status;
 
 		/*
 		 * The test command got in, we can read the answer.
@@ -314,10 +316,10 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 		wl1271_spi_read(wl, wl->cmd_box_addr, buf, buf_len, false);
 
 		cmd_answer = buf;
+		status = le16_to_cpu(cmd_answer->header.status);
 
-		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
-			wl1271_error("TEST command answer error: %d",
-				     cmd_answer->header.status);
+		if (status != CMD_STATUS_SUCCESS)
+			wl1271_error("TEST command answer error: %d", status);
 	}
 
 	return 0;
@@ -338,10 +340,10 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 	wl1271_debug(DEBUG_CMD, "cmd interrogate");
 
-	acx->id = id;
+	acx->id = cpu_to_le16(id);
 
 	/* payload length, does not include any headers */
-	acx->len = len - sizeof(*acx);
+	acx->len = cpu_to_le16(len - sizeof(*acx));
 
 	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
 	if (ret < 0) {
@@ -353,9 +355,9 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	wl1271_spi_read(wl, wl->cmd_box_addr, buf, len, false);
 
 	acx = buf;
-	if (acx->cmd.status != CMD_STATUS_SUCCESS)
+	if (le16_to_cpu(acx->cmd.status) != CMD_STATUS_SUCCESS)
 		wl1271_error("INTERROGATE command error: %d",
-			     acx->cmd.status);
+			     le16_to_cpu(acx->cmd.status));
 
 out:
 	return ret;
@@ -376,10 +378,10 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 
 	wl1271_debug(DEBUG_CMD, "cmd configure");
 
-	acx->id = id;
+	acx->id = cpu_to_le16(id);
 
 	/* payload length, does not include any headers */
-	acx->len = len - sizeof(*acx);
+	acx->len = cpu_to_le16(len - sizeof(*acx));
 
 	ret = wl1271_cmd_send(wl, CMD_CONFIGURE, acx, len);
 	if (ret < 0) {
@@ -463,7 +465,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 	ps_params->send_null_data = 1;
 	ps_params->retries = 5;
 	ps_params->hang_over_period = 128;
-	ps_params->null_data_rate = 1; /* 1 Mbps */
+	ps_params->null_data_rate = cpu_to_le32(1); /* 1 Mbps */
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
 			      sizeof(*ps_params));
@@ -494,8 +496,8 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 	WARN_ON(len > MAX_READ_SIZE);
 	len = min_t(size_t, len, MAX_READ_SIZE);
 
-	cmd->addr = addr;
-	cmd->size = len;
+	cmd->addr = cpu_to_le32(addr);
+	cmd->size = cpu_to_le32(len);
 
 	ret = wl1271_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
 	if (ret < 0) {
@@ -506,9 +508,9 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 	/* the read command got in, we can now read the answer */
 	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd), false);
 
-	if (cmd->header.status != CMD_STATUS_SUCCESS)
+	if (le16_to_cpu(cmd->header.status) != CMD_STATUS_SUCCESS)
 		wl1271_error("error in read command result: %d",
-			     cmd->header.status);
+			     le16_to_cpu(cmd->header.status));
 
 	memcpy(answer, cmd->value, len);
 
@@ -559,7 +561,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 	if (high_prio)
 		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
-	params->params.scan_options = scan_options;
+	params->params.scan_options = cpu_to_le16(scan_options);
 
 	params->params.num_probe_requests = probe_requests;
 	/* Let the fw autodetect suitable tx_rate for probes */
@@ -643,9 +645,9 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	wl1271_spi_read(wl, wl->cmd_box_addr, params, sizeof(*params),
 			false);
 
-	if (params->header.status != CMD_STATUS_SUCCESS) {
+	if (le16_to_cpu(params->header.status) != CMD_STATUS_SUCCESS) {
 		wl1271_error("Scan command error: %d",
-			     params->header.status);
+			     le16_to_cpu(params->header.status));
 		wl->scanning = false;
 		ret = -EIO;
 		goto out;
@@ -675,7 +677,7 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 
 	cmd->len = cpu_to_le16(buf_len);
 	cmd->template_type = template_id;
-	cmd->enabled_rates = wl->conf.tx.rc_conf.enabled_rates;
+	cmd->enabled_rates = cpu_to_le32(wl->conf.tx.rc_conf.enabled_rates);
 	cmd->short_retry_limit = wl->conf.tx.rc_conf.short_retry_limit;
 	cmd->long_retry_limit = wl->conf.tx.rc_conf.long_retry_limit;
 
@@ -858,7 +860,7 @@ int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
 	}
 
 	cmd->id = id;
-	cmd->key_action = KEY_SET_ID;
+	cmd->key_action = cpu_to_le16(KEY_SET_ID);
 	cmd->key_type = KEY_WEP;
 
 	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd));
@@ -889,12 +891,12 @@ int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 	if (key_type != KEY_WEP)
 		memcpy(cmd->addr, addr, ETH_ALEN);
 
-	cmd->key_action = action;
+	cmd->key_action = cpu_to_le16(action);
 	cmd->key_size = key_size;
 	cmd->key_type = key_type;
 
-	cmd->ac_seq_num16[0] = tx_seq_16;
-	cmd->ac_seq_num32[0] = tx_seq_32;
+	cmd->ac_seq_num16[0] = cpu_to_le16(tx_seq_16);
+	cmd->ac_seq_num32[0] = cpu_to_le32(tx_seq_32);
 
 	/* we have only one SSID profile */
 	cmd->ssid_profile = 0;
@@ -943,8 +945,8 @@ int wl1271_cmd_disconnect(struct wl1271 *wl)
 		goto out;
 	}
 
-	cmd->rx_config_options = wl->rx_config;
-	cmd->rx_filter_options = wl->rx_filter;
+	cmd->rx_config_options = cpu_to_le32(wl->rx_config);
+	cmd->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	/* disconnect reason is not used in immediate disconnections */
 	cmd->type = DISCONNECT_IMMEDIATE;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 15254fa..57d6905 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -120,8 +120,8 @@ enum cmd_templ {
 #define WL1271_CMD_TEMPL_MAX_SIZE  252
 
 struct wl1271_cmd_header {
-	u16 id;
-	u16 status;
+	__le16 id;
+	__le16 status;
 	/* payload */
 	u8 data[0];
 } __attribute__ ((packed));
@@ -174,11 +174,11 @@ struct cmd_read_write_memory {
 	struct wl1271_cmd_header header;
 
 	/* The address of the memory to read from or write to.*/
-	u32 addr;
+	__le32 addr;
 
 	/* The amount of data in bytes to read from or write to the WiLink
 	 * device.*/
-	u32 size;
+	__le32 size;
 
 	/* The actual value read from or written to the Wilink. The source
 	   of this field is the Host in WRITE command or the Wilink in READ
@@ -203,18 +203,18 @@ enum {
 struct wl1271_cmd_join {
 	struct wl1271_cmd_header header;
 
-	u32 bssid_lsb;
-	u16 bssid_msb;
-	u16 beacon_interval; /* in TBTTs */
-	u32 rx_config_options;
-	u32 rx_filter_options;
+	__le32 bssid_lsb;
+	__le16 bssid_msb;
+	__le16 beacon_interval; /* in TBTTs */
+	__le32 rx_config_options;
+	__le32 rx_filter_options;
 
 	/*
 	 * The target uses this field to determine the rate at
 	 * which to transmit control frame responses (such as
 	 * ACK or CTS frames).
 	 */
-	u32 basic_rate_set;
+	__le32 basic_rate_set;
 	u8 dtim_interval;
 	/*
 	 * bits 0-2: This bitwise field specifies the type
@@ -243,10 +243,10 @@ struct cmd_enabledisable_path {
 struct wl1271_cmd_template_set {
 	struct wl1271_cmd_header header;
 
-	u16 len;
+	__le16 len;
 	u8 template_type;
 	u8 index;  /* relevant only for KLV_TEMPLATE type */
-	u32 enabled_rates;
+	__le32 enabled_rates;
 	u8 short_retry_limit;
 	u8 long_retry_limit;
 	u8 aflags;
@@ -283,7 +283,7 @@ struct wl1271_cmd_ps_params {
 	  * to power save mode.
 	  */
 	u8 hang_over_period;
-	u32 null_data_rate;
+	__le32 null_data_rate;
 } __attribute__ ((packed));
 
 /* HW encryption keys */
@@ -314,9 +314,9 @@ struct wl1271_cmd_set_keys {
 	u8 addr[ETH_ALEN];
 
 	/* key_action_e */
-	u16 key_action;
+	__le16 key_action;
 
-	u16 reserved_1;
+	__le16 reserved_1;
 
 	/* key size in bytes */
 	u8 key_size;
@@ -332,8 +332,8 @@ struct wl1271_cmd_set_keys {
 	u8 id;
 	u8 reserved_2[6];
 	u8 key[MAX_KEY_SIZE];
-	u16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
-	u32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
+	__le16 ac_seq_num16[NUM_ACCESS_CATEGORIES_COPY];
+	__le32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
 } __attribute__ ((packed));
 
 
@@ -350,17 +350,17 @@ struct wl1271_cmd_set_keys {
 #define WL1271_SCAN_BAND_DUAL 2
 
 struct basic_scan_params {
-	u32 rx_config_options;
-	u32 rx_filter_options;
+	__le32 rx_config_options;
+	__le32 rx_filter_options;
 	/* Scan option flags (WL1271_SCAN_OPT_*) */
-	u16 scan_options;
+	__le16 scan_options;
 	/* Number of scan channels in the list (maximum 30) */
 	u8 num_channels;
 	/* This field indicates the number of probe requests to send
 	   per channel for an active scan */
 	u8 num_probe_requests;
 	/* Rate bit field for sending the probes */
-	u32 tx_rate;
+	__le32 tx_rate;
 	u8 tid_trigger;
 	u8 ssid_len;
 	/* in order to align */
@@ -375,10 +375,10 @@ struct basic_scan_params {
 
 struct basic_scan_channel_params {
 	/* Duration in TU to wait for frames on a channel for active scan */
-	u32 min_duration;
-	u32 max_duration;
-	u32 bssid_lsb;
-	u16 bssid_msb;
+	__le32 min_duration;
+	__le32 max_duration;
+	__le32 bssid_lsb;
+	__le16 bssid_msb;
 	u8 early_termination;
 	u8 tx_power_att;
 	u8 channel;
@@ -398,7 +398,7 @@ struct wl1271_cmd_scan {
 struct wl1271_cmd_trigger_scan_to {
 	struct wl1271_cmd_header header;
 
-	u32 timeout;
+	__le32 timeout;
 };
 
 struct wl1271_cmd_test_header {
@@ -426,7 +426,7 @@ struct wl1271_cmd_cal_channel_tune {
 	u8 band;
 	u8 channel;
 
-	u16 radio_status;
+	__le16 radio_status;
 } __attribute__ ((packed));
 
 struct wl1271_cmd_cal_update_ref_point {
@@ -434,8 +434,8 @@ struct wl1271_cmd_cal_update_ref_point {
 
 	struct wl1271_cmd_test_header test;
 
-	s32 ref_power;
-	s32 ref_detector;
+	__le32 ref_power;
+	__le32 ref_detector;
 	u8  sub_band;
 	u8  padding[3];
 } __attribute__ ((packed));
@@ -450,12 +450,12 @@ struct wl1271_cmd_cal_p2g {
 
 	struct wl1271_cmd_test_header test;
 
-	u16 len;
+	__le16 len;
 	u8  buf[MAX_TLV_LENGTH];
 	u8  type;
 	u8  padding;
 
-	s16 radio_status;
+	__le16 radio_status;
 	u8  nvs_version[MAX_NVS_VERSION_LENGTH];
 
 	u8  sub_band_mask;
@@ -479,10 +479,10 @@ enum wl1271_disconnect_type {
 };
 
 struct wl1271_cmd_disconnect {
-	u32 rx_config_options;
-	u32 rx_filter_options;
+	__le32 rx_config_options;
+	__le32 rx_filter_options;
 
-	u16 reason;
+	__le16 reason;
 	u8  type;
 
 	u8  padding;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index a4b11e4..31d396b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -82,7 +82,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 
 	wl1271_event_mbox_dump(mbox);
 
-	vector = mbox->events_vector & ~(mbox->events_mask);
+	vector = le32_to_cpu(mbox->events_vector);
+	vector &= ~(le32_to_cpu(mbox->events_mask));
 	wl1271_debug(DEBUG_EVENT, "vector: 0x%x", vector);
 
 	if (vector & SCAN_COMPLETE_EVENT_ID) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index adc4653..3ab53d3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -66,33 +66,33 @@ enum {
 struct event_debug_report {
 	u8 debug_event_id;
 	u8 num_params;
-	u16 pad;
-	u32 report_1;
-	u32 report_2;
-	u32 report_3;
+	__le16 pad;
+	__le32 report_1;
+	__le32 report_2;
+	__le32 report_3;
 } __attribute__ ((packed));
 
 #define NUM_OF_RSSI_SNR_TRIGGERS 8
 
 struct event_mailbox {
-	u32 events_vector;
-	u32 events_mask;
-	u32 reserved_1;
-	u32 reserved_2;
+	__le32 events_vector;
+	__le32 events_mask;
+	__le32 reserved_1;
+	__le32 reserved_2;
 
 	u8 dbg_event_id;
 	u8 num_relevant_params;
-	u16 reserved_3;
-	u32 event_report_p1;
-	u32 event_report_p2;
-	u32 event_report_p3;
+	__le16 reserved_3;
+	__le32 event_report_p1;
+	__le32 event_report_p2;
+	__le32 event_report_p3;
 
 	u8 number_of_scan_results;
 	u8 scan_tag;
 	u8 reserved_4[2];
-	u32 compl_scheduled_scan_status;
+	__le32 compl_scheduled_scan_status;
 
-	u16 scheduled_scan_attended_channels;
+	__le16 scheduled_scan_attended_channels;
 	u8 soft_gemini_sense_info;
 	u8 soft_gemini_protective_info;
 	s8 rssi_snr_trigger_metric[NUM_OF_RSSI_SNR_TRIGGERS];
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
index 513d0cb..6e21cee 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.h
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -65,7 +65,7 @@ struct wl1271_radio_parms {
 
 	/* Dynamic radio parameters */
 	/* 2.4GHz */
-	s16 tx_ref_pd_voltage;
+	__le16 tx_ref_pd_voltage;
 	s8  tx_ref_power;
 	s8  tx_offset_db;
 
@@ -82,7 +82,7 @@ struct wl1271_radio_parms {
 	u8 padding2;
 
 	/* 5GHz */
-	s16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
+	__le16 tx_ref_pd_voltage_5[CONF_NUMBER_OF_SUB_BANDS_5];
 	s8  tx_ref_power_5[CONF_NUMBER_OF_SUB_BANDS_5];
 	s8  tx_offset_db_5[CONF_NUMBER_OF_SUB_BANDS_5];
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index ee7ffaf..86132bb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -397,8 +397,11 @@ static void wl1271_fw_status(struct wl1271 *wl,
 
 	/* update number of available TX blocks */
 	for (i = 0; i < NUM_TX_QUEUES; i++) {
-		u32 cnt = status->tx_released_blks[i] - wl->tx_blocks_freed[i];
-		wl->tx_blocks_freed[i] = status->tx_released_blks[i];
+		u32 cnt = le32_to_cpu(status->tx_released_blks[i]) -
+			wl->tx_blocks_freed[i];
+
+		wl->tx_blocks_freed[i] =
+			le32_to_cpu(status->tx_released_blks[i]);
 		wl->tx_blocks_available += cnt;
 		total += cnt;
 	}
@@ -408,7 +411,8 @@ static void wl1271_fw_status(struct wl1271 *wl,
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
 	/* update the host-chipset time offset */
-	wl->time_offset = jiffies_to_usecs(jiffies) - status->fw_localtime;
+	wl->time_offset = jiffies_to_usecs(jiffies) -
+		le32_to_cpu(status->fw_localtime);
 }
 
 static void wl1271_irq_work(struct work_struct *work)
@@ -432,7 +436,7 @@ static void wl1271_irq_work(struct work_struct *work)
 	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
 	wl1271_fw_status(wl, wl->fw_status);
-	intr = wl->fw_status->intr;
+	intr = le32_to_cpu(wl->fw_status->intr);
 	if (!intr) {
 		wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
 		goto out_sleep;
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.c b/drivers/net/wireless/wl12xx/wl1271_rx.c
index 1ea3f41..dbf07be 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.c
@@ -30,14 +30,15 @@
 static u8 wl1271_rx_get_mem_block(struct wl1271_fw_status *status,
 				  u32 drv_rx_counter)
 {
-	return status->rx_pkt_descs[drv_rx_counter] & RX_MEM_BLOCK_MASK;
+	return le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
+		RX_MEM_BLOCK_MASK;
 }
 
 static u32 wl1271_rx_get_buf_size(struct wl1271_fw_status *status,
 				 u32 drv_rx_counter)
 {
-	return (status->rx_pkt_descs[drv_rx_counter] & RX_BUF_SIZE_MASK) >>
-		RX_BUF_SIZE_SHIFT_DIV;
+	return (le32_to_cpu(status->rx_pkt_descs[drv_rx_counter]) &
+		RX_BUF_SIZE_MASK) >> RX_BUF_SIZE_SHIFT_DIV;
 }
 
 /* The values of this table must match the wl1271_rates[] array */
@@ -203,8 +204,8 @@ void wl1271_rx(struct wl1271 *wl, struct wl1271_fw_status *status)
 			break;
 		}
 
-		wl->rx_mem_pool_addr.addr =
-			(mem_block << 8) + wl_mem_map->packet_memory_pool_start;
+		wl->rx_mem_pool_addr.addr = (mem_block << 8) +
+			le32_to_cpu(wl_mem_map->packet_memory_pool_start);
 		wl->rx_mem_pool_addr.addr_extra =
 			wl->rx_mem_pool_addr.addr + 4;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_rx.h b/drivers/net/wireless/wl12xx/wl1271_rx.h
index d1ca60e..1ae6d17 100644
--- a/drivers/net/wireless/wl12xx/wl1271_rx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_rx.h
@@ -102,14 +102,14 @@
 #define RX_BUF_SIZE_SHIFT_DIV 6
 
 struct wl1271_rx_descriptor {
-	u16 length;
+	__le16 length;
 	u8  status;
 	u8  flags;
 	u8  rate;
 	u8  channel;
 	s8  rssi;
 	u8  snr;
-	u32 timestamp;
+	__le32 timestamp;
 	u8  packet_class;
 	u8  process_id;
 	u8  pad_len;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 4560458..00af065 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -88,6 +88,7 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 {
 	struct wl1271_tx_hw_descr *desc;
 	int pad;
+	u16 tx_attr;
 
 	desc = (struct wl1271_tx_hw_descr *) skb->data;
 
@@ -95,16 +96,17 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	if (extra) {
 		void *framestart = skb->data + sizeof(*desc);
 		u16 fc = *(u16 *)(framestart + extra);
-		int hdrlen = ieee80211_hdrlen(fc);
+		int hdrlen = ieee80211_hdrlen(cpu_to_le16(fc));
 		memmove(framestart, framestart + extra, hdrlen);
 	}
 
 	/* configure packet life time */
-	desc->start_time = jiffies_to_usecs(jiffies) - wl->time_offset;
-	desc->life_time = TX_HW_MGMT_PKT_LIFETIME_TU;
+	desc->start_time = cpu_to_le32(jiffies_to_usecs(jiffies) -
+				       wl->time_offset);
+	desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
 
 	/* configure the tx attributes */
-	desc->tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
+	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
 	/* FIXME: do we know the packet priority? can we identify mgmt
 	   packets, and use max prio for them at least? */
 	desc->tid = 0;
@@ -113,11 +115,13 @@ static int wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 
 	/* align the length (and store in terms of words) */
 	pad = WL1271_TX_ALIGN(skb->len);
-	desc->length = pad >> 2;
+	desc->length = cpu_to_le16(pad >> 2);
 
 	/* calculate number of padding bytes */
 	pad = pad - skb->len;
-	desc->tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+	tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
+
+	desc->tx_attr = cpu_to_le16(tx_attr);
 
 	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d", pad);
 	return 0;
@@ -331,7 +335,7 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
 
 	/* read the tx results from the chipset */
-	wl1271_spi_read(wl, memmap->tx_result,
+	wl1271_spi_read(wl, le32_to_cpu(memmap->tx_result),
 			wl->tx_res_if, sizeof(*wl->tx_res_if), false);
 
 	/* verify that the result buffer is not getting overrun */
@@ -353,10 +357,10 @@ void wl1271_tx_complete(struct wl1271 *wl, u32 count)
 	}
 
 	/* write host counter to chipset (to ack) */
-	wl1271_spi_write32(wl, memmap->tx_result +
+	wl1271_spi_write32(wl, le32_to_cpu(memmap->tx_result) +
 			   offsetof(struct wl1271_tx_hw_res_if,
 				    tx_result_host_counter),
-			   wl->tx_res_if->tx_result_fw_counter);
+			   le32_to_cpu(wl->tx_res_if->tx_result_fw_counter));
 }
 
 /* caller must hold wl->mutex */
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.h b/drivers/net/wireless/wl12xx/wl1271_tx.h
index 4a61406..416396c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.h
@@ -58,7 +58,7 @@
 
 struct wl1271_tx_hw_descr {
 	/* Length of packet in words, including descriptor+header+data */
-	u16 length;
+	__le16 length;
 	/* Number of extra memory blocks to allocate for this packet in
 	   addition to the number of blocks derived from the packet length */
 	u8 extra_mem_blocks;
@@ -67,12 +67,12 @@ struct wl1271_tx_hw_descr {
 	   HW!! */
 	u8 total_mem_blocks;
 	/* Device time (in us) when the packet arrived to the driver */
-	u32 start_time;
+	__le32 start_time;
 	/* Max delay in TUs until transmission. The last device time the
 	   packet can be transmitted is: startTime+(1024*LifeTime) */
-	u16 life_time;
+	__le16 life_time;
 	/* Bitwise fields - see TX_ATTR... definitions above. */
-	u16 tx_attr;
+	__le16 tx_attr;
 	/* Packet identifier used also in the Tx-Result. */
 	u8 id;
 	/* The packet TID value (as User-Priority) */
@@ -100,12 +100,12 @@ struct wl1271_tx_hw_res_descr {
 	   several possible reasons for failure. */
 	u8 status;
 	/* Total air access duration including all retrys and overheads.*/
-	u16 medium_usage;
+	__le16 medium_usage;
 	/* The time passed from host xfer to Tx-complete.*/
-	u32 fw_handling_time;
+	__le32 fw_handling_time;
 	/* Total media delay
 	   (from 1st EDCA AIFS counter until TX Complete). */
-	u32 medium_delay;
+	__le32 medium_delay;
 	/* LS-byte of last TKIP seq-num (saved per AC for recovery). */
 	u8 lsb_security_sequence_number;
 	/* Retry count - number of transmissions without successful ACK.*/
@@ -118,8 +118,8 @@ struct wl1271_tx_hw_res_descr {
 } __attribute__ ((packed));
 
 struct wl1271_tx_hw_res_if {
-	u32 tx_result_fw_counter;
-	u32 tx_result_host_counter;
+	__le32 tx_result_fw_counter;
+	__le32 tx_result_host_counter;
 	struct wl1271_tx_hw_res_descr tx_results_queue[TX_HW_RESULT_QUEUE_LEN];
 } __attribute__ ((packed));
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx_80211.h b/drivers/net/wireless/wl12xx/wl12xx_80211.h
index 657c2db..055d7bc 100644
--- a/drivers/net/wireless/wl12xx/wl12xx_80211.h
+++ b/drivers/net/wireless/wl12xx/wl12xx_80211.h
@@ -122,8 +122,8 @@ struct wl12xx_null_data_template {
 } __attribute__ ((packed));
 
 struct wl12xx_ps_poll_template {
-	u16 fc;
-	u16 aid;
+	__le16 fc;
+	__le16 aid;
 	u8 bssid[ETH_ALEN];
 	u8 ta[ETH_ALEN];
 } __attribute__ ((packed));
-- 
1.5.6.5

