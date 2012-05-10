Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab2EJJQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:09 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1111470wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:09 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 45/78] wl18xx: add plt_init operation
Date: Thu, 10 May 2012 12:13:50 +0300
Message-Id: <1336641263-5761-46-git-send-email-arik@wizery.com> (sfid-20120510_112048_536577_160B0560)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add the correct FW name for PLT (which is the same as the normal
firmware) and implement the plt_init operation.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |   10 ++++++++++
 drivers/net/wireless/ti/wl18xx/reg.h  |    6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index f892d37..5940829 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -580,6 +580,8 @@ static int wl18xx_identify_chip(struct wl1271 *wl)
 		wl1271_debug(DEBUG_BOOT, "chip id 0x%x (185x PG10)",
 			     wl->chip.id);
 		wl->sr_fw_name = WL18XX_FW_NAME;
+		/* wl18xx uses the same firmware for PLT */
+		wl->plt_fw_name = WL18XX_FW_NAME;
 		wl->quirks |= WLCORE_QUIRK_NO_ELP |
 			      WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED |
 			      WLCORE_QUIRK_RX_BLOCKSIZE_ALIGN;
@@ -958,9 +960,17 @@ static void wl18xx_conf_init(struct wl1271 *wl)
 	memcpy(&priv->conf, &wl18xx_default_priv_conf, sizeof(priv->conf));
 }
 
+static int wl18xx_plt_init(struct wl1271 *wl)
+{
+	wl1271_write32(wl, WL18XX_SCR_PAD8, WL18XX_SCR_PAD8_PLT);
+
+	return wl->ops->boot(wl);
+}
+
 static struct wlcore_ops wl18xx_ops = {
 	.identify_chip	= wl18xx_identify_chip,
 	.boot		= wl18xx_boot,
+	.plt_init	= wl18xx_plt_init,
 	.trigger_cmd	= wl18xx_trigger_cmd,
 	.ack_event	= wl18xx_ack_event,
 	.calc_tx_blocks = wl18xx_calc_tx_blocks,
diff --git a/drivers/net/wireless/ti/wl18xx/reg.h b/drivers/net/wireless/ti/wl18xx/reg.h
index 1674c1a..aaedf91 100644
--- a/drivers/net/wireless/ti/wl18xx/reg.h
+++ b/drivers/net/wireless/ti/wl18xx/reg.h
@@ -154,6 +154,12 @@
  */
 #define WL18XX_INTR_TRIG_EVENT_ACK BIT(29)
 
+/*
+ * To boot the firmware in PLT mode we need to write this value in
+ * SCR_PAD8 before starting.
+ */
+#define WL18XX_SCR_PAD8_PLT	0xBABABEBE
+
 /* TODO: maybe move elsewhere? */
 #define NUM_OF_CHANNELS_11_ABG 150
 #define NUM_OF_CHANNELS_11_P 7
-- 
1.7.9.5

