Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40842 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab0G3CAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 22:00:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtl8180: use RTL818X_MSR_ADHOC for IBSS connection
Date: Thu, 29 Jul 2010 21:56:06 -0400
Message-Id: <1280454966-25996-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtl818x/rtl8180_dev.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
index c879660..2c44753 100644
--- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
@@ -788,6 +788,7 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_vif *vif_priv;
 	int i;
+	u8 reg;
 
 	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
 
@@ -796,12 +797,14 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
 					 info->bssid[i]);
 
-		if (is_valid_ether_addr(info->bssid))
-			rtl818x_iowrite8(priv, &priv->map->MSR,
-					 RTL818X_MSR_INFRA);
-		else
-			rtl818x_iowrite8(priv, &priv->map->MSR,
-					 RTL818X_MSR_NO_LINK);
+		if (is_valid_ether_addr(info->bssid)) {
+			if (vif->type == NL80211_IFTYPE_ADHOC)
+				reg = RTL818X_MSR_ADHOC;
+			else
+				reg = RTL818X_MSR_INFRA;
+		} else
+			reg = RTL818X_MSR_NO_LINK;
+		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
-- 
1.7.1.1

