Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35308 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932213AbeFJKvj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Jun 2018 06:51:39 -0400
Received: by mail-wr0-f194.google.com with SMTP id l10-v6so17438307wrn.2
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2018 03:51:38 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v3 05/19] mt76x2: move interface_modes definition in mt76x2_init
Date: Sun, 10 Jun 2018 12:51:12 +0200
Message-Id: <20180610105126.28425-6-lorenzo.bianconi@redhat.com> (sfid-20180610_125206_481003_B3AC49E1)
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
index fcd079a96782..d532ee1a3fe7 100644
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
index 9c6d180da294..ef6c92471453 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -835,6 +835,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
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
