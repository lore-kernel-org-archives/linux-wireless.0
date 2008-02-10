Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:56228 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYBJPKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 10:10:52 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 04/12] Add DBG_CMD for debugging firmware commands
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Date: Sun, 10 Feb 2008 17:00:19 +0200
Message-ID: <20080210150019.17592.86209.stgit@tikku> (sfid-20080210_151055_302093_62D7F00F)
In-Reply-To: <20080210145733.17592.61729.stgit@tikku>
References: <20080210145733.17592.61729.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/net/wireless/at76_usb.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 80b90a3..c312634 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -76,6 +76,7 @@
 #define DBG_WE_EVENTS		0x08000000	/* dump wireless events */
 #define DBG_FW			0x10000000	/* firmware download */
 #define DBG_DFU			0x20000000	/* device firmware upgrade */
+#define DBG_CMD			0x40000000
 
 #define DBG_DEFAULTS		0
 
@@ -786,6 +787,24 @@ static inline int at76_get_cmd_status(struct usb_device *udev, u8 cmd)
 	return stat_buf[5];
 }
 
+#define MAKE_CMD_CASE(c) case (c): return #c
+
+static const char *at76_get_cmd_string(u8 cmd_status)
+{
+	switch (cmd_status) {
+		MAKE_CMD_CASE(CMD_SET_MIB);
+		MAKE_CMD_CASE(CMD_GET_MIB);
+		MAKE_CMD_CASE(CMD_SCAN);
+		MAKE_CMD_CASE(CMD_JOIN);
+		MAKE_CMD_CASE(CMD_START_IBSS);
+		MAKE_CMD_CASE(CMD_RADIO_ON);
+		MAKE_CMD_CASE(CMD_RADIO_OFF);
+		MAKE_CMD_CASE(CMD_STARTUP);
+	}
+
+	return "UNKNOWN";
+}
+
 static int at76_set_card_command(struct usb_device *udev, int cmd, void *buf,
 				 int buf_size)
 {
@@ -801,6 +820,10 @@ static int at76_set_card_command(struct usb_device *udev, int cmd, void *buf,
 	cmd_buf->size = cpu_to_le16(buf_size);
 	memcpy(cmd_buf->data, buf, buf_size);
 
+	at76_dbg_dump(DBG_CMD, cmd_buf, sizeof(struct at76_command) + buf_size,
+		      "issuing command %s (0x%02x)",
+		      at76_get_cmd_string(cmd), cmd);
+
 	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), 0x0e,
 			      USB_TYPE_VENDOR | USB_DIR_OUT | USB_RECIP_DEVICE,
 			      0, 0, cmd_buf,

