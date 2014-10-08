Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:34556 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754410AbaJHGtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 02:49:17 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: emmanuel.grumbach@intel.com, michal.kazior@tieto.com,
	linux-wireless@vger.kernel.org
Date: Wed,  8 Oct 2014 09:48:35 +0300
Message-Id: <1412750920-15392-3-git-send-email-luca@coelho.fi> (sfid-20141008_084933_258580_2015D65D)
In-Reply-To: <1412750920-15392-1-git-send-email-luca@coelho.fi>
References: <1412750920-15392-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 2/7] mac80211: add device_timestamp to the ieee80211_channel_switch struct
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Some devices may need the device timestamp in order to synchronize the
channel switch.  To pass this value back to the driver, add it to the
channel switch structure and copy the device_timestamp value received
in the rx info structure into it.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h |  3 +++
 net/mac80211/mlme.c    | 15 ++++++++++-----
 net/mac80211/trace.h   |  2 ++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 0ad1f47..ec0a5b0 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1117,6 +1117,8 @@ struct ieee80211_conf {
  *	Function (TSF) timer when the frame containing the channel switch
  *	announcement was received. This is simply the rx.mactime parameter
  *	the driver passed into mac80211.
+ * @device_timestamp: arbitrary timestamp for the device, this is the
+ *	rx.device_timestamp parameter the driver passed to mac80211.
  * @block_tx: Indicates whether transmission must be blocked before the
  *	scheduled channel switch, as indicated by the AP.
  * @chandef: the new channel to switch to
@@ -1124,6 +1126,7 @@ struct ieee80211_conf {
  */
 struct ieee80211_channel_switch {
 	u64 timestamp;
+	u32 device_timestamp;
 	bool block_tx;
 	struct cfg80211_chan_def chandef;
 	u8 count;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d4ccb2..cb4d074 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1046,7 +1046,8 @@ static void ieee80211_chswitch_timer(unsigned long data)
 
 static void
 ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
-				 u64 timestamp, struct ieee802_11_elems *elems,
+				 u64 timestamp, u32 device_timestamp,
+				 struct ieee802_11_elems *elems,
 				 bool beacon)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -1154,6 +1155,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		/* use driver's channel switch callback */
 		struct ieee80211_channel_switch ch_switch = {
 			.timestamp = timestamp,
+			.device_timestamp = device_timestamp,
 			.block_tx = csa_ie.mode,
 			.chandef = csa_ie.chandef,
 			.count = csa_ie.count,
@@ -3203,6 +3205,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
 
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
+					 rx_status->device_timestamp,
 					 &elems, true);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) &&
@@ -3334,8 +3337,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				break;
 
 			ieee80211_sta_process_chanswitch(sdata,
-							 rx_status->mactime,
-							 &elems, false);
+						 rx_status->mactime,
+						 rx_status->device_timestamp,
+						 &elems, false);
 		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
 			ies_len = skb->len -
 				  offsetof(struct ieee80211_mgmt,
@@ -3356,8 +3360,9 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				&mgmt->u.action.u.ext_chan_switch.data;
 
 			ieee80211_sta_process_chanswitch(sdata,
-							 rx_status->mactime,
-							 &elems, false);
+						 rx_status->mactime,
+						 rx_status->device_timestamp,
+						 &elems, false);
 		}
 		break;
 	}
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 38fae7e..853c440 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -995,6 +995,7 @@ TRACE_EVENT(drv_channel_switch,
 		LOCAL_ENTRY
 		CHANDEF_ENTRY
 		__field(u64, timestamp)
+		__field(u32, device_timestamp)
 		__field(bool, block_tx)
 		__field(u8, count)
 	),
@@ -1003,6 +1004,7 @@ TRACE_EVENT(drv_channel_switch,
 		LOCAL_ASSIGN;
 		CHANDEF_ASSIGN(&ch_switch->chandef)
 		__entry->timestamp = ch_switch->timestamp;
+		__entry->device_timestamp = ch_switch->device_timestamp;
 		__entry->block_tx = ch_switch->block_tx;
 		__entry->count = ch_switch->count;
 	),
-- 
2.1.1

