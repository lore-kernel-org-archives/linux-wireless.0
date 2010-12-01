Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33816 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab0LAHAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 02:00:44 -0500
Received: by gxk1 with SMTP id 1so268673gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 23:00:44 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19701.62091.644444.121284@gargle.gargle.HOWL>
Date: Wed, 1 Dec 2010 12:30:27 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k_htc: Fix suspend/resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The HW has to be set to FULLSLEEP mode during suspend,
when no interface has been brought up. Not doing this would
break resume, as the chip won't be powered up at all.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      |    7 +++++++
 drivers/net/wireless/ath/ath9k/htc.h          |    3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    6 ++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++--
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index ae842db..6372c64 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1019,6 +1019,13 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 	struct hif_device_usb *hif_dev =
 		(struct hif_device_usb *) usb_get_intfdata(interface);
 
+	/*
+	 * The device has to be set to FULLSLEEP mode in case no
+	 * interface is up.
+	 */
+	if (!(hif_dev->flags & HIF_USB_START))
+		ath9k_htc_suspend(hif_dev->htc_handle);
+
 	ath9k_hif_usb_dealloc_urbs(hif_dev);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index afe39a9..fdf9d5f 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -455,6 +455,8 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv);
 void ath9k_htc_ps_wakeup(struct ath9k_htc_priv *priv);
 void ath9k_htc_ps_restore(struct ath9k_htc_priv *priv);
 void ath9k_ps_work(struct work_struct *work);
+bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
+			enum ath9k_power_mode mode);
 
 void ath9k_start_rfkill_poll(struct ath9k_htc_priv *priv);
 void ath9k_init_leds(struct ath9k_htc_priv *priv);
@@ -464,6 +466,7 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 			   u16 devid, char *product, u32 drv_info);
 void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug);
 #ifdef CONFIG_PM
+void ath9k_htc_suspend(struct htc_target *htc_handle);
 int ath9k_htc_resume(struct htc_target *htc_handle);
 #endif
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 071d0c9..3b172ea 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -888,6 +888,12 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 }
 
 #ifdef CONFIG_PM
+
+void ath9k_htc_suspend(struct htc_target *htc_handle)
+{
+	ath9k_htc_setpower(htc_handle->drv_priv, ATH9K_PM_FULL_SLEEP);
+}
+
 int ath9k_htc_resume(struct htc_target *htc_handle)
 {
 	struct ath9k_htc_priv *priv = htc_handle->drv_priv;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 8266ce1..1f62155 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -63,8 +63,8 @@ static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 	return mode;
 }
 
-static bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
-			       enum ath9k_power_mode mode)
+bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
+			enum ath9k_power_mode mode)
 {
 	bool ret;
 
-- 
1.7.3.2

