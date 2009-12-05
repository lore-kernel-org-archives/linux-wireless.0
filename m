Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58919 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbZLETGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 14:06:06 -0500
Date: Sat, 05 Dec 2009 13:06:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: antti@kaijanmaki.net, Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC/RFT] rtl8187: Modify rfkill for new models
Message-ID: <4b1aaf22.c1/8Zgm/N0sxiN/O%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are different bits used to convey the setting of the rfkill
switch to the driver. The current driver only supports one of these
possibilities. These changes were derived from the latest version
of the vendor driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested-by: Antti Kaijanmäki <antti@kaijanmaki.net>
Tested-by: Hin-Tak Leung <hintak.leung@gmail.com>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -23,6 +23,7 @@
 #define RTL8187_EEPROM_TXPWR_CHAN_1	0x16	/* 3 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_6	0x1B	/* 2 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_4	0x3D	/* 2 channels */
+#define RTL8187_EEPROM_SELECT_GPIO	0x3B	/* Which pin has rfkill? */
 
 #define RTL8187_REQT_READ	0xC0
 #define RTL8187_REQT_WRITE	0x40
@@ -122,6 +123,7 @@ struct rtl8187_priv {
 	u8 noise;
 	u8 slot_time;
 	u8 aifsn[4];
+	u8 rfkill_mask;
 	struct {
 		__le64 buf;
 		struct sk_buff_head queue;
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1322,6 +1322,8 @@ static int __devinit rtl8187_probe(struc
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;
+	u16 product_id = le16_to_cpu(udev->descriptor.idProduct);
+	u16 tmp;
 	int err, i;
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &rtl8187_ops);
@@ -1481,6 +1483,18 @@ static int __devinit rtl8187_probe(struc
 		(*channel++).hw_value = txpwr & 0xFF;
 		(*channel++).hw_value = txpwr >> 8;
 	}
+	/* Handle the differing GPIO bit in different models */
+	if (product_id == 0x8197 || product_id == 0x8198) {
+		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_SELECT_GPIO, &tmp);
+		tmp &= 0xFF00;
+	} else
+		tmp = 0;
+	if (tmp)
+		priv->rfkill_mask = 0x4;
+	else
+		priv->rfkill_mask = 0x2;
+	printk(KERN_INFO "rtl8187: rfkill mask set to %d for Product ID 0x%x",
+	       priv->rfkill_mask, product_id);
 
 	/*
 	 * XXX: Once this driver supports anything that requires
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rfkill.c
@@ -25,10 +25,10 @@ static bool rtl8187_is_radio_enabled(str
 	u8 gpio;
 
 	gpio = rtl818x_ioread8(priv, &priv->map->GPIO0);
-	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~0x02);
+	rtl818x_iowrite8(priv, &priv->map->GPIO0, gpio & ~priv->rfkill_mask);
 	gpio = rtl818x_ioread8(priv, &priv->map->GPIO1);
 
-	return gpio & 0x02;
+	return gpio & priv->rfkill_mask;
 }
 
 void rtl8187_rfkill_init(struct ieee80211_hw *hw)
