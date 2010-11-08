Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63163 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0KHJvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 04:51:17 -0500
Received: by mail-fx0-f46.google.com with SMTP id 16so3835093fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 01:51:17 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 1/2] mac80211: support hardware TX fragmentation offload
Date: Mon,  8 Nov 2010 11:51:06 +0200
Message-Id: <1289209867-21422-2-git-send-email-arik@wizery.com>
In-Reply-To: <1289209867-21422-1-git-send-email-arik@wizery.com>
References: <1289209867-21422-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The lower driver is notified when the fragmentation threshold changes
and upon a reconfig of the interface.

If the driver supports hardware TX fragmentation, don't fragment
packets in the stack.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h      |    6 ++++++
 net/mac80211/cfg.c          |    7 +++++++
 net/mac80211/driver-ops.h   |   14 ++++++++++++++
 net/mac80211/driver-trace.h |   21 +++++++++++++++++++++
 net/mac80211/tx.c           |   11 +++++++++--
 net/mac80211/util.c         |    3 +++
 6 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9fdf982..6122e8a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1652,6 +1652,11 @@ enum ieee80211_ampdu_mlme_action {
  *	and IV16) for the given key from hardware.
  *	The callback must be atomic.
  *
+ * @set_frag_threshold: Configuration of fragmentation threshold. Assign this
+ *	if the device does fragmentation by itself; if this callback is
+ *	implemented then the stack will not do fragmentation.
+ *	The callback can sleep.
+ *
  * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
  *	The callback can sleep.
  *
@@ -1765,6 +1770,7 @@ struct ieee80211_ops {
 			 struct ieee80211_low_level_stats *stats);
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
+	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..3df12f7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1299,6 +1299,13 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	int err;
 
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+		err = drv_set_frag_threshold(local, wiphy->frag_threshold);
+
+		if (err)
+			return err;
+	}
+
 	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
 		err = drv_set_coverage_class(local, wiphy->coverage_class);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1698382..79019f9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -233,6 +233,20 @@ static inline void drv_get_tkip_seq(struct ieee80211_local *local,
 	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
 }
 
+static inline int drv_set_frag_threshold(struct ieee80211_local *local,
+					u32 value)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	trace_drv_set_frag_threshold(local, value);
+	if (local->ops->set_frag_threshold)
+		ret = local->ops->set_frag_threshold(&local->hw, value);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
 static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 					u32 value)
 {
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6831fb1..431d655 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -531,6 +531,27 @@ TRACE_EVENT(drv_get_tkip_seq,
 	)
 );
 
+TRACE_EVENT(drv_set_frag_threshold,
+	TP_PROTO(struct ieee80211_local *local, u32 value),
+
+	TP_ARGS(local, value),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, value)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " value:%d",
+		LOCAL_PR_ARG, __entry->value
+	)
+);
+
 TRACE_EVENT(drv_set_rts_threshold,
 	TP_PROTO(struct ieee80211_local *local, u32 value),
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 96c5943..b392876 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1033,6 +1033,7 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_supported_band *sband;
+	bool hw_frag;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
 						   NULL);
@@ -1042,6 +1043,9 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	tx->flags &= ~IEEE80211_TX_FRAGMENTED;
 
+	/* packet is fragmented in HW if we have a non-NULL driver callback */
+	hw_frag = (tx->local->ops->set_frag_threshold != NULL);
+
 	/*
 	 * for every radiotap entry that is present
 	 * (ieee80211_radiotap_iterator_next returns -ENOENT when no more
@@ -1078,7 +1082,8 @@ static bool __ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx,
 			}
 			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_WEP)
 				info->flags &= ~IEEE80211_TX_INTFL_DONT_ENCRYPT;
-			if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
+			if ((*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG) &&
+								!hw_frag)
 				tx->flags |= IEEE80211_TX_FRAGMENTED;
 			break;
 
@@ -1181,8 +1186,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	/*
 	 * Set this flag (used below to indicate "automatic fragmentation"),
 	 * it will be cleared/left by radiotap as desired.
+	 * Only valid when fragmentation is done by the stack.
 	 */
-	tx->flags |= IEEE80211_TX_FRAGMENTED;
+	if (!local->ops->set_frag_threshold)
+		tx->flags |= IEEE80211_TX_FRAGMENTED;
 
 	/* process and remove the injection radiotap header */
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_HAS_RADIOTAP)) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0b6fc92..e486286 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1152,6 +1152,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	/* setup fragmentation threshold */
+	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
+
 	/* setup RTS threshold */
 	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
 
-- 
1.7.1

