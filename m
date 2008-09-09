Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYIII5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:57:17 -0400
Subject: [PATCH 12/8] mac80211: reorder frame code in mlme
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080908154421.216772000@sipsolutions.net> (sfid-20080908_174606_739824_DD7A31F6)
References: <20080908154421.216772000@sipsolutions.net>
	 (sfid-20080908_174606_739824_DD7A31F6)
Content-Type: text/plain
Date: Tue, 09 Sep 2008 10:57:09 +0200
Message-Id: <1220950629.31304.118.camel@johannes.berg> (sfid-20080909_105723_033950_8738EC57)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reorders all frame sending functions to be at the top of the
file. When reading the file, I tend to be looking at either the
frame code or the state machine, and having them mixed in the file
is confusing. When all frame sending is at the top the remainder
of the file is more readable, in my opinion.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
The only actual change is removing a stray "return;" at the end of a function.

 net/mac80211/mlme.c |  884 +++++++++++++++++++++++++---------------------------
 1 file changed, 441 insertions(+), 443 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-09 09:36:51.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-09 09:47:27.000000000 +0200
@@ -74,6 +74,27 @@ static u8 *ieee80211_bss_get_ie(struct i
 	return NULL;
 }
 
+static int ieee80211_compatible_rates(struct ieee80211_sta_bss *bss,
+				      struct ieee80211_supported_band *sband,
+				      u64 *rates)
+{
+	int i, j, count;
+	*rates = 0;
+	count = 0;
+	for (i = 0; i < bss->supp_rates_len; i++) {
+		int rate = (bss->supp_rates[i] & 0x7F) * 5;
+
+		for (j = 0; j < sband->n_bitrates; j++)
+			if (sband->bitrates[j].bitrate == rate) {
+				*rates |= BIT(j);
+				count++;
+				break;
+			}
+	}
+
+	return count;
+}
+
 /* frame sending functions */
 void ieee80211_sta_tx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 		      int encrypt)
@@ -186,6 +207,364 @@ void ieee80211_send_probe_req(struct iee
 	ieee80211_sta_tx(sdata, skb, 0);
 }
 
+static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_if_sta *ifsta)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos, *ies, *ht_add_ie;
+	int i, len, count, rates_len, supp_rates_len;
+	u16 capab;
+	struct ieee80211_sta_bss *bss;
+	int wmm = 0;
+	struct ieee80211_supported_band *sband;
+	u64 rates = 0;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
+			    ifsta->ssid_len);
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+
+	capab = ifsta->capab;
+
+	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+	}
+
+	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+				   local->hw.conf.channel->center_freq,
+				   ifsta->ssid, ifsta->ssid_len);
+	if (bss) {
+		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
+			capab |= WLAN_CAPABILITY_PRIVACY;
+		if (bss->wmm_used)
+			wmm = 1;
+
+		/* get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode) */
+		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+
+		if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
+		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
+			capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+
+		ieee80211_rx_bss_put(local, bss);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+
+	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
+		skb_put(skb, 10);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_REASSOC_REQ);
+		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
+		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
+		       ETH_ALEN);
+	} else {
+		skb_put(skb, 4);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ASSOC_REQ);
+		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
+	}
+
+	/* SSID */
+	ies = pos = skb_put(skb, 2 + ifsta->ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = ifsta->ssid_len;
+	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
+
+	/* add all rates which were marked to be used above */
+	supp_rates_len = rates_len;
+	if (supp_rates_len > 8)
+		supp_rates_len = 8;
+
+	len = sband->n_bitrates;
+	pos = skb_put(skb, supp_rates_len + 2);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = supp_rates_len;
+
+	count = 0;
+	for (i = 0; i < sband->n_bitrates; i++) {
+		if (BIT(i) & rates) {
+			int rate = sband->bitrates[i].bitrate;
+			*pos++ = (u8) (rate / 5);
+			if (++count == 8)
+				break;
+		}
+	}
+
+	if (rates_len > count) {
+		pos = skb_put(skb, rates_len - count + 2);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = rates_len - count;
+
+		for (i++; i < sband->n_bitrates; i++) {
+			if (BIT(i) & rates) {
+				int rate = sband->bitrates[i].bitrate;
+				*pos++ = (u8) (rate / 5);
+			}
+		}
+	}
+
+	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT) {
+		/* 1. power capabilities */
+		pos = skb_put(skb, 4);
+		*pos++ = WLAN_EID_PWR_CAPABILITY;
+		*pos++ = 2;
+		*pos++ = 0; /* min tx power */
+		*pos++ = local->hw.conf.channel->max_power; /* max tx power */
+
+		/* 2. supported channels */
+		/* TODO: get this in reg domain format */
+		pos = skb_put(skb, 2 * sband->n_channels + 2);
+		*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
+		*pos++ = 2 * sband->n_channels;
+		for (i = 0; i < sband->n_channels; i++) {
+			*pos++ = ieee80211_frequency_to_channel(
+					sband->channels[i].center_freq);
+			*pos++ = 1; /* one channel in the subband*/
+		}
+	}
+
+	if (ifsta->extra_ie) {
+		pos = skb_put(skb, ifsta->extra_ie_len);
+		memcpy(pos, ifsta->extra_ie, ifsta->extra_ie_len);
+	}
+
+	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
+		pos = skb_put(skb, 9);
+		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+		*pos++ = 7; /* len */
+		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
+		*pos++ = 0x50;
+		*pos++ = 0xf2;
+		*pos++ = 2; /* WME */
+		*pos++ = 0; /* WME info */
+		*pos++ = 1; /* WME ver */
+		*pos++ = 0;
+	}
+
+	/* wmm support is a must to HT */
+	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
+	    sband->ht_info.ht_supported &&
+	    (ht_add_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_EXTRA_INFO))) {
+		struct ieee80211_ht_addt_info *ht_add_info =
+			(struct ieee80211_ht_addt_info *)ht_add_ie;
+		u16 cap = sband->ht_info.cap;
+		__le16 tmp;
+		u32 flags = local->hw.conf.channel->flags;
+
+		switch (ht_add_info->ht_param & IEEE80211_HT_IE_CHA_SEC_OFFSET) {
+		case IEEE80211_HT_IE_CHA_SEC_ABOVE:
+			if (flags & IEEE80211_CHAN_NO_FAT_ABOVE) {
+				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
+				cap &= ~IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		case IEEE80211_HT_IE_CHA_SEC_BELOW:
+			if (flags & IEEE80211_CHAN_NO_FAT_BELOW) {
+				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
+				cap &= ~IEEE80211_HT_CAP_SGI_40;
+			}
+			break;
+		}
+
+		tmp = cpu_to_le16(cap);
+		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		memcpy(pos, &tmp, sizeof(u16));
+		pos += sizeof(u16);
+		/* TODO: needs a define here for << 2 */
+		*pos++ = sband->ht_info.ampdu_factor |
+			 (sband->ht_info.ampdu_density << 2);
+		memcpy(pos, sband->ht_info.supp_mcs_set, 16);
+	}
+
+	kfree(ifsta->assocreq_ies);
+	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
+	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_KERNEL);
+	if (ifsta->assocreq_ies)
+		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+
+static void ieee80211_send_deauth(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_if_sta *ifsta, u16 reason)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for deauth "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DEAUTH);
+	skb_put(skb, 2);
+	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_if_sta *ifsta, u16 reason)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer for disassoc "
+		       "frame\n", sdata->dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DISASSOC);
+	skb_put(skb, 2);
+	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
+					u8 dialog_token, u16 status, u16 policy,
+					u16 buf_size, u16 timeout)
+{
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u16 capab;
+
+	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
+
+	if (!skb) {
+		printk(KERN_DEBUG "%s: failed to allocate buffer "
+		       "for addba resp frame\n", sdata->dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, da, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
+	else
+		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
+	mgmt->u.action.category = WLAN_CATEGORY_BACK;
+	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
+	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
+
+	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
+	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
+	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
+
+	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
+	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
+	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
+static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
+					struct ieee80211_msrment_ie *request_ie,
+					const u8 *da, const u8 *bssid,
+					u8 dialog_token)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *msr_report;
+
+	skb = dev_alloc_skb(sizeof(*msr_report) + local->hw.extra_tx_headroom +
+				sizeof(struct ieee80211_msrment_ie));
+
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+				"measurement report frame\n", sdata->dev->name);
+		return;
+	}
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
+	memset(msr_report, 0, 24);
+	memcpy(msr_report->da, da, ETH_ALEN);
+	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
+	memcpy(msr_report->bssid, bssid, ETH_ALEN);
+	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						IEEE80211_STYPE_ACTION);
+
+	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
+	msr_report->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
+	msr_report->u.action.u.measurement.action_code =
+				WLAN_ACTION_SPCT_MSR_RPRT;
+	msr_report->u.action.u.measurement.dialog_token = dialog_token;
+
+	msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
+	msr_report->u.action.u.measurement.length =
+			sizeof(struct ieee80211_msrment_ie);
+
+	memset(&msr_report->u.action.u.measurement.msr_elem, 0,
+		sizeof(struct ieee80211_msrment_ie));
+	msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
+	msr_report->u.action.u.measurement.msr_elem.mode |=
+			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
+	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
+
+	ieee80211_sta_tx(sdata, skb, 0);
+}
+
 /* MLME */
 static void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_sta_bss *bss)
@@ -430,379 +809,85 @@ static void ieee80211_set_associated(str
 		sdata->bss_conf.dtim_period = bss->dtim_period;
 
 		changed |= ieee80211_handle_bss_capability(sdata, bss);
-
-		ieee80211_rx_bss_put(local, bss);
-	}
-
-	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
-		changed |= BSS_CHANGED_HT;
-		sdata->bss_conf.assoc_ht = 1;
-		sdata->bss_conf.ht_conf = &conf->ht_conf;
-		sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
-	}
-
-	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
-	memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
-	ieee80211_sta_send_associnfo(sdata, ifsta);
-
-	ifsta->last_probe = jiffies;
-	ieee80211_led_assoc(local, 1);
-
-	sdata->bss_conf.assoc = 1;
-	ieee80211_bss_info_change_notify(sdata, changed);
-
-	netif_tx_start_all_queues(sdata->dev);
-	netif_carrier_on(sdata->dev);
-
-	ieee80211_sta_send_apinfo(sdata, ifsta);
-}
-
-static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta)
-{
-	DECLARE_MAC_BUF(mac);
-
-	ifsta->direct_probe_tries++;
-	if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
-		       sdata->dev->name, print_mac(mac, ifsta->bssid));
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		return;
-	}
-
-	printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
-			sdata->dev->name, print_mac(mac, ifsta->bssid),
-			ifsta->direct_probe_tries);
-
-	ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
-
-	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
-
-	/* Direct probe is sent to broadcast address as some APs
-	 * will not answer to direct packet in unassociated state.
-	 */
-	ieee80211_send_probe_req(sdata, NULL,
-				 ifsta->ssid, ifsta->ssid_len);
-
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
-}
-
-
-static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
-				   struct ieee80211_if_sta *ifsta)
-{
-	DECLARE_MAC_BUF(mac);
-
-	ifsta->auth_tries++;
-	if (ifsta->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: authentication with AP %s"
-		       " timed out\n",
-		       sdata->dev->name, print_mac(mac, ifsta->bssid));
-		ifsta->state = IEEE80211_STA_MLME_DISABLED;
-		return;
-	}
-
-	ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
-	printk(KERN_DEBUG "%s: authenticate with AP %s\n",
-	       sdata->dev->name, print_mac(mac, ifsta->bssid));
-
-	ieee80211_send_auth(sdata, ifsta, 1, NULL, 0, 0);
-
-	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
-}
-
-static int ieee80211_compatible_rates(struct ieee80211_sta_bss *bss,
-				      struct ieee80211_supported_band *sband,
-				      u64 *rates)
-{
-	int i, j, count;
-	*rates = 0;
-	count = 0;
-	for (i = 0; i < bss->supp_rates_len; i++) {
-		int rate = (bss->supp_rates[i] & 0x7F) * 5;
-
-		for (j = 0; j < sband->n_bitrates; j++)
-			if (sband->bitrates[j].bitrate == rate) {
-				*rates |= BIT(j);
-				count++;
-				break;
-			}
-	}
-
-	return count;
-}
-
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_if_sta *ifsta)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos, *ies, *ht_add_ie;
-	int i, len, count, rates_len, supp_rates_len;
-	u16 capab;
-	struct ieee80211_sta_bss *bss;
-	int wmm = 0;
-	struct ieee80211_supported_band *sband;
-	u64 rates = 0;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-			    sizeof(*mgmt) + 200 + ifsta->extra_ie_len +
-			    ifsta->ssid_len);
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for assoc "
-		       "frame\n", sdata->dev->name);
-		return;
-	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-
-	capab = ifsta->capab;
-
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) {
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
-	}
-
-	bss = ieee80211_rx_bss_get(local, ifsta->bssid,
-				   local->hw.conf.channel->center_freq,
-				   ifsta->ssid, ifsta->ssid_len);
-	if (bss) {
-		if (bss->capability & WLAN_CAPABILITY_PRIVACY)
-			capab |= WLAN_CAPABILITY_PRIVACY;
-		if (bss->wmm_used)
-			wmm = 1;
-
-		/* get all rates supported by the device and the AP as
-		 * some APs don't like getting a superset of their rates
-		 * in the association request (e.g. D-Link DAP 1353 in
-		 * b-only mode) */
-		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
-
-		if ((bss->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
-		    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
-			capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
-
-		ieee80211_rx_bss_put(local, bss);
-	} else {
-		rates = ~0;
-		rates_len = sband->n_bitrates;
-	}
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-
-	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
-		skb_put(skb, 10);
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_REASSOC_REQ);
-		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval =
-				cpu_to_le16(local->hw.conf.listen_interval);
-		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
-		       ETH_ALEN);
-	} else {
-		skb_put(skb, 4);
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_ASSOC_REQ);
-		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval =
-				cpu_to_le16(local->hw.conf.listen_interval);
-	}
-
-	/* SSID */
-	ies = pos = skb_put(skb, 2 + ifsta->ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = ifsta->ssid_len;
-	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
-
-	/* add all rates which were marked to be used above */
-	supp_rates_len = rates_len;
-	if (supp_rates_len > 8)
-		supp_rates_len = 8;
-
-	len = sband->n_bitrates;
-	pos = skb_put(skb, supp_rates_len + 2);
-	*pos++ = WLAN_EID_SUPP_RATES;
-	*pos++ = supp_rates_len;
-
-	count = 0;
-	for (i = 0; i < sband->n_bitrates; i++) {
-		if (BIT(i) & rates) {
-			int rate = sband->bitrates[i].bitrate;
-			*pos++ = (u8) (rate / 5);
-			if (++count == 8)
-				break;
-		}
-	}
-
-	if (rates_len > count) {
-		pos = skb_put(skb, rates_len - count + 2);
-		*pos++ = WLAN_EID_EXT_SUPP_RATES;
-		*pos++ = rates_len - count;
-
-		for (i++; i < sband->n_bitrates; i++) {
-			if (BIT(i) & rates) {
-				int rate = sband->bitrates[i].bitrate;
-				*pos++ = (u8) (rate / 5);
-			}
-		}
-	}
-
-	if (capab & WLAN_CAPABILITY_SPECTRUM_MGMT) {
-		/* 1. power capabilities */
-		pos = skb_put(skb, 4);
-		*pos++ = WLAN_EID_PWR_CAPABILITY;
-		*pos++ = 2;
-		*pos++ = 0; /* min tx power */
-		*pos++ = local->hw.conf.channel->max_power; /* max tx power */
-
-		/* 2. supported channels */
-		/* TODO: get this in reg domain format */
-		pos = skb_put(skb, 2 * sband->n_channels + 2);
-		*pos++ = WLAN_EID_SUPPORTED_CHANNELS;
-		*pos++ = 2 * sband->n_channels;
-		for (i = 0; i < sband->n_channels; i++) {
-			*pos++ = ieee80211_frequency_to_channel(
-					sband->channels[i].center_freq);
-			*pos++ = 1; /* one channel in the subband*/
-		}
-	}
-
-	if (ifsta->extra_ie) {
-		pos = skb_put(skb, ifsta->extra_ie_len);
-		memcpy(pos, ifsta->extra_ie, ifsta->extra_ie_len);
+
+		ieee80211_rx_bss_put(local, bss);
 	}
 
-	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
-		pos = skb_put(skb, 9);
-		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
-		*pos++ = 7; /* len */
-		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
-		*pos++ = 0x50;
-		*pos++ = 0xf2;
-		*pos++ = 2; /* WME */
-		*pos++ = 0; /* WME info */
-		*pos++ = 1; /* WME ver */
-		*pos++ = 0;
+	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
+		changed |= BSS_CHANGED_HT;
+		sdata->bss_conf.assoc_ht = 1;
+		sdata->bss_conf.ht_conf = &conf->ht_conf;
+		sdata->bss_conf.ht_bss_conf = &conf->ht_bss_conf;
 	}
 
-	/* wmm support is a must to HT */
-	if (wmm && (ifsta->flags & IEEE80211_STA_WMM_ENABLED) &&
-	    sband->ht_info.ht_supported &&
-	    (ht_add_ie = ieee80211_bss_get_ie(bss, WLAN_EID_HT_EXTRA_INFO))) {
-		struct ieee80211_ht_addt_info *ht_add_info =
-			(struct ieee80211_ht_addt_info *)ht_add_ie;
-		u16 cap = sband->ht_info.cap;
-		__le16 tmp;
-		u32 flags = local->hw.conf.channel->flags;
+	ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
+	memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
+	ieee80211_sta_send_associnfo(sdata, ifsta);
 
-		switch (ht_add_info->ht_param & IEEE80211_HT_IE_CHA_SEC_OFFSET) {
-		case IEEE80211_HT_IE_CHA_SEC_ABOVE:
-			if (flags & IEEE80211_CHAN_NO_FAT_ABOVE) {
-				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
-				cap &= ~IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		case IEEE80211_HT_IE_CHA_SEC_BELOW:
-			if (flags & IEEE80211_CHAN_NO_FAT_BELOW) {
-				cap &= ~IEEE80211_HT_CAP_SUP_WIDTH;
-				cap &= ~IEEE80211_HT_CAP_SGI_40;
-			}
-			break;
-		}
+	ifsta->last_probe = jiffies;
+	ieee80211_led_assoc(local, 1);
 
-		tmp = cpu_to_le16(cap);
-		pos = skb_put(skb, sizeof(struct ieee80211_ht_cap)+2);
-		*pos++ = WLAN_EID_HT_CAPABILITY;
-		*pos++ = sizeof(struct ieee80211_ht_cap);
-		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
-		memcpy(pos, &tmp, sizeof(u16));
-		pos += sizeof(u16);
-		/* TODO: needs a define here for << 2 */
-		*pos++ = sband->ht_info.ampdu_factor |
-			 (sband->ht_info.ampdu_density << 2);
-		memcpy(pos, sband->ht_info.supp_mcs_set, 16);
-	}
+	sdata->bss_conf.assoc = 1;
+	ieee80211_bss_info_change_notify(sdata, changed);
 
-	kfree(ifsta->assocreq_ies);
-	ifsta->assocreq_ies_len = (skb->data + skb->len) - ies;
-	ifsta->assocreq_ies = kmalloc(ifsta->assocreq_ies_len, GFP_KERNEL);
-	if (ifsta->assocreq_ies)
-		memcpy(ifsta->assocreq_ies, ies, ifsta->assocreq_ies_len);
+	netif_tx_start_all_queues(sdata->dev);
+	netif_carrier_on(sdata->dev);
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_sta_send_apinfo(sdata, ifsta);
 }
 
-
-static void ieee80211_send_deauth(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_if_sta *ifsta, u16 reason)
+static void ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
+	DECLARE_MAC_BUF(mac);
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for deauth "
-		       "frame\n", sdata->dev->name);
+	ifsta->direct_probe_tries++;
+	if (ifsta->direct_probe_tries > IEEE80211_AUTH_MAX_TRIES) {
+		printk(KERN_DEBUG "%s: direct probe to AP %s timed out\n",
+		       sdata->dev->name, print_mac(mac, ifsta->bssid));
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_DEAUTH);
-	skb_put(skb, 2);
-	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
+	printk(KERN_DEBUG "%s: direct probe to AP %s try %d\n",
+			sdata->dev->name, print_mac(mac, ifsta->bssid),
+			ifsta->direct_probe_tries);
 
-	ieee80211_sta_tx(sdata, skb, 0);
-}
+	ifsta->state = IEEE80211_STA_MLME_DIRECT_PROBE;
 
-static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
-{
-	if (!sdata || !sdata->default_key ||
-	    sdata->default_key->conf.alg != ALG_WEP)
-		return 0;
-	return 1;
+	set_bit(IEEE80211_STA_REQ_DIRECT_PROBE, &ifsta->request);
+
+	/* Direct probe is sent to broadcast address as some APs
+	 * will not answer to direct packet in unassociated state.
+	 */
+	ieee80211_send_probe_req(sdata, NULL,
+				 ifsta->ssid, ifsta->ssid_len);
+
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
-static void ieee80211_send_disassoc(struct ieee80211_sub_if_data *sdata,
-				    struct ieee80211_if_sta *ifsta, u16 reason)
+
+static void ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_if_sta *ifsta)
 {
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
+	DECLARE_MAC_BUF(mac);
 
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer for disassoc "
-		       "frame\n", sdata->dev->name);
+	ifsta->auth_tries++;
+	if (ifsta->auth_tries > IEEE80211_AUTH_MAX_TRIES) {
+		printk(KERN_DEBUG "%s: authentication with AP %s"
+		       " timed out\n",
+		       sdata->dev->name, print_mac(mac, ifsta->bssid));
+		ifsta->state = IEEE80211_STA_MLME_DISABLED;
 		return;
 	}
-	skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_DISASSOC);
-	skb_put(skb, 2);
-	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
+	ifsta->state = IEEE80211_STA_MLME_AUTHENTICATE;
+	printk(KERN_DEBUG "%s: authenticate with AP %s\n",
+	       sdata->dev->name, print_mac(mac, ifsta->bssid));
 
-	ieee80211_sta_tx(sdata, skb, 0);
+	ieee80211_send_auth(sdata, ifsta, 1, NULL, 0, 0);
+
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_AUTH_TIMEOUT);
 }
 
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
@@ -865,6 +950,14 @@ static void ieee80211_set_disassoc(struc
 	sta_info_destroy(sta);
 }
 
+static int ieee80211_sta_wep_configured(struct ieee80211_sub_if_data *sdata)
+{
+	if (!sdata || !sdata->default_key ||
+	    sdata->default_key->conf.alg != ALG_WEP)
+		return 0;
+	return 1;
+}
+
 static int ieee80211_privacy_mismatch(struct ieee80211_sub_if_data *sdata,
 				      struct ieee80211_if_sta *ifsta)
 {
@@ -1010,54 +1103,6 @@ static void ieee80211_auth_challenge(str
 			    elems.challenge_len + 2, 1);
 }
 
-static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
-					u8 dialog_token, u16 status, u16 policy,
-					u16 buf_size, u16 timeout)
-{
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u16 capab;
-
-	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
-
-	if (!skb) {
-		printk(KERN_DEBUG "%s: failed to allocate buffer "
-		       "for addba resp frame\n", sdata->dev->name);
-		return;
-	}
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, da, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-	if (sdata->vif.type == IEEE80211_IF_TYPE_AP)
-		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
-	else
-		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-					  IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
-	mgmt->u.action.category = WLAN_CATEGORY_BACK;
-	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
-	mgmt->u.action.u.addba_resp.dialog_token = dialog_token;
-
-	capab = (u16)(policy << 1);	/* bit 1 aggregation policy */
-	capab |= (u16)(tid << 2); 	/* bit 5:2 TID number */
-	capab |= (u16)(buf_size << 6);	/* bit 15:6 max size of aggregation */
-
-	mgmt->u.action.u.addba_resp.capab = cpu_to_le16(capab);
-	mgmt->u.action.u.addba_resp.timeout = cpu_to_le16(timeout);
-	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
-
-	ieee80211_sta_tx(sdata, skb, 0);
-
-	return;
-}
-
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
@@ -1330,53 +1375,6 @@ static void ieee80211_sta_process_delba(
 	rcu_read_unlock();
 }
 
-static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_msrment_ie *request_ie,
-					const u8 *da, const u8 *bssid,
-					u8 dialog_token)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *msr_report;
-
-	skb = dev_alloc_skb(sizeof(*msr_report) + local->hw.extra_tx_headroom +
-				sizeof(struct ieee80211_msrment_ie));
-
-	if (!skb) {
-		printk(KERN_ERR "%s: failed to allocate buffer for "
-				"measurement report frame\n", sdata->dev->name);
-		return;
-	}
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-	msr_report = (struct ieee80211_mgmt *)skb_put(skb, 24);
-	memset(msr_report, 0, 24);
-	memcpy(msr_report->da, da, ETH_ALEN);
-	memcpy(msr_report->sa, sdata->dev->dev_addr, ETH_ALEN);
-	memcpy(msr_report->bssid, bssid, ETH_ALEN);
-	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						IEEE80211_STYPE_ACTION);
-
-	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
-	msr_report->u.action.category = WLAN_CATEGORY_SPECTRUM_MGMT;
-	msr_report->u.action.u.measurement.action_code =
-				WLAN_ACTION_SPCT_MSR_RPRT;
-	msr_report->u.action.u.measurement.dialog_token = dialog_token;
-
-	msr_report->u.action.u.measurement.element_id = WLAN_EID_MEASURE_REPORT;
-	msr_report->u.action.u.measurement.length =
-			sizeof(struct ieee80211_msrment_ie);
-
-	memset(&msr_report->u.action.u.measurement.msr_elem, 0,
-		sizeof(struct ieee80211_msrment_ie));
-	msr_report->u.action.u.measurement.msr_elem.token = request_ie->token;
-	msr_report->u.action.u.measurement.msr_elem.mode |=
-			IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED;
-	msr_report->u.action.u.measurement.msr_elem.type = request_ie->type;
-
-	ieee80211_sta_tx(sdata, skb, 0);
-}
-
 static void ieee80211_sta_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 						struct ieee80211_mgmt *mgmt,
 						size_t len)


