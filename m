Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:43179 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbeARXIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 18:08:25 -0500
Received: by mail-wm0-f67.google.com with SMTP id g1so73493wmg.2
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 15:08:24 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76x2: dfs: disable dfs tasklet during device cleanup
Date: Fri, 19 Jan 2018 00:08:14 +0100
Message-Id: <04f915e7611a50fd1c57562e6673baf418e55d3a.1516315624.git.lorenzo.bianconi@redhat.com> (sfid-20180119_000828_623378_E1DBFAC3)
In-Reply-To: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
References: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define mt76x2_dfs_cleanup() routine since it will be helpful to add
the support for dfs sw detector

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  | 6 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h  | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index f936dc9a5476..19ac6edd672a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -504,3 +504,9 @@ void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
 	}
 }
 
+void mt76x2_dfs_cleanup(struct mt76x2_dev *dev)
+{
+	struct mt76x2_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
+
+	tasklet_disable(&dfs_pd->dfs_tasklet);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
index 8dbc783cc6bc..f70220615bbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
@@ -74,6 +74,7 @@ struct mt76x2_dfs_pattern_detector {
 };
 
 void mt76x2_dfs_init_params(struct mt76x2_dev *dev);
+void mt76x2_dfs_cleanup(struct mt76x2_dev *dev);
 void mt76x2_dfs_init_detector(struct mt76x2_dev *dev);
 void mt76x2_dfs_adjust_agc(struct mt76x2_dev *dev);
 void mt76x2_dfs_set_domain(struct mt76x2_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 66d4bfc70977..2bf861058658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -618,6 +618,7 @@ void mt76x2_cleanup(struct mt76x2_dev *dev)
 	mt76x2_stop_hardware(dev);
 	mt76x2_dma_cleanup(dev);
 	mt76x2_mcu_cleanup(dev);
+	mt76x2_dfs_cleanup(dev);
 }
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
-- 
2.13.6
