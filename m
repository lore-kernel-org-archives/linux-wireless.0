Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40575 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753707AbeAINNU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 08:13:20 -0500
Received: by mail-wm0-f67.google.com with SMTP id f206so20531203wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 05:13:19 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76x2: dfs: avoid tasklet scheduling during mt76x2_dfs_init_params()
Date: Tue,  9 Jan 2018 14:13:10 +0100
Message-Id: <cc2633a981be777e631da2bd3d32781690db910f.1515503003.git.lorenzo.bianconi@redhat.com> (sfid-20180109_141330_383250_B5728599)
In-Reply-To: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
References: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substitute tasklet_kill with tasklet_disable/tasklet_enable in order to
guarantee dfs tasklet can not be executed during dfs parameter
initialization

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c  | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index 5b452a596016..1a6282a8b64b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -460,7 +460,6 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 
-	tasklet_kill(&dev->dfs_pd.dfs_tasklet);
 	if (chandef->chan->flags & IEEE80211_CHAN_RADAR) {
 		mt76x2_dfs_set_bbp_params(dev);
 		/* enable debug mode */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 963aea9e8801..c96e9348d3a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -127,6 +127,7 @@ mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76_set_channel(&dev->mt76);
 
 	tasklet_disable(&dev->pre_tbtt_tasklet);
+	tasklet_disable(&dev->dfs_pd.dfs_tasklet);
 	cancel_delayed_work_sync(&dev->cal_work);
 
 	mt76x2_mac_stop(dev, true);
@@ -139,6 +140,7 @@ mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76x2_dfs_init_params(dev);
 
 	mt76x2_mac_resume(dev);
+	tasklet_enable(&dev->dfs_pd.dfs_tasklet);
 	tasklet_enable(&dev->pre_tbtt_tasklet);
 
 	return ret;
-- 
2.13.6
