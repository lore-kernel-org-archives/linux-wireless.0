Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35878 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752052AbYJaQlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:41:06 -0400
Message-ID: <490B350C.6090004@lwfinger.net> (sfid-20081031_174112_863312_FDE58720)
Date: Fri, 31 Oct 2008 09:40:44 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH] rtl8187: Change TX power settings
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The latest vendor driver (rtl8187B_linux_26.1036.0708.2008) has a different
CCK power setting code as compared with the Linux driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Piter Punk <piterpk@terra.com.br>
---

Index: wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
@@ -625,7 +629,7 @@ static void rtl8225z2_b_rf_set_tx_power(
 		rtl8225_write_phy_cck(dev, 0x44 + i, *tmp++);

 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
-			 rtl8225z2_tx_gain_cck_ofdm[cck_power]);
+			 rtl8225z2_tx_gain_cck_ofdm[cck_power] << 1);
 	msleep(1);

 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,

