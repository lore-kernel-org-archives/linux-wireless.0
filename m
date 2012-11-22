Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50572 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2KVTYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:24:52 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3055972eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:24:50 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>,
	Victor Goldenshtein <victorg@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/13] wlcore: add new reg-domain configuration command
Date: Thu, 22 Nov 2012 14:05:26 +0200
Message-Id: <1353585928-28666-12-git-send-email-eliad@wizery.com> (sfid-20121122_202501_474103_07FD7038)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Victor Goldenshtein <victorg@ti.com>

In 18xx the calibration process of the PHY Cortex domain
requires to perform an active calibration of the channel
before it can be used for transmission. To fulfill world
wide regulatory restrictions, fw should be always
synchronized/updated with current CRDA configuration.
Add a new "CMD_DFS_CHANNEL_CONFIG" command to update the
fw with current reg-domain, this command passes a bit map
of channels that are allowed to be used for transmission.

The driver shall update the fw during initialization and
after each change in the current reg-domain
configuration. The driver will save the channel number of
incoming beacons during the scan process, as they might
be a result of the passive scan on
"IEEE80211_CHAN_PASSIVE_SCAN" channel and will update the
fw accordingly once the scan is finished, the purpose of
this is to be ready in case of the authentication request
on one of these disabled (uncalibrated) channels.

The new command requires to wait for the fw completion
event "DFS_CHANNELS_CONFIG_COMPLETE_EVENT".

No scan commands (including the sched scan) can be
executed concurrently with the "CMD_DFS_CHANNEL_CONFIG",
wl->mutex ensures that.

[Arik - move reset of reg_ch_conf_last to safe place inside
op_stop_locked]
[Eliad - adjust to new event waiting api]

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/event.c  |    4 +
 drivers/net/wireless/ti/wl18xx/main.c   |    2 +
 drivers/net/wireless/ti/wlcore/boot.c   |    4 +-
 drivers/net/wireless/ti/wlcore/cmd.c    |  125 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.h    |   10 +++
 drivers/net/wireless/ti/wlcore/event.h  |    1 +
 drivers/net/wireless/ti/wlcore/init.c   |    4 +
 drivers/net/wireless/ti/wlcore/main.c   |   34 ++++++++
 drivers/net/wireless/ti/wlcore/rx.c     |    4 +
 drivers/net/wireless/ti/wlcore/scan.c   |    2 +
 drivers/net/wireless/ti/wlcore/wlcore.h |   12 +++
 11 files changed, 201 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index bf4233c..02ef5aa 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -34,6 +34,10 @@ int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
 		local_event = PEER_REMOVE_COMPLETE_EVENT_ID;
 		break;
 
+	case WLCORE_EVENT_DFS_CONFIG_COMPLETE:
+		local_event = DFS_CHANNELS_CONFIG_COMPLETE_EVENT;
+		break;
+
 	default:
 		/* event not implemented */
 		return 0;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0895ffa..420da4ae 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -616,6 +616,7 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 			      WLCORE_QUIRK_TX_BLOCKSIZE_ALIGN |
 			      WLCORE_QUIRK_NO_SCHED_SCAN_WHILE_CONN |
 			      WLCORE_QUIRK_TX_PAD_LAST_FRAME |
+			      WLCORE_QUIRK_REGDOMAIN_CONF |
 			      WLCORE_QUIRK_DUAL_PROBE_TMPL;
 
 		wlcore_set_min_fw_ver(wl, WL18XX_CHIP_VER, WL18XX_IFTYPE_VER,
@@ -1427,6 +1428,7 @@ static int wl18xx_setup(struct wl1271 *wl)
 	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
 	wl->stats.fw_stats_len = sizeof(struct wl18xx_acx_statistics);
 	wl->static_data_priv_len = sizeof(struct wl18xx_static_data_priv);
+	wl->chip_family_event_mask = DFS_CHANNELS_CONFIG_COMPLETE_EVENT;
 
 	if (num_rx_desc_param != -1)
 		wl->num_rx_desc = num_rx_desc_param;
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 230c765..381a80d 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -507,7 +507,9 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 	 * ready to receive event from the command mailbox
 	 */
 
-	/* unmask required mbox events  */
+	/* unmask required mbox events  and specific family mbox events  */
+	wl->event_mask |= wl->chip_family_event_mask;
+
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
 		wl1271_error("EVENT mask setting failed");
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 1735a53..599c006 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1503,6 +1503,131 @@ out:
 	return ret;
 }
 
+static int wlcore_get_reg_conf_ch_idx(enum ieee80211_band band, u16 ch)
+{
+	int idx = -1;
+
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
+		if (ch >= 8 && ch <= 16)
+			idx = ((ch-8)/4 + 18);
+		else if (ch >= 34 && ch <= 64)
+			idx = ((ch-34)/2 + 3 + 18);
+		else if (ch >= 100 && ch <= 140)
+			idx = ((ch-100)/4 + 15 + 18);
+		else if (ch >= 149 && ch <= 165)
+			idx = ((ch-149)/4 + 26 + 18);
+		else
+			idx = -1;
+		break;
+	case IEEE80211_BAND_2GHZ:
+		if (ch >= 1 && ch <= 14)
+			idx = ch - 1;
+		else
+			idx = -1;
+		break;
+	default:
+		wl1271_error("get reg conf ch idx - unknown band: %d",
+			     (int)band);
+	}
+
+	return idx;
+}
+
+void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
+				     enum ieee80211_band band)
+{
+	int ch_bit_idx = 0;
+
+	if (!(wl->quirks & WLCORE_QUIRK_REGDOMAIN_CONF))
+		return;
+
+	ch_bit_idx = wlcore_get_reg_conf_ch_idx(band, channel);
+
+	if (ch_bit_idx > 0 && ch_bit_idx <= WL1271_MAX_CHANNELS)
+		set_bit(ch_bit_idx, (long *)wl->reg_ch_conf_pending);
+}
+
+int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_regdomain_dfs_config *cmd = NULL;
+	int ret = 0, i, b, ch_bit_idx;
+	struct ieee80211_channel *channel;
+	u32 tmp_ch_bitmap[2];
+	u16 ch;
+	struct wiphy *wiphy = wl->hw->wiphy;
+	struct ieee80211_supported_band *band;
+	bool timeout = false;
+
+	if (!(wl->quirks & WLCORE_QUIRK_REGDOMAIN_CONF))
+		return 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd reg domain config");
+
+	memset(tmp_ch_bitmap, 0, sizeof(tmp_ch_bitmap));
+
+	for (b = IEEE80211_BAND_2GHZ; b <= IEEE80211_BAND_5GHZ; b++) {
+		band = wiphy->bands[b];
+		for (i = 0; i < band->n_channels; i++) {
+			channel = &band->channels[i];
+			ch = channel->hw_value;
+
+			if (channel->flags & (IEEE80211_CHAN_DISABLED |
+					      IEEE80211_CHAN_RADAR |
+					      IEEE80211_CHAN_PASSIVE_SCAN))
+				continue;
+
+			ch_bit_idx = wlcore_get_reg_conf_ch_idx(b, ch);
+			if (ch_bit_idx < 0)
+				continue;
+
+			set_bit(ch_bit_idx, (long *)tmp_ch_bitmap);
+		}
+	}
+
+	tmp_ch_bitmap[0] |= wl->reg_ch_conf_pending[0];
+	tmp_ch_bitmap[1] |= wl->reg_ch_conf_pending[1];
+
+	if (!memcmp(tmp_ch_bitmap, wl->reg_ch_conf_last, sizeof(tmp_ch_bitmap)))
+		goto out;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->ch_bit_map1 = cpu_to_le32(tmp_ch_bitmap[0]);
+	cmd->ch_bit_map2 = cpu_to_le32(tmp_ch_bitmap[1]);
+
+	wl1271_debug(DEBUG_CMD,
+		     "cmd reg domain bitmap1: 0x%08x, bitmap2: 0x%08x",
+		     cmd->ch_bit_map1, cmd->ch_bit_map2);
+
+	ret = wl1271_cmd_send(wl, CMD_DFS_CHANNEL_CONFIG, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send reg domain dfs config");
+		goto out;
+	}
+
+	ret = wl->ops->wait_for_event(wl,
+				      WLCORE_EVENT_DFS_CONFIG_COMPLETE,
+				      &timeout);
+	if (ret < 0 || timeout) {
+		wl1271_error("reg domain conf %serror",
+			     timeout ? "completion " : "");
+		ret = timeout ? -ETIMEDOUT : ret;
+		goto out;
+	}
+
+	memcpy(wl->reg_ch_conf_last, tmp_ch_bitmap, sizeof(tmp_ch_bitmap));
+	memset(wl->reg_ch_conf_pending, 0, sizeof(wl->reg_ch_conf_pending));
+
+out:
+	kfree(cmd);
+	return ret;
+}
+
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl)
 {
 	struct wl12xx_cmd_config_fwlog *cmd;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index c9f8268..7f378b7 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -84,6 +84,9 @@ int wl12xx_croc(struct wl1271 *wl, u8 role_id);
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			struct ieee80211_sta *sta, u8 hlid);
 int wl12xx_cmd_remove_peer(struct wl1271 *wl, u8 hlid);
+void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
+				     enum ieee80211_band band);
+int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
@@ -623,6 +626,13 @@ enum wl12xx_fwlogger_output {
 	WL12XX_FWLOG_OUTPUT_HOST,
 };
 
+struct wl12xx_cmd_regdomain_dfs_config {
+	struct wl1271_cmd_header header;
+
+	__le32 ch_bit_map1;
+	__le32 ch_bit_map2;
+} __packed;
+
 struct wl12xx_cmd_config_fwlog {
 	struct wl1271_cmd_header header;
 
diff --git a/drivers/net/wireless/ti/wlcore/event.h b/drivers/net/wireless/ti/wlcore/event.h
index 766b02f..b4353be 100644
--- a/drivers/net/wireless/ti/wlcore/event.h
+++ b/drivers/net/wireless/ti/wlcore/event.h
@@ -54,6 +54,7 @@ enum {
 enum wlcore_wait_event {
 	WLCORE_EVENT_ROLE_STOP_COMPLETE,
 	WLCORE_EVENT_PEER_REMOVE_COMPLETE,
+	WLCORE_EVENT_DFS_CONFIG_COMPLETE
 };
 
 enum {
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 06e1bf9..68828b4 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -681,6 +681,10 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	ret = wlcore_cmd_regdomain_config_locked(wl);
+	if (ret < 0)
+		return ret;
+
 	/* Bluetooth WLAN coexistence */
 	ret = wl1271_init_pta(wl);
 	if (ret < 0)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d53bb8b..221762b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -93,6 +93,8 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *ch;
 	int i;
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct wl1271 *wl = hw->priv;
 
 	band = wiphy->bands[IEEE80211_BAND_5GHZ];
 	for (i = 0; i < band->n_channels; i++) {
@@ -106,6 +108,9 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 
 	}
 
+	if (likely(wl->state == WLCORE_STATE_ON))
+		wlcore_regdomain_config(wl);
+
 	return 0;
 }
 
@@ -1900,6 +1905,12 @@ static void wlcore_op_stop_locked(struct wl1271 *wl)
 	wl->tx_res_if = NULL;
 	kfree(wl->target_mem_map);
 	wl->target_mem_map = NULL;
+
+	/*
+	 * FW channels must be re-calibrated after recovery,
+	 * clear the last Reg-Domain channel configuration.
+	 */
+	memset(wl->reg_ch_conf_last, 0, sizeof(wl->reg_ch_conf_last));
 }
 
 static void wlcore_op_stop(struct ieee80211_hw *hw)
@@ -3284,6 +3295,29 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 }
 EXPORT_SYMBOL_GPL(wlcore_set_key);
 
+void wlcore_regdomain_config(struct wl1271 *wl)
+{
+	int ret;
+
+	if (!(wl->quirks & WLCORE_QUIRK_REGDOMAIN_CONF))
+		return;
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_cmd_regdomain_config_locked(wl);
+	if (ret < 0) {
+		wl12xx_queue_recovery_work(wl);
+		goto out;
+	}
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_scan_request *req)
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 9ee0ec6..4665b96 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -97,6 +97,10 @@ static void wl1271_rx_status(struct wl1271 *wl,
 			wl1271_warning("Michael MIC error");
 		}
 	}
+
+	if (beacon)
+		wlcore_set_pending_regdomain_ch(wl, (u16)desc->channel,
+						status->band);
 }
 
 static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index eeb6188..c913700 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -80,6 +80,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 		wl12xx_queue_recovery_work(wl);
 	}
 
+	wlcore_cmd_regdomain_config_locked(wl);
+
 	ieee80211_scan_completed(wl->hw, false);
 
 out:
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index e9254b7..eacace0 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -284,11 +284,18 @@ struct wl1271 {
 	struct work_struct recovery_work;
 	bool watchdog_recovery;
 
+	/* Reg domain last configuration */
+	u32 reg_ch_conf_last[2];
+	/* Reg domain pending configuration */
+	u32 reg_ch_conf_pending[2];
+
 	/* Pointer that holds DMA-friendly block for the mailbox */
 	void *mbox;
 
 	/* The mbox event mask */
 	u32 event_mask;
+	/* Specific chip family mbox event mask */
+	u32 chip_family_event_mask;
 
 	/* Mailbox pointers */
 	u32 mbox_size;
@@ -445,6 +452,7 @@ int wlcore_set_key(struct wl1271 *wl, enum set_key_cmd cmd,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta,
 		   struct ieee80211_key_conf *key_conf);
+void wlcore_regdomain_config(struct wl1271 *wl);
 
 static inline void
 wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
@@ -503,6 +511,10 @@ wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 /* separate probe response templates for one-shot and sched scans */
 #define WLCORE_QUIRK_DUAL_PROBE_TMPL		BIT(10)
 
+/* Firmware requires reg domain configuration for active calibration */
+#define WLCORE_QUIRK_REGDOMAIN_CONF		BIT(11)
+
+
 /* TODO: move to the lower drivers when all usages are abstracted */
 #define CHIP_ID_1271_PG10              (0x4030101)
 #define CHIP_ID_1271_PG20              (0x4030111)
-- 
1.7.6.401.g6a319

