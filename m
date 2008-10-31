Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54854 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYJaQwl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:52:41 -0400
Message-ID: <490B37D7.7080503@lwfinger.net> (sfid-20081031_175256_483223_A785E7A7)
Date: Fri, 31 Oct 2008 09:52:39 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/6] rtl8187: Remove OFDM delays
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routine rtl8225_write_phy_ofdm() calls rtl8225_write_phy(), which concludes
with a sleep of 1 msec; therefore a call to rtl8225_write_phy_ofdm()
immediately followed by an msleep(1) is not needed.

Signed-off-by: Larry Finger <Larry.Finger@larry.finger>
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
@@ -375,50 +375,48 @@ static void rtl8225_rf_init(struct ieee8

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
@@ -459,7 +457,7 @@ static void rtl8225_rf_init(struct ieee8

 	/* RX antenna default to A */
 	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);	/* B: 0xDB */
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);	/* B: 0x10 */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);		/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
@@ -736,53 +734,51 @@ static void rtl8225z2_rf_init(struct iee

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
@@ -823,7 +819,7 @@ static void rtl8225z2_rf_init(struct iee

 	/* RX antenna default to A */
 	rtl8225_write_phy_cck(dev, 0x10, 0x9b); msleep(1);	/* B: 0xDB */
-	rtl8225_write_phy_ofdm(dev, 0x26, 0x90); msleep(1);	/* B: 0x10 */
+	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);		/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
 	msleep(1);
@@ -889,10 +885,10 @@ static void rtl8225z2_b_rf_init(struct i
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




