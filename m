Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56198 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbG3TuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 15:50:13 -0400
From: Yaniv Machani <yanivma@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <yanivma@ti.com>, Eliad Peller <eliad@wizery.com>
Subject: [PATCH 3/4] wlcore: add generic_cfg_feature command definitions
Date: Thu, 30 Jul 2015 22:38:21 +0300
Message-ID: <1438285102-32751-3-git-send-email-yanivma@ti.com> (sfid-20150730_215019_840368_48A70699)
In-Reply-To: <1438285102-32751-1-git-send-email-yanivma@ti.com>
References: <1438285102-32751-1-git-send-email-yanivma@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Add definitions and function prototypes for generic_cfg
command.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   30 ++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.h |   15 +++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 68919f8..dbc55a0 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -2059,3 +2059,33 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 out:
 	return ret;
 }
+
+int wlcore_cmd_generic_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			   u8 feature, u8 enable, u8 value)
+{
+	struct wlcore_cmd_generic_cfg *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_CMD,
+		     "cmd generic cfg (role %d feature %d enable %d value %d)",
+		     wlvif->role_id, feature, enable, value);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->role_id = wlvif->role_id;
+	cmd->feature = feature;
+	cmd->enable = enable;
+	cmd->value = value;
+
+	ret = wl1271_cmd_send(wl, CMD_GENERIC_CFG, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send generic cfg command");
+		goto out_free;
+	}
+out_free:
+	kfree(cmd);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wlcore_cmd_generic_cfg);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index e14cd40..8dc46c0 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -92,6 +92,8 @@ int wl12xx_cmd_remove_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 void wlcore_set_pending_regdomain_ch(struct wl1271 *wl, u16 channel,
 				     enum ieee80211_band band);
 int wlcore_cmd_regdomain_config_locked(struct wl1271 *wl);
+int wlcore_cmd_generic_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+			   u8 feature, u8 enable, u8 value);
 int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
@@ -652,6 +654,19 @@ struct wl12xx_cmd_regdomain_dfs_config {
 	u8 padding[3];
 } __packed;
 
+enum wlcore_generic_cfg_feature {
+	WLCORE_CFG_FEATURE_RADAR_DEBUG = 2,
+};
+
+struct wlcore_cmd_generic_cfg {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 feature;
+	u8 enable;
+	u8 value;
+} __packed;
+
 struct wl12xx_cmd_config_fwlog {
 	struct wl1271_cmd_header header;
 
-- 
1.7.9

