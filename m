Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62134 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaL2GYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:24:34 -0500
Received: by mail-wg0-f50.google.com with SMTP id a1so18238907wgh.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Dec 2014 22:24:32 -0800 (PST)
Received: from muse.ger.corp.intel.com (85-250-108-142.bb.netvision.net.il. [85.250.108.142])
        by mx.google.com with ESMTPSA id gb10sm23488030wjb.21.2014.12.28.22.24.31
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 28 Dec 2014 22:24:32 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH 10/13] wlcore: add dfs master restart calls
Date: Mon, 29 Dec 2014 08:24:10 +0200
Message-Id: <1419834253-18331-10-git-send-email-eliad@wizery.com> (sfid-20141229_072441_453674_01D5ABE5)
In-Reply-To: <1419834253-18331-1-git-send-email-eliad@wizery.com>
References: <1419834253-18331-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

call wlcore_cmd_dfs_master_restart when starting
the ap on a new channel (after csa is done).

Add a new WLVIF_FLAG_BEACON_DISABLED flag to
indicate that dfs_master_restart command
is required.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.c      | 25 +++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/cmd.h      |  8 ++++++++
 drivers/net/wireless/ti/wl18xx/main.c     |  1 +
 drivers/net/wireless/ti/wlcore/event.c    |  1 +
 drivers/net/wireless/ti/wlcore/hw_ops.h   |  9 +++++++++
 drivers/net/wireless/ti/wlcore/main.c     | 10 +++++++++-
 drivers/net/wireless/ti/wlcore/wlcore.h   |  1 +
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  1 +
 8 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
index 5731950..a8d176d 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.c
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -229,3 +229,28 @@ out_free:
 	kfree(cmd);
 	return ret;
 }
+
+int wl18xx_cmd_dfs_master_restart(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	struct wl18xx_cmd_dfs_master_restart *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd dfs master restart (role %d)",
+		     wlvif->role_id);
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->role_id = wlvif->role_id;
+
+	ret = wl1271_cmd_send(wl, CMD_DFS_MASTER_RESTART,
+			      cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send dfs master restart command");
+		goto out_free;
+	}
+out_free:
+	kfree(cmd);
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
index 0809b92..7f9440a 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.h
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -66,6 +66,13 @@ struct wl18xx_cmd_dfs_radar_debug {
 	u8 padding[3];
 } __packed;
 
+struct wl18xx_cmd_dfs_master_restart {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+	u8 padding[3];
+} __packed;
+
 /* cac_start and cac_stop share the same params */
 struct wlcore_cmd_cac_start {
 	struct wl1271_cmd_header header;
@@ -85,4 +92,5 @@ int wl18xx_cmd_smart_config_set_group_key(struct wl1271 *wl, u16 group_id,
 					  u8 key_len, u8 *key);
 int wl18xx_cmd_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start);
 int wl18xx_cmd_radar_detection_debug(struct wl1271 *wl, u8 channel);
+int wl18xx_cmd_dfs_master_restart(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 #endif
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 48f7628..604de24 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1705,6 +1705,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.rx_ba_filter	= wl18xx_acx_rx_ba_filter,
 	.ap_sleep	= wl18xx_acx_ap_sleep,
 	.set_cac	= wl18xx_cmd_set_cac,
+	.dfs_master_restart	= wl18xx_cmd_dfs_master_restart,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 69a2661..c42e789 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -154,6 +154,7 @@ void wlcore_event_channel_switch(struct wl1271 *wl,
 			ieee80211_chswitch_done(vif, success);
 			cancel_delayed_work(&wlvif->channel_switch_work);
 		} else {
+			set_bit(WLVIF_FLAG_BEACON_DISABLED, &wlvif->flags);
 			ieee80211_csa_finish(vif);
 		}
 	}
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 42fef84..eec5693 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -320,4 +320,13 @@ wlcore_hw_set_cac(struct wl1271 *wl, struct wl12xx_vif *wlvif, bool start)
 
 	return wl->ops->set_cac(wl, wlvif, start);
 }
+
+static inline int
+wlcore_hw_dfs_master_restart(struct wl1271 *wl, struct wl12xx_vif *wlvif)
+{
+	if (!wl->ops->dfs_master_restart)
+		return -EINVAL;
+
+	return wl->ops->dfs_master_restart(wl, wlvif);
+}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9a35f30..362515f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4128,8 +4128,14 @@ static int wl1271_bss_beacon_info_changed(struct wl1271 *wl,
 		ret = wlcore_set_beacon_template(wl, vif, is_ap);
 		if (ret < 0)
 			goto out;
-	}
 
+		if (test_and_clear_bit(WLVIF_FLAG_BEACON_DISABLED,
+				       &wlvif->flags)) {
+			ret = wlcore_hw_dfs_master_restart(wl, wlvif);
+			if (ret < 0)
+				goto out;
+		}
+	}
 out:
 	if (ret != 0)
 		wl1271_error("beacon info change failed: %d", ret);
@@ -4775,6 +4781,8 @@ static int __wlcore_switch_vif_chan(struct wl1271 *wl,
 	if (WARN_ON_ONCE(wlvif->bss_type != BSS_TYPE_AP_BSS))
 		return 0;
 
+	WARN_ON(!test_bit(WLVIF_FLAG_BEACON_DISABLED, &wlvif->flags));
+
 	if (wlvif->radar_enabled) {
 		wl1271_debug(DEBUG_MAC80211, "Stop radar detection");
 		wlcore_hw_set_cac(wl, wlvif, false);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index caee58f..581c479 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -125,6 +125,7 @@ struct wlcore_ops {
 					  u8 key_len, u8 *key);
 	int (*set_cac)(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       bool start);
+	int (*dfs_master_restart)(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 };
 
 enum wlcore_partitions {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index b2bdb13..3396ce5 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -251,6 +251,7 @@ enum wl12xx_vif_flags {
 	WLVIF_FLAG_AP_PROBE_RESP_SET,
 	WLVIF_FLAG_IN_USE,
 	WLVIF_FLAG_ACTIVE,
+	WLVIF_FLAG_BEACON_DISABLED,
 };
 
 struct wl12xx_vif;
-- 
1.8.5.2.229.g4448466.dirty

