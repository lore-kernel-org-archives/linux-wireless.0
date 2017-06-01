Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60202 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdFAT2B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 15:28:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: petrum@gmail.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix dropped counter in multiqueue RX
Date: Thu,  1 Jun 2017 21:27:56 +0200
Message-Id: <20170601192756.13062-1-johannes@sipsolutions.net> (sfid-20170601_212810_286247_D651D7DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the commit enabling per-CPU station statistics, I inadvertedly
copy-pasted some code to update rx_packets and forgot to change it
to update rx_dropped_misc. Fix that.

This addresses https://bugzilla.kernel.org/show_bug.cgi?id=195953.

Fixes: c9c5962b56c1 ("mac80211: enable collecting station statistics per-CPU")
Reported-by: Petru-Florin Mihancea <petrum@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7cdf7a835bb0..403e3cc58b57 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2155,7 +2155,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			struct ieee80211_sta_rx_stats *cpurxs;
 
 			cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
-			sinfo->rx_packets += cpurxs->dropped;
+			sinfo->rx_dropped_misc += cpurxs->dropped;
 		}
 	}
 
-- 
2.11.0
