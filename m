Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbZLWMXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:23:00 -0500
Message-Id: <20091223121616.737417760@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:15:39 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH next 10/18] mac80211: proper bss private data handling
References: <20091223121529.289129599@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 offers private data for each BSS struct,
which mac80211 uses. However, mac80211 uses internal
and external (cfg80211) BSS pointers interchangeably
and has a hack to put the cfg80211 bss struct into
the private struct.

Remove this hack, properly converting between the
pointers wherever necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c         |    2 -
 net/mac80211/ibss.c        |   45 +++++++++++++++++-------------
 net/mac80211/ieee80211_i.h |    7 +---
 net/mac80211/main.c        |    4 --
 net/mac80211/mlme.c        |   66 +++++++++++++++++++++++----------------------
 net/mac80211/scan.c        |   29 ++++++++++++-------
 net/mac80211/work.c        |    3 --
 7 files changed, 83 insertions(+), 73 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-12-23 13:11:23.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-12-23 13:11:23.000000000 +0100
@@ -71,9 +71,6 @@ struct ieee80211_fragment_entry {
 
 
 struct ieee80211_bss {
-	/* Yes, this is a hack */
-	struct cfg80211_bss cbss;
-
 	/* don't want to look up all the time */
 	size_t ssid_len;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
@@ -274,7 +271,7 @@ struct ieee80211_work {
 			bool privacy;
 		} probe_auth;
 		struct {
-			struct ieee80211_bss *bss;
+			struct cfg80211_bss *bss;
 			const u8 *supp_rates;
 			const u8 *ht_information_ie;
 			enum ieee80211_smps_mode smps;
@@ -317,7 +314,7 @@ struct ieee80211_if_managed {
 	int probe_send_count;
 
 	struct mutex mtx;
-	struct ieee80211_bss *associated;
+	struct cfg80211_bss *associated;
 
 	u8 bssid[ETH_ALEN];
 
--- wireless-testing.orig/net/mac80211/cfg.c	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2009-12-23 13:11:23.000000000 +0100
@@ -1343,7 +1343,7 @@ int __ieee80211_request_smps(struct ieee
 		return 0;
 	}
 
-	ap = sdata->u.mgd.associated->cbss.bssid;
+	ap = sdata->u.mgd.associated->bssid;
 
 	if (smps_mode == IEEE80211_SMPS_AUTOMATIC) {
 		if (sdata->u.mgd.powersave)
--- wireless-testing.orig/net/mac80211/ibss.c	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2009-12-23 13:11:23.000000000 +0100
@@ -187,15 +187,17 @@ static void __ieee80211_sta_join_ibss(st
 static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_bss *bss)
 {
+	struct cfg80211_bss *cbss =
+		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_supported_band *sband;
 	u32 basic_rates;
 	int i, j;
-	u16 beacon_int = bss->cbss.beacon_interval;
+	u16 beacon_int = cbss->beacon_interval;
 
 	if (beacon_int < 10)
 		beacon_int = 10;
 
-	sband = sdata->local->hw.wiphy->bands[bss->cbss.channel->band];
+	sband = sdata->local->hw.wiphy->bands[cbss->channel->band];
 
 	basic_rates = 0;
 
@@ -212,12 +214,12 @@ static void ieee80211_sta_join_ibss(stru
 		}
 	}
 
-	__ieee80211_sta_join_ibss(sdata, bss->cbss.bssid,
+	__ieee80211_sta_join_ibss(sdata, cbss->bssid,
 				  beacon_int,
-				  bss->cbss.channel,
+				  cbss->channel,
 				  basic_rates,
-				  bss->cbss.capability,
-				  bss->cbss.tsf);
+				  cbss->capability,
+				  cbss->tsf);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -229,6 +231,7 @@ static void ieee80211_rx_bss_info(struct
 {
 	struct ieee80211_local *local = sdata->local;
 	int freq;
+	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	struct sta_info *sta;
 	struct ieee80211_channel *channel;
@@ -283,8 +286,10 @@ static void ieee80211_rx_bss_info(struct
 	if (!bss)
 		return;
 
+	cbss = container_of((void *)bss, struct cfg80211_bss, priv);
+
 	/* was just updated in ieee80211_bss_info_update */
-	beacon_timestamp = bss->cbss.tsf;
+	beacon_timestamp = cbss->tsf;
 
 	/* check if we need to merge IBSS */
 
@@ -297,11 +302,11 @@ static void ieee80211_rx_bss_info(struct
 		goto put_bss;
 
 	/* not an IBSS */
-	if (!(bss->cbss.capability & WLAN_CAPABILITY_IBSS))
+	if (!(cbss->capability & WLAN_CAPABILITY_IBSS))
 		goto put_bss;
 
 	/* different channel */
-	if (bss->cbss.channel != local->oper_channel)
+	if (cbss->channel != local->oper_channel)
 		goto put_bss;
 
 	/* different SSID */
@@ -311,7 +316,7 @@ static void ieee80211_rx_bss_info(struct
 		goto put_bss;
 
 	/* same BSSID */
-	if (memcmp(bss->cbss.bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
+	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
 		goto put_bss;
 
 	if (rx_status->flag & RX_FLAG_TSFT) {
@@ -514,7 +519,7 @@ static void ieee80211_sta_find_ibss(stru
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_bss *bss;
+	struct cfg80211_bss *cbss;
 	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
 	int active_ibss;
@@ -538,21 +543,23 @@ static void ieee80211_sta_find_ibss(stru
 		chan = ifibss->channel;
 	if (!is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
-	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan, bssid,
-				       ifibss->ssid, ifibss->ssid_len,
-				       WLAN_CAPABILITY_IBSS |
-				       WLAN_CAPABILITY_PRIVACY,
-				       capability);
+	cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
+				ifibss->ssid, ifibss->ssid_len,
+				WLAN_CAPABILITY_IBSS | WLAN_CAPABILITY_PRIVACY,
+				capability);
+
+	if (cbss) {
+		struct ieee80211_bss *bss;
 
-	if (bss) {
+		bss = (void *)cbss->priv;
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 		printk(KERN_DEBUG "   sta_find_ibss: selected %pM current "
-		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
+		       "%pM\n", cbss->bssid, ifibss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
-		       sdata->name, bss->cbss.bssid);
+		       sdata->name, cbss->bssid);
 
 		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:11:22.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:23.000000000 +0100
@@ -330,7 +330,7 @@ static void ieee80211_chswitch_work(stru
 	ieee80211_hw_config(sdata->local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->cbss.channel = sdata->local->oper_channel;
+	ifmgd->associated->channel = sdata->local->oper_channel;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -357,6 +357,8 @@ void ieee80211_sta_process_chanswitch(st
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct ieee80211_bss *bss)
 {
+	struct cfg80211_bss *cbss =
+		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num);
@@ -390,7 +392,7 @@ void ieee80211_sta_process_chanswitch(st
 		mod_timer(&ifmgd->chswitch_timer,
 			  jiffies +
 			  msecs_to_jiffies(sw_elem->count *
-					   bss->cbss.beacon_interval));
+					   cbss->beacon_interval));
 	}
 }
 
@@ -670,23 +672,24 @@ static u32 ieee80211_handle_bss_capabili
 }
 
 static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_bss *bss,
+				     struct cfg80211_bss *cbss,
 				     u32 bss_info_changed)
 {
+	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct ieee80211_local *local = sdata->local;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
 	/* set timing information */
-	sdata->vif.bss_conf.beacon_int = bss->cbss.beacon_interval;
-	sdata->vif.bss_conf.timestamp = bss->cbss.tsf;
+	sdata->vif.bss_conf.beacon_int = cbss->beacon_interval;
+	sdata->vif.bss_conf.timestamp = cbss->tsf;
 	sdata->vif.bss_conf.dtim_period = bss->dtim_period;
 
 	bss_info_changed |= BSS_CHANGED_BEACON_INT;
 	bss_info_changed |= ieee80211_handle_bss_capability(sdata,
-		bss->cbss.capability, bss->has_erp_value, bss->erp_value);
+		cbss->capability, bss->has_erp_value, bss->erp_value);
 
-	sdata->u.mgd.associated = bss;
-	memcpy(sdata->u.mgd.bssid, bss->cbss.bssid, ETH_ALEN);
+	sdata->u.mgd.associated = cbss;
+	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
 
 	/* just to be sure */
 	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
@@ -745,7 +748,7 @@ static void ieee80211_set_disassoc(struc
 	if (WARN_ON(!ifmgd->associated))
 		return;
 
-	memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
 	ifmgd->associated = NULL;
 	memset(ifmgd->bssid, 0, ETH_ALEN);
@@ -841,8 +844,8 @@ static void ieee80211_mgd_probe_ap_send(
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
 
-	ssid = ieee80211_bss_get_ie(&ifmgd->associated->cbss, WLAN_EID_SSID);
-	ieee80211_send_probe_req(sdata, ifmgd->associated->cbss.bssid,
+	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+	ieee80211_send_probe_req(sdata, ifmgd->associated->bssid,
 				 ssid + 2, ssid[1], NULL, 0);
 
 	ifmgd->probe_send_count++;
@@ -936,7 +939,7 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 
 	ASSERT_MGD_MTX(ifmgd);
 
-	bssid = ifmgd->associated->cbss.bssid;
+	bssid = ifmgd->associated->bssid;
 
 	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
@@ -965,7 +968,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	if (WARN_ON(!ifmgd->associated))
 		return RX_MGMT_NONE;
 
-	if (WARN_ON(memcmp(ifmgd->associated->cbss.bssid, mgmt->sa, ETH_ALEN)))
+	if (WARN_ON(memcmp(ifmgd->associated->bssid, mgmt->sa, ETH_ALEN)))
 		return RX_MGMT_NONE;
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
@@ -987,7 +990,7 @@ static bool ieee80211_assoc_success(stru
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
-	struct ieee80211_bss *bss = wk->assoc.bss;
+	struct cfg80211_bss *cbss = wk->assoc.bss;
 	u8 *pos;
 	u32 rates, basic_rates;
 	u16 capab_info, aid;
@@ -1019,7 +1022,7 @@ static bool ieee80211_assoc_success(stru
 
 	ifmgd->aid = aid;
 
-	sta = sta_info_alloc(sdata, bss->cbss.bssid, GFP_KERNEL);
+	sta = sta_info_alloc(sdata, cbss->bssid, GFP_KERNEL);
 	if (!sta) {
 		printk(KERN_DEBUG "%s: failed to alloc STA entry for"
 		       " the AP\n", sdata->name);
@@ -1111,14 +1114,13 @@ static bool ieee80211_assoc_success(stru
 	    (sdata->local->hw.queues >= 4) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
-					       bss->cbss.bssid,
-					       ap_ht_cap_flags);
+					       cbss->bssid, ap_ht_cap_flags);
 
 	/* set AID and assoc capability,
 	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
 	bss_conf->assoc_capability = capab_info;
-	ieee80211_set_associated(sdata, bss, changed);
+	ieee80211_set_associated(sdata, cbss, changed);
 
 	/*
 	 * Start timer to probe the connection to the AP now.
@@ -1162,8 +1164,8 @@ static void ieee80211_rx_bss_info(struct
 		return;
 
 	if (elems->ch_switch_elem && (elems->ch_switch_elem_len == 3) &&
-	    (memcmp(mgmt->bssid, sdata->u.mgd.associated->cbss.bssid,
-							ETH_ALEN) == 0)) {
+	    (memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid,
+	    						ETH_ALEN) == 0)) {
 		struct ieee80211_channel_sw_ie *sw_elem =
 			(struct ieee80211_channel_sw_ie *)elems->ch_switch_elem;
 		ieee80211_sta_process_chanswitch(sdata, sw_elem, bss);
@@ -1197,7 +1199,7 @@ static void ieee80211_rx_mgmt_probe_resp
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 
 	if (ifmgd->associated &&
-	    memcmp(mgmt->bssid, ifmgd->associated->cbss.bssid, ETH_ALEN) == 0 &&
+	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0 &&
 	    ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL)) {
 		ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
@@ -1270,7 +1272,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (!ifmgd->associated)
 		return;
 
-	bssid = ifmgd->associated->cbss.bssid;
+	bssid = ifmgd->associated->bssid;
 
 	/*
 	 * And in theory even frames from a different AP we were just
@@ -1436,8 +1438,7 @@ static void ieee80211_sta_rx_queued_mgmt
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated &&
-	    memcmp(ifmgd->associated->cbss.bssid, mgmt->bssid,
-							ETH_ALEN) == 0) {
+	    memcmp(ifmgd->associated->bssid, mgmt->bssid, ETH_ALEN) == 0) {
 		switch (fc & IEEE80211_FCTL_STYPE) {
 		case IEEE80211_STYPE_BEACON:
 			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
@@ -1456,7 +1457,7 @@ static void ieee80211_sta_rx_queued_mgmt
 			/* XXX: differentiate, can only happen for CSA now! */
 			ieee80211_sta_process_chanswitch(sdata,
 					&mgmt->u.action.u.chan_switch.sw_elem,
-					ifmgd->associated);
+					(void *)ifmgd->associated->priv);
 			break;
 		}
 		mutex_unlock(&ifmgd->mtx);
@@ -1541,7 +1542,7 @@ static void ieee80211_sta_work(struct wo
 	    ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 
-		memcpy(bssid, ifmgd->associated->cbss.bssid, ETH_ALEN);
+		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 		if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(ifmgd, ifmgd->probe_timeout);
 
@@ -1848,6 +1849,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 			struct cfg80211_assoc_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_bss *bss = (void *)req->bss->priv;
 	struct ieee80211_work *wk;
 	const u8 *ssid;
 	int i;
@@ -1878,7 +1880,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	} else
 		wk->ie_len = 0;
 
-	wk->assoc.bss = (void *)req->bss;
+	wk->assoc.bss = req->bss;
 
 	memcpy(wk->filter_ta, req->bss->bssid, ETH_ALEN);
 
@@ -1901,9 +1903,9 @@ int ieee80211_mgd_assoc(struct ieee80211
 	 */
 	wk->assoc.use_11n = !(ifmgd->flags & IEEE80211_STA_DISABLE_11N);
 	wk->assoc.capability = req->bss->capability;
-	wk->assoc.wmm_used = wk->assoc.bss->wmm_used;
-	wk->assoc.supp_rates = wk->assoc.bss->supp_rates;
-	wk->assoc.supp_rates_len = wk->assoc.bss->supp_rates_len;
+	wk->assoc.wmm_used = bss->wmm_used;
+	wk->assoc.supp_rates = bss->supp_rates;
+	wk->assoc.supp_rates_len = bss->supp_rates_len;
 	wk->assoc.ht_information_ie =
 		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_INFORMATION);
 
@@ -1950,7 +1952,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated && &ifmgd->associated->cbss == req->bss) {
+	if (ifmgd->associated == req->bss) {
 		bssid = req->bss->bssid;
 		ieee80211_set_disassoc(sdata);
 		mutex_unlock(&ifmgd->mtx);
@@ -2012,7 +2014,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	 * to cfg80211 while that's in a locked section already
 	 * trying to tell us that the user wants to disconnect.
 	 */
-	if (&ifmgd->associated->cbss != req->bss) {
+	if (ifmgd->associated != req->bss) {
 		mutex_unlock(&ifmgd->mtx);
 		return -ENOLINK;
 	}
--- wireless-testing.orig/net/mac80211/scan.c	2009-12-23 13:11:21.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-12-23 13:11:23.000000000 +0100
@@ -29,16 +29,19 @@ struct ieee80211_bss *
 ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
-	return (void *)cfg80211_get_bss(local->hw.wiphy,
-					ieee80211_get_channel(local->hw.wiphy,
-							      freq),
-					bssid, ssid, ssid_len,
-					0, 0);
+	struct cfg80211_bss *cbss;
+
+	cbss = cfg80211_get_bss(local->hw.wiphy,
+				ieee80211_get_channel(local->hw.wiphy, freq),
+				bssid, ssid, ssid_len, 0, 0);
+	if (!cbss)
+		return NULL;
+	return (void *)cbss->priv;
 }
 
 static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 {
-	struct ieee80211_bss *bss = (void *)cbss;
+	struct ieee80211_bss *bss = (void *)cbss->priv;
 
 	kfree(bss_mesh_id(bss));
 	kfree(bss_mesh_cfg(bss));
@@ -47,7 +50,9 @@ static void ieee80211_rx_bss_free(struct
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss)
 {
-	cfg80211_put_bss((struct cfg80211_bss *)bss);
+	if (!bss)
+		return;
+	cfg80211_put_bss(container_of((void *)bss, struct cfg80211_bss, priv));
 }
 
 struct ieee80211_bss *
@@ -59,6 +64,7 @@ ieee80211_bss_info_update(struct ieee802
 			  struct ieee80211_channel *channel,
 			  bool beacon)
 {
+	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
 	int clen;
 	s32 signal = 0;
@@ -68,13 +74,14 @@ ieee80211_bss_info_update(struct ieee802
 	else if (local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)
 		signal = (rx_status->signal * 100) / local->hw.max_signal;
 
-	bss = (void *)cfg80211_inform_bss_frame(local->hw.wiphy, channel,
-						mgmt, len, signal, GFP_ATOMIC);
+	cbss = cfg80211_inform_bss_frame(local->hw.wiphy, channel,
+					 mgmt, len, signal, GFP_ATOMIC);
 
-	if (!bss)
+	if (!cbss)
 		return NULL;
 
-	bss->cbss.free_priv = ieee80211_rx_bss_free;
+	cbss->free_priv = ieee80211_rx_bss_free;
+	bss = (void *)cbss->priv;
 
 	/* save the ERP value so that it is available at association time */
 	if (elems->erp_info && elems->erp_info_len >= 1) {
--- wireless-testing.orig/net/mac80211/work.c	2009-12-23 13:11:23.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-23 13:11:23.000000000 +0100
@@ -517,8 +517,7 @@ ieee80211_associate(struct ieee80211_wor
 		 * bss struct for that AP.
 		 */
 		if (wk->assoc.bss)
-			cfg80211_unlink_bss(local->hw.wiphy,
-					    &wk->assoc.bss->cbss);
+			cfg80211_unlink_bss(local->hw.wiphy, wk->assoc.bss);
 
 		/*
 		 * We might have a pending scan which had no chance to run yet
--- wireless-testing.orig/net/mac80211/main.c	2009-12-23 13:11:21.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-12-23 13:11:23.000000000 +0100
@@ -359,9 +359,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			WIPHY_FLAG_4ADDR_STATION;
 	wiphy->privid = mac80211_wiphy_privid;
 
-	/* Yes, putting cfg80211_bss into ieee80211_bss is a hack */
-	wiphy->bss_priv_size = sizeof(struct ieee80211_bss) -
-			       sizeof(struct cfg80211_bss);
+	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
 


