Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab0AZXpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 18:45:30 -0500
Date: Tue, 26 Jan 2010 17:45:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8187: Add callback for get_tsf
Message-ID: <4b5f7e98.WueiIRrKwMIrtoob%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1265,6 +1265,14 @@ static int rtl8187_conf_tx(struct ieee80
 	return 0;
 }
 
+static u64 rtl8187_get_tsf(struct ieee80211_hw *dev)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	return rtl818x_ioread32(priv, &priv->map->TSFT[0]) |
+	       (u64)(rtl818x_ioread32(priv, &priv->map->TSFT[1])) << 32;
+}
+
 static const struct ieee80211_ops rtl8187_ops = {
 	.tx			= rtl8187_tx,
 	.start			= rtl8187_start,
@@ -1276,7 +1284,8 @@ static const struct ieee80211_ops rtl818
 	.prepare_multicast	= rtl8187_prepare_multicast,
 	.configure_filter	= rtl8187_configure_filter,
 	.conf_tx		= rtl8187_conf_tx,
-	.rfkill_poll		= rtl8187_rfkill_poll
+	.rfkill_poll		= rtl8187_rfkill_poll,
+	.get_tsf		= rtl8187_get_tsf
 };
 
 static void rtl8187_eeprom_register_read(struct eeprom_93cx6 *eeprom)
