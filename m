Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55094 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756556AbcIPIdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 04:33:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Sep 2016 11:33:20 +0300
Message-Id: <20160916083321.5840-9-luca@coelho.fi> (sfid-20160916_103430_039071_4C669654)
In-Reply-To: <20160916083321.5840-1-luca@coelho.fi>
References: <20160916083321.5840-1-luca@coelho.fi>
Subject: [PATCH v2 8/9] mac80211: Implement add_nan_func and rm_nan_func
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Implement add/rm_nan_func functions and handle NAN function
termination notifications. Handle instance_id allocation for
NAN functions and implement the reconfig flow.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/mac80211.h     |  31 ++++++++++++
 net/mac80211/cfg.c         | 114 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  |  32 +++++++++++++
 net/mac80211/ieee80211_i.h |   7 +++
 net/mac80211/iface.c       |  20 +++++++-
 net/mac80211/main.c        |   3 ++
 net/mac80211/trace.h       |  52 +++++++++++++++++++++
 net/mac80211/util.c        |  48 ++++++++++++++++++-
 8 files changed, 304 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ef8d02a..5b74229 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2177,6 +2177,8 @@ enum ieee80211_hw_flags {
  * @n_cipher_schemes: a size of an array of cipher schemes definitions.
  * @cipher_schemes: a pointer to an array of cipher scheme definitions
  *	supported by HW.
+ * @max_nan_de_entries: maximum number of NAN DE functions supported by the
+ *	device.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -2211,6 +2213,7 @@ struct ieee80211_hw {
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
 	const struct ieee80211_cipher_scheme *cipher_schemes;
+	u8 max_nan_de_entries;
 };
 
 static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
@@ -3429,6 +3432,12 @@ enum ieee80211_reconfig_type {
  *	The driver gets both full configuration and the changed parameters since
  *	some devices may need the full configuration while others need only the
  *	changed parameters.
+ * @add_nan_func: Add a NAN function. Returns 0 on success. The data in
+ *	cfg80211_nan_func must not be referenced outside the scope of
+ *	this call.
+ * @rm_nan_func: Remove a NAN function. The driver must call
+ *	ieee80211_nan_func_terminated() with
+ *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3673,6 +3682,12 @@ struct ieee80211_ops {
 	int (*nan_change_conf)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif,
 			       struct cfg80211_nan_conf *conf, u32 changes);
+	int (*add_nan_func)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    const struct cfg80211_nan_func *nan_func);
+	void (*rm_nan_func)(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    u8 instance_id);
 };
 
 /**
@@ -5746,4 +5761,20 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 void ieee80211_txq_get_depth(struct ieee80211_txq *txq,
 			     unsigned long *frame_cnt,
 			     unsigned long *byte_cnt);
+
+/**
+ * ieee80211_nan_func_terminated - notify about NAN function termination.
+ *
+ * This function is used to notify mac80211 about NAN function termination.
+ * Note that this function can't be called from hard irq.
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
 #endif /* MAC80211_H */
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 38fdb53..aee0e25c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -174,6 +174,8 @@ static int ieee80211_start_nan(struct wiphy *wiphy,
 	if (ret)
 		ieee80211_sdata_stop(sdata);
 
+	sdata->u.nan.conf = *conf;
+
 	return ret;
 }
 
@@ -216,6 +218,84 @@ static int ieee80211_nan_change_conf(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_add_nan_func(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  struct cfg80211_nan_func *nan_func)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	int ret;
+
+	if (sdata->vif.type != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	ret = idr_alloc(&sdata->u.nan.function_inst_ids,
+			nan_func, 1, sdata->local->hw.max_nan_de_entries + 1,
+			GFP_ATOMIC);
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	if (ret < 0)
+		return ret;
+
+	nan_func->instance_id = ret;
+
+	WARN_ON(nan_func->instance_id == 0);
+
+	ret = drv_add_nan_func(sdata->local, sdata, nan_func);
+	if (ret) {
+		spin_lock_bh(&sdata->u.nan.func_lock);
+		idr_remove(&sdata->u.nan.function_inst_ids,
+			   nan_func->instance_id);
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+	}
+
+	return ret;
+}
+
+static struct cfg80211_nan_func *
+ieee80211_find_nan_func_by_cookie(struct ieee80211_sub_if_data *sdata,
+				  u64 cookie)
+{
+	struct cfg80211_nan_func *func;
+	int id;
+
+	lockdep_assert_held(&sdata->u.nan.func_lock);
+
+	idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, id) {
+		if (func->cookie == cookie)
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
+	struct cfg80211_nan_func *func;
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
+		instance_id = func->instance_id;
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
@@ -3443,6 +3523,38 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+void ieee80211_nan_func_terminated(struct ieee80211_vif *vif,
+				   u8 inst_id,
+				   enum nl80211_nan_func_term_reason reason,
+				   gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct cfg80211_nan_func *func;
+	u64 cookie;
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_NAN))
+		return;
+
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	func = idr_find(&sdata->u.nan.function_inst_ids, inst_id);
+	if (WARN_ON(!func)) {
+		spin_unlock_bh(&sdata->u.nan.func_lock);
+		return;
+	}
+
+	cookie = func->cookie;
+	idr_remove(&sdata->u.nan.function_inst_ids, inst_id);
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	cfg80211_free_nan_func(func);
+
+	cfg80211_nan_func_terminated(ieee80211_vif_to_wdev(vif), inst_id,
+				     reason, cookie, gfp);
+}
+EXPORT_SYMBOL(ieee80211_nan_func_terminated);
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3531,4 +3643,6 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.start_nan = ieee80211_start_nan,
 	.stop_nan = ieee80211_stop_nan,
 	.nan_change_conf = ieee80211_nan_change_conf,
+	.add_nan_func = ieee80211_add_nan_func,
+	.rm_nan_func = ieee80211_rm_nan_func,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 50aeb3a..ff1066b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1213,4 +1213,36 @@ static inline int drv_nan_change_conf(struct ieee80211_local *local,
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
index 712b20b..2b391f2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -86,6 +86,8 @@ struct ieee80211_local;
 
 #define IEEE80211_DEAUTH_FRAME_LEN	(24 /* hdr */ + 2 /* reason */)
 
+#define IEEE80211_MAX_NAN_INSTANCE_ID 255
+
 struct ieee80211_fragment_entry {
 	struct sk_buff_head skb_list;
 	unsigned long first_frag_time;
@@ -834,9 +836,14 @@ struct ieee80211_if_mntr {
  * struct ieee80211_if_nan - NAN state
  *
  * @conf: current NAN configuration
+ * @func_ids: a bitmap of available instance_id's
  */
 struct ieee80211_if_nan {
 	struct cfg80211_nan_conf conf;
+
+	/* protects function_inst_ids */
+	spinlock_t func_lock;
+	struct idr function_inst_ids;
 };
 
 struct ieee80211_sub_if_data {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 507f46a..638ec07 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -798,6 +798,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	struct ps_data *ps;
 	struct cfg80211_chan_def chandef;
 	bool cancel_scan;
+	struct cfg80211_nan_func *func;
 
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 
@@ -950,11 +951,22 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_adjust_monitor_flags(sdata, -1);
 		break;
+	case NL80211_IFTYPE_NAN:
+		/* clean all the functions */
+		spin_lock_bh(&sdata->u.nan.func_lock);
+
+		idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, i) {
+			idr_remove(&sdata->u.nan.function_inst_ids, i);
+			cfg80211_free_nan_func(func);
+		}
+		idr_destroy(&sdata->u.nan.function_inst_ids);
+
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
@@ -1462,9 +1474,13 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_WDS:
 		sdata->vif.bss_conf.bssid = NULL;
 		break;
+	case NL80211_IFTYPE_NAN:
+		idr_init(&sdata->u.nan.function_inst_ids);
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
index b5cf2c5..1075ac2 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1063,6 +1063,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->dynamic_ps_forced_timeout = -1;
 
+	if (!local->hw.max_nan_de_entries)
+		local->hw.max_nan_de_entries = IEEE80211_MAX_NAN_INSTANCE_ID;
+
 	result = ieee80211_wep_init(local);
 	if (result < 0)
 		wiphy_debug(local->hw.wiphy, "Failed to initialize wep: %d\n",
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0bafe11..e6bed8a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1781,6 +1781,58 @@ TRACE_EVENT(drv_nan_change_conf,
 	)
 );
 
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
index 5b57fca..91754c8 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1749,6 +1749,46 @@ static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->sta_mtx);
 }
 
+static int ieee80211_reconfig_nan(struct ieee80211_sub_if_data *sdata)
+{
+	struct cfg80211_nan_func *func, **funcs;
+	int res, id, i = 0;
+
+	res = drv_start_nan(sdata->local, sdata,
+			    &sdata->u.nan.conf);
+	if (WARN_ON(res))
+		return res;
+
+	funcs = kzalloc((sdata->local->hw.max_nan_de_entries + 1) *
+			sizeof(*funcs), GFP_KERNEL);
+	if (!funcs)
+		return -ENOMEM;
+
+	/* Add all the functions:
+	 * This is a little bit ugly. We need to call a potentially sleeping
+	 * callback for each NAN function, so we can't hold the spinlock.
+	 */
+	spin_lock_bh(&sdata->u.nan.func_lock);
+
+	idr_for_each_entry(&sdata->u.nan.function_inst_ids, func, id)
+		funcs[i++] = func;
+
+	spin_unlock_bh(&sdata->u.nan.func_lock);
+
+	for (i = 0; funcs[i]; i++) {
+		res = drv_add_nan_func(sdata->local, sdata, funcs[i]);
+		if (WARN_ON(res))
+			ieee80211_nan_func_terminated(&sdata->vif,
+						      funcs[i]->instance_id,
+						      NL80211_NAN_FUNC_TERM_REASON_ERROR,
+						      GFP_KERNEL);
+	}
+
+	kfree(funcs);
+
+	return 0;
+}
+
 int ieee80211_reconfig(struct ieee80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
@@ -1972,11 +2012,17 @@ int ieee80211_reconfig(struct ieee80211_local *local)
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
2.9.3
