Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1HIJNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:53 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:53 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/40] wl12xx: wl12xx-fw-3 - update scan cmd api
Date: Tue,  9 Aug 2011 12:13:24 +0300
Message-Id: <1312881233-9366-12-git-send-email-eliad@wizery.com> (sfid-20110809_111358_513309_4BC96229)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the scan command to use the new fw api.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/scan.c |    8 +++++++-
 drivers/net/wireless/wl12xx/scan.h |   25 ++++++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 78a9b23..b34034c 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -153,24 +153,28 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 	scan_options = WL1271_SCAN_OPT_PRIORITY_HIGH;
 
 	/* No SSIDs means that we have a forced passive scan */
 	if (passive || wl->scan.req->n_ssids == 0)
 		scan_options |= WL1271_SCAN_OPT_PASSIVE;
 
+	if (WARN_ON(wl->role_id == WL1271_INVALID_ROLE_ID)) {
+		ret = -EINVAL;
+		goto out;
+	}
+	cmd->params.role_id = wl->role_id;
 	cmd->params.scan_options = cpu_to_le16(scan_options);
 
 	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
 						    cmd->channels,
 						    band, passive);
 	if (cmd->params.n_ch == 0) {
 		ret = WL1271_NOTHING_TO_SCAN;
 		goto out;
 	}
 
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
-
 	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
 	cmd->params.tx_rate = cpu_to_le32(basic_rate);
 	cmd->params.tid_trigger = 0;
 	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
 
 	if (band == IEEE80211_BAND_2GHZ)
@@ -180,12 +184,14 @@ static int wl1271_scan_send(struct wl1271 *wl, enum ieee80211_band band,
 
 	if (wl->scan.ssid_len && wl->scan.ssid) {
 		cmd->params.ssid_len = wl->scan.ssid_len;
 		memcpy(cmd->params.ssid, wl->scan.ssid, wl->scan.ssid_len);
 	}
 
+	memcpy(cmd->addr, wl->mac_addr, ETH_ALEN);
+
 	ret = wl1271_cmd_build_probe_req(wl, wl->scan.ssid, wl->scan.ssid_len,
 					 wl->scan.req->ie, wl->scan.req->ie_len,
 					 band);
 	if (ret < 0) {
 		wl1271_error("PROBE request template failed");
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index d882e4d..65930a8 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -43,13 +43,16 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
 #define WL1271_SCAN_DEFAULT_TAG        1
 #define WL1271_SCAN_CURRENT_TX_PWR     0
 #define WL1271_SCAN_OPT_ACTIVE         0
 #define WL1271_SCAN_OPT_PASSIVE	       1
+#define WL1271_SCAN_OPT_TRIGGERED_SCAN 2
 #define WL1271_SCAN_OPT_PRIORITY_HIGH  4
+/* scan even if we fail to enter psm */
+#define WL1271_SCAN_OPT_FORCE          8
 #define WL1271_SCAN_BAND_2_4_GHZ 0
 #define WL1271_SCAN_BAND_5_GHZ 1
 
 #define WL1271_SCAN_TIMEOUT    10000 /* msec */
 
 enum {
@@ -59,33 +62,33 @@ enum {
 	WL1271_SCAN_STATE_5GHZ_ACTIVE,
 	WL1271_SCAN_STATE_5GHZ_PASSIVE,
 	WL1271_SCAN_STATE_DONE
 };
 
 struct basic_scan_params {
-	__le32 rx_config_options;
-	__le32 rx_filter_options;
 	/* Scan option flags (WL1271_SCAN_OPT_*) */
 	__le16 scan_options;
+	u8 role_id;
 	/* Number of scan channels in the list (maximum 30) */
 	u8 n_ch;
 	/* This field indicates the number of probe requests to send
 	   per channel for an active scan */
 	u8 n_probe_reqs;
-	/* Rate bit field for sending the probes */
-	__le32 tx_rate;
 	u8 tid_trigger;
 	u8 ssid_len;
-	/* in order to align */
-	u8 padding1[2];
+	u8 use_ssid_list;
+
+	/* Rate bit field for sending the probes */
+	__le32 tx_rate;
+
 	u8 ssid[IW_ESSID_MAX_SIZE];
 	/* Band to scan */
 	u8 band;
-	u8 use_ssid_list;
+
 	u8 scan_tag;
-	u8 padding2;
+	u8 padding2[2];
 } __packed;
 
 struct basic_scan_channel_params {
 	/* Duration in TU to wait for frames on a channel for active scan */
 	__le32 min_duration;
 	__le32 max_duration;
@@ -102,12 +105,16 @@ struct basic_scan_channel_params {
 
 struct wl1271_cmd_scan {
 	struct wl1271_cmd_header header;
 
 	struct basic_scan_params params;
 	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
+
+	/* src mac address */
+	u8 addr[ETH_ALEN];
+	u8 padding[2];
 } __packed;
 
 struct wl1271_cmd_trigger_scan_to {
 	struct wl1271_cmd_header header;
 
 	__le32 timeout;
@@ -181,13 +188,13 @@ struct wl1271_cmd_sched_scan_config {
 	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
 	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
 	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
 } __packed;
 
 
-#define SCHED_SCAN_MAX_SSIDS 8
+#define SCHED_SCAN_MAX_SSIDS 16
 
 enum {
 	SCAN_SSID_TYPE_PUBLIC = 0,
 	SCAN_SSID_TYPE_HIDDEN = 1,
 };
 
-- 
1.7.6.401.g6a319

