Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41456 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaL2GY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:29 -0500
Received: by mail-wg0-f53.google.com with SMTP id x13so363121wgg.12
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:28 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.26
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:27 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/13] wl18xx: add radar detection implementation
Date: Mon, 29 Dec 2014 08:24:07 +0200
Message-Id: <1419834253-18331-7-git-send-email-eliad@wizery.com> (sfid-20141229_072438_488860_7FA53DB9)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for CAC start/stop commands, and pass
radar detection events from the fw to mac80211.

Bump fw name (to wl18xx-fw-4.bin) and min fw version
(to 8.9.*.*.11), and align event mailbox accordingly.

Signed-off-by: Guy Mishol <guym@ti.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.c      |  31 ++++++
 drivers/net/wireless/ti/wl18xx/cmd.h      |  11 +++
 drivers/net/wireless/ti/wl18xx/event.c    |  21 ++++
 drivers/net/wireless/ti/wl18xx/event.h    |  14 ++-
 drivers/net/wireless/ti/wl18xx/main.c     |   4 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h   |   4 +-
 drivers/net/wireless/ti/wlcore/cmd.c      |   3 +-
 drivers/net/wireless/ti/wlcore/cmd.h      |   6 ++
 drivers/net/wireless/ti/wlcore/hw_ops.h   |   9 ++
 drivers/net/wireless/ti/wlcore/main.c     | 159 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |   2 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |   2 +
 12 files changed, 257 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 44f0b20..10f9d1c 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -167,3 +167,34 @@ out_free:
 out:
 	return ret;
 }
+
+int wl18xx_cmd_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start)
+{
+	struct wlcore_cmd_cac_start *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd cac (channel %d) %s",
+		     wlvif->channel, start ? "start" : "stop");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->role_id = wlvif->role_id;
+	cmd->channel = wlvif->channel;
+	if (wlvif->band == IEEE80211_BAND_5GHZ)
+		cmd->band = WLCORE_BAND_5GHZ;
+	cmd->bandwidth = wlcore_get_native_channel_type(wlvif->channel_type);
+
+	ret = wl1271_cmd_send(wl,
+			      start ? CMD_CAC_START : CMD_CAC_STOP,
+			      cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send cac command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
index 92499e2..91b3e2f 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.h
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -59,6 +59,16 @@ struct wl18xx_cmd_smart_config_set_group_key {
 	u8 key[16];
 } __packed;
 
+/* cac_start and cac_stop share the same params */
+struct wlcore_cmd_cac_start {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 channel;
+	u8 band;
+	u8 bandwidth;
+} __packed;
+
 int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
@@ -66,4 +76,5 @@ int wl18xx_cmd_smart_config_start(struct wl1271 *wl, u32 group_bitmap);
 int wl18xx_cmd_smart_config_stop(struct wl1271 *wl);
 int wl18xx_cmd_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
 					  u8 key_len, u8 *key);
+int wl18xx_cmd_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start);
 #endif
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index eb1848e..c28f068 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -47,6 +47,19 @@ int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
 	return wlcore_cmd_wait_for_event_or_timeout(wl, local_event, timeout);
 }
 
+static const char *wl18xx_radar_type_decode(u8 radar_type)
+{
+	switch (radar_type) {
+	case RADAR_TYPE_REGULAR:
+		return "REGULAR";
+	case RADAR_TYPE_CHIRP:
+		return "CHIRP";
+	case RADAR_TYPE_NONE:
+	default:
+		return "N/A";
+	}
+}
+
 static int wlcore_smart_config_sync_event(struct wl1271 *wl, u8 sync_channel,
 					  u8 sync_band)
 {
@@ -115,6 +128,14 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 			wl18xx_scan_completed(wl, wl->scan_wlvif);
 	}
 
+	if (vector & RADAR_DETECTED_EVENT_ID) {
+		wl1271_info("radar event: channel %d type %s",
+			    mbox->radar_channel,
+			    wl18xx_radar_type_decode(mbox->radar_type));
+
+		ieee80211_radar_detected(wl->hw);
+	}
+
 	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT,
 			     "PERIODIC_SCAN_REPORT_EVENT (results %d)",
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index 0680312..266ee87 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -42,6 +42,12 @@ enum {
 	SMART_CONFIG_DECODE_EVENT_ID		 = BIT(23),
 };
 
+enum wl18xx_radar_types {
+	RADAR_TYPE_NONE,
+	RADAR_TYPE_REGULAR,
+	RADAR_TYPE_CHIRP
+};
+
 struct wl18xx_event_mailbox {
 	__le32 events_vector;
 
@@ -83,13 +89,19 @@ struct wl18xx_event_mailbox {
 	u8 sc_token_len;
 	u8 padding1;
 	u8 sc_ssid[32];
-	u8 sc_pwd[32];
+	u8 sc_pwd[64];
 	u8 sc_token[32];
 
 	/* smart config sync channel */
 	u8 sc_sync_channel;
 	u8 sc_sync_band;
 	u8 padding2[2];
+
+	/* radar detect */
+	u8 radar_channel;
+	u8 radar_type;
+
+	u8 padding3[2];
 } __packed;
 
 int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 9e648a1..48f7628 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -655,7 +655,7 @@ static const struct wl18xx_clk_cfg wl18xx_clk_table[NUM_CLOCK_CONFIGS] = {
 };
 
 /* TODO: maybe move to a new header file? */
-#define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw-3.bin"
+#define WL18XX_FW_NAME "ti-connectivity/wl18xx-fw-4.bin"
 
 static int wl18xx_identify_chip(struct wl1271 *wl)
 {
@@ -990,6 +990,7 @@ static int wl18xx_boot(struct wl1271 *wl)
 
 	wl->event_mask = BSS_LOSS_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
+		RADAR_DETECTED_EVENT_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PERIODIC_SCAN_COMPLETE_EVENT_ID |
 		PERIODIC_SCAN_REPORT_EVENT_ID |
@@ -1703,6 +1704,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.interrupt_notify = wl18xx_acx_interrupt_notify_config,
 	.rx_ba_filter	= wl18xx_acx_rx_ba_filter,
 	.ap_sleep	= wl18xx_acx_ap_sleep,
+	.set_cac	= wl18xx_cmd_set_cac,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 6a2b880..71e9e38 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -26,10 +26,10 @@
 
 /* minimum FW required for driver */
 #define WL18XX_CHIP_VER		8
-#define WL18XX_IFTYPE_VER	8
+#define WL18XX_IFTYPE_VER	9
 #define WL18XX_MAJOR_VER	WLCORE_FW_VER_IGNORE
 #define WL18XX_SUBTYPE_VER	WLCORE_FW_VER_IGNORE
-#define WL18XX_MINOR_VER	13
+#define WL18XX_MINOR_VER	11
 
 #define WL18XX_CMD_MAX_SIZE          740
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index b826619..aacad4e 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -403,7 +403,7 @@ void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid)
 	WARN_ON_ONCE(wl->active_link_count < 0);
 }
 
-static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
+u8 wlcore_get_native_channel_type(u8 nl_channel_type)
 {
 	switch (nl_channel_type) {
 	case NL80211_CHAN_NO_HT:
@@ -419,6 +419,7 @@ static u8 wlcore_get_native_channel_type(u8 nl_channel_type)
 		return WLCORE_CHAN_NO_HT;
 	}
 }
+EXPORT_SYMBOL_GPL(wlcore_get_native_channel_type);
 
 static int wl12xx_cmd_role_start_dev(struct wl1271 *wl,
 				     struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 453684a..06bdee2 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -105,6 +105,7 @@ int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid);
 int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 					 u32 mask, bool *timeout);
+u8 wlcore_get_native_channel_type(u8 nl_channel_type);
 
 enum wl1271_commands {
 	CMD_INTERROGATE	= 1, /* use this to read information elements */
@@ -172,6 +173,11 @@ enum wl1271_commands {
 	CMD_SMART_CONFIG_STOP		= 62,
 	CMD_SMART_CONFIG_SET_GROUP_KEY	= 63,
 
+	CMD_CAC_START			= 64,
+	CMD_CAC_STOP			= 65,
+	CMD_DFS_MASTER_RESTART		= 66,
+	CMD_DFS_RADAR_DETECTION_DEBUG	= 67,
+
 	MAX_COMMAND_ID = 0xFFFF,
 };
 
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 449050b..42fef84 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -311,4 +311,13 @@ wlcore_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
 
 	return wl->ops->smart_config_set_group_key(wl, group_id, key_len, key);
 }
+
+static inline int
+wlcore_hw_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start)
+{
+	if (!wl->ops->set_cac)
+		return -EINVAL;
+
+	return wl->ops->set_cac(wl, wlvif, start);
+}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 0d67e39..673bfc4 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4630,10 +4630,46 @@ static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
 				     struct ieee80211_chanctx_conf *ctx,
 				     u32 changed)
 {
+	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif;
+	int ret;
+	int channel = ieee80211_frequency_to_channel(
+		ctx->def.chan->center_freq);
+
 	wl1271_debug(DEBUG_MAC80211,
 		     "mac80211 change chanctx %d (type %d) changed 0x%x",
-		     ieee80211_frequency_to_channel(ctx->def.chan->center_freq),
-		     cfg80211_get_chandef_type(&ctx->def), changed);
+		     channel, cfg80211_get_chandef_type(&ctx->def), changed);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl12xx_for_each_wlvif(wl, wlvif) {
+		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
+
+		rcu_read_lock();
+		if (rcu_access_pointer(vif->chanctx_conf) != ctx) {
+			rcu_read_unlock();
+			continue;
+		}
+		rcu_read_unlock();
+
+		/* start radar if needed */
+		if (changed & IEEE80211_CHANCTX_CHANGE_RADAR &&
+		    wlvif->bss_type == BSS_TYPE_AP_BSS &&
+		    ctx->radar_enabled && !wlvif->radar_enabled &&
+		    ctx->def.chan->dfs_state == NL80211_DFS_USABLE) {
+			wl1271_debug(DEBUG_MAC80211, "Start radar detection");
+			wlcore_hw_set_cac(wl, wlvif, true);
+			wlvif->radar_enabled = true;
+		}
+	}
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
 }
 
 static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
@@ -4644,13 +4680,26 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	int channel = ieee80211_frequency_to_channel(
 		ctx->def.chan->center_freq);
+	int ret = -EINVAL;
 
 	wl1271_debug(DEBUG_MAC80211,
-		     "mac80211 assign chanctx (role %d) %d (type %d)",
-		     wlvif->role_id, channel, cfg80211_get_chandef_type(&ctx->def));
+		     "mac80211 assign chanctx (role %d) %d (type %d) (radar %d dfs_state %d)",
+		     wlvif->role_id, channel,
+		     cfg80211_get_chandef_type(&ctx->def),
+		     ctx->radar_enabled, ctx->def.chan->dfs_state);
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
 	wlvif->band = ctx->def.chan->band;
 	wlvif->channel = channel;
 	wlvif->channel_type = cfg80211_get_chandef_type(&ctx->def);
@@ -4658,6 +4707,15 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	/* update default rates according to the band */
 	wl1271_set_band_rate(wl, wlvif);
 
+	if (ctx->radar_enabled &&
+	    ctx->def.chan->dfs_state == NL80211_DFS_USABLE) {
+		wl1271_debug(DEBUG_MAC80211, "Start radar detection");
+		wlcore_hw_set_cac(wl, wlvif, true);
+		wlvif->radar_enabled = true;
+	}
+
+	wl1271_ps_elp_sleep(wl);
+out:
 	mutex_unlock(&wl->mutex);
 
 	return 0;
@@ -4669,6 +4727,7 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211,
 		     "mac80211 unassign chanctx (role %d) %d (type %d)",
@@ -4677,6 +4736,97 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		     cfg80211_get_chandef_type(&ctx->def));
 
 	wl1271_tx_flush(wl);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
+	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
+		goto out;
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	if (wlvif->radar_enabled) {
+		wl1271_debug(DEBUG_MAC80211, "Stop radar detection");
+		wlcore_hw_set_cac(wl, wlvif, false);
+		wlvif->radar_enabled = false;
+	}
+
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+}
+
+static int __wlcore_switch_vif_chan(struct wl1271 *wl,
+				    struct wl12xx_vif *wlvif,
+				    struct ieee80211_chanctx_conf *new_ctx)
+{
+	int channel = ieee80211_frequency_to_channel(
+		new_ctx->def.chan->center_freq);
+
+	wl1271_debug(DEBUG_MAC80211,
+		     "switch vif (role %d) %d -> %d chan_type: %d",
+		     wlvif->role_id, wlvif->channel, channel,
+		     cfg80211_get_chandef_type(&new_ctx->def));
+
+	if (WARN_ON_ONCE(wlvif->bss_type != BSS_TYPE_AP_BSS))
+		return 0;
+
+	if (wlvif->radar_enabled) {
+		wl1271_debug(DEBUG_MAC80211, "Stop radar detection");
+		wlcore_hw_set_cac(wl, wlvif, false);
+		wlvif->radar_enabled = false;
+	}
+
+	wlvif->band = new_ctx->def.chan->band;
+	wlvif->channel = channel;
+	wlvif->channel_type = cfg80211_get_chandef_type(&new_ctx->def);
+
+	/* start radar if needed */
+	if (new_ctx->radar_enabled) {
+		wl1271_debug(DEBUG_MAC80211, "Start radar detection");
+		wlcore_hw_set_cac(wl, wlvif, true);
+		wlvif->radar_enabled = true;
+	}
+
+	return 0;
+}
+
+static int
+wlcore_op_switch_vif_chanctx(struct ieee80211_hw *hw,
+			     struct ieee80211_vif_chanctx_switch *vifs,
+			     int n_vifs,
+			     enum ieee80211_chanctx_switch_mode mode)
+{
+	struct wl1271 *wl = hw->priv;
+	int i, ret;
+
+	wl1271_debug(DEBUG_MAC80211,
+		     "mac80211 switch chanctx n_vifs %d mode %d",
+		     n_vifs, mode);
+
+	mutex_lock(&wl->mutex);
+
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	for (i = 0; i < n_vifs; i++) {
+		struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vifs[i].vif);
+
+		ret = __wlcore_switch_vif_chan(wl, wlvif, vifs[i].new_ctx);
+		if (ret)
+			goto out_sleep;
+	}
+out_sleep:
+	wl1271_ps_elp_sleep(wl);
+out:
+	mutex_unlock(&wl->mutex);
+
+	return 0;
 }
 
 static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
@@ -5666,6 +5816,7 @@ static const struct ieee80211_ops wl1271_ops = {
 	.change_chanctx = wlcore_op_change_chanctx,
 	.assign_vif_chanctx = wlcore_op_assign_vif_chanctx,
 	.unassign_vif_chanctx = wlcore_op_unassign_vif_chanctx,
+	.switch_vif_chanctx = wlcore_op_switch_vif_chanctx,
 	.sta_rc_update = wlcore_op_sta_rc_update,
 	.get_rssi = wlcore_op_get_rssi,
 	CFG80211_TESTMODE_CMD(wl1271_tm_cmd)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index c8fe2ae..caee58f 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -123,6 +123,8 @@ struct wlcore_ops {
 	int (*smart_config_stop)(struct wl1271 *wl);
 	int (*smart_config_set_group_key)(struct wl1271 *wl, u16 group_id,
 					  u8 key_len, u8 *key);
+	int (*set_cac)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+		       bool start);
 };
 
 enum wlcore_partitions {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 811851d..b2bdb13 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -434,6 +434,8 @@ struct wl12xx_vif {
 
 	bool wmm_enabled;
 
+	bool radar_enabled;
+
 	/* Rx Streaming */
 	struct work_struct rx_streaming_enable_work;
 	struct work_struct rx_streaming_disable_work;
-- 
1.8.5.2.229.g4448466.dirty

