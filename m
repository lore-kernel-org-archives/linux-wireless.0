Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44778 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbYJ3AzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:55:07 -0400
Message-ID: <490905E9.8040005@lwfinger.net> (sfid-20081030_015524_786628_B58C93AF)
Date: Wed, 29 Oct 2008 17:55:05 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT PATCH 5/6] rtl8187: Remove primitive write delays
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each of the primary write routines, rtl8187_write_phy(),
rtl8225_write_bitbang(), and rtl8225_write_8051() all conclude with an
msleep() command. Testing shows that these are not needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -152,8 +152,6 @@ void rtl8187_write_phy(struct ieee80211_
 	rtl818x_iowrite8(priv, &priv->map->PHY[2], (data >> 16) & 0xFF);
 	rtl818x_iowrite8(priv, &priv->map->PHY[1], (data >> 8) & 0xFF);
 	rtl818x_iowrite8(priv, &priv->map->PHY[0], data & 0xFF);
-
-	msleep(1);
 }

 static void rtl8187_tx_cb(struct urb *urb)
Index: wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
@@ -64,7 +64,6 @@ static void rtl8225_write_bitbang(struct

 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84);
-	msleep(2);
 }

 static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
@@ -98,7 +97,6 @@ static void rtl8225_write_8051(struct ie

 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84);
-	msleep(2);
 }

 static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)



