Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42547 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbaENNoR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 09:44:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.15] mac80211: fix on-channel remain-on-channel
Date: Wed, 14 May 2014 15:44:13 +0200
Message-Id: <1400075053-31863-1-git-send-email-johannes@sipsolutions.net> (sfid-20140514_154420_866836_E82DC3E3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that if a remain-on-channel was active on the
same channel as the current operating channel, then the ROC
would start, but any frames transmitted using mgmt-tx on the
same channel would get delayed until after the ROC.

The reason for this is that the ROC starts, but doesn't have
any handling for "remain on the same channel", so it stops
the interface queues. The later mgmt-tx then puts the frame
on the interface queues (since it's on the current operating
channel) and thus they get delayed until after the ROC.

To fix this, add some logic to handle remaining on the same
channel specially and not stop the queues etc. in this case.
This not only fixes the bug but also improves behaviour in
this case as data frames etc. can continue to flow.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/offchannel.c  | 27 ++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 222c28b75315..f169b6ee94ee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -317,6 +317,7 @@ struct ieee80211_roc_work {
 
 	bool started, abort, hw_begun, notified;
 	bool to_be_freed;
+	bool on_channel;
 
 	unsigned long hw_start_time;
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 6fb38558a5e6..7a17decd27f9 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -333,7 +333,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		container_of(work, struct ieee80211_roc_work, work.work);
 	struct ieee80211_sub_if_data *sdata = roc->sdata;
 	struct ieee80211_local *local = sdata->local;
-	bool started;
+	bool started, on_channel;
 
 	mutex_lock(&local->mtx);
 
@@ -354,14 +354,26 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 	if (!roc->started) {
 		struct ieee80211_roc_work *dep;
 
-		/* start this ROC */
-		ieee80211_offchannel_stop_vifs(local);
+		WARN_ON(local->use_chanctx);
+
+		/* If actually operating on the desired channel (with at least
+		 * 20 MHz channel width) don't stop all the operations but still
+		 * treat it as though the ROC operation started properly, so
+		 * other ROC operations won't interfere with this one.
+		 */
+		roc->on_channel = roc->chan == local->_oper_chandef.chan &&
+				  local->_oper_chandef.width != NL80211_CHAN_WIDTH_5 &&
+				  local->_oper_chandef.width != NL80211_CHAN_WIDTH_10;
 
-		/* switch channel etc */
+		/* start this ROC */
 		ieee80211_recalc_idle(local);
 
-		local->tmp_channel = roc->chan;
-		ieee80211_hw_config(local, 0);
+		if (!roc->on_channel) {
+			ieee80211_offchannel_stop_vifs(local);
+
+			local->tmp_channel = roc->chan;
+			ieee80211_hw_config(local, 0);
+		}
 
 		/* tell userspace or send frame */
 		ieee80211_handle_roc_started(roc);
@@ -380,9 +392,10 @@ void ieee80211_sw_roc_work(struct work_struct *work)
  finish:
 		list_del(&roc->list);
 		started = roc->started;
+		on_channel = roc->on_channel;
 		ieee80211_roc_notify_destroy(roc, !roc->abort);
 
-		if (started) {
+		if (started && !on_channel) {
 			ieee80211_flush_queues(local, NULL);
 
 			local->tmp_channel = NULL;
-- 
2.0.0.rc0

