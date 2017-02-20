Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50172 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752732AbdBTN1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:27:16 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 2/2] mac80211: don't reorder frames with SN smaller than SSN
Date: Mon, 20 Feb 2017 14:24:48 +0100
Message-Id: <20170220132448.16140-2-johannes@sipsolutions.net> (sfid-20170220_142807_708924_464BF5C3)
In-Reply-To: <20170220132448.16140-1-johannes@sipsolutions.net>
References: <20170220132448.16140-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When RX aggregation starts, transmitter may continue send frames
with SN smaller than SSN until the AddBA response is received.
However, the reorder buffer is already initialized at this point,
which will cause the drop of such frames as duplicates since the
head SN of the reorder buffer is set to the SSN, which is bigger.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c   |  1 +
 net/mac80211/rx.c       | 14 +++++++++++++-
 net/mac80211/sta_info.h |  6 ++++--
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 3b5fd4188f2a..58ad23a44109 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -398,6 +398,7 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	tid_agg_rx->timeout = timeout;
 	tid_agg_rx->stored_mpdu_num = 0;
 	tid_agg_rx->auto_seq = auto_seq;
+	tid_agg_rx->started = false;
 	tid_agg_rx->reorder_buf_filtered = 0;
 	status = WLAN_STATUS_SUCCESS;
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cc2599739ce1..90b43c3d6f7d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
+ * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1034,6 +1034,18 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
 
+	/*
+	 * If the current MPDU's SN is smaller than the SSN, it shouldn't
+	 * be reordered.
+	 */
+	if (unlikely(!tid_agg_rx->started)) {
+		if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
+			ret = false;
+			goto out;
+		}
+		tid_agg_rx->started = true;
+	}
+
 	/* frame with out of date sequence number */
 	if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index dd06ef0b8861..15599c70a38f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -189,6 +189,7 @@ struct tid_ampdu_tx {
  * @auto_seq: used for offloaded BA sessions to automatically pick head_seq_and
  *	and ssn.
  * @removed: this session is removed (but might have been found due to RCU)
+ * @started: this session has started (head ssn or higher was received)
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -212,8 +213,9 @@ struct tid_ampdu_rx {
 	u16 ssn;
 	u16 buf_size;
 	u16 timeout;
-	bool auto_seq;
-	bool removed;
+	u8 auto_seq:1,
+	   removed:1,
+	   started:1;
 };
 
 /**
-- 
2.9.3
