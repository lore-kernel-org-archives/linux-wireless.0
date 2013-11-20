Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:53632 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3KTJmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 04:42:24 -0500
Received: by mail-ee0-f47.google.com with SMTP id c50so3273782eek.20
        for <linux-wireless@vger.kernel.org>; Wed, 20 Nov 2013 01:42:23 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 3/4] cfg80211/mac80211: DFS pass CAC time as a parameter
Date: Wed, 20 Nov 2013 10:41:56 +0100
Message-Id: <1384940517-6154-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131120_104231_809265_2385B674)
In-Reply-To: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send Channel Availability Check time as a parameter
of start_radar_detection() callback.
We could have different CAC time configuration for
Off-channel CAC and for weather channels.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h |    3 ++-
 net/mac80211/cfg.c     |    8 ++++----
 net/wireless/nl80211.c |    3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bacc503..ba640e9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2412,7 +2412,8 @@ struct cfg80211_ops {
 
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
-					 struct cfg80211_chan_def *chandef);
+					 struct cfg80211_chan_def *chandef,
+					 u32 cac_time_ms);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
 	int	(*crit_proto_start)(struct wiphy *wiphy,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3bc92d0..d5a6f5c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2893,11 +2893,11 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 					   struct net_device *dev,
-					   struct cfg80211_chan_def *chandef)
+					   struct cfg80211_chan_def *chandef,
+					   u32 cac_time_ms)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	unsigned long timeout;
 	int err;
 
 	if (!list_empty(&local->roc_list) || local->scanning)
@@ -2915,9 +2915,9 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	if (err)
 		return err;
 
-	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
-				     &sdata->dfs_cac_timer_work, timeout);
+				     &sdata->dfs_cac_timer_work,
+				     msecs_to_jiffies(cac_time_ms));
 
 	return 0;
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 62b4efd..ea9ee18 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5667,7 +5667,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
+					       IEEE80211_DFS_MIN_CAC_TIME_MS);
 	if (!err) {
 		wdev->channel = chandef.chan;
 		wdev->cac_started = true;
-- 
1.7.9.5

