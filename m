Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYAMQ2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 11:28:19 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/2] mac80211: A-MPDU Rx stop aggregation on proper dev
Date: Sun, 13 Jan 2008 18:21:58 +0200
Message-Id: <12002413181718-git-send-email-ron.rindjunsky@intel.com> (sfid-20080113_162825_802110_9C36D54B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a check to insure that Rx A-MPDU will be stopped only
for the proper device.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 1770402..5dcc2d6 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -299,9 +299,11 @@ static int ieee80211_stop(struct net_device *dev)
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	list_for_each_entry(sta, &local->sta_list, list) {
-		for (i = 0; i <  STA_TID_NUM; i++)
-			ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
-						i, WLAN_BACK_RECIPIENT,
+		if (sta->dev == dev)
+			for (i = 0; i <  STA_TID_NUM; i++)
+				ieee80211_sta_stop_rx_ba_session(sta->dev,
+						sta->addr, i,
+						WLAN_BACK_RECIPIENT,
 						WLAN_REASON_QSTA_LEAVE_QBSS);
 	}
 
-- 
1.5.3.7

