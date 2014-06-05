Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:58476 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaFEM30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:29:26 -0400
Received: by mail-we0-f179.google.com with SMTP id q59so984845wes.24
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 05:29:25 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/2] mac80211: move csa counters from sdata to beacon/presp
Date: Thu,  5 Jun 2014 14:21:36 +0200
Message-Id: <1401970897-21389-2-git-send-email-michal.kazior@tieto.com> (sfid-20140605_142931_036186_80641AFD)
In-Reply-To: <1401970897-21389-1-git-send-email-michal.kazior@tieto.com>
References: <1401345535-22991-1-git-send-email-michal.kazior@tieto.com>
 <1401970897-21389-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having csa counters part of beacon and probe_resp
structures makes it easier to get rid of possible
races between setting a beacon and updating
counters on SMP systems by guaranteeing counters
are always consistent against given beacon struct.

While at it relax WARN_ON into WARN_ON_ONCE to
prevent spamming logs and racing.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * fix unbalanced rcu locking
     * use plural form of the word `offset` for variables
     * define a struct to pass csa arguments to ieee80211_assign_beacon() [Johannes]
     * fix lines with over 80 chars
    
    v3:
     * use sizeof(x[0]) instead of sizeof(*x) [Johannes]

 net/mac80211/cfg.c         |  67 +++++++++++++++++++----------
 net/mac80211/ibss.c        |   2 +-
 net/mac80211/ieee80211_i.h |  16 +++++--
 net/mac80211/mesh.c        |   2 +-
 net/mac80211/tx.c          | 104 +++++++++++++++++++++++++--------------------
 5 files changed, 116 insertions(+), 75 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d7513a5..c17e624 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -875,7 +875,8 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 }
 
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
-				    const u8 *resp, size_t resp_len)
+				    const u8 *resp, size_t resp_len,
+				    const struct ieee80211_csa_settings *csa)
 {
 	struct probe_resp *new, *old;
 
@@ -891,6 +892,11 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 	new->len = resp_len;
 	memcpy(new->data, resp, resp_len);
 
+	if (csa)
+		memcpy(new->csa_counter_offsets, csa->counter_offsets_presp,
+		       csa->n_counter_offsets_presp *
+		       sizeof(new->csa_counter_offsets[0]));
+
 	rcu_assign_pointer(sdata->u.ap.probe_resp, new);
 	if (old)
 		kfree_rcu(old, rcu_head);
@@ -899,7 +905,8 @@ static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 }
 
 static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
-				   struct cfg80211_beacon_data *params)
+				   struct cfg80211_beacon_data *params,
+				   const struct ieee80211_csa_settings *csa)
 {
 	struct beacon_data *new, *old;
 	int new_head_len, new_tail_len;
@@ -943,6 +950,13 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	new->head_len = new_head_len;
 	new->tail_len = new_tail_len;
 
+	if (csa) {
+		new->csa_current_counter = csa->count;
+		memcpy(new->csa_counter_offsets, csa->counter_offsets_beacon,
+		       csa->n_counter_offsets_beacon *
+		       sizeof(new->csa_counter_offsets[0]));
+	}
+
 	/* copy in head */
 	if (params->head)
 		memcpy(new->head, params->head, new_head_len);
@@ -957,7 +971,7 @@ static int ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 			memcpy(new->tail, old->tail, new_tail_len);
 
 	err = ieee80211_set_probe_resp(sdata, params->probe_resp,
-				       params->probe_resp_len);
+				       params->probe_resp_len, csa);
 	if (err < 0)
 		return err;
 	if (err == 0)
@@ -1042,7 +1056,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		sdata->vif.bss_conf.p2p_noa_attr.oppps_ctwindow |=
 					IEEE80211_P2P_OPPPS_ENABLE_BIT;
 
-	err = ieee80211_assign_beacon(sdata, &params->beacon);
+	err = ieee80211_assign_beacon(sdata, &params->beacon, NULL);
 	if (err < 0) {
 		ieee80211_vif_release_channel(sdata);
 		return err;
@@ -1090,7 +1104,7 @@ static int ieee80211_change_beacon(struct wiphy *wiphy, struct net_device *dev,
 	if (!old)
 		return -ENOENT;
 
-	err = ieee80211_assign_beacon(sdata, params);
+	err = ieee80211_assign_beacon(sdata, params, NULL);
 	if (err < 0)
 		return err;
 	ieee80211_bss_info_change_notify(sdata, err);
@@ -3073,7 +3087,8 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
-		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon);
+		err = ieee80211_assign_beacon(sdata, sdata->u.ap.next_beacon,
+					      NULL);
 		kfree(sdata->u.ap.next_beacon);
 		sdata->u.ap.next_beacon = NULL;
 
@@ -3176,6 +3191,7 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 				    struct cfg80211_csa_settings *params,
 				    u32 *changed)
 {
+	struct ieee80211_csa_settings csa = {};
 	int err;
 
 	switch (sdata->vif.type) {
@@ -3210,20 +3226,13 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 		     IEEE80211_MAX_CSA_COUNTERS_NUM))
 			return -EINVAL;
 
-		/* make sure we don't have garbage in other counters */
-		memset(sdata->csa_counter_offset_beacon, 0,
-		       sizeof(sdata->csa_counter_offset_beacon));
-		memset(sdata->csa_counter_offset_presp, 0,
-		       sizeof(sdata->csa_counter_offset_presp));
-
-		memcpy(sdata->csa_counter_offset_beacon,
-		       params->counter_offsets_beacon,
-		       params->n_counter_offsets_beacon * sizeof(u16));
-		memcpy(sdata->csa_counter_offset_presp,
-		       params->counter_offsets_presp,
-		       params->n_counter_offsets_presp * sizeof(u16));
+		csa.counter_offsets_beacon = params->counter_offsets_beacon;
+		csa.counter_offsets_presp = params->counter_offsets_presp;
+		csa.n_counter_offsets_beacon = params->n_counter_offsets_beacon;
+		csa.n_counter_offsets_presp = params->n_counter_offsets_presp;
+		csa.count = params->count;
 
-		err = ieee80211_assign_beacon(sdata, &params->beacon_csa);
+		err = ieee80211_assign_beacon(sdata, &params->beacon_csa, &csa);
 		if (err < 0) {
 			kfree(sdata->u.ap.next_beacon);
 			return err;
@@ -3367,7 +3376,6 @@ __ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	sdata->csa_radar_required = params->radar_required;
 	sdata->csa_chandef = params->chandef;
 	sdata->csa_block_tx = params->block_tx;
-	sdata->csa_current_counter = params->count;
 	sdata->vif.csa_active = true;
 
 	if (sdata->csa_block_tx)
@@ -3515,10 +3523,23 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	     sdata->vif.type == NL80211_IFTYPE_ADHOC) &&
 	    params->n_csa_offsets) {
 		int i;
-		u8 c = sdata->csa_current_counter;
+		struct beacon_data *beacon = NULL;
 
-		for (i = 0; i < params->n_csa_offsets; i++)
-			data[params->csa_offsets[i]] = c;
+		rcu_read_lock();
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
+			beacon = rcu_dereference(sdata->u.ap.beacon);
+		else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+			beacon = rcu_dereference(sdata->u.ibss.presp);
+		else if (ieee80211_vif_is_mesh(&sdata->vif))
+			beacon = rcu_dereference(sdata->u.mesh.beacon);
+
+		if (beacon)
+			for (i = 0; i < params->n_csa_offsets; i++)
+				data[params->csa_offsets[i]] =
+					beacon->csa_current_counter;
+
+		rcu_read_unlock();
 	}
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 18ee0a2..713485f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -143,7 +143,7 @@ ieee80211_ibss_build_presp(struct ieee80211_sub_if_data *sdata,
 		*pos++ = csa_settings->block_tx ? 1 : 0;
 		*pos++ = ieee80211_frequency_to_channel(
 				csa_settings->chandef.chan->center_freq);
-		sdata->csa_counter_offset_beacon[0] = (pos - presp->head);
+		presp->csa_counter_offsets[0] = (pos - presp->head);
 		*pos++ = csa_settings->count;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ed2b817..998c18c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -229,16 +229,29 @@ struct ieee80211_rx_data {
 	u16 tkip_iv16;
 };
 
+struct ieee80211_csa_settings {
+	const u16 *counter_offsets_beacon;
+	const u16 *counter_offsets_presp;
+
+	int n_counter_offsets_beacon;
+	int n_counter_offsets_presp;
+
+	u8 count;
+};
+
 struct beacon_data {
 	u8 *head, *tail;
 	int head_len, tail_len;
 	struct ieee80211_meshconf_ie *meshconf;
+	u16 csa_counter_offsets[IEEE80211_MAX_CSA_COUNTERS_NUM];
+	u8 csa_current_counter;
 	struct rcu_head rcu_head;
 };
 
 struct probe_resp {
 	struct rcu_head rcu_head;
 	int len;
+	u16 csa_counter_offsets[IEEE80211_MAX_CSA_COUNTERS_NUM];
 	u8 data[0];
 };
 
@@ -753,8 +766,6 @@ struct ieee80211_sub_if_data {
 	struct mac80211_qos_map __rcu *qos_map;
 
 	struct work_struct csa_finalize_work;
-	u16 csa_counter_offset_beacon[IEEE80211_MAX_CSA_COUNTERS_NUM];
-	u16 csa_counter_offset_presp[IEEE80211_MAX_CSA_COUNTERS_NUM];
 	bool csa_radar_required;
 	bool csa_block_tx; /* write-protected by sdata_lock and local->mtx */
 	struct cfg80211_chan_def csa_chandef;
@@ -766,7 +777,6 @@ struct ieee80211_sub_if_data {
 	struct ieee80211_chanctx *reserved_chanctx;
 	struct cfg80211_chan_def reserved_chandef;
 	bool reserved_radar_required;
-	u8 csa_current_counter;
 
 	/* used to reconfigure hardware SM PS */
 	struct work_struct recalc_smps;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index da16468..e9f99c1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -679,7 +679,7 @@ ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 		*pos++ = 0x0;
 		*pos++ = ieee80211_frequency_to_channel(
 				csa->settings.chandef.chan->center_freq);
-		sdata->csa_counter_offset_beacon[0] = hdr_len + 6;
+		bcn->csa_counter_offsets[0] = hdr_len + 6;
 		*pos++ = csa->settings.count;
 		*pos++ = WLAN_EID_CHAN_SWITCH_PARAM;
 		*pos++ = 6;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8170d99..ad5da6a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2425,7 +2425,7 @@ static void ieee80211_set_csa(struct ieee80211_sub_if_data *sdata,
 	u8 *beacon_data;
 	size_t beacon_data_len;
 	int i;
-	u8 count = sdata->csa_current_counter;
+	u8 count = beacon->csa_current_counter;
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP:
@@ -2444,46 +2444,54 @@ static void ieee80211_set_csa(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	rcu_read_lock();
 	for (i = 0; i < IEEE80211_MAX_CSA_COUNTERS_NUM; ++i) {
-		u16 counter_offset_beacon =
-			sdata->csa_counter_offset_beacon[i];
-		u16 counter_offset_presp = sdata->csa_counter_offset_presp[i];
-
-		if (counter_offset_beacon) {
-			if (WARN_ON(counter_offset_beacon >= beacon_data_len))
-				return;
-
-			beacon_data[counter_offset_beacon] = count;
-		}
-
-		if (sdata->vif.type == NL80211_IFTYPE_AP &&
-		    counter_offset_presp) {
-			rcu_read_lock();
-			resp = rcu_dereference(sdata->u.ap.probe_resp);
+		resp = rcu_dereference(sdata->u.ap.probe_resp);
 
-			/* If nl80211 accepted the offset, this should
-			 * not happen.
-			 */
-			if (WARN_ON(!resp)) {
+		if (beacon->csa_counter_offsets[i]) {
+			if (WARN_ON_ONCE(beacon->csa_counter_offsets[i] >=
+					 beacon_data_len)) {
 				rcu_read_unlock();
 				return;
 			}
-			resp->data[counter_offset_presp] = count;
-			rcu_read_unlock();
+
+			beacon_data[beacon->csa_counter_offsets[i]] = count;
 		}
+
+		if (sdata->vif.type == NL80211_IFTYPE_AP && resp &&
+		    resp->csa_counter_offsets)
+			resp->data[resp->csa_counter_offsets[i]] = count;
 	}
+	rcu_read_unlock();
 }
 
 u8 ieee80211_csa_update_counter(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct beacon_data *beacon = NULL;
+	u8 count = 0;
 
-	sdata->csa_current_counter--;
+	rcu_read_lock();
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
+		beacon = rcu_dereference(sdata->u.ap.beacon);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		beacon = rcu_dereference(sdata->u.ibss.presp);
+	else if (ieee80211_vif_is_mesh(&sdata->vif))
+		beacon = rcu_dereference(sdata->u.mesh.beacon);
+
+	if (!beacon)
+		goto unlock;
+
+	beacon->csa_current_counter--;
 
 	/* the counter should never reach 0 */
-	WARN_ON(!sdata->csa_current_counter);
+	WARN_ON_ONCE(!beacon->csa_current_counter);
+	count = beacon->csa_current_counter;
 
-	return sdata->csa_current_counter;
+unlock:
+	rcu_read_unlock();
+	return count;
 }
 EXPORT_SYMBOL(ieee80211_csa_update_counter);
 
@@ -2493,7 +2501,6 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 	struct beacon_data *beacon = NULL;
 	u8 *beacon_data;
 	size_t beacon_data_len;
-	int counter_beacon = sdata->csa_counter_offset_beacon[0];
 	int ret = false;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -2531,10 +2538,10 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 		goto out;
 	}
 
-	if (WARN_ON(counter_beacon > beacon_data_len))
+	if (WARN_ON_ONCE(beacon->csa_counter_offsets[0] > beacon_data_len))
 		goto out;
 
-	if (beacon_data[counter_beacon] == 1)
+	if (beacon_data[beacon->csa_counter_offsets[0]] == 1)
 		ret = true;
  out:
 	rcu_read_unlock();
@@ -2550,6 +2557,7 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 		       bool is_template)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct beacon_data *beacon = NULL;
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
@@ -2571,8 +2579,8 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
 		struct ieee80211_if_ap *ap = &sdata->u.ap;
-		struct beacon_data *beacon = rcu_dereference(ap->beacon);
 
+		beacon = rcu_dereference(ap->beacon);
 		if (beacon) {
 			if (sdata->vif.csa_active) {
 				if (!is_template)
@@ -2615,34 +2623,34 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 		struct ieee80211_hdr *hdr;
-		struct beacon_data *presp = rcu_dereference(ifibss->presp);
 
-		if (!presp)
+		beacon = rcu_dereference(ifibss->presp);
+		if (!beacon)
 			goto out;
 
 		if (sdata->vif.csa_active) {
 			if (!is_template)
 				ieee80211_csa_update_counter(vif);
 
-			ieee80211_set_csa(sdata, presp);
+			ieee80211_set_csa(sdata, beacon);
 		}
 
-		skb = dev_alloc_skb(local->tx_headroom + presp->head_len +
+		skb = dev_alloc_skb(local->tx_headroom + beacon->head_len +
 				    local->hw.extra_beacon_tailroom);
 		if (!skb)
 			goto out;
 		skb_reserve(skb, local->tx_headroom);
-		memcpy(skb_put(skb, presp->head_len), presp->head,
-		       presp->head_len);
+		memcpy(skb_put(skb, beacon->head_len), beacon->head,
+		       beacon->head_len);
 
 		hdr = (struct ieee80211_hdr *) skb->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-		struct beacon_data *bcn = rcu_dereference(ifmsh->beacon);
 
-		if (!bcn)
+		beacon = rcu_dereference(ifmsh->beacon);
+		if (!beacon)
 			goto out;
 
 		if (sdata->vif.csa_active) {
@@ -2654,40 +2662,42 @@ __ieee80211_beacon_get(struct ieee80211_hw *hw,
 				 */
 				ieee80211_csa_update_counter(vif);
 
-			ieee80211_set_csa(sdata, bcn);
+			ieee80211_set_csa(sdata, beacon);
 		}
 
 		if (ifmsh->sync_ops)
-			ifmsh->sync_ops->adjust_tbtt(sdata, bcn);
+			ifmsh->sync_ops->adjust_tbtt(sdata, beacon);
 
 		skb = dev_alloc_skb(local->tx_headroom +
-				    bcn->head_len +
+				    beacon->head_len +
 				    256 + /* TIM IE */
-				    bcn->tail_len +
+				    beacon->tail_len +
 				    local->hw.extra_beacon_tailroom);
 		if (!skb)
 			goto out;
 		skb_reserve(skb, local->tx_headroom);
-		memcpy(skb_put(skb, bcn->head_len), bcn->head, bcn->head_len);
+		memcpy(skb_put(skb, beacon->head_len), beacon->head,
+		       beacon->head_len);
 		ieee80211_beacon_add_tim(sdata, &ifmsh->ps, skb, is_template);
 
 		if (offs) {
-			offs->tim_offset = bcn->head_len;
-			offs->tim_length = skb->len - bcn->head_len;
+			offs->tim_offset = beacon->head_len;
+			offs->tim_length = skb->len - beacon->head_len;
 		}
 
-		memcpy(skb_put(skb, bcn->tail_len), bcn->tail, bcn->tail_len);
+		memcpy(skb_put(skb, beacon->tail_len), beacon->tail,
+		       beacon->tail_len);
 	} else {
 		WARN_ON(1);
 		goto out;
 	}
 
 	/* CSA offsets */
-	if (offs) {
+	if (offs && beacon) {
 		int i;
 
 		for (i = 0; i < IEEE80211_MAX_CSA_COUNTERS_NUM; i++) {
-			u16 csa_off = sdata->csa_counter_offset_beacon[i];
+			u16 csa_off = beacon->csa_counter_offsets[i];
 
 			if (!csa_off)
 				continue;
-- 
1.8.5.3

