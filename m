Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40644 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYGaBYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 21:24:03 -0400
Date: Wed, 30 Jul 2008 20:24:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH V2] rtl8187: Fix lockups due to concurrent access to
 config routine
Message-ID: <48911431.MXO/4WEWNQ+yQUFB%Larry.Finger@lwfinger.net> (sfid-20080731_032406_475565_5B343A71)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some users of the RTL8187B have experienced difficulties since commit
8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
management wext hooks. This difficulty has not made much sense until
it was realized that it was possible for mac80211 to make a call to the
config routine while that routine was already being executed. This patch
protects the critical section with a mutex.

The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
who also suggested this type of fix.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---

John,

This is 2.6.27 material. V2 is the same as V1 - I resubmitted as my mailer
seems to have bungled the white space.

Larry
---

Index: wireless-testing/drivers/net/wireless/rtl8187.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187.h
+++ wireless-testing/drivers/net/wireless/rtl8187.h
@@ -94,6 +94,10 @@ struct rtl8187_priv {
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
 	int mode;
+	/* The mutex protects the TX loopback state.
+	 * Any attempt to set channels concurrently locks the device.
+	 */
+	struct mutex conf_mutex;
 
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];
Index: wireless-testing/drivers/net/wireless/rtl8187_dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl8187_dev.c
+++ wireless-testing/drivers/net/wireless/rtl8187_dev.c
@@ -864,6 +864,7 @@ static int rtl8187_config(struct ieee802
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
 
+	mutex_lock(&priv->conf_mutex);
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	/* Enable TX loopback on MAC level to avoid TX during channel
 	 * changes, as this has be seen to causes problems and the
@@ -896,6 +897,7 @@ static int rtl8187_config(struct ieee802
 	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL_TIME, 100);
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -1187,6 +1189,7 @@ static int __devinit rtl8187_probe(struc
 		printk(KERN_ERR "rtl8187: Cannot register device\n");
 		goto err_free_dev;
 	}
+	mutex_init(&priv->conf_mutex);
 
 	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
