Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17343 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab2JHQDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 12:03:55 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: Use appropriate debug wrapper
Date: Mon, 8 Oct 2012 21:33:47 +0530
Message-ID: <1349712227-4955-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121008_180357_822346_BA239AD0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

ieee80211_sta_expire will be called by both IBSS and mesh
interfaces to account for inactive stations, so it would be more
appropriate to use sta_dbg instead of ibss_dbg.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/sta_info.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 06fa75c..163cf22 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -880,8 +880,8 @@ void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			continue;
 
 		if (time_after(jiffies, sta->last_rx + exp_time)) {
-			ibss_dbg(sdata, "expiring inactive STA %pM\n",
-				 sta->sta.addr);
+			sta_dbg(sta->sdata, "expiring inactive STA %pM\n",
+				sta->sta.addr);
 			WARN_ON(__sta_info_destroy(sta));
 		}
 	}
-- 
1.7.0.4

