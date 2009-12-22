Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58403 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbZLVXPa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:15:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rtl8180: remove priv->mode
Date: Tue, 22 Dec 2009 18:13:04 -0500
Message-Id: <1261523585-20635-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only checked in add_interface, and there it is easily replaced
with a check of priv->vif.  If that information should become necessary,
it is available in vif->type anyway.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180.h     |    1 -
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   14 +++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180.h
index 8721282..de3844f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180.h
@@ -60,7 +60,6 @@ struct rtl8180_priv {
 	struct rtl818x_csr __iomem *map;
 	const struct rtl818x_rf_ops *rf;
 	struct ieee80211_vif *vif;
-	int mode;
 
 	/* rtl8180 driver specific */
 	spinlock_t lock;
diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index 8a40a14..a199fa1 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -82,8 +82,6 @@ static const struct ieee80211_channel rtl818x_channels[] = {
 };
 
 
-
-
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -615,7 +613,6 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	reg |= RTL818X_CMD_TX_ENABLE;
 	rtl818x_iowrite8(priv, &priv->map->CMD, reg);
 
-	priv->mode = NL80211_IFTYPE_MONITOR;
 	return 0;
 
  err_free_rings:
@@ -633,8 +630,6 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
 	u8 reg;
 	int i;
 
-	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
-
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CMD);
@@ -661,12 +656,14 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
 {
 	struct rtl8180_priv *priv = dev->priv;
 
-	if (priv->mode != NL80211_IFTYPE_MONITOR)
-		return -EOPNOTSUPP;
+	/*
+	 * We only support one active interface at a time.
+	 */
+	if (priv->vif != NULL)
+		return -EBUSY;
 
 	switch (conf->type) {
 	case NL80211_IFTYPE_STATION:
-		priv->mode = conf->type;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -688,7 +685,6 @@ static void rtl8180_remove_interface(struct ieee80211_hw *dev,
 				     struct ieee80211_if_init_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	priv->mode = NL80211_IFTYPE_MONITOR;
 	priv->vif = NULL;
 }
 
-- 
1.6.2.5

