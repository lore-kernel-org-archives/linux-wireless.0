Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42808 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932747AbeEWMxp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 08:53:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: use better order for kcalloc() arguments
Date: Wed, 23 May 2018 14:53:41 +0200
Message-Id: <20180523125341.15495-1-johannes@sipsolutions.net> (sfid-20180523_145351_961633_1A11B1E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The arguments should be (# of elements, size of each) instead
of the other way around, which really ends up being mostly
equivalent but smatch complains about it, so swap them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b5bb1c309914..b91597a8baa2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1789,8 +1789,9 @@ bool cfg80211_does_bw_fit_range(const struct ieee80211_freq_range *freq_range,
 
 int cfg80211_sinfo_alloc_tid_stats(struct station_info *sinfo, gfp_t gfp)
 {
-	sinfo->pertid = kcalloc(sizeof(*(sinfo->pertid)),
-				IEEE80211_NUM_TIDS + 1, gfp);
+	sinfo->pertid = kcalloc(IEEE80211_NUM_TIDS + 1,
+				sizeof(*(sinfo->pertid)),
+				gfp);
 	if (!sinfo->pertid)
 		return -ENOMEM;
 
-- 
2.14.3
