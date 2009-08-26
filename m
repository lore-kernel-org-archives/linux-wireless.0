Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:35431 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZHZQyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 12:54:18 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 2/2] rtl8187: Implement rfkill support
Date: Wed, 26 Aug 2009 13:54:09 -0300
Message-Id: <1251305649-12508-2-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1251305649-12508-1-git-send-email-herton@mandriva.com.br>
References: <1251305649-12508-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change implements rfkill support for RTL8187B and RTL8187L devices,
using new cfg80211 rfkill API.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl818x/Makefile         |    2 +-
 drivers/net/wireless/rtl818x/rtl8187.h        |    1 +
 drivers/net/wireless/rtl818x/rtl8187_dev.c    |   28 ++++++-----
 drivers/net/wireless/rtl818x/rtl8187_leds.c   |    4 +-
 drivers/net/wireless/rtl818x/rtl8187_rfkill.c |   63 +++++++++++++++++++++++++
 drivers/net/wireless/rtl818x/rtl8187_rfkill.h |    8 +++
 drivers/net/wireless/rtl818x/rtl818x.h        |    5 +-
 7 files changed, 94 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187_rfkill.c
 create mode 100644 drivers/net/wireless/rtl818x/rtl8187_rfkill.h

diff --git a/drivers/net/wireless/rtl818x/Makefile b/drivers/net/wireless/rtl818x/Makefile
index 37e3d4d..93cbfbe 100644
--- a/drivers/net/wireless/rtl818x/Makefile
+++ b/drivers/net/wireless/rtl818x/Makefile
@@ -1,5 +1,5 @@
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
-rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o
+rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o rtl8187_leds.o rtl8187_rfkill.o
 
 obj-$(CONFIG_RTL8180)	+= rtl8180.o
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
diff --git a/drivers/net/wireless/rtl818x/rtl8187.h b/drivers/net/wireless/rtl818x/rtl8187.h
index c09bfef..bf9175a 100644
--- a/drivers/net/wireless/rtl818x/rtl8187.h
+++ b/drivers/net/wireless/rtl818x/rtl8187.h
@@ -133,6 +133,7 @@ struct rtl8187_priv {
 		__le16 bits16;
 		__le32 bits32;
 	} *io_dmabuf;
+	bool rfkill_off;
 };
 
 void rtl8187_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 75b63ac..2017ccc 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -32,6 +32,7 @@
 #ifdef CONFIG_RTL8187_LEDS
 #include "rtl8187_leds.h"
 #endif
+#include "rtl8187_rfkill.h"
 
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
@@ -648,10 +649,10 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 
 	/* setup card */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0);
-	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, 0);
 
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, (4 << 8));
-	rtl818x_iowrite8(priv, &priv->map->GPIO, 1);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, 1);
 	rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0);
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
@@ -674,11 +675,11 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 
 	/* host_usb_init */
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0);
-	rtl818x_iowrite8(priv, &priv->map->GPIO, 0);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, 0);
 	reg = rtl818x_ioread8(priv, (u8 *)0xFE53);
 	rtl818x_iowrite8(priv, (u8 *)0xFE53, reg | (1 << 7));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, (4 << 8));
-	rtl818x_iowrite8(priv, &priv->map->GPIO, 0x20);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, 0x20);
 	rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x80);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x80);
@@ -910,12 +911,12 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	u32 reg;
 	int ret;
 
+	mutex_lock(&priv->conf_mutex);
+
 	ret = (!priv->is_rtl8187b) ? rtl8187_init_hw(dev) :
 				     rtl8187b_init_hw(dev);
 	if (ret)
-		return ret;
-
-	mutex_lock(&priv->conf_mutex);
+		goto rtl8187_start_exit;
 
 	init_usb_anchor(&priv->anchored);
 	priv->dev = dev;
@@ -942,8 +943,7 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 				  (7 << 21 /* MAX TX DMA */));
 		rtl8187_init_urbs(dev);
 		rtl8187b_init_status_urb(dev);
-		mutex_unlock(&priv->conf_mutex);
-		return 0;
+		goto rtl8187_start_exit;
 	}
 
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
@@ -987,9 +987,10 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	reg |= RTL818X_CMD_RX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 	INIT_DELAYED_WORK(&priv->work, rtl8187_work);
-	mutex_unlock(&priv->conf_mutex);
 
-	return 0;
+rtl8187_start_exit:
+	mutex_unlock(&priv->conf_mutex);
+	return ret;
 }
 
 static void rtl8187_stop(struct ieee80211_hw *dev)
@@ -1283,7 +1284,8 @@ static const struct ieee80211_ops rtl8187_ops = {
 	.bss_info_changed	= rtl8187_bss_info_changed,
 	.prepare_multicast	= rtl8187_prepare_multicast,
 	.configure_filter	= rtl8187_configure_filter,
-	.conf_tx		= rtl8187_conf_tx
+	.conf_tx		= rtl8187_conf_tx,
+	.rfkill_poll		= rtl8187_rfkill_poll
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
@@ -1523,6 +1525,7 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	reg &= 0xFF;
 	rtl8187_leds_init(dev, reg);
 #endif
+	rtl8187_rfkill_init(dev);
 
 	return 0;
 
@@ -1546,6 +1549,7 @@ static void __devexit rtl8187_disconnect(struct usb_interface *intf)
 #ifdef CONFIG_RTL8187_LEDS
 	rtl8187_leds_exit(dev);
 #endif
+	rtl8187_rfkill_exit(dev);
 	ieee80211_unregister_hw(dev);
 
 	priv = dev->priv;
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index a6cfb7e..a1c670f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -42,7 +42,7 @@ static void led_turn_on(struct work_struct *work)
 	mutex_lock(&priv->conf_mutex);
 	switch (led->ledpin) {
 	case LED_PIN_GPIO0:
-		rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
+		rtl818x_iowrite8(priv, &priv->map->GPIO0, 0x01);
 		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x00);
 		break;
 	case LED_PIN_LED0:
@@ -80,7 +80,7 @@ static void led_turn_off(struct work_struct *work)
 	mutex_lock(&priv->conf_mutex);
 	switch (led->ledpin) {
 	case LED_PIN_GPIO0:
-		rtl818x_iowrite8(priv, &priv->map->GPIO, 0x01);
+		rtl818x_iowrite8(priv, &priv->map->GPIO0, 0x01);
 		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0x01);
 		break;
 	case LED_PIN_LED0:
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rfkill.c b/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
new file mode 100644
index 0000000..9fab13e
--- /dev/null
+++ b/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
@@ -0,0 +1,63 @@
+/*
+ * Linux RFKILL support for RTL8187
+ *
+ * Copyright (c) 2009 Herton Ronaldo Krzesinski <herton@mandriva.com.br>
+ *
+ * Based on the RFKILL handling in the r8187 driver, which is:
+ * Copyright (c) Realtek Semiconductor Corp. All rights reserved.
+ *
+ * Thanks to Realtek for their support!
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/types.h>
+#include <linux/usb.h>
+#include <net/mac80211.h>
+
+#include "rtl8187.h"
+
+static bool rtl8187_is_radio_enabled(struct rtl8187_priv *priv)
+{
+	u8 gpio;
+
+	gpio = rtl818x_ioread8(priv, &priv->map->GPIO0);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
+	gpio = rtl818x_ioread8(priv, &priv->map->GPIO1);
+
+	return gpio & 0x02;
+}
+
+void rtl8187_rfkill_init(struct ieee80211_hw *hw)
+{
+	struct rtl8187_priv *priv = hw->priv;
+
+	priv->rfkill_off = rtl8187_is_radio_enabled(priv);
+	printk(KERN_INFO "rtl8187: wireless switch is %s\n",
+	       priv->rfkill_off ? "on" : "off");
+	wiphy_rfkill_set_hw_state(hw->wiphy, !priv->rfkill_off);
+	wiphy_rfkill_start_polling(hw->wiphy);
+}
+
+void rtl8187_rfkill_poll(struct ieee80211_hw *hw)
+{
+	bool enabled;
+	struct rtl8187_priv *priv = hw->priv;
+
+	mutex_lock(&priv->conf_mutex);
+	enabled = rtl8187_is_radio_enabled(priv);
+	if (unlikely(enabled != priv->rfkill_off)) {
+		priv->rfkill_off = enabled;
+		printk(KERN_INFO "rtl8187: wireless radio switch turned %s\n",
+		       enabled ? "on" : "off");
+		wiphy_rfkill_set_hw_state(hw->wiphy, !enabled);
+	}
+	mutex_unlock(&priv->conf_mutex);
+}
+
+void rtl8187_rfkill_exit(struct ieee80211_hw *hw)
+{
+	wiphy_rfkill_stop_polling(hw->wiphy);
+}
diff --git a/drivers/net/wireless/rtl818x/rtl8187_rfkill.h b/drivers/net/wireless/rtl818x/rtl8187_rfkill.h
new file mode 100644
index 0000000..e12575e
--- /dev/null
+++ b/drivers/net/wireless/rtl818x/rtl8187_rfkill.h
@@ -0,0 +1,8 @@
+#ifndef RTL8187_RFKILL_H
+#define RTL8187_RFKILL_H
+
+void rtl8187_rfkill_init(struct ieee80211_hw *hw);
+void rtl8187_rfkill_poll(struct ieee80211_hw *hw);
+void rtl8187_rfkill_exit(struct ieee80211_hw *hw);
+
+#endif /* RTL8187_RFKILL_H */
diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index 562222e..8522490 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -138,8 +138,9 @@ struct rtl818x_csr {
 	__le32	RF_PARA;
 	__le32	RF_TIMING;
 	u8	GP_ENABLE;
-	u8	GPIO;
-	u8	reserved_12[2];
+	u8	GPIO0;
+	u8	GPIO1;
+	u8	reserved_12;
 	__le32	HSSI_PARA;
 	u8	reserved_13[4];
 	u8	TX_AGC_CTL;
-- 
1.6.4.1

