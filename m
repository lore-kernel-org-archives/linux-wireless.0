Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3BVJfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 04:35:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH] mac80211: Allow drivers to differentiate between ROC types
Date: Fri, 22 Feb 2013 10:35:01 +0100
Message-Id: <1361525701-26172-1-git-send-email-johannes@sipsolutions.net> (sfid-20130222_103532_386877_C421CED1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Some devices can handle remain on channel requests differently
based on the request type/priority. Add support to
differentiate between different ROC types, i.e., indicate that
the ROC is required for sending managment frames.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  3 ++-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  7 ++++---
 drivers/net/wireless/mac80211_hwsim.c       |  3 ++-
 drivers/net/wireless/ti/wlcore/main.c       |  3 ++-
 include/net/mac80211.h                      | 21 ++++++++++++++++++++-
 net/mac80211/cfg.c                          | 21 +++++++++++++++------
 net/mac80211/driver-ops.h                   |  7 ++++---
 net/mac80211/ieee80211_i.h                  |  1 +
 net/mac80211/offchannel.c                   |  2 +-
 net/mac80211/trace.h                        | 11 +++++++----
 10 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 99f9dc0..df2634c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1034,7 +1034,8 @@ done:
 static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *channel,
-				     int duration)
+				     int duration,
+				     enum ieee80211_roc_type type)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_PAN];
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index bbb8a5b..74508b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1076,7 +1076,8 @@ static void iwl_mvm_mac_update_tkip_key(struct ieee80211_hw *hw,
 static int iwl_mvm_roc(struct ieee80211_hw *hw,
 		       struct ieee80211_vif *vif,
 		       struct ieee80211_channel *channel,
-		       int duration)
+		       int duration,
+		       enum ieee80211_roc_type type)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct cfg80211_chan_def chandef;
@@ -1087,8 +1088,8 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 		return -EINVAL;
 	}
 
-	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d)\n", channel->hw_value,
-			   duration);
+	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
+			   duration, type);
 
 	mutex_lock(&mvm->mutex);
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index fbdf647..3466f1a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1535,7 +1535,8 @@ static void hw_roc_done(struct work_struct *work)
 static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_channel *chan,
-			      int duration)
+			      int duration,
+			      enum ieee80211_roc_type type)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5e59c63..a9f7041 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4956,7 +4956,8 @@ static void wlcore_op_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_channel *chan,
-				       int duration)
+				       int duration,
+				       enum ieee80211_roc_type type)
 {
 	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 	struct wl1271 *wl = hw->priv;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3682f89..a5e423b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2137,6 +2137,24 @@ enum ieee80211_rate_control_changed {
 };
 
 /**
+ * enum ieee80211_roc_type - remain on channel type
+ *
+ * With the support for multi channel contexts and multi channel operations,
+ * remain on channel operations might be limited/deffered/aborted by other
+ * flows/operations which have higher priority (and vise versa).
+ * Specifying the ROC type, can be used by devices to prioritize the ROC
+ * operations comapred to other operations/flows.
+ *
+ * @IEEE80211_ROC_TYPE_NORMAL: There are no special requirements for this ROC.
+ * @IEEE80211_ROC_TYPE_MGMT_TX: The remain on channel request is required
+ *	for sending managment frames offchannel.
+ */
+enum ieee80211_roc_type {
+	IEEE80211_ROC_TYPE_NORMAL = 0,
+	IEEE80211_ROC_TYPE_MGMT_TX,
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -2692,7 +2710,8 @@ struct ieee80211_ops {
 	int (*remain_on_channel)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_channel *chan,
-				 int duration);
+				 int duration,
+				 enum ieee80211_roc_type type);
 	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
 	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
 	void (*get_ringparam)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f0129e9..a003f72 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2410,7 +2410,8 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_channel *channel,
 				    unsigned int duration, u64 *cookie,
-				    struct sk_buff *txskb)
+				    struct sk_buff *txskb,
+				    enum ieee80211_roc_type type)
 {
 	struct ieee80211_roc_work *roc, *tmp;
 	bool queued = false;
@@ -2429,6 +2430,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	roc->duration = duration;
 	roc->req_duration = duration;
 	roc->frame = txskb;
+	roc->type = type;
 	roc->mgmt_tx_cookie = (unsigned long)txskb;
 	roc->sdata = sdata;
 	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
@@ -2459,7 +2461,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!duration)
 		duration = 10;
 
-	ret = drv_remain_on_channel(local, sdata, channel, duration);
+	ret = drv_remain_on_channel(local, sdata, channel, duration, type);
 	if (ret) {
 		kfree(roc);
 		return ret;
@@ -2478,10 +2480,13 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 		 *
 		 * If it hasn't started yet, just increase the duration
 		 * and add the new one to the list of dependents.
+		 * If the type of the new ROC has higher priority, modify the
+		 * type of the previous one to match that of the new one.
 		 */
 		if (!tmp->started) {
 			list_add_tail(&roc->list, &tmp->dependents);
 			tmp->duration = max(tmp->duration, roc->duration);
+			tmp->type = max(tmp->type, roc->type);
 			queued = true;
 			break;
 		}
@@ -2493,16 +2498,18 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 			/*
 			 * In the offloaded ROC case, if it hasn't begun, add
 			 * this new one to the dependent list to be handled
-			 * when the the master one begins. If it has begun,
+			 * when the master one begins. If it has begun,
 			 * check that there's still a minimum time left and
 			 * if so, start this one, transmitting the frame, but
-			 * add it to the list directly after this one with a
+			 * add it to the list directly after this one with
 			 * a reduced time so we'll ask the driver to execute
 			 * it right after finishing the previous one, in the
 			 * hope that it'll also be executed right afterwards,
 			 * effectively extending the old one.
 			 * If there's no minimum time left, just add it to the
 			 * normal list.
+			 * TODO: the ROC type is ignored here, assuming that it
+			 * is better to immediately use the current ROC.
 			 */
 			if (!tmp->hw_begun) {
 				list_add_tail(&roc->list, &tmp->dependents);
@@ -2596,7 +2603,8 @@ static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 
 	mutex_lock(&local->mtx);
 	ret = ieee80211_start_roc_work(local, sdata, chan,
-				       duration, cookie, NULL);
+				       duration, cookie, NULL,
+				       IEEE80211_ROC_TYPE_NORMAL);
 	mutex_unlock(&local->mtx);
 
 	return ret;
@@ -2829,7 +2837,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	/* This will handle all kinds of coalescing and immediate TX */
 	ret = ieee80211_start_roc_work(local, sdata, chan,
-				       wait, cookie, skb);
+				       wait, cookie, skb,
+				       IEEE80211_ROC_TYPE_MGMT_TX);
 	if (ret)
 		kfree_skb(skb);
  out_unlock:
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1f922c1..33f99b9 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -788,15 +788,16 @@ static inline int drv_get_antenna(struct ieee80211_local *local,
 static inline int drv_remain_on_channel(struct ieee80211_local *local,
 					struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_channel *chan,
-					unsigned int duration)
+					unsigned int duration,
+					enum ieee80211_roc_type type)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_remain_on_channel(local, sdata, chan, duration);
+	trace_drv_remain_on_channel(local, sdata, chan, duration, type);
 	ret = local->ops->remain_on_channel(&local->hw, &sdata->vif,
-					    chan, duration);
+					    chan, duration, type);
 	trace_drv_return_int(local, ret);
 
 	return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 939c97e..1281389 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -315,6 +315,7 @@ struct ieee80211_roc_work {
 	u32 duration, req_duration;
 	struct sk_buff *frame;
 	u64 cookie, mgmt_tx_cookie;
+	enum ieee80211_roc_type type;
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 4f67a30..b01eb73 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -277,7 +277,7 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 			duration = 10;
 
 		ret = drv_remain_on_channel(local, roc->sdata, roc->chan,
-					    duration);
+					    duration, roc->type);
 
 		roc->started = true;
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index c4f18af..f18f32b 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1045,15 +1045,17 @@ TRACE_EVENT(drv_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_channel *chan,
-		 unsigned int duration),
+		 unsigned int duration,
+		 enum ieee80211_roc_type type),
 
-	TP_ARGS(local, sdata, chan, duration),
+	TP_ARGS(local, sdata, chan, duration, type),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__field(int, center_freq)
 		__field(unsigned int, duration)
+		__field(u32, type)
 	),
 
 	TP_fast_assign(
@@ -1061,12 +1063,13 @@ TRACE_EVENT(drv_remain_on_channel,
 		VIF_ASSIGN;
 		__entry->center_freq = chan->center_freq;
 		__entry->duration = duration;
+		__entry->type = type;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " freq:%dMHz duration:%dms",
+		LOCAL_PR_FMT  VIF_PR_FMT " freq:%dMHz duration:%dms type=%d",
 		LOCAL_PR_ARG, VIF_PR_ARG,
-		__entry->center_freq, __entry->duration
+		__entry->center_freq, __entry->duration, __entry->type
 	)
 );
 
-- 
1.8.0

