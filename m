Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:53043 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446Ab1ELOPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:54 -0400
Received: by mail-ey0-f171.google.com with SMTP id d26so763571eyd.30
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:53 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/7] wl12xx: add scheduled scan structures and commands
Date: Thu, 12 May 2011 17:15:36 +0300
Message-Id: <1305209740-30287-4-git-send-email-coelho@ti.com> (sfid-20110512_161558_714194_D52A0C57)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add firmware command structures, definitions and code to to configure,
start and stop scheduled scans.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/scan.c |  233 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.h |  114 ++++++++++++++++++
 2 files changed, 347 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 5d0544c..d78044f 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -320,3 +320,236 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 
 	return 0;
 }
+
+static int
+wl1271_scan_get_sched_scan_channels(struct wl1271 *wl,
+				    struct cfg80211_sched_scan_request *req,
+				    struct conn_scan_ch_params *channels,
+				    u32 band, bool radar, bool passive,
+				    int start)
+{
+	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
+	int i, j;
+	u32 flags;
+
+	for (i = 0, j = start;
+	     i < req->n_channels && j < MAX_CHANNELS_ALL_BANDS;
+	     i++) {
+		flags = req->channels[i]->flags;
+
+		if (!(flags & IEEE80211_CHAN_DISABLED) &&
+		    ((flags & IEEE80211_CHAN_PASSIVE_SCAN) == passive) &&
+		    ((flags & IEEE80211_CHAN_RADAR) == radar) &&
+		    (req->channels[i]->band == band)) {
+			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
+				     req->channels[i]->band,
+				     req->channels[i]->center_freq);
+			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
+				     req->channels[i]->hw_value,
+				     req->channels[i]->flags);
+			wl1271_debug(DEBUG_SCAN, "max_power %d",
+				     req->channels[i]->max_power);
+
+			if (flags & IEEE80211_CHAN_PASSIVE_SCAN) {
+				channels[j].passive_duration =
+					cpu_to_le16(c->dwell_time_passive);
+			} else {
+				channels[j].min_duration =
+					cpu_to_le16(c->min_dwell_time_active);
+				channels[j].max_duration =
+					cpu_to_le16(c->max_dwell_time_active);
+			}
+			channels[j].tx_power_att = req->channels[j]->max_power;
+			channels[j].channel = req->channels[i]->hw_value;
+
+			j++;
+		}
+	}
+
+	return j - start;
+}
+
+static int
+wl1271_scan_sched_scan_channels(struct wl1271 *wl,
+				struct cfg80211_sched_scan_request *req,
+				struct wl1271_cmd_sched_scan_config *cfg)
+{
+	int idx = 0;
+
+	cfg->passive[0] =
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+						    IEEE80211_BAND_2GHZ,
+						    false, true, idx);
+	idx += cfg->passive[0];
+
+	cfg->active[0] =
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+						    IEEE80211_BAND_2GHZ,
+						    false, false, idx);
+	idx += cfg->active[0];
+
+	cfg->passive[1] =
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+						    IEEE80211_BAND_5GHZ,
+						    false, true, idx);
+	idx += cfg->passive[1];
+
+	cfg->active[1] =
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+						    IEEE80211_BAND_5GHZ,
+						    false, false, 14);
+	idx += cfg->active[1];
+
+	cfg->dfs =
+		wl1271_scan_get_sched_scan_channels(wl, req, cfg->channels,
+						    IEEE80211_BAND_5GHZ,
+						    true, false, idx);
+	idx += cfg->dfs;
+
+	wl1271_debug(DEBUG_SCAN, "    2.4GHz: active %d passive %d",
+		     cfg->active[0], cfg->passive[0]);
+	wl1271_debug(DEBUG_SCAN, "    5GHz: active %d passive %d",
+		     cfg->active[1], cfg->passive[1]);
+
+	return idx;
+}
+
+int wl1271_scan_sched_scan_config(struct wl1271 *wl,
+				  struct cfg80211_sched_scan_request *req,
+				  struct ieee80211_sched_scan_ies *ies)
+{
+	struct wl1271_cmd_sched_scan_config *cfg = NULL;
+	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
+	int i, total_channels, ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
+
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+
+	cfg->rssi_threshold = c->rssi_threshold;
+	cfg->snr_threshold  = c->snr_threshold;
+	cfg->n_probe_reqs = c->num_probe_reqs;
+	/* cycles set to 0 it means infinite (until manually stopped) */
+	cfg->cycles = 0;
+	/* report APs when at least 1 is found */
+	cfg->report_after = 1;
+	/* don't stop scanning automatically when something is found */
+	cfg->terminate = 0;
+	cfg->tag = WL1271_SCAN_DEFAULT_TAG;
+	/* don't filter on BSS type */
+	cfg->bss_type = SCAN_BSS_TYPE_ANY;
+	/* currently NL80211 supports only a single interval */
+	for (i = 0; i < SCAN_MAX_CYCLE_INTERVALS; i++)
+		cfg->intervals[i] = cpu_to_le32(req->interval);
+
+	if (req->ssids[0].ssid_len && req->ssids[0].ssid) {
+		cfg->filter_type = SCAN_SSID_FILTER_SPECIFIC;
+		cfg->ssid_len = req->ssids[0].ssid_len;
+		memcpy(cfg->ssid, req->ssids[0].ssid,
+		       req->ssids[0].ssid_len);
+	} else {
+		cfg->filter_type = SCAN_SSID_FILTER_ANY;
+		cfg->ssid_len = 0;
+	}
+
+	total_channels = wl1271_scan_sched_scan_channels(wl, req, cfg);
+	if (total_channels == 0) {
+		wl1271_error("scan channel list is empty");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (cfg->active[0]) {
+		ret = wl1271_cmd_build_probe_req(wl, req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[IEEE80211_BAND_2GHZ],
+						 ies->len[IEEE80211_BAND_2GHZ],
+						 IEEE80211_BAND_2GHZ);
+		if (ret < 0) {
+			wl1271_error("2.4GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	if (cfg->active[1]) {
+		ret = wl1271_cmd_build_probe_req(wl,  req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[IEEE80211_BAND_5GHZ],
+						 ies->len[IEEE80211_BAND_5GHZ],
+						 IEEE80211_BAND_5GHZ);
+		if (ret < 0) {
+			wl1271_error("5GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN_CFG: ", cfg, sizeof(*cfg));
+
+	ret = wl1271_cmd_send(wl, CMD_CONNECTION_SCAN_CFG, cfg,
+			      sizeof(*cfg), 0);
+	if (ret < 0) {
+		wl1271_error("SCAN configuration failed");
+		goto out;
+	}
+out:
+	kfree(cfg);
+	return ret;
+}
+
+int wl1271_scan_sched_scan_start(struct wl1271 *wl)
+{
+	struct wl1271_cmd_sched_scan_start *start;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd periodic scan start");
+
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		return -ENOMEM;
+
+	start->tag = WL1271_SCAN_DEFAULT_TAG;
+
+	ret = wl1271_cmd_send(wl, CMD_START_PERIODIC_SCAN, start,
+			      sizeof(*start), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send scan start command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(start);
+	return ret;
+}
+
+void wl1271_scan_sched_scan_results(struct wl1271 *wl)
+{
+	wl1271_debug(DEBUG_SCAN, "got periodic scan results");
+
+	ieee80211_sched_scan_results(wl->hw);
+}
+
+void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
+{
+	struct wl1271_cmd_sched_scan_stop *stop;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd periodic scan stop");
+
+	/* FIXME: what to do if alloc'ing to stop fails? */
+	stop = kzalloc(sizeof(*stop), GFP_KERNEL);
+	if (!stop) {
+		wl1271_error("failed to alloc memory to send sched scan stop");
+		return;
+	}
+
+	stop->tag = WL1271_SCAN_DEFAULT_TAG;
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
+			      sizeof(*stop), 0);
+	if (ret < 0)
+		wl1271_error("failed to send sched scan stop command");
+
+	kfree(stop);
+}
diff --git a/drivers/net/wireless/wl12xx/scan.h b/drivers/net/wireless/wl12xx/scan.h
index 421a750..c833195 100644
--- a/drivers/net/wireless/wl12xx/scan.h
+++ b/drivers/net/wireless/wl12xx/scan.h
@@ -33,6 +33,12 @@ int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ie, size_t ie_len, u8 band);
 void wl1271_scan_stm(struct wl1271 *wl);
 void wl1271_scan_complete_work(struct work_struct *work);
+int wl1271_scan_sched_scan_config(struct wl1271 *wl,
+				     struct cfg80211_sched_scan_request *req,
+				     struct ieee80211_sched_scan_ies *ies);
+int wl1271_scan_sched_scan_start(struct wl1271 *wl);
+void wl1271_scan_sched_scan_stop(struct wl1271 *wl);
+void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
 #define WL1271_SCAN_DEFAULT_TAG        1
@@ -106,4 +112,112 @@ struct wl1271_cmd_trigger_scan_to {
 	__le32 timeout;
 } __packed;
 
+#define MAX_CHANNELS_ALL_BANDS 41
+#define SCAN_MAX_CYCLE_INTERVALS 16
+#define SCAN_MAX_BANDS 3
+
+enum {
+	SCAN_CHANNEL_TYPE_2GHZ_PASSIVE,
+	SCAN_CHANNEL_TYPE_2GHZ_ACTIVE,
+	SCAN_CHANNEL_TYPE_5GHZ_PASSIVE,
+	SCAN_CHANNEL_TYPE_5GHZ_ACTIVE,
+	SCAN_CHANNEL_TYPE_5GHZ_DFS,
+};
+
+enum {
+	SCAN_SSID_FILTER_ANY      = 0,
+	SCAN_SSID_FILTER_SPECIFIC = 1,
+	SCAN_SSID_FILTER_LIST     = 2,
+	SCAN_SSID_FILTER_DISABLED = 3
+};
+
+enum {
+	SCAN_BSS_TYPE_INDEPENDENT,
+	SCAN_BSS_TYPE_INFRASTRUCTURE,
+	SCAN_BSS_TYPE_ANY,
+};
+
+struct conn_scan_ch_params {
+	__le16 min_duration;
+	__le16 max_duration;
+	__le16 passive_duration;
+
+	u8  channel;
+	u8  tx_power_att;
+
+	/* bit 0: DFS channel; bit 1: DFS enabled */
+	u8  flags;
+
+	u8  padding[3];
+} __packed;
+
+struct wl1271_cmd_sched_scan_config {
+	struct wl1271_cmd_header header;
+
+	__le32 intervals[SCAN_MAX_CYCLE_INTERVALS];
+
+	s8 rssi_threshold; /* for filtering (in dBm) */
+	s8 snr_threshold;  /* for filtering (in dB) */
+
+	u8 cycles;       /* maximum number of scan cycles */
+	u8 report_after; /* report when this number of results are received */
+	u8 terminate;    /* stop scanning after reporting */
+
+	u8 tag;
+	u8 bss_type; /* for filtering */
+	u8 filter_type;
+
+	u8 ssid_len;     /* For SCAN_SSID_FILTER_SPECIFIC */
+	u8 ssid[IW_ESSID_MAX_SIZE];
+
+	u8 n_probe_reqs; /* Number of probes requests per channel */
+
+	u8 passive[SCAN_MAX_BANDS];
+	u8 active[SCAN_MAX_BANDS];
+
+	u8 dfs;
+
+	u8 padding[3];
+
+	struct conn_scan_ch_params channels[MAX_CHANNELS_ALL_BANDS];
+} __packed;
+
+
+#define SCHED_SCAN_MAX_SSIDS 8
+
+enum {
+	SCAN_SSID_TYPE_PUBLIC = 0,
+	SCAN_SSID_TYPE_HIDDEN = 1,
+};
+
+struct wl1271_ssid {
+	u8 type;
+	u8 len;
+	u8 ssid[IW_ESSID_MAX_SIZE];
+	/* u8 padding[2]; */
+} __packed;
+
+struct wl1271_cmd_sched_scan_ssid_list {
+	struct wl1271_cmd_header header;
+
+	u8 n_ssids;
+	struct wl1271_ssid ssids[SCHED_SCAN_MAX_SSIDS];
+	u8 padding[3];
+} __packed;
+
+struct wl1271_cmd_sched_scan_start {
+	struct wl1271_cmd_header header;
+
+	u8 tag;
+	u8 padding[3];
+} __packed;
+
+struct wl1271_cmd_sched_scan_stop {
+	struct wl1271_cmd_header header;
+
+	u8 tag;
+	u8 padding[3];
+} __packed;
+
+
 #endif /* __WL1271_SCAN_H__ */
-- 
1.7.1

