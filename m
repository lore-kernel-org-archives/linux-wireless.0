Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12396 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934327Ab0HMNEm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 09:04:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Aug 2010 06:04:42 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: load proper firmware for device ID 7015
Date: Fri, 13 Aug 2010 18:36:40 +0530
Message-ID: <1281704800-4422-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch handles the firmware loading properly
for device ID 7015.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h       |    1 +
 drivers/net/wireless/ath/ath9k/eeprom_9287.c  |    7 ++++++-
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    8 ++------
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    1 +
 drivers/net/wireless/ath/ath9k/reg.h          |    1 +
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 8750c55..7f48df1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -191,6 +191,7 @@
 #define AR9287_EEP_NO_BACK_VER       AR9287_EEP_MINOR_VER_1
 
 #define AR9287_EEP_START_LOC            128
+#define AR9287_HTC_EEP_START_LOC        256
 #define AR9287_NUM_2G_CAL_PIERS         3
 #define AR9287_NUM_2G_CCK_TARGET_POWERS 3
 #define AR9287_NUM_2G_20_TARGET_POWERS  3
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 4a52cf0..dff2da7 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -34,9 +34,14 @@ static bool ath9k_hw_ar9287_fill_eeprom(struct ath_hw *ah)
 	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u16 *eep_data;
-	int addr, eep_start_loc = AR9287_EEP_START_LOC;
+	int addr, eep_start_loc;
 	eep_data = (u16 *)eep;
 
+	if (ah->hw_version.devid == 0x7015)
+		eep_start_loc = AR9287_HTC_EEP_START_LOC;
+	else
+		eep_start_loc = AR9287_EEP_START_LOC;
+
 	if (!ath9k_hw_use_flash(ah)) {
 		ath_print(common, ATH_DBG_EEPROM,
 			  "Reading from EEPROM, not flash\n");
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 61c1bee..17e7a9a 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -799,7 +799,7 @@ static int ath9k_hif_usb_download_fw(struct hif_device_usb *hif_dev)
 	}
 	kfree(buf);
 
-	if (hif_dev->device_id == 0x7010)
+	if ((hif_dev->device_id == 0x7010) || (hif_dev->device_id == 0x7015))
 		firm_offset = AR7010_FIRMWARE_TEXT;
 	else
 		firm_offset = AR9271_FIRMWARE_TEXT;
@@ -901,6 +901,7 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 
 	switch(hif_dev->device_id) {
 	case 0x7010:
+	case 0x7015:
 	case 0x9018:
 		if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x0202)
 			hif_dev->fw_name = FIRMWARE_AR7010_1_1;
@@ -912,11 +913,6 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 		break;
 	}
 
-	if (!hif_dev->fw_name) {
-		dev_err(&udev->dev, "Can't determine firmware !\n");
-		goto err_htc_hw_alloc;
-	}
-
 	ret = ath9k_hif_usb_dev_init(hif_dev);
 	if (ret) {
 		ret = -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 148b433..2d42791 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -245,6 +245,7 @@ static int ath9k_init_htc_services(struct ath9k_htc_priv *priv, u16 devid)
 
 	switch(devid) {
 	case 0x7010:
+	case 0x7015:
 	case 0x9018:
 		priv->htc->credits = 45;
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 633e3d9..d01c4ad 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -899,6 +899,7 @@
 
 #define AR_DEVID_7010(_ah) \
 	(((_ah)->hw_version.devid == 0x7010) || \
+	 ((_ah)->hw_version.devid == 0x7015) || \
 	 ((_ah)->hw_version.devid == 0x9018))
 
 #define AR_RADIO_SREV_MAJOR                   0xf0
-- 
1.7.2.1

