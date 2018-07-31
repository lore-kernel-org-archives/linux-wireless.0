Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38540 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbeGaJsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:38 -0400
Received: by mail-wm0-f68.google.com with SMTP id t25-v6so2079708wmi.3
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:30 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 05/19] mt76x2: move interface_modes definition in mt76x2_init
Date: Tue, 31 Jul 2018 10:09:06 +0200
Message-Id: <82ba7bcda9d54321ff0cd2bf469e151d7332e57f.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100935_495190_D04C2032)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move  wiphy interface_modes definition in mt76x2_init in order to
reuse mt76_register_device routine supporting mt76x2u based chipsets
since mt76x2u currently supports just sta mode

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 8 --------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d62e34e7eadf..6a0b6f4403a8 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -303,14 +303,6 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	SET_IEEE80211_DEV(hw, dev->dev);
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
 
-	wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-		BIT(NL80211_IFTYPE_MESH_POINT) |
-#endif
-		BIT(NL80211_IFTYPE_ADHOC);
-
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
 	wiphy->available_antennas_tx = dev->antenna_mask;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index c3ecc1c206bd..d3eedd9c59b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -841,6 +841,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
 	wiphy->reg_notifier = mt76x2_regd_notifier;
 
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		BIT(NL80211_IFTYPE_ADHOC);
+
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	mt76x2_dfs_init_detector(dev);
-- 
2.17.1
