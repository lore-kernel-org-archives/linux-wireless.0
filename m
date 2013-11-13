Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53569 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758918Ab3KMRyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:15 -0500
Received: by mail-wg0-f54.google.com with SMTP id y10so794957wgg.9
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:14 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/5] cfg80211: intersection dfs regions when intersecting regdomains
Date: Wed, 13 Nov 2013 18:54:03 +0100
Message-Id: <1384365246-24768-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185418_655800_2CBA22E2)
In-Reply-To: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
References: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only allow DFS to be set if the DFS regions agree.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/reg.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2796b62..068cb40 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -571,6 +571,20 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 }
 
 /*
+ * Later on we can perhaps use the more restrictive DFS
+ * region but we don't have information for that yet so
+ * for now simply disallow conflicts.
+ */
+static enum nl80211_dfs_regions
+reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
+			 const enum nl80211_dfs_regions dfs_region2)
+{
+	if (dfs_region1 != dfs_region2)
+		return NL80211_DFS_UNSET;
+	return dfs_region1;
+}
+
+/*
  * Helper for regdom_intersect(), this does the real
  * mathematical intersection fun
  */
@@ -701,6 +715,8 @@ regdom_intersect(const struct ieee80211_regdomain *rd1,
 	rd->n_reg_rules = num_rules;
 	rd->alpha2[0] = '9';
 	rd->alpha2[1] = '8';
+	rd->dfs_region = reg_intersect_dfs_region(rd1->dfs_region,
+						  rd2->dfs_region);
 
 	return rd;
 }
-- 
1.8.4.rc3

