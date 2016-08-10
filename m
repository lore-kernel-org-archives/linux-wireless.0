Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:36659 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbcHJSOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:14:45 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/4] cfg80211: rdev-ops: remove callback check from rdev_start_radar_detection()
Date: Wed, 10 Aug 2016 12:33:28 +0200
Message-Id: <1470825209-10054-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160810_223953_436651_5C90E64F)
In-Reply-To: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1470825209-10054-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrapper rdev_start_radar_detection() checks whether the driver provides
the start_radar_detection callback and returns -ENOTSUPP if not. However,
this check is already performed in nl80211_start_radar_detection() resulting
in -EOPNOTSUPP. This patch removes check from rdev wrapper function and move
the callback checking in nl80211_start_radar_detection() before the other
checks.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c  | 7 ++++---
 net/wireless/rdev-ops.h | 7 +++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f02653a..8ab63b5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6826,6 +6826,9 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	unsigned int cac_time_ms;
 	int err;
 
+	if (!rdev->ops->start_radar_detection)
+		return -EOPNOTSUPP;
+
 	dfs_region = reg_get_dfs_region(wdev->wiphy);
 	if (dfs_region == NL80211_DFS_UNSET)
 		return -EINVAL;
@@ -6845,15 +6848,13 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
+	/* 0 value means no dfs is required so bail out */
 	if (err == 0)
 		return -EINVAL;
 
 	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
 		return -EINVAL;
 
-	if (!rdev->ops->start_radar_detection)
-		return -EOPNOTSUPP;
-
 	cac_time_ms = cfg80211_chandef_dfs_cac_time(&rdev->wiphy, &chandef);
 	if (WARN_ON(!cac_time_ms))
 		cac_time_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index d002415..2020606 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1034,13 +1034,12 @@ rdev_start_radar_detection(struct cfg80211_registered_device *rdev,
 			   struct cfg80211_chan_def *chandef,
 			   u32 cac_time_ms)
 {
-	int ret = -ENOTSUPP;
+	int ret;
 
 	trace_rdev_start_radar_detection(&rdev->wiphy, dev, chandef,
 					 cac_time_ms);
-	if (rdev->ops->start_radar_detection)
-		ret = rdev->ops->start_radar_detection(&rdev->wiphy, dev,
-						       chandef, cac_time_ms);
+	ret = rdev->ops->start_radar_detection(&rdev->wiphy, dev,
+					       chandef, cac_time_ms);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
-- 
1.9.1

