Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56384 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaFKUIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 16:08:39 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, Ben Greear <greearb@candelatech.com>
Subject: [RFC] wireless:  improve dfs-region intersection.
Date: Wed, 11 Jun 2014 13:08:34 -0700
Message-Id: <1402517314-20110-1-git-send-email-greearb@candelatech.com> (sfid-20140611_220842_585447_8B907753)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

If one is UN-SET, use the other.  Seems this would
be more correct that what we have now.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Someone that understands this code better than I
do should review this well before it is considered
for upstream.  I'm not sure it is actually needed.

 net/wireless/reg.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 785e516..b87035f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -727,8 +727,15 @@ static enum nl80211_dfs_regions
 reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
 			 const enum nl80211_dfs_regions dfs_region2)
 {
-	if (dfs_region1 != dfs_region2)
+	if (dfs_region1 != dfs_region2) {
+		pr_info("intersect-dfs-region, region1: %d  region2: %d\n",
+			dfs_region1, dfs_region2);
+		if (dfs_region1 == NL80211_DFS_UNSET)
+			return dfs_region2;
+		if (dfs_region2 == NL80211_DFS_UNSET)
+			return dfs_region1;
 		return NL80211_DFS_UNSET;
+	}
 	return dfs_region1;
 }
 
-- 
1.7.11.7

