Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:18113 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750760AbXJUClk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2007 22:41:40 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 2/2] rtl8187: Allow multicast frames
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sat, 20 Oct 2007 20:05:31 -0400
Message-ID: <20071021000531.10326.713.stgit@tetra.sourmilk.net> (sfid-20071021_034145_975985_922E003D)
In-Reply-To: <20071021000530.10326.77030.stgit@tetra.sourmilk.net>
References: <20071021000530.10326.77030.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows rtl8187 to receive multicast frames if requested.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8187_dev.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index 590f4b4..1533bff 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -433,6 +433,9 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 
 	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
 
+	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
+	rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
+
 	rtl8187_init_urbs(dev);
 
 	reg = RTL818X_RX_CONF_ONLYERLPKT |
@@ -582,32 +585,31 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev, int if_id,
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
-				     int mc_count, struct dev_addr_list *mc_list)
+				     int mc_count, struct dev_addr_list *mclist)
 {
 	struct rtl8187_priv *priv = dev->priv;
 
-	*total_flags = 0;
-
-	if (changed_flags & FIF_ALLMULTI)
-		priv->rx_conf ^= RTL818X_RX_CONF_MULTICAST;
 	if (changed_flags & FIF_FCSFAIL)
 		priv->rx_conf ^= RTL818X_RX_CONF_FCS;
 	if (changed_flags & FIF_CONTROL)
 		priv->rx_conf ^= RTL818X_RX_CONF_CTRL;
 	if (changed_flags & FIF_OTHER_BSS)
 		priv->rx_conf ^= RTL818X_RX_CONF_MONITOR;
-
-	if (mc_count > 0)
+	if (*total_flags & FIF_ALLMULTI || mc_count > 0)
 		priv->rx_conf |= RTL818X_RX_CONF_MULTICAST;
+	else
+		priv->rx_conf &= ~RTL818X_RX_CONF_MULTICAST;
+
+	*total_flags = 0;
 
-	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
-		*total_flags |= FIF_ALLMULTI;
 	if (priv->rx_conf & RTL818X_RX_CONF_FCS)
 		*total_flags |= FIF_FCSFAIL;
 	if (priv->rx_conf & RTL818X_RX_CONF_CTRL)
 		*total_flags |= FIF_CONTROL;
 	if (priv->rx_conf & RTL818X_RX_CONF_MONITOR)
 		*total_flags |= FIF_OTHER_BSS;
+	if (priv->rx_conf & RTL818X_RX_CONF_MULTICAST)
+		*total_flags |= FIF_ALLMULTI;
 
 	rtl818x_iowrite32_async(priv, &priv->map->RX_CONF, priv->rx_conf);
 }


