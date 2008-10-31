Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37981 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751267AbYJaQyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:54:14 -0400
Message-ID: <490B3835.2030702@lwfinger.net> (sfid-20081031_175419_962265_CF41E5E6)
Date: Fri, 31 Oct 2008 09:54:13 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/6] rtl8187: Remove msleep calls after calls to rtl8225_write
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routine rtl8225_write() calls either rtl8225_write_bitbang() or
rtl8225_write_8051(), both of which end with an msleep() command. As a
result, a rtl8225_write() immediately followed by an msleep() is not needed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

This is 2.6.29 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
@@ -333,21 +333,21 @@ static void rtl8225_rf_init(struct ieee8
 	struct rtl8187_priv *priv = dev->priv;
 	int i;

-	rtl8225_write(dev, 0x0, 0x067); msleep(1);
-	rtl8225_write(dev, 0x1, 0xFE0); msleep(1);
-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x3, 0x441); msleep(1);
-	rtl8225_write(dev, 0x4, 0x486); msleep(1);
-	rtl8225_write(dev, 0x5, 0xBC0); msleep(1);
-	rtl8225_write(dev, 0x6, 0xAE6); msleep(1);
-	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
-	rtl8225_write(dev, 0x8, 0x01F); msleep(1);
-	rtl8225_write(dev, 0x9, 0x334); msleep(1);
-	rtl8225_write(dev, 0xA, 0xFD4); msleep(1);
-	rtl8225_write(dev, 0xB, 0x391); msleep(1);
-	rtl8225_write(dev, 0xC, 0x050); msleep(1);
-	rtl8225_write(dev, 0xD, 0x6DB); msleep(1);
-	rtl8225_write(dev, 0xE, 0x029); msleep(1);
+	rtl8225_write(dev, 0x0, 0x067);
+	rtl8225_write(dev, 0x1, 0xFE0);
+	rtl8225_write(dev, 0x2, 0x44D);
+	rtl8225_write(dev, 0x3, 0x441);
+	rtl8225_write(dev, 0x4, 0x486);
+	rtl8225_write(dev, 0x5, 0xBC0);
+	rtl8225_write(dev, 0x6, 0xAE6);
+	rtl8225_write(dev, 0x7, 0x82A);
+	rtl8225_write(dev, 0x8, 0x01F);
+	rtl8225_write(dev, 0x9, 0x334);
+	rtl8225_write(dev, 0xA, 0xFD4);
+	rtl8225_write(dev, 0xB, 0x391);
+	rtl8225_write(dev, 0xC, 0x050);
+	rtl8225_write(dev, 0xD, 0x6DB);
+	rtl8225_write(dev, 0xE, 0x029);
 	rtl8225_write(dev, 0xF, 0x914); msleep(100);

 	rtl8225_write(dev, 0x2, 0xC4D); msleep(200);
@@ -685,22 +685,23 @@ static void rtl8225z2_rf_init(struct iee
 	struct rtl8187_priv *priv = dev->priv;
 	int i;

-	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
-	rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x3, 0x441); msleep(1);
-	rtl8225_write(dev, 0x4, 0x8C3); msleep(1);
-	rtl8225_write(dev, 0x5, 0xC72); msleep(1);
-	rtl8225_write(dev, 0x6, 0x0E6); msleep(1);
-	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
-	rtl8225_write(dev, 0x8, 0x03F); msleep(1);
-	rtl8225_write(dev, 0x9, 0x335); msleep(1);
-	rtl8225_write(dev, 0xa, 0x9D4); msleep(1);
-	rtl8225_write(dev, 0xb, 0x7BB); msleep(1);
-	rtl8225_write(dev, 0xc, 0x850); msleep(1);
-	rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
-	rtl8225_write(dev, 0xe, 0x02B); msleep(1);
-	rtl8225_write(dev, 0xf, 0x114); msleep(100);
+	rtl8225_write(dev, 0x0, 0x2BF);
+	rtl8225_write(dev, 0x1, 0xEE0);
+	rtl8225_write(dev, 0x2, 0x44D);
+	rtl8225_write(dev, 0x3, 0x441);
+	rtl8225_write(dev, 0x4, 0x8C3);
+	rtl8225_write(dev, 0x5, 0xC72);
+	rtl8225_write(dev, 0x6, 0x0E6);
+	rtl8225_write(dev, 0x7, 0x82A);
+	rtl8225_write(dev, 0x8, 0x03F);
+	rtl8225_write(dev, 0x9, 0x335);
+	rtl8225_write(dev, 0xa, 0x9D4);
+	rtl8225_write(dev, 0xb, 0x7BB);
+	rtl8225_write(dev, 0xc, 0x850);
+	rtl8225_write(dev, 0xd, 0xCDF);
+	rtl8225_write(dev, 0xe, 0x02B);
+	rtl8225_write(dev, 0xf, 0x114);
+	msleep(100);

 	rtl8225_write(dev, 0x0, 0x1B7);

@@ -831,38 +832,38 @@ static void rtl8225z2_b_rf_init(struct i
 	struct rtl8187_priv *priv = dev->priv;
 	int i;

-	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
-	rtl8225_write(dev, 0x1, 0xEE0); msleep(1);
-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x3, 0x441); msleep(1);
-	rtl8225_write(dev, 0x4, 0x8C3); msleep(1);
-	rtl8225_write(dev, 0x5, 0xC72); msleep(1);
-	rtl8225_write(dev, 0x6, 0x0E6); msleep(1);
-	rtl8225_write(dev, 0x7, 0x82A); msleep(1);
-	rtl8225_write(dev, 0x8, 0x03F); msleep(1);
-	rtl8225_write(dev, 0x9, 0x335); msleep(1);
-	rtl8225_write(dev, 0xa, 0x9D4); msleep(1);
-	rtl8225_write(dev, 0xb, 0x7BB); msleep(1);
-	rtl8225_write(dev, 0xc, 0x850); msleep(1);
-	rtl8225_write(dev, 0xd, 0xCDF); msleep(1);
-	rtl8225_write(dev, 0xe, 0x02B); msleep(1);
-	rtl8225_write(dev, 0xf, 0x114); msleep(1);
+	rtl8225_write(dev, 0x0, 0x0B7);
+	rtl8225_write(dev, 0x1, 0xEE0);
+	rtl8225_write(dev, 0x2, 0x44D);
+	rtl8225_write(dev, 0x3, 0x441);
+	rtl8225_write(dev, 0x4, 0x8C3);
+	rtl8225_write(dev, 0x5, 0xC72);
+	rtl8225_write(dev, 0x6, 0x0E6);
+	rtl8225_write(dev, 0x7, 0x82A);
+	rtl8225_write(dev, 0x8, 0x03F);
+	rtl8225_write(dev, 0x9, 0x335);
+	rtl8225_write(dev, 0xa, 0x9D4);
+	rtl8225_write(dev, 0xb, 0x7BB);
+	rtl8225_write(dev, 0xc, 0x850);
+	rtl8225_write(dev, 0xd, 0xCDF);
+	rtl8225_write(dev, 0xe, 0x02B);
+	rtl8225_write(dev, 0xf, 0x114);

-	rtl8225_write(dev, 0x0, 0x1B7); msleep(1);
+	rtl8225_write(dev, 0x0, 0x1B7);

 	for (i = 0; i < ARRAY_SIZE(rtl8225z2_rxgain); i++) {
-		rtl8225_write(dev, 0x1, i + 1); msleep(1);
-		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]); msleep(1);
+		rtl8225_write(dev, 0x1, i + 1);
+		rtl8225_write(dev, 0x2, rtl8225z2_rxgain[i]);
 	}

-	rtl8225_write(dev, 0x3, 0x080); msleep(1);
-	rtl8225_write(dev, 0x5, 0x004); msleep(1);
-	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
+	rtl8225_write(dev, 0x3, 0x080);
+	rtl8225_write(dev, 0x5, 0x004);
+	rtl8225_write(dev, 0x0, 0x0B7);

-	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
+	rtl8225_write(dev, 0x2, 0xC4D);

-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
+	rtl8225_write(dev, 0x2, 0x44D);
+	rtl8225_write(dev, 0x0, 0x2BF);

 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
@@ -896,7 +897,7 @@ static void rtl8225_rf_stop(struct ieee8
 	u8 reg;
 	struct rtl8187_priv *priv = dev->priv;

-	rtl8225_write(dev, 0x4, 0x1f); msleep(1);
+	rtl8225_write(dev, 0x4, 0x1f);

 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);




