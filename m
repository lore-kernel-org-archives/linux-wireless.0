Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4198 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYAMQ3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 11:29:39 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/2] mac80211: A-MPDU Rx remove stop_rx_ba_session warning print
Date: Sun, 13 Jan 2008 18:25:43 +0200
Message-Id: <12002415431203-git-send-email-ron.rindjunsky@intel.com> (sfid-20080113_162942_952574_3BDB212B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes a warning print from ieee80211_sta_stop_rx_ba_session
in case the tid is inactive when interface goes down.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_sta.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 866eb80..bb73aac 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -1215,9 +1215,6 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 	if (sta->ampdu_mlme.tid_rx[tid].state
 				!= HT_AGG_STATE_OPERATIONAL) {
 		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
-		if (net_ratelimit())
-			printk(KERN_DEBUG "rx BA session requested to stop on "
-				"inactive tid %d\n", tid);
 		sta_info_put(sta);
 		return;
 	}
-- 
1.5.3.7

