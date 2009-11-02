Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51461 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbZKBSW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:27 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 3/6] wl1271: Check result code of commands
Date: Mon,  2 Nov 2009 20:22:10 +0200
Message-Id: <1257186133-18367-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
References: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Check the result code of all commands, and return an error code if the
firmware reports an error in execution. Previously this error would go
ignored in most cases.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   34 +++++++---------------------
 drivers/net/wireless/wl12xx/wl1271_init.c |    7 ++++-
 2 files changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0666328..46e5ea4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -74,6 +74,15 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len)
 		intr = wl1271_spi_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
 	}
 
+	/* read back the status code of the command */
+	wl1271_spi_read(wl, wl->cmd_box_addr, cmd,
+			sizeof(struct wl1271_cmd_header), false);
+
+	if (cmd->status != CMD_STATUS_SUCCESS) {
+		wl1271_error("command execute failure %d", cmd->status);
+		ret = -EIO;
+	}
+
 	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_ACK,
 			   WL1271_ACX_INTR_CMD_COMPLETE);
 
@@ -306,7 +315,6 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 
 	if (answer) {
 		struct wl1271_command *cmd_answer;
-		u16 status;
 
 		/*
 		 * The test command got in, we can read the answer.
@@ -316,10 +324,6 @@ int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer)
 		wl1271_spi_read(wl, wl->cmd_box_addr, buf, buf_len, false);
 
 		cmd_answer = buf;
-		status = le16_to_cpu(cmd_answer->header.status);
-
-		if (status != CMD_STATUS_SUCCESS)
-			wl1271_error("TEST command answer error: %d", status);
 	}
 
 	return 0;
@@ -354,11 +358,6 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	/* the interrogate command got in, we can read the answer */
 	wl1271_spi_read(wl, wl->cmd_box_addr, buf, len, false);
 
-	acx = buf;
-	if (le16_to_cpu(acx->cmd.status) != CMD_STATUS_SUCCESS)
-		wl1271_error("INTERROGATE command error: %d",
-			     le16_to_cpu(acx->cmd.status));
-
 out:
 	return ret;
 }
@@ -507,11 +506,6 @@ int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
 
 	/* the read command got in, we can now read the answer */
 	wl1271_spi_read(wl, wl->cmd_box_addr, cmd, sizeof(*cmd), false);
-
-	if (le16_to_cpu(cmd->header.status) != CMD_STATUS_SUCCESS)
-		wl1271_error("error in read command result: %d",
-			     le16_to_cpu(cmd->header.status));
-
 	memcpy(answer, cmd->value, len);
 
 out:
@@ -639,17 +633,7 @@ int wl1271_cmd_scan(struct wl1271 *wl, u8 *ssid, size_t len,
 	ret = wl1271_cmd_send(wl, CMD_SCAN, params, sizeof(*params));
 	if (ret < 0) {
 		wl1271_error("SCAN failed");
-		goto out;
-	}
-
-	wl1271_spi_read(wl, wl->cmd_box_addr, params, sizeof(*params),
-			false);
-
-	if (le16_to_cpu(params->header.status) != CMD_STATUS_SUCCESS) {
-		wl1271_error("Scan command error: %d",
-			     le16_to_cpu(params->header.status));
 		wl->scanning = false;
-		ret = -EIO;
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 417b415..7c2017f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -303,12 +303,15 @@ int wl1271_hw_init(struct wl1271 *wl)
 {
 	int ret;
 
+	/* FIXME: the following parameter setting functions return error
+	 * codes - the reason is so far unknown. The -EIO is therefore
+	 * ignored for the time being. */
 	ret = wl1271_init_general_parms(wl);
-	if (ret < 0)
+	if (ret < 0 && ret != -EIO)
 		return ret;
 
 	ret = wl1271_init_radio_parms(wl);
-	if (ret < 0)
+	if (ret < 0 && ret != -EIO)
 		return ret;
 
 	/* Template settings */
-- 
1.5.6.5

