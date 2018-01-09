Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44900 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeAINNV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 08:13:21 -0500
Received: by mail-wr0-f195.google.com with SMTP id w50so4849068wrc.11
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 05:13:21 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mt76x2: dfs: add set_domain handler
Date: Tue,  9 Jan 2018 14:13:11 +0100
Message-Id: <e3320c27f5d1b73896712cb2cea92f58722f707e.1515503003.git.lorenzo.bianconi@redhat.com> (sfid-20180109_141331_069304_368EC132)
In-Reply-To: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
References: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x2_dfs_set_domain routine in order to properly reconfigure
pattern detector when DFS domain has been changed

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h  |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 1a6282a8b64b..df23ba5ef900 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -490,3 +490,16 @@ void mt76x2_dfs_init_detector(struct mt76x2_dev *dev)
 		     (unsigned long)dev);
 }
 
+void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
+			   enum nl80211_dfs_regions region)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+
+	if (dfs_pd->region != region) {
+		tasklet_disable(&dfs_pd->dfs_tasklet);
+		dfs_pd->region = region;
+		mt76x2_dfs_init_params(dev);
+		tasklet_enable(&dfs_pd->dfs_tasklet);
+	}
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
index 9ac69b6a116d..8dbc783cc6bc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
@@ -76,5 +76,7 @@ struct mt76x2_dfs_pattern_detector {
 void mt76x2_dfs_init_params(struct mt76x2_dev *dev);
 void mt76x2_dfs_init_detector(struct mt76x2_dev *dev);
 void mt76x2_dfs_adjust_agc(struct mt76x2_dev *dev);
+void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
+			   enum nl80211_dfs_regions region);
 
 #endif /* __MT76x2_DFS_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 4373a2ba5143..9f20a308ff76 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -652,7 +652,7 @@ static void mt76x2_regd_notifier(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct mt76x2_dev *dev = hw->priv;
 
-	dev->dfs_pd.region = request->dfs_region;
+	mt76x2_dfs_set_domain(dev, request->dfs_region);
 }
 
 #define CCK_RATE(_idx, _rate) {					\
-- 
2.13.6
