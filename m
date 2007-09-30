Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32690 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbXI3SjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:39:25 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 06/26] at76_usb: Fix turning radio off
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:39:17 -0400
Message-ID: <20070930183917.23921.84956.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Atmel's driver uses command 7 to turn radio off.  Also,
CMD_GETOPMODE is bogus, remove it.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   13 ++++++++-----
 drivers/net/wireless/at76_usb.h |    4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index ca8157a..62ddae7 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -823,21 +823,24 @@ static int at76_set_mib(struct at76_priv *priv, struct set_mib_buffer *buf)
 }
 
 /* Return < 0 on error, == 0 if no command sent, == 1 if cmd sent */
-static int at76_set_radio(struct at76_priv *priv, int on_off)
+static int at76_set_radio(struct at76_priv *priv, int enable)
 {
 	int ret;
+	int cmd;
 
-	if (priv->radio_on == on_off)
+	if (priv->radio_on == enable)
 		return 0;
 
-	ret = at76_set_card_command(priv->udev, CMD_RADIO, NULL, 0);
+	cmd = enable ? CMD_RADIO_ON : CMD_RADIO_OFF;
+
+	ret = at76_set_card_command(priv->udev, cmd, NULL, 0);
 	if (ret < 0)
 		err("%s: at76_set_card_command(CMD_RADIO) failed: %d",
 		    priv->netdev->name, ret);
 	else
 		ret = 1;
 
-	priv->radio_on = on_off;
+	priv->radio_on = enable;
 	return ret;
 }
 
@@ -3950,7 +3953,7 @@ static int at76_startup_device(struct at76_priv *priv)
 	memset(priv->bssid, 0, ETH_ALEN);
 
 	if (at76_set_radio(priv, 1) == 1)
-		at76_wait_completion(priv, CMD_RADIO);
+		at76_wait_completion(priv, CMD_RADIO_ON);
 
 	ret = at76_set_preamble(priv, priv->preamble_type);
 	if (ret < 0)
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 4fef446..413d12e 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -78,9 +78,9 @@ enum board_type {
 #define CMD_SCAN		0x03
 #define CMD_JOIN		0x04
 #define CMD_START_IBSS		0x05
-#define CMD_RADIO		0x06
+#define CMD_RADIO_ON		0x06
+#define CMD_RADIO_OFF		0x07
 #define CMD_STARTUP		0x0B
-#define CMD_GETOPMODE		0x33
 
 #define MIB_LOCAL		0x01
 #define MIB_MAC_ADDR		0x02
