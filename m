Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58079 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaAGMG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 07:06:59 -0500
Date: Tue, 7 Jan 2014 13:06:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 04/13] wl1251: split RX and TX data path initialisation
Message-ID: <20140107120658.GD10836@amd.pavel.ucw.cz> (sfid-20140107_130702_305277_5F221052)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Gnedt <david.gnedt@davizone.at>

Split up data path initialisation into RX and TX data path initialisation
functions. This change is required for channel switching in monitor mode.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/cmd.c  |   46 +++++++++++++++++++++++----------
 drivers/net/wireless/ti/wl1251/cmd.h  |    3 ++-
 drivers/net/wireless/ti/wl1251/init.c |    9 +++++--
 3 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti/wl1251/cmd.c
index 16b6479..381b3fe 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -204,11 +204,11 @@ out:
 	return ret;
 }
 
-int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable)
+int wl1251_cmd_data_path_rx(struct wl1251 *wl, u8 channel, bool enable)
 {
 	struct cmd_enabledisable_path *cmd;
 	int ret;
-	u16 cmd_rx, cmd_tx;
+	u16 cmd_rx;
 
 	wl1251_debug(DEBUG_CMD, "cmd data path");
 
@@ -220,13 +220,10 @@ int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable)
 
 	cmd->channel = channel;
 
-	if (enable) {
+	if (enable)
 		cmd_rx = CMD_ENABLE_RX;
-		cmd_tx = CMD_ENABLE_TX;
-	} else {
+	else
 		cmd_rx = CMD_DISABLE_RX;
-		cmd_tx = CMD_DISABLE_TX;
-	}
 
 	ret = wl1251_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
 	if (ret < 0) {
@@ -238,17 +235,38 @@ int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable)
 	wl1251_debug(DEBUG_BOOT, "rx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
+out:
+	kfree(cmd);
+	return ret;
+}
+
+int wl1251_cmd_data_path_tx(struct wl1251 *wl, u8 channel, bool enable)
+{
+	struct cmd_enabledisable_path *cmd;
+	int ret;
+	u16 cmd_tx;
+
+	wl1251_debug(DEBUG_CMD, "cmd data path");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
+	cmd->channel = channel;
+
+	if (enable)
+		cmd_tx = CMD_ENABLE_TX;
+	else
+		cmd_tx = CMD_DISABLE_TX;
+
 	ret = wl1251_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
-	if (ret < 0) {
+	if (ret < 0)
 		wl1251_error("tx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
-		goto out;
-	}
-
-	wl1251_debug(DEBUG_BOOT, "tx %s cmd channel %d",
-		     enable ? "start" : "stop", channel);
+	else
+		wl1251_debug(DEBUG_BOOT, "tx %s cmd channel %d",
+			     enable ? "start" : "stop", channel);
 
-out:
 	kfree(cmd);
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wl1251/cmd.h b/drivers/net/wireless/ti/wl1251/cmd.h
index 126f273..d824ff9 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.h
+++ b/drivers/net/wireless/ti/wl1251/cmd.h
@@ -35,7 +35,8 @@ int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void *buf, size_t len);
 int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len);
 int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
-int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
+int wl1251_cmd_data_path_rx(struct wl1251 *wl, u8 channel, bool enable);
+int wl1251_cmd_data_path_tx(struct wl1251 *wl, u8 channel, bool enable);
 int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 		    u16 beacon_interval, u8 dtim_interval);
 int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
diff --git a/drivers/net/wireless/ti/wl1251/init.c b/drivers/net/wireless/ti/wl1251/init.c
index a6ad223..424ce01 100644
--- a/drivers/net/wireless/ti/wl1251/init.c
+++ b/drivers/net/wireless/ti/wl1251/init.c
@@ -390,8 +390,13 @@ int wl1251_hw_init(struct wl1251 *wl)
 	if (ret < 0)
 		goto out_free_data_path;
 
-	/* Enable data path */
-	ret = wl1251_cmd_data_path(wl, wl->channel, 1);
+	/* Enable rx data path */
+	ret = wl1251_cmd_data_path_rx(wl, wl->channel, 1);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Enable tx data path */
+	ret = wl1251_cmd_data_path_tx(wl, wl->channel, 1);
 	if (ret < 0)
 		goto out_free_data_path;
 
-- 
1.7.9.5



----- End forwarded message -----

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
