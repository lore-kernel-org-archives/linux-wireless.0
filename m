Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45432 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYKLUBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 15:01:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: adapt for deprecated IEEE80211_CONF_SHORT_SLOT_TIME flag
Date: Wed, 12 Nov 2008 14:49:22 -0500
Message-Id: <1226519362-14226-1-git-send-email-linville@tuxdriver.com> (sfid-20081112_210116_220216_ADD24C7B)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates rtl8180 handling for short slot after "mac80211: fix short
slot handling". Only rtl8180_rtl8225 actually had code for handling
short slot times, so the other RF devices are untouched by this change.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c     |   12 ++++++++++++
 drivers/net/wireless/rtl818x/rtl8180_rtl8225.c |   14 +++++++++++---
 drivers/net/wireless/rtl818x/rtl818x.h         |    1 +
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 29ef4e7..f9e62e6 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -720,6 +720,17 @@ static int rtl8180_config_interface(struct ieee80211_hw *dev,
 	return 0;
 }
 
+static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *info,
+				     u32 changed)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
+	        priv->rf->conf_erp(dev, info);
+}
+
 static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
@@ -760,6 +771,7 @@ static const struct ieee80211_ops rtl8180_ops = {
 	.remove_interface	= rtl8180_remove_interface,
 	.config			= rtl8180_config,
 	.config_interface	= rtl8180_config_interface,
+	.bss_info_changed	= rtl8180_bss_info_changed,
 	.configure_filter	= rtl8180_configure_filter,
 };
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
index cd22781..4d2be0d 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_rtl8225.c
@@ -725,8 +725,14 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 
 	rtl8225_write(dev, 0x7, rtl8225_chan[chan - 1]);
 	msleep(10);
+}
+
+static void rtl8225_rf_conf_erp(struct ieee80211_hw *dev,
+				struct ieee80211_bss_conf *info)
+{
+	struct rtl8180_priv *priv = dev->priv;
 
-	if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
+	if (info->use_short_slot) {
 		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
@@ -745,14 +751,16 @@ static const struct rtl818x_rf_ops rtl8225_ops = {
 	.name		= "rtl8225",
 	.init		= rtl8225_rf_init,
 	.stop		= rtl8225_rf_stop,
-	.set_chan	= rtl8225_rf_set_channel
+	.set_chan	= rtl8225_rf_set_channel,
+	.conf_erp	= rtl8225_rf_conf_erp,
 };
 
 static const struct rtl818x_rf_ops rtl8225z2_ops = {
 	.name		= "rtl8225z2",
 	.init		= rtl8225z2_rf_init,
 	.stop		= rtl8225_rf_stop,
-	.set_chan	= rtl8225_rf_set_channel
+	.set_chan	= rtl8225_rf_set_channel,
+	.conf_erp	= rtl8225_rf_conf_erp,
 };
 
 const struct rtl818x_rf_ops * rtl8180_detect_rf(struct ieee80211_hw *dev)
diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index 3538b15..34a5555 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -191,6 +191,7 @@ struct rtl818x_rf_ops {
 	void (*init)(struct ieee80211_hw *);
 	void (*stop)(struct ieee80211_hw *);
 	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
+	void (*conf_erp)(struct ieee80211_hw *, struct ieee80211_bss_conf *);
 };
 
 /* Tx/Rx flags are common between RTL818X chips */
-- 
1.5.4.3

