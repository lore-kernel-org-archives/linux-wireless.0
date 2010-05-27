Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60659 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0E0MlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 May 2010 08:41:10 -0400
Subject: [PATCH] mac80211: clean up ieee80211_stop_tx_ba_session
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 14:41:07 +0200
Message-ID: <1274964067.3669.43.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no sense in letting anything but internal
mac80211 functions set the initiator to anything
but WLAN_BACK_INITIATOR, since WLAN_BACK_RECIPIENT
is only valid when we have received a frame from
the peer, which we react to directly in mac80211.

The debugfs code I recently added got this wrong
as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    3 +--
 include/net/mac80211.h                    |    6 ++----
 net/mac80211/agg-tx.c                     |    7 +++----
 net/mac80211/debugfs_sta.c                |    3 +--
 net/mac80211/driver-trace.h               |   10 ++++------
 5 files changed, 11 insertions(+), 18 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-05-27 14:31:11.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-05-27 14:32:19.000000000 +0200
@@ -2331,16 +2331,14 @@ void ieee80211_start_tx_ba_cb_irqsafe(st
  * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
  * @sta: the station whose BA session to stop
  * @tid: the TID to stop BA.
- * @initiator: if indicates initiator DELBA frame will be sent.
  *
- * Return: error if no sta with matching da found, success otherwise
+ * Return: negative error if the TID is invalid, or no aggregation active
  *
  * Although mac80211/low level driver/user space application can estimate
  * the need to stop aggregation on a certain RA/TID, the session level
  * will be managed by the mac80211.
  */
-int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid,
-				 enum ieee80211_back_parties initiator);
+int ieee80211_stop_tx_ba_session(struct ieee80211_sta *sta, u16 tid);
 
 /**
  * ieee80211_stop_tx_ba_cb - low level driver ready to stop aggregate.
--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-05-27 14:31:32.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-05-27 14:34:25.000000000 +0200
@@ -538,14 +538,13 @@ int __ieee80211_stop_tx_ba_session(struc
 	return ret;
 }
 
-int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
-				 enum ieee80211_back_parties initiator)
+int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct ieee80211_local *local = sdata->local;
 
-	trace_api_stop_tx_ba_session(pubsta, tid, initiator);
+	trace_api_stop_tx_ba_session(pubsta, tid);
 
 	if (!local->ops->ampdu_action)
 		return -EINVAL;
@@ -553,7 +552,7 @@ int ieee80211_stop_tx_ba_session(struct
 	if (tid >= STA_TID_NUM)
 		return -EINVAL;
 
-	return __ieee80211_stop_tx_ba_session(sta, tid, initiator);
+	return __ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 }
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2010-05-27 14:34:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2010-05-27 14:34:07.000000000 +0200
@@ -313,8 +313,7 @@ static int rs_tl_turn_on_agg_for_tid(str
 			 */
 			IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
 				tid);
-			ieee80211_stop_tx_ba_session(sta, tid,
-						WLAN_BACK_INITIATOR);
+			ieee80211_stop_tx_ba_session(sta, tid);
 		}
 	} else
 		IWL_ERR(priv, "Fail finding valid aggregation tid: %d\n", tid);
--- wireless-testing.orig/net/mac80211/driver-trace.h	2010-05-27 14:34:29.000000000 +0200
+++ wireless-testing/net/mac80211/driver-trace.h	2010-05-27 14:34:47.000000000 +0200
@@ -850,25 +850,23 @@ TRACE_EVENT(api_start_tx_ba_cb,
 );
 
 TRACE_EVENT(api_stop_tx_ba_session,
-	TP_PROTO(struct ieee80211_sta *sta, u16 tid, u16 initiator),
+	TP_PROTO(struct ieee80211_sta *sta, u16 tid),
 
-	TP_ARGS(sta, tid, initiator),
+	TP_ARGS(sta, tid),
 
 	TP_STRUCT__entry(
 		STA_ENTRY
 		__field(u16, tid)
-		__field(u16, initiator)
 	),
 
 	TP_fast_assign(
 		STA_ASSIGN;
 		__entry->tid = tid;
-		__entry->initiator = initiator;
 	),
 
 	TP_printk(
-		STA_PR_FMT " tid:%d initiator:%d",
-		STA_PR_ARG, __entry->tid, __entry->initiator
+		STA_PR_FMT " tid:%d",
+		STA_PR_ARG, __entry->tid
 	)
 );
 
--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2010-05-27 14:37:41.000000000 +0200
+++ wireless-testing/net/mac80211/debugfs_sta.c	2010-05-27 14:37:59.000000000 +0200
@@ -210,8 +210,7 @@ static ssize_t sta_agg_status_write(stru
 		if (start)
 			ret = ieee80211_start_tx_ba_session(&sta->sta, tid);
 		else
-			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid,
-							   WLAN_BACK_RECIPIENT);
+			ret = ieee80211_stop_tx_ba_session(&sta->sta, tid);
 	} else {
 		__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT, 3);
 		ret = 0;


