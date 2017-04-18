Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31299 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751890AbdDRMJh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 08:09:37 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Fix dfs state propagation for non-DFS center channel
Date: Tue, 18 Apr 2017 17:39:19 +0530
Message-ID: <1492517359-5994-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170418_140940_967496_242EBE27)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When part of a bigger bandwidth (160 MHz) channel falls in DFS
channel range it is possible that the  center frequency may not
necessarily be a radar channel. Remove the sanity check on channel
flag for IEEE80211_CHAN_RADAR in regulatory_propagate_dfs_state(),
this should fix the dfs state propagation for non-DFS center freq
which has DFS channels in it's bandwidth, should also fix unnecessary
WARN_ON() spam in regulatory_propagate_dfs_state().

Fixes: 8976672736d6 ("cfg80211: Share Channel DFS state across wiphys of same DFS domain")
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 net/wireless/reg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a38f315..5fae296 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -3244,9 +3244,6 @@ void regulatory_propagate_dfs_state(struct wiphy *wiphy,
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return;
 
-	if (WARN_ON(!(chandef->chan->flags & IEEE80211_CHAN_RADAR)))
-		return;
-
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (wiphy == &rdev->wiphy)
 			continue;
-- 
1.9.1
