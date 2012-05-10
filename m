Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38065 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab2EJJOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:49 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so243375wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 08/78] wl18xx: add trigger command and ack event operations
Date: Thu, 10 May 2012 12:13:13 +0300
Message-Id: <1336641263-5761-9-git-send-email-arik@wizery.com> (sfid-20120510_111453_371302_3E1B5464)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add the operations that allow wlcore to trigger commands to the
firmware and acknowledge when an event has been fully received.

Allocate a private buffer to hold the maximum sized cmd. Send the
entire length of the buffer each time a command is sent to signal
EOT. Remove the previous EOT mechanism.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |   20 +++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h    |   16 +++++++++++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |   33 +++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+)
 create mode 100644 drivers/net/wireless/ti/wl18xx/wl18xx.h

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 12632d0..6a487c8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -30,6 +30,7 @@
 
 #include "reg.h"
 #include "conf.h"
+#include "wl18xx.h"
 
 static struct wl18xx_conf wl18xx_default_conf = {
 	.phy = {
@@ -284,9 +285,28 @@ out:
 	return ret;
 }
 
+static void wl18xx_trigger_cmd(struct wl1271 *wl, int cmd_box_addr,
+			       void *buf, size_t len)
+{
+	struct wl18xx_priv *priv = wl->priv;
+
+	memcpy(priv->cmd_buf, buf, len);
+	memset(priv->cmd_buf + len, 0, WL18XX_CMD_MAX_SIZE - len);
+
+	wl1271_write(wl, cmd_box_addr, priv->cmd_buf, WL18XX_CMD_MAX_SIZE,
+		     false);
+}
+
+static void wl18xx_ack_event(struct wl1271 *wl)
+{
+	wlcore_write_reg(wl, REG_INTERRUPT_TRIG, WL18XX_INTR_TRIG_EVENT_ACK);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
+	.trigger_cmd	= wl18xx_trigger_cmd,
+	.ack_event	= wl18xx_ack_event,
 };
 
 int __devinit wl18xx_probe(struct platform_device *pdev)
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 2916d69..5398799 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -113,6 +113,22 @@
 
 #define CHIP_ID_185x_PG10              (0x06030101)
 
+/*
+ * Host Command Interrupt. Setting this bit masks
+ * the interrupt that the host issues to inform
+ * the FW that it has sent a command
+ * to the Wlan hardware Command Mailbox.
+ */
+#define WL18XX_INTR_TRIG_CMD       BIT(28)
+
+/*
+ * Host Event Acknowlegde Interrupt. The host
+ * sets this bit to acknowledge that it received
+ * the unsolicited information from the event
+ * mailbox.
+ */
+#define WL18XX_INTR_TRIG_EVENT_ACK BIT(29)
+
 /* TODO: maybe move elsewhere? */
 #define NUM_OF_CHANNELS_11_ABG 150
 #define NUM_OF_CHANNELS_11_P 7
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
new file mode 100644
index 0000000..58709bb
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -0,0 +1,33 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __WL18XX_PRIV_H__
+#define __WL18XX_PRIV_H__
+
+
+#define WL18XX_CMD_MAX_SIZE          740
+
+struct wl18xx_priv {
+	/* buffer for sending commands to FW */
+	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
+};
+
+#endif /* __WL18XX_PRIV_H__ */
-- 
1.7.9.5

