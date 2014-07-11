Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36213 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaGKACE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 20:02:04 -0400
Received: by mail-wg0-f43.google.com with SMTP id b13so288463wgh.26
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2014 17:02:02 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/14] wlcore: add smart config definitions
Date: Fri, 11 Jul 2014 03:01:30 +0300
Message-Id: <1405036899-27396-6-git-send-email-eliad@wizery.com> (sfid-20140711_020209_393331_E29E0549)
In-Reply-To: <1405036899-27396-1-git-send-email-eliad@wizery.com>
References: <1405036899-27396-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add definitions for the smart config commands.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/cmd.h | 14 ++++++++++++++
 drivers/net/wireless/ti/wlcore/cmd.h |  3 +++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/cmd.h b/drivers/net/wireless/ti/wl18xx/cmd.h
index 6687d10..03b746b 100644
--- a/drivers/net/wireless/ti/wl18xx/cmd.h
+++ b/drivers/net/wireless/ti/wl18xx/cmd.h
@@ -45,6 +45,20 @@ struct wl18xx_cmd_channel_switch {
 	u8 padding[2];
 } __packed;
 
+struct wl18xx_cmd_smart_config_start {
+	struct wl1271_cmd_header header;
+
+	__le32 group_id_bitmask;
+} __packed;
+
+struct wl18xx_cmd_smart_config_set_group_key {
+	struct wl1271_cmd_header header;
+
+	__le32 group_id;
+
+	u8 key[16];
+} __packed;
+
 int wl18xx_cmd_channel_switch(struct wl1271 *wl,
 			      struct wl12xx_vif *wlvif,
 			      struct ieee80211_channel_switch *ch_switch);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 6788d73..ca6a28b 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -170,6 +170,9 @@ enum wl1271_commands {
 
 	/* start of 18xx specific commands */
 	CMD_DFS_CHANNEL_CONFIG		= 60,
+	CMD_SMART_CONFIG_START		= 61,
+	CMD_SMART_CONFIG_STOP		= 62,
+	CMD_SMART_CONFIG_SET_GROUP_KEY	= 63,
 
 	MAX_COMMAND_ID = 0xFFFF,
 };
-- 
1.8.5.1.109.g3d252a9

