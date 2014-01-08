Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48102 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbaAHPbQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 10:31:16 -0500
Received: by mail-ee0-f51.google.com with SMTP id b15so760127eek.38
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jan 2014 07:31:15 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 2/4] cfg80211: rename function argument to be more readable
Date: Wed,  8 Jan 2014 16:26:56 +0100
Message-Id: <1389194818-7864-3-git-send-email-michal.kazior@tieto.com> (sfid-20140108_163122_327165_59ABF248)
In-Reply-To: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
References: <1389194818-7864-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unifies variable naming regarding radar detection
width.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/wireless/core.h |  2 +-
 net/wireless/util.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 0a277c3..38f74fe 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -379,7 +379,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum nl80211_iftype iftype,
 				 struct ieee80211_channel *chan,
 				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect);
+				 u8 radar_detect_width);
 
 /**
  * cfg80211_chandef_dfs_usable - checks if chandef is DFS usable
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 935dea9..41013f1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1238,7 +1238,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 enum nl80211_iftype iftype,
 				 struct ieee80211_channel *chan,
 				 enum cfg80211_chan_mode chanmode,
-				 u8 radar_detect)
+				 u8 radar_detect_width)
 {
 	struct wireless_dev *wdev_iter;
 	u32 used_iftypes = BIT(iftype);
@@ -1254,7 +1254,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 
 	ASSERT_RTNL();
 
-	if (WARN_ON(hweight32(radar_detect) > 1))
+	if (WARN_ON(hweight32(radar_detect_width) > 1))
 		return -EINVAL;
 
 	switch (iftype) {
@@ -1268,7 +1268,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		 * then mark DFS as required.
 		 */
 		if (!chan) {
-			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect)
+			if (chanmode != CHAN_MODE_UNDEFINED && radar_detect_width)
 				radar_required = true;
 			break;
 		}
@@ -1285,12 +1285,12 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 	}
 
-	if (radar_required && !radar_detect)
+	if (radar_required && !radar_detect_width)
 		return -EINVAL;
 
 	/* Always allow software iftypes */
 	if (rdev->wiphy.software_iftypes & BIT(iftype)) {
-		if (radar_detect)
+		if (radar_detect_width)
 			return -EINVAL;
 		return 0;
 	}
@@ -1366,7 +1366,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 
-	if (total == 1 && !radar_detect)
+	if (total == 1 && !radar_detect_width)
 		return 0;
 
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
@@ -1399,7 +1399,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 			}
 		}
 
-		if (radar_detect && !(c->radar_detect_widths & radar_detect))
+		if (radar_detect_width && !(c->radar_detect_widths & radar_detect_width))
 			goto cont;
 
 		/*
-- 
1.8.4.rc3

