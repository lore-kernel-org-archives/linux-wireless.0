Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:62398 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbbFNQMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 12:12:54 -0400
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH] ath9k_htc: introduce support for different fw versions
Date: Sun, 14 Jun 2015 18:12:22 +0200
Message-Id: <1434298342-1620-1-git-send-email-linux@rempel-privat.de> (sfid-20150614_181259_634552_6EC6DD68)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current kernel support only one fw name with theoretically only one
fw version. By replacing fw with other version we will break compatibility
with older kernels.

To avoid this kind of regression this patch will reuse fw version model
from iwlwifi driver.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      | 102 ++++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/hif_usb.h      |  13 +++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   4 +
 3 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 10c02f5..18407f2 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -17,10 +17,6 @@
 #include <asm/unaligned.h>
 #include "htc.h"
 
-/* identify firmware images */
-#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
-#define FIRMWARE_AR9271         "htc_9271.fw"
-
 MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
 MODULE_FIRMWARE(FIRMWARE_AR9271);
 
@@ -1080,12 +1076,88 @@ static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
 		device_unlock(parent);
 }
 
+static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context);
+
+/* taken from iwlwifi */
+static int ath9k_hif_request_firmware(struct hif_device_usb *hif_dev,
+				      bool first)
+{
+	char index[8], *chip;
+	int ret;
+
+	if (first) {
+		if (htc_use_dev_fw) {
+			hif_dev->fw_minor_index = FIRMWARE_MINOR_IDX_MAX + 1;
+			sprintf(index, "%s", "dev");
+		} else {
+			hif_dev->fw_minor_index = FIRMWARE_MINOR_IDX_MAX;
+			sprintf(index, "%d", hif_dev->fw_minor_index);
+		}
+	} else {
+		hif_dev->fw_minor_index--;
+		sprintf(index, "%d", hif_dev->fw_minor_index);
+	}
+
+	/* test for FW 1.3 */
+	if (MAJOR_VERSION_REQ == 1 && hif_dev->fw_minor_index == 3) {
+		const char *filename;
+
+		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+			filename = FIRMWARE_AR7010_1_1;
+		else
+			filename = FIRMWARE_AR9271;
+
+		/* expected fw locations:
+		 * - htc_9271.fw   (stable version 1.3, depricated)
+		 */
+		snprintf(hif_dev->fw_name, sizeof(hif_dev->fw_name),
+			 "%s", filename);
+
+	} else if (hif_dev->fw_minor_index < FIRMWARE_MINOR_IDX_MIN) {
+		dev_err(&hif_dev->udev->dev, "no suitable firmware found!\n");
+
+		return -ENOENT;
+	} else {
+		if (IS_AR7010_DEVICE(hif_dev->usb_device_id->driver_info))
+			chip = "7010";
+		else
+			chip = "9271";
+
+		/* expected fw locations:
+		 * - ath9k_htc/htc_9271-1.dev.0.fw (development version)
+		 * - ath9k_htc/htc_9271-1.4.0.fw   (stable version)
+		 */
+		snprintf(hif_dev->fw_name, sizeof(hif_dev->fw_name),
+			 "ath9k_htc/htc_%s-%d.%s.0.fw",
+			 chip, MAJOR_VERSION_REQ, index);
+	}
+
+	ret = request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
+				      &hif_dev->udev->dev, GFP_KERNEL,
+				      hif_dev, ath9k_hif_usb_firmware_cb);
+	if (ret) {
+		dev_err(&hif_dev->udev->dev,
+			"ath9k_htc: Async request for firmware %s failed\n",
+			hif_dev->fw_name);
+		return ret;
+	}
+
+	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
+		 hif_dev->fw_name);
+
+	return ret;
+}
+
 static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 {
 	struct hif_device_usb *hif_dev = context;
 	int ret;
 
 	if (!fw) {
+		ret = ath9k_hif_request_firmware(hif_dev, false);
+		if (!ret)
+			return;
+
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Failed to get firmware %s\n",
 			hif_dev->fw_name);
@@ -1215,27 +1287,11 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	init_completion(&hif_dev->fw_done);
 
-	/* Find out which firmware to load */
-
-	if (IS_AR7010_DEVICE(id->driver_info))
-		hif_dev->fw_name = FIRMWARE_AR7010_1_1;
-	else
-		hif_dev->fw_name = FIRMWARE_AR9271;
-
-	ret = request_firmware_nowait(THIS_MODULE, true, hif_dev->fw_name,
-				      &hif_dev->udev->dev, GFP_KERNEL,
-				      hif_dev, ath9k_hif_usb_firmware_cb);
-	if (ret) {
-		dev_err(&hif_dev->udev->dev,
-			"ath9k_htc: Async request for firmware %s failed\n",
-			hif_dev->fw_name);
+	ret = ath9k_hif_request_firmware(hif_dev, true);
+	if (ret)
 		goto err_fw_req;
-	}
 
-	dev_info(&hif_dev->udev->dev, "ath9k_htc: Firmware %s requested\n",
-		 hif_dev->fw_name);
-
-	return 0;
+	return ret;
 
 err_fw_req:
 	usb_set_intfdata(interface, NULL);
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 51496e7..c55b786 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -17,8 +17,18 @@
 #ifndef HTC_USB_H
 #define HTC_USB_H
 
+/* old firmware images */
+#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
+#define FIRMWARE_AR9271         "htc_9271.fw"
+
+/* supported Major FW version */
 #define MAJOR_VERSION_REQ 1
 #define MINOR_VERSION_REQ 3
+/* minimal and maximal supported Minor FW version. */
+#define FIRMWARE_MINOR_IDX_MAX  4
+#define FIRMWARE_MINOR_IDX_MIN  3
+
+extern int htc_use_dev_fw;
 
 #define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
 
@@ -101,7 +111,8 @@ struct hif_device_usb {
 	struct usb_anchor reg_in_submitted;
 	struct usb_anchor mgmt_submitted;
 	struct sk_buff *remain_skb;
-	const char *fw_name;
+	char fw_name[32];
+	int fw_minor_index;
 	int rx_remain_len;
 	int rx_pkt_len;
 	int rx_transfer_len;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7468562..57ca9b6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -38,6 +38,10 @@ static int ath9k_ps_enable;
 module_param_named(ps_enable, ath9k_ps_enable, int, 0444);
 MODULE_PARM_DESC(ps_enable, "Enable WLAN PowerSave");
 
+int htc_use_dev_fw = 0;
+module_param_named(use_dev_fw, htc_use_dev_fw, int, 0444);
+MODULE_PARM_DESC(use_dev_fw, "Use development FW version");
+
 #ifdef CONFIG_MAC80211_LEDS
 int ath9k_htc_led_blink = 1;
 module_param_named(blink, ath9k_htc_led_blink, int, 0444);
-- 
2.1.4

