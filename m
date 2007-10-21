Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:64926 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbXJUClm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 22:41:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/2] rtl8180: Allow multicast frames
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sat, 20 Oct 2007 20:05:31 -0400
Message-ID: <20071021000530.10326.77030.stgit@tetra.sourmilk.net> (sfid-20071021_034147_386756_C7902BB9)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows rtl8180 to receive multicast frames if requested.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_dev.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 5ec7ea9..517927d 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -485,13 +485,15 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
 
+	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
+	rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
+
 	reg = RTL818X_RX_CONF_ONLYERLPKT |
 	      RTL818X_RX_CONF_RX_AUTORESETPHY |
 	      RTL818X_RX_CONF_MGMT |
 	      RTL818X_RX_CONF_DATA |
 	      (7 << 8 /* MAX RX DMA */) |
 	      RTL818X_RX_CONF_BROADCAST |
-	      RTL818X_RX_CONF_MULTICAST |
 	      RTL818X_RX_CONF_NICMAC;
 
 	if (priv->r8185)
@@ -641,21 +643,22 @@ static int rtl8180_config_interface(struct ieee80211_hw *dev, int if_id,
 static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
-				     int mc_count, struct dev_addr_list *mc_list
-)
+				     int mc_count, struct dev_addr_list *mclist)
 {
 	struct rtl8180_priv *priv = dev->priv;
 
-	*total_flags = 0;
-
 	if (changed_flags & FIF_FCSFAIL)
 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
 	if (changed_flags & FIF_CONTROL)
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
 	if (changed_flags & FIF_OTHER_BSS)
 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
+	if (*total_flags & FIF_ALLMULTI || mc_count > 0)
+		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
+	else
+		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
 
-	/* TODO: Add proper multicast support */
+	*total_flags = 0;
 
 	if (priv->rx_conf & RTL818X_RX_CONF_FCS)
 		*total_flags |= FIF_FCSFAIL;
@@ -663,6 +666,8 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
 		*total_flags |= FIF_CONTROL;
 	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
 		*total_flags |= FIF_OTHER_BSS;
+	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
+		*total_flags |= FIF_ALLMULTI;
 
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
 }


