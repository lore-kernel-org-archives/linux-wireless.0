Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44902 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753992AbeAINNX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 08:13:23 -0500
Received: by mail-wr0-f195.google.com with SMTP id w50so4849138wrc.11
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 05:13:22 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x2: dfs: take into account dfs region in mt76x2_dfs_init_params()
Date: Tue,  9 Jan 2018 14:13:12 +0100
Message-Id: <380bdfe40558af66959f6658b50b4999a825edcd.1515503003.git.lorenzo.bianconi@redhat.com> (sfid-20180109_141331_714518_AD575CF3)
In-Reply-To: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
References: <cover.1515503003.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not enable DFS state machine if dfs region is set to NL80211_DFS_UNSET

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
index df23ba5ef900..f936dc9a5476 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
@@ -460,7 +460,8 @@ void mt76x2_dfs_init_params(struct mt76x2_dev *dev)
 {
 	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
 
-	if (chandef->chan->flags & IEEE80211_CHAN_RADAR) {
+	if ((chandef->chan->flags & IEEE80211_CHAN_RADAR) &&
+	    dev->dfs_pd.region != NL80211_DFS_UNSET) {
 		mt76x2_dfs_set_bbp_params(dev);
 		/* enable debug mode */
 		mt76x2_dfs_set_capture_mode_ctrl(dev, true);
-- 
2.13.6
