Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:54046 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1A3STf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:35 -0500
Message-ID: <4D45A5D6.6020506@davizone.at>
Date: Sun, 30 Jan 2011 18:54:30 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 10/18] wl1251: split RX and TX data path initialisation
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split up data path initialisation into RX and TX data path initialisation
functions. This change is required for channel switching in monitor mode.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/cmd.c  |   37 +++++++++++++++++++++++++++++------
 drivers/net/wireless/wl1251/cmd.h  |    3 +-
 drivers/net/wireless/wl1251/init.c |    9 ++++++-
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl1251/cmd.c b/drivers/net/wireless/wl1251/cmd.c
index 4e4987d..886da13 100644
--- a/drivers/net/wireless/wl1251/cmd.c
+++ b/drivers/net/wireless/wl1251/cmd.c
@@ -203,11 +203,11 @@ out:
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
 @@ -219,13 +219,10 @@ int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel,
bool enable)
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
@@ -237,6 +234,32 @@ int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel,
bool enable)
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
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->channel = channel;
+
+	if (enable)
+		cmd_tx = CMD_ENABLE_TX;
+	else
+		cmd_tx = CMD_DISABLE_TX;
+
 	ret = wl1251_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
 	if (ret < 0) {
 		wl1251_error("tx %s cmd for channel %d failed",
diff --git a/drivers/net/wireless/wl1251/cmd.h b/drivers/net/wireless/wl1251/cmd.h
index c4ed9cd..48bef36 100644
--- a/drivers/net/wireless/wl1251/cmd.h
+++ b/drivers/net/wireless/wl1251/cmd.h
@@ -35,7 +35,8 @@ int wl1251_cmd_interrogate(struct wl1251 *wl, u16 id, void
*buf, size_t len);
 int wl1251_cmd_configure(struct wl1251 *wl, u16 id, void *buf, size_t len);
 int wl1251_cmd_vbm(struct wl1251 *wl, u8 identity,
 		   void *bitmap, u16 bitmap_len, u8 bitmap_control);
-int wl1251_cmd_data_path(struct wl1251 *wl, u8 channel, bool enable);
+int wl1251_cmd_data_path_rx(struct wl1251 *wl, u8 channel, bool enable);
+int wl1251_cmd_data_path_tx(struct wl1251 *wl, u8 channel, bool enable);
 int wl1251_cmd_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 		    u16 beacon_interval, u8 dtim_interval);
 int wl1251_cmd_ps_mode(struct wl1251 *wl, u8 ps_mode);
diff --git a/drivers/net/wireless/wl1251/init.c b/drivers/net/wireless/wl1251/init.c
index a6ad223..424ce01 100644
--- a/drivers/net/wireless/wl1251/init.c
+++ b/drivers/net/wireless/wl1251/init.c
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
 -- 1.7.0.4


