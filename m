Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53334 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbbJXSuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Oct 2015 14:50:06 -0400
From: Olav Haugan <ohaugan@codeaurora.org>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: davem@davemloft.net, kvalo@codeaurora.org,
	ath9k-devel@qca.qualcomm.com, Olav Haugan <ohaugan@codeaurora.org>
Subject: [PATCH 1/2] mac80211: add support to set_coalesce
Date: Sat, 24 Oct 2015 11:49:56 -0700
Message-Id: <1445712597-19114-1-git-send-email-ohaugan@codeaurora.org> (sfid-20151024_205035_623799_C6615F9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ops in mac80211 and corresponding driver calls.
Add trace event for set_coalesce.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
---
 include/net/mac80211.h    |  4 ++++
 net/mac80211/cfg.c        |  9 +++++++++
 net/mac80211/driver-ops.h | 12 ++++++++++++
 net/mac80211/trace.h      |  5 +++++
 4 files changed, 30 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bfc5694..8bd7ccb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3232,6 +3232,8 @@ enum ieee80211_reconfig_type {
  *	the function call.
  *
  * @wake_tx_queue: Called when new packets have been added to the queue.
+ *
+ * @set_coalesce: Set coalesce parameters.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3467,6 +3469,8 @@ struct ieee80211_ops {
 
 	void (*wake_tx_queue)(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
+	int (*set_coalesce)(struct ieee80211_hw *hw,
+			    struct cfg80211_coalesce *coalesce);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a77a14..affd8ab 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3810,6 +3810,14 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+static int ieee80211_set_coalesce(struct wiphy *wiphy,
+				  struct cfg80211_coalesce *coalesce)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+
+	return drv_set_coalesce(local, coalesce);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3894,4 +3902,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.set_coalesce = ieee80211_set_coalesce,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 02d9133..49856e1 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1355,4 +1355,16 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int drv_set_coalesce(struct ieee80211_local *local,
+				   struct cfg80211_coalesce *coalesce)
+{
+	u32 ret = 0;
+
+	trace_drv_set_coalesce(local);
+	if (local->ops->set_coalesce)
+		ret = local->ops->set_coalesce(&local->hw, coalesce);
+	trace_drv_return_u32(local, ret);
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 6f14591..ff1173b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1655,6 +1655,11 @@ TRACE_EVENT(drv_get_expected_throughput,
 	)
 );
 
+DEFINE_EVENT(local_only_evt, drv_set_coalesce,
+	     TP_PROTO(struct ieee80211_local *local),
+	     TP_ARGS(local)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
-- 
2.6.1

