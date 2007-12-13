Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57840 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770AbXLMHAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:00 -0500
Subject: [PATCH 90/48] libertas: implement suspend and resume core methods
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3G-0005uN-KR@shinybook.infradead.org> (sfid-20071213_070017_131110_389ED9E9)
Date: Thu, 13 Dec 2007 02:00:10 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 17:38:56 -0500

We (ab)use priv->fw_ready to stop the worker thread from sending more
commands or data after the response to the HOST_SLEEP_ACTIVATE command
comes in. And we set it from the callback function _directly_ to ensure
that the worker thread sees it immediately; if we did it in
lbs_suspend() after waking up, that might be too late.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.h  |    2 +
 drivers/net/wireless/libertas/main.c |   47 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index e800295..e44a0db 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -35,5 +35,7 @@ int lbs_mesh_config(struct lbs_private *priv, int enable);
 
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
 		       uint8_t gpio, uint8_t gap);
+int lbs_suspend(struct lbs_private *priv);
+int lbs_resume(struct lbs_private *priv);
 
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index dd432ea..1ea119e 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -820,6 +820,53 @@ static int lbs_thread(void *data)
 	return 0;
 }
 
+static int lbs_suspend_callback(struct lbs_private *priv, unsigned long dummy,
+				struct cmd_header *cmd)
+{
+	lbs_deb_fw("HOST_SLEEP_ACTIVATE succeeded\n");
+
+	netif_device_detach(priv->dev);
+	if (priv->mesh_dev)
+		netif_device_detach(priv->mesh_dev);
+
+	priv->fw_ready = 0;
+	return 0;
+}
+
+
+int lbs_suspend(struct lbs_private *priv)
+{
+	struct cmd_header cmd;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	
+	ret = __lbs_cmd(priv, CMD_802_11_HOST_SLEEP_ACTIVATE, &cmd,
+			sizeof(cmd), lbs_suspend_callback, 0);
+	if (ret)
+		lbs_pr_info("HOST_SLEEP_ACTIVATE failed: %d\n", ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lbs_suspend);
+
+int lbs_resume(struct lbs_private *priv)
+{
+	priv->fw_ready = 1;
+
+	/* Firmware doesn't seem to give us RX packets any more
+	   until we send it some command. Might as well update */
+	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
+				     0, 0, NULL);
+
+	netif_device_attach(priv->dev);
+	if (priv->mesh_dev)
+		netif_device_attach(priv->mesh_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lbs_resume);
+
 /**
  *  @brief This function downloads firmware image, gets
  *  HW spec from firmware and set basic parameters to
-- 
1.5.3.4

