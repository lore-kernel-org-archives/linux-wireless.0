Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:52263 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbeHaFQL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 01:16:11 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: support FTM responder configuration/statistics
Date: Thu, 30 Aug 2018 18:11:10 -0700
Message-Id: <1535677870-32739-1-git-send-email-pradeepc@codeaurora.org> (sfid-20180831_031123_202290_ED1543E6)
In-Reply-To: <1534293018-4930-3-git-send-email-pradeepc@codeaurora.org>
References: <1534293018-4930-3-git-send-email-pradeepc@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New bss param ftm_responder is used to notify the driver to
enable fine timing request (FTM) responder role in AP mode.

Plumb the new cfg80211 API for FTM responder statistics through to
the driver API in mac80211.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
---
 include/net/mac80211.h    | 12 ++++++++
 net/mac80211/cfg.c        | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 16 ++++++++++
 net/mac80211/trace.h      | 23 +++++++++++++++
 net/mac80211/util.c       |  3 ++
 5 files changed, 128 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..db1e505e884f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -308,6 +308,8 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
+ * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
+ *	functionality changed for this BSS (AP mode).
  *
  */
 enum ieee80211_bss_change {
@@ -337,6 +339,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 	BSS_CHANGED_MCAST_RATE		= 1<<25,
+	BSS_CHANGED_FTM_RESPONDER	= 1<<26,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -561,6 +564,8 @@ struct ieee80211_mu_group_data {
  * @protected_keep_alive: if set, indicates that the station should send an RSN
  *	protected frame to the AP to reset the idle timer at the AP for the
  *	station.
+ * @ftm_responder: whether to enable fine timing measurement FTM functionality
+ * @ftmr_params: configurable lci/civic parameter when enabling FTM responder.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -611,6 +616,8 @@ struct ieee80211_bss_conf {
 	bool allow_p2p_go_ps;
 	u16 max_idle_period;
 	bool protected_keep_alive;
+	bool ftm_responder;
+	struct cfg80211_ftm_responder_params *ftmr_params;
 };
 
 /**
@@ -3542,6 +3549,8 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3824,6 +3833,9 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d25da0e66da1..4b2dd6bfd58c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -792,6 +792,40 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static int ieee80211_set_ftm_responder_params(
+				struct ieee80211_sub_if_data *sdata,
+				const u8 *lci, size_t lci_len,
+				const u8 *civic, size_t civic_len)
+{
+	struct cfg80211_ftm_responder_params *new, *old;
+	struct ieee80211_bss_conf *bss_conf;
+
+	if ((!lci || !lci_len) && (!civic || !civic_len))
+		return 1;
+
+	bss_conf = &sdata->vif.bss_conf;
+
+	old = bss_conf->ftmr_params;
+
+	new = kzalloc(sizeof(*new) + lci_len + civic_len, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	if (lci)
+		memcpy(new->lci, lci, lci_len);
+
+	if (civic)
+		memcpy(new->civic, civic, civic_len);
+
+	new->lci_len = lci_len;
+	new->civic_len = civic_len;
+	bss_conf->ftmr_params = new;
+
+	kfree(old);
+
+	return 0;
+}
+
 static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 				   struct cfg80211_beacon_data *params,
 				   const struct ieee80211_csa_settings *csa)
@@ -865,6 +899,20 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
+	if (params->ftm_responder) {
+		sdata->vif.bss_conf.ftm_responder = 1;
+		err = ieee80211_set_ftm_responder_params(sdata,
+							 params->lci,
+							 params->lci_len,
+							 params->civic,
+							 params->civic_len);
+
+		if (err < 0)
+			return err;
+
+		changed |= BSS_CHANGED_FTM_RESPONDER;
+	}
+
 	rcu_assign_pointer(sdata->u.ap.beacon, new);
 
 	if (old)
@@ -2918,6 +2966,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
 		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
 		pos += beacon->probe_resp_len;
 	}
+	if (beacon->ftm_responder)
+		new_beacon->ftm_responder = beacon->ftm_responder;
+	if (beacon->lci) {
+		new_beacon->lci_len = beacon->lci_len;
+		new_beacon->lci = pos;
+		memcpy(pos, beacon->lci, beacon->lci_len);
+		pos += beacon->lci_len;
+	}
+	if (beacon->civic) {
+		new_beacon->civic_len = beacon->civic_len;
+		new_beacon->civic = pos;
+		memcpy(pos, beacon->civic, beacon->civic_len);
+		pos += beacon->civic_len;
+	}
 
 	return new_beacon;
 }
@@ -3808,6 +3870,17 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	return ret;
 }
 
+static int
+ieee80211_get_ftm_responder_stats(struct wiphy *wiphy,
+				  struct net_device *dev,
+				  struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3902,4 +3975,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
 	.set_multicast_to_unicast = ieee80211_set_multicast_to_unicast,
 	.tx_control_port = ieee80211_tx_control_port,
 	.get_txq_stats = ieee80211_get_txq_stats,
+	.get_ftm_responder_stats = ieee80211_get_ftm_responder_stats,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 8f6998091d26..16878f7310ab 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1173,6 +1173,22 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline int
+drv_get_ftm_responder_stats(struct ieee80211_local *local,
+			    struct ieee80211_sub_if_data *sdata,
+			    struct cfg80211_ftm_responder_stats *ftm_stats)
+{
+	u32 ret = -EOPNOTSUPP;
+
+	if (local->ops->get_ftm_responder_stats)
+		ret = local->ops->get_ftm_responder_stats(&local->hw,
+							 &sdata->vif,
+							 ftm_stats);
+	trace_drv_get_ftm_responder_stats(local, sdata, ftm_stats);
+
+	return ret;
+}
+
 static inline int drv_start_nan(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				struct cfg80211_nan_conf *conf)
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0ab69a1964f8..588c51a67c89 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2600,6 +2600,29 @@ struct trace_switch_entry {
 	)
 );
 
+TRACE_EVENT(drv_get_ftm_responder_stats,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_ftm_responder_stats *ftm_stats),
+
+	TP_ARGS(local, sdata, ftm_stats),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT,
+		LOCAL_PR_ARG, VIF_PR_ARG
+	)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 88efda7c9f8a..787405d483bf 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2076,6 +2076,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
+			if (sdata->vif.bss_conf.ftm_responder)
+				changed |= BSS_CHANGED_FTM_RESPONDER;
+
 			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
 
-- 
1.9.1
