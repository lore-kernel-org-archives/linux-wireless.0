Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40610 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbeD3OM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:12:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id j5so14503070wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:12:58 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 05/18] mt76x2: move currently mt76x2u unsupported features to mt76x2_init
Date: Mon, 30 Apr 2018 16:12:20 +0200
Message-Id: <0cabed92416ee1a751a89acd4e6bc29ff42c48f9.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161333_484341_464FF499)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
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
index b53f59803f54..3b081fe2acbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -831,6 +831,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 
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
@@ -839,6 +847,14 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
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
2.14.3
