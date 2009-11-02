Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16448 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387AbZKBSWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:24 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 6/6] wl1271: Generalize command response reading
Date: Mon,  2 Nov 2009 20:22:13 +0200
Message-Id: <1257186133-18367-7-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
References: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Responses to firmware commands are read in by the command transmission
function, as part of command flow. Previously responses were read in
multiple places.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   67 ++++++++++++------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    3 +-
 2 files changed, 29 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 8acee5c..990eb01 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -42,7 +42,8 @@
  * @buf: buffer containing the command, must work with dma
  * @len: length of the buffer
  */
-int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
+int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
+		    size_t res_len)
 {
 	struct wl1271_cmd_header *cmd;
 	unsigned long timeout;
@@ -76,8 +77,9 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	}
 
 	/* read back the status code of the command */
-	wl1271_spi_read(wl, wl->cmd_box_addr, cmd,
-			sizeof(struct wl1271_cmd_header), false);
+	if (res_len == 0)
+		res_len = sizeof(struct wl1271_cmd_header);
+	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, res_len, false);
 
 	status = le16_to_cpu(cmd->status);
 	if (status != CMD_STATUS_SUCCESS) {
@@ -273,7 +275,7 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	wl->tx_security_seq_16 = 0;
 	wl->tx_security_seq_32 = 0;
 
-	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join));
+	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd join");
 		goto out_free;
@@ -305,30 +307,21 @@ out:
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 {
 	int ret;
+	size_t res_len = 0;
 
 	wl1271_debug(DEBUG_CMD, "cmd test");
 
-	ret = wl1271_cmd_send(wl, CMD_TEST, buf, buf_len);
+	if (answer)
+		res_len = buf_len;
+
+	ret = wl1271_cmd_send(wl, CMD_TEST, buf, buf_len, res_len);
 
 	if (ret < 0) {
 		wl1271_warning("TEST command failed");
 		return ret;
 	}
 
-	if (answer) {
-		struct wl1271_command *cmd_answer;
-
-		/*
-		 * The test command got in, we can read the answer.
-		 * The answer would be a wl1271_command, where the
-		 * parameter array contains the actual answer.
-		 */
-		wl1271_spi_read(wl, wl->cmd_box_addr, buf, buf_len, false);
-
-		cmd_answer = buf;
-	}
-
-	return 0;
+	return ret;
 }
 
 /**
@@ -351,16 +344,10 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	/* payload length, does not include any headers */
 	acx->len = cpu_to_le16(len - sizeof(*acx));
 
-	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx));
-	if (ret < 0) {
+	ret = wl1271_cmd_send(wl, CMD_INTERROGATE, acx, sizeof(*acx), len);
+	if (ret < 0)
 		wl1271_error("INTERROGATE command failed");
-		goto out;
-	}
-
-	/* the interrogate command got in, we can read the answer */
-	wl1271_spi_read(wl, wl->cmd_box_addr, buf, len, false);
 
-out:
 	return ret;
 }
 
@@ -384,7 +371,7 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	/* payload length, does not include any headers */
 	acx->len = cpu_to_le16(len - sizeof(*acx));
 
-	ret = wl1271_cmd_send(wl, CMD_CONFIGURE, acx, len);
+	ret = wl1271_cmd_send(wl, CMD_CONFIGURE, acx, len, 0);
 	if (ret < 0) {
 		wl1271_warning("CONFIGURE command NOK");
 		return ret;
@@ -417,7 +404,7 @@ int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
 		cmd_tx = CMD_DISABLE_TX;
 	}
 
-	ret = wl1271_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, cmd_rx, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("rx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
@@ -427,7 +414,7 @@ int wl1271_cmd_data_path(struct wl1271 *wl, u8 channel, bool enable)
 	wl1271_debug(DEBUG_BOOT, "rx %s cmd channel %d",
 		     enable ? "start" : "stop", channel);
 
-	ret = wl1271_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, cmd_tx, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("tx %s cmd for channel %d failed",
 			     enable ? "start" : "stop", channel);
@@ -469,7 +456,7 @@ int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode)
 	ps_params->null_data_rate = cpu_to_le32(1); /* 1 Mbps */
 
 	ret = wl1271_cmd_send(wl, CMD_SET_PS_MODE, ps_params,
-			      sizeof(*ps_params));
+			      sizeof(*ps_params), 0);
 	if (ret < 0) {
 		wl1271_error("cmd set_ps_mode failed");
 		goto out;
@@ -500,14 +487,14 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 	cmd->addr = cpu_to_le32(addr);
 	cmd->size = cpu_to_le32(len);
 
-	ret = wl1271_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd),
+			      sizeof(*cmd));
 	if (ret < 0) {
 		wl1271_error("read memory command failed: %d", ret);
 		goto out;
 	}
 
-	/* the read command got in, we can now read the answer */
-	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd), false);
+	/* the read command got in */
 	memcpy(answer, cmd->value, len);
 
 out:
@@ -609,7 +596,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	trigger->timeout = 0;
 
 	ret = wl1271_cmd_send(wl, CMD_TRIGGER_SCAN_TO, trigger,
-			      sizeof(*trigger));
+			      sizeof(*trigger), 0);
 	if (ret < 0) {
 		wl1271_error("trigger scan to failed for hw scan");
 		goto out;
@@ -632,7 +619,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 		}
 	}
 
-	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
+	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params), 0);
 	if (ret < 0) {
 		wl1271_error("SCAN failed");
 		wl->scanning = false;
@@ -670,7 +657,7 @@ int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 	if (buf)
 		memcpy(cmd->template_data, buf, buf_len);
 
-	ret = wl1271_cmd_send(wl, CMD_SET_TEMPLATE, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, CMD_SET_TEMPLATE, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_warning("cmd set_template failed: %d", ret);
 		goto out_free;
@@ -849,7 +836,7 @@ int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id)
 	cmd->key_action = cpu_to_le16(KEY_SET_ID);
 	cmd->key_type = KEY_WEP;
 
-	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_warning("cmd set_default_wep_key failed: %d", ret);
 		goto out;
@@ -906,7 +893,7 @@ int wl1271_cmd_set_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 
 	wl1271_dump(DEBUG_CRYPT, "TARGET KEY: ", cmd, sizeof(*cmd));
 
-	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, CMD_SET_KEYS, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_warning("could not set keys");
 		goto out;
@@ -936,7 +923,7 @@ int wl1271_cmd_disconnect(struct wl1271 *wl)
 	/* disconnect reason is not used in immediate disconnections */
 	cmd->type = DISCONNECT_IMMEDIATE;
 
-	ret = wl1271_cmd_send(wl, CMD_DISCONNECT, cmd, sizeof(*cmd));
+	ret = wl1271_cmd_send(wl, CMD_DISCONNECT, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to send disconnect command");
 		goto out_free;
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 174b820..9d7061b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -29,7 +29,8 @@
 
 struct acx_header;
 
-int wl1271_cmd_send(struct wl1271 *wl, u16 type, void *buf, size_t buf_len);
+int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
+		    size_t res_len);
 int wl1271_cmd_join(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
-- 
1.5.6.5

