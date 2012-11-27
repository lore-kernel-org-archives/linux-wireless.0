Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54532 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab2K0GpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 01:45:15 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so3551054wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2012 22:45:14 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/20] wlcore: allow fw commands to fail
Date: Tue, 27 Nov 2012 08:44:45 +0200
Message-Id: <1353998701-18171-5-git-send-email-arik@wizery.com> (sfid-20121127_074524_267986_A5A61B36)
In-Reply-To: <1353998701-18171-1-git-send-email-arik@wizery.com>
References: <1353998701-18171-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Currently, each fw command/acx that return a status code
different than CMD_STATUS_SUCCESS will trigger a recovery
in the driver.

However, it is a valid for some fw commands to fail (e.g.
due to temporary lack of resources), so add new functions
that allow passing bitmap of valid error return values.

(make the current wl1271_cmd_send/wl1271_cmd_configure
wrappers around the new functions, in order to avoid
changing the whole driver)

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c |   85 +++++++++++++++++++++++++++-------
 drivers/net/wireless/ti/wlcore/cmd.h |    7 ++-
 2 files changed, 73 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index fc508ee..ead19c9 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -48,14 +48,15 @@
  * @id: command id
  * @buf: buffer containing the command, must work with dma
  * @len: length of the buffer
+ * return the cmd status code on success.
  */
-int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
-		    size_t res_len)
+static int __wlcore_cmd_send(struct wl1271 *wl, u16 id, void *buf,
+			     size_t len, size_t res_len)
 {
 	struct wl1271_cmd_header *cmd;
 	unsigned long timeout;
 	u32 intr;
-	int ret = 0;
+	int ret;
 	u16 status;
 	u16 poll_count = 0;
 
@@ -71,7 +72,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	ret = wlcore_write(wl, wl->cmd_box_addr, buf, len, false);
 	if (ret < 0)
-		goto fail;
+		return ret;
 
 	/*
 	 * TODO: we just need this because one bit is in a different
@@ -79,19 +80,18 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	 */
 	ret = wl->ops->trigger_cmd(wl, wl->cmd_box_addr, buf, len);
 	if (ret < 0)
-		goto fail;
+		return ret;
 
 	timeout = jiffies + msecs_to_jiffies(WL1271_COMMAND_TIMEOUT);
 
 	ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &intr);
 	if (ret < 0)
-		goto fail;
+		return ret;
 
 	while (!(intr & WL1271_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1271_error("command complete timeout");
-			ret = -ETIMEDOUT;
-			goto fail;
+			return -ETIMEDOUT;
 		}
 
 		poll_count++;
@@ -102,7 +102,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 		ret = wlcore_read_reg(wl, REG_INTERRUPT_NO_CLEAR, &intr);
 		if (ret < 0)
-			goto fail;
+			return ret;
 	}
 
 	/* read back the status code of the command */
@@ -111,22 +111,40 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 
 	ret = wlcore_read(wl, wl->cmd_box_addr, cmd, res_len, false);
 	if (ret < 0)
-		goto fail;
+		return ret;
 
 	status = le16_to_cpu(cmd->status);
-	if (status != CMD_STATUS_SUCCESS) {
-		wl1271_error("command execute failure %d", status);
-		ret = -EIO;
-		goto fail;
-	}
 
 	ret = wlcore_write_reg(wl, REG_INTERRUPT_ACK,
 			       WL1271_ACX_INTR_CMD_COMPLETE);
 	if (ret < 0)
+		return ret;
+
+	return status;
+}
+
+/*
+ * send command to fw and return cmd status on success
+ * valid_rets contains a bitmap of allowed error codes
+ */
+int wlcore_cmd_send_failsafe(struct wl1271 *wl, u16 id, void *buf, size_t len,
+			     size_t res_len, unsigned long valid_rets)
+{
+	int ret = __wlcore_cmd_send(wl, id, buf, len, res_len);
+
+	if (ret < 0)
 		goto fail;
 
-	return 0;
+	/* success is always a valid status */
+	valid_rets |= BIT(CMD_STATUS_SUCCESS);
 
+	if (ret >= MAX_COMMAND_STATUS ||
+	    !test_bit(ret, &valid_rets)) {
+		wl1271_error("command execute failure %d", ret);
+		ret = -EIO;
+		goto fail;
+	}
+	return ret;
 fail:
 	wl12xx_queue_recovery_work(wl);
 	return ret;
@@ -134,6 +152,20 @@ fail:
 EXPORT_SYMBOL_GPL(wl1271_cmd_send);
 
 /*
+ * wrapper for wlcore_cmd_send that accept only CMD_STATUS_SUCCESS
+ * return 0 on success.
+ */
+int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
+		    size_t res_len)
+{
+	int ret = wlcore_cmd_send_failsafe(wl, id, buf, len, res_len, 0);
+
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+/*
  * Poll the mailbox event field until any of the bits in the mask is set or a
  * timeout occurs (WL1271_EVENT_TIMEOUT in msecs)
  */
@@ -791,8 +823,11 @@ int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len)
  * @id: acx id
  * @buf: buffer containing acx, including all headers, must work with dma
  * @len: length of buf
+ * @valid_rets: bitmap of valid cmd status codes (i.e. return values).
+ * return the cmd status on success.
  */
-int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
+int wlcore_cmd_configure_failsafe(struct wl1271 *wl, u16 id, void *buf,
+				  size_t len, unsigned long valid_rets)
 {
 	struct acx_header *acx = buf;
 	int ret;
@@ -804,12 +839,26 @@ int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
 	/* payload length, does not include any headers */
 	acx->len = cpu_to_le16(len - sizeof(*acx));
 
-	ret = wl1271_cmd_send(wl, CMD_CONFIGURE, acx, len, 0);
+	ret = wlcore_cmd_send_failsafe(wl, CMD_CONFIGURE, acx, len, 0,
+				       valid_rets);
 	if (ret < 0) {
 		wl1271_warning("CONFIGURE command NOK");
 		return ret;
 	}
 
+	return ret;
+}
+
+/*
+ * wrapper for wlcore_cmd_configure that accepts only success status.
+ * return 0 on success
+ */
+int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len)
+{
+	int ret = wlcore_cmd_configure_failsafe(wl, id, buf, len, 0);
+
+	if (ret < 0)
+		return ret;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(wl1271_cmd_configure);
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 7f378b7..fd34123 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -31,6 +31,8 @@ struct acx_header;
 
 int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 		    size_t res_len);
+int wlcore_cmd_send_failsafe(struct wl1271 *wl, u16 id, void *buf, size_t len,
+			     size_t res_len, unsigned long valid_rets);
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
@@ -45,6 +47,8 @@ int wl12xx_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
+int wlcore_cmd_configure_failsafe(struct wl1271 *wl, u16 id, void *buf,
+				  size_t len, unsigned long valid_rets);
 int wl1271_cmd_data_path(struct wl1271 *wl, bool enable);
 int wl1271_cmd_ps_mode(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		       u8 ps_mode, u16 auto_ps_timeout);
@@ -234,7 +238,8 @@ enum {
 	CMD_STATUS_FW_RESET		= 22, /* Driver internal use.*/
 	CMD_STATUS_TEMPLATE_OOM		= 23,
 	CMD_STATUS_NO_RX_BA_SESSION	= 24,
-	MAX_COMMAND_STATUS		= 0xff
+
+	MAX_COMMAND_STATUS
 };
 
 #define CMDMBOX_HEADER_LEN 4
-- 
1.7.9.5

