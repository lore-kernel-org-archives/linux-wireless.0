Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:18138 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbbDTTxs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:53:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] mac80211: notify the driver on reordering buffer timeout
Date: Mon, 20 Apr 2015 22:53:38 +0300
Message-Id: <1429559618-23056-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215351_567647_861E3101)
In-Reply-To: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559618-23056-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When frames time out in the reordering buffer, it is a
good indication that something went wrong and the driver
may want to know about that to take action or trigger
debug flows.
It is pointless to notify the driver about each frame that
is released. Notify each time the timer fires.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 8 ++++++--
 net/mac80211/rx.c      | 9 +++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e682927..ac6c13c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -338,11 +338,15 @@ enum ieee80211_bss_change {
  * @RSSI_EVENT: AP's rssi crossed the a threshold set by the driver.
  * @MLME_EVENT: event related to MLME
  * @BAR_RX_EVENT: a BAR was received
+ * @BA_FRAME_TIMEOUT: Frames were released from the reordering buffer because
+ *	they timed out. This won't be called for each frame released, but only
+ *	once each time the timeout triggers.
  */
 enum ieee80211_event_type {
 	RSSI_EVENT,
 	MLME_EVENT,
 	BAR_RX_EVENT,
+	BA_FRAME_TIMEOUT,
 };
 
 /**
@@ -405,7 +409,7 @@ struct ieee80211_mlme_event {
  * struct ieee80211_ba_event - data attached for BlockAck related events
  * @sta: pointer to the &ieee80211_sta to which this event relates
  * @tid: the tid
- * @ssn: the starting sequence number
+ * @ssn: the starting sequence number (for %BAR_RX_EVENT)
  */
 struct ieee80211_ba_event {
 	struct ieee80211_sta *sta;
@@ -418,7 +422,7 @@ struct ieee80211_ba_event {
  * @type: The event itself. See &enum ieee80211_event_type.
  * @rssi: relevant if &type is %RSSI_EVENT
  * @mlme: relevant if &type is %AUTH_EVENT
- * @ba: relevant if &type is %BAR_RX_EVENT
+ * @ba: relevant if &type is %BAR_RX_EVENT or %BA_FRAME_TIMEOUT
  * @u:union holding the fields above
  */
 struct ieee80211_event {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b01468f..6f19837 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3252,6 +3252,15 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	ieee80211_sta_reorder_release(sta->sdata, tid_agg_rx, &frames);
 	spin_unlock(&tid_agg_rx->reorder_lock);
 
+	if (!skb_queue_empty(&frames)) {
+		struct ieee80211_event event = {
+			.type = BA_FRAME_TIMEOUT,
+			.u.ba.tid = tid,
+			.u.ba.sta = &sta->sta,
+		};
+		drv_event_callback(rx.local, rx.sdata, &event);
+	}
+
 	ieee80211_rx_handlers(&rx, &frames);
 }
 
-- 
2.1.0

