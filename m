Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35089 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752398AbeGAONJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 10:13:09 -0400
Received: by mail-wr0-f196.google.com with SMTP id h40-v6so1911226wrh.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2018 07:13:08 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 05/19] mt76x2: move interface_modes definition in mt76x2_init
Date: Sun,  1 Jul 2018 16:12:17 +0200
Message-Id: <20180701141231.25323-6-lorenzo.bianconi@redhat.com> (sfid-20180701_161326_421123_5B77EB6C)
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
2.18.0
