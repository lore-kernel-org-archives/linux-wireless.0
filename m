Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:54974 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbYJMSK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 14:10:57 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH 1/3] rtl8187: adapt for deprecated IEEE80211_CONF_SHORT_SLOT_TIME flag
Date: Mon, 13 Oct 2008 18:10:59 +0000
Message-Id: <1223921460-26419-2-git-send-email-herton@mandriva.com.br> (sfid-20081013_201109_012048_7D930248)
In-Reply-To: <1223921460-26419-1-git-send-email-herton@mandriva.com.br>
References: <1223921460-26419-1-git-send-email-herton@mandriva.com.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This updates 8187L handling for short slot after "mac80211: fix short
slot handling". For 8187B, there was no handling done for short slot
timing so nothing done, support for it will come in a following patch.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/net/wireless/rtl8187_dev.c |   46 +++++++++++++++++++++++------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index ccb9446..6244461 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -875,22 +875,6 @@ static int rtl8187_config(struct ieee80211_hw *dev, u32 changed)
 	msleep(10);
 	rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
 
-	if (!priv->is_rtl8187b) {
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
-
-		if (conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME) {
-			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
-			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
-			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
-		} else {
-			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
-			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
-			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
-			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
-		}
-	}
-
 	rtl818x_iowrite16(priv, &priv->map->ATIM_WND, 2);
 	rtl818x_iowrite16(priv, &priv->map->ATIMTR_INTERVAL, 100);
 	rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL, 100);
@@ -925,6 +909,35 @@ static int rtl8187_config_interface(struct ieee80211_hw *dev,
 	return 0;
 }
 
+static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot)
+{
+	if (!priv->is_rtl8187b) {
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
+		if (use_short_slot) {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x14);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
+		} else {
+			rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
+			rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
+			rtl818x_iowrite8(priv, &priv->map->EIFS, 91 - 0x24);
+			rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
+		}
+	}
+}
+
+static void rtl8187_bss_info_changed(struct ieee80211_hw *dev,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_bss_conf *info,
+				     u32 changed)
+{
+	struct rtl8187_priv *priv = dev->priv;
+
+	if (changed & BSS_CHANGED_ERP_SLOT)
+		rtl8187_conf_erp(priv, info->use_short_slot);
+}
+
 static void rtl8187_configure_filter(struct ieee80211_hw *dev,
 				     unsigned int changed_flags,
 				     unsigned int *total_flags,
@@ -965,6 +978,7 @@ static const struct ieee80211_ops rtl8187_ops = {
 	.remove_interface	= rtl8187_remove_interface,
 	.config			= rtl8187_config,
 	.config_interface	= rtl8187_config_interface,
+	.bss_info_changed	= rtl8187_bss_info_changed,
 	.configure_filter	= rtl8187_configure_filter,
 };
 
-- 
1.6.0.2

