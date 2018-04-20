Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40628 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754594AbeDTKti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Apr 2018 13:49:22 +0300
Message-Id: <20180420104926.8816-6-luca@coelho.fi> (sfid-20180420_124953_027283_35812D2D)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 5/9] mac80211: ethtool: memset the whole sinfo struct to 0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Rather than just setting the valid flags to 0 set the
whole struct to 0 since other places might rely on it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ethtool.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ethtool.c b/net/mac80211/ethtool.c
index 9cc986deda61..08408520c3f8 100644
--- a/net/mac80211/ethtool.c
+++ b/net/mac80211/ethtool.c
@@ -4,6 +4,7 @@
  * Copied from cfg.c - originally
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2014	Intel Corporation (Author: Johannes Berg)
+ * Copyright (C) 2018 Intel Corporation
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -106,7 +107,7 @@ static void ieee80211_get_stats(struct net_device *dev,
 		if (!(sta && !WARN_ON(sta->sdata->dev != dev)))
 			goto do_survey;
 
-		sinfo.filled = 0;
+		memset(&sinfo, 0, sizeof(sinfo));
 		sta_set_sinfo(sta, &sinfo);
 
 		i = 0;
@@ -133,7 +134,7 @@ static void ieee80211_get_stats(struct net_device *dev,
 			if (sta->sdata->dev != dev)
 				continue;
 
-			sinfo.filled = 0;
+			memset(&sinfo, 0, sizeof(sinfo));
 			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
-- 
2.17.0
