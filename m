Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63811 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab2KVTPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:15:53 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so3321549eaa.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 11:15:52 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/13] wlcore: update channel_switch/stop_channel_switch commands
Date: Thu, 22 Nov 2012 14:05:22 +0200
Message-Id: <1353585928-28666-8-git-send-email-eliad@wizery.com> (sfid-20121122_201609_880090_DF28B11D)
In-Reply-To: <1353585928-28666-1-git-send-email-eliad@wizery.com>
References: <1353585928-28666-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some fields were added to the channel_switch and
stop_channel_switch commands. Unfortunately,
the new 18xx channel_switch struct is not backward
compatible with the 12xx channel switch struct.

Add a new channel_switch op to wlcore, and update
the driver accordingly.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/cmd.c    |   37 ++++++++++++++
 drivers/net/wireless/ti/wl12xx/cmd.h    |   20 ++++++++
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/Makefile |    2 +-
 drivers/net/wireless/ti/wl18xx/cmd.c    |   80 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/cmd.h    |   52 ++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |    2 +
 drivers/net/wireless/ti/wlcore/cmd.c    |   40 +--------------
 drivers/net/wireless/ti/wlcore/cmd.h    |   19 +------
 drivers/net/wireless/ti/wlcore/main.c   |    5 +-
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 +
 11 files changed, 204 insertions(+), 57 deletions(-)
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.c
 create mode 100644 drivers/net/wireless/ti/wl18xx/cmd.h

diff --git a/drivers/net/wireless/ti/wl12xx/cmd.c b/drivers/net/wireless/ti/wl12xx/cmd.c
index 6222062..7dc9f96 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.c
+++ b/drivers/net/wireless/ti/wl12xx/cmd.c
@@ -284,3 +284,40 @@ int wl128x_cmd_radio_parms(struct wl1271 *wl)
 	kfree(radio_parms);
 	return ret;
 }
+
+int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
+			      struct ieee80211_channel_switch *ch_switch)
+{
+	struct wl12xx_cmd_channel_switch *cmd;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "cmd channel switch");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = wlvif->role_id;
+	cmd->channel = ch_switch->channel->hw_value;
+	cmd->switch_time = ch_switch->count;
+	cmd->stop_tx = ch_switch->block_tx;
+
+	/* FIXME: control from mac80211 in the future */
+	/* Enable TX on the target channel */
+	cmd->post_switch_tx_disable = 0;
+
+	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send channel switch command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl12xx/cmd.h b/drivers/net/wireless/ti/wl12xx/cmd.h
index 140a0e8..32cbad5 100644
--- a/drivers/net/wireless/ti/wl12xx/cmd.h
+++ b/drivers/net/wireless/ti/wl12xx/cmd.h
@@ -103,10 +103,30 @@ struct wl1271_ext_radio_parms_cmd {
 	u8 padding[3];
 } __packed;
 
+struct wl12xx_cmd_channel_switch {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+
+	/* The new serving channel */
+	u8 channel;
+	/* Relative time of the serving channel switch in TBTT units */
+	u8 switch_time;
+	/* Stop the role TX, should expect it after radar detection */
+	u8 stop_tx;
+	/* The target channel tx status 1-stopped 0-open*/
+	u8 post_switch_tx_disable;
+
+	u8 padding[3];
+} __packed;
+
 int wl1271_cmd_general_parms(struct wl1271 *wl);
 int wl128x_cmd_general_parms(struct wl1271 *wl);
 int wl1271_cmd_radio_parms(struct wl1271 *wl);
 int wl128x_cmd_radio_parms(struct wl1271 *wl);
 int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
+int wl12xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
+			      struct ieee80211_channel_switch *ch_switch);
 
 #endif /* __WL12XX_CMD_H__ */
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0c81eeb..b93de04 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1632,6 +1632,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.sched_scan_stop	= wl12xx_scan_sched_scan_stop,
 	.get_spare_blocks	= wl12xx_get_spare_blocks,
 	.set_key		= wl12xx_set_key,
+	.channel_switch		= wl12xx_cmd_channel_switch,
 	.pre_pkt_send		= NULL,
 };
 
diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
index f742249..81a864f 100644
--- a/drivers/net/wireless/ti/wl18xx/Makefile
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -1,3 +1,3 @@
-wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o scan.o
+wl18xx-objs	= main.o acx.o tx.o io.o debugfs.o scan.o cmd.o
 
 obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.c b/drivers/net/wireless/ti/wl18xx/cmd.c
new file mode 100644
index 0000000..1d1f6cc
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/cmd.c
@@ -0,0 +1,80 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
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
+#include "../wlcore/cmd.h"
+#include "../wlcore/debug.h"
+#include "../wlcore/hw_ops.h"
+
+#include "cmd.h"
+
+int wl18xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
+			      struct ieee80211_channel_switch *ch_switch)
+{
+	struct wl18xx_cmd_channel_switch *cmd;
+	u32 supported_rates;
+	int ret;
+
+	wl1271_debug(DEBUG_ACX, "cmd channel switch");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->role_id = wlvif->role_id;
+	cmd->channel = ch_switch->channel->hw_value;
+	cmd->switch_time = ch_switch->count;
+	cmd->stop_tx = ch_switch->block_tx;
+
+	switch (ch_switch->channel->band) {
+	case IEEE80211_BAND_2GHZ:
+		cmd->band = WLCORE_BAND_2_4GHZ;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		cmd->band = WLCORE_BAND_5GHZ;
+		break;
+	default:
+		wl1271_error("invalid channel switch band: %d",
+			     ch_switch->channel->band);
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	supported_rates = CONF_TX_ENABLED_RATES | CONF_TX_MCS_RATES |
+			  wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
+	if (wlvif->p2p)
+		supported_rates &= ~CONF_TX_CCK_RATES;
+	cmd->local_supported_rates = cpu_to_le32(supported_rates);
+	cmd->channel_type = wlvif->channel_type;
+
+	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send channel switch command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
new file mode 100644
index 0000000..6687d10
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -0,0 +1,52 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments. All rights reserved.
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
+#ifndef __WL18XX_CMD_H__
+#define __WL18XX_CMD_H__
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/acx.h"
+
+struct wl18xx_cmd_channel_switch {
+	struct wl1271_cmd_header header;
+
+	u8 role_id;
+
+	/* The new serving channel */
+	u8 channel;
+	/* Relative time of the serving channel switch in TBTT units */
+	u8 switch_time;
+	/* Stop the role TX, should expect it after radar detection */
+	u8 stop_tx;
+
+	__le32 local_supported_rates;
+
+	u8 channel_type;
+	u8 band;
+
+	u8 padding[2];
+} __packed;
+
+int wl18xx_cmd_channel_switch(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
+			      struct ieee80211_channel_switch *ch_switch);
+
+#endif
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index e81b351..2e54a3e 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -34,6 +34,7 @@
 
 #include "reg.h"
 #include "conf.h"
+#include "cmd.h"
 #include "acx.h"
 #include "tx.h"
 #include "wl18xx.h"
@@ -1335,6 +1336,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.handle_static_data	= wl18xx_handle_static_data,
 	.get_spare_blocks = wl18xx_get_spare_blocks,
 	.set_key	= wl18xx_set_key,
+	.channel_switch	= wl18xx_cmd_channel_switch,
 	.pre_pkt_send	= wl18xx_pre_pkt_send,
 };
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index c8c7766..9796765 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1722,43 +1722,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_channel_switch(struct wl1271 *wl,
-			      struct wl12xx_vif *wlvif,
-			      struct ieee80211_channel_switch *ch_switch)
-{
-	struct wl12xx_cmd_channel_switch *cmd;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "cmd channel switch");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	cmd->role_id = wlvif->role_id;
-	cmd->channel = ch_switch->channel->hw_value;
-	cmd->switch_time = ch_switch->count;
-	cmd->stop_tx = ch_switch->block_tx;
-
-	/* FIXME: control from mac80211 in the future */
-	cmd->post_switch_tx_disable = 0;  /* Enable TX on the target channel */
-
-	ret = wl1271_cmd_send(wl, CMD_CHANNEL_SWITCH, cmd, sizeof(*cmd), 0);
-	if (ret < 0) {
-		wl1271_error("failed to send channel switch command");
-		goto out_free;
-	}
-
-out_free:
-	kfree(cmd);
-
-out:
-	return ret;
-}
-
-int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl)
+int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_stop_channel_switch *cmd;
 	int ret;
@@ -1771,6 +1735,8 @@ int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl)
 		goto out;
 	}
 
+	cmd->role_id = wlvif->role_id;
+
 	ret = wl1271_cmd_send(wl, CMD_STOP_CHANNEL_SWICTH, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to stop channel switch command");
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 9e9062f..96d53a7 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -89,7 +89,8 @@ int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 int wl12xx_cmd_channel_switch(struct wl1271 *wl,
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
-int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl);
+int wl12xx_cmd_stop_channel_switch(struct wl1271 *wl,
+				   struct wl12xx_vif *wlvif);
 int wl12xx_allocate_link(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			 u8 *hlid);
 void wl12xx_free_link(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 *hlid);
@@ -633,27 +634,13 @@ struct wl12xx_cmd_stop_fwlog {
 	struct wl1271_cmd_header header;
 } __packed;
 
-struct wl12xx_cmd_channel_switch {
+struct wl12xx_cmd_stop_channel_switch {
 	struct wl1271_cmd_header header;
 
 	u8 role_id;
-
-	/* The new serving channel */
-	u8 channel;
-	/* Relative time of the serving channel switch in TBTT units */
-	u8 switch_time;
-	/* Stop the role TX, should expect it after radar detection */
-	u8 stop_tx;
-	/* The target channel tx status 1-stopped 0-open*/
-	u8 post_switch_tx_disable;
-
 	u8 padding[3];
 } __packed;
 
-struct wl12xx_cmd_stop_channel_switch {
-	struct wl1271_cmd_header header;
-} __packed;
-
 /* Used to check radio status after calibration */
 #define MAX_TLV_LENGTH		500
 #define TEST_CMD_P2G_CAL	2	/* TX BiP */
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 77479cb..7c596dd 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2673,7 +2673,7 @@ static int wlcore_unset_assoc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	if (test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags)) {
 		struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 
-		wl12xx_cmd_stop_channel_switch(wl);
+		wl12xx_cmd_stop_channel_switch(wl, wlvif);
 		ieee80211_chswitch_done(vif, false);
 	}
 
@@ -4680,8 +4680,7 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 
 	/* TODO: change mac80211 to pass vif as param */
 	wl12xx_for_each_wlvif_sta(wl, wlvif) {
-		ret = wl12xx_cmd_channel_switch(wl, wlvif, ch_switch);
-
+		ret = wl->ops->channel_switch(wl, wlvif, ch_switch);
 		if (!ret)
 			set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
 	}
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 36fde4e..1ad49c9 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -95,6 +95,9 @@ struct wlcore_ops {
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta,
 		       struct ieee80211_key_conf *key_conf);
+	int (*channel_switch)(struct wl1271 *wl,
+			      struct wl12xx_vif *wlvif,
+			      struct ieee80211_channel_switch *ch_switch);
 	u32 (*pre_pkt_send)(struct wl1271 *wl, u32 buf_offset, u32 last_len);
 };
 
-- 
1.7.6.401.g6a319

