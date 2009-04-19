Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbZDSTZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 15:25:48 -0400
Subject: [PATCH] mac80211: convert to cfg80211 IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 21:25:43 +0200
Message-Id: <1240169143.28138.17.camel@johannes.local> (sfid-20090419_212553_930385_70405464)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This converts mac80211 to the new cfg80211 IBSS API, the
wext handling functions are called where appropriate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Same as the RFC. Did some more testing in user-mode-linux with hwsim.
Might post the hwsim patch for IBSS but it's trivial and not good, but
was sufficient to test the config interface.

 net/mac80211/cfg.c         |   17 ++
 net/mac80211/ibss.c        |  353 +++++++++++++++++++++------------------------
 net/mac80211/ieee80211_i.h |   35 +---
 net/mac80211/iface.c       |   12 -
 net/mac80211/main.c        |    2 
 net/mac80211/scan.c        |    2 
 net/mac80211/sta_info.c    |   71 ---------
 net/mac80211/sta_info.h    |    3 
 net/mac80211/tx.c          |    6 
 net/mac80211/wext.c        |   63 +++-----
 10 files changed, 231 insertions(+), 333 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-19 17:51:58.000000000 +0200
@@ -323,14 +323,6 @@ struct ieee80211_if_managed {
 	size_t sme_auth_ie_len;
 };
 
-enum ieee80211_ibss_flags {
-	IEEE80211_IBSS_AUTO_CHANNEL_SEL		= BIT(0),
-	IEEE80211_IBSS_AUTO_BSSID_SEL		= BIT(1),
-	IEEE80211_IBSS_BSSID_SET		= BIT(2),
-	IEEE80211_IBSS_PREV_BSSID_SET		= BIT(3),
-	IEEE80211_IBSS_SSID_SET			= BIT(4),
-};
-
 enum ieee80211_ibss_request {
 	IEEE80211_IBSS_REQ_RUN	= 0,
 };
@@ -341,17 +333,20 @@ struct ieee80211_if_ibss {
 
 	struct sk_buff_head skb_queue;
 
-	u8 ssid[IEEE80211_MAX_SSID_LEN];
-	u8 ssid_len;
-
-	u32 flags;
+	unsigned long request;
+	unsigned long last_scan_completed;
+	bool fixed_bssid;
+	bool fixed_channel;
 
 	u8 bssid[ETH_ALEN];
-
-	unsigned long request;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len, ie_len;
+	u8 *ie;
+	struct ieee80211_channel *channel;
 
 	unsigned long ibss_join_req;
-	struct sk_buff *probe_resp; /* ProbeResp template for IBSS */
+	/* probe response/beacon for IBSS */
+	struct sk_buff *presp, *skb;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,
@@ -630,8 +625,6 @@ struct ieee80211_local {
 	spinlock_t sta_lock;
 	unsigned long num_sta;
 	struct list_head sta_list;
-	struct list_head sta_flush_list;
-	struct work_struct sta_flush_work;
 	struct sta_info *sta_hash[STA_HASH_SIZE];
 	struct timer_list sta_cleanup;
 
@@ -681,7 +674,6 @@ struct ieee80211_local {
 	int scan_ies_len;
 
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
-	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type oper_channel_type;
@@ -946,10 +938,6 @@ int ieee80211_max_network_latency(struct
 				  unsigned long data, void *dummy);
 
 /* IBSS code */
-int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata);
-int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
-int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
-int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid);
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result
@@ -957,6 +945,9 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 		       struct ieee80211_rx_status *rx_status);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates);
+int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
+			struct cfg80211_ibss_params *params);
+int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
--- wireless-testing.orig/net/mac80211/wext.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/wext.c	2009-04-19 17:31:31.000000000 +0200
@@ -149,17 +149,14 @@ static int ieee80211_ioctl_siwfreq(struc
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		sdata->u.ibss.flags &= ~IEEE80211_IBSS_AUTO_CHANNEL_SEL;
+		return cfg80211_ibss_wext_siwfreq(dev, info, freq, extra);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_CHANNEL_SEL;
 
 	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
 	if (freq->e == 0) {
 		if (freq->m < 0) {
-			if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-				sdata->u.ibss.flags |=
-					IEEE80211_IBSS_AUTO_CHANNEL_SEL;
-			else if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			if (sdata->vif.type == NL80211_IFTYPE_STATION)
 				sdata->u.mgd.flags |=
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
@@ -183,6 +180,10 @@ static int ieee80211_ioctl_giwfreq(struc
 				   struct iw_freq *freq, char *extra)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return cfg80211_ibss_wext_giwfreq(dev, info, freq, extra);
 
 	freq->m = local->hw.conf.channel->center_freq;
 	freq->e = 6;
@@ -195,15 +196,17 @@ static int ieee80211_ioctl_siwessid(stru
 				    struct iw_request_info *info,
 				    struct iw_point *data, char *ssid)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	size_t len = data->length;
 	int ret;
 
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return cfg80211_ibss_wext_siwessid(dev, info, data, ssid);
+
 	/* iwconfig uses nul termination in SSID.. */
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		if (data->flags)
 			sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_SSID_SEL;
@@ -217,8 +220,7 @@ static int ieee80211_ioctl_siwessid(stru
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		return ieee80211_ibss_set_ssid(sdata, ssid, len);
+	}
 
 	return -EOPNOTSUPP;
 }
@@ -229,9 +231,13 @@ static int ieee80211_ioctl_giwessid(stru
 				    struct iw_point *data, char *ssid)
 {
 	size_t len;
-
 	struct ieee80211_sub_if_data *sdata;
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
+
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int res = ieee80211_sta_get_ssid(sdata, ssid, &len);
 		if (res == 0) {
@@ -240,14 +246,6 @@ static int ieee80211_ioctl_giwessid(stru
 		} else
 			data->flags = 0;
 		return res;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		int res = ieee80211_ibss_get_ssid(sdata, ssid, &len);
-		if (res == 0) {
-			data->length = len;
-			data->flags = 1;
-		} else
-			data->flags = 0;
-		return res;
 	}
 
 	return -EOPNOTSUPP;
@@ -258,9 +256,11 @@ static int ieee80211_ioctl_siwap(struct 
 				 struct iw_request_info *info,
 				 struct sockaddr *ap_addr, char *extra)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return cfg80211_ibss_wext_siwap(dev, info, ap_addr, extra);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		int ret;
 
@@ -277,16 +277,6 @@ static int ieee80211_ioctl_siwap(struct 
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		if (is_zero_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.ibss.flags |= IEEE80211_IBSS_AUTO_BSSID_SEL |
-					       IEEE80211_IBSS_AUTO_CHANNEL_SEL;
-		else if (is_broadcast_ether_addr((u8 *) &ap_addr->sa_data))
-			sdata->u.ibss.flags |= IEEE80211_IBSS_AUTO_BSSID_SEL;
-		else
-			sdata->u.ibss.flags &= ~IEEE80211_IBSS_AUTO_BSSID_SEL;
-
-		return ieee80211_ibss_set_bssid(sdata, (u8 *) &ap_addr->sa_data);
 	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		/*
 		 * If it is necessary to update the WDS peer address
@@ -312,9 +302,11 @@ static int ieee80211_ioctl_giwap(struct 
 				 struct iw_request_info *info,
 				 struct sockaddr *ap_addr, char *extra)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		return cfg80211_ibss_wext_giwap(dev, info, ap_addr, extra);
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		if (sdata->u.mgd.state == IEEE80211_STA_MLME_ASSOCIATED) {
 			ap_addr->sa_family = ARPHRD_ETHER;
@@ -322,13 +314,6 @@ static int ieee80211_ioctl_giwap(struct 
 		} else
 			memset(&ap_addr->sa_data, 0, ETH_ALEN);
 		return 0;
-	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		if (sdata->u.ibss.state == IEEE80211_IBSS_MLME_JOINED) {
-			ap_addr->sa_family = ARPHRD_ETHER;
-			memcpy(&ap_addr->sa_data, sdata->u.ibss.bssid, ETH_ALEN);
-		} else
-			memset(&ap_addr->sa_data, 0, ETH_ALEN);
-		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {
 		ap_addr->sa_family = ARPHRD_ETHER;
 		memcpy(&ap_addr->sa_data, sdata->u.wds.remote_addr, ETH_ALEN);
--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-19 17:51:58.000000000 +0200
@@ -59,74 +59,59 @@ static void ieee80211_rx_mgmt_auth_ibss(
 				    sdata->u.ibss.bssid, 0);
 }
 
-static int __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				     const u8 *bssid, const int beacon_int,
-				     const int freq,
-				     const size_t supp_rates_len,
-				     const u8 *supp_rates,
-				     const u16 capability, u64 tsf)
+static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				      const u8 *bssid, const int beacon_int,
+				      struct ieee80211_channel *chan,
+				      const size_t supp_rates_len,
+				      const u8 *supp_rates,
+				      const u16 capability, u64 tsf)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	int res = 0, rates, i, j;
+	int rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
 	struct ieee80211_supported_band *sband;
-	union iwreq_data wrqu;
 
 	if (local->ops->reset_tsf) {
 		/* Reset own TSF to allow time synchronization work. */
 		local->ops->reset_tsf(local_to_hw(local));
 	}
 
-	if ((ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET) &&
-	   memcmp(ifibss->bssid, bssid, ETH_ALEN) == 0)
-		return res;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for probe "
-		       "response\n", sdata->dev->name);
-		return -ENOMEM;
-	}
+	skb = ifibss->skb;
+	rcu_assign_pointer(ifibss->presp, NULL);
+	synchronize_rcu();
+	skb->data = skb->head;
+	skb->len = 0;
+	skb_reset_tail_pointer(skb);
+	skb_reserve(skb, sdata->local->hw.extra_tx_headroom);
 
-	if (!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET)) {
-		/* Remove possible STA entries from other IBSS networks. */
-		sta_info_flush_delayed(sdata);
-	}
+	if (memcmp(ifibss->bssid, bssid, ETH_ALEN))
+		sta_info_flush(sdata->local, sdata);
 
 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
-	res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-	if (res)
-		return res;
 
 	local->hw.conf.beacon_int = beacon_int >= 10 ? beacon_int : 10;
 
-	sdata->drop_unencrypted = capability &
-		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
+	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_freq(sdata, freq);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
 
-	if (res)
-		return res;
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	local->oper_channel = chan;
+	local->oper_channel_type = NL80211_CHAN_NO_HT;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	sband = local->hw.wiphy->bands[chan->band];
 
 	/* Build IBSS probe response */
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	mgmt = (void *) skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_PROBE_RESP);
 	memset(mgmt->da, 0xff, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
-	mgmt->u.beacon.beacon_int =
-		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.beacon_int = cpu_to_le16(local->hw.conf.beacon_int);
 	mgmt->u.beacon.timestamp = cpu_to_le64(tsf);
 	mgmt->u.beacon.capab_info = cpu_to_le16(capability);
 
@@ -147,7 +132,7 @@ static int __ieee80211_sta_join_ibss(str
 		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(freq);
+		*pos++ = ieee80211_frequency_to_channel(chan->center_freq);
 	}
 
 	pos = skb_put(skb, 2 + 2);
@@ -165,12 +150,15 @@ static int __ieee80211_sta_join_ibss(str
 		memcpy(pos, &supp_rates[8], rates);
 	}
 
-	ifibss->probe_resp = skb;
+	if (ifibss->ie_len)
+		memcpy(skb_put(skb, ifibss->ie_len),
+		       ifibss->ie, ifibss->ie_len);
+
+	rcu_assign_pointer(ifibss->presp, skb);
 
 	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON |
 				   IEEE80211_IFCC_BEACON_ENABLED);
 
-
 	rates = 0;
 	for (i = 0; i < supp_rates_len; i++) {
 		int bitrate = (supp_rates[i] & 0x7f) * 5;
@@ -181,27 +169,24 @@ static int __ieee80211_sta_join_ibss(str
 
 	ieee80211_sta_def_wmm_params(sdata, supp_rates_len, supp_rates);
 
-	ifibss->flags |= IEEE80211_IBSS_PREV_BSSID_SET;
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
-	mod_timer(&ifibss->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
-
-	return res;
-}
+	mod_timer(&ifibss->timer,
+		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_bss *bss)
-{
-	return __ieee80211_sta_join_ibss(sdata,
-					 bss->cbss.bssid,
-					 bss->cbss.beacon_interval,
-					 bss->cbss.channel->center_freq,
-					 bss->supp_rates_len, bss->supp_rates,
-					 bss->cbss.capability,
-					 bss->cbss.tsf);
+	cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
+				  mgmt, skb->len, 0, GFP_KERNEL);
+	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
+}
+
+static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_bss *bss)
+{
+	__ieee80211_sta_join_ibss(sdata, bss->cbss.bssid,
+				  bss->cbss.beacon_interval,
+				  bss->cbss.channel,
+				  bss->supp_rates_len, bss->supp_rates,
+				  bss->cbss.capability,
+				  bss->cbss.tsf);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -277,7 +262,7 @@ static void ieee80211_rx_bss_info(struct
 		goto put_bss;
 
 	/* we use a fixed BSSID */
-	if (sdata->u.ibss.flags & IEEE80211_IBSS_BSSID_SET)
+	if (sdata->u.ibss.bssid)
 		goto put_bss;
 
 	/* not an IBSS */
@@ -369,13 +354,14 @@ struct sta_info *ieee80211_ibss_add_sta(
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
 
-	/* TODO: Could consider removing the least recently used entry and
-	 * allow new one to be added. */
+	/*
+	 * XXX: Consider removing the least recently used entry and
+	 * 	allow new one to be added.
+	 */
 	if (local->num_sta >= IEEE80211_IBSS_MAX_STA_ENTRIES) {
-		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: No room for a new IBSS STA "
-			       "entry %pM\n", sdata->dev->name, addr);
-		}
+		if (net_ratelimit())
+			printk(KERN_DEBUG "%s: No room for a new IBSS STA entry %pM\n",
+			       sdata->dev->name, addr);
 		return NULL;
 	}
 
@@ -432,14 +418,15 @@ static void ieee80211_sta_merge_ibss(str
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	mod_timer(&ifibss->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
+	mod_timer(&ifibss->timer,
+		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
 	ieee80211_sta_expire(sdata, IEEE80211_IBSS_INACTIVITY_LIMIT);
+
 	if (ieee80211_sta_active_ibss(sdata))
 		return;
 
-	if ((ifibss->flags & IEEE80211_IBSS_BSSID_SET) &&
-	    (!(ifibss->flags & IEEE80211_IBSS_AUTO_CHANNEL_SEL)))
+	if (ifibss->fixed_channel)
 		return;
 
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
@@ -455,7 +442,7 @@ static void ieee80211_sta_merge_ibss(str
 	ieee80211_request_scan(sdata, &sdata->local->int_scan_req);
 }
 
-static int ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -466,7 +453,7 @@ static int ieee80211_sta_create_ibss(str
 	u16 capability;
 	int i;
 
-	if (ifibss->flags & IEEE80211_IBSS_BSSID_SET) {
+	if (ifibss->fixed_bssid) {
 		memcpy(bssid, ifibss->bssid, ETH_ALEN);
 	} else {
 		/* Generate random, not broadcast, locally administered BSSID. Mix in
@@ -482,7 +469,7 @@ static int ieee80211_sta_create_ibss(str
 	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
 	       sdata->dev->name, bssid);
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[ifibss->channel->band];
 
 	if (local->hw.conf.beacon_int == 0)
 		local->hw.conf.beacon_int = 100;
@@ -500,24 +487,20 @@ static int ieee80211_sta_create_ibss(str
 		*pos++ = (u8) (rate / 5);
 	}
 
-	return __ieee80211_sta_join_ibss(sdata,
-					 bssid, local->hw.conf.beacon_int,
-					 local->hw.conf.channel->center_freq,
-					 sband->n_bitrates, supp_rates,
-					 capability, 0);
+	__ieee80211_sta_join_ibss(sdata, bssid, local->hw.conf.beacon_int,
+				  ifibss->channel, sband->n_bitrates,
+				  supp_rates, capability, 0);
 }
 
-static int ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_bss *bss;
+	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
 	int active_ibss;
 
-	if (ifibss->ssid_len == 0)
-		return -EINVAL;
-
 	active_ibss = ieee80211_sta_active_ibss(sdata);
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 	printk(KERN_DEBUG "%s: sta_find_ibss (active_ibss=%d)\n",
@@ -525,11 +508,15 @@ static int ieee80211_sta_find_ibss(struc
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
 	if (active_ibss)
-		return 0;
+		return;
 
-	if (ifibss->flags & IEEE80211_IBSS_BSSID_SET)
+	if (ifibss->fixed_bssid)
+		bssid = ifibss->bssid;
+	if (ifibss->fixed_channel)
+		chan = ifibss->channel;
+	if (!is_zero_ether_addr(ifibss->bssid))
 		bssid = ifibss->bssid;
-	bss = (void *)cfg80211_get_bss(local->hw.wiphy, NULL, bssid,
+	bss = (void *)cfg80211_get_bss(local->hw.wiphy, chan, bssid,
 				       ifibss->ssid, ifibss->ssid_len,
 				       WLAN_CAPABILITY_IBSS,
 				       WLAN_CAPABILITY_IBSS);
@@ -540,18 +527,14 @@ static int ieee80211_sta_find_ibss(struc
 		       "%pM\n", bss->cbss.bssid, ifibss->bssid);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (bss &&
-	    (!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET) ||
-	     memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN))) {
-		int ret;
-
+	if (bss && memcmp(ifibss->bssid, bss->cbss.bssid, ETH_ALEN)) {
 		printk(KERN_DEBUG "%s: Selected IBSS BSSID %pM"
 		       " based on configured SSID\n",
 		       sdata->dev->name, bss->cbss.bssid);
 
-		ret = ieee80211_sta_join_ibss(sdata, bss);
+		ieee80211_sta_join_ibss(sdata, bss);
 		ieee80211_rx_bss_put(local, bss);
-		return ret;
+		return;
 	} else if (bss)
 		ieee80211_rx_bss_put(local, bss);
 
@@ -562,29 +545,31 @@ static int ieee80211_sta_find_ibss(struc
 	/* Selected IBSS not found in current scan results - try to scan */
 	if (ifibss->state == IEEE80211_IBSS_MLME_JOINED &&
 	    !ieee80211_sta_active_ibss(sdata)) {
-		mod_timer(&ifibss->timer, jiffies +
-					  IEEE80211_IBSS_MERGE_INTERVAL);
-	} else if (time_after(jiffies, local->last_scan_completed +
+		mod_timer(&ifibss->timer,
+			  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
+	} else if (time_after(jiffies, ifibss->last_scan_completed +
 					IEEE80211_SCAN_INTERVAL)) {
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->dev->name);
 
 		/* XXX maybe racy? */
 		if (local->scan_req)
-			return -EBUSY;
+			return;
 
 		memcpy(local->int_scan_req.ssids[0].ssid,
 		       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
-		local->int_scan_req.ssids[0].ssid_len = ifibss->ssid_len;
-		return ieee80211_request_scan(sdata, &local->int_scan_req);
+		local->int_scan_req.ssids[0].ssid_len =
+			ifibss->ssid_len;
+		ieee80211_request_scan(sdata, &local->int_scan_req);
 	} else if (ifibss->state != IEEE80211_IBSS_MLME_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
 		if (time_after(jiffies, ifibss->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if (!(local->oper_channel->flags &
-						IEEE80211_CHAN_NO_IBSS))
-				return ieee80211_sta_create_ibss(sdata);
+			if (!(local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
+				ieee80211_sta_create_ibss(sdata);
+				return;
+			}
 			printk(KERN_DEBUG "%s: IBSS not allowed on"
 			       " %d MHz\n", sdata->dev->name,
 			       local->hw.conf.channel->center_freq);
@@ -595,11 +580,9 @@ static int ieee80211_sta_find_ibss(struc
 		}
 
 		ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
-		mod_timer(&ifibss->timer, jiffies + interval);
-		return 0;
+		mod_timer(&ifibss->timer,
+			  round_jiffies(jiffies + interval));
 	}
-
-	return 0;
 }
 
 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
@@ -614,7 +597,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	u8 *pos, *end;
 
 	if (ifibss->state != IEEE80211_IBSS_MLME_JOINED ||
-	    len < 24 + 2 || !ifibss->probe_resp)
+	    len < 24 + 2 || !ifibss->presp)
 		return;
 
 	if (local->ops->tx_last_beacon)
@@ -649,13 +632,13 @@ static void ieee80211_rx_mgmt_probe_req(
 	}
 	if (pos[1] != 0 &&
 	    (pos[1] != ifibss->ssid_len ||
-	     memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len) != 0)) {
+	     !memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len))) {
 		/* Ignore ProbeReq for foreign SSID */
 		return;
 	}
 
 	/* Reply with ProbeResp */
-	skb = skb_copy(ifibss->probe_resp, GFP_KERNEL);
+	skb = skb_copy(ifibss->presp, GFP_KERNEL);
 	if (!skb)
 		return;
 
@@ -794,89 +777,21 @@ void ieee80211_ibss_setup_sdata(struct i
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 	skb_queue_head_init(&ifibss->skb_queue);
-
-	ifibss->flags |= IEEE80211_IBSS_AUTO_BSSID_SEL |
-			IEEE80211_IBSS_AUTO_CHANNEL_SEL;
-}
-
-int ieee80211_ibss_commit(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-	ifibss->flags &= ~IEEE80211_IBSS_PREV_BSSID_SET;
-
-	if (ifibss->ssid_len)
-		ifibss->flags |= IEEE80211_IBSS_SSID_SET;
-	else
-		ifibss->flags &= ~IEEE80211_IBSS_SSID_SET;
-
-	ifibss->ibss_join_req = jiffies;
-	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
-	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-
-	return 0;
-}
-
-int ieee80211_ibss_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-	if (len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
-
-	if (ifibss->ssid_len != len || memcmp(ifibss->ssid, ssid, len) != 0) {
-		memset(ifibss->ssid, 0, sizeof(ifibss->ssid));
-		memcpy(ifibss->ssid, ssid, len);
-		ifibss->ssid_len = len;
-	}
-
-	return ieee80211_ibss_commit(sdata);
-}
-
-int ieee80211_ibss_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-	memcpy(ssid, ifibss->ssid, ifibss->ssid_len);
-	*len = ifibss->ssid_len;
-
-	return 0;
-}
-
-int ieee80211_ibss_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
-{
-	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-
-	if (is_valid_ether_addr(bssid)) {
-		memcpy(ifibss->bssid, bssid, ETH_ALEN);
-		ifibss->flags |= IEEE80211_IBSS_BSSID_SET;
-	} else {
-		memset(ifibss->bssid, 0, ETH_ALEN);
-		ifibss->flags &= ~IEEE80211_IBSS_BSSID_SET;
-	}
-
-	if (netif_running(sdata->dev)) {
-		if (ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID)) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-		}
-	}
-
-	return ieee80211_ibss_commit(sdata);
 }
 
 /* scan finished notification */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_if_ibss *ifibss;
+	struct ieee80211_sub_if_data *sdata;
 
-	if (sdata && sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-		ifibss = &sdata->u.ibss;
-		if ((!(ifibss->flags & IEEE80211_IBSS_PREV_BSSID_SET)) ||
-		    !ieee80211_sta_active_ibss(sdata))
-			ieee80211_sta_find_ibss(sdata);
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
+			continue;
+		sdata->u.ibss.last_scan_completed = jiffies;
+		ieee80211_sta_find_ibss(sdata);
 	}
+	rcu_read_unlock();
 }
 
 ieee80211_rx_result
@@ -906,3 +821,71 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_
 
 	return RX_DROP_MONITOR;
 }
+
+int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
+			struct cfg80211_ibss_params *params)
+{
+	struct sk_buff *skb;
+
+	memcpy(sdata->u.ibss.ssid, params->ssid, IEEE80211_MAX_SSID_LEN);
+	sdata->u.ibss.ssid_len = params->ssid_len;
+
+	if (params->bssid) {
+		memcpy(sdata->u.ibss.bssid, params->bssid, ETH_ALEN);
+		sdata->u.ibss.fixed_bssid = true;
+	} else
+		sdata->u.ibss.fixed_bssid = false;
+
+	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.fixed_channel = params->channel_fixed;
+
+	if (params->ie) {
+		sdata->u.ibss.ie = kmemdup(params->ie, params->ie_len,
+					   GFP_KERNEL);
+		if (sdata->u.ibss.ie)
+			sdata->u.ibss.ie_len = params->ie_len;
+	}
+
+	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
+			    36 /* bitrates */ +
+			    34 /* SSID */ +
+			    3  /* DS params */ +
+			    4  /* IBSS params */ +
+			    params->ie_len);
+	if (!skb)
+		return -ENOMEM;
+
+	sdata->u.ibss.skb = skb;
+	sdata->u.ibss.state = IEEE80211_IBSS_MLME_SEARCH;
+	sdata->u.ibss.ibss_join_req = jiffies;
+
+	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
+	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
+
+	return 0;
+}
+
+int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
+{
+	struct sk_buff *skb;
+
+	del_timer_sync(&sdata->u.ibss.timer);
+	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
+	cancel_work_sync(&sdata->u.ibss.work);
+	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
+
+	sta_info_flush(sdata->local, sdata);
+
+	/* remove beacon */
+	kfree(sdata->u.ibss.ie);
+	skb = sdata->u.ibss.presp;
+	rcu_assign_pointer(sdata->u.ibss.presp, NULL);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON_ENABLED);
+	synchronize_rcu();
+	kfree_skb(skb);
+
+	skb_queue_purge(&sdata->u.ibss.skb_queue);
+	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
+
+	return 0;
+}
--- wireless-testing.orig/net/mac80211/iface.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-04-19 17:31:31.000000000 +0200
@@ -235,11 +235,7 @@ static int ieee80211_open(struct net_dev
 		netif_addr_unlock_bh(local->mdev);
 		break;
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_ADHOC:
-		if (sdata->vif.type == NL80211_IFTYPE_STATION)
-			sdata->u.mgd.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
-		else
-			sdata->u.ibss.flags &= ~IEEE80211_IBSS_PREV_BSSID_SET;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		/* fall through */
 	default:
 		conf.vif = &sdata->vif;
@@ -327,8 +323,6 @@ static int ieee80211_open(struct net_dev
 	 */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
-	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
-		queue_work(local->hw.workqueue, &sdata->u.ibss.work);
 
 	netif_tx_start_all_queues(dev);
 
@@ -499,7 +493,6 @@ static int ieee80211_stop(struct net_dev
 		/* fall through */
 	case NL80211_IFTYPE_ADHOC:
 		if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
-			memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
 			del_timer_sync(&sdata->u.ibss.timer);
 			cancel_work_sync(&sdata->u.ibss.work);
 			synchronize_rcu();
@@ -653,7 +646,8 @@ static void ieee80211_teardown_sdata(str
 			mesh_rmc_free(sdata);
 		break;
 	case NL80211_IFTYPE_ADHOC:
-		kfree_skb(sdata->u.ibss.probe_resp);
+		if (WARN_ON(sdata->u.ibss.presp))
+			kfree_skb(sdata->u.ibss.presp);
 		break;
 	case NL80211_IFTYPE_STATION:
 		kfree(sdata->u.mgd.extra_ie);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-04-19 17:31:31.000000000 +0200
@@ -1286,6 +1286,21 @@ static int ieee80211_disassoc(struct wip
 	return ieee80211_sta_disassociate(sdata, req->reason_code);
 }
 
+static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_ibss_params *params)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return ieee80211_ibss_join(sdata, params);
+}
+
+static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return ieee80211_ibss_leave(sdata);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -1322,4 +1337,6 @@ struct cfg80211_ops mac80211_config_ops 
 	.assoc = ieee80211_assoc,
 	.deauth = ieee80211_deauth,
 	.disassoc = ieee80211_disassoc,
+	.join_ibss = ieee80211_join_ibss,
+	.leave_ibss = ieee80211_leave_ibss,
 };
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2009-04-19 17:31:31.000000000 +0200
@@ -686,41 +686,10 @@ static void sta_info_debugfs_add_work(st
 }
 #endif
 
-static void __ieee80211_run_pending_flush(struct ieee80211_local *local)
-{
-	struct sta_info *sta;
-	unsigned long flags;
-
-	ASSERT_RTNL();
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	while (!list_empty(&local->sta_flush_list)) {
-		sta = list_first_entry(&local->sta_flush_list,
-				       struct sta_info, list);
-		list_del(&sta->list);
-		spin_unlock_irqrestore(&local->sta_lock, flags);
-		sta_info_destroy(sta);
-		spin_lock_irqsave(&local->sta_lock, flags);
-	}
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-}
-
-static void ieee80211_sta_flush_work(struct work_struct *work)
-{
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, sta_flush_work);
-
-	rtnl_lock();
-	__ieee80211_run_pending_flush(local);
-	rtnl_unlock();
-}
-
 void sta_info_init(struct ieee80211_local *local)
 {
 	spin_lock_init(&local->sta_lock);
 	INIT_LIST_HEAD(&local->sta_list);
-	INIT_LIST_HEAD(&local->sta_flush_list);
-	INIT_WORK(&local->sta_flush_work, ieee80211_sta_flush_work);
 
 	setup_timer(&local->sta_cleanup, sta_info_cleanup,
 		    (unsigned long)local);
@@ -741,7 +710,6 @@ int sta_info_start(struct ieee80211_loca
 void sta_info_stop(struct ieee80211_local *local)
 {
 	del_timer(&local->sta_cleanup);
-	cancel_work_sync(&local->sta_flush_work);
 #ifdef CONFIG_MAC80211_DEBUGFS
 	/*
 	 * Make sure the debugfs adding work isn't pending after this
@@ -752,10 +720,7 @@ void sta_info_stop(struct ieee80211_loca
 	cancel_work_sync(&local->sta_debugfs_add);
 #endif
 
-	rtnl_lock();
 	sta_info_flush(local, NULL);
-	__ieee80211_run_pending_flush(local);
-	rtnl_unlock();
 }
 
 /**
@@ -767,7 +732,7 @@ void sta_info_stop(struct ieee80211_loca
  * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
  */
 int sta_info_flush(struct ieee80211_local *local,
-		    struct ieee80211_sub_if_data *sdata)
+		   struct ieee80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
 	LIST_HEAD(tmp_list);
@@ -775,7 +740,6 @@ int sta_info_flush(struct ieee80211_loca
 	unsigned long flags;
 
 	might_sleep();
-	ASSERT_RTNL();
 
 	spin_lock_irqsave(&local->sta_lock, flags);
 	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
@@ -795,39 +759,6 @@ int sta_info_flush(struct ieee80211_loca
 	return ret;
 }
 
-/**
- * sta_info_flush_delayed - flush matching STA entries from the STA table
- *
- * This function unlinks all stations for a given interface and queues
- * them for freeing. Note that the workqueue function scheduled here has
- * to run before any new keys can be added to the system to avoid set_key()
- * callback ordering issues.
- *
- * @sdata: the interface
- */
-void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sta_info *sta, *tmp;
-	unsigned long flags;
-	bool work = false;
-
-	spin_lock_irqsave(&local->sta_lock, flags);
-	list_for_each_entry_safe(sta, tmp, &local->sta_list, list) {
-		if (sdata == sta->sdata) {
-			__sta_info_unlink(&sta);
-			if (sta) {
-				list_add_tail(&sta->list,
-					      &local->sta_flush_list);
-				work = true;
-			}
-		}
-	}
-	if (work)
-		schedule_work(&local->sta_flush_work);
-	spin_unlock_irqrestore(&local->sta_lock, flags);
-}
-
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time)
 {
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2009-04-19 17:31:31.000000000 +0200
@@ -442,8 +442,7 @@ void sta_info_init(struct ieee80211_loca
 int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
 int sta_info_flush(struct ieee80211_local *local,
-		    struct ieee80211_sub_if_data *sdata);
-void sta_info_flush_delayed(struct ieee80211_sub_if_data *sdata);
+		   struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
--- wireless-testing.orig/net/mac80211/main.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-19 17:31:31.000000000 +0200
@@ -209,7 +209,7 @@ int ieee80211_if_config(struct ieee80211
 					!!rcu_dereference(sdata->u.ap.beacon);
 				break;
 			case NL80211_IFTYPE_ADHOC:
-				conf.enable_beacon = !!sdata->u.ibss.probe_resp;
+				conf.enable_beacon = !!sdata->u.ibss.presp;
 				break;
 			case NL80211_IFTYPE_MESH_POINT:
 				conf.enable_beacon = true;
--- wireless-testing.orig/net/mac80211/tx.c	2009-04-19 17:31:14.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-04-19 17:31:31.000000000 +0200
@@ -2086,18 +2086,18 @@ struct sk_buff *ieee80211_beacon_get(str
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 		struct ieee80211_hdr *hdr;
+		struct sk_buff *presp = rcu_dereference(ifibss->presp);
 
-		if (!ifibss->probe_resp)
+		if (!presp)
 			goto out;
 
-		skb = skb_copy(ifibss->probe_resp, GFP_ATOMIC);
+		skb = skb_copy(presp, GFP_ATOMIC);
 		if (!skb)
 			goto out;
 
 		hdr = (struct ieee80211_hdr *) skb->data;
 		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						 IEEE80211_STYPE_BEACON);
-
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_mgmt *mgmt;
 		u8 *pos;
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-19 17:51:55.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-19 17:51:58.000000000 +0200
@@ -295,8 +295,6 @@ void ieee80211_scan_completed(struct iee
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 
-	local->last_scan_completed = jiffies;
-
 	if (local->hw_scanning) {
 		local->hw_scanning = false;
 		/*


