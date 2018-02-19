Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35854 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752890AbeBSNb3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 08:31:29 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v7 7/8] rsi: add module parameter operating mode
Date: Mon, 19 Feb 2018 18:49:38 +0530
Message-Id: <1519046379-10068-8-git-send-email-amitkarwar@gmail.com> (sfid-20180219_143134_822226_E3B66250)
In-Reply-To: <1519046379-10068-1-git-send-email-amitkarwar@gmail.com>
References: <1519046379-10068-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Operating mode determines the support for other protocols.
This is made as module parameter for better usage.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 48 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 10 ++++++-
 drivers/net/wireless/rsi/rsi_91x_usb.c  | 10 ++++++-
 drivers/net/wireless/rsi/rsi_common.h   |  2 +-
 drivers/net/wireless/rsi/rsi_hal.h      | 11 ++++++++
 5 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index b3e7d75..1485a0c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -70,8 +70,24 @@ EXPORT_SYMBOL_GPL(rsi_dbg);
 static char *opmode_str(int oper_mode)
 {
 	switch (oper_mode) {
-	case RSI_DEV_OPMODE_WIFI_ALONE:
+	case DEV_OPMODE_WIFI_ALONE:
 		return "Wi-Fi alone";
+	case DEV_OPMODE_BT_ALONE:
+		return "BT EDR alone";
+	case DEV_OPMODE_BT_LE_ALONE:
+		return "BT LE alone";
+	case DEV_OPMODE_BT_DUAL:
+		return "BT Dual";
+	case DEV_OPMODE_STA_BT:
+		return "Wi-Fi STA + BT EDR";
+	case DEV_OPMODE_STA_BT_LE:
+		return "Wi-Fi STA + BT LE";
+	case DEV_OPMODE_STA_BT_DUAL:
+		return "Wi-Fi STA + BT DUAL";
+	case DEV_OPMODE_AP_BT:
+		return "Wi-Fi AP + BT EDR";
+	case DEV_OPMODE_AP_BT_DUAL:
+		return "Wi-Fi AP + BT DUAL";
 	}
 
 	return "Unknown";
@@ -278,7 +294,7 @@ void rsi_set_bt_context(void *priv, void *bt_context)
  *
  * Return: Pointer to the adapter structure on success, NULL on failure .
  */
-struct rsi_hw *rsi_91x_init(void)
+struct rsi_hw *rsi_91x_init(u16 oper_mode)
 {
 	struct rsi_hw *adapter = NULL;
 	struct rsi_common *common = NULL;
@@ -321,9 +337,33 @@ struct rsi_hw *rsi_91x_init(void)
 	timer_setup(&common->roc_timer, rsi_roc_timeout, 0);
 	init_completion(&common->wlan_init_completion);
 	common->init_done = true;
+	adapter->device_model = RSI_DEV_9113;
+	common->oper_mode = oper_mode;
+
+	/* Determine coex mode */
+	switch (common->oper_mode) {
+	case DEV_OPMODE_STA_BT_DUAL:
+	case DEV_OPMODE_STA_BT:
+	case DEV_OPMODE_STA_BT_LE:
+	case DEV_OPMODE_BT_ALONE:
+	case DEV_OPMODE_BT_LE_ALONE:
+	case DEV_OPMODE_BT_DUAL:
+		common->coex_mode = 2;
+		break;
+	case DEV_OPMODE_AP_BT_DUAL:
+	case DEV_OPMODE_AP_BT:
+		common->coex_mode = 4;
+		break;
+	case DEV_OPMODE_WIFI_ALONE:
+		common->coex_mode = 1;
+		break;
+	default:
+		common->oper_mode = 1;
+		common->coex_mode = 1;
+	}
+	rsi_dbg(INFO_ZONE, "%s: oper_mode = %d, coex_mode = %d\n",
+		__func__, common->oper_mode, common->coex_mode);
 
-	common->coex_mode = RSI_DEV_COEX_MODE_WIFI_ALONE;
-	common->oper_mode = RSI_DEV_OPMODE_WIFI_ALONE;
 	adapter->device_model = RSI_DEV_9113;
 #ifdef CONFIG_RSI_COEX
 	if (common->coex_mode > 1) {
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index ba38c6d..5722736 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -21,6 +21,14 @@
 #include "rsi_coex.h"
 #include "rsi_hal.h"
 
+/* Default operating mode is wlan STA + BT */
+static u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL;
+module_param(dev_oper_mode, ushort, 0444);
+MODULE_PARM_DESC(dev_oper_mode,
+		 "1[Wi-Fi], 4[BT], 8[BT LE], 5[Wi-Fi STA + BT classic]\n"
+		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
+		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
+
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
  * @rw: Read/write
@@ -926,7 +934,7 @@ static int rsi_probe(struct sdio_func *pfunction,
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
 
-	adapter = rsi_91x_init();
+	adapter = rsi_91x_init(dev_oper_mode);
 	if (!adapter) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init os intf ops\n",
 			__func__);
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index b33a05f..0a50cff 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -21,6 +21,14 @@
 #include "rsi_hal.h"
 #include "rsi_coex.h"
 
+/* Default operating mode is wlan STA + BT */
+static u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL;
+module_param(dev_oper_mode, ushort, 0444);
+MODULE_PARM_DESC(dev_oper_mode,
+		 "1[Wi-Fi], 4[BT], 8[BT LE], 5[Wi-Fi STA + BT classic]\n"
+		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
+		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
+
 /**
  * rsi_usb_card_write() - This function writes to the USB Card.
  * @adapter: Pointer to the adapter structure.
@@ -708,7 +716,7 @@ static int rsi_probe(struct usb_interface *pfunction,
 
 	rsi_dbg(INIT_ZONE, "%s: Init function called\n", __func__);
 
-	adapter = rsi_91x_init();
+	adapter = rsi_91x_init(dev_oper_mode);
 	if (!adapter) {
 		rsi_dbg(ERR_ZONE, "%s: Failed to init os intf ops\n",
 			__func__);
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 4616585..d9ff3b8 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -81,7 +81,7 @@ static inline int rsi_kill_thread(struct rsi_thread *handle)
 
 void rsi_mac80211_detach(struct rsi_hw *hw);
 u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
-struct rsi_hw *rsi_91x_init(void);
+struct rsi_hw *rsi_91x_init(u16 oper_mode);
 void rsi_91x_deinit(struct rsi_hw *adapter);
 int rsi_read_pkt(struct rsi_common *common, u8 *rx_pkt, s32 rcv_pkt_len);
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index e712223..a7d3011 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -17,6 +17,17 @@
 #ifndef __RSI_HAL_H__
 #define __RSI_HAL_H__
 
+/* Device Operating modes */
+#define DEV_OPMODE_WIFI_ALONE		1
+#define DEV_OPMODE_BT_ALONE		4
+#define DEV_OPMODE_BT_LE_ALONE		8
+#define DEV_OPMODE_BT_DUAL		12
+#define DEV_OPMODE_STA_BT		5
+#define DEV_OPMODE_STA_BT_LE		9
+#define DEV_OPMODE_STA_BT_DUAL		13
+#define DEV_OPMODE_AP_BT		6
+#define DEV_OPMODE_AP_BT_DUAL		14
+
 #define FLASH_WRITE_CHUNK_SIZE		(4 * 1024)
 #define FLASH_SECTOR_SIZE		(4 * 1024)
 
-- 
2.7.4
