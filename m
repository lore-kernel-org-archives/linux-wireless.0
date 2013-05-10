Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36635 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3EJNoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 09:44:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/4] cfg80211: use atomic_t for wiphy counter
Date: Fri, 10 May 2013 15:43:54 +0200
Message-Id: <1368193436-26618-2-git-send-email-johannes@sipsolutions.net> (sfid-20130510_154412_691707_8CEDABD5)
In-Reply-To: <1368193436-26618-1-git-send-email-johannes@sipsolutions.net>
References: <1368193436-26618-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to lock, we can just use an atomic_t.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4e0b52f..875d79a 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -289,7 +289,7 @@ static void cfg80211_event_work(struct work_struct *work)
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
-	static int wiphy_counter;
+	static atomic_t wiphy_counter = ATOMIC_INIT(0);
 
 	struct cfg80211_registered_device *rdev;
 	int alloc_size;
@@ -311,20 +311,15 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	rdev->ops = ops;
 
-	mutex_lock(&cfg80211_mutex);
-
-	rdev->wiphy_idx = wiphy_counter++;
+	rdev->wiphy_idx = atomic_inc_return(&wiphy_counter);
 
 	if (unlikely(rdev->wiphy_idx < 0)) {
-		wiphy_counter--;
-		mutex_unlock(&cfg80211_mutex);
 		/* ugh, wrapped! */
+		atomic_dec(&wiphy_counter);
 		kfree(rdev);
 		return NULL;
 	}
 
-	mutex_unlock(&cfg80211_mutex);
-
 	/* give it a proper name */
 	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
 
-- 
1.8.0

