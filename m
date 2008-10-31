Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37697 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbYJaQxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:53:01 -0400
Message-ID: <490B37EA.8050205@lwfinger.net> (sfid-20081031_175307_516032_E9F57E19)
Date: Fri, 31 Oct 2008 09:52:58 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/6] rtl8187: Remove CCK delays
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Routine rtl8225_write_phy_cck() calls rtl8225_write_phy(), which concludes
with a sleep of 1 msec; therefore a call to rtl8225_write_phy_cck()
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
@@ -423,40 +423,40 @@ static void rtl8225_rf_init(struct ieee8
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
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);			/* B: 0xDB */
 	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);		/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */
@@ -785,40 +785,40 @@ static void rtl8225z2_rf_init(struct iee
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
+	rtl8225_write_phy_cck(dev, 0x10, 0x9b);			/* B: 0xDB */
 	rtl8225_write_phy_ofdm(dev, 0x26, 0x90);		/* B: 0x10 */

 	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);	/* B: 0x00 */




