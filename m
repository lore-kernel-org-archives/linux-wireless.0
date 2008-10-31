Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38733 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbYJaQwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:52:16 -0400
Message-ID: <490B37B7.5030009@lwfinger.net> (sfid-20081031_175240_691243_D7867D95)
Date: Fri, 31 Oct 2008 09:52:07 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: htl10@users.sourceforge.net,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/6] rtl8187: Remove large delays
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rtl8187 driver contains 3 sleep statements that are longer than
a second. Testing has shown no bad effects when they are removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

This is 2.6.29 material.

Larry
---


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

Index: wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
+++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
@@ -862,10 +862,8 @@ static void rtl8225z2_b_rf_init(struct i
 	rtl8225_write(dev, 0x3, 0x080); msleep(1);
 	rtl8225_write(dev, 0x5, 0x004); msleep(1);
 	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
-	msleep(3000);

 	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
-	msleep(2000);

 	rtl8225_write(dev, 0x2, 0x44D); msleep(1);
 	rtl8225_write(dev, 0x0, 0x2BF); msleep(1);






