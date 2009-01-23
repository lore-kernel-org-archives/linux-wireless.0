Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46164 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802AbZAWRaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:30:23 -0500
Date: Fri, 23 Jan 2009 11:30:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] rtl8187: Fix locking of private data
Message-ID: <4979fea3.KCM4D+5CjI7qNgEa%Larry.Finger@lwfinger.net> (sfid-20090123_183031_097296_24BC4194)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rtl8187_add_interface(), the mutex that protects the data in struct
rtl8187_priv does not include all references to that structure.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch and the change in queue depth helped the bug #12380 at
http://bugzilla.kernel.org/, but the test was not clean, and the OP for
that bug has not been able to test. Your call on when it gets included.

If I get a clear indication that this patch helps the bug, I'll repost.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -973,19 +973,21 @@ static int rtl8187_add_interface(struct
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
+	int ret = -EOPNOTSUPP;
 
+	mutex_lock(&priv->conf_mutex);
 	if (priv->mode != NL80211_IFTYPE_MONITOR)
-		return -EOPNOTSUPP;
+		goto exit;
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
 		priv->mode = conf->type;
 		break;
 	default:
-		return -EOPNOTSUPP;
+		goto exit;
 	}
 
-	mutex_lock(&priv->conf_mutex);
+	ret = 0;
 	priv->vif = conf->vif;
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
@@ -994,8 +996,9 @@ static int rtl8187_add_interface(struct
 				 ((u8 *)conf->mac_addr)[i]);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
+exit:
 	mutex_unlock(&priv->conf_mutex);
-	return 0;
+	return ret;
 }
 
 static void rtl8187_remove_interface(struct ieee80211_hw *dev,
