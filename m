Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56186 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab0I0Ijr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:39:47 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8dex9024477
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:39:44 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 12/25] wl1271: Remove function cmd_read_memory
Date: Mon, 27 Sep 2010 11:37:36 +0300
Message-Id: <1285576669-8070-13-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The function is not used anywhere.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.c |   35 ----------------------------
 drivers/net/wireless/wl12xx/wl1271_cmd.h |   37 ------------------------------
 2 files changed, 0 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index a516035..42e7d2f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -421,41 +421,6 @@ out:
 	return ret;
 }
 
-int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
-			   size_t len)
-{
-	struct cmd_read_write_memory *cmd;
-	int ret = 0;
-
-	wl1271_debug(DEBUG_CMD, "cmd read memory");
-
-	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
-	if (!cmd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	WARN_ON(len > MAX_READ_SIZE);
-	len = min_t(size_t, len, MAX_READ_SIZE);
-
-	cmd->addr = cpu_to_le32(addr);
-	cmd->size = cpu_to_le32(len);
-
-	ret = wl1271_cmd_send(wl, CMD_READ_MEMORY, cmd, sizeof(*cmd),
-			      sizeof(*cmd));
-	if (ret < 0) {
-		wl1271_error("read memory command failed: %d", ret);
-		goto out;
-	}
-
-	/* the read command got in */
-	memcpy(answer, cmd->value, len);
-
-out:
-	kfree(cmd);
-	return ret;
-}
-
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index ce0476c..92747ce 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -39,8 +39,6 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, u8 ps_mode, bool send);
-int wl1271_cmd_read_memory(struct wl1271 *wl, u32 addr, void *answer,
-			   size_t len);
 int wl1271_cmd_template_set(struct wl1271 *wl, u16 template_id,
 			    void *buf, size_t buf_len, int index, u32 rates);
 int wl1271_cmd_build_null_data(struct wl1271 *wl);
@@ -161,41 +159,6 @@ enum {
 	MAX_COMMAND_STATUS		= 0xff
 };
 
-
-/*
- * CMD_READ_MEMORY
- *
- * The host issues this command to read the WiLink device memory/registers.
- *
- * Note: The Base Band address has special handling (16 bits registers and
- * addresses). For more information, see the hardware specification.
- */
-/*
- * CMD_WRITE_MEMORY
- *
- * The host issues this command to write the WiLink device memory/registers.
- *
- * The Base Band address has special handling (16 bits registers and
- * addresses). For more information, see the hardware specification.
- */
-#define MAX_READ_SIZE 256
-
-struct cmd_read_write_memory {
-	struct wl1271_cmd_header header;
-
-	/* The address of the memory to read from or write to.*/
-	__le32 addr;
-
-	/* The amount of data in bytes to read from or write to the WiLink
-	 * device.*/
-	__le32 size;
-
-	/* The actual value read from or written to the Wilink. The source
-	   of this field is the Host in WRITE command or the Wilink in READ
-	   command. */
-	u8 value[MAX_READ_SIZE];
-} __packed;
-
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
 
-- 
1.6.3.3

