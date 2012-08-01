Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab2HAPVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 11:21:33 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/8] mac80211: clean up CSA handling code
Date: Wed,  1 Aug 2012 17:21:21 +0200
Message-Id: <1343834487-23737-3-git-send-email-johannes@sipsolutions.net> (sfid-20120801_172147_310405_CCF9D877)
In-Reply-To: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
References: <1343834487-23737-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up the CSA handling code by moving some
of it out of the if and using a C99 initializer
for the struct passed to the driver method.

While at it, also add a comment that we should
wait for a beacon after switching the channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 55cf04c..dc1c84b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -712,6 +712,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	/* XXX: shouldn't really modify cfg80211-owned data! */
 	ifmgd->associated->channel = sdata->local->oper_channel;
 
+	/* XXX: wait for a beacon first? */
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
@@ -788,36 +789,33 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	sdata->local->csa_channel = new_ch;
 
+	ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+
+	if (sw_elem->mode)
+		ieee80211_stop_queues_by_reason(&sdata->local->hw,
+				IEEE80211_QUEUE_STOP_REASON_CSA);
+
 	if (sdata->local->ops->channel_switch) {
 		/* use driver's channel switch callback */
-		struct ieee80211_channel_switch ch_switch;
-		memset(&ch_switch, 0, sizeof(ch_switch));
-		ch_switch.timestamp = timestamp;
-		if (sw_elem->mode) {
-			ch_switch.block_tx = true;
-			ieee80211_stop_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-		}
-		ch_switch.channel = new_ch;
-		ch_switch.count = sw_elem->count;
-		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+		struct ieee80211_channel_switch ch_switch = {
+			.timestamp = timestamp,
+			.block_tx = sw_elem->mode,
+			.channel = new_ch,
+			.count = sw_elem->count,
+		};
+
 		drv_channel_switch(sdata->local, &ch_switch);
 		return;
 	}
 
 	/* channel switch handled in software */
-	if (sw_elem->count <= 1) {
+	if (sw_elem->count <= 1)
 		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
-	} else {
-		if (sw_elem->mode)
-			ieee80211_stop_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
-		ifmgd->flags |= IEEE80211_STA_CSA_RECEIVED;
+	else
 		mod_timer(&ifmgd->chswitch_timer,
 			  jiffies +
 			  msecs_to_jiffies(sw_elem->count *
 					   cbss->beacon_interval));
-	}
 }
 
 static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-- 
1.7.10.4

