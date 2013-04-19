Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab3DSK0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 06:26:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: fix P2P-Device stop locking
Date: Fri, 19 Apr 2013 12:26:06 +0200
Message-Id: <1366367167-17619-1-git-send-email-johannes@sipsolutions.net> (sfid-20130419_122615_660843_088ACB74)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

cfg80211_stop_p2p_device() requires the devlist_mtx to
be held, but nl80211_stop_p2p_device() doesn't acquire
it which is a locking error and causes a warning (when
lockdep is enabled). Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 212d2aa..3abcbba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8159,9 +8159,11 @@ static int nl80211_stop_p2p_device(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->stop_p2p_device)
 		return -EOPNOTSUPP;
 
+	mutex_lock(&rdev->devlist_mtx);
 	mutex_lock(&rdev->sched_scan_mtx);
 	cfg80211_stop_p2p_device(rdev, wdev);
 	mutex_unlock(&rdev->sched_scan_mtx);
+	mutex_unlock(&rdev->devlist_mtx);
 
 	return 0;
 }
-- 
1.8.0

