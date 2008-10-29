Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62000 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbYJ2Q3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 12:29:53 -0400
Message-ID: <49088F7D.8020102@lwfinger.net> (sfid-20081029_172958_781510_A3EBCBEE)
Date: Wed, 29 Oct 2008 09:29:49 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT] rtl8187: Reduce delays to reduce startup time
References: <838057.50079.qm@web23102.mail.ird.yahoo.com>
In-Reply-To: <838057.50079.qm@web23102.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current driver for the RTL8187 and RTL8187B USB devices contain a large
number of sleep statements, which causes the driver to take a very long time
to initialize and connect. An audit was undertaken to test which, if any, of
these delays could be eliminated.

The first thing I noted was that calls to rtl8225_write_ofdm(),
rtl8225_write_cck(), and rtl8225_write() all go through either
rtl8225_write_bang() or rtl8225_write_8051() and that both those routines
finish with an msleep() call; therefore sequences such as
rtl8225_write(); msleep(1) should not be needed. After removing the msleep()
calls of this type, the initialization routine was much faster without affecting
any functionality.

Next, I experimented with removing those calls with sleeps greater than 1
second - again there was no negative effect.

These changes are most important for the execution of routine
rtl8225z2_b_rf_init() where the time went from 14.84 sec to 7.90 sec.

Please test these changes to verify that these changes do not affect correct
operations of other versions of either the RTL8187 or RTL8187B chips.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---


Index: wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
@@ -64,7 +64,7 @@ static void rtl8225_write_bitbang(struct

 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84);
-	msleep(2);
+	msleep(1);
 }

 static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
@@ -98,7 +98,7 @@ static void rtl8225_write_8051(struct ie

 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, reg80 | (1 << 2));
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, reg84);
-	msleep(2);
+	msleep(1);
 }

 static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
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
@@ -375,91 +375,89 @@ static void rtl8225_rf_init(struct ieee8

 	for (i = 0; i < ARRAY_SIZE(rtl8225_agc); i++) {
 		rtl8225_write_phy_ofdm(dev, 0xB, rtl8225_agc[i]);
-		msleep(1);
 		rtl8225_write_phy_ofdm(dev, 0xA, 0x80 + i);
-		msleep(1);
 	}

 	msleep(1);

-	rtl8225_write_phy_ofdm(dev, 0x00, 0x01); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x01, 0x02); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x02, 0x42); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x03, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x04, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x05, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x06, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x07, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x08, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0a, 0x09); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0c, 0x01); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x10, 0x84); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x11, 0x06); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x12, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x13, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x14, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x15, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x16, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x17, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x18, 0xef); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x19, 0x19); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1a, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1b, 0x76); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1c, 0x04); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1e, 0x95); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1f, 0x75); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x20, 0x1f); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x21, 0x27); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x22, 0x16); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x24, 0x46); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x25, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x27, 0x88); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x00, 0x01);
+	rtl8225_write_phy_ofdm(dev, 0x01, 0x02);
+	rtl8225_write_phy_ofdm(dev, 0x02, 0x42);
+	rtl8225_write_phy_ofdm(dev, 0x03, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x04, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x05, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x06, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x07, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x08, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe);
+	rtl8225_write_phy_ofdm(dev, 0x0a, 0x09);
+	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80);
+	rtl8225_write_phy_ofdm(dev, 0x0c, 0x01);
+	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3);
+	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38);
+	rtl8225_write_phy_ofdm(dev, 0x10, 0x84);
+	rtl8225_write_phy_ofdm(dev, 0x11, 0x06);
+	rtl8225_write_phy_ofdm(dev, 0x12, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x13, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x14, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x15, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x16, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x17, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x18, 0xef);
+	rtl8225_write_phy_ofdm(dev, 0x19, 0x19);
+	rtl8225_write_phy_ofdm(dev, 0x1a, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x1b, 0x76);
+	rtl8225_write_phy_ofdm(dev, 0x1c, 0x04);
+	rtl8225_write_phy_ofdm(dev, 0x1e, 0x95);
+	rtl8225_write_phy_ofdm(dev, 0x1f, 0x75);
+	rtl8225_write_phy_ofdm(dev, 0x20, 0x1f);
+	rtl8225_write_phy_ofdm(dev, 0x21, 0x27);
+	rtl8225_write_phy_ofdm(dev, 0x22, 0x16);
+	rtl8225_write_phy_ofdm(dev, 0x24, 0x46);
+	rtl8225_write_phy_ofdm(dev, 0x25, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);
+	rtl8225_write_phy_ofdm(dev, 0x27, 0x88);

 	rtl8225_write_phy_ofdm(dev, 0x0d, rtl8225_gain[2 * 4]);
 	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225_gain[2 * 4 + 2]);
 	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225_gain[2 * 4 + 3]);
 	rtl8225_write_phy_ofdm(dev, 0x23, rtl8225_gain[2 * 4 + 1]);

-	rtl8225_write_phy_cck(dev, 0x00, 0x98); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x03, 0x20); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x04, 0x7e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x05, 0x12); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x06, 0xfc); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x07, 0x78); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x08, 0x2e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x11, 0x88); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x12, 0x47); msleep(1);
+	rtl8225_write_phy_cck(dev, 0x00, 0x98);
+	rtl8225_write_phy_cck(dev, 0x03, 0x20);
+	rtl8225_write_phy_cck(dev, 0x04, 0x7e);
+	rtl8225_write_phy_cck(dev, 0x05, 0x12);
+	rtl8225_write_phy_cck(dev, 0x06, 0xfc);
+	rtl8225_write_phy_cck(dev, 0x07, 0x78);
+	rtl8225_write_phy_cck(dev, 0x08, 0x2e);
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);
+	rtl8225_write_phy_cck(dev, 0x11, 0x88);
+	rtl8225_write_phy_cck(dev, 0x12, 0x47);
 	rtl8225_write_phy_cck(dev, 0x13, 0xd0);
 	rtl8225_write_phy_cck(dev, 0x19, 0x00);
 	rtl8225_write_phy_cck(dev, 0x1a, 0xa0);
 	rtl8225_write_phy_cck(dev, 0x1b, 0x08);
 	rtl8225_write_phy_cck(dev, 0x40, 0x86);
-	rtl8225_write_phy_cck(dev, 0x41, 0x8d); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x42, 0x15); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x43, 0x18); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x44, 0x1f); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x45, 0x1e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x46, 0x1a); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x47, 0x15); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x48, 0x10); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x49, 0x0a); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4a, 0x05); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4b, 0x02); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4c, 0x05); msleep(1);
+	rtl8225_write_phy_cck(dev, 0x41, 0x8d);
+	rtl8225_write_phy_cck(dev, 0x42, 0x15);
+	rtl8225_write_phy_cck(dev, 0x43, 0x18);
+	rtl8225_write_phy_cck(dev, 0x44, 0x1f);
+	rtl8225_write_phy_cck(dev, 0x45, 0x1e);
+	rtl8225_write_phy_cck(dev, 0x46, 0x1a);
+	rtl8225_write_phy_cck(dev, 0x47, 0x15);
+	rtl8225_write_phy_cck(dev, 0x48, 0x10);
+	rtl8225_write_phy_cck(dev, 0x49, 0x0a);
+	rtl8225_write_phy_cck(dev, 0x4a, 0x05);
+	rtl8225_write_phy_cck(dev, 0x4b, 0x02);
+	rtl8225_write_phy_cck(dev, 0x4c, 0x05);

 	rtl818x_iowrite8(priv, &priv->map->TESTR, 0x0D);

 	rtl8225_rf_set_tx_power(dev, 1);

 	/* RX antenna default to A */
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);	/* B: 0xDB */
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);	/* B: 0x10 */
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);		/* B: 0xDB */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);	/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
@@ -691,21 +689,21 @@ static void rtl8225z2_rf_init(struct iee
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
 	rtl8225_write(dev, 0xf, 0x114); msleep(100);

 	rtl8225_write(dev, 0x0, 0x1B7);
@@ -740,94 +738,92 @@ static void rtl8225z2_rf_init(struct iee

 	for (i = 0; i < ARRAY_SIZE(rtl8225_agc); i++) {
 		rtl8225_write_phy_ofdm(dev, 0xB, rtl8225_agc[i]);
-		msleep(1);
 		rtl8225_write_phy_ofdm(dev, 0xA, 0x80 + i);
-		msleep(1);
 	}

 	msleep(1);

-	rtl8225_write_phy_ofdm(dev, 0x00, 0x01); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x01, 0x02); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x02, 0x42); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x03, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x04, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x05, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x06, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x07, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x08, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0a, 0x08); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0c, 0x01); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x00, 0x01);
+	rtl8225_write_phy_ofdm(dev, 0x01, 0x02);
+	rtl8225_write_phy_ofdm(dev, 0x02, 0x42);
+	rtl8225_write_phy_ofdm(dev, 0x03, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x04, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x05, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x06, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x07, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x08, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x09, 0xfe);
+	rtl8225_write_phy_ofdm(dev, 0x0a, 0x08);
+	rtl8225_write_phy_ofdm(dev, 0x0b, 0x80);
+	rtl8225_write_phy_ofdm(dev, 0x0c, 0x01);
 	rtl8225_write_phy_ofdm(dev, 0x0d, 0x43);
-	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x10, 0x84); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x11, 0x07); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x12, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x13, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x14, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x15, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x16, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x17, 0x40); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x18, 0xef); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x19, 0x19); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1a, 0x20); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1b, 0x15); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1c, 0x04); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1d, 0xc5); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1e, 0x95); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x1f, 0x75); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x20, 0x1f); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x21, 0x17); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x22, 0x16); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x23, 0x80); msleep(1); //FIXME: not needed?
-	rtl8225_write_phy_ofdm(dev, 0x24, 0x46); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x25, 0x00); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x27, 0x88); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x0e, 0xd3);
+	rtl8225_write_phy_ofdm(dev, 0x0f, 0x38);
+	rtl8225_write_phy_ofdm(dev, 0x10, 0x84);
+	rtl8225_write_phy_ofdm(dev, 0x11, 0x07);
+	rtl8225_write_phy_ofdm(dev, 0x12, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x13, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x14, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x15, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x16, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x17, 0x40);
+	rtl8225_write_phy_ofdm(dev, 0x18, 0xef);
+	rtl8225_write_phy_ofdm(dev, 0x19, 0x19);
+	rtl8225_write_phy_ofdm(dev, 0x1a, 0x20);
+	rtl8225_write_phy_ofdm(dev, 0x1b, 0x15);
+	rtl8225_write_phy_ofdm(dev, 0x1c, 0x04);
+	rtl8225_write_phy_ofdm(dev, 0x1d, 0xc5);
+	rtl8225_write_phy_ofdm(dev, 0x1e, 0x95);
+	rtl8225_write_phy_ofdm(dev, 0x1f, 0x75);
+	rtl8225_write_phy_ofdm(dev, 0x20, 0x1f);
+	rtl8225_write_phy_ofdm(dev, 0x21, 0x17);
+	rtl8225_write_phy_ofdm(dev, 0x22, 0x16);
+	rtl8225_write_phy_ofdm(dev, 0x23, 0x80);
+	rtl8225_write_phy_ofdm(dev, 0x24, 0x46);
+	rtl8225_write_phy_ofdm(dev, 0x25, 0x00);
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);
+	rtl8225_write_phy_ofdm(dev, 0x27, 0x88);

 	rtl8225_write_phy_ofdm(dev, 0x0b, rtl8225z2_gain_bg[4 * 3]);
 	rtl8225_write_phy_ofdm(dev, 0x1b, rtl8225z2_gain_bg[4 * 3 + 1]);
 	rtl8225_write_phy_ofdm(dev, 0x1d, rtl8225z2_gain_bg[4 * 3 + 2]);
 	rtl8225_write_phy_ofdm(dev, 0x21, 0x37);

-	rtl8225_write_phy_cck(dev, 0x00, 0x98); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x03, 0x20); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x04, 0x7e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x05, 0x12); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x06, 0xfc); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x07, 0x78); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x08, 0x2e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x11, 0x88); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x12, 0x47); msleep(1);
+	rtl8225_write_phy_cck(dev, 0x00, 0x98);
+	rtl8225_write_phy_cck(dev, 0x03, 0x20);
+	rtl8225_write_phy_cck(dev, 0x04, 0x7e);
+	rtl8225_write_phy_cck(dev, 0x05, 0x12);
+	rtl8225_write_phy_cck(dev, 0x06, 0xfc);
+	rtl8225_write_phy_cck(dev, 0x07, 0x78);
+	rtl8225_write_phy_cck(dev, 0x08, 0x2e);
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);
+	rtl8225_write_phy_cck(dev, 0x11, 0x88);
+	rtl8225_write_phy_cck(dev, 0x12, 0x47);
 	rtl8225_write_phy_cck(dev, 0x13, 0xd0);
 	rtl8225_write_phy_cck(dev, 0x19, 0x00);
 	rtl8225_write_phy_cck(dev, 0x1a, 0xa0);
 	rtl8225_write_phy_cck(dev, 0x1b, 0x08);
 	rtl8225_write_phy_cck(dev, 0x40, 0x86);
-	rtl8225_write_phy_cck(dev, 0x41, 0x8d); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x42, 0x15); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x43, 0x18); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x44, 0x36); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x45, 0x35); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x46, 0x2e); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x47, 0x25); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x48, 0x1c); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x49, 0x12); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4a, 0x09); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4b, 0x04); msleep(1);
-	rtl8225_write_phy_cck(dev, 0x4c, 0x05); msleep(1);
+	rtl8225_write_phy_cck(dev, 0x41, 0x8d);
+	rtl8225_write_phy_cck(dev, 0x42, 0x15);
+	rtl8225_write_phy_cck(dev, 0x43, 0x18);
+	rtl8225_write_phy_cck(dev, 0x44, 0x36);
+	rtl8225_write_phy_cck(dev, 0x45, 0x35);
+	rtl8225_write_phy_cck(dev, 0x46, 0x2e);
+	rtl8225_write_phy_cck(dev, 0x47, 0x25);
+	rtl8225_write_phy_cck(dev, 0x48, 0x1c);
+	rtl8225_write_phy_cck(dev, 0x49, 0x12);
+	rtl8225_write_phy_cck(dev, 0x4a, 0x09);
+	rtl8225_write_phy_cck(dev, 0x4b, 0x04);
+	rtl8225_write_phy_cck(dev, 0x4c, 0x05);

 	rtl818x_iowrite8(priv, (u8 *)0xFF5B, 0x0D); msleep(1);

 	rtl8225z2_rf_set_tx_power(dev, 1);

 	/* RX antenna default to A */
-	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);	/* B: 0xDB */
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);	/* B: 0x10 */
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);		/* B: 0xDB */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);	/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
@@ -839,40 +835,38 @@ static void rtl8225z2_b_rf_init(struct i
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
-	msleep(3000);
+	rtl8225_write(dev, 0x3, 0x080);
+	rtl8225_write(dev, 0x5, 0x004);
+	rtl8225_write(dev, 0x0, 0x0B7);

-	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
-	msleep(2000);
+	rtl8225_write(dev, 0x2, 0xC4D);

-	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
-	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);
+	rtl8225_write(dev, 0x2, 0x44D);
+	rtl8225_write(dev, 0x0, 0x2BF);

 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x03);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x07);
@@ -895,10 +889,10 @@ static void rtl8225z2_b_rf_init(struct i
 	rtl818x_iowrite32(priv, (__le32 *)0xFFFC, (7 << 12) | (3 << 8) | 28);
 	rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0);

-	rtl8225_write_phy_ofdm(dev, 0x97, 0x46); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6); msleep(1);
-	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc); msleep(1);
-	rtl8225_write_phy_cck(dev, 0xc1, 0x88); msleep(1);
+	rtl8225_write_phy_ofdm(dev, 0x97, 0x46);
+	rtl8225_write_phy_ofdm(dev, 0xa4, 0xb6);
+	rtl8225_write_phy_ofdm(dev, 0x85, 0xfc);
+	rtl8225_write_phy_cck(dev, 0xc1, 0x88);
 }

 static void rtl8225_rf_stop(struct ieee80211_hw *dev)
@@ -906,7 +900,7 @@ static void rtl8225_rf_stop(struct ieee8
 	u8 reg;
 	struct rtl8187_priv *priv = dev->priv;

-	rtl8225_write(dev, 0x4, 0x1f); msleep(1);
+	rtl8225_write(dev, 0x4, 0x1f);

 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -669,7 +669,7 @@ static int rtl8187b_init_hw(struct ieee8
 	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
 	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
-	msleep(1100);
+	msleep(100);

 	priv->rf->init(dev);


