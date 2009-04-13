Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62161 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZDMAlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 20:41:11 -0400
Date: Sun, 12 Apr 2009 19:40:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [RFT/RFC] rtl8187: Remove some magic numbers
Message-ID: <49e28a0e.w2E55OwYOA9yeg+w%Larry.Finger@lwfinger.net> (sfid-20090413_024115_059324_BFAA839F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several magic numbers that refer to locations in the CSR page.
They can be replaced.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -650,7 +650,7 @@ static int rtl8187_init_hw(struct ieee80
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 
-	rtl818x_iowrite16(priv, (__le16 *)0xFFF4, 0xFFFF);
+	rtl818x_iowrite16(priv, &priv->map->FEMR, 0xFFFF);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG1);
 	reg &= 0x3F;
 	reg |= 0x80;
@@ -882,7 +882,7 @@ static void rtl8187_work(struct work_str
 	u16 tmp;
 
 	mutex_lock(&priv->conf_mutex);
-	tmp = rtl818x_ioread16(priv, (__le16 *)0xFFFA);
+	tmp = rtl818x_ioread16(priv, &priv->map->TALLY_CNT);
 	while (skb_queue_len(&priv->b_tx_status.queue) > 0) {
 		struct sk_buff *old_skb;
 
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_rtl8225.c
@@ -462,7 +462,7 @@ static void rtl8225_rf_init(struct ieee8
 
 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
-	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
+	rtl818x_iowrite32(priv, &priv->map->HSSI_PARA, 0x3dc00002);
 
 	/* set sensitivity */
 	rtl8225_write(dev, 0x0c, 0x50);
@@ -818,7 +818,7 @@ static void rtl8225z2_rf_init(struct iee
 	rtl8225_write_phy_cck(dev, 0x4b, 0x04);
 	rtl8225_write_phy_cck(dev, 0x4c, 0x05);
 
-	rtl818x_iowrite8(priv, (u8 *)0xFF5B, 0x0D); msleep(1);
+	rtl818x_iowrite8(priv, &priv->map->TESTR, 0x0D); msleep(1);
 
 	rtl8225z2_rf_set_tx_power(dev, 1);
 
@@ -828,7 +828,7 @@ static void rtl8225z2_rf_init(struct iee
 
 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
-	rtl818x_iowrite32(priv, (__le32 *)0xFF94, 0x3dc00002);
+	rtl818x_iowrite32(priv, &priv->map->HSSI_PARA, 0x3dc00002);
 }
 
 static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
