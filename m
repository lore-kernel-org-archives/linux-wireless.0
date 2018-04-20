Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40638 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754555AbeDTKti (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Apr 2018 06:49:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Apr 2018 13:49:23 +0300
Message-Id: <20180420104926.8816-7-luca@coelho.fi> (sfid-20180420_124943_965196_4A0F0113)
In-Reply-To: <20180420104926.8816-1-luca@coelho.fi>
References: <20180420104926.8816-1-luca@coelho.fi>
Subject: [PATCH 6/9] mac80211: remove pointless flags=0 assignment
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The data structure is initialized to all zeroes, and
we already rely on that in other places, so remove the
pointless assignment to 0.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 655c3d8b0d80..2d5ffb0a16f6 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3,6 +3,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1992,7 +1993,6 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		int band = STA_STATS_GET(LEGACY_BAND, rate);
 		int rate_idx = STA_STATS_GET(LEGACY_IDX, rate);
 
-		rinfo->flags = 0;
 		sband = local->hw.wiphy->bands[band];
 		brate = sband->bitrates[rate_idx].bitrate;
 		if (rinfo->bw == RATE_INFO_BW_5)
-- 
2.17.0
