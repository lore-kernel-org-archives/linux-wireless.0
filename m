Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61396 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1ADTuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 14:50:55 -0500
Received: by pva4 with SMTP id 4so2634665pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 11:50:55 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19747.31249.385185.637500@gargle.gargle.HOWL>
Date: Wed, 5 Jan 2011 01:20:41 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH v2] ath9k_htc: Fix warning on device removal
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The commit "ath9k_hw: warn if we cannot change the power to the chip"
introduced a new warning to indicate chip powerup failures, but this
is not required for devices that have been removed. Handle USB device
removal properly by checking for unplugged status.

For PCI devices, this warning will still be seen when the card is pulled
out, not sure how to check for card removal.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/eeprom.h       |    2 --
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    6 +++---
 drivers/net/wireless/ath/ath9k/htc.h          |    5 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    5 +----
 drivers/net/wireless/ath/ath9k/hw.c           |    4 +++-
 drivers/net/wireless/ath/ath9k/hw.h           |    4 ++++
 drivers/net/wireless/ath/ath9k/wmi.c          |    2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index f6f09d1..58e2ddc 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -23,8 +23,6 @@
 #include <net/cfg80211.h>
 #include "ar9003_eeprom.h"
 
-#define AH_USE_EEPROM   0x1
-
 #ifdef __BIG_ENDIAN
 #define AR5416_EEPROM_MAGIC 0x5aa5
 #else
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 22b68b3..c20c8c8 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -993,16 +993,16 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 {
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct hif_device_usb *hif_dev = usb_get_intfdata(interface);
+	bool unplugged = (udev->state == USB_STATE_NOTATTACHED) ? true : false;
 
 	if (hif_dev) {
-		ath9k_htc_hw_deinit(hif_dev->htc_handle,
-		    (udev->state == USB_STATE_NOTATTACHED) ? true : false);
+		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
 		ath9k_htc_hw_free(hif_dev->htc_handle);
 		ath9k_hif_usb_dev_deinit(hif_dev);
 		usb_set_intfdata(interface, NULL);
 	}
 
-	if (hif_dev->flags & HIF_USB_START)
+	if (!unplugged && (hif_dev->flags & HIF_USB_START))
 		ath9k_hif_usb_reboot(udev);
 
 	kfree(hif_dev);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index fdf9d5f..e6c2f0a 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -339,9 +339,8 @@ void ath_htc_cancel_btcoex_work(struct ath9k_htc_priv *priv);
 #define OP_ASSOCIATED		   BIT(7)
 #define OP_ENABLE_BEACON	   BIT(8)
 #define OP_LED_DEINIT		   BIT(9)
-#define OP_UNPLUGGED		   BIT(10)
-#define OP_BT_PRIORITY_DETECTED	   BIT(11)
-#define OP_BT_SCAN		   BIT(12)
+#define OP_BT_PRIORITY_DETECTED    BIT(10)
+#define OP_BT_SCAN                 BIT(11)
 
 struct ath9k_htc_priv {
 	struct device *dev;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 0f6be35..724f545 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -851,9 +851,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
-	/* The device may have been unplugged earlier. */
-	priv->op_flags &= ~OP_UNPLUGGED;
-
 	ret = ath9k_init_device(priv, devid, product, drv_info);
 	if (ret)
 		goto err_init;
@@ -873,7 +870,7 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 
 		/* Check if the device has been yanked out. */
 		if (hotunplug)
-			htc_handle->drv_priv->op_flags |= OP_UNPLUGGED;
+			htc_handle->drv_priv->ah->ah_flags |= AH_UNPLUGGED;
 
 		ath9k_deinit_device(htc_handle->drv_priv);
 		ath9k_deinit_wmi(htc_handle->drv_priv);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4b51ed4..fde9786 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1615,7 +1615,9 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	 * simply keep the ATH_DBG_WARN_ON_ONCE() but make
 	 * ath9k_hw_setpower() return type void.
 	 */
-	ATH_DBG_WARN_ON_ONCE(!status);
+
+	if (!(ah->ah_flags & AH_UNPLUGGED))
+		ATH_DBG_WARN_ON_ONCE(!status);
 
 	return status;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b8ffaa5..5a3dfec 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -646,6 +646,10 @@ struct ath_nf_limits {
 	s16 nominal;
 };
 
+/* ah_flags */
+#define AH_USE_EEPROM   0x1
+#define AH_UNPLUGGED    0x2 /* The card has been physically removed. */
+
 struct ath_hw {
 	struct ieee80211_hw *hw;
 	struct ath_common common;
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 8f42ea7..573daca 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -250,7 +250,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	int time_left, ret = 0;
 	unsigned long flags;
 
-	if (wmi->drv_priv->op_flags & OP_UNPLUGGED)
+	if (ah->ah_flags & AH_UNPLUGGED)
 		return 0;
 
 	skb = alloc_skb(headroom + cmd_len, GFP_ATOMIC);
-- 
1.7.3.4

