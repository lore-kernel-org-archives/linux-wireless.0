Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab2EJJPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:06 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1110716wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:05 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 16/78] wl18xx: add fw_status private data
Date: Thu, 10 May 2012 12:13:21 +0300
Message-Id: <1336641263-5761-17-git-send-email-arik@wizery.com> (sfid-20120510_111516_992094_1B4C1BA3)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl18xx chip passes extra information in the firmware status to the
driver.  Add a private data section to handle that.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c   |    2 +-
 drivers/net/wireless/ti/wl18xx/wl18xx.h |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 7dcb832..4a5ef6e 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -478,7 +478,7 @@ int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
-
+	wl->fw_status_priv_len = sizeof(struct wl18xx_fw_status_priv);
 	return wlcore_probe(wl, pdev);
 }
 
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 58709bb..68ef5ba 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -30,4 +30,22 @@ struct wl18xx_priv {
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
 };
 
+#define WL18XX_FW_MAX_TX_STATUS_DESC 33
+
+struct wl18xx_fw_status_priv {
+	/*
+	 * Index in released_tx_desc for first byte that holds
+	 * released tx host desc
+	 */
+	u8 fw_release_idx;
+
+	/*
+	 * Array of host Tx descriptors, where fw_release_idx
+	 * indicated the first released idx.
+	 */
+	u8 released_tx_desc[WL18XX_FW_MAX_TX_STATUS_DESC];
+
+	u8 padding[2];
+};
+
 #endif /* __WL18XX_PRIV_H__ */
-- 
1.7.9.5

