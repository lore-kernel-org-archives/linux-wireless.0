Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40404 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab0GHOux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:53 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/13] wl1271: moved scan operations to a separate file
Date: Thu,  8 Jul 2010 17:50:06 +0300
Message-Id: <1278600608-22411-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scanning code is going to get a bit more complex, with proper support for
active/passive scans together with 2.4GHz and 5GHz.  In the future, also a
new type of scan (periodic scan) will be added.  When all this is
implemented, the code is going to be much more complex, so we'd better
separate it into a separate file.

This patch doesn't have any impact on functionality.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/Makefile       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c   |  136 --------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h   |   68 ----------
 drivers/net/wireless/wl12xx/wl1271_event.c |   36 +-----
 drivers/net/wireless/wl12xx/wl1271_main.c  |    9 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c  |  191 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_scan.h  |  101 +++++++++++++++
 7 files changed, 303 insertions(+), 240 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.c
 create mode 100644 drivers/net/wireless/wl12xx/wl1271_scan.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 27ddd2b..078b439 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
 wl1271-objs		= wl1271_main.o  wl1271_cmd.o wl1271_io.o \
 			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
-			  wl1271_init.o  wl1271_debugfs.o
+			  wl1271_init.o  wl1271_debugfs.o wl1271_scan.o
 
 wl1271-$(CONFIG_NL80211_TESTMODE)	+= wl1271_testmode.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 23c7598..ce503dd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -463,142 +463,6 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		    struct cfg80211_scan_request *req, u8 active_scan,
-		    u8 high_prio, u8 band, u8 probe_requests)
-{
-
-	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
-	struct wl1271_cmd_scan *params = NULL;
-	struct ieee80211_channel *channels;
-	u32 rate;
-	int i, j, n_ch, ret;
-	u16 scan_options = 0;
-	u8 ieee_band;
-
-	if (band == WL1271_SCAN_BAND_2_4_GHZ) {
-		ieee_band = IEEE80211_BAND_2GHZ;
-		rate = wl->conf.tx.basic_rate;
-	} else if (band == WL1271_SCAN_BAND_DUAL && wl1271_11a_enabled()) {
-		ieee_band = IEEE80211_BAND_2GHZ;
-		rate = wl->conf.tx.basic_rate;
-	} else if (band == WL1271_SCAN_BAND_5_GHZ && wl1271_11a_enabled()) {
-		ieee_band = IEEE80211_BAND_5GHZ;
-		rate = wl->conf.tx.basic_rate_5;
-	} else
-		return -EINVAL;
-
-	if (wl->hw->wiphy->bands[ieee_band]->channels == NULL)
-		return -EINVAL;
-
-	channels = wl->hw->wiphy->bands[ieee_band]->channels;
-	n_ch = wl->hw->wiphy->bands[ieee_band]->n_channels;
-
-	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags))
-		return -EINVAL;
-
-	params = kzalloc(sizeof(*params), GFP_KERNEL);
-	if (!params)
-		return -ENOMEM;
-
-	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
-	params->params.rx_filter_options =
-		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
-
-	if (!active_scan)
-		scan_options |= WL1271_SCAN_OPT_PASSIVE;
-	if (high_prio)
-		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
-	params->params.scan_options = cpu_to_le16(scan_options);
-
-	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le32(rate);
-	params->params.tid_trigger = 0;
-	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
-
-	if (band == WL1271_SCAN_BAND_DUAL)
-		params->params.band = WL1271_SCAN_BAND_2_4_GHZ;
-	else
-		params->params.band = band;
-
-	for (i = 0, j = 0; i < n_ch && i < WL1271_SCAN_MAX_CHANNELS; i++) {
-		if (!(channels[i].flags & IEEE80211_CHAN_DISABLED)) {
-			params->channels[j].min_duration =
-				cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
-			params->channels[j].max_duration =
-				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
-			memset(&params->channels[j].bssid_lsb, 0xff, 4);
-			memset(&params->channels[j].bssid_msb, 0xff, 2);
-			params->channels[j].early_termination = 0;
-			params->channels[j].tx_power_att =
-				WL1271_SCAN_CURRENT_TX_PWR;
-			params->channels[j].channel = channels[i].hw_value;
-			j++;
-		}
-	}
-
-	params->params.num_channels = j;
-
-	if (ssid_len && ssid) {
-		params->params.ssid_len = ssid_len;
-		memcpy(params->params.ssid, ssid, ssid_len);
-	}
-
-	ret = wl1271_cmd_build_probe_req(wl, ssid, ssid_len,
-					 req->ie, req->ie_len, ieee_band);
-	if (ret < 0) {
-		wl1271_error("PROBE request template failed");
-		goto out;
-	}
-
-	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
-	if (!trigger) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	/* disable the timeout */
-	trigger->timeout = 0;
-
-	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
-			      sizeof(*trigger), 0);
-	if (ret < 0) {
-		wl1271_error("trigger scan to failed for hw scan");
-		goto out;
-	}
-
-	wl1271_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
-
-	set_bit(WL1271_FLAG_SCANNING, &wl->flags);
-	if (wl1271_11a_enabled()) {
-		wl->scan.state = band;
-		if (band == WL1271_SCAN_BAND_DUAL) {
-			wl->scan.active = active_scan;
-			wl->scan.high_prio = high_prio;
-			wl->scan.probe_requests = probe_requests;
-			if (ssid_len && ssid) {
-				wl->scan.ssid_len = ssid_len;
-				memcpy(wl->scan.ssid, ssid, ssid_len);
-			} else
-				wl->scan.ssid_len = 0;
-			wl->scan.req = req;
-		} else
-			wl->scan.req = NULL;
-	}
-
-	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
-	if (ret < 0) {
-		wl1271_error("SCAN failed");
-		clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
-		goto out;
-	}
-
-out:
-	kfree(params);
-	kfree(trigger);
-	return ret;
-}
-
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 68001df..34cd013 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -41,9 +41,6 @@ int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
-int wl1271_cmd_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		    struct cfg80211_scan_request *req, u8 active_scan,
-		    u8 high_prio, u8 band, u8 probe_requests);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
@@ -350,71 +347,6 @@ struct wl1271_cmd_set_keys {
 	__le32 ac_seq_num32[NUM_ACCESS_CATEGORIES_COPY];
 } __attribute__ ((packed));
 
-
-#define WL1271_SCAN_MAX_CHANNELS       24
-#define WL1271_SCAN_DEFAULT_TAG        1
-#define WL1271_SCAN_CURRENT_TX_PWR     0
-#define WL1271_SCAN_OPT_ACTIVE         0
-#define WL1271_SCAN_OPT_PASSIVE	       1
-#define WL1271_SCAN_OPT_PRIORITY_HIGH  4
-#define WL1271_SCAN_CHAN_MIN_DURATION  30000  /* TU */
-#define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
-#define WL1271_SCAN_BAND_2_4_GHZ 0
-#define WL1271_SCAN_BAND_5_GHZ 1
-#define WL1271_SCAN_BAND_DUAL 2
-
-struct basic_scan_params {
-	__le32 rx_config_options;
-	__le32 rx_filter_options;
-	/* Scan option flags (WL1271_SCAN_OPT_*) */
-	__le16 scan_options;
-	/* Number of scan channels in the list (maximum 30) */
-	u8 num_channels;
-	/* This field indicates the number of probe requests to send
-	   per channel for an active scan */
-	u8 num_probe_requests;
-	/* Rate bit field for sending the probes */
-	__le32 tx_rate;
-	u8 tid_trigger;
-	u8 ssid_len;
-	/* in order to align */
-	u8 padding1[2];
-	u8 ssid[IW_ESSID_MAX_SIZE];
-	/* Band to scan */
-	u8 band;
-	u8 use_ssid_list;
-	u8 scan_tag;
-	u8 padding2;
-} __attribute__ ((packed));
-
-struct basic_scan_channel_params {
-	/* Duration in TU to wait for frames on a channel for active scan */
-	__le32 min_duration;
-	__le32 max_duration;
-	__le32 bssid_lsb;
-	__le16 bssid_msb;
-	u8 early_termination;
-	u8 tx_power_att;
-	u8 channel;
-	/* FW internal use only! */
-	u8 dfs_candidate;
-	u8 activity_detected;
-	u8 pad;
-} __attribute__ ((packed));
-
-struct wl1271_cmd_scan {
-	struct wl1271_cmd_header header;
-
-	struct basic_scan_params params;
-	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
-} __attribute__ ((packed));
-
-struct wl1271_cmd_trigger_scan_to {
-	struct wl1271_cmd_header header;
-
-	__le32 timeout;
-} __attribute__ ((packed));
-
 struct wl1271_cmd_test_header {
 	u8 id;
 	u8 padding[3];
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 2d60d22..3bdae89 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -26,6 +26,7 @@
 #include "wl1271_io.h"
 #include "wl1271_event.h"
 #include "wl1271_ps.h"
+#include "wl1271_scan.h"
 #include "wl12xx_80211.h"
 
 void wl1271_pspoll_work(struct work_struct *work)
@@ -85,36 +86,6 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl)
 	 */
 }
 
-static int wl1271_event_scan_complete(struct wl1271 *wl,
-				      struct event_mailbox *mbox)
-{
-	wl1271_debug(DEBUG_EVENT, "status: 0x%x",
-		     mbox->scheduled_scan_status);
-
-	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
-		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
-			/* 2.4 GHz band scanned, scan 5 GHz band, pretend
-			 * to the wl1271_cmd_scan function that we are not
-			 * scanning as it checks that.
-			 */
-			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
-			/* FIXME: ie missing! */
-			wl1271_cmd_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
-					wl->scan.req,
-					wl->scan.active,
-					wl->scan.high_prio,
-					WL1271_SCAN_BAND_5_GHZ,
-					wl->scan.probe_requests);
-		} else {
-			mutex_unlock(&wl->mutex);
-			ieee80211_scan_completed(wl->hw, false);
-			mutex_lock(&wl->mutex);
-			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
-		}
-	}
-	return 0;
-}
-
 static int wl1271_event_ps_report(struct wl1271 *wl,
 				  struct event_mailbox *mbox,
 				  bool *beacon_loss)
@@ -220,7 +191,10 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	wl1271_debug(DEBUG_EVENT, "vector: 0x%x", vector);
 
 	if (vector & SCAN_COMPLETE_EVENT_ID) {
-		ret = wl1271_event_scan_complete(wl, mbox);
+		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
+			     mbox->scheduled_scan_status);
+
+		ret = wl1271_scan_complete(wl);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 70c6b0d..cdfcc05 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -44,6 +44,7 @@
 #include "wl1271_cmd.h"
 #include "wl1271_boot.h"
 #include "wl1271_testmode.h"
+#include "wl1271_scan.h"
 
 #define WL1271_BOOT_RETRIES 3
 
@@ -1550,11 +1551,11 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	if (wl1271_11a_enabled())
-		ret = wl1271_cmd_scan(hw->priv, ssid, len, req,
-				      1, 0, WL1271_SCAN_BAND_DUAL, 3);
+		ret = wl1271_scan(hw->priv, ssid, len, req,
+				  1, 0, WL1271_SCAN_BAND_DUAL, 3);
 	else
-		ret = wl1271_cmd_scan(hw->priv, ssid, len, req,
-				      1, 0, WL1271_SCAN_BAND_2_4_GHZ, 3);
+		ret = wl1271_scan(hw->priv, ssid, len, req,
+				  1, 0, WL1271_SCAN_BAND_2_4_GHZ, 3);
 
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
new file mode 100644
index 0000000..eb9b4ec
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -0,0 +1,191 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include <linux/ieee80211.h>
+
+#include "wl1271.h"
+#include "wl1271_cmd.h"
+#include "wl1271_scan.h"
+#include "wl1271_acx.h"
+
+int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+		struct cfg80211_scan_request *req, u8 active_scan,
+		u8 high_prio, u8 band, u8 probe_requests)
+{
+
+	struct wl1271_cmd_trigger_scan_to *trigger = NULL;
+	struct wl1271_cmd_scan *params = NULL;
+	struct ieee80211_channel *channels;
+	u32 rate;
+	int i, j, n_ch, ret;
+	u16 scan_options = 0;
+	u8 ieee_band;
+
+	if (band == WL1271_SCAN_BAND_2_4_GHZ) {
+		ieee_band = IEEE80211_BAND_2GHZ;
+		rate = wl->conf.tx.basic_rate;
+	} else if (band == WL1271_SCAN_BAND_DUAL && wl1271_11a_enabled()) {
+		ieee_band = IEEE80211_BAND_2GHZ;
+		rate = wl->conf.tx.basic_rate;
+	} else if (band == WL1271_SCAN_BAND_5_GHZ && wl1271_11a_enabled()) {
+		ieee_band = IEEE80211_BAND_5GHZ;
+		rate = wl->conf.tx.basic_rate_5;
+	} else
+		return -EINVAL;
+
+	if (wl->hw->wiphy->bands[ieee_band]->channels == NULL)
+		return -EINVAL;
+
+	channels = wl->hw->wiphy->bands[ieee_band]->channels;
+	n_ch = wl->hw->wiphy->bands[ieee_band]->n_channels;
+
+	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags))
+		return -EINVAL;
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	params->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
+	params->params.rx_filter_options =
+		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
+
+	if (!active_scan)
+		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+	if (high_prio)
+		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
+	params->params.scan_options = cpu_to_le16(scan_options);
+
+	params->params.num_probe_requests = probe_requests;
+	params->params.tx_rate = cpu_to_le32(rate);
+	params->params.tid_trigger = 0;
+	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
+
+	if (band == WL1271_SCAN_BAND_DUAL)
+		params->params.band = WL1271_SCAN_BAND_2_4_GHZ;
+	else
+		params->params.band = band;
+
+	for (i = 0, j = 0; i < n_ch && i < WL1271_SCAN_MAX_CHANNELS; i++) {
+		if (!(channels[i].flags & IEEE80211_CHAN_DISABLED)) {
+			params->channels[j].min_duration =
+				cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
+			params->channels[j].max_duration =
+				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
+			memset(&params->channels[j].bssid_lsb, 0xff, 4);
+			memset(&params->channels[j].bssid_msb, 0xff, 2);
+			params->channels[j].early_termination = 0;
+			params->channels[j].tx_power_att =
+				WL1271_SCAN_CURRENT_TX_PWR;
+			params->channels[j].channel = channels[i].hw_value;
+			j++;
+		}
+	}
+
+	params->params.num_channels = j;
+
+	if (ssid_len && ssid) {
+		params->params.ssid_len = ssid_len;
+		memcpy(params->params.ssid, ssid, ssid_len);
+	}
+
+	ret = wl1271_cmd_build_probe_req(wl, ssid, ssid_len,
+					 req->ie, req->ie_len, ieee_band);
+	if (ret < 0) {
+		wl1271_error("PROBE request template failed");
+		goto out;
+	}
+
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!trigger) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* disable the timeout */
+	trigger->timeout = 0;
+
+	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+			      sizeof(*trigger), 0);
+	if (ret < 0) {
+		wl1271_error("trigger scan to failed for hw scan");
+		goto out;
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", params, sizeof(*params));
+
+	set_bit(WL1271_FLAG_SCANNING, &wl->flags);
+	if (wl1271_11a_enabled()) {
+		wl->scan.state = band;
+		if (band == WL1271_SCAN_BAND_DUAL) {
+			wl->scan.active = active_scan;
+			wl->scan.high_prio = high_prio;
+			wl->scan.probe_requests = probe_requests;
+			if (ssid_len && ssid) {
+				wl->scan.ssid_len = ssid_len;
+				memcpy(wl->scan.ssid, ssid, ssid_len);
+			} else
+				wl->scan.ssid_len = 0;
+			wl->scan.req = req;
+		} else
+			wl->scan.req = NULL;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
+	if (ret < 0) {
+		wl1271_error("SCAN failed");
+		clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
+		goto out;
+	}
+
+out:
+	kfree(params);
+	kfree(trigger);
+	return ret;
+}
+
+int wl1271_scan_complete(struct wl1271 *wl)
+{
+	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
+		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
+			/* 2.4 GHz band scanned, scan 5 GHz band, pretend to
+			 * the wl1271_scan function that we are not scanning
+			 * as it checks that.
+			 */
+			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
+			/* FIXME: ie missing! */
+			wl1271_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
+				    wl->scan.req,
+				    wl->scan.active,
+				    wl->scan.high_prio,
+				    WL1271_SCAN_BAND_5_GHZ,
+				    wl->scan.probe_requests);
+		} else {
+			mutex_unlock(&wl->mutex);
+			ieee80211_scan_completed(wl->hw, false);
+			mutex_lock(&wl->mutex);
+			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
+		}
+	}
+	return 0;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h b/drivers/net/wireless/wl12xx/wl1271_scan.h
new file mode 100644
index 0000000..0002e81
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.h
@@ -0,0 +1,101 @@
+/*
+ * This file is part of wl1271
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL1271_SCAN_H__
+#define __WL1271_SCAN_H__
+
+#include "wl1271.h"
+
+int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+		struct cfg80211_scan_request *req, u8 active_scan,
+		u8 high_prio, u8 band, u8 probe_requests);
+int wl1271_scan_build_probe_req(struct wl1271 *wl,
+				const u8 *ssid, size_t ssid_len,
+				const u8 *ie, size_t ie_len, u8 band);
+int wl1271_scan_complete(struct wl1271 *wl);
+
+#define WL1271_SCAN_MAX_CHANNELS       24
+#define WL1271_SCAN_DEFAULT_TAG        1
+#define WL1271_SCAN_CURRENT_TX_PWR     0
+#define WL1271_SCAN_OPT_ACTIVE         0
+#define WL1271_SCAN_OPT_PASSIVE	       1
+#define WL1271_SCAN_OPT_PRIORITY_HIGH  4
+#define WL1271_SCAN_CHAN_MIN_DURATION  30000  /* TU */
+#define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
+#define WL1271_SCAN_BAND_2_4_GHZ 0
+#define WL1271_SCAN_BAND_5_GHZ 1
+#define WL1271_SCAN_BAND_DUAL 2
+
+struct basic_scan_params {
+	__le32 rx_config_options;
+	__le32 rx_filter_options;
+	/* Scan option flags (WL1271_SCAN_OPT_*) */
+	__le16 scan_options;
+	/* Number of scan channels in the list (maximum 30) */
+	u8 num_channels;
+	/* This field indicates the number of probe requests to send
+	   per channel for an active scan */
+	u8 num_probe_requests;
+	/* Rate bit field for sending the probes */
+	__le32 tx_rate;
+	u8 tid_trigger;
+	u8 ssid_len;
+	/* in order to align */
+	u8 padding1[2];
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	/* Band to scan */
+	u8 band;
+	u8 use_ssid_list;
+	u8 scan_tag;
+	u8 padding2;
+} __attribute__ ((packed));
+
+struct basic_scan_channel_params {
+	/* Duration in TU to wait for frames on a channel for active scan */
+	__le32 min_duration;
+	__le32 max_duration;
+	__le32 bssid_lsb;
+	__le16 bssid_msb;
+	u8 early_termination;
+	u8 tx_power_att;
+	u8 channel;
+	/* FW internal use only! */
+	u8 dfs_candidate;
+	u8 activity_detected;
+	u8 pad;
+} __attribute__ ((packed));
+
+struct wl1271_cmd_scan {
+	struct wl1271_cmd_header header;
+
+	struct basic_scan_params params;
+	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
+} __attribute__ ((packed));
+
+struct wl1271_cmd_trigger_scan_to {
+	struct wl1271_cmd_header header;
+
+	__le32 timeout;
+} __attribute__ ((packed));
+
+#endif /* __WL1271_SCAN_H__ */
-- 
1.6.3.3

