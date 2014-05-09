Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:47518 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaEILYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:24:07 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so2566315eek.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 04:24:05 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] cfg80211: reg: get dfs region only from cfg80211_regd
Date: Fri,  9 May 2014 13:23:38 +0200
Message-Id: <1399634618-3619-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140509_132411_575805_9A33F4CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scenario:
1) Driver register regd as "US"
2) cfg80211 set wiphy_regd->dfs_region = FCC
3) now I change country to FR
4) cfg80211_regd->dfs_region == ETSI
   wiphy_regd->dfs_region == FCC
6) start CAC (this call get_dfs_region)
5) next get warning
device specific dfs_region (FCC) disagrees with cfg80211's central dfs_region (ETSI)

Seems checking wiphy_regd->dfs_region is not required, while
there is no way to register more than one dfs_region from
the driver when registering regd.

With patch:
cfg80211: allow restricting supported dfs regions
driver will supported dfs regions using bitmap.
This seems like a more correct approach.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 11804e8..460ea0c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -133,29 +133,7 @@ static const char *reg_dfs_region_str(enum nl80211_dfs_regions dfs_region)
 
 enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
 {
-	const struct ieee80211_regdomain *regd = NULL;
-	const struct ieee80211_regdomain *wiphy_regd = NULL;
-
-	regd = get_cfg80211_regdom();
-	if (!wiphy)
-		goto out;
-
-	wiphy_regd = get_wiphy_regdom(wiphy);
-	if (!wiphy_regd)
-		goto out;
-
-	if (wiphy_regd->dfs_region == regd->dfs_region)
-		goto out;
-
-	REG_DBG_PRINT("%s: device specific dfs_region "
-		      "(%s) disagrees with cfg80211's "
-		      "central dfs_region (%s)\n",
-		      dev_name(&wiphy->dev),
-		      reg_dfs_region_str(wiphy_regd->dfs_region),
-		      reg_dfs_region_str(regd->dfs_region));
-
-out:
-	return regd->dfs_region;
+	return get_cfg80211_regdom()->dfs_region;
 }
 
 static void rcu_free_regdom(const struct ieee80211_regdomain *r)
-- 
1.7.9.5

