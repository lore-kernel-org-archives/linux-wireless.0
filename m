Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41630 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbeIUGQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 02:16:30 -0400
From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Subject: [PATCH v5 2/3] mac80211: support FTM responder configuration/statistics
Date: Thu, 20 Sep 2018 17:30:10 -0700
Message-Id: <1537489811-5752-3-git-send-email-pradeepc@codeaurora.org> (sfid-20180921_023024_426621_9A981993)
In-Reply-To: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
References: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
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
v5:
 - renamed 'civic' param to 'civicloc'

v4:
 - no changes

v3:
 - fixed ftm responder disabled case to be not supported.
 - changed ftm_responder param from bool to s8.

 include/net/mac80211.h    | 13 ++++++++
 net/mac80211/cfg.c        | 84 +++++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 16 +++++++++
 net/mac80211/trace.h      | 23 +++++++++++++
 net/mac80211/util.c       |  3 ++
 5 files changed, 139 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c26d2d36cbe..5425d65128c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -309,6 +309,8 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_KEEP_ALIVE: keep alive options (idle period or protected
  *	keep alive) changed.
  * @BSS_CHANGED_MCAST_RATE: Multicast Rate setting changed for this interface
+ * @BSS_CHANGED_FTM_RESPONDER: fime timing reasurement request responder
+ *	functionality changed for this BSS (AP mode).
  *
  */
 enum ieee80211_bss_change {
@@ -338,6 +340,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_MU_GROUPS		= 1<<23,
 	BSS_CHANGED_KEEP_ALIVE		= 1<<24,
 	BSS_CHANGED_MCAST_RATE		= 1<<25,
+	BSS_CHANGED_FTM_RESPONDER	= 1<<26,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -562,6 +565,9 @@ struct ieee80211_mu_group_data {
  * @protected_keep_alive: if set, indicates that the station should send an RSN
  *	protected frame to the AP to reset the idle timer at the AP for the
  *	station.
+ * @ftm_responder: whether to enable or disable fine timing measurement FTM
+ *	responder functionality.
+ * @ftmr_params: configurable lci/civic parameter when enabling FTM responder.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -612,6 +618,8 @@ struct ieee80211_bss_conf {
 	bool allow_p2p_go_ps;
 	u16 max_idle_period;
 	bool protected_keep_alive;
+	s8 ftm_responder;
+	struct cfg80211_ftm_responder_params *ftmr_params;
 };
 
 /**
@@ -3580,6 +3588,8 @@ enum ieee80211_reconfig_type {
  * @del_nan_func: Remove a NAN function. The driver must call
  *	ieee80211_nan_func_terminated() with
  *	NL80211_NAN_FUNC_TERM_REASON_USER_REQUEST reason code upon removal.
+ * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
+ *	Statistics should be cumulative, currently no way to reset is provided.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -3862,6 +3872,9 @@ struct ieee80211_ops {
 	void (*del_nan_func)(struct ieee80211_hw *hw,
 			    struct ieee80211_vif *vif,
 			    u8 instance_id);
+	int (*get_ftm_responder_stats)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct cfg80211_ftm_responder_stats *ftm_stats);
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 504627e2117f..5f1d7a76678a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -790,6 +790,48 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static int ieee80211_set_ftm_responder_params(
+				struct ieee80211_sub_if_data *sdata,
+				const u8 *lci, size_t lci_len,
+				const u8 *civicloc, size_t civicloc_len)
+{
+	struct cfg80211_ftm_responder_params *new, *old;
+	struct ieee80211_bss_conf *bss_conf;
+	u8 *pos;
+	int len;
+
+	if ((!lci || !lci_len) && (!civicloc || !civicloc_len))
+		return 1;
+
+	bss_conf = &sdata->vif.bss_conf;
+	old = bss_conf->ftmr_params;
+	len = lci_len + civicloc_len;
+
+	new = kzalloc(sizeof(*new) + len, GFP_KERNEL);
+	if (!new)
+		return -ENOMEM;
+
+	pos = (u8 *)(new + 1);
+	if (lci_len) {
+		new->lci_len = lci_len;
+		new->lci = pos;
+		memcpy(pos, lci, lci_len);
+		pos += lci_len;
+	}
+
+	if (civicloc_len) {
+		new->civicloc_len = civicloc_len;
+		new->civicloc = pos;
+		memcpy(pos, civicloc, civicloc_len);
+		pos += civicloc_len;
+	}
+
+	bss_conf->ftmr_params = new;
+	kfree(old);
+
+	return 0;
+}
+
 static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 				   struct cfg80211_beacon_data *params,
 				   const struct ieee80211_csa_settings *csa)
@@ -863,6 +905,22 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	if (err == 0)
 		changed |= BSS_CHANGED_AP_PROBE_RESP;
 
+	if (params->ftm_responder != -1) {
+		sdata->vif.bss_conf.ftm_responder = params->ftm_responder;
+		err = ieee80211_set_ftm_responder_params(sdata,
+							 params->lci,
+							 params->lci_len,
+							 params->civicloc,
+							 params->civicloc_len);
+
+		if (err < 0)
+			return err;
+
+		changed |= BSS_CHANGED_FTM_RESPONDER;
+	} else {
+		sdata->vif.bss_conf.ftm_responder = -1;
+	}
+
 	rcu_assign_pointer(sdata->u.ap.beacon, new);
 
 	if (old)
@@ -2875,6 +2933,20 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
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
+	if (beacon->civicloc) {
+		new_beacon->civicloc_len = beacon->civicloc_len;
+		new_beacon->civicloc = pos;
+		memcpy(pos, beacon->civicloc, beacon->civicloc_len);
+		pos += beacon->civicloc_len;
+	}
 
 	return new_beacon;
 }
@@ -3765,6 +3837,17 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
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
@@ -3859,4 +3942,5 @@ static int ieee80211_get_txq_stats(struct wiphy *wiphy,
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
index 36a3c2ada515..e89f82c0b22f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2175,6 +2175,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		case NL80211_IFTYPE_AP:
 			changed |= BSS_CHANGED_SSID | BSS_CHANGED_P2P_PS;
 
+			if (sdata->vif.bss_conf.ftm_responder != -1)
+				changed |= BSS_CHANGED_FTM_RESPONDER;
+
 			if (sdata->vif.type == NL80211_IFTYPE_AP) {
 				changed |= BSS_CHANGED_AP_PROBE_RESP;
 
-- 
1.9.1
