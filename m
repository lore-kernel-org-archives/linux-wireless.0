Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYHAAau (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 20:30:50 -0400
Date: Thu, 31 Jul 2008 19:30:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Subject: [PATCH V3] rtl8187: Fix lockups due to concurrent access to
 config routine
Message-ID: <48925938.27Ki5NWyw4NzKtNf%Larry.Finger@lwfinger.net> (sfid-20080801_023054_214126_F5DD7559)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some users of the RTL8187B have experienced difficulties since commit
8f87dd7e540d455f8e7f11478133b85edc969c67 that introduced the power
management wext hooks. This difficulty has not made much sense until
it was realized that it was possible for mac80211 to make a call to the
config routine while that routine was already being executed. On this
device, it is necessary to loopback the TX when changing channels. Unless
this is properly restored, the device will lockup. A mutex now protects
the device state, and the private data in several places.

The problem was found by Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
who also suggested this type of fix.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---

John,

This is 2.6.27 material. V3 protects some additional routines where the
private data is being updated.

Larry
---

 rtl8187.h     |    4 ++++
 rtl8187_dev.c |   15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

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
@@ -726,6 +726,7 @@ static int rtl8187_start(struct ieee8021
 	if (ret)
 		return ret;
 
+	mutex_lock(&priv->conf_mutex);
 	if (priv->is_rtl8187b) {
 		reg = RTL818X_RX_CONF_MGMT |
 		      RTL818X_RX_CONF_DATA |
@@ -747,6 +748,7 @@ static int rtl8187_start(struct ieee8021
 				  (7 << 0  /* long retry limit */) |
 				  (7 << 21 /* MAX TX DMA */));
 		rtl8187_init_urbs(dev);
+		mutex_unlock(&priv->conf_mutex);
 		return 0;
 	}
 
@@ -790,6 +792,7 @@ static int rtl8187_start(struct ieee8021
 	reg |= RTL818X_CMD_TX_ENABLE;
 	reg |= RTL818X_CMD_RX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
+	mutex_unlock(&priv->conf_mutex);
 
 	return 0;
 }
@@ -801,6 +804,7 @@ static void rtl8187_stop(struct ieee8021
 	struct sk_buff *skb;
 	u32 reg;
 
+	mutex_lock(&priv->conf_mutex);
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
@@ -820,7 +824,7 @@ static void rtl8187_stop(struct ieee8021
 		usb_kill_urb(info->urb);
 		kfree_skb(skb);
 	}
-	return;
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int rtl8187_add_interface(struct ieee80211_hw *dev,
@@ -840,6 +844,7 @@ static int rtl8187_add_interface(struct
 		return -EOPNOTSUPP;
 	}
 
+	mutex_lock(&priv->conf_mutex);
 	priv->vif = conf->vif;
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
@@ -848,6 +853,7 @@ static int rtl8187_add_interface(struct
 				 ((u8 *)conf->mac_addr)[i]);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -855,8 +861,10 @@ static void rtl8187_remove_interface(str
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
+	mutex_lock(&priv->conf_mutex);
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
 	priv->vif = NULL;
+	mutex_unlock(&priv->conf_mutex);
 }
 
 static int rtl8187_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -864,6 +872,7 @@ static int rtl8187_config(struct ieee802
 	struct rtl8187_priv *priv = dev->priv;
 	u32 reg;
 
+	mutex_lock(&priv->conf_mutex);
 	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
 	/* Enable TX loopback on MAC level to avoid TX during channel
 	 * changes, as this has be seen to causes problems and the
@@ -896,6 +905,7 @@ static int rtl8187_config(struct ieee802
 	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL_TIME, 100);
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -907,6 +917,7 @@ static int rtl8187_config_interface(stru
 	int i;
 	u8 reg;
 
+	mutex_lock(&priv->conf_mutex);
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
 
@@ -920,6 +931,7 @@ static int rtl8187_config_interface(stru
 		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 	}
 
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -1187,6 +1199,7 @@ static int __devinit rtl8187_probe(struc
 		printk(KERN_ERR "rtl8187: Cannot register device\n");
 		goto err_free_dev;
 	}
+	mutex_init(&priv->conf_mutex);
 
 	printk(KERN_INFO "%s: hwaddr %s, %s V%d + %s\n",
 	       wiphy_name(dev->wiphy), print_mac(mac, dev->wiphy->perm_addr),
