Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:42922 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaGKACL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:11 -0400
Received: by mail-wg0-f47.google.com with SMTP id y10so286230wgg.18
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:07 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/14] wlcore/wl18xx: add smart config commands
Date: Fri, 11 Jul 2014 03:01:31 +0300
Message-Id: <1405036899-27396-7-git-send-email-eliad@wizery.com> (sfid-20140711_020217_286294_77711D3E)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These commands configures the fw to set key,
enter smart config mode, and exit it.

Add relevant hw ops as well.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.c    | 89 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/cmd.h    |  5 +-
 drivers/net/wireless/ti/wl18xx/main.c   |  3 ++
 drivers/net/wireless/ti/wlcore/hw_ops.h | 27 ++++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |  4 ++
 5 files changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 7649c75..44f0b20 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -78,3 +78,92 @@ out_free:
 out:
 	return ret;
 }
+
+int wl18xx_cmd_smart_config_start(struct wl1271 *wl, u32 group_bitmap)
+{
+	struct wl18xx_cmd_smart_config_start *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd smart config start group_bitmap=0x%x",
+		     group_bitmap);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->group_id_bitmask = cpu_to_le32(group_bitmap);
+
+	ret = wl1271_cmd_send(wl, CMD_SMART_CONFIG_START, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send smart config start command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+out:
+	return ret;
+}
+
+int wl18xx_cmd_smart_config_stop(struct wl1271 *wl)
+{
+	struct wl1271_cmd_header *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd smart config stop");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_SMART_CONFIG_STOP, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send smart config stop command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+out:
+	return ret;
+}
+
+int wl18xx_cmd_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
+					  u8 key_len, u8 *key)
+{
+	struct wl18xx_cmd_smart_config_set_group_key *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd smart config set group key id=0x%x",
+		     group_id);
+
+	if (key_len != sizeof(cmd->key)) {
+		wl1271_error("invalid group key size: %d", key_len);
+		return -E2BIG;
+	}
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->group_id = cpu_to_le32(group_id);
+	memcpy(cmd->key, key, key_len);
+
+	ret = wl1271_cmd_send(wl, CMD_SMART_CONFIG_SET_GROUP_KEY, cmd,
+			      sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send smart config set group key cmd");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
index 03b746b..92499e2 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.h
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -62,5 +62,8 @@ struct wl18xx_cmd_smart_config_set_group_key {
 int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
-
+int wl18xx_cmd_smart_config_start(struct wl1271 *wl, u32 group_bitmap);
+int wl18xx_cmd_smart_config_stop(struct wl1271 *wl);
+int wl18xx_cmd_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
+					  u8 key_len, u8 *key);
 #endif
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index de5b4fa..2727ca3 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1687,6 +1687,9 @@ static struct wlcore_ops wl18xx_ops = {
 	.convert_hwaddr = wl18xx_convert_hwaddr,
 	.lnk_high_prio	= wl18xx_lnk_high_prio,
 	.lnk_low_prio	= wl18xx_lnk_low_prio,
+	.smart_config_start = wl18xx_cmd_smart_config_start,
+	.smart_config_stop  = wl18xx_cmd_smart_config_stop,
+	.smart_config_set_group_key = wl18xx_cmd_smart_config_set_group_key,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 1555ff9..aa9f82c 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -260,4 +260,31 @@ wlcore_hw_lnk_low_prio(struct wl1271 *wl, u8 hlid,
 	return wl->ops->lnk_low_prio(wl, hlid, lnk);
 }
 
+static inline int
+wlcore_smart_config_start(struct wl1271 *wl, u32 group_bitmap)
+{
+	if (!wl->ops->smart_config_start)
+		return -EINVAL;
+
+	return wl->ops->smart_config_start(wl, group_bitmap);
+}
+
+static inline int
+wlcore_smart_config_stop(struct wl1271 *wl)
+{
+	if (!wl->ops->smart_config_stop)
+		return -EINVAL;
+
+	return wl->ops->smart_config_stop(wl);
+}
+
+static inline int
+wlcore_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
+				  u8 key_len, u8 *key)
+{
+	if (!wl->ops->smart_config_set_group_key)
+		return -EINVAL;
+
+	return wl->ops->smart_config_set_group_key(wl, group_id, key_len, key);
+}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 7132050..13459c4 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -117,6 +117,10 @@ struct wlcore_ops {
 			      struct wl1271_link *lnk);
 	bool (*lnk_low_prio)(struct wl1271 *wl, u8 hlid,
 			     struct wl1271_link *lnk);
+	int (*smart_config_start)(struct wl1271 *wl, u32 group_bitmap);
+	int (*smart_config_stop)(struct wl1271 *wl);
+	int (*smart_config_set_group_key)(struct wl1271 *wl, u16 group_id,
+					  u8 key_len, u8 *key);
 };
 
 enum wlcore_partitions {
-- 
1.8.5.1.109.g3d252a9

