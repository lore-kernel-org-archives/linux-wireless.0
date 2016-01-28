Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbcA1OTc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 09:19:32 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: add API to allow filtering frames in BA sessions
Date: Thu, 28 Jan 2016 16:19:25 +0200
Message-Id: <1453990766-2065-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160128_152114_469119_5FA9AC68)
In-Reply-To: <1453990766-2065-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1453990766-2065-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

If any frames are dropped that are part of a BA session, the reorder
buffer will "indefinitely" (until the timeout) wait for them to come
in (or a BAR moving the window) and won't release frames after them.
This means it isn't possible to filter frames within a BA session in
firmware.

Introduce an API function that allows such filtering. Calling this
function will move the BA window forward to the new SSN, and allows
marking frames after the SSN as having been filtered, so any future
reordering activity will release frames while skipping the holes.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h  | 20 +++++++++++-
 net/mac80211/agg-rx.c   |  1 +
 net/mac80211/rx.c       | 84 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h |  3 ++
 4 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 31337f8..8607cea 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5,7 +5,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright (C) 2015 Intel Deutschland GmbH
+ * Copyright (C) 2015 - 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -5192,6 +5192,24 @@ void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 				  const u8 *addr);
 
 /**
+ * ieee80211_mark_rx_ba_filtered_frames - move RX BA window and mark filtered
+ * @pubsta: station struct
+ * @tid: the session's TID
+ * @ssn: starting sequence number of the bitmap, all frames before this are
+ *	assumed to be out of the window after the call
+ * @filtered: bitmap of filtered frames, BIT(0) is the @ssn entry etc.
+ * @received_mpdus: number of received mpdus in firmware
+ *
+ * This function moves the BA window and releases all frames before @ssn, and
+ * marks frames marked in the bitmap as having been filtered. Afterwards, it
+ * checks if any frames in the window starting from @ssn can now be released
+ * (in case they were only waiting for frames that were filtered.)
+ */
+void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
+					  u16 ssn, u64 filtered,
+					  u16 received_mpdus);
+
+/**
  * ieee80211_send_bar - send a BlockAckReq frame
  *
  * can be used to flush pending frames from the peer's aggregation reorder
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 2ab5479..1b8a5ca 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -376,6 +376,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	tid_agg_rx->timeout = timeout;
 	tid_agg_rx->stored_mpdu_num = 0;
 	tid_agg_rx->auto_seq = auto_seq;
+	tid_agg_rx->reorder_buf_filtered = 0;
 	status = WLAN_STATUS_SUCCESS;
 
 	/* activate it for RX */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a607518..e830b0a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -19,6 +19,7 @@
 #include <linux/etherdevice.h>
 #include <linux/rcupdate.h>
 #include <linux/export.h>
+#include <linux/bitops.h>
 #include <net/mac80211.h>
 #include <net/ieee80211_radiotap.h>
 #include <asm/unaligned.h>
@@ -806,6 +807,9 @@ static inline bool ieee80211_rx_reorder_ready(struct tid_ampdu_rx *tid_agg_rx,
 	struct sk_buff *tail = skb_peek_tail(frames);
 	struct ieee80211_rx_status *status;
 
+	if (tid_agg_rx->reorder_buf_filtered & BIT_ULL(index))
+		return true;
+
 	if (!tail)
 		return false;
 
@@ -844,6 +848,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 no_frame:
+	tid_agg_rx->reorder_buf_filtered &= ~BIT_ULL(index);
 	tid_agg_rx->head_seq_num = ieee80211_sn_inc(tid_agg_rx->head_seq_num);
 }
 
@@ -3299,6 +3304,85 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	ieee80211_rx_handlers(&rx, &frames);
 }
 
+void ieee80211_mark_rx_ba_filtered_frames(struct ieee80211_sta *pubsta, u8 tid,
+					  u16 ssn, u64 filtered,
+					  u16 received_mpdus)
+{
+	struct sta_info *sta;
+	struct tid_ampdu_rx *tid_agg_rx;
+	struct sk_buff_head frames;
+	struct ieee80211_rx_data rx = {
+		/* This is OK -- must be QoS data frame */
+		.security_idx = tid,
+		.seqno_idx = tid,
+	};
+	int i, diff;
+
+	if (WARN_ON(!pubsta || tid >= IEEE80211_NUM_TIDS))
+		return;
+
+	__skb_queue_head_init(&frames);
+
+	sta = container_of(pubsta, struct sta_info, sta);
+
+	rx.sta = sta;
+	rx.sdata = sta->sdata;
+	rx.local = sta->local;
+
+	rcu_read_lock();
+	tid_agg_rx = rcu_dereference(sta->ampdu_mlme.tid_rx[tid]);
+	if (!tid_agg_rx)
+		goto out;
+
+	spin_lock_bh(&tid_agg_rx->reorder_lock);
+
+	if (received_mpdus >= IEEE80211_SN_MODULO >> 1) {
+		int release;
+
+		/* release all frames in the reorder buffer */
+		release = (tid_agg_rx->head_seq_num + tid_agg_rx->buf_size) %
+			   IEEE80211_SN_MODULO;
+		ieee80211_release_reorder_frames(sta->sdata, tid_agg_rx,
+						 release, &frames);
+		/* update ssn to match received ssn */
+		tid_agg_rx->head_seq_num = ssn;
+	} else {
+		ieee80211_release_reorder_frames(sta->sdata, tid_agg_rx, ssn,
+						 &frames);
+	}
+
+	/* handle the case that received ssn is behind the mac ssn.
+	 * it can be tid_agg_rx->buf_size behind and still be valid */
+	diff = (tid_agg_rx->head_seq_num - ssn) & IEEE80211_SN_MASK;
+	if (diff >= tid_agg_rx->buf_size) {
+		tid_agg_rx->reorder_buf_filtered = 0;
+		goto release;
+	}
+	filtered = filtered >> diff;
+	ssn += diff;
+
+	/* update bitmap */
+	for (i = 0; i < tid_agg_rx->buf_size; i++) {
+		int index = (ssn + i) % tid_agg_rx->buf_size;
+
+		tid_agg_rx->reorder_buf_filtered &= ~BIT_ULL(index);
+		if (filtered & BIT_ULL(i))
+			tid_agg_rx->reorder_buf_filtered |= BIT_ULL(index);
+	}
+
+	/* now process also frames that the filter marking released */
+	ieee80211_sta_reorder_release(sta->sdata, tid_agg_rx, &frames);
+
+release:
+	spin_unlock_bh(&tid_agg_rx->reorder_lock);
+
+	ieee80211_rx_handlers(&rx, &frames);
+
+ out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_mark_rx_ba_filtered_frames);
+
 /* main receive path */
 
 static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index f4d3899..053f5c4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -168,6 +168,8 @@ struct tid_ampdu_tx {
  *
  * @reorder_buf: buffer to reorder incoming aggregated MPDUs. An MPDU may be an
  *	A-MSDU with individually reported subframes.
+ * @reorder_buf_filtered: bitmap indicating where there are filtered frames in
+ *	the reorder buffer that should be ignored when releasing frames
  * @reorder_time: jiffies when skb was added
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
  * @reorder_timer: releases expired frames from the reorder buffer.
@@ -195,6 +197,7 @@ struct tid_ampdu_tx {
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
 	spinlock_t reorder_lock;
+	u64 reorder_buf_filtered;
 	struct sk_buff_head *reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
-- 
2.5.0

