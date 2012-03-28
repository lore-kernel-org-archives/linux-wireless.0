Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669Ab2C1JGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 05:06:14 -0400
Message-Id: <20120328085901.307857420@sipsolutions.net> (sfid-20120328_110619_243292_1BF7F7AC)
Date: Wed, 28 Mar 2012 10:58:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mac80211: remove queue stop on rate control update
References: <20120328085835.902687300@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We currently stop the queue when changing the rate
control between 20/40 MHz in the BSS. This seems to
have been necessary when we actually changed the
channel, but now that we just update the station it
doesn't seem right any more. Remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/mlme.c        |   19 -------------------
 2 files changed, 20 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-03-16 14:14:19.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-16 14:14:20.000000000 +0100
@@ -757,7 +757,6 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
-	IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
--- a/net/mac80211/mlme.c	2012-03-16 14:14:19.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-16 14:14:20.000000000 +0100
@@ -212,21 +212,6 @@ static u32 ieee80211_config_ht_tx(struct
 	if (sta && (!reconfig ||
 		    (disable_40 != !!(sta->sta.ht_cap.cap &
 					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
-		if (reconfig) {
-			/*
-			 * Whenever the AP announces the HT mode changed
-			 * (e.g. 40 MHz intolerant) stop queues to avoid
-			 * sending out frames while the rate control is
-			 * reconfiguring.
-			 */
-			ieee80211_stop_queues_by_reason(&sdata->local->hw,
-				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
-
-			/* flush out all packets */
-			synchronize_net();
-
-			drv_flush(local, false);
-		}
 
 		if (disable_40)
 			sta->sta.ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
@@ -235,10 +220,6 @@ static u32 ieee80211_config_ht_tx(struct
 
 		rate_control_rate_update(local, sband, sta,
 					 IEEE80211_RC_HT_CHANGED);
-
-		if (reconfig)
-			ieee80211_wake_queues_by_reason(&sdata->local->hw,
-				IEEE80211_QUEUE_STOP_REASON_CHTYPE_CHANGE);
 	}
 	mutex_unlock(&local->sta_mtx);
 


