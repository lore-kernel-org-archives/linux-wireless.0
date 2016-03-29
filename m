Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18912 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756387AbcC2Jf0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 05:35:26 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCHv3 RESEND 09/11] mac80211: Implement add_nan_func and rm_nan_func
Date: Tue, 29 Mar 2016 12:35:07 +0300
Message-Id: <1459244109-16038-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160329_113545_519232_0E4E6775)
In-Reply-To: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1459244109-16038-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Implement add/rm_nan_func functions and handle nan function
termination notifications. Handle instance_id allocation for
nan functions and implement the reconfig flow.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h     |  31 ++++++++++
 net/mac80211/cfg.c         | 147 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  |  32 ++++++++++
 net/mac80211/ieee80211_i.h |  15 +++++
 net/mac80211/iface.c       |  21 ++++++-
 net/mac80211/main.c        |   3 +
 net/mac80211/trace.h       |  53 ++++++++++++++++
 net/mac80211/util.c        |  55 ++++++++++++++++-
 8 files changed, 354 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 011f979..a3cc08f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2116,6 +2116,8 @@ enum ieee80211_hw_flags {
  *
  * @txq_ac_max_pending: maximum number of frames per AC pending in all txq
  *	entries for a vif.
+ * @max_nan_de_entries: maximum number of NAN DE functions supported by the
+ *	device.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2146,6 +2148,7 @@ struct ieee80211_hw {
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
 	int txq_ac_max_pending;
+	u8 max_nan_de_entries;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
@@ -3364,6 +3367,12 @@ enum ieee80211_reconfig_type {
  * @nan_change_conf: change nan configuration. The data in cfg80211_nan_conf
  *	contains full new configuration and changes specify which parameters
  *	are changed with respect to the last nan config.
+ * @add_nan_func: Add a nan function. Returns 0 on success. The data in
+ *	cfg80211_nan_func must not be referenced outside the scope of
+ *	this call.
+ * @rm_nan_func: Remove a nan function. The driver must call
+ * ieee80211_nan_func_terminated() with
+ * NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3611,6 +3620,12 @@ struct ieee80211_ops {
 	int (*nan_change_conf)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct cfg80211_nan_conf *conf, u8 changes);
+	int (*add_nan_func)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    const struct cfg80211_nan_func *nan_func);
+	void (*rm_nan_func)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    u8 instance_id);
 };
 
 /**
@@ -5655,4 +5670,20 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 			     unsigned long *frame_cnt,
 			     unsigned long *byte_cnt);
+
+/*
+ * ieee80211_nan_func_terminated - notify about NAN function termination.
+ *
+ * This function is used to notify mac80211 about nan function termination.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @inst_id: the local instance id
+ * @reason: termination reason (one of the NL80211_NAN_FUNC_TERM_REASON_*)
+ * @gfp: allocation flags
+ */
+void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
+				   u8 inst_id,
+				   enum nl80211_nan_func_term_reason reason,
+				   gfp_t gfp);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9215232..67b0d8a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3,6 +3,7 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
+ * Copyright (C) 2015-2016 Intel Deutschland GmbH
  *
  * This file is GPLv2 as found in COPYING.
  */
@@ -152,6 +153,12 @@ static int ieee80211_start_nan(struct wiphy *wiphy,
 
 	memcpy(&sdata->u.nan.nan_conf, conf, sizeof(sdata->u.nan.nan_conf));
 
+	/* Only set max_nan_de_entries as available to honor the device's
+	 * limitations
+	 */
+	bitmap_set(sdata->u.nan.func_ids, 1,
+		   sdata->local->hw.max_nan_de_entries);
+
 	return ret;
 }
 
@@ -194,6 +201,107 @@ static int ieee80211_nan_change_conf(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_add_nan_func(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_nan_func *nan_func)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_nan_func *func;
+	int ret;
+	int inst_id;
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	inst_id = find_first_bit(sdata->u.nan.func_ids,
+				 IEEE80211_MAX_NAN_INSTANCE_ID + 1);
+	if (inst_id == IEEE80211_MAX_NAN_INSTANCE_ID + 1)
+		return -ENOBUFS;
+
+	nan_func->instance_id = inst_id;
+
+	func = kzalloc(sizeof(*func), GFP_KERNEL);
+	if (!func)
+		return -ENOBUFS;
+
+	cfg80211_clone_nan_func_members(&func->func, nan_func);
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+	clear_bit(inst_id, sdata->u.nan.func_ids);
+	list_add(&func->list, &sdata->u.nan.functions_list);
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	ret = drv_add_nan_func(sdata->local, sdata, nan_func);
+	if (ret) {
+		spin_lock_bh(&sdata->u.nan.func_lock);
+		set_bit(inst_id, sdata->u.nan.func_ids);
+		list_del(&func->list);
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+
+		cfg80211_free_nan_func_members(&func->func);
+		kfree(func);
+	}
+
+	return ret;
+}
+
+static struct ieee80211_nan_func *
+ieee80211_find_nan_func(struct ieee80211_sub_if_data *sdata, u8 instance_id)
+{
+	struct ieee80211_nan_func *func;
+
+	lockdep_assert_held(&sdata->u.nan.func_lock);
+
+	list_for_each_entry(func, &sdata->u.nan.functions_list, list) {
+		if (func->func.instance_id == instance_id)
+			return func;
+	}
+
+	return NULL;
+}
+
+static struct ieee80211_nan_func *
+ieee80211_find_nan_func_by_cookie(struct ieee80211_sub_if_data *sdata,
+				  u64 cookie)
+{
+	struct ieee80211_nan_func *func;
+
+	lockdep_assert_held(&sdata->u.nan.func_lock);
+
+	list_for_each_entry(func, &sdata->u.nan.functions_list, list) {
+		if (func->func.cookie == cookie)
+			return func;
+	}
+
+	return NULL;
+}
+
+static void ieee80211_rm_nan_func(struct wiphy *wiphy,
+				  struct wireless_dev *wdev, u64 cookie)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_nan_func *func;
+	u8 instance_id = 0;
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN ||
+	    !ieee80211_sdata_running(sdata))
+		return;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	func = ieee80211_find_nan_func_by_cookie(sdata, cookie);
+	if (func)
+		instance_id = func->func.instance_id;
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	if (instance_id)
+		drv_rm_nan_func(sdata->local, sdata, instance_id);
+}
+
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
 				  u16 noack_map)
@@ -3418,6 +3526,43 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
+				   u8 inst_id,
+				   enum nl80211_nan_func_term_reason reason,
+				   gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_nan_func *func;
+	struct wireless_dev *wdev;
+	u64 cookie;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
+		return;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	func = ieee80211_find_nan_func(sdata, inst_id);
+	if (WARN_ON(!func)) {
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		return;
+	}
+
+	WARN_ON(test_and_set_bit(inst_id, sdata->u.nan.func_ids));
+	list_del(&func->list);
+	cookie = func->func.cookie;
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	cfg80211_free_nan_func_members(&func->func);
+	kfree(func);
+
+	wdev = ieee80211_vif_to_wdev(vif);
+	if (!WARN_ON_ONCE(!wdev))
+		cfg80211_nan_func_terminated(wdev, inst_id,
+					     reason, cookie, gfp);
+}
+EXPORT_SYMBOL(ieee80211_nan_func_terminated);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3506,4 +3651,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.start_nan = ieee80211_start_nan,
 	.stop_nan = ieee80211_stop_nan,
 	.nan_change_conf = ieee80211_nan_change_conf,
+	.add_nan_func = ieee80211_add_nan_func,
+	.rm_nan_func = ieee80211_rm_nan_func,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3c84fbd..5b7de8c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1227,4 +1227,36 @@ static inline int drv_nan_change_conf(struct ieee80211_local *local,
 	return ret;
 }
 
+static inline int drv_add_nan_func(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   const struct cfg80211_nan_func *nan_func)
+{
+	int ret;
+
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	if (!local->ops->add_nan_func)
+		return -EOPNOTSUPP;
+
+	trace_drv_add_nan_func(local, sdata, nan_func);
+	ret = local->ops->add_nan_func(&local->hw, &sdata->vif, nan_func);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_rm_nan_func(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata,
+				   u8 instance_id)
+{
+	might_sleep();
+	check_sdata_in_driver(sdata);
+
+	trace_drv_rm_nan_func(local, sdata, instance_id);
+	if (local->ops->rm_nan_func)
+		local->ops->rm_nan_func(&local->hw, &sdata->vif, instance_id);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f985ed2..00c4d7a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -85,6 +85,8 @@ struct ieee80211_local;
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
+#define IEEE80211_MAX_NAN_INSTANCE_ID 255
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
@@ -817,9 +819,16 @@ struct txq_info {
  * struct ieee80211_if_nan - NAN state
  *
  * @nan_conf: current nan configuration
+ * @func_ids: a bitmap of available instance_id's
  */
 struct ieee80211_if_nan {
 	struct cfg80211_nan_conf nan_conf;
+	unsigned long func_ids[BITS_TO_LONGS(IEEE80211_MAX_NAN_INSTANCE_ID +
+					     1)];
+
+	/* protects functions_list */
+	spinlock_t func_lock;
+	struct list_head functions_list;
 };
 
 struct ieee80211_sub_if_data {
@@ -1458,6 +1467,12 @@ struct ieee802_11_elems {
 	bool parse_error;
 };
 
+/* NAN function entry */
+struct ieee80211_nan_func {
+	struct list_head list;
+	struct cfg80211_nan_func func;
+};
+
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7887ed7..eed7358 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -792,6 +792,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct ps_data *ps;
 	struct cfg80211_chan_def chandef;
 	bool cancel_scan;
+	struct ieee80211_nan_func *func, *tmp_func;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -944,11 +945,21 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		break;
+	case NL80211_IFTYPE_NAN:
+		/* clean all the functions */
+		spin_lock_bh(&sdata->u.nan.func_lock);
+		list_for_each_entry_safe(func, tmp_func,
+					 &sdata->u.nan.functions_list, list) {
+			list_del(&func->list);
+			cfg80211_free_nan_func_members(&func->func);
+			kfree(func);
+		}
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* relies on synchronize_rcu() below */
 		RCU_INIT_POINTER(local->p2p_sdata, NULL);
 		/* fall through */
-	case NL80211_IFTYPE_NAN:
 	default:
 		cancel_work_sync(&sdata->work);
 		/*
@@ -1453,9 +1464,15 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 		sdata->vif.bss_conf.bssid = NULL;
 		break;
+	case NL80211_IFTYPE_NAN:
+		bitmap_zero(sdata->u.nan.func_ids,
+			    IEEE80211_MAX_NAN_INSTANCE_ID + 1);
+		INIT_LIST_HEAD(&sdata->u.nan.functions_list);
+		spin_lock_init(&sdata->u.nan.func_lock);
+		sdata->vif.bss_conf.bssid = sdata->vif.addr;
+		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_P2P_DEVICE:
-	case NL80211_IFTYPE_NAN:
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index ad5060e..936e103 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1061,6 +1061,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (!local->hw.txq_ac_max_pending)
 		local->hw.txq_ac_max_pending = 64;
 
+	if (!local->hw.max_nan_de_entries)
+		local->hw.max_nan_de_entries = IEEE80211_MAX_NAN_INSTANCE_ID;
+
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 4f17ad1..71828d7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1781,6 +1781,59 @@ TRACE_EVENT(drv_nan_change_conf,
 	)
 );
 
+/* TODO: record more fields */
+TRACE_EVENT(drv_add_nan_func,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const struct cfg80211_nan_func *func),
+
+	TP_ARGS(local, sdata, func),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, type)
+		__field(u8, inst_id)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->type = func->type;
+		__entry->inst_id = func->instance_id;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", type: %u, inst_id: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->type, __entry->inst_id
+	)
+);
+
+TRACE_EVENT(drv_rm_nan_func,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 u8 instance_id),
+
+	TP_ARGS(local, sdata, instance_id),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(u8, instance_id)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->instance_id = instance_id;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT
+		", instance_id: %u",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->instance_id
+	)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6ce88d4..241cb6f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1748,6 +1748,53 @@ static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->sta_mtx);
 }
 
+static int ieee80211_reconfig_nan(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_nan_func *func, *ftmp;
+	LIST_HEAD(tmp_list);
+	int res;
+
+	res = drv_start_nan(sdata->local, sdata,
+			    &sdata->u.nan.nan_conf);
+	if (WARN_ON(res))
+		return res;
+
+	/* Add all the functions:
+	 * This is a little bit ugly. We need to call a potentially sleeping
+	 * callback for each entry in the list, so we can't hold the spinlock.
+	 * So we will copy everything to a temporary list and empty the
+	 * original one. And then we re-add the functions one by one
+	 * to the list.
+	 */
+	spin_lock_bh(&sdata->u.nan.func_lock);
+	list_splice_tail_init(&sdata->u.nan.functions_list, &tmp_list);
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	list_for_each_entry_safe(func, ftmp, &tmp_list, list) {
+		list_del(&func->list);
+
+		/* TODO: need to adjust TTL of the function */
+		spin_lock_bh(&sdata->u.nan.func_lock);
+		list_add(&func->list, &sdata->u.nan.functions_list);
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		res = drv_add_nan_func(sdata->local, sdata,
+				       &func->func);
+		if (WARN_ON(res)) {
+			/* make sure all the functions are back in the list,
+			 * otherwise we leak memory
+			 */
+			spin_lock_bh(&sdata->u.nan.func_lock);
+			list_splice_tail(&tmp_list,
+					 &sdata->u.nan.functions_list);
+			spin_unlock_bh(&sdata->u.nan.func_lock);
+
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
@@ -1971,11 +2018,17 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 				ieee80211_bss_info_change_notify(sdata, changed);
 			}
 			break;
+		case NL80211_IFTYPE_NAN:
+			res = ieee80211_reconfig_nan(sdata);
+			if (res < 0) {
+				ieee80211_handle_reconfig_failure(local);
+				return res;
+			}
+			break;
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_AP_VLAN:
 		case NL80211_IFTYPE_MONITOR:
 		case NL80211_IFTYPE_P2P_DEVICE:
-		case NL80211_IFTYPE_NAN:
 			/* nothing to do */
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
-- 
2.5.0

