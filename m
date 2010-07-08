Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40431 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab0GHOvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:51:14 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] wl1271: rewritten scanning code
Date: Thu,  8 Jul 2010 17:50:07 +0300
Message-Id: <1278600608-22411-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is a complete rewrite of the scanning code.  It now includes a
state machine to scan all four possible sets of channels independently:
2.4GHz active, 2.4GHz passive, 5GHz active and 5GHz passive.  The wl1271
firmware doesn't allow these sets to be mixed, so up to several scan commands
have to be issued.  This patch also allows scanning more than 24 channels per
set, by breaking the sets into smaller parts if needed (the firmware can scan
a maximum of 24 channels at a time).

Previously, the scanning code was erroneously scanning all channels possible
actively, not complying with the CRDA values.  This is also fixed with this
patch.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h       |   21 +--
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   11 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c  |  296 +++++++++++++++++-----------
 drivers/net/wireless/wl12xx/wl1271_scan.h  |   20 ++-
 5 files changed, 211 insertions(+), 141 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index cfdccdb..b7c2995 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -300,12 +300,10 @@ struct wl1271_rx_mem_pool_addr {
 
 struct wl1271_scan {
 	struct cfg80211_scan_request *req;
+	bool *scanned_ch;
 	u8 state;
 	u8 ssid[IW_ESSID_MAX_SIZE+1];
 	size_t ssid_len;
-	u8 active;
-	u8 high_prio;
-	u8 probe_requests;
 };
 
 struct wl1271_if_operations {
@@ -343,15 +341,14 @@ struct wl1271 {
 #define WL1271_FLAG_JOINED             (2)
 #define WL1271_FLAG_GPIO_POWER         (3)
 #define WL1271_FLAG_TX_QUEUE_STOPPED   (4)
-#define WL1271_FLAG_SCANNING           (5)
-#define WL1271_FLAG_IN_ELP             (6)
-#define WL1271_FLAG_PSM                (7)
-#define WL1271_FLAG_PSM_REQUESTED      (8)
-#define WL1271_FLAG_IRQ_PENDING        (9)
-#define WL1271_FLAG_IRQ_RUNNING       (10)
-#define WL1271_FLAG_IDLE              (11)
-#define WL1271_FLAG_IDLE_REQUESTED    (12)
-#define WL1271_FLAG_PSPOLL_FAILURE    (13)
+#define WL1271_FLAG_IN_ELP             (5)
+#define WL1271_FLAG_PSM                (6)
+#define WL1271_FLAG_PSM_REQUESTED      (7)
+#define WL1271_FLAG_IRQ_PENDING        (8)
+#define WL1271_FLAG_IRQ_RUNNING        (9)
+#define WL1271_FLAG_IDLE              (10)
+#define WL1271_FLAG_IDLE_REQUESTED    (11)
+#define WL1271_FLAG_PSPOLL_FAILURE    (12)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 3bdae89..25ce2cd 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -194,9 +194,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 			     mbox->scheduled_scan_status);
 
-		ret = wl1271_scan_complete(wl);
-		if (ret < 0)
-			return ret;
+		wl1271_scan_stm(wl);
 	}
 
 	/* disable dynamic PS when requested by the firmware */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index cdfcc05..d30de58 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -942,10 +942,13 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	if (wl->bss_type == BSS_TYPE_STA_BSS)
 		ieee80211_enable_dyn_ps(wl->vif);
 
-	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
+	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
 		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, true);
 		mutex_lock(&wl->mutex);
+		wl->scan.state = WL1271_SCAN_STATE_IDLE;
+		kfree(wl->scan.scanned_ch);
+		wl->scan.scanned_ch = NULL;
 	}
 
 	wl->state = WL1271_STATE_OFF;
@@ -1551,11 +1554,9 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	if (wl1271_11a_enabled())
-		ret = wl1271_scan(hw->priv, ssid, len, req,
-				  1, 0, WL1271_SCAN_BAND_DUAL, 3);
+		ret = wl1271_scan(hw->priv, ssid, len, req);
 	else
-		ret = wl1271_scan(hw->priv, ssid, len, req,
-				  1, 0, WL1271_SCAN_BAND_2_4_GHZ, 3);
+		ret = wl1271_scan(hw->priv, ssid, len, req);
 
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index eb9b4ec..567d759 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -28,103 +28,120 @@
 #include "wl1271_scan.h"
 #include "wl1271_acx.h"
 
-int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		struct cfg80211_scan_request *req, u8 active_scan,
-		u8 high_prio, u8 band, u8 probe_requests)
+static int wl1271_get_scan_channels(struct wl1271 *wl,
+				    struct cfg80211_scan_request *req,
+				    struct basic_scan_channel_params *channels,
+				    enum ieee80211_band band, bool passive)
 {
+	int i, j;
+	u32 flags;
 
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
+	for (i = 0, j = 0;
+	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
+	     i++) {
 
-	if (!active_scan)
-		scan_options |= WL1271_SCAN_OPT_PASSIVE;
-	if (high_prio)
-		scan_options |= WL1271_SCAN_OPT_PRIORITY_HIGH;
-	params->params.scan_options = cpu_to_le16(scan_options);
+		flags = req->channels[i]->flags;
 
-	params->params.num_probe_requests = probe_requests;
-	params->params.tx_rate = cpu_to_le32(rate);
-	params->params.tid_trigger = 0;
-	params->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
+		if (!wl->scan.scanned_ch[i] &&
+		    !(flags & IEEE80211_CHAN_DISABLED) &&
+		    ((!!(flags & IEEE80211_CHAN_PASSIVE_SCAN)) == passive) &&
+		    (req->channels[i]->band == band)) {
 
-	if (band == WL1271_SCAN_BAND_DUAL)
-		params->params.band = WL1271_SCAN_BAND_2_4_GHZ;
-	else
-		params->params.band = band;
+			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
+				     req->channels[i]->band,
+				     req->channels[i]->center_freq);
+			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
+				     req->channels[i]->hw_value,
+				     req->channels[i]->flags);
+			wl1271_debug(DEBUG_SCAN,
+				     "max_antenna_gain %d, max_power %d",
+				     req->channels[i]->max_antenna_gain,
+				     req->channels[i]->max_power);
+			wl1271_debug(DEBUG_SCAN, "beacon_found %d",
+				     req->channels[i]->beacon_found);
 
-	for (i = 0, j = 0; i < n_ch && i < WL1271_SCAN_MAX_CHANNELS; i++) {
-		if (!(channels[i].flags & IEEE80211_CHAN_DISABLED)) {
-			params->channels[j].min_duration =
+			channels[j].min_duration = 
 				cpu_to_le32(WL1271_SCAN_CHAN_MIN_DURATION);
-			params->channels[j].max_duration =
+			channels[j].max_duration =
 				cpu_to_le32(WL1271_SCAN_CHAN_MAX_DURATION);
-			memset(&params->channels[j].bssid_lsb, 0xff, 4);
-			memset(&params->channels[j].bssid_msb, 0xff, 2);
-			params->channels[j].early_termination = 0;
-			params->channels[j].tx_power_att =
-				WL1271_SCAN_CURRENT_TX_PWR;
-			params->channels[j].channel = channels[i].hw_value;
+			channels[j].early_termination = 0;
+			channels[j].tx_power_att = WL1271_SCAN_CURRENT_TX_PWR;
+			channels[j].channel = req->channels[i]->hw_value;
+
+			memset(&channels[j].bssid_lsb, 0xff, 4);
+			memset(&channels[j].bssid_msb, 0xff, 2);
+
+			/* Mark the channels we already used */
+			wl->scan.scanned_ch[i] = true;
+
 			j++;
 		}
 	}
 
-	params->params.num_channels = j;
+	return j;
+}
 
-	if (ssid_len && ssid) {
-		params->params.ssid_len = ssid_len;
-		memcpy(params->params.ssid, ssid, ssid_len);
+#define WL1271_NOTHING_TO_SCAN 1
+
+static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
+			     bool passive, u32 basic_rate)
+{
+	struct wl1271_cmd_scan *cmd;
+	struct wl1271_cmd_trigger_scan_to *trigger;
+	int ret;
+	u16 scan_options = 0;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!cmd || !trigger) {
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	ret = wl1271_cmd_build_probe_req(wl, ssid, ssid_len,
-					 req->ie, req->ie_len, ieee_band);
-	if (ret < 0) {
-		wl1271_error("PROBE request template failed");
+	/* We always use high priority scans */
+	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
+	if(passive)
+		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+	cmd->params.scan_options = cpu_to_le16(scan_options);
+
+	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
+						    cmd->channels,
+						    band, passive);
+	if (cmd->params.n_ch == 0) {
+		ret = WL1271_NOTHING_TO_SCAN;
 		goto out;
 	}
 
-	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
-	if (!trigger) {
-		ret = -ENOMEM;
+	cmd->params.tx_rate = cpu_to_le32(basic_rate);
+	cmd->params.rx_config_options = cpu_to_le32(CFG_RX_ALL_GOOD);
+	cmd->params.rx_filter_options =
+		cpu_to_le32(CFG_RX_PRSP_EN | CFG_RX_MGMT_EN | CFG_RX_BCN_EN);
+
+	cmd->params.n_probe_reqs = WL1271_SCAN_PROBE_REQS;
+	cmd->params.tx_rate = cpu_to_le32(basic_rate);
+	cmd->params.tid_trigger = 0;
+	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
+
+	if (band == IEEE80211_BAND_2GHZ)
+		cmd->params.band = WL1271_SCAN_BAND_2_4_GHZ;
+	else
+		cmd->params.band = WL1271_SCAN_BAND_5_GHZ;
+
+	if (wl->scan.ssid_len && wl->scan.ssid) {
+		cmd->params.ssid_len = wl->scan.ssid_len;
+		memcpy(cmd->params.ssid, wl->scan.ssid, wl->scan.ssid_len);
+	}
+
+	ret = wl1271_cmd_build_probe_req(wl, wl->scan.ssid, wl->scan.ssid_len,
+					 wl->scan.req->ie, wl->scan.req->ie_len,
+					 band);
+	if (ret < 0) {
+		wl1271_error("PROBE request template failed");
 		goto out;
 	}
 
 	/* disable the timeout */
 	trigger->timeout = 0;
-
 	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
 			      sizeof(*trigger), 0);
 	if (ret < 0) {
@@ -132,60 +149,109 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		goto out;
 	}
 
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
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", cmd, sizeof(*cmd));
 
-	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
+	ret = wl1271_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("SCAN failed");
-		clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
 		goto out;
 	}
 
 out:
-	kfree(params);
+	kfree(cmd);
 	kfree(trigger);
 	return ret;
 }
 
-int wl1271_scan_complete(struct wl1271 *wl)
+void wl1271_scan_stm(struct wl1271 *wl)
 {
-	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
-		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
-			/* 2.4 GHz band scanned, scan 5 GHz band, pretend to
-			 * the wl1271_scan function that we are not scanning
-			 * as it checks that.
-			 */
-			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
-			/* FIXME: ie missing! */
-			wl1271_scan(wl, wl->scan.ssid, wl->scan.ssid_len,
-				    wl->scan.req,
-				    wl->scan.active,
-				    wl->scan.high_prio,
-				    WL1271_SCAN_BAND_5_GHZ,
-				    wl->scan.probe_requests);
-		} else {
-			mutex_unlock(&wl->mutex);
-			ieee80211_scan_completed(wl->hw, false);
-			mutex_lock(&wl->mutex);
-			clear_bit(WL1271_FLAG_SCANNING, &wl->flags);
+	int ret;
+
+	switch (wl->scan.state) {
+	case WL1271_SCAN_STATE_IDLE:
+		break;
+
+	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
+		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, false,
+				       wl->conf.tx.basic_rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
+			wl1271_scan_stm(wl);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
+		ret = wl1271_scan_send(wl, IEEE80211_BAND_2GHZ, true,
+				       wl->conf.tx.basic_rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			if (wl1271_11a_enabled())
+				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
+			else
+				wl->scan.state = WL1271_SCAN_STATE_DONE;
+			wl1271_scan_stm(wl);
 		}
+
+		break;
+
+	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
+		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, false,
+				       wl->conf.tx.basic_rate_5);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
+			wl1271_scan_stm(wl);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
+		ret = wl1271_scan_send(wl, IEEE80211_BAND_5GHZ, true,
+				       wl->conf.tx.basic_rate_5);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_DONE;
+			wl1271_scan_stm(wl);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_DONE:
+		mutex_unlock(&wl->mutex);
+		ieee80211_scan_completed(wl->hw, false);
+		mutex_lock(&wl->mutex);
+
+		kfree(wl->scan.scanned_ch);
+		wl->scan.scanned_ch = NULL;
+
+		wl->scan.state = WL1271_SCAN_STATE_IDLE;
+		break;
+
+	default:
+		wl1271_error("invalid scan state");
+		break;
 	}
+}
+
+int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
+		struct cfg80211_scan_request *req)
+{
+	if (wl->scan.state != WL1271_SCAN_STATE_IDLE)
+		return -EBUSY;
+
+	wl->scan.state = WL1271_SCAN_STATE_2GHZ_ACTIVE;
+
+	if (ssid_len && ssid) {
+		wl->scan.ssid_len = ssid_len;
+		memcpy(wl->scan.ssid, ssid, ssid_len);
+	} else {
+		wl->scan.ssid_len = 0;
+	}
+
+	wl->scan.req = req;
+
+	wl->scan.scanned_ch = kzalloc(req->n_channels *
+				      sizeof(*wl->scan.scanned_ch),
+				      GFP_KERNEL);
+	wl1271_scan_stm(wl);
+
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h b/drivers/net/wireless/wl12xx/wl1271_scan.h
index 0002e81..b0e36e3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.h
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.h
@@ -27,12 +27,11 @@
 #include "wl1271.h"
 
 int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
-		struct cfg80211_scan_request *req, u8 active_scan,
-		u8 high_prio, u8 band, u8 probe_requests);
+		struct cfg80211_scan_request *req);
 int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ssid, size_t ssid_len,
 				const u8 *ie, size_t ie_len, u8 band);
-int wl1271_scan_complete(struct wl1271 *wl);
+void wl1271_scan_stm(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
 #define WL1271_SCAN_DEFAULT_TAG        1
@@ -44,7 +43,16 @@ int wl1271_scan_complete(struct wl1271 *wl);
 #define WL1271_SCAN_CHAN_MAX_DURATION  60000  /* TU */
 #define WL1271_SCAN_BAND_2_4_GHZ 0
 #define WL1271_SCAN_BAND_5_GHZ 1
-#define WL1271_SCAN_BAND_DUAL 2
+#define WL1271_SCAN_PROBE_REQS 3
+
+enum {
+	WL1271_SCAN_STATE_IDLE,
+	WL1271_SCAN_STATE_2GHZ_ACTIVE,
+	WL1271_SCAN_STATE_2GHZ_PASSIVE,
+	WL1271_SCAN_STATE_5GHZ_ACTIVE,
+	WL1271_SCAN_STATE_5GHZ_PASSIVE,
+	WL1271_SCAN_STATE_DONE
+};
 
 struct basic_scan_params {
 	__le32 rx_config_options;
@@ -52,10 +60,10 @@ struct basic_scan_params {
 	/* Scan option flags (WL1271_SCAN_OPT_*) */
 	__le16 scan_options;
 	/* Number of scan channels in the list (maximum 30) */
-	u8 num_channels;
+	u8 n_ch;
 	/* This field indicates the number of probe requests to send
 	   per channel for an active scan */
-	u8 num_probe_requests;
+	u8 n_probe_reqs;
 	/* Rate bit field for sending the probes */
 	__le32 tx_rate;
 	u8 tid_trigger;
-- 
1.6.3.3

