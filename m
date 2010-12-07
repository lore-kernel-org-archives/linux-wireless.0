Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55378 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab0LGLCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 06:02:15 -0500
Received: by pva4 with SMTP id 4so2051658pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 03:02:15 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19710.5138.516088.604747@gargle.gargle.HOWL>
Date: Tue, 7 Dec 2010 16:31:38 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k_htc: Cleanup device identification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

ath.ko is a common module shared between ath5k, ar9170usb, ath9k and ath9k_htc.
Adding driver specific data to the shared structure would impact all the
drivers. Handling USB device recognition for devices specific to ath9k_htc
can be handled within the driver itself.

Also, AR7010 refers to the processor used in both AR9280/AR9287 based
devices. Rename the device enumerations accordingly.

While at it, check properly for the bus type when choosing the EEPROM
base address for UB95.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath.h                |    6 ----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c  |    6 ++--
 drivers/net/wireless/ath/ath9k/hif_usb.c      |   32 +++++++++++-------------
 drivers/net/wireless/ath/ath9k/hif_usb.h      |    2 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 ++--
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/reg.h          |    8 +++++-
 7 files changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 26bdbee..3743e3b 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -104,11 +104,6 @@ enum ath_cipher {
 	ATH_CIPHER_MIC = 127
 };
 
-enum ath_drv_info {
-	AR7010_DEVICE		= BIT(0),
-	AR9287_DEVICE		= BIT(1),
-};
-
 /**
  * struct ath_ops - Register read/write operations
  *
@@ -152,7 +147,6 @@ struct ath_common {
 	u8 rx_chainmask;
 
 	u32 rx_bufsize;
-	u32 driver_info;
 
 	u32 keymax;
 	DECLARE_BITMAP(keymap, ATH_KEYMAX);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index bcb9ed3..dbb788e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -37,10 +37,10 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	int addr, eep_start_loc;
 	eep_data = (u16 *)eep;
 
-	if (!common->driver_info)
-		eep_start_loc = AR9287_EEP_START_LOC;
-	else
+	if (common->bus_ops->ath_bus_type == ATH_USB)
 		eep_start_loc = AR9287_HTC_EEP_START_LOC;
+	else
+		eep_start_loc = AR9287_EEP_START_LOC;
 
 	if (!ath9k_hw_use_flash(ah)) {
 		ath_print(common, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8946e8a..cc1e5b3 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -28,16 +28,7 @@ MODULE_FIRMWARE(FIRMWARE_AR9271);
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
-	{ USB_DEVICE(0x0cf3, 0x7010),
-		.driver_info = AR7010_DEVICE },
-					/* Atheros */
-	{ USB_DEVICE(0x0cf3, 0x7015),
-		.driver_info = AR7010_DEVICE | AR9287_DEVICE },
-					/* Atheros */
 	{ USB_DEVICE(0x0846, 0x9030) }, /* Netgear N150 */
-	{ USB_DEVICE(0x0846, 0x9018),
-		.driver_info = AR7010_DEVICE },
-					/* Netgear WNDA3200 */
 	{ USB_DEVICE(0x07D1, 0x3A10) }, /* Dlink Wireless 150 */
 	{ USB_DEVICE(0x13D3, 0x3327) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3328) }, /* Azurewave */
@@ -46,13 +37,20 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x13D3, 0x3349) }, /* Azurewave */
 	{ USB_DEVICE(0x13D3, 0x3350) }, /* Azurewave */
 	{ USB_DEVICE(0x04CA, 0x4605) }, /* Liteon */
-	{ USB_DEVICE(0x083A, 0xA704),
-		.driver_info = AR7010_DEVICE },
-					/* SMC Networks */
 	{ USB_DEVICE(0x040D, 0x3801) }, /* VIA */
+
+	{ USB_DEVICE(0x0cf3, 0x7015),
+	  .driver_info = AR9287_USB },  /* Atheros */
 	{ USB_DEVICE(0x1668, 0x1200),
-		.driver_info = AR7010_DEVICE | AR9287_DEVICE },
-					/* Verizon */
+	  .driver_info = AR9287_USB },  /* Verizon */
+
+	{ USB_DEVICE(0x0cf3, 0x7010),
+	  .driver_info = AR9280_USB },  /* Atheros */
+	{ USB_DEVICE(0x0846, 0x9018),
+	  .driver_info = AR9280_USB },  /* Netgear WNDA3200 */
+	{ USB_DEVICE(0x083A, 0xA704),
+	  .driver_info = AR9280_USB },  /* SMC Networks */
+
 	{ },
 };
 
@@ -818,7 +816,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev,
 	}
 	kfree(buf);
 
-	if (drv_info & AR7010_DEVICE)
+	if (IS_AR7010_DEVICE(drv_info))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -934,7 +932,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	/* Find out which firmware to load */
 
-	if (id->driver_info & AR7010_DEVICE)
+	if (IS_AR7010_DEVICE(id->driver_info))
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
 			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
 		else
@@ -1034,7 +1032,7 @@ static int ath9k_hif_usb_resume(struct usb_interface *interface)
 
 	if (hif_dev->firmware) {
 		ret = ath9k_hif_usb_download_fw(hif_dev,
-				htc_handle->drv_priv->ah->common.driver_info);
+				htc_handle->drv_priv->ah->hw_version.usbdev);
 		if (ret)
 			goto fail_resume;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.h b/drivers/net/wireless/ath/ath9k/hif_usb.h
index 2daf97b..e4a5e2e 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.h
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.h
@@ -17,6 +17,8 @@
 #ifndef HTC_USB_H
 #define HTC_USB_H
 
+#define IS_AR7010_DEVICE(_v) (((_v) == AR9280_USB) || ((_v) == AR9287_USB))
+
 #define AR9271_FIRMWARE       0x501000
 #define AR9271_FIRMWARE_TEXT  0x903000
 #define AR7010_FIRMWARE_TEXT  0x906000
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 071d0c9..0709315 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -246,7 +246,7 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid,
 	 * the HIF layer, shouldn't matter much.
 	 */
 
-	if (drv_info & AR7010_DEVICE)
+	if (IS_AR7010_DEVICE(drv_info))
 		priv->htc->credits = 45;
 	else
 		priv->htc->credits = 33;
@@ -636,6 +636,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = 0; /* FIXME */
+	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
 	priv->ah = ah;
 
@@ -646,7 +647,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->hw = priv->hw;
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
-	common->driver_info = drv_info;
 
 	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
@@ -898,7 +898,7 @@ int ath9k_htc_resume(struct htc_target *htc_handle)
 		return ret;
 
 	ret = ath9k_init_htc_services(priv, priv->ah->hw_version.devid,
-				      priv->ah->common.driver_info);
+				      priv->ah->hw_version.usbdev);
 	return ret;
 }
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 5fcfa48..e9db2ff 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -442,6 +442,7 @@ struct ath9k_hw_version {
 	u16 analog5GhzRev;
 	u16 analog2GhzRev;
 	u16 subsysid;
+	enum ath_usb_dev usbdev;
 };
 
 /* Generic TSF timer definitions */
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index c2472ed..71ec197 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -863,8 +863,14 @@
     (AR_SREV_9285_12_OR_LATER(_ah) && \
      ((REG_READ(_ah, AR_AN_SYNTH9) & 0x7) == 0x1))
 
+enum ath_usb_dev {
+	AR9280_USB = 1, /* AR7010 + AR9280, UB94 */
+	AR9287_USB = 2, /* AR7010 + AR9287, UB95 */
+};
+
 #define AR_DEVID_7010(_ah) \
-	((_ah)->common.driver_info & AR7010_DEVICE)
+	(((_ah)->hw_version.usbdev == AR9280_USB) || \
+	 ((_ah)->hw_version.usbdev == AR9287_USB))
 
 #define AR_RADIO_SREV_MAJOR                   0xf0
 #define AR_RAD5133_SREV_MAJOR                 0xc0
-- 
1.7.3.2

