Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34980 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0IUX5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 19:57:16 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [wireless] wireless:  Keep phy name consistent across module reloads.
Date: Tue, 21 Sep 2010 16:57:11 -0700
Message-Id: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It adds needless pain to user-space scripts to change the name
of the phy on each module reload.  Instead, find the first
index.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 9c21ebf... 8226ba7... M	net/wireless/core.c
 net/wireless/core.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9c21ebf..8226ba7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -319,8 +319,7 @@ static void cfg80211_event_work(struct work_struct *work)
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
-	static int wiphy_counter;
-
+	int i;
 	struct cfg80211_registered_device *rdev;
 	int alloc_size;
 
@@ -342,12 +341,18 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_mutex);
 
-	rdev->wiphy_idx = wiphy_counter++;
+	/* 64k wiphy devices is enough for anyone! */
+	for (i = 0; i < 0xFFFF; i++) {
+		if (!cfg80211_rdev_by_wiphy_idx(i))
+			break;
+	}
+	if (i == 0xFFFF)
+		i = -1; /* invalid */
+	rdev->wiphy_idx = i;
 
 	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
-		wiphy_counter--;
 		mutex_unlock(&cfg80211_mutex);
-		/* ugh, wrapped! */
+		/* ugh, too many devices already! */
 		kfree(rdev);
 		return NULL;
 	}
-- 
1.7.2.2

