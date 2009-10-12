Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49269 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbZJLMNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:30 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/16] wl1271: implement cmd_disconnect
Date: Mon, 12 Oct 2009 15:08:42 +0300
Message-Id: <1255349337-9776-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the CMD_DISCONNECT command, which should be sent to the
firmware when we are disassociated.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   32 +++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   27 +++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index ac93efd..d09ad12 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -191,7 +191,6 @@ int wl1271_cmd_join(struct wl1271 *wl)
 			do_cal = false;
 	}
 
-
 	join = kzalloc(sizeof(*join), GFP_KERNEL);
 	if (!join) {
 		ret = -ENOMEM;
@@ -825,3 +824,34 @@ out:
 
 	return ret;
 }
+
+int wl1271_cmd_disconnect(struct wl1271 *wl)
+{
+	struct wl1271_cmd_disconnect *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd disconnect");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->rx_config_options = wl->rx_config;
+	cmd->rx_filter_options = wl->rx_filter;
+	/* disconnect reason is not used in immediate disconnections */
+	cmd->type = DISCONNECT_IMMEDIATE;
+
+	ret = wl1271_cmd_send(wl, CMD_DISCONNECT, cmd, sizeof(*cmd));
+	if (ret < 0) {
+		wl1271_error("failed to send disconnect command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 63bc441..0219664 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -50,6 +50,7 @@ int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
 int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16);
+int wl1271_cmd_disconnect(struct wl1271 *wl);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -461,4 +462,30 @@ struct wl1271_cmd_cal_p2g {
 	u8  padding2;
 } __attribute__ ((packed));
 
+
+/*
+ * There are three types of disconnections:
+ *
+ * DISCONNECT_IMMEDIATE: the fw doesn't send any frames
+ * DISCONNECT_DEAUTH:    the fw generates a DEAUTH request with the reason
+ *                       we have passed
+ * DISCONNECT_DISASSOC:  the fw generates a DESASSOC request with the reason
+ *                       we have passed
+ */
+enum wl1271_disconnect_type {
+	DISCONNECT_IMMEDIATE,
+	DISCONNECT_DEAUTH,
+	DISCONNECT_DISASSOC
+};
+
+struct wl1271_cmd_disconnect {
+	u32 rx_config_options;
+	u32 rx_filter_options;
+
+	u16 reason;
+	u8  type;
+
+	u8  padding;
+} __attribute__ ((packed));
+
 #endif /* __WL1271_CMD_H__ */
-- 
1.5.6.5

