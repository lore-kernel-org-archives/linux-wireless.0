Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945951Ab2K2A0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 19:26:22 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] cfg80211: fix BSS struct IE access races
Date: Thu, 29 Nov 2012 01:26:44 +0100
Message-Id: <1354148804-26678-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_012627_328755_CFFDFE23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a BSS struct is updated, the IEs are currently
overwritten or freed. This can lead to races if some
other CPU is accessing the BSS struct and using the
IEs concurrently.

Fix this by always allocating the IEs in a new struct
that holds the data and length and protecting access
to this new struct with RCU.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/libertas/cfg.c      |   9 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |  34 ++-
 include/net/cfg80211.h                   |  41 ++--
 net/mac80211/mlme.c                      |  80 +++---
 net/wireless/core.h                      |   2 -
 net/wireless/nl80211.c                   |  27 +-
 net/wireless/reg.c                       |   2 +-
 net/wireless/reg.h                       |   2 +-
 net/wireless/scan.c                      | 407 +++++++++++++++----------------
 net/wireless/sme.c                       |  13 +-
 net/wireless/util.c                      |   9 +-
 net/wireless/wext-sme.c                  |   8 +-
 12 files changed, 349 insertions(+), 285 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index ec36868..ec6d5d6 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -298,6 +298,7 @@ static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
 	const u8 *rates_eid, *ext_rates_eid;
 	int n = 0;
 
+	rcu_read_lock();
 	rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
 	ext_rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_EXT_SUPP_RATES);
 
@@ -325,6 +326,7 @@ static int lbs_add_common_rates_tlv(u8 *tlv, struct cfg80211_bss *bss)
 		*tlv++ = 0x96;
 		n = 4;
 	}
+	rcu_read_unlock();
 
 	rate_tlv->header.len = cpu_to_le16(n);
 	return sizeof(rate_tlv->header) + n;
@@ -1140,11 +1142,13 @@ static int lbs_associate(struct lbs_private *priv,
 	cmd->capability = cpu_to_le16(bss->capability);
 
 	/* add SSID TLV */
+	rcu_read_lock();
 	ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
 	if (ssid_eid)
 		pos += lbs_add_ssid_tlv(pos, ssid_eid + 2, ssid_eid[1]);
 	else
 		lbs_deb_assoc("no SSID\n");
+	rcu_read_unlock();
 
 	/* add DS param TLV */
 	if (bss->channel)
@@ -1782,7 +1786,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 	struct cfg80211_ibss_params *params,
 	struct cfg80211_bss *bss)
 {
-	const u8 *rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
+	const u8 *rates_eid;
 	struct cmd_ds_802_11_ad_hoc_join cmd;
 	u8 preamble = RADIO_PREAMBLE_SHORT;
 	int ret = 0;
@@ -1841,6 +1845,8 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 
 	/* set rates to the intersection of our rates and the rates in the
 	   bss */
+	rcu_read_lock();
+	rates_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SUPP_RATES);
 	if (!rates_eid) {
 		lbs_add_rates(cmd.bss.rates);
 	} else {
@@ -1860,6 +1866,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 			}
 		}
 	}
+	rcu_read_unlock();
 
 	/* Only v8 and below support setting this */
 	if (MRVL_FW_MAJOR_REV(priv->fwrelease) <= 8) {
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f92047d..5d7b83e 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -158,13 +158,22 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 			      struct cfg80211_bss *bss,
 			      struct mwifiex_bssdescriptor *bss_desc)
 {
-	int ret;
+	int ret, beacon_ie_len;
 	u8 *beacon_ie;
 	struct mwifiex_bss_priv *bss_priv = (void *)bss->priv;
-	size_t beacon_ie_len = bss->len_information_elements;
+	const struct cfg80211_bss_ies *ies;
+
+	rcu_read_lock();
+	ies = rcu_dereference(bss->ies);
+	if (WARN_ON(!ies)) {
+		/* should never happen */
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	beacon_ie = kmemdup(ies->data, ies->len, GFP_ATOMIC);
+	beacon_ie_len = ies->len;
+	rcu_read_unlock();
 
-	beacon_ie = kmemdup(bss->information_elements, beacon_ie_len,
-			    GFP_KERNEL);
 	if (!beacon_ie) {
 		dev_err(priv->adapter->dev, " failed to alloc beacon_ie\n");
 		return -ENOMEM;
@@ -199,18 +208,23 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 				      struct cfg80211_bss *bss)
 {
-	u8 *country_ie, country_ie_len;
+	const u8 *country_ie;
+	u8 country_ie_len;
 	struct mwifiex_802_11d_domain_reg *domain_info =
 					&priv->adapter->domain_reg;
 
-	country_ie = (u8 *)ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
-
-	if (!country_ie)
+	rcu_read_lock();
+	country_ie = ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+	if (!country_ie) {
+		rcu_read_unlock();
 		return 0;
+	}
 
 	country_ie_len = country_ie[1];
-	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
+	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN) {
+		rcu_read_unlock();
 		return 0;
+	}
 
 	domain_info->country_code[0] = country_ie[2];
 	domain_info->country_code[1] = country_ie[3];
@@ -224,6 +238,8 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 	memcpy((u8 *)domain_info->triplet,
 	       &country_ie[2] + IEEE80211_COUNTRY_STRING_LEN, country_ie_len);
 
+	rcu_read_unlock();
+
 	if (mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11D_DOMAIN_INFO,
 				   HostCmd_ACT_GEN_SET, 0, NULL)) {
 		wiphy_err(priv->adapter->wiphy,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 69a6453..3ba1784 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1206,6 +1206,18 @@ enum cfg80211_signal_type {
 };
 
 /**
+ * struct cfg80211_bss_ie_data - BSS entry IE data
+ * @rcu_head: internal use, for freeing
+ * @len: length of the IEs
+ * @data: IE data
+ */
+struct cfg80211_bss_ies {
+	struct rcu_head rcu_head;
+	int len;
+	u8 data[];
+};
+
+/**
  * struct cfg80211_bss - BSS description
  *
  * This structure describes a BSS (which may also be a mesh network)
@@ -1216,36 +1228,34 @@ enum cfg80211_signal_type {
  * @tsf: timestamp of last received update
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
- * @information_elements: the information elements (Note that there
+ * @ies: the information elements (Note that there
  *	is no guarantee that these are well-formed!); this is a pointer to
  *	either the beacon_ies or proberesp_ies depending on whether Probe
  *	Response frame has been received
- * @len_information_elements: total length of the information elements
  * @beacon_ies: the information elements from the last Beacon frame
- * @len_beacon_ies: total length of the beacon_ies
  * @proberesp_ies: the information elements from the last Probe Response frame
- * @len_proberesp_ies: total length of the proberesp_ies
  * @signal: signal strength value (type depends on the wiphy's signal_type)
  * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
+	u64 tsf;
+
 	struct ieee80211_channel *channel;
 
-	u8 bssid[ETH_ALEN];
-	u64 tsf;
+	const struct cfg80211_bss_ies __rcu *ies;
+	const struct cfg80211_bss_ies __rcu *beacon_ies;
+	const struct cfg80211_bss_ies __rcu *proberesp_ies;
+
+	void (*free_priv)(struct cfg80211_bss *bss);
+
+	s32 signal;
+
 	u16 beacon_interval;
 	u16 capability;
-	u8 *information_elements;
-	size_t len_information_elements;
-	u8 *beacon_ies;
-	size_t len_beacon_ies;
-	u8 *proberesp_ies;
-	size_t len_proberesp_ies;
 
-	s32 signal;
+	u8 bssid[ETH_ALEN];
 
-	void (*free_priv)(struct cfg80211_bss *bss);
 	u8 priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
 
@@ -1253,6 +1263,9 @@ struct cfg80211_bss {
  * ieee80211_bss_get_ie - find IE with given ID
  * @bss: the bss to search
  * @ie: the IE ID
+ *
+ * Note that the return value is an RCU-protected pointer, so
+ * rcu_read_lock() must be held when calling this function.
  * Returns %NULL if not found.
  */
 const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5289f52..95e1f5c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1381,19 +1381,26 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	sdata->u.mgd.flags |= IEEE80211_STA_RESET_SIGNAL_AVE;
 
 	if (sdata->vif.p2p) {
-		u8 noa[2];
-		int ret;
+		const struct cfg80211_bss_ies *ies;
 
-		ret = cfg80211_get_p2p_attr(cbss->information_elements,
-					    cbss->len_information_elements,
-					    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
-					    noa, sizeof(noa));
-		if (ret >= 2) {
-			bss_conf->p2p_oppps = noa[1] & 0x80;
-			bss_conf->p2p_ctwindow = noa[1] & 0x7f;
-			bss_info_changed |= BSS_CHANGED_P2P_PS;
-			sdata->u.mgd.p2p_noa_index = noa[0];
+		rcu_read_lock();
+		ies = rcu_dereference(cbss->ies);
+		if (ies) {
+			u8 noa[2];
+			int ret;
+
+			ret = cfg80211_get_p2p_attr(
+					ies->data, ies->len,
+					IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+					noa, sizeof(noa));
+			if (ret >= 2) {
+				bss_conf->p2p_oppps = noa[1] & 0x80;
+				bss_conf->p2p_ctwindow = noa[1] & 0x7f;
+				bss_info_changed |= BSS_CHANGED_P2P_PS;
+				sdata->u.mgd.p2p_noa_index = noa[0];
+			}
 		}
+		rcu_read_unlock();
 	}
 
 	/* just to be sure */
@@ -1658,6 +1665,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	} else {
 		int ssid_len;
 
+		rcu_read_lock();
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 		if (WARN_ON_ONCE(ssid == NULL))
 			ssid_len = 0;
@@ -1667,6 +1675,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid_len, NULL,
 					 0, (u32) -1, true, false,
 					 ifmgd->associated->channel, false);
+		rcu_read_unlock();
 	}
 
 	ifmgd->probe_timeout = jiffies + msecs_to_jiffies(probe_wait_ms);
@@ -1762,6 +1771,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 	else
 		return NULL;
 
+	rcu_read_lock();
 	ssid = ieee80211_bss_get_ie(cbss, WLAN_EID_SSID);
 	if (WARN_ON_ONCE(ssid == NULL))
 		ssid_len = 0;
@@ -1772,6 +1782,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 					(u32) -1, cbss->channel,
 					ssid + 2, ssid_len,
 					NULL, 0, true);
+	rcu_read_unlock();
 
 	return skb;
 }
@@ -2884,9 +2895,12 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 			   auth_data->bss->bssid, auth_data->tries,
 			   IEEE80211_AUTH_MAX_TRIES);
 
+		rcu_read_lock();
 		ssidie = ieee80211_bss_get_ie(auth_data->bss, WLAN_EID_SSID);
-		if (!ssidie)
+		if (!ssidie) {
+			rcu_read_unlock();
 			return -EINVAL;
+		}
 		/*
 		 * Direct probe is sent to broadcast address as some APs
 		 * will not answer to direct packet in unassociated state.
@@ -2894,6 +2908,7 @@ static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
 		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
 					 NULL, 0, (u32) -1, true, false,
 					 auth_data->bss->channel, false);
+		rcu_read_unlock();
 	}
 
 	auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
@@ -3430,9 +3445,7 @@ static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_HT)
 		return chains;
 
-	ht_cap_ie = cfg80211_find_ie(WLAN_EID_HT_CAPABILITY,
-				     cbss->information_elements,
-				     cbss->len_information_elements);
+	ht_cap_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_CAPABILITY);
 	if (ht_cap_ie && ht_cap_ie[1] >= sizeof(*ht_cap)) {
 		ht_cap = (void *)(ht_cap_ie + 2);
 		chains = ieee80211_mcs_to_chains(&ht_cap->mcs);
@@ -3445,9 +3458,7 @@ static u8 ieee80211_ht_vht_rx_chains(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->flags & IEEE80211_STA_DISABLE_VHT)
 		return chains;
 
-	vht_cap_ie = cfg80211_find_ie(WLAN_EID_VHT_CAPABILITY,
-				      cbss->information_elements,
-				      cbss->len_information_elements);
+	vht_cap_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_VHT_CAPABILITY);
 	if (vht_cap_ie && vht_cap_ie[1] >= sizeof(*vht_cap)) {
 		u8 nss;
 		u16 tx_mcs_map;
@@ -3483,13 +3494,13 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 			  IEEE80211_STA_DISABLE_80P80MHZ |
 			  IEEE80211_STA_DISABLE_160MHZ);
 
+	rcu_read_lock();
+
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_HT) &&
 	    sband->ht_cap.ht_supported) {
 		const u8 *ht_oper_ie;
 
-		ht_oper_ie = cfg80211_find_ie(WLAN_EID_HT_OPERATION,
-					      cbss->information_elements,
-					      cbss->len_information_elements);
+		ht_oper_ie = ieee80211_bss_get_ie(cbss, WLAN_EID_HT_OPERATION);
 		if (ht_oper_ie && ht_oper_ie[1] >= sizeof(*ht_oper))
 			ht_oper = (void *)(ht_oper_ie + 2);
 	}
@@ -3498,9 +3509,8 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	    sband->vht_cap.vht_supported) {
 		const u8 *vht_oper_ie;
 
-		vht_oper_ie = cfg80211_find_ie(WLAN_EID_VHT_OPERATION,
-					       cbss->information_elements,
-					       cbss->len_information_elements);
+		vht_oper_ie = ieee80211_bss_get_ie(cbss,
+						   WLAN_EID_VHT_OPERATION);
 		if (vht_oper_ie && vht_oper_ie[1] >= sizeof(*vht_oper))
 			vht_oper = (void *)(vht_oper_ie + 2);
 		if (vht_oper && !ht_oper) {
@@ -3520,6 +3530,8 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	sdata->needed_rx_chains = min(ieee80211_ht_vht_rx_chains(sdata, cbss),
 				      local->rx_chains);
 
+	rcu_read_unlock();
+
 	/* will change later if needed */
 	sdata->smps_mode = IEEE80211_SMPS_OFF;
 
@@ -3760,14 +3772,21 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	const u8 *ssidie, *ht_ie;
 	int i, err;
 
-	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	if (!ssidie)
-		return -EINVAL;
-
 	assoc_data = kzalloc(sizeof(*assoc_data) + req->ie_len, GFP_KERNEL);
 	if (!assoc_data)
 		return -ENOMEM;
 
+	rcu_read_lock();
+	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
+	if (!ssidie) {
+		rcu_read_unlock();
+		kfree(assoc_data);
+		return -EINVAL;
+	}
+	memcpy(assoc_data->ssid, ssidie + 2, ssidie[1]);
+	assoc_data->ssid_len = ssidie[1];
+	rcu_read_unlock();
+
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated)
@@ -3862,12 +3881,14 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	assoc_data->supp_rates = bss->supp_rates;
 	assoc_data->supp_rates_len = bss->supp_rates_len;
 
+	rcu_read_lock();
 	ht_ie = ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
 	if (ht_ie && ht_ie[1] >= sizeof(struct ieee80211_ht_operation))
 		assoc_data->ap_ht_param =
 			((struct ieee80211_ht_operation *)(ht_ie + 2))->ht_param;
 	else
 		ifmgd->flags |= IEEE80211_STA_DISABLE_HT;
+	rcu_read_unlock();
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
@@ -3878,9 +3899,6 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
 	}
 
-	memcpy(assoc_data->ssid, ssidie + 2, ssidie[1]);
-	assoc_data->ssid_len = ssidie[1];
-
 	if (req->prev_bssid)
 		memcpy(assoc_data->prev_bssid, req->prev_bssid, ETH_ALEN);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6183a0d..3563097 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -138,8 +138,6 @@ struct cfg80211_internal_bss {
 	unsigned long ts;
 	struct kref ref;
 	atomic_t hold;
-	bool beacon_ies_allocated;
-	bool proberesp_ies_allocated;
 
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf5b66d..9d31090 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4858,6 +4858,7 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			    struct cfg80211_internal_bss *intbss)
 {
 	struct cfg80211_bss *res = &intbss->pub;
+	const struct cfg80211_bss_ies *ies;
 	void *hdr;
 	struct nlattr *bss;
 
@@ -4878,16 +4879,24 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 	if (!bss)
 		goto nla_put_failure;
 	if ((!is_zero_ether_addr(res->bssid) &&
-	     nla_put(msg, NL80211_BSS_BSSID, ETH_ALEN, res->bssid)) ||
-	    (res->information_elements && res->len_information_elements &&
-	     nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
-		     res->len_information_elements,
-		     res->information_elements)) ||
-	    (res->beacon_ies && res->len_beacon_ies &&
-	     res->beacon_ies != res->information_elements &&
-	     nla_put(msg, NL80211_BSS_BEACON_IES,
-		     res->len_beacon_ies, res->beacon_ies)))
+	     nla_put(msg, NL80211_BSS_BSSID, ETH_ALEN, res->bssid)))
 		goto nla_put_failure;
+
+	rcu_read_lock();
+	ies = rcu_dereference(res->ies);
+	if (ies && ies->len && nla_put(msg, NL80211_BSS_INFORMATION_ELEMENTS,
+				       ies->len, ies->data)) {
+		rcu_read_unlock();
+		goto nla_put_failure;
+	}
+	ies = rcu_dereference(res->beacon_ies);
+	if (ies && ies->len && nla_put(msg, NL80211_BSS_BEACON_IES,
+				       ies->len, ies->data)) {
+		rcu_read_unlock();
+		goto nla_put_failure;
+	}
+	rcu_read_unlock();
+
 	if (res->tsf &&
 	    nla_put_u64(msg, NL80211_BSS_TSF, res->tsf))
 		goto nla_put_failure;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index bcc7d7e..b6c7ea6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1797,7 +1797,7 @@ EXPORT_SYMBOL(regulatory_hint);
  */
 void regulatory_hint_11d(struct wiphy *wiphy,
 			 enum ieee80211_band band,
-			 u8 *country_ie,
+			 const u8 *country_ie,
 			 u8 country_ie_len)
 {
 	char alpha2[2];
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f023c8a..4c0a32f 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -81,7 +81,7 @@ int regulatory_hint_found_beacon(struct wiphy *wiphy,
  */
 void regulatory_hint_11d(struct wiphy *wiphy,
 			 enum ieee80211_band band,
-			 u8 *country_ie,
+			 const u8 *country_ie,
 			 u8 country_ie_len);
 
 /**
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 57855bc..e6c79c7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -23,6 +23,7 @@
 
 static void bss_release(struct kref *ref)
 {
+	struct cfg80211_bss_ies *ies;
 	struct cfg80211_internal_bss *bss;
 
 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
@@ -33,10 +34,12 @@ static void bss_release(struct kref *ref)
 	if (bss->pub.free_priv)
 		bss->pub.free_priv(&bss->pub);
 
-	if (bss->beacon_ies_allocated)
-		kfree(bss->pub.beacon_ies);
-	if (bss->proberesp_ies_allocated)
-		kfree(bss->pub.proberesp_ies);
+	ies = (void *)rcu_access_pointer(bss->pub.beacon_ies);
+	if (ies)
+		kfree_rcu(ies, rcu_head);
+	ies = (void *)rcu_access_pointer(bss->pub.proberesp_ies);
+	if (ies)
+		kfree_rcu(ies, rcu_head);
 
 	kfree(bss);
 }
@@ -288,7 +291,7 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
 }
 EXPORT_SYMBOL(cfg80211_find_vendor_ie);
 
-static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
+static int cmp_ies(u8 num, const u8 *ies1, int len1, const u8 *ies2, int len2)
 {
 	const u8 *ie1 = cfg80211_find_ie(num, ies1, len1);
 	const u8 *ie2 = cfg80211_find_ie(num, ies2, len2);
@@ -311,6 +314,7 @@ static int cmp_ies(u8 num, u8 *ies1, size_t len1, u8 *ies2, size_t len2)
 static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 		   const u8 *ssid, size_t ssid_len)
 {
+	const struct cfg80211_bss_ies *ies;
 	const u8 *ssidie;
 
 	if (bssid && !ether_addr_equal(a->bssid, bssid))
@@ -319,9 +323,10 @@ static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 	if (!ssid)
 		return true;
 
-	ssidie = cfg80211_find_ie(WLAN_EID_SSID,
-				  a->information_elements,
-				  a->len_information_elements);
+	ies = rcu_access_pointer(a->ies);
+	if (!ies)
+		return false;
+	ssidie = cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
 	if (!ssidie)
 		return false;
 	if (ssidie[1] != ssid_len)
@@ -331,20 +336,21 @@ static bool is_bss(struct cfg80211_bss *a, const u8 *bssid,
 
 static bool is_mesh_bss(struct cfg80211_bss *a)
 {
+	const struct cfg80211_bss_ies *ies;
 	const u8 *ie;
 
 	if (!WLAN_CAPABILITY_IS_STA_BSS(a->capability))
 		return false;
 
-	ie = cfg80211_find_ie(WLAN_EID_MESH_ID,
-			      a->information_elements,
-			      a->len_information_elements);
+	ies = rcu_access_pointer(a->ies);
+	if (!ies)
+		return false;
+
+	ie = cfg80211_find_ie(WLAN_EID_MESH_ID, ies->data, ies->len);
 	if (!ie)
 		return false;
 
-	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG,
-			      a->information_elements,
-			      a->len_information_elements);
+	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG, ies->data, ies->len);
 	if (!ie)
 		return false;
 
@@ -355,14 +361,17 @@ static bool is_mesh(struct cfg80211_bss *a,
 		    const u8 *meshid, size_t meshidlen,
 		    const u8 *meshcfg)
 {
+	const struct cfg80211_bss_ies *ies;
 	const u8 *ie;
 
 	if (!WLAN_CAPABILITY_IS_STA_BSS(a->capability))
 		return false;
 
-	ie = cfg80211_find_ie(WLAN_EID_MESH_ID,
-			      a->information_elements,
-			      a->len_information_elements);
+	ies = rcu_access_pointer(a->ies);
+	if (!ies)
+		return false;
+
+	ie = cfg80211_find_ie(WLAN_EID_MESH_ID, ies->data, ies->len);
 	if (!ie)
 		return false;
 	if (ie[1] != meshidlen)
@@ -370,9 +379,7 @@ static bool is_mesh(struct cfg80211_bss *a,
 	if (memcmp(ie + 2, meshid, meshidlen))
 		return false;
 
-	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG,
-			      a->information_elements,
-			      a->len_information_elements);
+	ie = cfg80211_find_ie(WLAN_EID_MESH_CONFIG, ies->data, ies->len);
 	if (!ie)
 		return false;
 	if (ie[1] != sizeof(struct ieee80211_meshconf_ie))
@@ -389,24 +396,28 @@ static bool is_mesh(struct cfg80211_bss *a,
 
 static int cmp_bss_core(struct cfg80211_bss *a, struct cfg80211_bss *b)
 {
+	const struct cfg80211_bss_ies *a_ies, *b_ies;
 	int r;
 
 	if (a->channel != b->channel)
 		return b->channel->center_freq - a->channel->center_freq;
 
 	if (is_mesh_bss(a) && is_mesh_bss(b)) {
+		a_ies = rcu_access_pointer(a->ies);
+		if (!a_ies)
+			return -1;
+		b_ies = rcu_access_pointer(b->ies);
+		if (!b_ies)
+			return 1;
+
 		r = cmp_ies(WLAN_EID_MESH_ID,
-			    a->information_elements,
-			    a->len_information_elements,
-			    b->information_elements,
-			    b->len_information_elements);
+			    a_ies->data, a_ies->len,
+			    b_ies->data, b_ies->len);
 		if (r)
 			return r;
 		return cmp_ies(WLAN_EID_MESH_CONFIG,
-			       a->information_elements,
-			       a->len_information_elements,
-			       b->information_elements,
-			       b->len_information_elements);
+			       a_ies->data, a_ies->len,
+			       b_ies->data, b_ies->len);
 	}
 
 	/*
@@ -419,21 +430,28 @@ static int cmp_bss_core(struct cfg80211_bss *a, struct cfg80211_bss *b)
 static int cmp_bss(struct cfg80211_bss *a,
 		   struct cfg80211_bss *b)
 {
+	const struct cfg80211_bss_ies *a_ies, *b_ies;
 	int r;
 
 	r = cmp_bss_core(a, b);
 	if (r)
 		return r;
 
+	a_ies = rcu_access_pointer(a->ies);
+	if (!a_ies)
+		return -1;
+	b_ies = rcu_access_pointer(b->ies);
+	if (!b_ies)
+		return 1;
+
 	return cmp_ies(WLAN_EID_SSID,
-		       a->information_elements,
-		       a->len_information_elements,
-		       b->information_elements,
-		       b->len_information_elements);
+		       a_ies->data, a_ies->len,
+		       b_ies->data, b_ies->len);
 }
 
 static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 {
+	const struct cfg80211_bss_ies *a_ies, *b_ies;
 	const u8 *ie1;
 	const u8 *ie2;
 	int i;
@@ -443,12 +461,15 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
 	if (r)
 		return r;
 
-	ie1 = cfg80211_find_ie(WLAN_EID_SSID,
-			       a->information_elements,
-			       a->len_information_elements);
-	ie2 = cfg80211_find_ie(WLAN_EID_SSID,
-			       b->information_elements,
-			       b->len_information_elements);
+	a_ies = rcu_access_pointer(a->ies);
+	if (!a_ies)
+		return -1;
+	b_ies = rcu_access_pointer(b->ies);
+	if (!b_ies)
+		return 1;
+
+	ie1 = cfg80211_find_ie(WLAN_EID_SSID, a_ies->data, a_ies->len);
+	ie2 = cfg80211_find_ie(WLAN_EID_SSID, b_ies->data, b_ies->len);
 
 	/* Key comparator must use same algorithm in any rb-tree
 	 * search function (order is important), otherwise ordering
@@ -623,126 +644,84 @@ static void
 copy_hidden_ies(struct cfg80211_internal_bss *res,
 		struct cfg80211_internal_bss *hidden)
 {
-	if (unlikely(res->pub.beacon_ies))
-		return;
-	if (WARN_ON(!hidden->pub.beacon_ies))
+	const struct cfg80211_bss_ies *ies;
+
+	if (rcu_access_pointer(res->pub.beacon_ies))
 		return;
 
-	res->pub.beacon_ies = kmalloc(hidden->pub.len_beacon_ies, GFP_ATOMIC);
-	if (unlikely(!res->pub.beacon_ies))
+	ies = rcu_access_pointer(hidden->pub.beacon_ies);
+	if (WARN_ON(!ies))
 		return;
 
-	res->beacon_ies_allocated = true;
-	res->pub.len_beacon_ies = hidden->pub.len_beacon_ies;
-	memcpy(res->pub.beacon_ies, hidden->pub.beacon_ies,
-	       res->pub.len_beacon_ies);
+	ies = kmemdup(ies, sizeof(*ies) + ies->len, GFP_ATOMIC);
+	if (unlikely(!ies))
+		return;
+	rcu_assign_pointer(res->pub.beacon_ies, ies);
 }
 
 static struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *dev,
-		    struct cfg80211_internal_bss *res)
+		    struct cfg80211_internal_bss *tmp)
 {
 	struct cfg80211_internal_bss *found = NULL;
 
-	/*
-	 * The reference to "res" is donated to this function.
-	 */
-
-	if (WARN_ON(!res->pub.channel)) {
-		kref_put(&res->ref, bss_release);
+	if (WARN_ON(!tmp->pub.channel))
 		return NULL;
-	}
 
-	res->ts = jiffies;
+	tmp->ts = jiffies;
 
 	spin_lock_bh(&dev->bss_lock);
 
-	found = rb_find_bss(dev, res);
+	if (WARN_ON(!rcu_access_pointer(tmp->pub.ies))) {
+		spin_unlock_bh(&dev->bss_lock);
+		return NULL;
+	}
+
+	found = rb_find_bss(dev, tmp);
 
 	if (found) {
-		found->pub.beacon_interval = res->pub.beacon_interval;
-		found->pub.tsf = res->pub.tsf;
-		found->pub.signal = res->pub.signal;
-		found->pub.capability = res->pub.capability;
-		found->ts = res->ts;
+		found->pub.beacon_interval = tmp->pub.beacon_interval;
+		found->pub.tsf = tmp->pub.tsf;
+		found->pub.signal = tmp->pub.signal;
+		found->pub.capability = tmp->pub.capability;
+		found->ts = tmp->ts;
 
 		/* Update IEs */
-		if (res->pub.proberesp_ies) {
-			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
-			size_t ielen = res->pub.len_proberesp_ies;
-
-			if (found->pub.proberesp_ies &&
-			    !found->proberesp_ies_allocated &&
-			    ksize(found) >= used + ielen) {
-				memcpy(found->pub.proberesp_ies,
-				       res->pub.proberesp_ies, ielen);
-				found->pub.len_proberesp_ies = ielen;
-			} else {
-				u8 *ies = found->pub.proberesp_ies;
-
-				if (found->proberesp_ies_allocated)
-					ies = krealloc(ies, ielen, GFP_ATOMIC);
-				else
-					ies = kmalloc(ielen, GFP_ATOMIC);
-
-				if (ies) {
-					memcpy(ies, res->pub.proberesp_ies,
-					       ielen);
-					found->proberesp_ies_allocated = true;
-					found->pub.proberesp_ies = ies;
-					found->pub.len_proberesp_ies = ielen;
-				}
-			}
+		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
+			const struct cfg80211_bss_ies *old;
 
+			old = rcu_access_pointer(found->pub.proberesp_ies);
+
+			rcu_assign_pointer(found->pub.proberesp_ies,
+					   tmp->pub.proberesp_ies);
 			/* Override possible earlier Beacon frame IEs */
-			found->pub.information_elements =
-				found->pub.proberesp_ies;
-			found->pub.len_information_elements =
-				found->pub.len_proberesp_ies;
-		}
+			rcu_assign_pointer(found->pub.ies,
+					   tmp->pub.proberesp_ies);
+			if (old)
+				kfree_rcu((struct cfg80211_bss_ies *)old,
+					  rcu_head);
+		} else if (rcu_access_pointer(tmp->pub.beacon_ies)) {
+			const struct cfg80211_bss_ies *old, *ies;
 
-		if (res->pub.beacon_ies) {
-			size_t used = dev->wiphy.bss_priv_size + sizeof(*res);
-			size_t ielen = res->pub.len_beacon_ies;
-			bool information_elements_is_beacon_ies =
-				(found->pub.information_elements ==
-				 found->pub.beacon_ies);
-
-			if (found->pub.beacon_ies &&
-			    !found->beacon_ies_allocated &&
-			    ksize(found) >= used + ielen) {
-				memcpy(found->pub.beacon_ies,
-				       res->pub.beacon_ies, ielen);
-				found->pub.len_beacon_ies = ielen;
-			} else {
-				u8 *ies = found->pub.beacon_ies;
-
-				if (found->beacon_ies_allocated)
-					ies = krealloc(ies, ielen, GFP_ATOMIC);
-				else
-					ies = kmalloc(ielen, GFP_ATOMIC);
-
-				if (ies) {
-					memcpy(ies, res->pub.beacon_ies,
-					       ielen);
-					found->beacon_ies_allocated = true;
-					found->pub.beacon_ies = ies;
-					found->pub.len_beacon_ies = ielen;
-				}
-			}
+			old = rcu_access_pointer(found->pub.beacon_ies);
+			ies = rcu_access_pointer(found->pub.ies);
+
+			rcu_assign_pointer(found->pub.beacon_ies,
+					   tmp->pub.beacon_ies);
 
 			/* Override IEs if they were from a beacon before */
-			if (information_elements_is_beacon_ies) {
-				found->pub.information_elements =
-					found->pub.beacon_ies;
-				found->pub.len_information_elements =
-					found->pub.len_beacon_ies;
-			}
-		}
+			if (old == ies)
+				rcu_assign_pointer(found->pub.ies,
+						   tmp->pub.beacon_ies);
 
-		kref_put(&res->ref, bss_release);
+			if (old)
+				kfree_rcu((struct cfg80211_bss_ies *)old,
+					  rcu_head);
+		}
 	} else {
+		struct cfg80211_internal_bss *new;
 		struct cfg80211_internal_bss *hidden;
+		struct cfg80211_bss_ies *ies;
 
 		/* First check if the beacon is a probe response from
 		 * a hidden bss. If so, copy beacon ies (with nullified
@@ -753,14 +732,32 @@ cfg80211_bss_update(struct cfg80211_registered_device *dev,
 		/* TODO: The code is not trying to update existing probe
 		 * response bss entries when beacon ies are
 		 * getting changed. */
-		hidden = rb_find_hidden_bss(dev, res);
+		hidden = rb_find_hidden_bss(dev, tmp);
 		if (hidden)
-			copy_hidden_ies(res, hidden);
-
-		/* this "consumes" the reference */
-		list_add_tail(&res->list, &dev->bss_list);
-		rb_insert_bss(dev, res);
-		found = res;
+			copy_hidden_ies(tmp, hidden);
+
+		/*
+		 * create a copy -- the "res" variable that is passed in
+		 * is allocated on the stack since it's not needed in the
+		 * more common case of an update
+		 */
+		new = kzalloc(sizeof(*new) + dev->wiphy.bss_priv_size,
+			      GFP_ATOMIC);
+		if (!new) {
+			ies = (void *)rcu_dereference(tmp->pub.beacon_ies);
+			if (ies)
+				kfree_rcu(ies, rcu_head);
+			ies = (void *)rcu_dereference(tmp->pub.proberesp_ies);
+			if (ies)
+				kfree_rcu(ies, rcu_head);
+			spin_unlock_bh(&dev->bss_lock);
+			return NULL;
+		}
+		memcpy(new, tmp, sizeof(*new));
+		kref_init(&new->ref);
+		list_add_tail(&new->list, &dev->bss_list);
+		rb_insert_bss(dev, new);
+		found = new;
 	}
 
 	dev->bss_generation++;
@@ -809,14 +806,12 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 		    u16 beacon_interval, const u8 *ie, size_t ielen,
 		    s32 signal, gfp_t gfp)
 {
-	struct cfg80211_internal_bss *res;
-	size_t privsz;
+	struct cfg80211_bss_ies *ies;
+	struct cfg80211_internal_bss tmp = {}, *res;
 
 	if (WARN_ON(!wiphy))
 		return NULL;
 
-	privsz = wiphy->bss_priv_size;
-
 	if (WARN_ON(wiphy->signal_type == CFG80211_SIGNAL_TYPE_UNSPEC &&
 			(signal < 0 || signal > 100)))
 		return NULL;
@@ -825,36 +820,33 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	if (!channel)
 		return NULL;
 
-	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
-	if (!res)
-		return NULL;
-
-	memcpy(res->pub.bssid, bssid, ETH_ALEN);
-	res->pub.channel = channel;
-	res->pub.signal = signal;
-	res->pub.tsf = tsf;
-	res->pub.beacon_interval = beacon_interval;
-	res->pub.capability = capability;
+	memcpy(tmp.pub.bssid, bssid, ETH_ALEN);
+	tmp.pub.channel = channel;
+	tmp.pub.signal = signal;
+	tmp.pub.tsf = tsf;
+	tmp.pub.beacon_interval = beacon_interval;
+	tmp.pub.capability = capability;
 	/*
 	 * Since we do not know here whether the IEs are from a Beacon or Probe
 	 * Response frame, we need to pick one of the options and only use it
 	 * with the driver that does not provide the full Beacon/Probe Response
 	 * frame. Use Beacon frame pointer to avoid indicating that this should
-	 * override the information_elements pointer should we have received an
-	 * earlier indication of Probe Response data.
+	 * override the iies pointer should we have received an earlier
+	 * indication of Probe Response data.
 	 *
 	 * The initial buffer for the IEs is allocated with the BSS entry and
 	 * is located after the private area.
 	 */
-	res->pub.beacon_ies = (u8 *)res + sizeof(*res) + privsz;
-	memcpy(res->pub.beacon_ies, ie, ielen);
-	res->pub.len_beacon_ies = ielen;
-	res->pub.information_elements = res->pub.beacon_ies;
-	res->pub.len_information_elements = res->pub.len_beacon_ies;
+	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	if (!ies)
+		return NULL;
+	ies->len = ielen;
+	memcpy(ies->data, ie, ielen);
 
-	kref_init(&res->ref);
+	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
+	rcu_assign_pointer(tmp.pub.ies, ies);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res);
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp);
 	if (!res)
 		return NULL;
 
@@ -873,10 +865,10 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  struct ieee80211_mgmt *mgmt, size_t len,
 			  s32 signal, gfp_t gfp)
 {
-	struct cfg80211_internal_bss *res;
+	struct cfg80211_internal_bss tmp = {}, *res;
+	struct cfg80211_bss_ies *ies;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	size_t privsz;
 
 	BUILD_BUG_ON(offsetof(struct ieee80211_mgmt, u.probe_resp.variable) !=
 			offsetof(struct ieee80211_mgmt, u.beacon.variable));
@@ -896,45 +888,31 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (WARN_ON(len < offsetof(struct ieee80211_mgmt, u.probe_resp.variable)))
 		return NULL;
 
-	privsz = wiphy->bss_priv_size;
-
 	channel = cfg80211_get_bss_channel(wiphy, mgmt->u.beacon.variable,
 					   ielen, channel);
 	if (!channel)
 		return NULL;
 
-	res = kzalloc(sizeof(*res) + privsz + ielen, gfp);
-	if (!res)
+	ies = kmalloc(sizeof(*ies) + ielen, gfp);
+	if (!ies)
 		return NULL;
+	ies->len = ielen;
+	memcpy(ies->data, mgmt->u.probe_resp.variable, ielen);
 
-	memcpy(res->pub.bssid, mgmt->bssid, ETH_ALEN);
-	res->pub.channel = channel;
-	res->pub.signal = signal;
-	res->pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
-	res->pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
-	res->pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
-	/*
-	 * The initial buffer for the IEs is allocated with the BSS entry and
-	 * is located after the private area.
-	 */
-	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
-		res->pub.proberesp_ies = (u8 *) res + sizeof(*res) + privsz;
-		memcpy(res->pub.proberesp_ies, mgmt->u.probe_resp.variable,
-		       ielen);
-		res->pub.len_proberesp_ies = ielen;
-		res->pub.information_elements = res->pub.proberesp_ies;
-		res->pub.len_information_elements = res->pub.len_proberesp_ies;
-	} else {
-		res->pub.beacon_ies = (u8 *) res + sizeof(*res) + privsz;
-		memcpy(res->pub.beacon_ies, mgmt->u.beacon.variable, ielen);
-		res->pub.len_beacon_ies = ielen;
-		res->pub.information_elements = res->pub.beacon_ies;
-		res->pub.len_information_elements = res->pub.len_beacon_ies;
-	}
-
-	kref_init(&res->ref);
-
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res);
+	if (ieee80211_is_probe_resp(mgmt->frame_control))
+		rcu_assign_pointer(tmp.pub.proberesp_ies, ies);
+	else
+		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
+	rcu_assign_pointer(tmp.pub.ies, ies);
+	
+	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
+	tmp.pub.channel = channel;
+	tmp.pub.signal = signal;
+	tmp.pub.tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
+	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
+	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+
+	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp);
 	if (!res)
 		return NULL;
 
@@ -1126,22 +1104,18 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
 
 static void ieee80211_scan_add_ies(struct iw_request_info *info,
-				   struct cfg80211_bss *bss,
+				   const struct cfg80211_bss_ies *ies,
 				   char **current_ev, char *end_buf)
 {
-	u8 *pos, *end, *next;
+	const u8 *pos, *end, *next;
 	struct iw_event iwe;
 
-	if (!bss->information_elements ||
-	    !bss->len_information_elements)
-		return;
-
 	/*
 	 * If needed, fragment the IEs buffer (at IE boundaries) into short
 	 * enough fragments to fit into IW_GENERIC_IE_MAX octet messages.
 	 */
-	pos = bss->information_elements;
-	end = pos + bss->len_information_elements;
+	pos = ies->data;
+	end = pos + ies->len;
 
 	while (end - pos > IW_GENERIC_IE_MAX) {
 		next = pos + 2 + pos[1];
@@ -1152,7 +1126,8 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = next - pos;
 		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
+						   end_buf, &iwe,
+						   (void *)pos);
 
 		pos = next;
 	}
@@ -1162,7 +1137,8 @@ static void ieee80211_scan_add_ies(struct iw_request_info *info,
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = end - pos;
 		*current_ev = iwe_stream_add_point(info, *current_ev,
-						   end_buf, &iwe, pos);
+						   end_buf, &iwe,
+						   (void *)pos);
 	}
 }
 
@@ -1181,10 +1157,11 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	      struct cfg80211_internal_bss *bss, char *current_ev,
 	      char *end_buf)
 {
+	const struct cfg80211_bss_ies *ies;
 	struct iw_event iwe;
+	const u8 *ie;
 	u8 *buf, *cfg, *p;
-	u8 *ie = bss->pub.information_elements;
-	int rem = bss->pub.len_information_elements, i, sig;
+	int rem, i, sig;
 	bool ismesh = false;
 
 	memset(&iwe, 0, sizeof(iwe));
@@ -1249,6 +1226,15 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 	current_ev = iwe_stream_add_point(info, current_ev, end_buf,
 					  &iwe, "");
 
+	rcu_read_lock();
+	ies = rcu_dereference(bss->pub.ies);
+	if (ies) {
+		rem = ies->len;
+		ie = ies->data;
+	} else {
+		rem = 0;
+	}
+
 	while (rem >= 2) {
 		/* invalid data */
 		if (ie[1] > rem - 2)
@@ -1261,7 +1247,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			iwe.u.data.length = ie[1];
 			iwe.u.data.flags = 1;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-							  &iwe, ie + 2);
+							  &iwe, (u8 *)ie + 2);
 			break;
 		case WLAN_EID_MESH_ID:
 			memset(&iwe, 0, sizeof(iwe));
@@ -1269,7 +1255,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			iwe.u.data.length = ie[1];
 			iwe.u.data.flags = 1;
 			current_ev = iwe_stream_add_point(info, current_ev, end_buf,
-							  &iwe, ie + 2);
+							  &iwe, (u8 *)ie + 2);
 			break;
 		case WLAN_EID_MESH_CONFIG:
 			ismesh = true;
@@ -1278,7 +1264,7 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 			buf = kmalloc(50, GFP_ATOMIC);
 			if (!buf)
 				break;
-			cfg = ie + 2;
+			cfg = (u8 *)ie + 2;
 			memset(&iwe, 0, sizeof(iwe));
 			iwe.cmd = IWEVCUSTOM;
 			sprintf(buf, "Mesh Network Path Selection Protocol ID: "
@@ -1376,7 +1362,8 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 		kfree(buf);
 	}
 
-	ieee80211_scan_add_ies(info, &bss->pub, &current_ev, end_buf);
+	ieee80211_scan_add_ies(info, ies, &current_ev, end_buf);
+	rcu_read_unlock();
 
 	return current_ev;
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c749002..f2431e4 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -417,7 +417,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 *country_ie;
+	const u8 *country_ie;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
@@ -501,7 +501,15 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	wdev->sme_state = CFG80211_SME_CONNECTED;
 	cfg80211_upload_connect_keys(wdev);
 
-	country_ie = (u8 *) ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+	rcu_read_lock();
+	country_ie = ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+	if (!country_ie) {
+		rcu_read_unlock();
+		return;
+	}
+
+	country_ie = kmemdup(country_ie, 2 + country_ie[1], GFP_ATOMIC);
+	rcu_read_unlock();
 
 	if (!country_ie)
 		return;
@@ -515,6 +523,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			    bss->channel->band,
 			    country_ie + 2,
 			    country_ie[1]);
+	kfree(country_ie);
 }
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index feb6eebbb..ba7def4 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -688,10 +688,13 @@ EXPORT_SYMBOL(cfg80211_classify8021d);
 
 const u8 *ieee80211_bss_get_ie(struct cfg80211_bss *bss, u8 ie)
 {
-	if (bss->information_elements == NULL)
+	const struct cfg80211_bss_ies *ies;
+
+	ies = rcu_dereference(bss->ies);
+	if (!ies)
 		return NULL;
-	return cfg80211_find_ie(ie, bss->information_elements,
-				 bss->len_information_elements);
+
+	return cfg80211_find_ie(ie, ies->data, ies->len);
 }
 EXPORT_SYMBOL(ieee80211_bss_get_ie);
 
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 873af63..fb9622f 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -242,13 +242,17 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 
 	wdev_lock(wdev);
 	if (wdev->current_bss) {
-		const u8 *ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
-						    WLAN_EID_SSID);
+		const u8 *ie;
+
+		rcu_read_lock();
+		ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
+					  WLAN_EID_SSID);
 		if (ie) {
 			data->flags = 1;
 			data->length = ie[1];
 			memcpy(ssid, ie + 2, data->length);
 		}
+		rcu_read_unlock();
 	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
 		data->flags = 1;
 		data->length = wdev->wext.connect.ssid_len;
-- 
1.8.0

