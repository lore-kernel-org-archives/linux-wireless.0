Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59108 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab2KVSyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:54:37 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3314883eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 10:54:35 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/14] wlcore: split 18xx and 12xx scan mechanism
Date: Thu, 22 Nov 2012 18:06:15 +0200
Message-Id: <1353600384-32462-6-git-send-email-eliad@wizery.com> (sfid-20121122_195457_707870_8EDD5766)
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan APIs of 12xx and 18xx are totally different.
Use some common functions as much as possible (e.g.
for setting scan channels), but split scan.c into
chip-specific scan.c files, each implementing its
own scan mechanism.

(in other words - move most of the current wlcore's
scan.c into wl12xx, and implement a similar mechanism
in 18xx, according to the new api)

New wlcore ops are introduced in order to call the
chip-specific scan functions.

The template indices used for each scan (regular/scheduled)
are also different between the chips, so set the correct
indices used for each scan type after identifying the chip.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: * use correct prefixes in some places (18xx instead of wl12xx/wl1271).
    * create a new patch ([01/14]) instead of fixing the issue
      (redundant ieee80211_sched_scan_stopped() call) here.
    (thanks Luca!)

 drivers/net/wireless/ti/wl12xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl12xx/main.c   |   11 +
 drivers/net/wireless/ti/wl12xx/scan.c   |  500 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl12xx/scan.h   |  138 +++++++++
 drivers/net/wireless/ti/wl18xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl18xx/main.c   |   13 +-
 drivers/net/wireless/ti/wl18xx/scan.c   |  320 +++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/scan.h   |  120 +++++++
 drivers/net/wireless/ti/wlcore/cmd.c    |   12 +-
 drivers/net/wireless/ti/wlcore/cmd.h    |    6 +-
 drivers/net/wireless/ti/wlcore/event.c  |    4 +-
 drivers/net/wireless/ti/wlcore/init.c   |   10 +-
 drivers/net/wireless/ti/wlcore/main.c   |   15 +-
 drivers/net/wireless/ti/wlcore/scan.c   |  513 +++----------------------------
 drivers/net/wireless/ti/wlcore/scan.h   |  127 ++-------
 drivers/net/wireless/ti/wlcore/tx.c     |    1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |   13 +
 17 files changed, 1209 insertions(+), 598 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl12xx/scan.h
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/scan.h

diff --git a/drivers/net/wireless/ti/wl12xx/Makefile b/drivers/net/wireless/ti/wl12xx/Makefile
index da509aa..8d9afd2 100644
--- a/drivers/net/wireless/ti/wl12xx/Makefile
+++ b/drivers/net/wireless/ti/wl12xx/Makefile
@@ -1,3 +1,3 @@
-wl12xx-objs	= main.o cmd.o acx.o debugfs.o
+wl12xx-objs	= main.o cmd.o acx.o debugfs.o scan.o
 
 obj-$(CONFIG_WL12XX)		+= wl12xx.o
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 6c9fba4..ada7031 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -38,6 +38,7 @@
 #include "reg.h"
 #include "cmd.h"
 #include "acx.h"
+#include "scan.h"
 #include "debugfs.h"
 
 static char *fref_param;
@@ -698,6 +699,11 @@ static int wl12xx_identify_chip(struct wl1271 *wl)
 		goto out;
 	}
 
+	/* common settings */
+	wl->scan_templ_id_2_4 = CMD_TEMPL_APP_PROBE_REQ_2_4_LEGACY;
+	wl->scan_templ_id_5 = CMD_TEMPL_APP_PROBE_REQ_5_LEGACY;
+	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
+	wl->sched_scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
 out:
 	return ret;
 }
@@ -1618,6 +1624,11 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_rx_csum		= NULL,
 	.ap_get_mimo_wide_rate_mask = NULL,
 	.debugfs_init		= wl12xx_debugfs_add_files,
+	.scan_start		= wl12xx_scan_start,
+	.scan_stop		= wl12xx_scan_stop,
+	.scan_completed		= wl12xx_scan_completed,
+	.sched_scan_start	= wl12xx_sched_scan_start,
+	.sched_scan_stop	= wl12xx_scan_sched_scan_stop,
 	.get_spare_blocks	= wl12xx_get_spare_blocks,
 	.set_key		= wl12xx_set_key,
 	.pre_pkt_send		= NULL,
diff --git a/drivers/net/wireless/ti/wl12xx/scan.c b/drivers/net/wireless/ti/wl12xx/scan.c
new file mode 100644
index 0000000..a99e876
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/scan.c
@@ -0,0 +1,500 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
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
+#include "scan.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/tx.h"
+
+static int wl1271_get_scan_channels(struct wl1271 *wl,
+				    struct cfg80211_scan_request *req,
+				    struct basic_scan_channel_params *channels,
+				    enum ieee80211_band band, bool passive)
+{
+	struct conf_scan_settings *c = &wl->conf.scan;
+	int i, j;
+	u32 flags;
+
+	for (i = 0, j = 0;
+	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
+	     i++) {
+		flags = req->channels[i]->flags;
+
+		if (!test_bit(i, wl->scan.scanned_ch) &&
+		    !(flags & IEEE80211_CHAN_DISABLED) &&
+		    (req->channels[i]->band == band) &&
+		    /*
+		     * In passive scans, we scan all remaining
+		     * channels, even if not marked as such.
+		     * In active scans, we only scan channels not
+		     * marked as passive.
+		     */
+		    (passive || !(flags & IEEE80211_CHAN_PASSIVE_SCAN))) {
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
+
+			if (!passive) {
+				channels[j].min_duration =
+					cpu_to_le32(c->min_dwell_time_active);
+				channels[j].max_duration =
+					cpu_to_le32(c->max_dwell_time_active);
+			} else {
+				channels[j].min_duration =
+					cpu_to_le32(c->min_dwell_time_passive);
+				channels[j].max_duration =
+					cpu_to_le32(c->max_dwell_time_passive);
+			}
+			channels[j].early_termination = 0;
+			channels[j].tx_power_att = req->channels[i]->max_power;
+			channels[j].channel = req->channels[i]->hw_value;
+
+			memset(&channels[j].bssid_lsb, 0xff, 4);
+			memset(&channels[j].bssid_msb, 0xff, 2);
+
+			/* Mark the channels we already used */
+			set_bit(i, wl->scan.scanned_ch);
+
+			j++;
+		}
+	}
+
+	return j;
+}
+
+#define WL1271_NOTHING_TO_SCAN 1
+
+static int wl1271_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    enum ieee80211_band band,
+			    bool passive, u32 basic_rate)
+{
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+	struct wl1271_cmd_scan *cmd;
+	struct wl1271_cmd_trigger_scan_to *trigger;
+	int ret;
+	u16 scan_options = 0;
+
+	/* skip active scans if we don't have SSIDs */
+	if (!passive && wl->scan.req->n_ssids == 0)
+		return WL1271_NOTHING_TO_SCAN;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
+	if (!cmd || !trigger) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (wl->conf.scan.split_scan_timeout)
+		scan_options |= WL1271_SCAN_OPT_SPLIT_SCAN;
+
+	if (passive)
+		scan_options |= WL1271_SCAN_OPT_PASSIVE;
+
+	cmd->params.role_id = wlvif->role_id;
+
+	if (WARN_ON(cmd->params.role_id == WL12XX_INVALID_ROLE_ID)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cmd->params.scan_options = cpu_to_le16(scan_options);
+
+	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
+						    cmd->channels,
+						    band, passive);
+	if (cmd->params.n_ch == 0) {
+		ret = WL1271_NOTHING_TO_SCAN;
+		goto out;
+	}
+
+	cmd->params.tx_rate = cpu_to_le32(basic_rate);
+	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
+	cmd->params.tid_trigger = CONF_TX_AC_ANY_TID;
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
+	memcpy(cmd->addr, vif->addr, ETH_ALEN);
+
+	ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+					 cmd->params.role_id, band,
+					 wl->scan.ssid, wl->scan.ssid_len,
+					 wl->scan.req->ie,
+					 wl->scan.req->ie_len, false);
+	if (ret < 0) {
+		wl1271_error("PROBE request template failed");
+		goto out;
+	}
+
+	trigger->timeout = cpu_to_le32(wl->conf.scan.split_scan_timeout);
+	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
+			      sizeof(*trigger), 0);
+	if (ret < 0) {
+		wl1271_error("trigger scan to failed for hw scan");
+		goto out;
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("SCAN failed");
+		goto out;
+	}
+
+out:
+	kfree(cmd);
+	kfree(trigger);
+	return ret;
+}
+
+int wl12xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	struct wl1271_cmd_header *cmd = NULL;
+	int ret = 0;
+
+	if (WARN_ON(wl->scan.state == WL1271_SCAN_STATE_IDLE))
+		return -EINVAL;
+
+	wl1271_debug(DEBUG_CMD, "cmd scan stop");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_SCAN, cmd,
+			      sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("cmd stop_scan failed");
+		goto out;
+	}
+out:
+	kfree(cmd);
+	return ret;
+}
+
+void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	int ret = 0;
+	enum ieee80211_band band;
+	u32 rate, mask;
+
+	switch (wl->scan.state) {
+	case WL1271_SCAN_STATE_IDLE:
+		break;
+
+	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
+		band = IEEE80211_BAND_2GHZ;
+		mask = wlvif->bitrate_masks[band];
+		if (wl->scan.req->no_cck) {
+			mask &= ~CONF_TX_CCK_RATES;
+			if (!mask)
+				mask = CONF_TX_RATE_MASK_BASIC_P2P;
+		}
+		rate = wl1271_tx_min_rate_get(wl, mask);
+		ret = wl1271_scan_send(wl, wlvif, band, false, rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
+			wl1271_scan_stm(wl, wlvif);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
+		band = IEEE80211_BAND_2GHZ;
+		mask = wlvif->bitrate_masks[band];
+		if (wl->scan.req->no_cck) {
+			mask &= ~CONF_TX_CCK_RATES;
+			if (!mask)
+				mask = CONF_TX_RATE_MASK_BASIC_P2P;
+		}
+		rate = wl1271_tx_min_rate_get(wl, mask);
+		ret = wl1271_scan_send(wl, wlvif, band, true, rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			if (wl->enable_11a)
+				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
+			else
+				wl->scan.state = WL1271_SCAN_STATE_DONE;
+			wl1271_scan_stm(wl, wlvif);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
+		band = IEEE80211_BAND_5GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, wlvif, band, false, rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
+			wl1271_scan_stm(wl, wlvif);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
+		band = IEEE80211_BAND_5GHZ;
+		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
+		ret = wl1271_scan_send(wl, wlvif, band, true, rate);
+		if (ret == WL1271_NOTHING_TO_SCAN) {
+			wl->scan.state = WL1271_SCAN_STATE_DONE;
+			wl1271_scan_stm(wl, wlvif);
+		}
+
+		break;
+
+	case WL1271_SCAN_STATE_DONE:
+		wl->scan.failed = false;
+		cancel_delayed_work(&wl->scan_complete_work);
+		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+					     msecs_to_jiffies(0));
+		break;
+
+	default:
+		wl1271_error("invalid scan state");
+		break;
+	}
+
+	if (ret < 0) {
+		cancel_delayed_work(&wl->scan_complete_work);
+		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+					     msecs_to_jiffies(0));
+	}
+}
+
+static void wl12xx_adjust_channels(struct wl1271_cmd_sched_scan_config *cmd,
+				   struct wlcore_scan_channels *cmd_channels)
+{
+	memcpy(cmd->passive, cmd_channels->passive, sizeof(cmd->passive));
+	memcpy(cmd->active, cmd_channels->active, sizeof(cmd->active));
+	cmd->dfs = cmd_channels->dfs;
+	cmd->n_pactive_ch = cmd_channels->passive_active;
+
+	memcpy(cmd->channels_2, cmd_channels->channels_2,
+	       sizeof(cmd->channels_2));
+	memcpy(cmd->channels_5, cmd_channels->channels_5,
+	       sizeof(cmd->channels_2));
+	/* channels_4 are not supported, so no need to copy them */
+}
+
+int wl1271_scan_sched_scan_config(struct wl1271 *wl,
+				  struct wl12xx_vif *wlvif,
+				  struct cfg80211_sched_scan_request *req,
+				  struct ieee80211_sched_scan_ies *ies)
+{
+	struct wl1271_cmd_sched_scan_config *cfg = NULL;
+	struct wlcore_scan_channels *cfg_channels = NULL;
+	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
+	int i, ret;
+	bool force_passive = !req->n_ssids;
+
+	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
+
+	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
+	if (!cfg)
+		return -ENOMEM;
+
+	cfg->role_id = wlvif->role_id;
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
+	cfg->ssid_len = 0;
+	ret = wlcore_scan_sched_scan_ssid_list(wl, wlvif, req);
+	if (ret < 0)
+		goto out;
+
+	cfg->filter_type = ret;
+
+	wl1271_debug(DEBUG_SCAN, "filter_type = %d", cfg->filter_type);
+
+	cfg_channels = kzalloc(sizeof(*cfg_channels), GFP_KERNEL);
+	if (!cfg_channels) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!wlcore_set_scan_chan_params(wl, cfg_channels, req->channels,
+					 req->n_channels, req->n_ssids)) {
+		wl1271_error("scan channel list is empty");
+		ret = -EINVAL;
+		goto out;
+	}
+	wl12xx_adjust_channels(cfg, cfg_channels);
+
+	if (!force_passive && cfg->active[0]) {
+		u8 band = IEEE80211_BAND_2GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 wlvif->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[band],
+						 ies->len[band], true);
+		if (ret < 0) {
+			wl1271_error("2.4GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	if (!force_passive && cfg->active[1]) {
+		u8 band = IEEE80211_BAND_5GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 wlvif->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[band],
+						 ies->len[band], true);
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
+	kfree(cfg_channels);
+	kfree(cfg);
+	return ret;
+}
+
+int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	struct wl1271_cmd_sched_scan_start *start;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd periodic scan start");
+
+	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
+		return -EOPNOTSUPP;
+
+	if ((wl->quirks & WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN) &&
+	    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
+		return -EBUSY;
+
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		return -ENOMEM;
+
+	start->role_id = wlvif->role_id;
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
+int wl12xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif  *wlvif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_sched_scan_ies *ies)
+{
+	int ret;
+
+	ret = wl1271_scan_sched_scan_config(wl, wlvif, req, ies);
+	if (ret < 0)
+		return ret;
+
+	return wl1271_scan_sched_scan_start(wl, wlvif);
+}
+
+void wl12xx_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif)
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
+	stop->role_id = wlvif->role_id;
+	stop->tag = WL1271_SCAN_DEFAULT_TAG;
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
+			      sizeof(*stop), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send sched scan stop command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(stop);
+}
+
+int wl12xx_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct cfg80211_scan_request *req)
+{
+	wl1271_scan_stm(wl, wlvif);
+	return 0;
+}
+
+void wl12xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	wl1271_scan_stm(wl, wlvif);
+}
diff --git a/drivers/net/wireless/ti/wl12xx/scan.h b/drivers/net/wireless/ti/wl12xx/scan.h
new file mode 100644
index 0000000..bd075de
--- /dev/null
+++ b/drivers/net/wireless/ti/wl12xx/scan.h
@@ -0,0 +1,138 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
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
+#ifndef __WL12XX_SCAN_H__
+#define __WL12XX_SCAN_H__
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/cmd.h"
+#include "../wlcore/scan.h"
+
+struct basic_scan_params {
+	/* Scan option flags (WL1271_SCAN_OPT_*) */
+	__le16 scan_options;
+	u8 role_id;
+	/* Number of scan channels in the list (maximum 30) */
+	u8 n_ch;
+	/* This field indicates the number of probe requests to send
+	   per channel for an active scan */
+	u8 n_probe_reqs;
+	u8 tid_trigger;
+	u8 ssid_len;
+	u8 use_ssid_list;
+
+	/* Rate bit field for sending the probes */
+	__le32 tx_rate;
+
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	/* Band to scan */
+	u8 band;
+
+	u8 scan_tag;
+	u8 padding2[2];
+} __packed;
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
+} __packed;
+
+struct wl1271_cmd_scan {
+	struct wl1271_cmd_header header;
+
+	struct basic_scan_params params;
+	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
+
+	/* src mac address */
+	u8 addr[ETH_ALEN];
+	u8 padding[2];
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
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+
+	u8 n_probe_reqs; /* Number of probes requests per channel */
+
+	u8 passive[SCAN_MAX_BANDS];
+	u8 active[SCAN_MAX_BANDS];
+
+	u8 dfs;
+
+	u8 n_pactive_ch; /* number of pactive (passive until fw detects energy)
+			    channels in BG band */
+	u8 role_id;
+	u8 padding[1];
+	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
+	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
+} __packed;
+
+struct wl1271_cmd_sched_scan_start {
+	struct wl1271_cmd_header header;
+
+	u8 tag;
+	u8 role_id;
+	u8 padding[2];
+} __packed;
+
+struct wl1271_cmd_sched_scan_stop {
+	struct wl1271_cmd_header header;
+
+	u8 tag;
+	u8 role_id;
+	u8 padding[2];
+} __packed;
+
+int wl12xx_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct cfg80211_scan_request *req);
+int wl12xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+void wl12xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl12xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif  *wlvif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_sched_scan_ies *ies);
+void wl12xx_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif);
+#endif
diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index 67c0987..f742249 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o
+wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o scan.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 8ba1c93..97c23c8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -38,6 +38,7 @@
 #include "tx.h"
 #include "wl18xx.h"
 #include "io.h"
+#include "scan.h"
 #include "debugfs.h"
 
 #define WL18XX_RX_CHECKSUM_MASK      0x40
@@ -612,7 +613,8 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
-			      WLCORE_QUIRK_TX_PAD_LAST_FRAME;
+			      WLCORE_QUIRK_TX_PAD_LAST_FRAME |
+			      WLCORE_QUIRK_DUAL_PROBE_TMPL;
 
 		wlcore_set_min_fw_ver(wl, WL18XX_CHIP_VER, WL18XX_IFTYPE_VER,
 				      WL18XX_MAJOR_VER, WL18XX_SUBTYPE_VER,
@@ -630,6 +632,10 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		goto out;
 	}
 
+	wl->scan_templ_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
+	wl->scan_templ_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
+	wl->sched_scan_templ_id_2_4 = CMD_TEMPL_PROBE_REQ_2_4_PERIODIC;
+	wl->sched_scan_templ_id_5 = CMD_TEMPL_PROBE_REQ_5_PERIODIC;
 out:
 	return ret;
 }
@@ -1320,6 +1326,11 @@ static struct wlcore_ops wl18xx_ops = {
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 	.get_mac	= wl18xx_get_mac,
 	.debugfs_init	= wl18xx_debugfs_add_files,
+	.scan_start	= wl18xx_scan_start,
+	.scan_stop	= wl18xx_scan_stop,
+	.scan_completed	= wl18xx_scan_completed,
+	.sched_scan_start	= wl18xx_sched_scan_start,
+	.sched_scan_stop	= wl18xx_scan_sched_scan_stop,
 	.handle_static_data	= wl18xx_handle_static_data,
 	.get_spare_blocks = wl18xx_get_spare_blocks,
 	.set_key	= wl18xx_set_key,
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
new file mode 100644
index 0000000..f31d0d4
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -0,0 +1,320 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
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
+#include "scan.h"
+#include "../wlcore/debug.h"
+
+static void wl18xx_adjust_channels(struct wl18xx_cmd_scan_params *cmd,
+				   struct wlcore_scan_channels *cmd_channels)
+{
+	memcpy(cmd->passive, cmd_channels->passive, sizeof(cmd->passive));
+	memcpy(cmd->active, cmd_channels->active, sizeof(cmd->active));
+	cmd->dfs = cmd_channels->dfs;
+	cmd->passive_active = cmd_channels->passive_active;
+
+	memcpy(cmd->channels_2, cmd_channels->channels_2,
+	       sizeof(cmd->channels_2));
+	memcpy(cmd->channels_5, cmd_channels->channels_5,
+	       sizeof(cmd->channels_2));
+	/* channels_4 are not supported, so no need to copy them */
+}
+
+static int wl18xx_scan_send(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    struct cfg80211_scan_request *req)
+{
+	struct wl18xx_cmd_scan_params *cmd;
+	struct wlcore_scan_channels *cmd_channels = NULL;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = wlvif->role_id;
+
+	if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cmd->scan_type = SCAN_TYPE_SEARCH;
+	cmd->rssi_threshold = -127;
+	cmd->snr_threshold = 0;
+
+	cmd->bss_type = SCAN_BSS_TYPE_ANY;
+
+	cmd->ssid_from_list = 0;
+	cmd->filter = 0;
+	cmd->add_broadcast = 0;
+
+	cmd->urgency = 0;
+	cmd->protect = 0;
+
+	cmd->n_probe_reqs = wl->conf.scan.num_probe_reqs;
+	cmd->terminate_after = 0;
+
+	/* configure channels */
+	WARN_ON(req->n_ssids > 1);
+
+	cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
+	if (!cmd_channels) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
+				    req->n_channels, req->n_ssids);
+	wl18xx_adjust_channels(cmd, cmd_channels);
+
+	/*
+	 * all the cycles params (except total cycles) should
+	 * remain 0 for normal scan
+	 */
+	cmd->total_cycles = 1;
+
+	if (req->no_cck)
+		cmd->rate = WL18XX_SCAN_RATE_6;
+
+	cmd->tag = WL1271_SCAN_DEFAULT_TAG;
+
+	if (req->n_ssids) {
+		cmd->ssid_len = req->ssids[0].ssid_len;
+		memcpy(cmd->ssid, req->ssids[0].ssid, cmd->ssid_len);
+	}
+
+	/* TODO: per-band ies? */
+	if (cmd->active[0]) {
+		u8 band = IEEE80211_BAND_2GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 cmd->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 req->ie,
+						 req->ie_len,
+						 false);
+		if (ret < 0) {
+			wl1271_error("2.4GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	if (cmd->active[1]) {
+		u8 band = IEEE80211_BAND_5GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 cmd->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 req->ie,
+						 req->ie_len,
+						 false);
+		if (ret < 0) {
+			wl1271_error("5GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("SCAN failed");
+		goto out;
+	}
+
+out:
+	kfree(cmd_channels);
+	kfree(cmd);
+	return ret;
+}
+
+void wl18xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	wl->scan.failed = false;
+	cancel_delayed_work(&wl->scan_complete_work);
+	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+				     msecs_to_jiffies(0));
+}
+
+static
+int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
+				  struct wl12xx_vif *wlvif,
+				  struct cfg80211_sched_scan_request *req,
+				  struct ieee80211_sched_scan_ies *ies)
+{
+	struct wl18xx_cmd_scan_params *cmd;
+	struct wlcore_scan_channels *cmd_channels = NULL;
+	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
+	int ret;
+	int filter_type;
+
+	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
+
+	filter_type = wlcore_scan_sched_scan_ssid_list(wl, wlvif, req);
+	if (filter_type < 0)
+		return filter_type;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = wlvif->role_id;
+
+	if (WARN_ON(cmd->role_id == WL12XX_INVALID_ROLE_ID)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	cmd->scan_type = SCAN_TYPE_PERIODIC;
+	cmd->rssi_threshold = c->rssi_threshold;
+	cmd->snr_threshold = c->snr_threshold;
+
+	/* don't filter on BSS type */
+	cmd->bss_type = SCAN_BSS_TYPE_ANY;
+
+	cmd->ssid_from_list = 1;
+	if (filter_type == SCAN_SSID_FILTER_LIST)
+		cmd->filter = 1;
+	cmd->add_broadcast = 0;
+
+	cmd->urgency = 0;
+	cmd->protect = 0;
+
+	cmd->n_probe_reqs = c->num_probe_reqs;
+	/* don't stop scanning automatically when something is found */
+	cmd->terminate_after = 0;
+
+	cmd_channels = kzalloc(sizeof(*cmd_channels), GFP_KERNEL);
+	if (!cmd_channels) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* configure channels */
+	wlcore_set_scan_chan_params(wl, cmd_channels, req->channels,
+				    req->n_channels, req->n_ssids);
+	wl18xx_adjust_channels(cmd, cmd_channels);
+
+	cmd->short_cycles_sec = 0;
+	cmd->long_cycles_sec = cpu_to_le16(req->interval);
+	cmd->short_cycles_count = 0;
+
+	cmd->total_cycles = 0;
+
+	cmd->tag = WL1271_SCAN_DEFAULT_TAG;
+
+	if (cmd->active[0]) {
+		u8 band = IEEE80211_BAND_2GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 cmd->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[band],
+						 ies->len[band],
+						 true);
+		if (ret < 0) {
+			wl1271_error("2.4GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	if (cmd->active[1]) {
+		u8 band = IEEE80211_BAND_5GHZ;
+		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
+						 cmd->role_id, band,
+						 req->ssids[0].ssid,
+						 req->ssids[0].ssid_len,
+						 ies->ie[band],
+						 ies->len[band],
+						 true);
+		if (ret < 0) {
+			wl1271_error("5GHz PROBE request template failed");
+			goto out;
+		}
+	}
+
+	wl1271_dump(DEBUG_SCAN, "SCAN: ", cmd, sizeof(*cmd));
+
+	ret = wl1271_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("SCAN failed");
+		goto out;
+	}
+
+out:
+	kfree(cmd_channels);
+	kfree(cmd);
+	return ret;
+}
+
+int wl18xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_sched_scan_ies *ies)
+{
+	return wl18xx_scan_sched_scan_config(wl, wlvif, req, ies);
+}
+
+static int __wl18xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			       u8 scan_type)
+{
+	struct wl18xx_cmd_scan_stop *stop;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD, "cmd periodic scan stop");
+
+	stop = kzalloc(sizeof(*stop), GFP_KERNEL);
+	if (!stop) {
+		wl1271_error("failed to alloc memory to send sched scan stop");
+		return -ENOMEM;
+	}
+
+	stop->role_id = wlvif->role_id;
+	stop->scan_type = scan_type;
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_SCAN, stop, sizeof(*stop), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send sched scan stop command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(stop);
+	return ret;
+}
+
+void wl18xx_scan_sched_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	__wl18xx_scan_stop(wl, wlvif, SCAN_TYPE_PERIODIC);
+}
+int wl18xx_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct cfg80211_scan_request *req)
+{
+	return wl18xx_scan_send(wl, wlvif, req);
+}
+
+int wl18xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	return __wl18xx_scan_stop(wl, wlvif, SCAN_TYPE_SEARCH);
+}
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
new file mode 100644
index 0000000..404baf1
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -0,0 +1,120 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2012 Texas Instruments. All rights reserved.
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
+#ifndef __WL18XX_SCAN_H__
+#define __WL18XX_SCAN_H__
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/cmd.h"
+#include "../wlcore/scan.h"
+
+struct tracking_ch_params {
+	struct conn_scan_ch_params channel;
+
+	__le32 bssid_lsb;
+	__le16 bssid_msb;
+
+	u8 padding[2];
+} __packed;
+
+enum
+{
+	SCAN_TYPE_SEARCH	= 0,
+	SCAN_TYPE_PERIODIC	= 1,
+	SCAN_TYPE_TRACKING	= 2,
+};
+
+/* probe request rate */
+enum
+{
+	WL18XX_SCAN_RATE_1	= 0,
+	WL18XX_SCAN_RATE_5_5	= 1,
+	WL18XX_SCAN_RATE_6	= 2,
+};
+
+struct wl18xx_cmd_scan_params {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 scan_type;
+
+	s8 rssi_threshold; /* for filtering (in dBm) */
+	s8 snr_threshold;  /* for filtering (in dB) */
+
+	u8 bss_type;	   /* for filtering */
+	u8 ssid_from_list; /* use ssid from configured ssid list */
+	u8 filter;	   /* forward only results with matching ssids */
+
+	/*
+	 * add broadcast ssid in addition to the configured ssids.
+	 * the driver should add dummy entry for it (?).
+	 */
+	u8 add_broadcast;
+
+	u8 urgency;
+	u8 protect;	 /* ??? */
+	u8 n_probe_reqs;    /* Number of probes requests per channel */
+	u8 terminate_after; /* early terminate scan operation */
+
+	u8 passive[SCAN_MAX_BANDS]; /* number of passive scan channels */
+	u8 active[SCAN_MAX_BANDS];  /* number of active scan channels */
+	u8 dfs;		   /* number of dfs channels in 5ghz */
+	u8 passive_active; /* number of passive before active channels 2.4ghz */
+
+	__le16 short_cycles_sec;
+	__le16 long_cycles_sec;
+	u8 short_cycles_count;
+	u8 total_cycles; /* 0 - infinite */
+	u8 rate;
+	u8 padding[1];
+
+	union {
+		struct {
+			struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
+			struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+			struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
+		};
+		struct tracking_ch_params channels_tracking[WL1271_SCAN_MAX_CHANNELS];
+	} ;
+
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;	 /* For SCAN_SSID_FILTER_SPECIFIC */
+	u8 tag;
+	u8 padding1[2];
+} __packed;
+
+struct wl18xx_cmd_scan_stop {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 scan_type;
+	u8 padding[2];
+} __packed;
+
+int wl18xx_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		      struct cfg80211_scan_request *req);
+int wl18xx_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+void wl18xx_scan_completed(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl18xx_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			    struct cfg80211_sched_scan_request *req,
+			    struct ieee80211_sched_scan_ies *ies);
+void wl18xx_scan_sched_scan_stop(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+#endif
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 04ba86d..c8c7766 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -131,6 +131,7 @@ fail:
 	wl12xx_queue_recovery_work(wl);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl1271_cmd_send);
 
 /*
  * Poll the mailbox event field until any of the bits in the mask is set or a
@@ -1049,8 +1050,8 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	struct sk_buff *skb;
 	int ret;
 	u32 rate;
-	u16 template_id_2_4 = CMD_TEMPL_CFG_PROBE_REQ_2_4;
-	u16 template_id_5 = CMD_TEMPL_CFG_PROBE_REQ_5;
+	u16 template_id_2_4 = wl->scan_templ_id_2_4;
+	u16 template_id_5 = wl->scan_templ_id_5;
 
 	skb = ieee80211_probereq_get(wl->hw, vif, ssid, ssid_len,
 				     ie, ie_len);
@@ -1061,10 +1062,10 @@ int wl12xx_cmd_build_probe_req(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	wl1271_dump(DEBUG_SCAN, "PROBE REQ: ", skb->data, skb->len);
 
-	if (!sched_scan &&
+	if (sched_scan &&
 	    (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL)) {
-		template_id_2_4 = CMD_TEMPL_APP_PROBE_REQ_2_4;
-		template_id_5 = CMD_TEMPL_APP_PROBE_REQ_5;
+		template_id_2_4 = wl->sched_scan_templ_id_2_4;
+		template_id_5 = wl->sched_scan_templ_id_5;
 	}
 
 	rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
@@ -1081,6 +1082,7 @@ out:
 	dev_kfree_skb(skb);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(wl12xx_cmd_build_probe_req);
 
 struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
 					      struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index d021305..9e9062f 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -172,8 +172,8 @@ enum cmd_templ {
 	CMD_TEMPL_PS_POLL,
 	CMD_TEMPL_KLV,
 	CMD_TEMPL_DISCONNECT,
-	CMD_TEMPL_APP_PROBE_REQ_2_4,
-	CMD_TEMPL_APP_PROBE_REQ_5,
+	CMD_TEMPL_APP_PROBE_REQ_2_4_LEGACY,
+	CMD_TEMPL_APP_PROBE_REQ_5_LEGACY,
 	CMD_TEMPL_BAR,           /* for firmware internal use only */
 	CMD_TEMPL_CTS,           /*
 				  * For CTS-to-self (FastCTS) mechanism
@@ -184,6 +184,8 @@ enum cmd_templ {
 	CMD_TEMPL_DEAUTH_AP,
 	CMD_TEMPL_TEMPORARY,
 	CMD_TEMPL_LINK_MEASUREMENT_REPORT,
+	CMD_TEMPL_PROBE_REQ_2_4_PERIODIC,
+	CMD_TEMPL_PROBE_REQ_5_PERIODIC,
 
 	CMD_TEMPL_MAX = 0xff
 };
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index cf45aaf..d9353da 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -117,7 +117,9 @@ static int wl1271_event_process(struct wl1271 *wl)
 		wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 			     mbox->scheduled_scan_status);
 
-		wl1271_scan_stm(wl, wl->scan_vif);
+		if (wl->scan_vif)
+			wl->ops->scan_completed(wl,
+					wl12xx_vif_to_data(wl->scan_vif));
 	}
 
 	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 84641b3..06e1bf9 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -41,14 +41,14 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
-				      CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
+				      wl->scan_templ_id_2_4, NULL,
 				      WL1271_CMD_TEMPL_MAX_SIZE,
 				      0, WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
 		return ret;
 
 	ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
-				      CMD_TEMPL_CFG_PROBE_REQ_5,
+				      wl->scan_templ_id_5,
 				      NULL, WL1271_CMD_TEMPL_MAX_SIZE, 0,
 				      WL1271_RATE_AUTOMATIC);
 	if (ret < 0)
@@ -56,14 +56,16 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 
 	if (wl->quirks & WLCORE_QUIRK_DUAL_PROBE_TMPL) {
 		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
-					      CMD_TEMPL_APP_PROBE_REQ_2_4, NULL,
+					      wl->sched_scan_templ_id_2_4,
+					      NULL,
 					      WL1271_CMD_TEMPL_MAX_SIZE,
 					      0, WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
 			return ret;
 
 		ret = wl1271_cmd_template_set(wl, WL12XX_INVALID_ROLE_ID,
-					      CMD_TEMPL_APP_PROBE_REQ_5, NULL,
+					      wl->sched_scan_templ_id_5,
+					      NULL,
 					      WL1271_CMD_TEMPL_MAX_SIZE,
 					      0, WL1271_RATE_AUTOMATIC);
 		if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9e6b7eb..77479cb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3252,7 +3252,7 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 		goto out_sleep;
 	}
 
-	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
+	ret = wlcore_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -3265,6 +3265,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 cancel hw scan");
@@ -3282,7 +3283,7 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 		goto out;
 
 	if (wl->scan.state != WL1271_SCAN_STATE_DONE) {
-		ret = wl1271_scan_stop(wl);
+		ret = wl->ops->scan_stop(wl, wlvif);
 		if (ret < 0)
 			goto out_sleep;
 	}
@@ -3329,11 +3330,7 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	ret = wl1271_scan_sched_scan_config(wl, wlvif, req, ies);
-	if (ret < 0)
-		goto out_sleep;
-
-	ret = wl1271_scan_sched_scan_start(wl, wlvif);
+	ret = wl->ops->sched_scan_start(wl, wlvif, req, ies);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -3364,7 +3361,7 @@ static void wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	wl1271_scan_sched_scan_stop(wl, wlvif);
+	wl->ops->sched_scan_stop(wl, wlvif);
 
 	wl1271_ps_elp_sleep(wl);
 out:
@@ -3821,7 +3818,7 @@ static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	/* we only support sched_scan while not connected */
 	if (wl->sched_scanning)
-		wl1271_scan_sched_scan_stop(wl, wlvif);
+		wl->ops->sched_scan_stop(wl, wlvif);
 
 	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 22dd7e9..9eab64d 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -89,319 +89,6 @@ out:
 
 }
 
-
-static int wl1271_get_scan_channels(struct wl1271 *wl,
-				    struct cfg80211_scan_request *req,
-				    struct basic_scan_channel_params *channels,
-				    enum ieee80211_band band, bool passive)
-{
-	struct conf_scan_settings *c = &wl->conf.scan;
-	int i, j;
-	u32 flags;
-
-	for (i = 0, j = 0;
-	     i < req->n_channels && j < WL1271_SCAN_MAX_CHANNELS;
-	     i++) {
-		flags = req->channels[i]->flags;
-
-		if (!test_bit(i, wl->scan.scanned_ch) &&
-		    !(flags & IEEE80211_CHAN_DISABLED) &&
-		    (req->channels[i]->band == band) &&
-		    /*
-		     * In passive scans, we scan all remaining
-		     * channels, even if not marked as such.
-		     * In active scans, we only scan channels not
-		     * marked as passive.
-		     */
-		    (passive || !(flags & IEEE80211_CHAN_PASSIVE_SCAN))) {
-			wl1271_debug(DEBUG_SCAN, "band %d, center_freq %d ",
-				     req->channels[i]->band,
-				     req->channels[i]->center_freq);
-			wl1271_debug(DEBUG_SCAN, "hw_value %d, flags %X",
-				     req->channels[i]->hw_value,
-				     req->channels[i]->flags);
-			wl1271_debug(DEBUG_SCAN,
-				     "max_antenna_gain %d, max_power %d",
-				     req->channels[i]->max_antenna_gain,
-				     req->channels[i]->max_power);
-			wl1271_debug(DEBUG_SCAN, "beacon_found %d",
-				     req->channels[i]->beacon_found);
-
-			if (!passive) {
-				channels[j].min_duration =
-					cpu_to_le32(c->min_dwell_time_active);
-				channels[j].max_duration =
-					cpu_to_le32(c->max_dwell_time_active);
-			} else {
-				channels[j].min_duration =
-					cpu_to_le32(c->min_dwell_time_passive);
-				channels[j].max_duration =
-					cpu_to_le32(c->max_dwell_time_passive);
-			}
-			channels[j].early_termination = 0;
-			channels[j].tx_power_att = req->channels[i]->max_power;
-			channels[j].channel = req->channels[i]->hw_value;
-
-			memset(&channels[j].bssid_lsb, 0xff, 4);
-			memset(&channels[j].bssid_msb, 0xff, 2);
-
-			/* Mark the channels we already used */
-			set_bit(i, wl->scan.scanned_ch);
-
-			j++;
-		}
-	}
-
-	return j;
-}
-
-#define WL1271_NOTHING_TO_SCAN 1
-
-static int wl1271_scan_send(struct wl1271 *wl, struct ieee80211_vif *vif,
-			    enum ieee80211_band band,
-			    bool passive, u32 basic_rate)
-{
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	struct wl1271_cmd_scan *cmd;
-	struct wl1271_cmd_trigger_scan_to *trigger;
-	int ret;
-	u16 scan_options = 0;
-
-	/* skip active scans if we don't have SSIDs */
-	if (!passive && wl->scan.req->n_ssids == 0)
-		return WL1271_NOTHING_TO_SCAN;
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	trigger = kzalloc(sizeof(*trigger), GFP_KERNEL);
-	if (!cmd || !trigger) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (wl->conf.scan.split_scan_timeout)
-		scan_options |= WL1271_SCAN_OPT_SPLIT_SCAN;
-
-	if (passive)
-		scan_options |= WL1271_SCAN_OPT_PASSIVE;
-
-	cmd->params.role_id = wlvif->role_id;
-
-	if (WARN_ON(cmd->params.role_id == WL12XX_INVALID_ROLE_ID)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	cmd->params.scan_options = cpu_to_le16(scan_options);
-
-	cmd->params.n_ch = wl1271_get_scan_channels(wl, wl->scan.req,
-						    cmd->channels,
-						    band, passive);
-	if (cmd->params.n_ch == 0) {
-		ret = WL1271_NOTHING_TO_SCAN;
-		goto out;
-	}
-
-	cmd->params.tx_rate = cpu_to_le32(basic_rate);
-	cmd->params.n_probe_reqs = wl->conf.scan.num_probe_reqs;
-	cmd->params.tid_trigger = CONF_TX_AC_ANY_TID;
-	cmd->params.scan_tag = WL1271_SCAN_DEFAULT_TAG;
-
-	if (band == IEEE80211_BAND_2GHZ)
-		cmd->params.band = WL1271_SCAN_BAND_2_4_GHZ;
-	else
-		cmd->params.band = WL1271_SCAN_BAND_5_GHZ;
-
-	if (wl->scan.ssid_len && wl->scan.ssid) {
-		cmd->params.ssid_len = wl->scan.ssid_len;
-		memcpy(cmd->params.ssid, wl->scan.ssid, wl->scan.ssid_len);
-	}
-
-	memcpy(cmd->addr, vif->addr, ETH_ALEN);
-
-	ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-					 cmd->params.role_id, band,
-					 wl->scan.ssid, wl->scan.ssid_len,
-					 wl->scan.req->ie,
-					 wl->scan.req->ie_len, false);
-	if (ret < 0) {
-		wl1271_error("PROBE request template failed");
-		goto out;
-	}
-
-	trigger->timeout = cpu_to_le32(wl->conf.scan.split_scan_timeout);
-	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
-			      sizeof(*trigger), 0);
-	if (ret < 0) {
-		wl1271_error("trigger scan to failed for hw scan");
-		goto out;
-	}
-
-	wl1271_dump(DEBUG_SCAN, "SCAN: ", cmd, sizeof(*cmd));
-
-	ret = wl1271_cmd_send(wl, CMD_SCAN, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("SCAN failed");
-		goto out;
-	}
-
-out:
-	kfree(cmd);
-	kfree(trigger);
-	return ret;
-}
-
-void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif)
-{
-	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
-	int ret = 0;
-	enum ieee80211_band band;
-	u32 rate, mask;
-
-	switch (wl->scan.state) {
-	case WL1271_SCAN_STATE_IDLE:
-		break;
-
-	case WL1271_SCAN_STATE_2GHZ_ACTIVE:
-		band = IEEE80211_BAND_2GHZ;
-		mask = wlvif->bitrate_masks[band];
-		if (wl->scan.req->no_cck) {
-			mask &= ~CONF_TX_CCK_RATES;
-			if (!mask)
-				mask = CONF_TX_RATE_MASK_BASIC_P2P;
-		}
-		rate = wl1271_tx_min_rate_get(wl, mask);
-		ret = wl1271_scan_send(wl, vif, band, false, rate);
-		if (ret == WL1271_NOTHING_TO_SCAN) {
-			wl->scan.state = WL1271_SCAN_STATE_2GHZ_PASSIVE;
-			wl1271_scan_stm(wl, vif);
-		}
-
-		break;
-
-	case WL1271_SCAN_STATE_2GHZ_PASSIVE:
-		band = IEEE80211_BAND_2GHZ;
-		mask = wlvif->bitrate_masks[band];
-		if (wl->scan.req->no_cck) {
-			mask &= ~CONF_TX_CCK_RATES;
-			if (!mask)
-				mask = CONF_TX_RATE_MASK_BASIC_P2P;
-		}
-		rate = wl1271_tx_min_rate_get(wl, mask);
-		ret = wl1271_scan_send(wl, vif, band, true, rate);
-		if (ret == WL1271_NOTHING_TO_SCAN) {
-			if (wl->enable_11a)
-				wl->scan.state = WL1271_SCAN_STATE_5GHZ_ACTIVE;
-			else
-				wl->scan.state = WL1271_SCAN_STATE_DONE;
-			wl1271_scan_stm(wl, vif);
-		}
-
-		break;
-
-	case WL1271_SCAN_STATE_5GHZ_ACTIVE:
-		band = IEEE80211_BAND_5GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, vif, band, false, rate);
-		if (ret == WL1271_NOTHING_TO_SCAN) {
-			wl->scan.state = WL1271_SCAN_STATE_5GHZ_PASSIVE;
-			wl1271_scan_stm(wl, vif);
-		}
-
-		break;
-
-	case WL1271_SCAN_STATE_5GHZ_PASSIVE:
-		band = IEEE80211_BAND_5GHZ;
-		rate = wl1271_tx_min_rate_get(wl, wlvif->bitrate_masks[band]);
-		ret = wl1271_scan_send(wl, vif, band, true, rate);
-		if (ret == WL1271_NOTHING_TO_SCAN) {
-			wl->scan.state = WL1271_SCAN_STATE_DONE;
-			wl1271_scan_stm(wl, vif);
-		}
-
-		break;
-
-	case WL1271_SCAN_STATE_DONE:
-		wl->scan.failed = false;
-		cancel_delayed_work(&wl->scan_complete_work);
-		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
-					     msecs_to_jiffies(0));
-		break;
-
-	default:
-		wl1271_error("invalid scan state");
-		break;
-	}
-
-	if (ret < 0) {
-		cancel_delayed_work(&wl->scan_complete_work);
-		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
-					     msecs_to_jiffies(0));
-	}
-}
-
-int wl1271_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
-		const u8 *ssid, size_t ssid_len,
-		struct cfg80211_scan_request *req)
-{
-	/*
-	 * cfg80211 should guarantee that we don't get more channels
-	 * than what we have registered.
-	 */
-	BUG_ON(req->n_channels > WL1271_MAX_CHANNELS);
-
-	if (wl->scan.state != WL1271_SCAN_STATE_IDLE)
-		return -EBUSY;
-
-	wl->scan.state = WL1271_SCAN_STATE_2GHZ_ACTIVE;
-
-	if (ssid_len && ssid) {
-		wl->scan.ssid_len = ssid_len;
-		memcpy(wl->scan.ssid, ssid, ssid_len);
-	} else {
-		wl->scan.ssid_len = 0;
-	}
-
-	wl->scan_vif = vif;
-	wl->scan.req = req;
-	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
-
-	/* we assume failure so that timeout scenarios are handled correctly */
-	wl->scan.failed = true;
-	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
-				     msecs_to_jiffies(WL1271_SCAN_TIMEOUT));
-
-	wl1271_scan_stm(wl, vif);
-
-	return 0;
-}
-
-int wl1271_scan_stop(struct wl1271 *wl)
-{
-	struct wl1271_cmd_header *cmd = NULL;
-	int ret = 0;
-
-	if (WARN_ON(wl->scan.state == WL1271_SCAN_STATE_IDLE))
-		return -EINVAL;
-
-	wl1271_debug(DEBUG_CMD, "cmd scan stop");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = wl1271_cmd_send(wl, CMD_STOP_SCAN, cmd,
-			      sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("cmd stop_scan failed");
-		goto out;
-	}
-out:
-	kfree(cmd);
-	return ret;
-}
-
 static int
 wlcore_scan_get_channels(struct wl1271 *wl,
 			 struct ieee80211_channel *req_channels[],
@@ -503,9 +190,9 @@ wlcore_scan_get_channels(struct wl1271 *wl,
 	return j - start;
 }
 
-static bool
+bool
 wlcore_set_scan_chan_params(struct wl1271 *wl,
-			    struct wl1271_cmd_sched_scan_config *cfg,
+			    struct wlcore_scan_channels *cfg,
 			    struct ieee80211_channel *channels[],
 			    u32 n_channels,
 			    u32 n_ssids)
@@ -570,7 +257,7 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 	cfg->passive[2] = 0;
 	cfg->active[2] = 0;
 
-	cfg->n_pactive_ch = n_pactive_ch;
+	cfg->passive_active = n_pactive_ch;
 
 	wl1271_debug(DEBUG_SCAN, "    2.4GHz: active %d passive %d",
 		     cfg->active[0], cfg->passive[0]);
@@ -582,10 +269,48 @@ wlcore_set_scan_chan_params(struct wl1271 *wl,
 		cfg->passive[1] || cfg->active[1] || cfg->dfs ||
 		cfg->passive[2] || cfg->active[2];
 }
+EXPORT_SYMBOL_GPL(wlcore_set_scan_chan_params);
 
+int wlcore_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
+		const u8 *ssid, size_t ssid_len,
+		struct cfg80211_scan_request *req)
+{
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
+	/*
+	 * cfg80211 should guarantee that we don't get more channels
+	 * than what we have registered.
+	 */
+	BUG_ON(req->n_channels > WL1271_MAX_CHANNELS);
+
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
+	wl->scan_vif = vif;
+	wl->scan.req = req;
+	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
+
+	/* we assume failure so that timeout scenarios are handled correctly */
+	wl->scan.failed = true;
+	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+				     msecs_to_jiffies(WL1271_SCAN_TIMEOUT));
+
+	wl->ops->scan_start(wl, wlvif, req);
+
+	return 0;
+}
 /* Returns the scan type to be used or a negative value on error */
-static int
-wl12xx_scan_sched_scan_ssid_list(struct wl1271 *wl,
+int
+wlcore_scan_sched_scan_ssid_list(struct wl1271 *wl,
 				 struct wl12xx_vif *wlvif,
 				 struct cfg80211_sched_scan_request *req)
 {
@@ -688,129 +413,7 @@ out:
 		return ret;
 	return type;
 }
-
-int wl1271_scan_sched_scan_config(struct wl1271 *wl,
-				  struct wl12xx_vif *wlvif,
-				  struct cfg80211_sched_scan_request *req,
-				  struct ieee80211_sched_scan_ies *ies)
-{
-	struct wl1271_cmd_sched_scan_config *cfg = NULL;
-	struct conf_sched_scan_settings *c = &wl->conf.sched_scan;
-	int i, ret;
-	bool force_passive = !req->n_ssids;
-
-	wl1271_debug(DEBUG_CMD, "cmd sched_scan scan config");
-
-	cfg = kzalloc(sizeof(*cfg), GFP_KERNEL);
-	if (!cfg)
-		return -ENOMEM;
-
-	cfg->role_id = wlvif->role_id;
-	cfg->rssi_threshold = c->rssi_threshold;
-	cfg->snr_threshold  = c->snr_threshold;
-	cfg->n_probe_reqs = c->num_probe_reqs;
-	/* cycles set to 0 it means infinite (until manually stopped) */
-	cfg->cycles = 0;
-	/* report APs when at least 1 is found */
-	cfg->report_after = 1;
-	/* don't stop scanning automatically when something is found */
-	cfg->terminate = 0;
-	cfg->tag = WL1271_SCAN_DEFAULT_TAG;
-	/* don't filter on BSS type */
-	cfg->bss_type = SCAN_BSS_TYPE_ANY;
-	/* currently NL80211 supports only a single interval */
-	for (i = 0; i < SCAN_MAX_CYCLE_INTERVALS; i++)
-		cfg->intervals[i] = cpu_to_le32(req->interval);
-
-	cfg->ssid_len = 0;
-	ret = wl12xx_scan_sched_scan_ssid_list(wl, wlvif, req);
-	if (ret < 0)
-		goto out;
-
-	cfg->filter_type = ret;
-
-	wl1271_debug(DEBUG_SCAN, "filter_type = %d", cfg->filter_type);
-
-	if (!wlcore_set_scan_chan_params(wl, cfg, req->channels,
-					 req->n_channels, req->n_ssids)) {
-		wl1271_error("scan channel list is empty");
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (!force_passive && cfg->active[0]) {
-		u8 band = IEEE80211_BAND_2GHZ;
-		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band], true);
-		if (ret < 0) {
-			wl1271_error("2.4GHz PROBE request template failed");
-			goto out;
-		}
-	}
-
-	if (!force_passive && cfg->active[1]) {
-		u8 band = IEEE80211_BAND_5GHZ;
-		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
-						 wlvif->role_id, band,
-						 req->ssids[0].ssid,
-						 req->ssids[0].ssid_len,
-						 ies->ie[band],
-						 ies->len[band], true);
-		if (ret < 0) {
-			wl1271_error("5GHz PROBE request template failed");
-			goto out;
-		}
-	}
-
-	wl1271_dump(DEBUG_SCAN, "SCAN_CFG: ", cfg, sizeof(*cfg));
-
-	ret = wl1271_cmd_send(wl, CMD_CONNECTION_SCAN_CFG, cfg,
-			      sizeof(*cfg), 0);
-	if (ret < 0) {
-		wl1271_error("SCAN configuration failed");
-		goto out;
-	}
-out:
-	kfree(cfg);
-	return ret;
-}
-
-int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif)
-{
-	struct wl1271_cmd_sched_scan_start *start;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_CMD, "cmd periodic scan start");
-
-	if (wlvif->bss_type != BSS_TYPE_STA_BSS)
-		return -EOPNOTSUPP;
-
-	if ((wl->quirks & WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN) &&
-	    test_bit(WLVIF_FLAG_IN_USE, &wlvif->flags))
-		return -EBUSY;
-
-	start = kzalloc(sizeof(*start), GFP_KERNEL);
-	if (!start)
-		return -ENOMEM;
-
-	start->role_id = wlvif->role_id;
-	start->tag = WL1271_SCAN_DEFAULT_TAG;
-
-	ret = wl1271_cmd_send(wl, CMD_START_PERIODIC_SCAN, start,
-			      sizeof(*start), 0);
-	if (ret < 0) {
-		wl1271_error("failed to send scan start command");
-		goto out_free;
-	}
-
-out_free:
-	kfree(start);
-	return ret;
-}
+EXPORT_SYMBOL_GPL(wlcore_scan_sched_scan_ssid_list);
 
 void wl1271_scan_sched_scan_results(struct wl1271 *wl)
 {
@@ -818,31 +421,3 @@ void wl1271_scan_sched_scan_results(struct wl1271 *wl)
 
 	ieee80211_sched_scan_results(wl->hw);
 }
-
-void wl1271_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif)
-{
-	struct wl1271_cmd_sched_scan_stop *stop;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_CMD, "cmd periodic scan stop");
-
-	/* FIXME: what to do if alloc'ing to stop fails? */
-	stop = kzalloc(sizeof(*stop), GFP_KERNEL);
-	if (!stop) {
-		wl1271_error("failed to alloc memory to send sched scan stop");
-		return;
-	}
-
-	stop->role_id = wlvif->role_id;
-	stop->tag = WL1271_SCAN_DEFAULT_TAG;
-
-	ret = wl1271_cmd_send(wl, CMD_STOP_PERIODIC_SCAN, stop,
-			      sizeof(*stop), 0);
-	if (ret < 0) {
-		wl1271_error("failed to send sched scan stop command");
-		goto out_free;
-	}
-
-out_free:
-	kfree(stop);
-}
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 29f3c8d6..25b0422 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -26,21 +26,19 @@
 
 #include "wlcore.h"
 
-int wl1271_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
+int wlcore_scan(struct wl1271 *wl, struct ieee80211_vif *vif,
 		const u8 *ssid, size_t ssid_len,
 		struct cfg80211_scan_request *req);
-int wl1271_scan_stop(struct wl1271 *wl);
 int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ssid, size_t ssid_len,
 				const u8 *ie, size_t ie_len, u8 band);
-void wl1271_scan_stm(struct wl1271 *wl, struct ieee80211_vif *vif);
+void wl1271_scan_stm(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl1271_scan_complete_work(struct work_struct *work);
 int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				     struct wl12xx_vif *wlvif,
 				     struct cfg80211_sched_scan_request *req,
 				     struct ieee80211_sched_scan_ies *ies);
 int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-void wl1271_scan_sched_scan_stop(struct wl1271 *wl,  struct wl12xx_vif *wlvif);
 void wl1271_scan_sched_scan_results(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
@@ -66,56 +64,6 @@ enum {
 	WL1271_SCAN_STATE_DONE
 };
 
-struct basic_scan_params {
-	/* Scan option flags (WL1271_SCAN_OPT_*) */
-	__le16 scan_options;
-	u8 role_id;
-	/* Number of scan channels in the list (maximum 30) */
-	u8 n_ch;
-	/* This field indicates the number of probe requests to send
-	   per channel for an active scan */
-	u8 n_probe_reqs;
-	u8 tid_trigger;
-	u8 ssid_len;
-	u8 use_ssid_list;
-
-	/* Rate bit field for sending the probes */
-	__le32 tx_rate;
-
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	/* Band to scan */
-	u8 band;
-
-	u8 scan_tag;
-	u8 padding2[2];
-} __packed;
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
-} __packed;
-
-struct wl1271_cmd_scan {
-	struct wl1271_cmd_header header;
-
-	struct basic_scan_params params;
-	struct basic_scan_channel_params channels[WL1271_SCAN_MAX_CHANNELS];
-
-	/* src mac address */
-	u8 addr[ETH_ALEN];
-	u8 padding[2];
-} __packed;
-
 struct wl1271_cmd_trigger_scan_to {
 	struct wl1271_cmd_header header;
 
@@ -160,43 +108,6 @@ struct conn_scan_ch_params {
 	u8  padding[3];
 } __packed;
 
-struct wl1271_cmd_sched_scan_config {
-	struct wl1271_cmd_header header;
-
-	__le32 intervals[SCAN_MAX_CYCLE_INTERVALS];
-
-	s8 rssi_threshold; /* for filtering (in dBm) */
-	s8 snr_threshold;  /* for filtering (in dB) */
-
-	u8 cycles;       /* maximum number of scan cycles */
-	u8 report_after; /* report when this number of results are received */
-	u8 terminate;    /* stop scanning after reporting */
-
-	u8 tag;
-	u8 bss_type; /* for filtering */
-	u8 filter_type;
-
-	u8 ssid_len;     /* For SCAN_SSID_FILTER_SPECIFIC */
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-
-	u8 n_probe_reqs; /* Number of probes requests per channel */
-
-	u8 passive[SCAN_MAX_BANDS];
-	u8 active[SCAN_MAX_BANDS];
-
-	u8 dfs;
-
-	u8 n_pactive_ch; /* number of pactive (passive until fw detects energy)
-			    channels in BG band */
-	u8 role_id;
-	u8 padding[1];
-
-	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
-	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
-	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
-} __packed;
-
-
 #define SCHED_SCAN_MAX_SSIDS 16
 
 enum {
@@ -220,21 +131,27 @@ struct wl1271_cmd_sched_scan_ssid_list {
 	u8 padding[2];
 } __packed;
 
-struct wl1271_cmd_sched_scan_start {
-	struct wl1271_cmd_header header;
+struct wlcore_scan_channels {
+	u8 passive[SCAN_MAX_BANDS]; /* number of passive scan channels */
+	u8 active[SCAN_MAX_BANDS];  /* number of active scan channels */
+	u8 dfs;		   /* number of dfs channels in 5ghz */
+	u8 passive_active; /* number of passive before active channels 2.4ghz */
 
-	u8 tag;
-	u8 role_id;
-	u8 padding[2];
-} __packed;
-
-struct wl1271_cmd_sched_scan_stop {
-	struct wl1271_cmd_header header;
-
-	u8 tag;
-	u8 role_id;
-	u8 padding[2];
-} __packed;
+	struct conn_scan_ch_params channels_2[MAX_CHANNELS_2GHZ];
+	struct conn_scan_ch_params channels_5[MAX_CHANNELS_5GHZ];
+	struct conn_scan_ch_params channels_4[MAX_CHANNELS_4GHZ];
+};
 
+bool
+wlcore_set_scan_chan_params(struct wl1271 *wl,
+			    struct wlcore_scan_channels *cfg,
+			    struct ieee80211_channel *channels[],
+			    u32 n_channels,
+			    u32 n_ssids);
+
+int
+wlcore_scan_sched_scan_ssid_list(struct wl1271 *wl,
+				 struct wl12xx_vif *wlvif,
+				 struct cfg80211_sched_scan_request *req);
 
 #endif /* __WL1271_SCAN_H__ */
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index cf6dbee..2844f30 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1135,6 +1135,7 @@ u32 wl1271_tx_min_rate_get(struct wl1271 *wl, u32 rate_set)
 
 	return BIT(__ffs(rate_set));
 }
+EXPORT_SYMBOL_GPL(wl1271_tx_min_rate_get);
 
 void wlcore_stop_queue_locked(struct wl1271 *wl, u8 queue,
 			      enum wlcore_queue_stop_reason reason)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index b636f1d..9f82ee3 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -82,6 +82,14 @@ struct wlcore_ops {
 	int (*debugfs_init)(struct wl1271 *wl, struct dentry *rootdir);
 	int (*handle_static_data)(struct wl1271 *wl,
 				  struct wl1271_static_data *static_data);
+	int (*scan_start)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			  struct cfg80211_scan_request *req);
+	int (*scan_stop)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+	void (*scan_completed)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+	int (*sched_scan_start)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				struct cfg80211_sched_scan_request *req,
+				struct ieee80211_sched_scan_ies *ies);
+	void (*sched_scan_stop)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 	int (*get_spare_blocks)(struct wl1271 *wl, bool is_gem);
 	int (*set_key)(struct wl1271 *wl, enum set_key_cmd cmd,
 		       struct ieee80211_vif *vif,
@@ -370,6 +378,11 @@ struct wl1271 {
 	const char *sr_fw_name;
 	const char *mr_fw_name;
 
+	u8 scan_templ_id_2_4;
+	u8 scan_templ_id_5;
+	u8 sched_scan_templ_id_2_4;
+	u8 sched_scan_templ_id_5;
+
 	/* per-chip-family private structure */
 	void *priv;
 
-- 
1.7.6.401.g6a319

