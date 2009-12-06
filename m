Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55437 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740AbZLFBZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 20:25:24 -0500
Date: Sat, 05 Dec 2009 19:25:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: antti@kaijanmaki.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Fix regression noted in Bug #14743 - wrong
 rfkill switch mask for some models
Message-ID: <4b1b0802.TyTvmD6koeBpReIQ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are different bits used to convey the setting of the rfkill
switch to the driver. The current driver only supports one of these
possibilities. These changes were derived from the latest version
of the vendor driver.

This patch fixes the regression noted in kernel Bugzilla #14743.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested-by: Antti Kaijanmäki <antti@kaijanmaki.net>
Tested-by: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Stable <stable@vger.org>
---

John,

After seeing the response from DaveM regarding your last push, I expect
problems getting this into 2.6.33; however, it is a regression from 2.6.31
as noted in the Bug cited above.

Thanks,
Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
@@ -23,6 +23,7 @@
 #define RTL8187_EEPROM_TXPWR_CHAN_1	0x16	/* 3 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_6	0x1B	/* 2 channels */
 #define RTL8187_EEPROM_TXPWR_CHAN_4	0x3D	/* 2 channels */
+#define RTL8187_EEPROM_SELECT_GPIO	0x3B
 
 #define RTL8187_REQT_READ	0xC0
 #define RTL8187_REQT_WRITE	0x40
@@ -31,6 +32,9 @@
 
 #define RTL8187_MAX_RX		0x9C4
 
+#define RFKILL_MASK_8187_89_97	0x2
+#define RFKILL_MASK_8198	0x4
+
 struct rtl8187_rx_info {
 	struct urb *urb;
 	struct ieee80211_hw *dev;
@@ -122,6 +126,7 @@ struct rtl8187_priv {
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
@@ -1322,6 +1322,7 @@ static int __devinit rtl8187_probe(struc
 	struct ieee80211_channel *channel;
 	const char *chip_name;
 	u16 txpwr, reg;
+	u16 product_id = le16_to_cpu(udev->descriptor.idProduct);
 	int err, i;
 
 	dev = ieee80211_alloc_hw(sizeof(*priv), &rtl8187_ops);
@@ -1481,6 +1482,13 @@ static int __devinit rtl8187_probe(struc
 		(*channel++).hw_value = txpwr & 0xFF;
 		(*channel++).hw_value = txpwr >> 8;
 	}
+	/* Handle the differing rfkill GPIO bit in different models */
+	priv->rfkill_mask = RFKILL_MASK_8187_89_97;
+	if (product_id == 0x8197 || product_id == 0x8198) {
+		eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_SELECT_GPIO, &reg);
+		if (reg & 0xFF00)
+			priv->rfkill_mask = RFKILL_MASK_8198;
+	}
 
 	/*
 	 * XXX: Once this driver supports anything that requires
@@ -1509,9 +1513,9 @@ static int __devinit rtl8187_probe(struc
 	mutex_init(&priv->conf_mutex);
 	skb_queue_head_init(&priv->b_tx_status.queue);
 
-	printk(KERN_INFO "%s: hwaddr %pM, %s V%d + %s\n",
+	printk(KERN_INFO "%s: hwaddr %pM, %s V%d + %s, rfkill mask %d\n",
 	       wiphy_name(dev->wiphy), dev->wiphy->perm_addr,
-	       chip_name, priv->asic_rev, priv->rf->name);
+	       chip_name, priv->asic_rev, priv->rf->name, priv->rfkill_mask);
 
 #ifdef CONFIG_RTL8187_LEDS
 	eeprom_93cx6_read(&eeprom, 0x3F, &reg);
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
