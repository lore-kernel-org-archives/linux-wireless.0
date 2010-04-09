Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49063 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab0DIIH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 04:07:56 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 5/5] wl1271: Add support for connection quality monitoring
Date: Fri,  9 Apr 2010 11:07:30 +0300
Message-Id: <1270800450-8167-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
References: <1270800450-8167-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch will add support for connection quality monitoring by configuring
rssi triggers to the firmware, and enabling the firmware rssi trigger
functionality.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |    3 +
 drivers/net/wireless/wl12xx/wl1271_acx.c   |   71 +++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_acx.h   |   56 +++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_boot.c  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_conf.h  |  103 ++++++++++-----------------
 drivers/net/wireless/wl12xx/wl1271_event.c |   24 +++++++
 drivers/net/wireless/wl12xx/wl1271_event.h |    8 ++
 drivers/net/wireless/wl12xx/wl1271_init.c  |    5 ++
 drivers/net/wireless/wl12xx/wl1271_main.c  |   52 ++++++--------
 9 files changed, 228 insertions(+), 97 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 7894600..75887e7 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -473,6 +473,9 @@ struct wl1271 {
 	/* in dBm */
 	int power_level;
 
+	int rssi_thold;
+	int last_rssi_event;
+
 	struct wl1271_stats stats;
 	struct wl1271_debugfs debugfs;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.c b/drivers/net/wireless/wl12xx/wl1271_acx.c
index 621c946..1a6b2ec 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.c
@@ -1165,6 +1165,7 @@ out:
 	kfree(acx);
 	return ret;
 }
+
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid)
 {
 	struct wl1271_acx_keep_alive_config *acx = NULL;
@@ -1194,3 +1195,73 @@ out:
 	kfree(acx);
 	return ret;
 }
+
+int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
+				s16 thold, u8 hyst)
+{
+	struct wl1271_acx_rssi_snr_trigger *acx = NULL;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx rssi snr trigger");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wl->last_rssi_event = -1;
+
+	acx->pacing = cpu_to_le16(wl->conf.roam_trigger.trigger_pacing);
+	acx->metric = WL1271_ACX_TRIG_METRIC_RSSI_BEACON;
+	acx->type = WL1271_ACX_TRIG_TYPE_EDGE;
+	if (enable)
+		acx->enable = WL1271_ACX_TRIG_ENABLE;
+	else
+		acx->enable = WL1271_ACX_TRIG_DISABLE;
+
+	acx->index = WL1271_ACX_TRIG_IDX_RSSI;
+	acx->dir = WL1271_ACX_TRIG_DIR_BIDIR;
+	acx->threshold = cpu_to_le16(thold);
+	acx->hysteresis = hyst;
+
+	ret = wl1271_cmd_configure(wl, ACX_RSSI_SNR_TRIGGER, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx rssi snr trigger setting failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl)
+{
+	struct wl1271_acx_rssi_snr_avg_weights *acx = NULL;
+	struct conf_roam_trigger_settings *c = &wl->conf.roam_trigger;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_ACX, "acx rssi snr avg weights");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->rssi_beacon = c->avg_weight_rssi_beacon;
+	acx->rssi_data = c->avg_weight_rssi_data;
+	acx->snr_beacon = c->avg_weight_snr_beacon;
+	acx->snr_data = c->avg_weight_snr_data;
+
+	ret = wl1271_cmd_configure(wl, ACX_RSSI_SNR_WEIGHTS, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1271_warning("acx rssi snr trigger weights failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_acx.h b/drivers/net/wireless/wl12xx/wl1271_acx.h
index 15cc561..420e7e2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1271_acx.h
@@ -943,6 +943,57 @@ struct wl1271_acx_keep_alive_config {
 } __attribute__ ((packed));
 
 enum {
+	WL1271_ACX_TRIG_TYPE_LEVEL = 0,
+	WL1271_ACX_TRIG_TYPE_EDGE,
+};
+
+enum {
+	WL1271_ACX_TRIG_DIR_LOW = 0,
+	WL1271_ACX_TRIG_DIR_HIGH,
+	WL1271_ACX_TRIG_DIR_BIDIR,
+};
+
+enum {
+	WL1271_ACX_TRIG_ENABLE = 1,
+	WL1271_ACX_TRIG_DISABLE,
+};
+
+enum {
+	WL1271_ACX_TRIG_METRIC_RSSI_BEACON = 0,
+	WL1271_ACX_TRIG_METRIC_RSSI_DATA,
+	WL1271_ACX_TRIG_METRIC_SNR_BEACON,
+	WL1271_ACX_TRIG_METRIC_SNR_DATA,
+};
+
+enum {
+	WL1271_ACX_TRIG_IDX_RSSI = 0,
+	WL1271_ACX_TRIG_COUNT = 8,
+};
+
+struct wl1271_acx_rssi_snr_trigger {
+	struct acx_header header;
+
+	__le16 threshold;
+	__le16 pacing; /* 0 - 60000 ms */
+	u8 metric;
+	u8 type;
+	u8 dir;
+	u8 hysteresis;
+	u8 index;
+	u8 enable;
+	u8 padding[2];
+};
+
+struct wl1271_acx_rssi_snr_avg_weights {
+	struct acx_header header;
+
+	u8 rssi_beacon;
+	u8 rssi_data;
+	u8 snr_beacon;
+	u8 snr_data;
+};
+
+enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
 	ACX_SLOT                    = 0x0004,
@@ -990,7 +1041,7 @@ enum {
 	ACX_FRAG_CFG                = 0x004F,
 	ACX_BET_ENABLE              = 0x0050,
 	ACX_RSSI_SNR_TRIGGER        = 0x0051,
-	ACX_RSSI_SNR_WEIGHTS        = 0x0051,
+	ACX_RSSI_SNR_WEIGHTS        = 0x0052,
 	ACX_KEEP_ALIVE_MODE         = 0x0053,
 	ACX_SET_KEEP_ALIVE_CONFIG   = 0x0054,
 	ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
@@ -1060,5 +1111,8 @@ int wl1271_acx_arp_ip_filter(struct wl1271 *wl, bool enable, u8 *address,
 int wl1271_acx_pm_config(struct wl1271 *wl);
 int wl1271_acx_keep_alive_mode(struct wl1271 *wl, bool enable);
 int wl1271_acx_keep_alive_config(struct wl1271 *wl, u8 index, u8 tpl_valid);
+int wl1271_acx_rssi_snr_trigger(struct wl1271 *wl, bool enable,
+				s16 thold, u8 hyst);
+int wl1271_acx_rssi_snr_avg_weights(struct wl1271 *wl);
 
 #endif /* __WL1271_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 7acef88..f16d15b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -412,7 +412,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		SCAN_COMPLETE_EVENT_ID |
 		PS_REPORT_EVENT_ID |
 		JOIN_EVENT_COMPLETE_ID |
-		DISCONNECT_EVENT_COMPLETE_ID;
+		DISCONNECT_EVENT_COMPLETE_ID |
+		RSSI_SNR_TRIGGER_0_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1271_conf.h b/drivers/net/wireless/wl12xx/wl1271_conf.h
index d76ae03..c44307c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_conf.h
+++ b/drivers/net/wireless/wl12xx/wl1271_conf.h
@@ -756,65 +756,6 @@ enum {
 	CONF_TRIG_EVENT_DIR_BIDIR
 };
 
-
-struct conf_sig_trigger {
-	/*
-	 * The RSSI / SNR threshold value.
-	 *
-	 * FIXME: what is the range?
-	 */
-	s16 threshold;
-
-	/*
-	 * Minimum delay between two trigger events for this trigger in ms.
-	 *
-	 * Range: 0 - 60000
-	 */
-	u16 pacing;
-
-	/*
-	 * The measurement data source for this trigger.
-	 *
-	 * Range: CONF_TRIG_METRIC_*
-	 */
-	u8 metric;
-
-	/*
-	 * The trigger type of this trigger.
-	 *
-	 * Range: CONF_TRIG_EVENT_TYPE_*
-	 */
-	u8 type;
-
-	/*
-	 * The direction of the trigger.
-	 *
-	 * Range: CONF_TRIG_EVENT_DIR_*
-	 */
-	u8 direction;
-
-	/*
-	 * Hysteresis range of the trigger around the threshold (in dB)
-	 *
-	 * Range: u8
-	 */
-	u8 hysteresis;
-
-	/*
-	 * Index of the trigger rule.
-	 *
-	 * Range: 0 - CONF_MAX_RSSI_SNR_TRIGGERS-1
-	 */
-	u8 index;
-
-	/*
-	 * Enable / disable this rule (to use for clearing rules.)
-	 *
-	 * Range: 1 - Enabled, 2 - Not enabled
-	 */
-	u8 enable;
-};
-
 struct conf_sig_weights {
 
 	/*
@@ -933,12 +874,6 @@ struct conf_conn_settings {
 	u8 ps_poll_threshold;
 
 	/*
-	 * Configuration of signal (rssi/snr) triggers.
-	 */
-	u8 sig_trigger_count;
-	struct conf_sig_trigger sig_trigger[CONF_MAX_RSSI_SNR_TRIGGERS];
-
-	/*
 	 * Configuration of signal average weights.
 	 */
 	struct conf_sig_weights sig_weights;
@@ -1045,6 +980,43 @@ struct conf_pm_config_settings {
 	bool host_fast_wakeup_support;
 };
 
+struct conf_roam_trigger_settings {
+	/*
+	 * The minimum interval between two trigger events.
+	 *
+	 * Range: 0 - 60000 ms
+	 */
+	u16 trigger_pacing;
+
+	/*
+	 * The weight for rssi/beacon average calculation
+	 *
+	 * Range: 0 - 255
+	 */
+	u8 avg_weight_rssi_beacon;
+
+	/*
+	 * The weight for rssi/data frame average calculation
+	 *
+	 * Range: 0 - 255
+	 */
+	u8 avg_weight_rssi_data;
+
+	/*
+	 * The weight for snr/beacon average calculation
+	 *
+	 * Range: 0 - 255
+	 */
+	u8 avg_weight_snr_beacon;
+
+	/*
+	 * The weight for snr/data frame average calculation
+	 *
+	 * Range: 0 - 255
+	 */
+	u8 avg_weight_snr_data;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1053,6 +1025,7 @@ struct conf_drv_settings {
 	struct conf_init_settings init;
 	struct conf_itrim_settings itrim;
 	struct conf_pm_config_settings pm_config;
+	struct conf_roam_trigger_settings roam_trigger;
 };
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index daacf17..cf37aa6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -125,6 +125,24 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 	return ret;
 }
 
+static void wl1271_event_rssi_trigger(struct wl1271 *wl,
+				      struct event_mailbox *mbox)
+{
+	enum nl80211_cqm_rssi_threshold_event event;
+	s8 metric = mbox->rssi_snr_trigger_metric[0];
+
+	wl1271_debug(DEBUG_EVENT, "RSSI trigger metric: %d", metric);
+
+	if (metric <= wl->rssi_thold)
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW;
+	else
+		event = NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH;
+
+	if (event != wl->last_rssi_event)
+		ieee80211_cqm_rssi_notify(wl->vif, event, GFP_KERNEL);
+	wl->last_rssi_event = event;
+}
+
 static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -173,6 +191,12 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
+	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "RSSI_SNR_TRIGGER_0_EVENT");
+		if (wl->vif)
+			wl1271_event_rssi_trigger(wl, mbox);
+	}
+
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index 278f920..5837100 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -38,6 +38,14 @@
  */
 
 enum {
+	RSSI_SNR_TRIGGER_0_EVENT_ID              = BIT(0),
+	RSSI_SNR_TRIGGER_1_EVENT_ID              = BIT(1),
+	RSSI_SNR_TRIGGER_2_EVENT_ID              = BIT(2),
+	RSSI_SNR_TRIGGER_3_EVENT_ID              = BIT(3),
+	RSSI_SNR_TRIGGER_4_EVENT_ID              = BIT(4),
+	RSSI_SNR_TRIGGER_5_EVENT_ID              = BIT(5),
+	RSSI_SNR_TRIGGER_6_EVENT_ID              = BIT(6),
+	RSSI_SNR_TRIGGER_7_EVENT_ID              = BIT(7),
 	MEASUREMENT_START_EVENT_ID		 = BIT(8),
 	MEASUREMENT_COMPLETE_EVENT_ID		 = BIT(9),
 	SCAN_COMPLETE_EVENT_ID			 = BIT(10),
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 9ab3368..b880382 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -352,6 +352,11 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
+	/* Configure rssi/snr averaging weights */
+	ret = wl1271_acx_rssi_snr_avg_weights(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
 	return 0;
 
  out_free_memmap:
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 5517141..283d5da 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -234,35 +234,6 @@ static struct conf_drv_settings default_conf = {
 		.broadcast_timeout           = 20000,
 		.rx_broadcast_in_ps          = 1,
 		.ps_poll_threshold           = 20,
-		.sig_trigger_count           = 2,
-		.sig_trigger = {
-			[0] = {
-				.threshold   = -75,
-				.pacing      = 500,
-				.metric      = CONF_TRIG_METRIC_RSSI_BEACON,
-				.type        = CONF_TRIG_EVENT_TYPE_EDGE,
-				.direction   = CONF_TRIG_EVENT_DIR_LOW,
-				.hysteresis  = 2,
-				.index       = 0,
-				.enable      = 1
-			},
-			[1] = {
-				.threshold   = -75,
-				.pacing      = 500,
-				.metric      = CONF_TRIG_METRIC_RSSI_BEACON,
-				.type        = CONF_TRIG_EVENT_TYPE_EDGE,
-				.direction   = CONF_TRIG_EVENT_DIR_HIGH,
-				.hysteresis  = 2,
-				.index       = 1,
-				.enable      = 1
-			}
-		},
-		.sig_weights = {
-			.rssi_bcn_avg_weight = 10,
-			.rssi_pkt_avg_weight = 10,
-			.snr_bcn_avg_weight  = 10,
-			.snr_pkt_avg_weight  = 10
-		},
 		.bet_enable                  = CONF_BET_MODE_ENABLE,
 		.bet_max_consecutive         = 10,
 		.psm_entry_retries           = 3,
@@ -281,6 +252,14 @@ static struct conf_drv_settings default_conf = {
 	.pm_config = {
 		.host_clk_settling_time = 5000,
 		.host_fast_wakeup_support = false
+	},
+	.roam_trigger = {
+		/* FIXME: due to firmware bug, must use value 1 for now */
+		.trigger_pacing               = 1,
+		.avg_weight_rssi_beacon       = 20,
+		.avg_weight_rssi_data         = 10,
+		.avg_weight_snr_beacon        = 20,
+		.avg_weight_snr_data          = 10
 	}
 };
 
@@ -1703,6 +1682,18 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		do_join = true;
 	}
 
+	if (changed & BSS_CHANGED_CQM) {
+		bool enable = false;
+		if (bss_conf->cqm_rssi_thold)
+			enable = true;
+		ret = wl1271_acx_rssi_snr_trigger(wl, enable,
+						  bss_conf->cqm_rssi_thold,
+						  bss_conf->cqm_rssi_hyst);
+		if (ret < 0)
+			goto out;
+		wl->rssi_thold = bss_conf->cqm_rssi_thold;
+	}
+
 	if ((changed & BSS_CHANGED_BSSID) &&
 	    /*
 	     * Now we know the correct bssid, so we send a new join command
@@ -2283,7 +2274,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		IEEE80211_HW_SUPPORTS_PS |
 		IEEE80211_HW_SUPPORTS_UAPSD |
 		IEEE80211_HW_HAS_RATE_CONTROL |
-		IEEE80211_HW_CONNECTION_MONITOR;
+		IEEE80211_HW_CONNECTION_MONITOR |
+		IEEE80211_HW_SUPPORTS_CQM_RSSI;
 
 	wl->hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 		BIT(NL80211_IFTYPE_ADHOC);
-- 
1.6.3.3

