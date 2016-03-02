Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:23502 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbcCBVqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 16:46:20 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: synchronize driver rx queues before removing a station
Date: Wed,  2 Mar 2016 23:46:14 +0200
Message-Id: <1456955174-5623-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_224623_587004_170BE326)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Some devices, like iwlwifi, have RSS queues. This may cause a
situation where a disassociation is handled in control path and
results in station removal while there are prior RX frames
that were still not processed in other queues. When they will
be processed the station will be gone, and the frames will be
dropped.
Add a synchronization interface to avoid that. When driver returns
from the synchronization mac80211 may remove the station.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/driver-ops.h | 15 +++++++++++++++
 net/mac80211/sta_info.c   |  9 ++++++++-
 net/mac80211/trace.h      | 12 ++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7cb791f..a53333c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3354,6 +3354,10 @@ enum ieee80211_reconfig_type {
  *	the function call.
  *
  * @wake_tx_queue: Called when new packets have been added to the queue.
+ * @sync_rx_queues: Process all pending frames in RSS queues. This is a
+ *	synchronization which is needed in case driver has in its RSS queues
+ *	pending frames that were received prior to the control path action
+ *	currently taken (e.g. disassociation) but are not processed yet.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3591,6 +3595,7 @@ struct ieee80211_ops {
 
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
+	void (*sync_rx_queues)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 18b0d65..184473c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1,3 +1,8 @@
+/*
+* Portions of this file
+* Copyright(c) 2016 Intel Deutschland GmbH
+*/
+
 #ifndef __MAC80211_DRIVER_OPS
 #define __MAC80211_DRIVER_OPS
 
@@ -29,6 +34,16 @@ static inline void drv_tx(struct ieee80211_local *local,
 	local->ops->tx(&local->hw, control, skb);
 }
 
+static inline void drv_sync_rx_queues(struct ieee80211_local *local,
+				      struct sta_info *sta)
+{
+	if (local->ops->sync_rx_queues) {
+		trace_drv_sync_rx_queues(local, sta->sdata, &sta->sta);
+		local->ops->sync_rx_queues(&local->hw);
+		trace_drv_return_void(local);
+	}
+}
+
 static inline void drv_get_et_strings(struct ieee80211_sub_if_data *sdata,
 				      u32 sset, u8 *data)
 {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d20bab5..00c82fb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2,7 +2,7 @@
  * Copyright 2002-2005, Instant802 Networks, Inc.
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -875,6 +875,13 @@ static int __must_check __sta_info_destroy_part1(struct sta_info *sta)
 	set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 	ieee80211_sta_tear_down_BA_sessions(sta, AGG_STOP_DESTROY_STA);
 
+	/*
+	 * Before removing the station from the driver there might be pending
+	 * rx frames on RSS queues sent prior to the disassociation - wait for
+	 * all such frames to be processed.
+	 */
+	drv_sync_rx_queues(local, sta);
+
 	ret = sta_info_hash_del(local, sta);
 	if (WARN_ON(ret))
 		return ret;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 2b0a17e..8c3b7ae 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1,3 +1,8 @@
+/*
+* Portions of this file
+* Copyright(c) 2016 Intel Deutschland GmbH
+*/
+
 #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
 #define __MAC80211_DRIVER_TRACE
 
@@ -899,6 +904,13 @@ DEFINE_EVENT(sta_event, drv_sta_pre_rcu_remove,
 	TP_ARGS(local, sdata, sta)
 );
 
+DEFINE_EVENT(sta_event, drv_sync_rx_queues,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
+
 DEFINE_EVENT(sta_event, drv_sta_rate_tbl_update,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-- 
2.5.0

