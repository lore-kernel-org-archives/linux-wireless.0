Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39467 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757845AbYHCW6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 18:58:43 -0400
Date: Sun, 03 Aug 2008 17:58:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix potential concurrent access to private data
Message-ID: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net> (sfid-20080804_005910_996009_08816071)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Experience with the rtl8187 driver has shown that mac80211 can make
calls to the config callback routine in rapid succession. This patch
creates a mutex that protects the private data in several of the routines
called by mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I think this is 2.6.27 material. It is a definite bug, but I cannot point
to a single bug report implicating this lack of protection as the cause.
Your call.

Larry
---

Index: linux-2.6/drivers/net/wireless/p54/p54.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54.h
+++ linux-2.6/drivers/net/wireless/p54/p54.h
@@ -52,6 +52,7 @@ struct p54_common {
 	int (*open)(struct ieee80211_hw *dev);
 	void (*stop)(struct ieee80211_hw *dev);
 	int mode;
+	struct mutex conf_mutex;
 	u8 mac_addr[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	struct pda_iq_autocal_entry *iq_autocal;
Index: linux-2.6/drivers/net/wireless/p54/p54common.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/p54/p54common.c
+++ linux-2.6/drivers/net/wireless/p54/p54common.c
@@ -886,9 +886,12 @@ static void p54_remove_interface(struct
 static int p54_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
 {
 	int ret;
+	struct p54_common *priv = dev->priv;
 
+	mutex_lock(&priv->conf_mutex);
 	ret = p54_set_freq(dev, cpu_to_le16(conf->channel->center_freq));
 	p54_set_vdcf(dev);
+	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
 
@@ -898,10 +901,12 @@ static int p54_config_interface(struct i
 {
 	struct p54_common *priv = dev->priv;
 
+	mutex_lock(&priv->conf_mutex);
 	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 0, 1, 0, 0xF642);
 	p54_set_filter(dev, 0, priv->mac_addr, conf->bssid, 2, 0, 0, 0);
 	p54_set_leds(dev, 1, !is_multicast_ether_addr(conf->bssid), 0);
 	memcpy(priv->bssid, conf->bssid, ETH_ALEN);
+	mutex_unlock(&priv->conf_mutex);
 	return 0;
 }
 
@@ -1009,6 +1014,7 @@ struct ieee80211_hw *p54_init_common(siz
 	}
 
 	p54_init_vdcf(dev);
+	mutex_init(&priv->conf_mutex);
 
 	return dev;
 }
