Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46950 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727577AbeIEJes (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 05:34:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Sep 2018 08:06:11 +0300
Message-Id: <20180905050614.23273-7-luca@coelho.fi> (sfid-20180905_070633_897861_228CFDBB)
In-Reply-To: <20180905050614.23273-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180905050614.23273-1-luca@coelho.fi>
Subject: [RESEND PATCH v2 6/9] mac80211: add an option for drivers to check if packets can be aggregated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
index 28da9e27ea70..c4fadbafbf21 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3594,6 +3594,10 @@ enum ieee80211_reconfig_type {
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
@@ -3876,6 +3880,9 @@ struct ieee80211_ops {
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
index 41eaa8e6a938..1c9ef0755bc0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3255,6 +3255,9 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (skb->len + head->len > max_amsdu_len)
 		goto out;
 
+	if (!drv_can_aggregate_in_amsdu(local, head, skb))
+		goto out;
+
 	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
-- 
2.18.0
