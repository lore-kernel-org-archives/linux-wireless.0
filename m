Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61381 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZLKNlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:44 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 16/31] wl1271: use channel 1 when configuring the data path
Date: Fri, 11 Dec 2009 15:40:55 +0200
Message-Id: <1260538870-32297-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the data path configuration, one of the parameters is the channel.  We
have been setting it to wl->channel, which is not correct in this case.  This
channel has nothing to do with the channel we're currently tuned to, since it
is only used for calibration during this phase.  Hardcoded the channel to 1,
according to the reference driver.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   13 +++++++------
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_init.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index ceb1ca6..20f3e67 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -505,7 +505,7 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	return 0;
 }
 
-int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
+int wl1271_cmd_data_path(struct wl1271 *wl, bool enable)
 {
 	struct cmd_enabledisable_path *cmd;
 	int ret;
@@ -519,7 +519,8 @@ int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
 		goto out;
 	}
 
-	cmd->channel = channel;
+	/* the channel here is only used for calibration, so hardcoded to 1 */
+	cmd->channel = 1;
 
 	if (enable) {
 		cmd_rx = CMD_ENABLE_RX;
@@ -532,22 +533,22 @@ int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
 	ret = wl1271_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("rx %s cmd for channel %d failed",
-			     enable ? "start" : "stop", channel);
+			     enable ? "start" : "stop", cmd->channel);
 		goto out;
 	}
 
 	wl1271_debug(DEBUG_BOOT, "rx %s cmd channel %d",
-		     enable ? "start" : "stop", channel);
+		     enable ? "start" : "stop", cmd->channel);
 
 	ret = wl1271_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("tx %s cmd for channel %d failed",
-			     enable ? "start" : "stop", channel);
+			     enable ? "start" : "stop", cmd->channel);
 		return ret;
 	}
 
 	wl1271_debug(DEBUG_BOOT, "tx %s cmd channel %d",
-		     enable ? "start" : "stop", channel);
+		     enable ? "start" : "stop", cmd->channel);
 
 out:
 	kfree(cmd);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 057f925..09fe912 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -37,7 +37,7 @@ int wl1271_cmd_join(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
-int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable);
+int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode);
 int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 			   size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 39f01d8..bdd4a96 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -289,7 +289,7 @@ int wl1271_hw_init(struct wl1271 *wl)
 		goto out_free_memmap;
 
 	/* Enable data path */
-	ret = wl1271_cmd_data_path(wl, wl->channel, 1);
+	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
 		goto out_free_memmap;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index fb22217..55a45d3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -384,7 +384,7 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	ret = wl1271_cmd_data_path(wl, wl->channel, 1);
+	ret = wl1271_cmd_data_path(wl, 1);
 	if (ret < 0)
 		return ret;
 
-- 
1.6.3.3

