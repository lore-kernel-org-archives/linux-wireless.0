Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3CTNMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 09:12:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: ibss: use beacon_data struct for beacon and probe response
Date: Wed, 20 Mar 2013 14:12:11 +0100
Message-Id: <1363785131-909-2-git-send-email-johannes@sipsolutions.net> (sfid-20130320_141223_999839_6855ED7C)
In-Reply-To: <1363785131-909-1-git-send-email-johannes@sipsolutions.net>
References: <1363785131-909-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of having an SKB all the time, use a beacon_data struct
with just the information required. This also allows removing a
synchronize_rcu() and using kfree_rcu() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        | 131 ++++++++++++++++++++++-----------------------
 net/mac80211/ieee80211_i.h |   3 +-
 net/mac80211/tx.c          |   7 ++-
 3 files changed, 70 insertions(+), 71 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index bd02fac..5ab32e2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -44,7 +44,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	int rates, i;
-	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
@@ -52,6 +51,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	struct cfg80211_chan_def chandef;
+	struct beacon_data *presp;
+	int frame_len;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -72,13 +73,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 						 BSS_CHANGED_BEACON_ENABLED);
 	}
 
-	skb = ifibss->skb;
-	RCU_INIT_POINTER(ifibss->presp, NULL);
-	synchronize_rcu();
-	skb->data = skb->head;
-	skb->len = 0;
-	skb_reset_tail_pointer(skb);
-	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&ifibss->mtx));
+	rcu_assign_pointer(ifibss->presp, NULL);
+	if (presp)
+		kfree_rcu(presp, rcu_head);
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
@@ -101,19 +100,24 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sband = local->hw.wiphy->bands[chan->band];
 
-	/* build supported rates array */
-	pos = supp_rates;
-	for (i = 0; i < sband->n_bitrates; i++) {
-		int rate = sband->bitrates[i].bitrate;
-		u8 basic = 0;
-		if (basic_rates & BIT(i))
-			basic = 0x80;
-		*pos++ = basic | (u8) (rate / 5);
-	}
-
 	/* Build IBSS probe response */
-	mgmt = (void *) skb_put(skb, 24 + sizeof(mgmt->u.beacon));
-	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	frame_len = sizeof(struct ieee80211_hdr_3addr) +
+		    12 /* struct ieee80211_mgmt.u.beacon */ +
+		    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+		    2 + 8 /* max Supported Rates */ +
+		    3 /* max DS params */ +
+		    4 /* IBSS params */ +
+		    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+		    2 + sizeof(struct ieee80211_ht_cap) +
+		    2 + sizeof(struct ieee80211_ht_operation) +
+		    ifibss->ie_len;
+	presp = kzalloc(sizeof(*presp) + frame_len, GFP_KERNEL);
+	if (!presp)
+		return;
+
+	presp->head = (void *)(presp + 1);
+
+	mgmt = (void *) presp->head;
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_PROBE_RESP);
 	eth_broadcast_addr(mgmt->da);
@@ -123,27 +127,30 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.beacon.timestamp = cpu_to_le64(tsf);
 	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
 
-	pos = skb_put(skb, 2 + ifibss->ssid_len);
+	pos = (u8 *)mgmt + offsetof(struct ieee80211_mgmt, u.beacon.variable);
+
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = ifibss->ssid_len;
 	memcpy(pos, ifibss->ssid, ifibss->ssid_len);
+	pos += ifibss->ssid_len;
 
-	rates = sband->n_bitrates;
-	if (rates > 8)
-		rates = 8;
-	pos = skb_put(skb, 2 + rates);
+	rates = min_t(int, 8, sband->n_bitrates);
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos++ = rates;
-	memcpy(pos, supp_rates, rates);
+	for (i = 0; i < rates; i++) {
+		int rate = sband->bitrates[i].bitrate;
+		u8 basic = 0;
+		if (basic_rates & BIT(i))
+			basic = 0x80;
+		*pos++ = basic | (u8) (rate / 5);
+	}
 
 	if (sband->band == IEEE80211_BAND_2GHZ) {
-		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
 		*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
 	}
 
-	pos = skb_put(skb, 2 + 2);
 	*pos++ = WLAN_EID_IBSS_PARAMS;
 	*pos++ = 2;
 	/* FIX: set ATIM window based on scan results */
@@ -151,23 +158,25 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	*pos++ = 0;
 
 	if (sband->n_bitrates > 8) {
-		rates = sband->n_bitrates - 8;
-		pos = skb_put(skb, 2 + rates);
 		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = rates;
-		memcpy(pos, &supp_rates[8], rates);
+		*pos++ = sband->n_bitrates - 8;
+		for (i = 8; i < sband->n_bitrates; i++) {
+			int rate = sband->bitrates[i].bitrate;
+			u8 basic = 0;
+			if (basic_rates & BIT(i))
+				basic = 0x80;
+			*pos++ = basic | (u8) (rate / 5);
+		}
 	}
 
-	if (ifibss->ie_len)
-		memcpy(skb_put(skb, ifibss->ie_len),
-		       ifibss->ie, ifibss->ie_len);
+	if (ifibss->ie_len) {
+		memcpy(pos, ifibss->ie, ifibss->ie_len);
+		pos += ifibss->ie_len;
+	}
 
 	/* add HT capability and information IEs */
 	if (chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
 	    sband->ht_cap.ht_supported) {
-		pos = skb_put(skb, 4 +
-				   sizeof(struct ieee80211_ht_cap) +
-				   sizeof(struct ieee80211_ht_operation));
 		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
 						sband->ht_cap.cap);
 		/*
@@ -180,7 +189,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (local->hw.queues >= IEEE80211_NUM_ACS) {
-		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
 		*pos++ = 7; /* len */
 		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
@@ -192,7 +200,11 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		*pos++ = 0; /* U-APSD no in use */
 	}
 
-	rcu_assign_pointer(ifibss->presp, skb);
+	presp->head_len = pos - presp->head;
+	if (WARN_ON(presp->head_len > frame_len))
+		return;
+
+	rcu_assign_pointer(ifibss->presp, presp);
 
 	sdata->vif.bss_conf.enable_beacon = true;
 	sdata->vif.bss_conf.beacon_int = beacon_int;
@@ -230,7 +242,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
 	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan,
-					mgmt, skb->len, 0, GFP_KERNEL);
+					mgmt, presp->head_len, 0, GFP_KERNEL);
 	cfg80211_put_bss(local->hw.wiphy, bss);
 	netif_carrier_on(sdata->dev);
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
@@ -825,8 +837,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	int tx_last_beacon, len = req->len;
 	struct sk_buff *skb;
-	struct ieee80211_mgmt *resp;
-	struct sk_buff *presp;
+	struct beacon_data *presp;
 	u8 *pos, *end;
 
 	lockdep_assert_held(&ifibss->mtx);
@@ -867,13 +878,15 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* Reply with ProbeResp */
-	skb = skb_copy(presp, GFP_KERNEL);
+	skb = dev_alloc_skb(local->tx_headroom + presp->head_len);
 	if (!skb)
 		return;
 
-	resp = (struct ieee80211_mgmt *) skb->data;
-	memcpy(resp->da, mgmt->sa, ETH_ALEN);
-	ibss_dbg(sdata, "Sending ProbeResp to %pM\n", resp->da);
+	skb_reserve(skb, local->tx_headroom);
+	memcpy(skb_put(skb, presp->head_len), presp->head, presp->head_len);
+
+	memcpy(((struct ieee80211_mgmt *) skb->data)->da, mgmt->sa, ETH_ALEN);
+	ibss_dbg(sdata, "Sending ProbeResp to %pM\n", mgmt->sa);
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
@@ -1023,23 +1036,8 @@ void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
-	struct sk_buff *skb;
 	u32 changed = 0;
 
-	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    sizeof(struct ieee80211_hdr_3addr) +
-			    12 /* struct ieee80211_mgmt.u.beacon */ +
-			    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
-			    2 + 8 /* max Supported Rates */ +
-			    3 /* max DS params */ +
-			    4 /* IBSS params */ +
-			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
-			    2 + sizeof(struct ieee80211_ht_cap) +
-			    2 + sizeof(struct ieee80211_ht_operation) +
-			    params->ie_len);
-	if (!skb)
-		return -ENOMEM;
-
 	mutex_lock(&sdata->u.ibss.mtx);
 
 	if (params->bssid) {
@@ -1068,7 +1066,6 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			sdata->u.ibss.ie_len = params->ie_len;
 	}
 
-	sdata->u.ibss.skb = skb;
 	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
 	sdata->u.ibss.ibss_join_req = jiffies;
 
@@ -1104,13 +1101,13 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
-	struct sk_buff *skb;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	u16 capability;
 	int active_ibss;
 	struct sta_info *sta;
+	struct beacon_data *presp;
 
 	mutex_lock(&sdata->u.ibss.mtx);
 
@@ -1156,8 +1153,8 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 
 	/* remove beacon */
 	kfree(sdata->u.ibss.ie);
-	skb = rcu_dereference_protected(sdata->u.ibss.presp,
-					lockdep_is_held(&sdata->u.ibss.mtx));
+	presp = rcu_dereference_protected(ifibss->presp,
+					  lockdep_is_held(&sdata->u.ibss.mtx));
 	RCU_INIT_POINTER(sdata->u.ibss.presp, NULL);
 	sdata->vif.bss_conf.ibss_joined = false;
 	sdata->vif.bss_conf.ibss_creator = false;
@@ -1166,7 +1163,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_IBSS);
 	synchronize_rcu();
-	kfree_skb(skb);
+	kfree(presp);
 
 	skb_queue_purge(&sdata->skb_queue);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9f16963..6ad7e7d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -508,8 +508,7 @@ struct ieee80211_if_ibss {
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
-	struct sk_buff __rcu *presp;
-	struct sk_buff *skb;
+	struct beacon_data __rcu *presp;
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2a6ae80..4a83d8d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2442,14 +2442,17 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 		struct ieee80211_hdr *hdr;
-		struct sk_buff *presp = rcu_dereference(ifibss->presp);
+		struct beacon_data *presp = rcu_dereference(ifibss->presp);
 
 		if (!presp)
 			goto out;
 
-		skb = skb_copy(presp, GFP_ATOMIC);
+		skb = dev_alloc_skb(local->tx_headroom + presp->head_len);
 		if (!skb)
 			goto out;
+		skb_reserve(skb, local->tx_headroom);
+		memcpy(skb_put(skb, presp->head_len), presp->head,
+		       presp->head_len);
 
 		hdr = (struct ieee80211_hdr *) skb->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-- 
1.8.0

