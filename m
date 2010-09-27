Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46671 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab0I0QHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 12:07:34 -0400
Received: by pwi1 with SMTP id 1so63892pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 09:07:34 -0700 (PDT)
From: greearb@gmail.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] Revert "wireless: Keep phy name consistent across module reloads."
Date: Mon, 27 Sep 2010 09:07:25 -0700
Message-Id: <1285603646-7710-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This reverts commit a6ab8e2903d4416a53e3bcc97ae2d3148a36c5df.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 8226ba7... 9c21ebf... M	net/wireless/core.c
 net/wireless/core.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8226ba7..9c21ebf 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -319,7 +319,8 @@ static void cfg80211_event_work(struct work_struct *work)
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 {
-	int i;
+	static int wiphy_counter;
+
 	struct cfg80211_registered_device *rdev;
 	int alloc_size;
 
@@ -341,18 +342,12 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 
 	mutex_lock(&cfg80211_mutex);
 
-	/* 64k wiphy devices is enough for anyone! */
-	for (i = 0; i < 0xFFFF; i++) {
-		if (!cfg80211_rdev_by_wiphy_idx(i))
-			break;
-	}
-	if (i == 0xFFFF)
-		i = -1; /* invalid */
-	rdev->wiphy_idx = i;
+	rdev->wiphy_idx = wiphy_counter++;
 
 	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx))) {
+		wiphy_counter--;
 		mutex_unlock(&cfg80211_mutex);
-		/* ugh, too many devices already! */
+		/* ugh, wrapped! */
 		kfree(rdev);
 		return NULL;
 	}
-- 
1.7.2.3

