Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64794 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZFLLQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:34 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 18/33] wl12xx: Fix CMD_TEST regression via netlink.
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:13 +0300
Message-ID: <20090612111612.8877.71819.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ari Kauppi <Ext-Ari.Kauppi@nokia.com>

CMD_TEST via netlink API has been broken since
e29c3f59cfbc38c3b481a2694b08962da19c4664: cmd and acx interface rework.

The user of the interface sends the request in a buffer without the
wl12xx_command header but expects the response to have the wl12xx_command
header (with id and status).

This patch reverts the e29c3f5 commit for cmd.c:wl12xx_cmd_test
and implements the needed wrapper functionality in netlink.c. Now the
API of wl12xx_cmd_test and rest of wl12xx_cmd_* commands in cmd.c are
similar.

Signed-off-by: Ari Kauppi <Ext-Ari.Kauppi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/cmd.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d98941a..04e8401 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -66,38 +66,26 @@ out:
  * send test command to firmware
  *
  * @wl: wl struct
- * @buf: buffer containing the command, without headers, no dma requirements
+ * @buf: buffer containing the command, with all headers, must work with dma
  * @len: length of the buffer
  * @answer: is answer needed
- *
- * FIXME: cmd_test users need to be converted to the new interface
  */
 int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 {
-	struct wl12xx_command *cmd;
-	size_t cmd_len;
 	int ret;
 
 	wl12xx_debug(DEBUG_CMD, "cmd test");
 
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	memcpy(cmd->parameters, buf, buf_len);
-
-	/* FIXME: ugly */
-	cmd_len = sizeof(struct wl12xx_cmd_header) + buf_len;
+	ret = wl12xx_cmd_send(wl, CMD_TEST, buf, buf_len);
 
-	ret = wl12xx_cmd_send(wl, CMD_TEST, cmd, cmd_len);
 	if (ret < 0) {
 		wl12xx_warning("TEST command failed");
-		goto out;
+		return ret;
 	}
 
 	if (answer) {
+		struct wl12xx_command *cmd_answer;
+
 		/*
 		 * The test command got in, we can read the answer.
 		 * The answer would be a wl12xx_command, where the
@@ -106,19 +94,18 @@ int wl12xx_cmd_test(struct wl12xx *wl, void *buf, size_t buf_len, u8 answer)
 
 		wl12xx_ps_elp_wakeup(wl);
 
-		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, cmd, cmd_len);
+		wl12xx_spi_mem_read(wl, wl->cmd_box_addr, buf, buf_len);
 
 		wl12xx_ps_elp_sleep(wl);
 
-		if (cmd->header.status != CMD_STATUS_SUCCESS)
+		cmd_answer = buf;
+
+		if (cmd_answer->header.status != CMD_STATUS_SUCCESS)
 			wl12xx_error("TEST command answer error: %d",
-				     cmd->header.status);
-		memcpy(buf, cmd->parameters, buf_len);
+				     cmd_answer->header.status);
 	}
 
-out:
-	kfree(cmd);
-	return ret;
+	return 0;
 }
 
 /**

