Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22586 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab0KSLQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 06:16:32 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Nov 2010 03:16:19 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/4] ath9k_htc: Identify devices using driver_info
Date: Fri, 19 Nov 2010 16:53:22 +0530
Message-ID: <1290165802-3566-4-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
References: <1290165802-3566-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Categorize AR7010 & AR9287 devices based on driver_info
of usb_device_id, instead of PIDs. This avoids per-device cases
and minimize code changes for new device addition.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   41 ++++++++----------------
 drivers/net/wireless/ath/ath9k/htc.h          |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   35 ++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_hst.c      |    5 ++-
 drivers/net/wireless/ath/ath9k/htc_hst.h      |    3 +-
 drivers/net/wireless/ath/ath9k/reg.h          |    6 +---
 6 files changed, 37 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 6a0dbd1..ae842db 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -786,7 +786,8 @@ static void ath9k_hif_usb_dealloc_urbs(struct hif_device_usb *hif_dev)
 	ath9k_hif_usb_dealloc_rx_urbs(hif_dev);
 }
 
-static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
+static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev,
+				     u32 drv_info)
 {
 	int transfer, err;
 	const void *data = hif_dev->firmware->data;
@@ -817,18 +818,10 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	switch (hif_dev->device_id) {
-	case 0x7010:
-	case 0x7015:
-	case 0x9018:
-	case 0xA704:
-	case 0x1200:
+	if (drv_info & AR7010_DEVICE)
 		firm_offset = AR7010_FIRMWARE_TEXT;
-		break;
-	default:
+	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
-		break;
-	}
 
 	/*
 	 * Issue FW download complete command to firmware.
@@ -846,7 +839,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	return 0;
 }
 
-static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
+static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev, u32 drv_info)
 {
 	int ret, idx;
 	struct usb_host_interface *alt = &hif_dev->interface->altsetting[0];
@@ -862,7 +855,7 @@ static int ath9k_hif_usb_dev_init(struct hif_device_usb *hif_dev)
 	}
 
 	/* Download firmware */
-	ret = ath9k_hif_usb_download_fw(hif_dev);
+	ret = ath9k_hif_usb_download_fw(hif_dev, drv_info);
 	if (ret) {
 		dev_err(&hif_dev->udev->dev,
 			"ath9k_htc: Firmware - %s download failed\n",
@@ -941,23 +934,15 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	/* Find out which firmware to load */
 
-	switch(hif_dev->device_id) {
-	case 0x7010:
-	case 0x7015:
-	case 0x9018:
-	case 0xA704:
-	case 0x1200:
+	if (id->driver_info & AR7010_DEVICE)
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
 			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
 		else
 			hif_dev->fw_name = FIRMWARE_AR7010;
-		break;
-	default:
+	else
 		hif_dev->fw_name = FIRMWARE_AR9271;
-		break;
-	}
 
-	ret = ath9k_hif_usb_dev_init(hif_dev);
+	ret = ath9k_hif_usb_dev_init(hif_dev, id->driver_info);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_hif_init_usb;
@@ -965,7 +950,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	ret = ath9k_htc_hw_init(hif_dev->htc_handle,
 				&hif_dev->udev->dev, hif_dev->device_id,
-				hif_dev->udev->product);
+				hif_dev->udev->product, id->driver_info);
 	if (ret) {
 		ret = -EINVAL;
 		goto err_htc_hw_init;
@@ -1043,6 +1028,7 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 {
 	struct hif_device_usb *hif_dev =
 		(struct hif_device_usb *) usb_get_intfdata(interface);
+	struct htc_target *htc_handle = hif_dev->htc_handle;
 	int ret;
 
 	ret = ath9k_hif_usb_alloc_urbs(hif_dev);
@@ -1050,7 +1036,8 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 		return ret;
 
 	if (hif_dev->firmware) {
-		ret = ath9k_hif_usb_download_fw(hif_dev);
+		ret = ath9k_hif_usb_download_fw(hif_dev,
+				htc_handle->drv_priv->ah->common.driver_info);
 		if (ret)
 			goto fail_resume;
 	} else {
@@ -1060,7 +1047,7 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 
 	mdelay(100);
 
-	ret = ath9k_htc_resume(hif_dev->htc_handle);
+	ret = ath9k_htc_resume(htc_handle);
 
 	if (ret)
 		goto fail_resume;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index db00289..afe39a9 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -461,7 +461,7 @@ void ath9k_init_leds(struct ath9k_htc_priv *priv);
 void ath9k_deinit_leds(struct ath9k_htc_priv *priv);
 
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
-			   u16 devid, char *product);
+			   u16 devid, char *product, u32 drv_info);
 void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug);
 #ifdef CONFIG_PM
 int ath9k_htc_resume(struct htc_target *htc_handle);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 7c8a38d..8e6a9a8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -181,7 +181,8 @@ static inline int ath9k_htc_connect_svc(struct ath9k_htc_priv *priv,
 	return htc_connect_service(priv->htc, &req, ep_id);
 }
 
-static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
+static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid,
+				   u32 drv_info)
 {
 	int ret;
 
@@ -245,17 +246,10 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
 	 * the HIF layer, shouldn't matter much.
 	 */
 
-	switch(devid) {
-	case 0x7010:
-	case 0x7015:
-	case 0x9018:
-	case 0xA704:
-	case 0x1200:
+	if (drv_info & AR7010_DEVICE)
 		priv->htc->credits = 45;
-		break;
-	default:
+	else
 		priv->htc->credits = 33;
-	}
 
 	ret = htc_init(priv->htc);
 	if (ret)
@@ -627,7 +621,8 @@ static void ath9k_init_btcoex(struct ath9k_htc_priv *priv)
 }
 
 static int ath9k_init_priv(struct ath9k_htc_priv *priv,
-			   u16 devid, char *product)
+			   u16 devid, char *product,
+			   u32 drv_info)
 {
 	struct ath_hw *ah = NULL;
 	struct ath_common *common;
@@ -650,6 +645,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->hw = priv->hw;
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
+	common->driver_info = drv_info;
 
 	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
@@ -762,7 +758,7 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 }
 
 static int ath9k_init_device(struct ath9k_htc_priv *priv,
-			     u16 devid, char *product)
+			     u16 devid, char *product, u32 drv_info)
 {
 	struct ieee80211_hw *hw = priv->hw;
 	struct ath_common *common;
@@ -771,7 +767,7 @@ static int ath9k_init_device(struct ath9k_htc_priv *priv,
 	struct ath_regulatory *reg;
 
 	/* Bring up device */
-	error = ath9k_init_priv(priv, devid, product);
+	error = ath9k_init_priv(priv, devid, product, drv_info);
 	if (error != 0)
 		goto err_init;
 
@@ -829,7 +825,7 @@ err_init:
 }
 
 int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
-			   u16 devid, char *product)
+			   u16 devid, char *product, u32 drv_info)
 {
 	struct ieee80211_hw *hw;
 	struct ath9k_htc_priv *priv;
@@ -856,14 +852,14 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 		goto err_free;
 	}
 
-	ret = ath9k_init_htc_services(priv, devid);
+	ret = ath9k_init_htc_services(priv, devid, drv_info);
 	if (ret)
 		goto err_init;
 
 	/* The device may have been unplugged earlier. */
 	priv->op_flags &= ~OP_UNPLUGGED;
 
-	ret = ath9k_init_device(priv, devid, product);
+	ret = ath9k_init_device(priv, devid, product, drv_info);
 	if (ret)
 		goto err_init;
 
@@ -893,14 +889,15 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 #ifdef CONFIG_PM
 int ath9k_htc_resume(struct htc_target *htc_handle)
 {
+	struct ath9k_htc_priv *priv = htc_handle->drv_priv;
 	int ret;
 
-	ret = ath9k_htc_wait_for_target(htc_handle->drv_priv);
+	ret = ath9k_htc_wait_for_target(priv);
 	if (ret)
 		return ret;
 
-	ret = ath9k_init_htc_services(htc_handle->drv_priv,
-			      htc_handle->drv_priv->ah->hw_version.devid);
+	ret = ath9k_init_htc_services(priv, priv->ah->hw_version.devid,
+				      priv->ah->common.driver_info);
 	return ret;
 }
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 861ec92..c41ab8c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -462,9 +462,10 @@ void ath9k_htc_hw_free(struct htc_target *htc)
 }
 
 int ath9k_htc_hw_init(struct htc_target *target,
-		      struct device *dev, u16 devid, char *product)
+		      struct device *dev, u16 devid,
+		      char *product, u32 drv_info)
 {
-	if (ath9k_htc_probe_device(target, dev, devid, product)) {
+	if (ath9k_htc_probe_device(target, dev, devid, product, drv_info)) {
 		printk(KERN_ERR "Failed to initialize the device\n");
 		return -ENODEV;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.h b/drivers/net/wireless/ath/ath9k/htc_hst.h
index 07b6509..6fc1b21 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.h
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.h
@@ -239,7 +239,8 @@ struct htc_target *ath9k_htc_hw_alloc(void *hif_handle,
 				      struct device *dev);
 void ath9k_htc_hw_free(struct htc_target *htc);
 int ath9k_htc_hw_init(struct htc_target *target,
-		      struct device *dev, u16 devid, char *product);
+		      struct device *dev, u16 devid, char *product,
+		      u32 drv_info);
 void ath9k_htc_hw_deinit(struct htc_target *target, bool hot_unplug);
 
 #endif /* HTC_HST_H */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index f444a37..556e2ca 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -864,11 +864,7 @@
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
 
 #define AR_DEVID_7010(_ah) \
-	(((_ah)->hw_version.devid == 0x7010) || \
-	 ((_ah)->hw_version.devid == 0x7015) || \
-	 ((_ah)->hw_version.devid == 0x9018) || \
-	 ((_ah)->hw_version.devid == 0xA704) || \
-	 ((_ah)->hw_version.devid == 0x1200))
+	((_ah)->common.driver_info & AR7010_DEVICE)
 
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
-- 
1.7.3.2

