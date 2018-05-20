Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38562 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbeETIPl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 04:15:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id m129-v6so21624057wmb.3
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2018 01:15:40 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v2 05/18] mt76x2: move currently mt76x2u unsupported features to mt76x2_init
Date: Sun, 20 May 2018 10:15:09 +0200
Message-Id: <20180520081522.10163-6-lorenzo.bianconi@redhat.com> (sfid-20180520_101551_814369_20B8FAF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move currently mt76x2u hw unsupported features to mt76x2_init in order
to reuse mt76_register_device routine supporting mt76x2u based chipsets

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 15 ---------------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 16 ++++++++++++++++
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 915e61733131..da5254b48cf7 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -284,14 +284,6 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
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
@@ -301,17 +293,10 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 	hw->max_tx_fragments = 16;
 
 	ieee80211_hw_set(hw, SIGNAL_DBM);
-	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
-	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
-	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
-	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
-	ieee80211_hw_set(hw, TX_AMSDU);
-	ieee80211_hw_set(hw, TX_FRAG_LIST);
 	ieee80211_hw_set(hw, MFP_CAPABLE);
-	ieee80211_hw_set(hw, AP_LINK_PS);
 
 	wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index d678675a0b91..b00f51cf22df 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -834,6 +834,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
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
@@ -842,6 +850,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	dev->mt76.led_cdev.brightness_set = mt76x2_led_set_brightness;
 	dev->mt76.led_cdev.blink_set = mt76x2_led_set_blink;
 
+	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
+	ieee80211_hw_set(hw, TX_AMSDU);
+	ieee80211_hw_set(hw, TX_FRAG_LIST);
+	ieee80211_hw_set(hw, AP_LINK_PS);
+
 	ret = mt76_register_device(&dev->mt76, true, mt76x2_rates,
 				   ARRAY_SIZE(mt76x2_rates));
 	if (ret)
-- 
2.16.3
