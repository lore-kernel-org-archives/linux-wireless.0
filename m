Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:52443 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaBLSyk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 13:54:40 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so4645659ead.13
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 10:54:39 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	linville@tuxdriver.com, Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/4] cfg80211/mac80211: DFS pass CAC time as a parameter
Date: Wed, 12 Feb 2014 19:54:22 +0100
Message-Id: <1392231266-28479-3-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140212_195448_295334_3DE109AA)
In-Reply-To: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Send Channel Availability Check time as a parameter
of start_radar_detection() callback.
We will get this time from regulatory database.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/net/cfg80211.h |    3 ++-
 net/mac80211/cfg.c     |    8 ++++----
 net/wireless/nl80211.c |    3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e1ea2ed..14e2671 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2499,7 +2499,8 @@ struct cfg80211_ops {
 
 	int	(*start_radar_detection)(struct wiphy *wiphy,
 					 struct net_device *dev,
-					 struct cfg80211_chan_def *chandef);
+					 struct cfg80211_chan_def *chandef,
+					 u32 cac_time_ms);
 	int	(*update_ft_ies)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_update_ft_ies_params *ftie);
 	int	(*crit_proto_start)(struct wiphy *wiphy,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7f01f2ae..f504205 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2912,11 +2912,11 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
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
 
 	mutex_lock(&local->mtx);
@@ -2935,9 +2935,9 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 	if (err)
 		goto out_unlock;
 
-	timeout = msecs_to_jiffies(IEEE80211_DFS_MIN_CAC_TIME_MS);
 	ieee80211_queue_delayed_work(&sdata->local->hw,
-				     &sdata->dfs_cac_timer_work, timeout);
+				     &sdata->dfs_cac_timer_work,
+				     msecs_to_jiffies(cac_time_ms));
 
  out_unlock:
 	mutex_unlock(&local->mtx);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0bf69da..4a4c988 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5811,7 +5811,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
+	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
+					       IEEE80211_DFS_MIN_CAC_TIME_MS);
 	if (!err) {
 		wdev->chandef = chandef;
 		wdev->cac_started = true;
-- 
1.7.9.5

