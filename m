Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbYIJWMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:12:44 -0400
Message-Id: <20080910220415.642821000@sipsolutions.net> (sfid-20080911_001250_383231_D5E5117A)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:52 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/18] mac80211: reorder MLME code more
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This way all the utility functions are at the top, then the
state machine and externally callable functions are moved to
the bottom. Also clean up ieee80211_i.h a bit and add a few
comments about which functions are called from where.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |   39 +-
 net/mac80211/iface.c       |   17 -
 net/mac80211/mlme.c        |  702 +++++++++++++++++++++++----------------------
 3 files changed, 385 insertions(+), 373 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:57:59.000000000 +0200
@@ -882,54 +882,53 @@ static inline int ieee80211_bssid_match(
 }
 
 
-/* ieee80211.c */
 int ieee80211_hw_config(struct ieee80211_local *local);
 int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 			struct ieee80211_ht_info *req_ht_cap,
 			struct ieee80211_ht_bss_info *req_bss_cap);
+void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+				      u32 changed);
 
-/* ieee80211_ioctl.c */
+/* wireless extensions */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
 int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 
-/* ieee80211_sta.c */
-void ieee80211_sta_timer(unsigned long data);
-void ieee80211_sta_work(struct work_struct *work);
+/* STA/IBSS code */
+void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_scan_work(struct work_struct *work);
 void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status);
 int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len);
 int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len);
 int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid);
-int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len);
 void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_if_sta *ifsta);
-int ieee80211_sta_scan_results(struct ieee80211_local *local,
-			       struct iw_request_info *info,
-			       char *buf, size_t len);
-ieee80211_rx_result ieee80211_sta_rx_scan(
-	struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
-	struct ieee80211_rx_status *rx_status);
-void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
-void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
-int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					struct sk_buff *skb, u8 *bssid,
 					u8 *addr, u64 supp_rates);
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason);
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason);
-void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
-				      u32 changed);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u8 *ssid, size_t ssid_len);
-void ieee802_11_parse_elems(u8 *start, size_t len,
-			    struct ieee802_11_elems *elems);
+
+/* scan/BSS handling */
+int ieee80211_sta_req_scan(struct ieee80211_sub_if_data *sdata, u8 *ssid, size_t ssid_len);
+int ieee80211_sta_scan_results(struct ieee80211_local *local,
+			       struct iw_request_info *info,
+			       char *buf, size_t len);
+ieee80211_rx_result ieee80211_sta_rx_scan(
+	struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+	struct ieee80211_rx_status *rx_status);
+void ieee80211_rx_bss_list_init(struct ieee80211_local *local);
+void ieee80211_rx_bss_list_deinit(struct ieee80211_local *local);
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len);
+
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
 int ieee80211_sta_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 			     u8 *ssid, size_t ssid_len);
@@ -1007,6 +1006,8 @@ void mac80211_ev_michael_mic_failure(str
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt);
+void ieee802_11_parse_elems(u8 *start, size_t len,
+			    struct ieee802_11_elems *elems);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:57:59.000000000 +0200
@@ -83,8 +83,6 @@ static void ieee80211_teardown_sdata(str
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				  enum ieee80211_if_types type)
 {
-	struct ieee80211_if_sta *ifsta;
-
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
 
@@ -101,20 +99,7 @@ static void ieee80211_setup_sdata(struct
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
-		ifsta = &sdata->u.sta;
-		INIT_WORK(&ifsta->work, ieee80211_sta_work);
-		setup_timer(&ifsta->timer, ieee80211_sta_timer,
-			    (unsigned long) sdata);
-		skb_queue_head_init(&ifsta->skb_queue);
-
-		ifsta->capab = WLAN_CAPABILITY_ESS;
-		ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
-			IEEE80211_AUTH_ALG_SHARED_KEY;
-		ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
-			IEEE80211_STA_AUTO_BSSID_SEL |
-			IEEE80211_STA_AUTO_CHANNEL_SEL;
-		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
-			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
+		ieee80211_sta_setup_sdata(sdata);
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:58.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:59.000000000 +0200
@@ -93,44 +93,46 @@ static int ieee80211_compatible_rates(st
 	return count;
 }
 
-/* frame sending functions */
-static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
-				struct ieee80211_if_sta *ifsta,
-				int transaction, u8 *extra, size_t extra_len,
-				int encrypt)
+/* also used by mesh code */
+u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
+			    struct ieee802_11_elems *elems,
+			    enum ieee80211_band band)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_rate *bitrates;
+	size_t num_rates;
+	u64 supp_rates;
+	int i, j;
+	sband = local->hw.wiphy->bands[band];
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 6 + extra_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
-		       "frame\n", sdata->dev->name);
-		return;
+	if (!sband) {
+		WARN_ON(1);
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
-	memset(mgmt, 0, 24 + 6);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_AUTH);
-	if (encrypt)
-		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
-	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
-	ifsta->auth_transaction = transaction + 1;
-	mgmt->u.auth.status_code = cpu_to_le16(0);
-	if (extra)
-		memcpy(skb_put(skb, extra_len), extra, extra_len);
 
-	ieee80211_tx_skb(sdata, skb, encrypt);
+	bitrates = sband->bitrates;
+	num_rates = sband->n_bitrates;
+	supp_rates = 0;
+	for (i = 0; i < elems->supp_rates_len +
+		     elems->ext_supp_rates_len; i++) {
+		u8 rate = 0;
+		int own_rate;
+		if (i < elems->supp_rates_len)
+			rate = elems->supp_rates[i];
+		else if (elems->ext_supp_rates)
+			rate = elems->ext_supp_rates
+				[i - elems->supp_rates_len];
+		own_rate = 5 * (rate & 0x7f);
+		for (j = 0; j < num_rates; j++)
+			if (bitrates[j].bitrate == own_rate)
+				supp_rates |= BIT(j);
+	}
+	return supp_rates;
 }
 
+/* frame sending functions */
+
+/* also used by scanning code */
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      u8 *ssid, size_t ssid_len)
 {
@@ -191,6 +193,43 @@ void ieee80211_send_probe_req(struct iee
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
+static void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+				struct ieee80211_if_sta *ifsta,
+				int transaction, u8 *extra, size_t extra_len,
+				int encrypt)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(*mgmt) + 6 + extra_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for auth "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
+	memset(mgmt, 0, 24 + 6);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_AUTH);
+	if (encrypt)
+		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->u.auth.auth_alg = cpu_to_le16(ifsta->auth_alg);
+	mgmt->u.auth.auth_transaction = cpu_to_le16(transaction);
+	ifsta->auth_transaction = transaction + 1;
+	mgmt->u.auth.status_code = cpu_to_le16(0);
+	if (extra)
+		memcpy(skb_put(skb, extra_len), extra, extra_len);
+
+	ieee80211_tx_skb(sdata, skb, encrypt);
+}
+
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_if_sta *ifsta)
 {
@@ -1445,42 +1484,6 @@ static int ieee80211_sta_join_ibss(struc
 	return res;
 }
 
-u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
-			    struct ieee802_11_elems *elems,
-			    enum ieee80211_band band)
-{
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *bitrates;
-	size_t num_rates;
-	u64 supp_rates;
-	int i, j;
-	sband = local->hw.wiphy->bands[band];
-
-	if (!sband) {
-		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	}
-
-	bitrates = sband->bitrates;
-	num_rates = sband->n_bitrates;
-	supp_rates = 0;
-	for (i = 0; i < elems->supp_rates_len +
-		     elems->ext_supp_rates_len; i++) {
-		u8 rate = 0;
-		int own_rate;
-		if (i < elems->supp_rates_len)
-			rate = elems->supp_rates[i];
-		else if (elems->ext_supp_rates)
-			rate = elems->ext_supp_rates
-				[i - elems->supp_rates_len];
-		own_rate = 5 * (rate & 0x7f);
-		for (j = 0; j < num_rates; j++)
-			if (bitrates[j].bitrate == own_rate)
-				supp_rates |= BIT(j);
-	}
-	return supp_rates;
-}
-
 static u64 ieee80211_sta_get_mandatory_rates(struct ieee80211_local *local,
 					enum ieee80211_band band)
 {
@@ -1925,7 +1928,7 @@ static void ieee80211_sta_merge_ibss(str
 }
 
 
-void ieee80211_sta_timer(unsigned long data)
+static void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
@@ -1968,28 +1971,6 @@ static void ieee80211_sta_reset_auth(str
 }
 
 
-void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
-			    struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_local *local = sdata->local;
-
-	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
-		return;
-
-	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
-			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
-	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
-			     IEEE80211_STA_AUTO_SSID_SEL))) {
-
-		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
-			ieee80211_set_disassoc(sdata, ifsta, true, true,
-					       WLAN_REASON_DEAUTH_LEAVING);
-
-		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		queue_work(local->hw.workqueue, &ifsta->work);
-	}
-}
-
 static int ieee80211_sta_match_ssid(struct ieee80211_if_sta *ifsta,
 				    const char *ssid, int ssid_len)
 {
@@ -2191,113 +2172,190 @@ dont_join:
 }
 
 
-int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
+static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_if_sta *ifsta;
-	int res;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sta_bss *bss, *selected = NULL;
+	int top_rssi = 0, freq;
 
-	if (len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
+	spin_lock_bh(&local->sta_bss_lock);
+	freq = local->oper_channel->center_freq;
+	list_for_each_entry(bss, &local->sta_bss_list, list) {
+		if (!(bss->capability & WLAN_CAPABILITY_ESS))
+			continue;
 
-	ifsta = &sdata->u.sta;
+		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
+			IEEE80211_STA_AUTO_BSSID_SEL |
+			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
+		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
+		     !!sdata->default_key))
+			continue;
 
-	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0) {
-		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
-		memcpy(ifsta->ssid, ssid, len);
-		ifsta->ssid_len = len;
-		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
+		    bss->freq != freq)
+			continue;
 
-		res = 0;
-		/*
-		 * Hack! MLME code needs to be cleaned up to have different
-		 * entry points for configuration and internal selection change
-		 */
-		if (netif_running(sdata->dev))
-			res = ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
-		if (res) {
-			printk(KERN_DEBUG "%s: Failed to config new SSID to "
-			       "the low-level driver\n", sdata->dev->name);
-			return res;
-		}
-	}
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
+		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
+			continue;
 
-	if (len)
-		ifsta->flags |= IEEE80211_STA_SSID_SET;
-	else
-		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
+		if (!(ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) &&
+		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
+			continue;
 
-	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
-	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
-		ifsta->ibss_join_req = jiffies;
-		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
-		return ieee80211_sta_find_ibss(sdata, ifsta);
+		if (!selected || top_rssi < bss->signal) {
+			selected = bss;
+			top_rssi = bss->signal;
+		}
 	}
+	if (selected)
+		atomic_inc(&selected->users);
+	spin_unlock_bh(&local->sta_bss_lock);
 
-	return 0;
-}
-
-
-int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
-{
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	memcpy(ssid, ifsta->ssid, ifsta->ssid_len);
-	*len = ifsta->ssid_len;
-	return 0;
-}
-
+	if (selected) {
+		ieee80211_set_freq(sdata, selected->freq);
+		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
+			ieee80211_sta_set_ssid(sdata, selected->ssid,
+					       selected->ssid_len);
+		ieee80211_sta_set_bssid(sdata, selected->bssid);
+		ieee80211_sta_def_wmm_params(sdata, selected);
 
-int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
-{
-	struct ieee80211_if_sta *ifsta;
-	int res;
+		/* Send out direct probe if no probe resp was received or
+		 * the one we have is outdated
+		 */
+		if (!selected->last_probe_resp ||
+		    time_after(jiffies, selected->last_probe_resp
+					+ IEEE80211_SCAN_RESULT_EXPIRE))
+			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
+		else
+			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
 
-	ifsta = &sdata->u.sta;
-
-	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
-		memcpy(ifsta->bssid, bssid, ETH_ALEN);
-		res = 0;
-		/*
-		 * Hack! See also ieee80211_sta_set_ssid.
-		 */
-		if (netif_running(sdata->dev))
-			res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
-		if (res) {
-			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
-			       "the low-level driver\n", sdata->dev->name);
-			return res;
-		}
+		ieee80211_rx_bss_put(local, selected);
+		ieee80211_sta_reset_auth(sdata, ifsta);
+		return 0;
+	} else {
+		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
+			ifsta->assoc_scan_tries++;
+			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
+				ieee80211_sta_start_scan(sdata, NULL, 0);
+			else
+				ieee80211_sta_start_scan(sdata, ifsta->ssid,
+							 ifsta->ssid_len);
+			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+		} else
+			ifsta->state = IEEE80211_STA_MLME_DISABLED;
 	}
-
-	if (is_valid_ether_addr(bssid))
-		ifsta->flags |= IEEE80211_STA_BSSID_SET;
-	else
-		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
-
-	return 0;
+	return -1;
 }
 
 
-int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)
+static void ieee80211_sta_work(struct work_struct *work)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_sta *ifsta;
+	struct sk_buff *skb;
 
-	kfree(ifsta->extra_ie);
-	if (len == 0) {
-		ifsta->extra_ie = NULL;
-		ifsta->extra_ie_len = 0;
-		return 0;
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
+		return;
+
+	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
+		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS))
+		return;
+	ifsta = &sdata->u.sta;
+
+	while ((skb = skb_dequeue(&ifsta->skb_queue)))
+		ieee80211_sta_rx_queued_mgmt(sdata, skb);
+
+	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
+	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
+	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
+	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
+		ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
+		return;
 	}
-	ifsta->extra_ie = kmalloc(len, GFP_KERNEL);
-	if (!ifsta->extra_ie) {
-		ifsta->extra_ie_len = 0;
-		return -ENOMEM;
+
+	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
+		if (ieee80211_sta_config_auth(sdata, ifsta))
+			return;
+		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
+	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
+		return;
+
+	switch (ifsta->state) {
+	case IEEE80211_STA_MLME_DISABLED:
+		break;
+	case IEEE80211_STA_MLME_DIRECT_PROBE:
+		ieee80211_direct_probe(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_AUTHENTICATE:
+		ieee80211_authenticate(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_ASSOCIATE:
+		ieee80211_associate(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_ASSOCIATED:
+		ieee80211_associated(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_IBSS_SEARCH:
+		ieee80211_sta_find_ibss(sdata, ifsta);
+		break;
+	case IEEE80211_STA_MLME_IBSS_JOINED:
+		ieee80211_sta_merge_ibss(sdata, ifsta);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
+		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
+		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
+
+		ieee80211_set_disassoc(sdata, ifsta, false, true,
+					WLAN_REASON_UNSPECIFIED);
 	}
-	memcpy(ifsta->extra_ie, ie, len);
-	ifsta->extra_ie_len = len;
-	return 0;
 }
 
+static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
+		queue_work(sdata->local->hw.workqueue,
+			   &sdata->u.sta.work);
+}
 
+/* interface setup */
+void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_sta *ifsta;
+
+	ifsta = &sdata->u.sta;
+	INIT_WORK(&ifsta->work, ieee80211_sta_work);
+	setup_timer(&ifsta->timer, ieee80211_sta_timer,
+		    (unsigned long) sdata);
+	skb_queue_head_init(&ifsta->skb_queue);
+
+	ifsta->capab = WLAN_CAPABILITY_ESS;
+	ifsta->auth_algs = IEEE80211_AUTH_ALG_OPEN |
+		IEEE80211_AUTH_ALG_SHARED_KEY;
+	ifsta->flags |= IEEE80211_STA_CREATE_IBSS |
+		IEEE80211_STA_AUTO_BSSID_SEL |
+		IEEE80211_STA_AUTO_CHANNEL_SEL;
+	if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
+		ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
+}
+
+/*
+ * Add a new IBSS station, will also be called by the RX code when,
+ * in IBSS mode, receiving a frame from a yet-unknown station, hence
+ * must be callable in atomic context.
+ */
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					struct sk_buff *skb, u8 *bssid,
 					u8 *addr, u64 supp_rates)
@@ -2343,86 +2401,132 @@ struct sta_info *ieee80211_ibss_add_sta(
 	return sta;
 }
 
-
-static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta)
+/* configuration hooks */
+void ieee80211_sta_req_auth(struct ieee80211_sub_if_data *sdata,
+			    struct ieee80211_if_sta *ifsta)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_sta_bss *bss, *selected = NULL;
-	int top_rssi = 0, freq;
 
-	spin_lock_bh(&local->sta_bss_lock);
-	freq = local->oper_channel->center_freq;
-	list_for_each_entry(bss, &local->sta_bss_list, list) {
-		if (!(bss->capability & WLAN_CAPABILITY_ESS))
-			continue;
+	if (sdata->vif.type != IEEE80211_IF_TYPE_STA)
+		return;
 
-		if ((ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
-			IEEE80211_STA_AUTO_BSSID_SEL |
-			IEEE80211_STA_AUTO_CHANNEL_SEL)) &&
-		    (!!(bss->capability & WLAN_CAPABILITY_PRIVACY) ^
-		     !!sdata->default_key))
-			continue;
+	if ((ifsta->flags & (IEEE80211_STA_BSSID_SET |
+			     IEEE80211_STA_AUTO_BSSID_SEL)) &&
+	    (ifsta->flags & (IEEE80211_STA_SSID_SET |
+			     IEEE80211_STA_AUTO_SSID_SEL))) {
 
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_CHANNEL_SEL) &&
-		    bss->freq != freq)
-			continue;
+		if (ifsta->state == IEEE80211_STA_MLME_ASSOCIATED)
+			ieee80211_set_disassoc(sdata, ifsta, true, true,
+					       WLAN_REASON_DEAUTH_LEAVING);
 
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_BSSID_SEL) &&
-		    memcmp(bss->bssid, ifsta->bssid, ETH_ALEN))
-			continue;
+		set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
+		queue_work(local->hw.workqueue, &ifsta->work);
+	}
+}
 
-		if (!(ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL) &&
-		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
-			continue;
+int ieee80211_sta_set_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t len)
+{
+	struct ieee80211_if_sta *ifsta;
+	int res;
 
-		if (!selected || top_rssi < bss->signal) {
-			selected = bss;
-			top_rssi = bss->signal;
+	if (len > IEEE80211_MAX_SSID_LEN)
+		return -EINVAL;
+
+	ifsta = &sdata->u.sta;
+
+	if (ifsta->ssid_len != len || memcmp(ifsta->ssid, ssid, len) != 0) {
+		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
+		memcpy(ifsta->ssid, ssid, len);
+		ifsta->ssid_len = len;
+		ifsta->flags &= ~IEEE80211_STA_PREV_BSSID_SET;
+
+		res = 0;
+		/*
+		 * Hack! MLME code needs to be cleaned up to have different
+		 * entry points for configuration and internal selection change
+		 */
+		if (netif_running(sdata->dev))
+			res = ieee80211_if_config(sdata, IEEE80211_IFCC_SSID);
+		if (res) {
+			printk(KERN_DEBUG "%s: Failed to config new SSID to "
+			       "the low-level driver\n", sdata->dev->name);
+			return res;
 		}
 	}
-	if (selected)
-		atomic_inc(&selected->users);
-	spin_unlock_bh(&local->sta_bss_lock);
 
-	if (selected) {
-		ieee80211_set_freq(sdata, selected->freq);
-		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
-			ieee80211_sta_set_ssid(sdata, selected->ssid,
-					       selected->ssid_len);
-		ieee80211_sta_set_bssid(sdata, selected->bssid);
-		ieee80211_sta_def_wmm_params(sdata, selected);
+	if (len)
+		ifsta->flags |= IEEE80211_STA_SSID_SET;
+	else
+		ifsta->flags &= ~IEEE80211_STA_SSID_SET;
 
-		/* Send out direct probe if no probe resp was received or
-		 * the one we have is outdated
+	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
+		ifsta->ibss_join_req = jiffies;
+		ifsta->state = IEEE80211_STA_MLME_IBSS_SEARCH;
+		return ieee80211_sta_find_ibss(sdata, ifsta);
+	}
+
+	return 0;
+}
+
+int ieee80211_sta_get_ssid(struct ieee80211_sub_if_data *sdata, char *ssid, size_t *len)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	memcpy(ssid, ifsta->ssid, ifsta->ssid_len);
+	*len = ifsta->ssid_len;
+	return 0;
+}
+
+int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 *bssid)
+{
+	struct ieee80211_if_sta *ifsta;
+	int res;
+
+	ifsta = &sdata->u.sta;
+
+	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) != 0) {
+		memcpy(ifsta->bssid, bssid, ETH_ALEN);
+		res = 0;
+		/*
+		 * Hack! See also ieee80211_sta_set_ssid.
 		 */
-		if (!selected->last_probe_resp ||
-		    time_after(jiffies, selected->last_probe_resp
-					+ IEEE80211_SCAN_RESULT_EXPIRE))
-			ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
-		else
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+		if (netif_running(sdata->dev))
+			res = ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
+		if (res) {
+			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
+			       "the low-level driver\n", sdata->dev->name);
+			return res;
+		}
+	}
 
-		ieee80211_rx_bss_put(local, selected);
-		ieee80211_sta_reset_auth(sdata, ifsta);
+	if (is_valid_ether_addr(bssid))
+		ifsta->flags |= IEEE80211_STA_BSSID_SET;
+	else
+		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
+
+	return 0;
+}
+
+int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, char *ie, size_t len)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+
+	kfree(ifsta->extra_ie);
+	if (len == 0) {
+		ifsta->extra_ie = NULL;
+		ifsta->extra_ie_len = 0;
 		return 0;
-	} else {
-		if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
-			ifsta->assoc_scan_tries++;
-			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				ieee80211_sta_start_scan(sdata, NULL, 0);
-			else
-				ieee80211_sta_start_scan(sdata, ifsta->ssid,
-							 ifsta->ssid_len);
-			ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
-			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
-		} else
-			ifsta->state = IEEE80211_STA_MLME_DISABLED;
 	}
-	return -1;
+	ifsta->extra_ie = kmalloc(len, GFP_KERNEL);
+	if (!ifsta->extra_ie) {
+		ifsta->extra_ie_len = 0;
+		return -ENOMEM;
+	}
+	memcpy(ifsta->extra_ie, ie, len);
+	ifsta->extra_ie_len = len;
+	return 0;
 }
 
-
 int ieee80211_sta_deauthenticate(struct ieee80211_sub_if_data *sdata, u16 reason)
 {
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -2438,7 +2542,6 @@ int ieee80211_sta_deauthenticate(struct 
 	return 0;
 }
 
-
 int ieee80211_sta_disassociate(struct ieee80211_sub_if_data *sdata, u16 reason)
 {
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
@@ -2456,6 +2559,28 @@ int ieee80211_sta_disassociate(struct ie
 	return 0;
 }
 
+/* scan finished notification */
+void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct ieee80211_if_sta *ifsta;
+
+	if (sdata && sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
+		ifsta = &sdata->u.sta;
+		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
+		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
+		    !ieee80211_sta_active_ibss(sdata)))
+			ieee80211_sta_find_ibss(sdata, ifsta);
+	}
+
+	/* Restart STA timers */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		ieee80211_restart_sta_timer(sdata);
+	rcu_read_unlock();
+}
+
+/* driver notification call */
 void ieee80211_notify_mac(struct ieee80211_hw *hw,
 			  enum ieee80211_notification_types  notif_type)
 {
@@ -2476,102 +2601,3 @@ void ieee80211_notify_mac(struct ieee802
 	}
 }
 EXPORT_SYMBOL(ieee80211_notify_mac);
-
-void ieee80211_sta_work(struct work_struct *work)
-{
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.sta.work);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_sta *ifsta;
-	struct sk_buff *skb;
-
-	if (!netif_running(sdata->dev))
-		return;
-
-	if (local->sta_sw_scanning || local->sta_hw_scanning)
-		return;
-
-	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS))
-		return;
-	ifsta = &sdata->u.sta;
-
-	while ((skb = skb_dequeue(&ifsta->skb_queue)))
-		ieee80211_sta_rx_queued_mgmt(sdata, skb);
-
-	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
-	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
-	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
-	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
-		ieee80211_sta_start_scan(sdata, ifsta->scan_ssid, ifsta->scan_ssid_len);
-		return;
-	}
-
-	if (test_and_clear_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request)) {
-		if (ieee80211_sta_config_auth(sdata, ifsta))
-			return;
-		clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request);
-	} else if (!test_and_clear_bit(IEEE80211_STA_REQ_RUN, &ifsta->request))
-		return;
-
-	switch (ifsta->state) {
-	case IEEE80211_STA_MLME_DISABLED:
-		break;
-	case IEEE80211_STA_MLME_DIRECT_PROBE:
-		ieee80211_direct_probe(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_AUTHENTICATE:
-		ieee80211_authenticate(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_ASSOCIATE:
-		ieee80211_associate(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_ASSOCIATED:
-		ieee80211_associated(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_SEARCH:
-		ieee80211_sta_find_ibss(sdata, ifsta);
-		break;
-	case IEEE80211_STA_MLME_IBSS_JOINED:
-		ieee80211_sta_merge_ibss(sdata, ifsta);
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	if (ieee80211_privacy_mismatch(sdata, ifsta)) {
-		printk(KERN_DEBUG "%s: privacy configuration mismatch and "
-		       "mixed-cell disabled - disassociate\n", sdata->dev->name);
-
-		ieee80211_set_disassoc(sdata, ifsta, false, true,
-					WLAN_REASON_UNSPECIFIED);
-	}
-}
-
-static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
-{
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
-		queue_work(sdata->local->hw.workqueue,
-			   &sdata->u.sta.work);
-}
-
-void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	struct ieee80211_if_sta *ifsta;
-
-	if (sdata && sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		ifsta = &sdata->u.sta;
-		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
-		    (!(ifsta->state == IEEE80211_STA_MLME_IBSS_JOINED) &&
-		    !ieee80211_sta_active_ibss(sdata)))
-			ieee80211_sta_find_ibss(sdata, ifsta);
-	}
-
-	/* Restart STA timers */
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		ieee80211_restart_sta_timer(sdata);
-	rcu_read_unlock();
-}

-- 

