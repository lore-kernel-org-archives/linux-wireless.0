Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbYKMSiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 13:38:17 -0500
Date: Thu, 13 Nov 2008 12:30:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: [PATCH] rtl8187: Remove module warning and dependence on
 CONFIG_EXPERIMENTAL
Message-ID: <491c7251.WCV2He6gta/bha3+%Larry.Finger@lwfinger.net> (sfid-20081113_193823_634828_96ECA3B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After considerable testing, the initial fears that the driver might damage
some flavors of RTL8187B hardware seem to be groundless. Accordingly, the
logged warning is removed. In addition, Kconfig is changed to remove the
dependence on EXPERIMENTAL.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 
Index: wireless-testing/drivers/net/wireless/Kconfig
===================================================================
--- wireless-testing.orig/drivers/net/wireless/Kconfig
+++ wireless-testing/drivers/net/wireless/Kconfig
@@ -654,7 +654,7 @@ config RTL8180
 
 config RTL8187
 	tristate "Realtek 8187 and 8187B USB support"
-	depends on MAC80211 && USB && WLAN_80211 && EXPERIMENTAL
+	depends on MAC80211 && USB && WLAN_80211
 	select EEPROM_93CX6
 	---help---
 	  This is a driver for RTL8187 and RTL8187B based cards.
Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1407,9 +1407,7 @@ static int __devinit rtl8187_probe(struc
 	}
 
 	if (priv->is_rtl8187b) {
-		printk(KERN_WARNING "rtl8187: 8187B chip detected. Support "
-			"is EXPERIMENTAL, and could damage your\n"
-			"         hardware, use at your own risk\n");
+		printk(KERN_WARNING "rtl8187: 8187B chip detected.\n");
 		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
 	} else {
 		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
