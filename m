Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53711 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2I0Kil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:41 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 10/31] wl18xx/wl12xx: defines for Tx/Rx descriptors num
Date: Thu, 27 Sep 2012 13:37:48 +0300
Message-Id: <1348742289-6587-11-git-send-email-luca@coelho.fi> (sfid-20120927_123948_557678_C041411A)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

Use defines for number of Tx/Rx descriptors.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    4 ++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    3 +++
 drivers/net/wireless/ti/wl18xx/main.c   |    4 ++--
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    3 +++
 4 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 9ab85c0..f38e769 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1641,8 +1641,8 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->ops = &wl12xx_ops;
 	wl->ptable = wl12xx_ptable;
 	wl->rtable = wl12xx_rtable;
-	wl->num_tx_desc = 16;
-	wl->num_rx_desc = 8;
+	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
+	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 26990fb..c8ff7ec 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -38,6 +38,9 @@
 #define WL128X_SUBTYPE_VER	2
 #define WL128X_MINOR_VER	115
 
+#define WL12XX_NUM_TX_DESCRIPTORS 16
+#define WL12XX_NUM_RX_DESCRIPTORS 8
+
 struct wl127x_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 181cd94..934708b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1392,8 +1392,8 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->ops = &wl18xx_ops;
 	wl->ptable = wl18xx_ptable;
 	wl->rtable = wl18xx_rtable;
-	wl->num_tx_desc = 32;
-	wl->num_rx_desc = 32;
+	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
+	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 6452396..9882e29 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -33,6 +33,9 @@
 
 #define WL18XX_CMD_MAX_SIZE          740
 
+#define WL18XX_NUM_TX_DESCRIPTORS 32
+#define WL18XX_NUM_RX_DESCRIPTORS 32
+
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
-- 
1.7.10.4

