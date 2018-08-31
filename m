Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45456 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727410AbeHaMrJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 08:47:09 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 11:31:27 +0300
Message-Id: <20180831083130.15525-26-luca@coelho.fi> (sfid-20180831_104053_817210_280317B8)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 25/28] mac80211: add an option for drivers to check if packets can be aggregated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

)

From: Sara Sharon <sara.sharon@intel.com>

Some hardwares have limitations on the packets' type in AMSDU.
Add an optional driver callback to determine if two skbs can
be used in the same AMSDU or not.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h    |  7 +++++++
 net/mac80211/driver-ops.h | 10 ++++++++++
 net/mac80211/tx.c         |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e448a633a242..95b0b3421ff6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3581,6 +3581,10 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @can_aggregate_in_amsdu: Called in order to determine if HW supports
+ *	aggregating two specific frames in the same A-MSDU. The relation
+ *	between the skbs should be symmetric and transitive. Note that while
+ *	skb is always a real frame, head may or may not be an A-MSDU.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3863,6 +3867,9 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	bool (*can_aggregate_in_amsdu)(struct ieee80211_hw *hw,
+				       struct sk_buff *head,
+				       struct sk_buff *skb);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 8f6998091d26..e42c641b6190 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1173,6 +1173,16 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int drv_can_aggregate_in_amsdu(struct ieee80211_local *local,
+					     struct sk_buff *head,
+					     struct sk_buff *skb)
+{
+	if (!local->ops->can_aggregate_in_amsdu)
+		return true;
+
+	return local->ops->can_aggregate_in_amsdu(&local->hw, head, skb);
+}
+
 static inline int drv_start_nan(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				struct cfg80211_nan_conf *conf)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a2cc33652f2a..4efed4ac16eb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3242,6 +3242,9 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (skb->len + head->len > max_amsdu_len)
 		goto out;
 
+	if (!drv_can_aggregate_in_amsdu(local, head, skb))
+		goto out;
+
 	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
-- 
2.18.0
