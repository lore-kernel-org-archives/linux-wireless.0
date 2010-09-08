Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:48764 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab0IHXZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:25:59 -0400
Received: by mail-px0-f174.google.com with SMTP id 10so254007pxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:25:59 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 4/9] libertas_tf: Add firmware reset to sdio driver and attempt firmware reload
Date: Wed,  8 Sep 2010 16:25:24 -0700
Message-Id: <1283988329-44549-5-git-send-email-steve@cozybit.com>
In-Reply-To: <1283988329-44549-1-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a method to do a firmware/chip reset to the sdio driver and
attempts to reload the firmware.

Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/if_sdio.c |   40 +++++++++++++++++++++++----
 drivers/net/wireless/libertas_tf/main.c    |    7 ++++-
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
index fed5aff..1e72b4c 100644
--- a/drivers/net/wireless/libertas_tf/if_sdio.c
+++ b/drivers/net/wireless/libertas_tf/if_sdio.c
@@ -53,6 +53,8 @@ struct if_sdio_model {
 	const char *firmware;
 };
 
+extern unsigned int lbtf_reset_fw;
+
 static struct if_sdio_model if_sdio_models[] = {
 	{
 		/* 8686 */
@@ -673,6 +675,8 @@ out:
 	return ret;
 }
 
+static void if_sdio_reset_device(struct if_sdio_card *card);
+
 static int if_sdio_prog_firmware(struct if_sdio_card *card)
 {
 	int ret;
@@ -691,17 +695,29 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
 	scratch = if_sdio_read_scratch(card, &ret);
 	sdio_release_host(card->func);
 
+	lbtf_deb_sdio("firmware status = %#x\n", scratch);
+	lbtf_deb_sdio("scratch ret = %d\n", ret);
+
 	if (ret)
 		goto out;
 
-	lbtf_deb_sdio("firmware status = %#x\n", scratch);
-
 	if (scratch == IF_SDIO_FIRMWARE_OK) {
 		lbtf_deb_sdio("firmware already loaded\n");
 		goto success;
 	} else if ((card->model == IF_SDIO_MODEL_8686) && (scratch > 0)) {
 		lbtf_deb_sdio("firmware may be running\n");
-		goto success;
+		if( lbtf_reset_fw == 0 ) {
+			goto success;
+		} else {
+			int i = 0;
+			lbtf_deb_sdio("attempting to reset and reload firmware\n");
+
+			if_sdio_reset_device(card);
+			lbtf_reset_fw=0;
+
+			ret = if_sdio_prog_firmware(card);
+			goto out;
+		}
 	}
 
 	ret = if_sdio_prog_helper(card);
@@ -864,7 +880,7 @@ static void if_sdio_reset_device(struct if_sdio_card *card)
 
 	if_sdio_host_to_card(card->priv, MVMS_CMD, (u8 *) &cmd, sizeof(cmd));
 
-	msleep(100);
+	msleep(1000);
 
 	lbtf_deb_leave(LBTF_DEB_SDIO);
 
@@ -887,10 +903,12 @@ static void if_sdio_interrupt(struct sdio_func *func)
 	card = sdio_get_drvdata(func);
 
 	cause = sdio_readb(card->func, IF_SDIO_H_INT_STATUS, &ret);
+	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
+	lbtf_deb_sdio("interrupt ret: 0x%X\n", ret);
 	if (ret)
 		goto out;
 
-	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
+//	lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
 
 	sdio_writeb(card->func, ~cause, IF_SDIO_H_INT_STATUS, &ret);
 	if (ret)
@@ -1061,13 +1079,23 @@ static int if_sdio_probe(struct sdio_func *func,
 	priv->enter_deep_sleep = if_sdio_enter_deep_sleep;
 	priv->exit_deep_sleep = if_sdio_exit_deep_sleep;
 	priv->reset_deep_sleep_wakeup = if_sdio_reset_deep_sleep_wakeup;
-	priv->hw_reset_device = if_sdio_reset_device;
 	priv->enable_interrupts = if_sdio_enable_interrupts;
 	priv->disable_interrupts = if_sdio_disable_interrupts;
 
 	/* SD8385 & SD8686 do not have rx_unit.	*/
 	card->rx_unit = 0;
 
+	/*
+	 * Enable interrupts now that everything is set up
+	 */
+	ret = _if_sdio_enable_interrupts(card);
+	if (ret) {
+		pr_err("Error enabling interrupts: %d", ret);
+		goto err_activate_card;
+	}
+
+	priv->fw_ready = 1;
+
 out:
 	lbtf_deb_leave_args(LBTF_DEB_SDIO, "ret %d", ret);
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 5d34ad9..119d625 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -24,6 +24,10 @@ unsigned int lbtf_debug;
 EXPORT_SYMBOL_GPL(lbtf_debug);
 module_param_named(libertas_tf_debug, lbtf_debug, int, 0644);
 
+unsigned int lbtf_reset_fw;
+EXPORT_SYMBOL_GPL(lbtf_reset_fw);
+module_param_named(libertas_tf_reset_fw, lbtf_reset_fw, int, 0644);
+
 static const char lbtf_driver_version[] = "THINFIRM-USB8388-" DRIVER_RELEASE_VERSION
 #ifdef DEBUG
 	"-dbg"
@@ -360,7 +364,8 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
 	return 0;
 
 err_prog_firmware:
-//	priv->hw_reset_device(card);
+	if (priv->hw_reset_device)
+		priv->hw_reset_device(card);
 	lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programing fw; ret=%d", ret);
 	return ret;
 }
-- 
1.7.0

