Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33402 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606AbaKRQ5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 11:57:30 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] [RFC] mac80211: allow drivers to support NL80211_SCAN_FLAG_RANDOM_ADDR
Date: Tue, 18 Nov 2014 17:57:18 +0100
Message-Id: <1416329839-21648-2-git-send-email-johannes@sipsolutions.net> (sfid-20141118_175735_583134_D41AD850)
In-Reply-To: <1416329839-21648-1-git-send-email-johannes@sipsolutions.net>
References: <1416329839-21648-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow drivers to support NL80211_SCAN_FLAG_RANDOM_ADDR with software
based scanning and generate a random MAC address for them for every
scan request with the flag.

Change-Id: I17566082fcfa7ae977c5e03739fd87e050ab8d28
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  9 ++++++---
 include/net/mac80211.h                | 15 ++++++++++-----
 net/mac80211/driver-ops.h             | 15 +++++++++------
 net/mac80211/ieee80211_i.h            |  7 +++++--
 net/mac80211/mlme.c                   |  8 +++++---
 net/mac80211/scan.c                   | 34 +++++++++++++++++++++++++++-------
 net/mac80211/trace.h                  | 31 +++++++++++++++++++++++++------
 net/mac80211/tx.c                     |  9 +++------
 net/mac80211/util.c                   | 12 +++++++-----
 9 files changed, 97 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9c0e9f520271..8507e42fe68c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1752,7 +1752,7 @@ static void hw_scan_work(struct work_struct *work)
 			struct sk_buff *probe;
 
 			probe = ieee80211_probereq_get(hwsim->hw,
-						       hwsim->hw_scan_vif,
+						       hwsim->hw_scan_vif->addr,
 						       req->ssids[i].ssid,
 						       req->ssids[i].ssid_len,
 						       req->ie_len);
@@ -1816,7 +1816,9 @@ static void mac80211_hwsim_cancel_hw_scan(struct ieee80211_hw *hw,
 	mutex_unlock(&hwsim->mutex);
 }
 
-static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw)
+static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   const u8 *mac_addr)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
@@ -1834,7 +1836,8 @@ out:
 	mutex_unlock(&hwsim->mutex);
 }
 
-static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw)
+static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw,
+					    struct ieee80211_vif *vif)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f8cdb9d472a9..4cfcebabedae 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2606,7 +2606,9 @@ enum ieee80211_reconfig_type {
  *
  * @sw_scan_start: Notifier function that is called just before a software scan
  *	is started. Can be NULL, if the driver doesn't need this notification.
- *	The callback can sleep.
+ *	The mac_addr parameter allows supporting NL80211_SCAN_FLAG_RANDOM_ADDR,
+ *	the driver may set the NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR flag if it
+ *	can use this parameter. The callback can sleep.
  *
  * @sw_scan_complete: Notifier function that is called just after a
  *	software scan finished. Can be NULL, if the driver doesn't need
@@ -3001,8 +3003,11 @@ struct ieee80211_ops {
 				struct ieee80211_scan_ies *ies);
 	int (*sched_scan_stop)(struct ieee80211_hw *hw,
 			       struct ieee80211_vif *vif);
-	void (*sw_scan_start)(struct ieee80211_hw *hw);
-	void (*sw_scan_complete)(struct ieee80211_hw *hw);
+	void (*sw_scan_start)(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      const u8 *mac_addr);
+	void (*sw_scan_complete)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
@@ -3805,7 +3810,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 /**
  * ieee80211_probereq_get - retrieve a Probe Request template
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @src_addr: source MAC address
  * @ssid: SSID buffer
  * @ssid_len: length of SSID
  * @tailroom: tailroom to reserve at end of SKB for IEs
@@ -3816,7 +3821,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
  * Return: The Probe Request template. %NULL on error.
  */
 struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
+				       const u8 *src_addr,
 				       const u8 *ssid, size_t ssid_len,
 				       size_t tailroom);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f04414259961..5660f1e58b15 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -380,23 +380,26 @@ static inline int drv_sched_scan_stop(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_sw_scan_start(struct ieee80211_local *local)
+static inline void drv_sw_scan_start(struct ieee80211_local *local,
+				     struct ieee80211_sub_if_data *sdata,
+				     const u8 *mac_addr)
 {
 	might_sleep();
 
-	trace_drv_sw_scan_start(local);
+	trace_drv_sw_scan_start(local, sdata, mac_addr);
 	if (local->ops->sw_scan_start)
-		local->ops->sw_scan_start(&local->hw);
+		local->ops->sw_scan_start(&local->hw, &sdata->vif, mac_addr);
 	trace_drv_return_void(local);
 }
 
-static inline void drv_sw_scan_complete(struct ieee80211_local *local)
+static inline void drv_sw_scan_complete(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata)
 {
 	might_sleep();
 
-	trace_drv_sw_scan_complete(local);
+	trace_drv_sw_scan_complete(local, sdata);
 	if (local->ops->sw_scan_complete)
-		local->ops->sw_scan_complete(&local->hw);
+		local->ops->sw_scan_complete(&local->hw, &sdata->vif);
 	trace_drv_return_void(local);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a423b953a5e6..12e828dbf21f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1291,6 +1291,7 @@ struct ieee80211_local {
 	struct work_struct sched_scan_stopped_work;
 	struct ieee80211_sub_if_data __rcu *sched_scan_sdata;
 	struct cfg80211_sched_scan_request *sched_scan_req;
+	u8 scan_addr[ETH_ALEN];
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
@@ -1945,12 +1946,14 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     u8 bands_used, u32 *rate_masks,
 			     struct cfg80211_chan_def *chandef);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
-					  u8 *dst, u32 ratemask,
+					  const u8 *src, const u8 *dst,
+					  u32 ratemask,
 					  struct ieee80211_channel *chan,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed);
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata,
+			      const u8 *src, const u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
 			      u32 ratemask, bool directed, u32 tx_flags,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8bec6dbdff43..cae3af7b1205 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2235,7 +2235,8 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		else
 			ssid_len = ssid[1];
 
-		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
+		ieee80211_send_probe_req(sdata, sdata->vif.addr, NULL,
+					 ssid + 2, ssid_len, NULL,
 					 0, (u32) -1, true, 0,
 					 ifmgd->associated->channel, false);
 		rcu_read_unlock();
@@ -2338,7 +2339,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 	else
 		ssid_len = ssid[1];
 
-	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
+	skb = ieee80211_build_probe_req(sdata, sdata->vif.addr, cbss->bssid,
 					(u32) -1, cbss->channel,
 					ssid + 2, ssid_len,
 					NULL, 0, true);
@@ -3659,7 +3660,8 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		 * Direct probe is sent to broadcast address as some APs
 		 * will not answer to direct packet in unassociated state.
 		 */
-		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
+		ieee80211_send_probe_req(sdata, sdata->vif.addr, NULL,
+					 ssidie + 2, ssidie[1],
 					 NULL, 0, (u32) -1, true, 0,
 					 auth_data->bss->channel, false);
 		rcu_read_unlock();
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d23c8d90c3b4..dd4c4a077361 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -281,6 +281,9 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 					 bands_used, req->rates, &chandef);
 	local->hw_scan_req->req.ie_len = ielen;
 	local->hw_scan_req->req.no_cck = req->no_cck;
+	ether_addr_copy(local->hw_scan_req->req.mac_addr, req->mac_addr);
+	ether_addr_copy(local->hw_scan_req->req.mac_addr_mask,
+			req->mac_addr_mask);
 
 	return true;
 }
@@ -290,6 +293,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool hw_scan = local->ops->hw_scan;
 	bool was_scanning = local->scanning;
+	struct ieee80211_sub_if_data *scan_sdata;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -325,6 +329,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	if (local->scan_req != local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
+	scan_sdata = rcu_dereference_protected(local->scan_sdata,
+					       lockdep_is_held(&local->mtx));
 	RCU_INIT_POINTER(local->scan_sdata, NULL);
 
 	local->scanning = 0;
@@ -335,7 +341,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	if (!hw_scan) {
 		ieee80211_configure_filter(local);
-		drv_sw_scan_complete(local);
+		drv_sw_scan_complete(local, scan_sdata);
 		ieee80211_offchannel_return(local);
 	}
 
@@ -361,7 +367,8 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
-static int ieee80211_start_sw_scan(struct ieee80211_local *local)
+static int ieee80211_start_sw_scan(struct ieee80211_local *local,
+				   struct ieee80211_sub_if_data *sdata)
 {
 	/* Software scan is not supported in multi-channel cases */
 	if (local->use_chanctx)
@@ -380,7 +387,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
-	drv_sw_scan_start(local);
+	drv_sw_scan_start(local, sdata, local->scan_addr);
 
 	local->leave_oper_channel_time = jiffies;
 	local->next_scan_state = SCAN_DECISION;
@@ -452,7 +459,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
-			sdata, NULL,
+			sdata, local->scan_addr, NULL,
 			local->scan_req->ssids[i].ssid,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
@@ -533,6 +540,18 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	local->scan_req = req;
 	rcu_assign_pointer(local->scan_sdata, sdata);
 
+	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+		int i;
+
+		get_random_bytes(local->scan_addr, ETH_ALEN);
+		for (i = 0; i < ETH_ALEN; i++) {
+			local->scan_addr[i] &= ~req->mac_addr_mask[i];
+			local->scan_addr[i] |= req->mac_addr[i];
+		}
+	} else {
+		memcpy(local->scan_addr, sdata->vif.addr, ETH_ALEN);
+	}
+
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
@@ -549,7 +568,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		/* Notify driver scan is starting, keep order of operations
 		 * same as normal software scan, in case that matters. */
-		drv_sw_scan_start(local);
+		drv_sw_scan_start(local, sdata, local->scan_addr);
 
 		ieee80211_configure_filter(local); /* accept probe-responses */
 
@@ -579,8 +598,9 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		WARN_ON(!ieee80211_prep_hw_scan(local));
 		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
-	} else
-		rc = ieee80211_start_sw_scan(local);
+	} else {
+		rc = ieee80211_start_sw_scan(local, sdata);
+	}
 
 	if (rc) {
 		kfree(local->hw_scan_req);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 21d35ca1ef7a..5d22400b5b4a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -596,14 +596,33 @@ DEFINE_EVENT(local_sdata_evt, drv_sched_scan_stop,
 	TP_ARGS(local, sdata)
 );
 
-DEFINE_EVENT(local_only_evt, drv_sw_scan_start,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+TRACE_EVENT(drv_sw_scan_start,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *mac_addr),
+
+	TP_ARGS(local, sdata, mac_addr),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, mac_addr, ETH_ALEN)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->mac_addr, mac_addr, ETH_ALEN);
+	),
+
+	TP_printk(LOCAL_PR_FMT ", " VIF_PR_FMT ", addr:%pM",
+		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->mac_addr)
 );
 
-DEFINE_EVENT(local_only_evt, drv_sw_scan_complete,
-	TP_PROTO(struct ieee80211_local *local),
-	TP_ARGS(local)
+DEFINE_EVENT(local_sdata_evt, drv_sw_scan_complete,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata),
+	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_get_stats,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 019a15527993..4d356c28b483 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2966,19 +2966,16 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(ieee80211_nullfunc_get);
 
 struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
-				       struct ieee80211_vif *vif,
+				       const u8 *src_addr,
 				       const u8 *ssid, size_t ssid_len,
 				       size_t tailroom)
 {
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local;
+	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_hdr_3addr *hdr;
 	struct sk_buff *skb;
 	size_t ie_ssid_len;
 	u8 *pos;
 
-	sdata = vif_to_sdata(vif);
-	local = sdata->local;
 	ie_ssid_len = 2 + ssid_len;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*hdr) +
@@ -2993,7 +2990,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_REQ);
 	eth_broadcast_addr(hdr->addr1);
-	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
+	memcpy(hdr->addr2, src_addr, ETH_ALEN);
 	eth_broadcast_addr(hdr->addr3);
 
 	pos = skb_put(skb, ie_ssid_len);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 745a8a9cbbb5..4c043749b3b5 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1523,7 +1523,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 };
 
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
-					  u8 *dst, u32 ratemask,
+					  const u8 *src, const u8 *dst,
+					  u32 ratemask,
 					  struct ieee80211_channel *chan,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
@@ -1548,8 +1549,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	else
 		chandef.chan = chan;
 
-	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
-				     ssid, ssid_len, 100 + ie_len);
+	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
+				     100 + ie_len);
 	if (!skb)
 		return NULL;
 
@@ -1571,7 +1572,8 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	return skb;
 }
 
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata,
+			      const u8 *src, const u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
 			      u32 ratemask, bool directed, u32 tx_flags,
@@ -1579,7 +1581,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 {
 	struct sk_buff *skb;
 
-	skb = ieee80211_build_probe_req(sdata, dst, ratemask, channel,
+	skb = ieee80211_build_probe_req(sdata, src, dst, ratemask, channel,
 					ssid, ssid_len,
 					ie, ie_len, directed);
 	if (skb) {
-- 
2.1.1

