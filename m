Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2ATM7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:59:01 -0500
Message-Id: <20120120125741.661585676@sipsolutions.net> (sfid-20120120_135908_548410_5F8DDF2C)
Date: Fri, 20 Jan 2012 13:55:27 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mac80211: redesign auth/assoc
References: <20120120125516.000124996@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is the second part of the auth/assoc redesign,
the mac80211 part. This moves the auth/assoc code
out of the work abstraction and into the MLME, so
that we don't flip channels all the time etc.

The only downside is that when we are associated,
we need to drop the association in order to create
a connection to another AP, but for most drivers
this is actually desirable and the ability to do
was never used by any applications. If we want to
implement resource reservation with FT-OTA, we'd
probably best do it with explicit R-O-C in wpa_s.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Makefile      |    4 
 net/mac80211/cfg.c         |    6 
 net/mac80211/ieee80211_i.h |   77 +-
 net/mac80211/iface.c       |    4 
 net/mac80211/main.c        |   10 
 net/mac80211/mlme.c        | 1346 +++++++++++++++++++++++++++++++++------------
 net/mac80211/rx.c          |    9 
 net/mac80211/work.c        |  815 ---------------------------
 8 files changed, 1041 insertions(+), 1230 deletions(-)

--- a/net/mac80211/ieee80211_i.h	2012-01-20 13:54:17.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-01-20 13:54:21.000000000 +0100
@@ -280,10 +280,6 @@ struct mesh_preq_queue {
 
 enum ieee80211_work_type {
 	IEEE80211_WORK_ABORT,
-	IEEE80211_WORK_DIRECT_PROBE,
-	IEEE80211_WORK_AUTH,
-	IEEE80211_WORK_ASSOC_BEACON_WAIT,
-	IEEE80211_WORK_ASSOC,
 	IEEE80211_WORK_REMAIN_ON_CHANNEL,
 	IEEE80211_WORK_OFFCHANNEL_TX,
 };
@@ -316,36 +312,10 @@ struct ieee80211_work {
 	unsigned long timeout;
 	enum ieee80211_work_type type;
 
-	u8 filter_ta[ETH_ALEN];
-
 	bool started;
 
 	union {
 		struct {
-			int tries;
-			u16 algorithm, transaction;
-			u8 ssid[IEEE80211_MAX_SSID_LEN];
-			u8 ssid_len;
-			u8 key[WLAN_KEY_LEN_WEP104];
-			u8 key_len, key_idx;
-			bool privacy;
-			bool synced;
-		} probe_auth;
-		struct {
-			struct cfg80211_bss *bss;
-			const u8 *supp_rates;
-			const u8 *ht_information_ie;
-			enum ieee80211_smps_mode smps;
-			int tries;
-			u16 capability;
-			u8 prev_bssid[ETH_ALEN];
-			u8 ssid[IEEE80211_MAX_SSID_LEN];
-			u8 ssid_len;
-			u8 supp_rates_len;
-			bool wmm_used, use_11n, uapsd_used;
-			bool synced;
-		} assoc;
-		struct {
 			u32 duration;
 		} remain;
 		struct {
@@ -355,9 +325,8 @@ struct ieee80211_work {
 		} offchan_tx;
 	};
 
-	int ie_len;
-	/* must be last */
-	u8 ie[0];
+	size_t data_len;
+	u8 data[];
 };
 
 /* flags used in struct ieee80211_if_managed.flags */
@@ -373,6 +342,43 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
 };
 
+struct ieee80211_mgd_auth_data {
+	struct cfg80211_bss *bss;
+	unsigned long timeout;
+	int tries;
+	u16 algorithm, expected_transaction;
+
+	u8 key[WLAN_KEY_LEN_WEP104];
+	u8 key_len, key_idx;
+	bool synced;
+	bool done;
+
+	size_t ie_len;
+	u8 ie[];
+};
+
+struct ieee80211_mgd_assoc_data {
+	struct cfg80211_bss *bss;
+	const u8 *supp_rates;
+	const u8 *ht_information_ie;
+
+	unsigned long timeout;
+	int tries;
+
+	u16 capability;
+	u8 prev_bssid[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;
+	u8 supp_rates_len;
+	bool wmm_used, uapsd_used;
+	bool have_beacon;
+	bool sent_assoc;
+	bool synced;
+
+	size_t ie_len;
+	u8 ie[];
+};
+
 struct ieee80211_if_managed {
 	struct timer_list timer;
 	struct timer_list conn_mon_timer;
@@ -389,6 +395,8 @@ struct ieee80211_if_managed {
 
 	struct mutex mtx;
 	struct cfg80211_bss *associated;
+	struct ieee80211_mgd_auth_data *auth_data;
+	struct ieee80211_mgd_assoc_data *assoc_data;
 
 	u8 bssid[ETH_ALEN];
 
@@ -769,7 +777,6 @@ struct ieee80211_local {
 	struct list_head work_list;
 	struct timer_list work_timer;
 	struct work_struct work_work;
-	struct sk_buff_head work_skb_queue;
 
 	/*
 	 * private workqueue to mac80211. mac80211 makes this accessible
@@ -1436,8 +1443,6 @@ void ieee80211_work_init(struct ieee8021
 void ieee80211_add_work(struct ieee80211_work *wk);
 void free_work(struct ieee80211_work *wk);
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
-ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb);
 int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_channel *chan,
 				   enum nl80211_channel_type channel_type,
--- a/net/mac80211/mlme.c	2012-01-20 13:54:20.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-20 13:54:21.000000000 +0100
@@ -30,6 +30,12 @@
 #include "rate.h"
 #include "led.h"
 
+#define IEEE80211_AUTH_TIMEOUT (HZ / 5)
+#define IEEE80211_AUTH_MAX_TRIES 3
+#define IEEE80211_AUTH_WAIT_ASSOC (HZ * 5)
+#define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
+#define IEEE80211_ASSOC_MAX_TRIES 3
+
 static int max_nullfunc_tries = 2;
 module_param(max_nullfunc_tries, int, 0644);
 MODULE_PARM_DESC(max_nullfunc_tries,
@@ -97,6 +103,15 @@ enum rx_mgmt_action {
 
 	/* caller must call cfg80211_send_disassoc() */
 	RX_MGMT_CFG80211_DISASSOC,
+
+	/* caller must call cfg80211_send_rx_auth() */
+	RX_MGMT_CFG80211_RX_AUTH,
+
+	/* caller must call cfg80211_send_rx_assoc() */
+	RX_MGMT_CFG80211_RX_ASSOC,
+
+	/* caller must call cfg80211_send_assoc_timeout() */
+	RX_MGMT_CFG80211_ASSOC_TIMEOUT,
 };
 
 /* utils */
@@ -115,8 +130,7 @@ static inline void ASSERT_MGD_MTX(struct
  * has happened -- the work that runs from this timer will
  * do that.
  */
-static void run_again(struct ieee80211_if_managed *ifmgd,
-			     unsigned long timeout)
+static void run_again(struct ieee80211_if_managed *ifmgd, unsigned long timeout)
 {
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -284,6 +298,319 @@ static u32 ieee80211_enable_ht(struct ie
 
 /* frame sending functions */
 
+static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
+				      struct ieee80211_supported_band *sband,
+				      u32 *rates)
+{
+	int i, j, count;
+	*rates = 0;
+	count = 0;
+	for (i = 0; i < supp_rates_len; i++) {
+		int rate = (supp_rates[i] & 0x7F) * 5;
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
+static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, const u8 *ht_info_ie,
+				struct ieee80211_supported_band *sband,
+				struct ieee80211_channel *channel,
+				enum ieee80211_smps_mode smps)
+{
+	struct ieee80211_ht_info *ht_info;
+	u8 *pos;
+	u32 flags = channel->flags;
+	u16 cap;
+	struct ieee80211_sta_ht_cap ht_cap;
+
+	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
+
+	if (!sband->ht_cap.ht_supported)
+		return;
+
+	if (!ht_info_ie)
+		return;
+
+	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
+		return;
+
+	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
+	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
+
+	/* determine capability flags */
+	cap = ht_cap.cap;
+
+	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
+			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+		break;
+	}
+
+	/* set SM PS mode properly */
+	cap &= ~IEEE80211_HT_CAP_SM_PS;
+	switch (smps) {
+	case IEEE80211_SMPS_AUTOMATIC:
+	case IEEE80211_SMPS_NUM_MODES:
+		WARN_ON(1);
+	case IEEE80211_SMPS_OFF:
+		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_STATIC:
+		cap |= WLAN_HT_CAP_SM_PS_STATIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	case IEEE80211_SMPS_DYNAMIC:
+		cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
+			IEEE80211_HT_CAP_SM_PS_SHIFT;
+		break;
+	}
+
+	/* reserve and fill IE */
+	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+	ieee80211_ie_build_ht_cap(pos, &ht_cap, cap);
+}
+
+static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
+	struct sk_buff *skb;
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos, qos_info;
+	size_t offset = 0, noffset;
+	int i, count, rates_len, supp_rates_len;
+	u16 capab;
+	struct ieee80211_supported_band *sband;
+	u32 rates = 0;
+	struct ieee80211_bss *bss = (void *)assoc_data->bss->priv;
+
+	lockdep_assert_held(&ifmgd->mtx);
+
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+
+	if (assoc_data->supp_rates_len) {
+		/*
+		 * Get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode)...
+		 */
+		rates_len = ieee80211_compatible_rates(assoc_data->supp_rates,
+						       assoc_data->supp_rates_len,
+						       sband, &rates);
+	} else {
+		/*
+		 * In case AP not provide any supported rates information
+		 * before association, we send information element(s) with
+		 * all rates that we support.
+		 */
+		rates = ~0;
+		rates_len = sband->n_bitrates;
+	}
+
+	skb = alloc_skb(local->hw.extra_tx_headroom +
+			sizeof(*mgmt) + /* bit too much but doesn't matter */
+			2 + assoc_data->ssid_len + /* SSID */
+			4 + rates_len + /* (extended) rates */
+			4 + /* power capability */
+			2 + 2 * sband->n_channels + /* supported channels */
+			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
+			assoc_data->ie_len + /* extra IEs */
+			9, /* WMM */
+			GFP_KERNEL);
+	if (!skb)
+		return;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	capab = WLAN_CAPABILITY_ESS;
+
+	if (sband->band == IEEE80211_BAND_2GHZ) {
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
+		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
+			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
+	}
+
+	if (assoc_data->capability & WLAN_CAPABILITY_PRIVACY)
+		capab |= WLAN_CAPABILITY_PRIVACY;
+
+	if ((assoc_data->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
+	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
+		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+
+	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, assoc_data->bss->bssid, ETH_ALEN);
+	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
+	memcpy(mgmt->bssid, assoc_data->bss->bssid, ETH_ALEN);
+
+	if (!is_zero_ether_addr(assoc_data->prev_bssid)) {
+		skb_put(skb, 10);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_REASSOC_REQ);
+		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
+		mgmt->u.reassoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
+		memcpy(mgmt->u.reassoc_req.current_ap, assoc_data->prev_bssid,
+		       ETH_ALEN);
+	} else {
+		skb_put(skb, 4);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ASSOC_REQ);
+		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
+		mgmt->u.assoc_req.listen_interval =
+				cpu_to_le16(local->hw.conf.listen_interval);
+	}
+
+	/* SSID */
+	pos = skb_put(skb, 2 + assoc_data->ssid_len);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = assoc_data->ssid_len;
+	memcpy(pos, assoc_data->ssid, assoc_data->ssid_len);
+
+	/* add all rates which were marked to be used above */
+	supp_rates_len = rates_len;
+	if (supp_rates_len > 8)
+		supp_rates_len = 8;
+
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
+		*pos++ = local->oper_channel->max_power; /* max tx power */
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
+	/* if present, add any custom IEs that go before HT */
+	if (assoc_data->ie_len && assoc_data->ie) {
+		static const u8 before_ht[] = {
+			WLAN_EID_SSID,
+			WLAN_EID_SUPP_RATES,
+			WLAN_EID_EXT_SUPP_RATES,
+			WLAN_EID_PWR_CAPABILITY,
+			WLAN_EID_SUPPORTED_CHANNELS,
+			WLAN_EID_RSN,
+			WLAN_EID_QOS_CAPA,
+			WLAN_EID_RRM_ENABLED_CAPABILITIES,
+			WLAN_EID_MOBILITY_DOMAIN,
+			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
+		};
+		noffset = ieee80211_ie_split(assoc_data->ie, assoc_data->ie_len,
+					     before_ht, ARRAY_SIZE(before_ht),
+					     offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, assoc_data->ie + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N) &&
+	    bss->wmm_used && local->hw.queues >= 4)
+		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_information_ie,
+				    sband, local->oper_channel, ifmgd->ap_smps);
+
+	/* if present, add any custom non-vendor IEs that go after HT */
+	if (assoc_data->ie_len && assoc_data->ie) {
+		noffset = ieee80211_ie_split_vendor(assoc_data->ie,
+						    assoc_data->ie_len,
+						    offset);
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, assoc_data->ie + offset, noffset - offset);
+		offset = noffset;
+	}
+
+	if (assoc_data->wmm_used && local->hw.queues >= 4) {
+		if (assoc_data->uapsd_used) {
+			qos_info = local->uapsd_queues;
+			qos_info |= (local->uapsd_max_sp_len <<
+				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
+		} else {
+			qos_info = 0;
+		}
+
+		pos = skb_put(skb, 9);
+		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+		*pos++ = 7; /* len */
+		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
+		*pos++ = 0x50;
+		*pos++ = 0xf2;
+		*pos++ = 2; /* WME */
+		*pos++ = 0; /* WME info */
+		*pos++ = 1; /* WME ver */
+		*pos++ = qos_info;
+	}
+
+	/* add any remaining custom (i.e. vendor specific here) IEs */
+	if (assoc_data->ie_len && assoc_data->ie) {
+		noffset = assoc_data->ie_len;
+		pos = skb_put(skb, noffset - offset);
+		memcpy(pos, assoc_data->ie + offset, noffset - offset);
+	}
+
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	ieee80211_tx_skb(sdata, skb);
+}
+
 static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   const u8 *bssid, u16 stype, u16 reason,
 					   void *cookie, bool send_frame)
@@ -1423,6 +1750,135 @@ void ieee80211_connection_loss(struct ie
 EXPORT_SYMBOL(ieee80211_connection_loss);
 
 
+static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
+					bool assoc)
+{
+	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
+
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
+	if (auth_data->synced)
+		drv_finish_tx_sync(sdata->local, sdata,
+				   auth_data->bss->bssid,
+				   IEEE80211_TX_SYNC_AUTH);
+
+	if (!assoc) {
+		sta_info_destroy_addr(sdata, auth_data->bss->bssid);
+
+		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+	}
+
+	cfg80211_put_bss(auth_data->bss);
+	kfree(auth_data);
+	sdata->u.mgd.auth_data = NULL;
+}
+
+static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
+	u8 *pos;
+	struct ieee802_11_elems elems;
+
+	pos = mgmt->u.auth.variable;
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+	if (!elems.challenge)
+		return;
+	auth_data->expected_transaction = 4;
+	ieee80211_send_auth(sdata, 3, auth_data->algorithm,
+			    elems.challenge - 2, elems.challenge_len + 2,
+			    auth_data->bss->bssid, auth_data->bss->bssid,
+			    auth_data->key, auth_data->key_len,
+			    auth_data->key_idx);
+}
+
+static enum rx_mgmt_action __must_check
+ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
+		       struct ieee80211_mgmt *mgmt, size_t len)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 bssid[ETH_ALEN];
+	u16 auth_alg, auth_transaction, status_code;
+	struct sta_info *sta;
+
+	lockdep_assert_held(&ifmgd->mtx);
+
+	if (len < 24 + 6)
+		return RX_MGMT_NONE;
+
+	if (!ifmgd->auth_data || ifmgd->auth_data->done)
+		return RX_MGMT_NONE;
+
+	memcpy(bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN);
+
+	if (memcmp(bssid, mgmt->bssid, ETH_ALEN))
+		return RX_MGMT_NONE;
+
+	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
+	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
+	status_code = le16_to_cpu(mgmt->u.auth.status_code);
+
+	if (auth_alg != ifmgd->auth_data->algorithm ||
+	    auth_transaction != ifmgd->auth_data->expected_transaction)
+		return RX_MGMT_NONE;
+
+	if (status_code != WLAN_STATUS_SUCCESS) {
+		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
+		       sdata->name, mgmt->sa, status_code);
+		goto out;
+	}
+
+	switch (ifmgd->auth_data->algorithm) {
+	case WLAN_AUTH_OPEN:
+	case WLAN_AUTH_LEAP:
+	case WLAN_AUTH_FT:
+		break;
+	case WLAN_AUTH_SHARED_KEY:
+		if (ifmgd->auth_data->expected_transaction != 4) {
+			ieee80211_auth_challenge(sdata, mgmt, len);
+			/* need another frame */
+			return RX_MGMT_NONE;
+		}
+		break;
+	default:
+		WARN_ONCE(1, "invalid auth alg %d",
+			  ifmgd->auth_data->algorithm);
+		return RX_MGMT_NONE;
+	}
+
+	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
+ out:
+	if (ifmgd->auth_data->synced)
+		drv_finish_tx_sync(sdata->local, sdata, bssid,
+				   IEEE80211_TX_SYNC_AUTH);
+	ifmgd->auth_data->synced = false;
+	ifmgd->auth_data->done = true;
+	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
+	run_again(ifmgd, ifmgd->auth_data->timeout);
+
+	/* move station state to auth */
+	mutex_lock(&sdata->local->sta_mtx);
+	sta = sta_info_get(sdata, bssid);
+	if (!sta) {
+		WARN_ONCE(1, "%s: STA %pM not found", sdata->name, bssid);
+		goto out_err;
+	}
+	if (sta_info_move_state(sta, IEEE80211_STA_AUTH)) {
+		printk(KERN_DEBUG "%s: failed moving %pM to auth\n",
+		       sdata->name, bssid);
+		goto out_err;
+	}
+	mutex_unlock(&sdata->local->sta_mtx);
+
+	return RX_MGMT_CFG80211_RX_AUTH;
+ out_err:
+	mutex_unlock(&sdata->local->sta_mtx);
+	/* ignore frame -- wait for timeout */
+	return RX_MGMT_NONE;
+}
+
+
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len)
@@ -1431,10 +1887,14 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 	const u8 *bssid = NULL;
 	u16 reason_code;
 
+	lockdep_assert_held(&ifmgd->mtx);
+
 	if (len < 24 + 2)
 		return RX_MGMT_NONE;
 
-	ASSERT_MGD_MTX(ifmgd);
+	if (!ifmgd->associated ||
+	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
+		return RX_MGMT_NONE;
 
 	bssid = ifmgd->associated->bssid;
 
@@ -1459,15 +1919,13 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u16 reason_code;
 
-	if (len < 24 + 2)
-		return RX_MGMT_NONE;
-
-	ASSERT_MGD_MTX(ifmgd);
+	lockdep_assert_held(&ifmgd->mtx);
 
-	if (WARN_ON(!ifmgd->associated))
+	if (len < 24 + 2)
 		return RX_MGMT_NONE;
 
-	if (WARN_ON(memcmp(ifmgd->associated->bssid, mgmt->sa, ETH_ALEN)))
+	if (!ifmgd->associated ||
+	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
 		return RX_MGMT_NONE;
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
@@ -1524,15 +1982,37 @@ static void ieee80211_get_rates(struct i
 	}
 }
 
-static bool ieee80211_assoc_success(struct ieee80211_work *wk,
+static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
+					 bool assoc)
+{
+	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
+
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
+	if (assoc_data->synced)
+		drv_finish_tx_sync(sdata->local, sdata,
+				   assoc_data->bss->bssid,
+				   IEEE80211_TX_SYNC_ASSOC);
+
+	if (!assoc) {
+		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
+
+		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+	}
+
+	kfree(assoc_data);
+	sdata->u.mgd.assoc_data = NULL;
+}
+
+static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
+				    struct cfg80211_bss *cbss,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
-	struct cfg80211_bss *cbss = wk->assoc.bss;
 	u8 *pos;
 	u32 rates, basic_rates;
 	u16 capab_info, aid;
@@ -1589,7 +2069,7 @@ static bool ieee80211_assoc_success(stru
 
 	rates = 0;
 	basic_rates = 0;
-	sband = local->hw.wiphy->bands[wk->chan->band];
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
 
 	ieee80211_get_rates(sband, elems.supp_rates, elems.supp_rates_len,
 			    &rates, &basic_rates, &have_higher_than_11mbit,
@@ -1610,11 +2090,11 @@ static bool ieee80211_assoc_success(stru
 		basic_rates = BIT(min_rate_index);
 	}
 
-	sta->sta.supp_rates[wk->chan->band] = rates;
+	sta->sta.supp_rates[local->oper_channel->band] = rates;
 	sdata->vif.bss_conf.basic_rates = basic_rates;
 
 	/* cf. IEEE 802.11 9.2.12 */
-	if (wk->chan->band == IEEE80211_BAND_2GHZ &&
+	if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
@@ -1664,8 +2144,6 @@ static bool ieee80211_assoc_success(stru
 	else
 		ieee80211_set_wmm_default(sdata);
 
-	local->oper_channel = wk->chan;
-
 	if (elems.ht_info_elem && elems.wmm_param &&
 	    (sdata->local->hw.queues >= 4) &&
 	    !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
@@ -1696,7 +2174,82 @@ static bool ieee80211_assoc_success(stru
 	return true;
 }
 
+static enum rx_mgmt_action __must_check
+ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
+			     struct ieee80211_mgmt *mgmt, size_t len,
+			     struct cfg80211_bss **bss)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
+	u16 capab_info, status_code, aid;
+	struct ieee802_11_elems elems;
+	u8 *pos;
+	bool reassoc;
+
+	lockdep_assert_held(&ifmgd->mtx);
+
+	if (!assoc_data)
+		return RX_MGMT_NONE;
+	if (memcmp(assoc_data->bss->bssid, mgmt->bssid, ETH_ALEN))
+		return RX_MGMT_NONE;
+
+	/*
+	 * AssocResp and ReassocResp have identical structure, so process both
+	 * of them in this function.
+	 */
+
+	if (len < 24 + 6)
+		return RX_MGMT_NONE;
 
+	reassoc = ieee80211_is_reassoc_req(mgmt->frame_control);
+	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
+	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
+
+	printk(KERN_DEBUG "%s: RX %sssocResp from %pM (capab=0x%x "
+	       "status=%d aid=%d)\n",
+	       sdata->name, reassoc ? "Rea" : "A", mgmt->sa,
+	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
+
+	pos = mgmt->u.assoc_resp.variable;
+	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
+
+	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
+	    elems.timeout_int && elems.timeout_int_len == 5 &&
+	    elems.timeout_int[0] == WLAN_TIMEOUT_ASSOC_COMEBACK) {
+		u32 tu, ms;
+		tu = get_unaligned_le32(elems.timeout_int + 1);
+		ms = tu * 1024 / 1000;
+		printk(KERN_DEBUG "%s: %pM rejected association temporarily; "
+		       "comeback duration %u TU (%u ms)\n",
+		       sdata->name, mgmt->sa, tu, ms);
+		assoc_data->timeout = jiffies + msecs_to_jiffies(ms);
+		if (ms > IEEE80211_ASSOC_TIMEOUT)
+			run_again(ifmgd, assoc_data->timeout);
+		return RX_MGMT_NONE;
+	}
+
+	*bss = assoc_data->bss;
+
+	if (status_code != WLAN_STATUS_SUCCESS) {
+		printk(KERN_DEBUG "%s: %pM denied association (code=%d)\n",
+		       sdata->name, mgmt->sa, status_code);
+		ieee80211_destroy_assoc_data(sdata, false);
+	} else {
+		printk(KERN_DEBUG "%s: associated\n", sdata->name);
+
+		ieee80211_destroy_assoc_data(sdata, true);
+
+		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
+			/* oops -- internal error -- send timeout for now */
+			sta_info_destroy_addr(sdata, mgmt->bssid);
+			cfg80211_put_bss(*bss);
+			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
+		}
+	}
+
+	return RX_MGMT_CFG80211_RX_ASSOC;
+}
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
@@ -1710,7 +2263,9 @@ static void ieee80211_rx_bss_info(struct
 	struct ieee80211_channel *channel;
 	bool need_ps = false;
 
-	if (sdata->u.mgd.associated) {
+	if (sdata->u.mgd.associated &&
+	    memcmp(mgmt->bssid, sdata->u.mgd.associated->bssid,
+		   ETH_ALEN) == 0) {
 		bss = (void *)sdata->u.mgd.associated->priv;
 		/* not previously set so we may need to recalc */
 		need_ps = !bss->dtim_period;
@@ -1780,6 +2335,15 @@ static void ieee80211_rx_mgmt_probe_resp
 	if (ifmgd->associated &&
 	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN) == 0)
 		ieee80211_reset_ap_probe(sdata);
+
+	if (ifmgd->auth_data && !ifmgd->auth_data->bss->proberesp_ies &&
+	    memcmp(mgmt->bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN) == 0) {
+		/* got probe response, continue with auth */
+		printk(KERN_DEBUG "%s: direct probe responded\n", sdata->name);
+		ifmgd->auth_data->tries = 0;
+		ifmgd->auth_data->timeout = jiffies;
+		run_again(ifmgd, ifmgd->auth_data->timeout);
+	}
 }
 
 /*
@@ -1819,7 +2383,7 @@ static void ieee80211_rx_mgmt_beacon(str
 	u32 ncrc;
 	u8 *bssid;
 
-	ASSERT_MGD_MTX(ifmgd);
+	lockdep_assert_held(&ifmgd->mtx);
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
@@ -1829,21 +2393,25 @@ static void ieee80211_rx_mgmt_beacon(str
 	if (rx_status->freq != local->hw.conf.channel->center_freq)
 		return;
 
-	/*
-	 * We might have received a number of frames, among them a
-	 * disassoc frame and a beacon...
-	 */
-	if (!ifmgd->associated)
-		return;
+	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
+	    memcmp(mgmt->bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN) == 0) {
+		ieee802_11_parse_elems(mgmt->u.beacon.variable,
+				       len - baselen, &elems);
 
-	bssid = ifmgd->associated->bssid;
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
+				      false);
+		ifmgd->assoc_data->have_beacon = true;
+		ifmgd->assoc_data->sent_assoc = false;
+		/* continue assoc process */
+		ifmgd->assoc_data->timeout = jiffies;
+		run_again(ifmgd, ifmgd->assoc_data->timeout);
+		return;
+	}
 
-	/*
-	 * And in theory even frames from a different AP we were just
-	 * associated to a split-second ago!
-	 */
-	if (memcmp(bssid, mgmt->bssid, ETH_ALEN) != 0)
+	if (!ifmgd->associated ||
+	    memcmp(mgmt->bssid, ifmgd->associated->bssid, ETH_ALEN))
 		return;
+	bssid = ifmgd->associated->bssid;
 
 	/* Track average RSSI from the Beacon frames of the current AP */
 	ifmgd->last_beacon_signal = rx_status->signal;
@@ -2027,6 +2595,7 @@ void ieee80211_sta_rx_queued_mgmt(struct
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
+	struct cfg80211_bss *bss = NULL;
 	enum rx_mgmt_action rma = RX_MGMT_NONE;
 	u16 fc;
 
@@ -2036,92 +2605,59 @@ void ieee80211_sta_rx_queued_mgmt(struct
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated &&
-	    memcmp(ifmgd->associated->bssid, mgmt->bssid, ETH_ALEN) == 0) {
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_BEACON:
-			ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len,
-						 rx_status);
-			break;
-		case IEEE80211_STYPE_PROBE_RESP:
-			ieee80211_rx_mgmt_probe_resp(sdata, skb);
-			break;
-		case IEEE80211_STYPE_DEAUTH:
-			rma = ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_DISASSOC:
-			rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_ACTION:
-			switch (mgmt->u.action.category) {
-			case WLAN_CATEGORY_SPECTRUM_MGMT:
-				ieee80211_sta_process_chanswitch(sdata,
-						&mgmt->u.action.u.chan_switch.sw_elem,
-						(void *)ifmgd->associated->priv,
-						rx_status->mactime);
-				break;
-			}
-		}
-		mutex_unlock(&ifmgd->mtx);
-
-		switch (rma) {
-		case RX_MGMT_NONE:
-			/* no action */
-			break;
-		case RX_MGMT_CFG80211_DEAUTH:
-			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
-			break;
-		case RX_MGMT_CFG80211_DISASSOC:
-			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_BEACON:
+		ieee80211_rx_mgmt_beacon(sdata, mgmt, skb->len, rx_status);
+		break;
+	case IEEE80211_STYPE_PROBE_RESP:
+		ieee80211_rx_mgmt_probe_resp(sdata, skb);
+		break;
+	case IEEE80211_STYPE_AUTH:
+		rma = ieee80211_rx_mgmt_auth(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_DEAUTH:
+		rma = ieee80211_rx_mgmt_deauth(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_DISASSOC:
+		rma = ieee80211_rx_mgmt_disassoc(sdata, mgmt, skb->len);
+		break;
+	case IEEE80211_STYPE_ASSOC_RESP:
+	case IEEE80211_STYPE_REASSOC_RESP:
+		rma = ieee80211_rx_mgmt_assoc_resp(sdata, mgmt, skb->len, &bss);
+		break;
+	case IEEE80211_STYPE_ACTION:
+		switch (mgmt->u.action.category) {
+		case WLAN_CATEGORY_SPECTRUM_MGMT:
+			ieee80211_sta_process_chanswitch(sdata,
+					&mgmt->u.action.u.chan_switch.sw_elem,
+					(void *)ifmgd->associated->priv,
+					rx_status->mactime);
 			break;
-		default:
-			WARN(1, "unexpected: %d", rma);
 		}
-		return;
 	}
-
 	mutex_unlock(&ifmgd->mtx);
 
-	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
-	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
-		struct ieee80211_local *local = sdata->local;
-		struct ieee80211_work *wk;
-
-		mutex_lock(&local->mtx);
-		list_for_each_entry(wk, &local->work_list, list) {
-			if (wk->sdata != sdata)
-				continue;
-
-			if (wk->type != IEEE80211_WORK_ASSOC &&
-			    wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
-				continue;
-
-			if (memcmp(mgmt->bssid, wk->filter_ta, ETH_ALEN))
-				continue;
-			if (memcmp(mgmt->sa, wk->filter_ta, ETH_ALEN))
-				continue;
-
-			/*
-			 * Printing the message only here means we can't
-			 * spuriously print it, but it also means that it
-			 * won't be printed when the frame comes in before
-			 * we even tried to associate or in similar cases.
-			 *
-			 * Ultimately, I suspect cfg80211 should print the
-			 * messages instead.
-			 */
-			printk(KERN_DEBUG
-			       "%s: deauthenticated from %pM (Reason: %u)\n",
-			       sdata->name, mgmt->bssid,
-			       le16_to_cpu(mgmt->u.deauth.reason_code));
-
-			list_del_rcu(&wk->list);
-			free_work(wk);
-			break;
-		}
-		mutex_unlock(&local->mtx);
-
+	switch (rma) {
+	case RX_MGMT_NONE:
+		/* no action */
+		break;
+	case RX_MGMT_CFG80211_DEAUTH:
 		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
+		break;
+	case RX_MGMT_CFG80211_DISASSOC:
+		cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
+		break;
+	case RX_MGMT_CFG80211_RX_AUTH:
+		cfg80211_send_rx_auth(sdata->dev, (u8 *)mgmt, skb->len);
+		break;
+	case RX_MGMT_CFG80211_RX_ASSOC:
+		cfg80211_send_rx_assoc(sdata->dev, bss, (u8 *)mgmt, skb->len);
+		break;
+	case RX_MGMT_CFG80211_ASSOC_TIMEOUT:
+		cfg80211_send_assoc_timeout(sdata->dev, mgmt->bssid);
+		break;
+	default:
+		WARN(1, "unexpected: %d", rma);
 	}
 }
 
@@ -2166,14 +2702,160 @@ static void ieee80211_sta_connection_los
 	mutex_lock(&ifmgd->mtx);
 }
 
+static int ieee80211_probe_auth(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_auth_data *auth_data = ifmgd->auth_data;
+
+	lockdep_assert_held(&ifmgd->mtx);
+
+	if (WARN_ON_ONCE(!auth_data))
+		return -EINVAL;
+
+	if (!auth_data->synced) {
+		int ret = drv_tx_sync(local, sdata, auth_data->bss->bssid,
+				      IEEE80211_TX_SYNC_AUTH);
+		if (ret)
+			return ret;
+	}
+	auth_data->synced = true;
+
+	auth_data->tries++;
+
+	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
+		printk(KERN_DEBUG "%s: authentication with %pM timed out\n",
+		       sdata->name, auth_data->bss->bssid);
+
+		/*
+		 * Most likely AP is not in the range so remove the
+		 * bss struct for that AP.
+		 */
+		cfg80211_unlink_bss(local->hw.wiphy, auth_data->bss);
+
+		return -ETIMEDOUT;
+	}
+
+	if (auth_data->bss->proberesp_ies) {
+		printk(KERN_DEBUG "%s: send auth to %pM (try %d/%d)\n",
+		       sdata->name, auth_data->bss->bssid, auth_data->tries,
+		       IEEE80211_AUTH_MAX_TRIES);
+
+		auth_data->expected_transaction = 2;
+		ieee80211_send_auth(sdata, 1, auth_data->algorithm,
+				    auth_data->ie, auth_data->ie_len,
+				    auth_data->bss->bssid,
+				    auth_data->bss->bssid, NULL, 0, 0);
+	} else {
+		const u8 *ssidie;
+
+		printk(KERN_DEBUG "%s: direct probe to %pM (try %d/%i)\n",
+		       sdata->name, auth_data->bss->bssid, auth_data->tries,
+		       IEEE80211_AUTH_MAX_TRIES);
+
+		ssidie = ieee80211_bss_get_ie(auth_data->bss, WLAN_EID_SSID);
+		if (!ssidie)
+			return -EINVAL;
+		/*
+		 * Direct probe is sent to broadcast address as some APs
+		 * will not answer to direct packet in unassociated state.
+		 */
+		ieee80211_send_probe_req(sdata, NULL, ssidie + 2, ssidie[1],
+					 NULL, 0, (u32) -1, true, false);
+	}
+
+	auth_data->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
+	run_again(ifmgd, auth_data->timeout);
+
+	return 0;
+}
+
+static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
+	struct ieee80211_local *local = sdata->local;
+
+	lockdep_assert_held(&sdata->u.mgd.mtx);
+
+	if (!assoc_data->synced) {
+		int ret = drv_tx_sync(local, sdata, assoc_data->bss->bssid,
+				      IEEE80211_TX_SYNC_ASSOC);
+		if (ret)
+			return ret;
+	}
+	assoc_data->synced = true;
+
+	assoc_data->tries++;
+	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
+		printk(KERN_DEBUG "%s: association with %pM timed out\n",
+		       sdata->name, assoc_data->bss->bssid);
+
+		/*
+		 * Most likely AP is not in the range so remove the
+		 * bss struct for that AP.
+		 */
+		cfg80211_unlink_bss(local->hw.wiphy, assoc_data->bss);
+
+		return -ETIMEDOUT;
+	}
+
+	printk(KERN_DEBUG "%s: associate with %pM (try %d/%d)\n",
+	       sdata->name, assoc_data->bss->bssid, assoc_data->tries,
+	       IEEE80211_ASSOC_MAX_TRIES);
+	ieee80211_send_assoc(sdata);
+
+	assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
+	run_again(&sdata->u.mgd, assoc_data->timeout);
+
+	return 0;
+}
+
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
 
+	if (ifmgd->auth_data &&
+	    time_after(jiffies, ifmgd->auth_data->timeout)) {
+		if (ifmgd->auth_data->done) {
+			/*
+			 * ok ... we waited for assoc but userspace didn't,
+			 * so let's just kill the auth data
+			 */
+			ieee80211_destroy_auth_data(sdata, false);
+		} else if (ieee80211_probe_auth(sdata)) {
+			u8 bssid[ETH_ALEN];
+
+			memcpy(bssid, ifmgd->auth_data->bss->bssid, ETH_ALEN);
+
+			ieee80211_destroy_auth_data(sdata, false);
+
+			mutex_unlock(&ifmgd->mtx);
+			cfg80211_send_auth_timeout(sdata->dev, bssid);
+			mutex_lock(&ifmgd->mtx);
+		}
+	} else if (ifmgd->auth_data)
+		run_again(ifmgd, ifmgd->auth_data->timeout);
+
+	if (ifmgd->assoc_data &&
+	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
+		if (!ifmgd->assoc_data->have_beacon ||
+		    ieee80211_do_assoc(sdata)) {
+			u8 bssid[ETH_ALEN];
+
+			memcpy(bssid, ifmgd->assoc_data->bss->bssid, ETH_ALEN);
+
+			ieee80211_destroy_assoc_data(sdata, false);
+
+			mutex_unlock(&ifmgd->mtx);
+			cfg80211_send_assoc_timeout(sdata->dev, bssid);
+			mutex_lock(&ifmgd->mtx);
+		}
+	} else if (ifmgd->assoc_data)
+		run_again(ifmgd, ifmgd->assoc_data->timeout);
+
 	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
 	    ifmgd->associated) {
@@ -2249,6 +2931,10 @@ void ieee80211_sta_work(struct ieee80211
 	}
 
 	mutex_unlock(&ifmgd->mtx);
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(local);
+	mutex_unlock(&local->mtx);
 }
 
 static void ieee80211_sta_bcn_mon_timer(unsigned long data)
@@ -2421,50 +3107,24 @@ int ieee80211_max_network_latency(struct
 }
 
 /* config hooks */
-static enum work_done_result
-ieee80211_probe_auth_done(struct ieee80211_work *wk,
-			  struct sk_buff *skb)
-{
-	struct ieee80211_local *local = wk->sdata->local;
-
-	if (!skb) {
-		cfg80211_send_auth_timeout(wk->sdata->dev, wk->filter_ta);
-		goto destroy;
-	}
-
-	if (wk->type == IEEE80211_WORK_AUTH) {
-		cfg80211_send_rx_auth(wk->sdata->dev, skb->data, skb->len);
-		goto destroy;
-	}
-
-	mutex_lock(&wk->sdata->u.mgd.mtx);
-	ieee80211_rx_mgmt_probe_resp(wk->sdata, skb);
-	mutex_unlock(&wk->sdata->u.mgd.mtx);
-
-	wk->type = IEEE80211_WORK_AUTH;
-	wk->probe_auth.tries = 0;
-	return WORK_DONE_REQUEUE;
- destroy:
-	if (wk->probe_auth.synced)
-		drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
-				   IEEE80211_TX_SYNC_AUTH);
-
-	return WORK_DONE_DESTROY;
-}
-
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req)
 {
-	const u8 *ssid;
-	struct ieee80211_work *wk;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_auth_data *auth_data;
+	struct sta_info *sta;
 	u16 auth_alg;
+	int err;
+
+	/* prepare auth data structure */
 
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		auth_alg = WLAN_AUTH_OPEN;
 		break;
 	case NL80211_AUTHTYPE_SHARED_KEY:
-		if (IS_ERR(sdata->local->wep_tx_tfm))
+		if (IS_ERR(local->wep_tx_tfm))
 			return -EOPNOTSUPP;
 		auth_alg = WLAN_AUTH_SHARED_KEY;
 		break;
@@ -2478,169 +3138,142 @@ int ieee80211_mgd_auth(struct ieee80211_
 		return -EOPNOTSUPP;
 	}
 
-	wk = kzalloc(sizeof(*wk) + req->ie_len, GFP_KERNEL);
-	if (!wk)
+	auth_data = kzalloc(sizeof(*auth_data) + req->ie_len, GFP_KERNEL);
+	if (!auth_data)
 		return -ENOMEM;
 
-	memcpy(wk->filter_ta, req->bss->bssid, ETH_ALEN);
+	auth_data->bss = req->bss;
 
 	if (req->ie && req->ie_len) {
-		memcpy(wk->ie, req->ie, req->ie_len);
-		wk->ie_len = req->ie_len;
+		memcpy(auth_data->ie, req->ie, req->ie_len);
+		auth_data->ie_len = req->ie_len;
 	}
 
 	if (req->key && req->key_len) {
-		wk->probe_auth.key_len = req->key_len;
-		wk->probe_auth.key_idx = req->key_idx;
-		memcpy(wk->probe_auth.key, req->key, req->key_len);
+		auth_data->key_len = req->key_len;
+		auth_data->key_idx = req->key_idx;
+		memcpy(auth_data->key, req->key, req->key_len);
 	}
 
-	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	memcpy(wk->probe_auth.ssid, ssid + 2, ssid[1]);
-	wk->probe_auth.ssid_len = ssid[1];
+	auth_data->algorithm = auth_alg;
 
-	wk->probe_auth.algorithm = auth_alg;
-	wk->probe_auth.privacy = req->bss->capability & WLAN_CAPABILITY_PRIVACY;
+	/* try to authenticate/probe */
 
-	/* if we already have a probe, don't probe again */
-	if (req->bss->proberesp_ies)
-		wk->type = IEEE80211_WORK_AUTH;
-	else
-		wk->type = IEEE80211_WORK_DIRECT_PROBE;
-	wk->chan = req->bss->channel;
-	wk->chan_type = NL80211_CHAN_NO_HT;
-	wk->sdata = sdata;
-	wk->done = ieee80211_probe_auth_done;
+	mutex_lock(&ifmgd->mtx);
 
-	ieee80211_add_work(wk);
-	return 0;
-}
+	if ((ifmgd->auth_data && !ifmgd->auth_data->done) ||
+	    ifmgd->assoc_data) {
+		err = -EBUSY;
+		goto err_free;
+	}
 
-/* create and insert a dummy station entry */
-static int ieee80211_pre_assoc(struct ieee80211_sub_if_data *sdata,
-				u8 *bssid) {
-	struct sta_info *sta;
-	int err;
+	if (ifmgd->auth_data)
+		ieee80211_destroy_auth_data(sdata, false);
 
-	sta = sta_info_alloc(sdata, bssid, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
+	/* prep auth_data so we don't go into idle on disassoc */
+	ifmgd->auth_data = auth_data;
 
-	err = sta_info_insert(sta);
-	sta = NULL;
-	if (err) {
-		printk(KERN_DEBUG "%s: failed to insert STA entry for"
-		       " the AP (error %d)\n", sdata->name, err);
-		return err;
-	}
+	if (ifmgd->associated)
+		ieee80211_set_disassoc(sdata, true, false);
 
-	return 0;
-}
+	printk(KERN_DEBUG "%s: authenticate with %pM\n",
+	       sdata->name, req->bss->bssid);
 
-static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
-						  struct sk_buff *skb)
-{
-	struct ieee80211_local *local = wk->sdata->local;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_rx_status *rx_status;
-	struct ieee802_11_elems elems;
-	struct cfg80211_bss *cbss = wk->assoc.bss;
-	u16 status;
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&local->mtx);
 
-	if (!skb) {
-		sta_info_destroy_addr(wk->sdata, cbss->bssid);
-		cfg80211_send_assoc_timeout(wk->sdata->dev, wk->filter_ta);
-		goto destroy;
-	}
-
-	if (wk->type == IEEE80211_WORK_ASSOC_BEACON_WAIT) {
-		mutex_lock(&wk->sdata->u.mgd.mtx);
-		rx_status = (void *) skb->cb;
-		ieee802_11_parse_elems(skb->data + 24 + 12, skb->len - 24 - 12, &elems);
-		ieee80211_rx_bss_info(wk->sdata, (void *)skb->data, skb->len, rx_status,
-				      &elems, true);
-		mutex_unlock(&wk->sdata->u.mgd.mtx);
-
-		wk->type = IEEE80211_WORK_ASSOC;
-		/* not really done yet */
-		return WORK_DONE_REQUEUE;
-	}
-
-	mgmt = (void *)skb->data;
-	status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
-
-	if (status == WLAN_STATUS_SUCCESS) {
-		if (wk->assoc.synced)
-			drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
-					   IEEE80211_TX_SYNC_ASSOC);
-
-		mutex_lock(&wk->sdata->u.mgd.mtx);
-		if (!ieee80211_assoc_success(wk, mgmt, skb->len)) {
-			mutex_unlock(&wk->sdata->u.mgd.mtx);
-			/* oops -- internal error -- send timeout for now */
-			sta_info_destroy_addr(wk->sdata, cbss->bssid);
-			cfg80211_send_assoc_timeout(wk->sdata->dev,
-						    wk->filter_ta);
-			return WORK_DONE_DESTROY;
-		}
+	/* switch to the right channel */
+	local->oper_channel = req->bss->channel;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	/* set BSSID */
+	memcpy(ifmgd->bssid, req->bss->bssid, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+
+	/* add station entry */
+	sta = sta_info_alloc(sdata, req->bss->bssid, GFP_KERNEL);
+	if (!sta) {
+		err = -ENOMEM;
+		goto err_clear;
+	}
 
-		mutex_unlock(&wk->sdata->u.mgd.mtx);
-	} else {
-		/* assoc failed - destroy the dummy station entry */
-		sta_info_destroy_addr(wk->sdata, cbss->bssid);
+	err = sta_info_insert(sta);
+	if (err) {
+		printk(KERN_DEBUG
+		       "%s: failed to insert STA entry for the AP %pM (error %d)\n",
+		       sdata->name, req->bss->bssid, err);
+		goto err_clear;
 	}
 
-	cfg80211_send_rx_assoc(wk->sdata->dev, cbss, skb->data, skb->len);
- destroy:
-	if (wk->assoc.synced)
-		drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
-				   IEEE80211_TX_SYNC_ASSOC);
+	err = ieee80211_probe_auth(sdata);
+	if (err) {
+		if (auth_data->synced)
+			drv_finish_tx_sync(local, sdata, req->bss->bssid,
+					   IEEE80211_TX_SYNC_AUTH);
+		sta_info_destroy_addr(sdata, req->bss->bssid);
+		goto err_clear;
+	}
+
+	/* hold our own reference */
+	cfg80211_ref_bss(auth_data->bss);
+	err = 0;
+	goto out_unlock;
+
+ err_clear:
+	ifmgd->auth_data = NULL;
+ err_free:
+	kfree(auth_data);
+ out_unlock:
+	mutex_unlock(&ifmgd->mtx);
 
-	return WORK_DONE_DESTROY;
+	return err;
 }
 
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)req->bss->priv;
-	struct ieee80211_work *wk;
-	const u8 *ssid;
+	struct ieee80211_mgd_assoc_data *assoc_data;
+	struct sta_info *sta;
+	const u8 *ssidie;
 	int i, err;
 
+	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
+	if (!ssidie)
+		return -EINVAL;
+
+	assoc_data = kzalloc(sizeof(*assoc_data) + req->ie_len, GFP_KERNEL);
+	if (!assoc_data)
+		return -ENOMEM;
+
 	mutex_lock(&ifmgd->mtx);
-	if (ifmgd->associated) {
-		if (!req->prev_bssid ||
-		    memcmp(req->prev_bssid, ifmgd->associated->bssid,
-			   ETH_ALEN)) {
-			/*
-			 * We are already associated and the request was not a
-			 * reassociation request from the current BSS, so
-			 * reject it.
-			 */
-			mutex_unlock(&ifmgd->mtx);
-			return -EALREADY;
-		}
 
-		/* Trying to reassociate - clear previous association state */
+	if (ifmgd->associated)
 		ieee80211_set_disassoc(sdata, true, false);
+
+	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
+		err = -EBUSY;
+		goto err_free;
 	}
-	mutex_unlock(&ifmgd->mtx);
 
-	wk = kzalloc(sizeof(*wk) + req->ie_len, GFP_KERNEL);
-	if (!wk)
-		return -ENOMEM;
+	if (ifmgd->assoc_data) {
+		err = -EBUSY;
+		goto err_free;
+	}
 
-	/*
-	 * create a dummy station info entry in order
-	 * to start accepting incoming EAPOL packets from the station
-	 */
-	err = ieee80211_pre_assoc(sdata, req->bss->bssid);
-	if (err) {
-		kfree(wk);
-		return err;
+	if (ifmgd->auth_data) {
+		bool match;
+
+		/* keep sta info, bssid if matching */
+		match = memcmp(ifmgd->bssid, req->bss->bssid, ETH_ALEN) == 0;
+		ieee80211_destroy_auth_data(sdata, match);
 	}
 
+	/* prepare assoc data */
+
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_11N;
 	ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 
@@ -2652,7 +3285,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
-
 	if (req->flags & ASSOC_REQ_DISABLE_HT)
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
@@ -2661,16 +3293,12 @@ int ieee80211_mgd_assoc(struct ieee80211
 	       sizeof(ifmgd->ht_capa_mask));
 
 	if (req->ie && req->ie_len) {
-		memcpy(wk->ie, req->ie, req->ie_len);
-		wk->ie_len = req->ie_len;
-	} else
-		wk->ie_len = 0;
-
-	wk->assoc.bss = req->bss;
+		memcpy(assoc_data->ie, req->ie, req->ie_len);
+		assoc_data->ie_len = req->ie_len;
+	}
 
-	memcpy(wk->filter_ta, req->bss->bssid, ETH_ALEN);
+	assoc_data->bss = req->bss;
 
-	/* new association always uses requested smps mode */
 	if (ifmgd->req_smps == IEEE80211_SMPS_AUTOMATIC) {
 		if (ifmgd->powersave)
 			ifmgd->ap_smps = IEEE80211_SMPS_DYNAMIC;
@@ -2679,7 +3307,6 @@ int ieee80211_mgd_assoc(struct ieee80211
 	} else
 		ifmgd->ap_smps = ifmgd->req_smps;
 
-	wk->assoc.smps = ifmgd->ap_smps;
 	/*
 	 * IEEE802.11n does not allow TKIP/WEP as pairwise ciphers in HT mode.
 	 * We still associate in non-HT mode (11a/b/g) if any one of these
@@ -2687,39 +3314,27 @@ int ieee80211_mgd_assoc(struct ieee80211
 	 * We can set this to true for non-11n hardware, that'll be checked
 	 * separately along with the peer capabilities.
 	 */
-	wk->assoc.use_11n = !(ifmgd->flags & IEEE80211_STA_DISABLE_11N);
-	wk->assoc.capability = req->bss->capability;
-	wk->assoc.wmm_used = bss->wmm_used;
-	wk->assoc.supp_rates = bss->supp_rates;
-	wk->assoc.supp_rates_len = bss->supp_rates_len;
-	wk->assoc.ht_information_ie =
+	assoc_data->capability = req->bss->capability;
+	assoc_data->wmm_used = bss->wmm_used;
+	assoc_data->supp_rates = bss->supp_rates;
+	assoc_data->supp_rates_len = bss->supp_rates_len;
+	assoc_data->ht_information_ie =
 		ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_INFORMATION);
 
 	if (bss->wmm_used && bss->uapsd_supported &&
 	    (sdata->local->hw.flags & IEEE80211_HW_SUPPORTS_UAPSD)) {
-		wk->assoc.uapsd_used = true;
+		assoc_data->uapsd_used = true;
 		ifmgd->flags |= IEEE80211_STA_UAPSD_ENABLED;
 	} else {
-		wk->assoc.uapsd_used = false;
+		assoc_data->uapsd_used = false;
 		ifmgd->flags &= ~IEEE80211_STA_UAPSD_ENABLED;
 	}
 
-	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
-	memcpy(wk->assoc.ssid, ssid + 2, ssid[1]);
-	wk->assoc.ssid_len = ssid[1];
+	memcpy(assoc_data->ssid, ssidie + 2, ssidie[1]);
+	assoc_data->ssid_len = ssidie[1];
 
 	if (req->prev_bssid)
-		memcpy(wk->assoc.prev_bssid, req->prev_bssid, ETH_ALEN);
-
-	wk->chan = req->bss->channel;
-	wk->chan_type = NL80211_CHAN_NO_HT;
-	wk->sdata = sdata;
-	wk->done = ieee80211_assoc_done;
-	if (!bss->dtim_period &&
-	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
-		wk->type = IEEE80211_WORK_ASSOC_BEACON_WAIT;
-	else
-		wk->type = IEEE80211_WORK_ASSOC;
+		memcpy(assoc_data->prev_bssid, req->prev_bssid, ETH_ALEN);
 
 	if (req->use_mfp) {
 		ifmgd->mfp = IEEE80211_MFP_REQUIRED;
@@ -2737,15 +3352,79 @@ int ieee80211_mgd_assoc(struct ieee80211
 	sdata->control_port_protocol = req->crypto.control_port_ethertype;
 	sdata->control_port_no_encrypt = req->crypto.control_port_no_encrypt;
 
-	ieee80211_add_work(wk);
-	return 0;
+	/* kick off associate process */
+
+	ifmgd->assoc_data = assoc_data;
+
+	mutex_lock(&local->mtx);
+	ieee80211_recalc_idle(sdata->local);
+	mutex_unlock(&local->mtx);
+
+	/* switch to the right channel */
+	local->oper_channel = req->bss->channel;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, req->bss->bssid);
+	rcu_read_unlock();
+
+	if (!sta) {
+		/* set BSSID */
+		memcpy(ifmgd->bssid, req->bss->bssid, ETH_ALEN);
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
+
+		sta = sta_info_alloc(sdata, req->bss->bssid, GFP_KERNEL);
+		if (!sta) {
+			err = -ENOMEM;
+			goto err_clear;
+		}
+
+		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
+
+		err = sta_info_insert(sta);
+		sta = NULL;
+		if (err) {
+			printk(KERN_DEBUG
+			       "%s: failed to insert STA entry for the AP (error %d)\n",
+			       sdata->name, err);
+			goto err_clear;
+		}
+	} else
+		WARN_ON_ONCE(memcmp(ifmgd->bssid, req->bss->bssid, ETH_ALEN));
+
+	if (!bss->dtim_period &&
+	    sdata->local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD) {
+		/*
+		 * Wait up to one beacon interval ...
+		 * should this be more if we miss one?
+		 */
+		printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
+		       sdata->name, ifmgd->bssid);
+		assoc_data->timeout = jiffies +
+				TU_TO_EXP_TIME(req->bss->beacon_interval);
+	} else {
+		assoc_data->have_beacon = true;
+		assoc_data->sent_assoc = false;
+		assoc_data->timeout = jiffies;
+	}
+	run_again(ifmgd, assoc_data->timeout);
+
+	err = 0;
+	goto out;
+ err_clear:
+	ifmgd->assoc_data = NULL;
+ err_free:
+	kfree(assoc_data);
+ out:
+	mutex_unlock(&ifmgd->mtx);
+
+	return err;
 }
 
 int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req,
 			 void *cookie)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool assoc_bss = false;
 
@@ -2754,62 +3433,13 @@ int ieee80211_mgd_deauth(struct ieee8021
 	if (ifmgd->associated &&
 	    memcmp(ifmgd->associated->bssid, req->bssid, ETH_ALEN) == 0) {
 		ieee80211_set_disassoc(sdata, false, true);
-		mutex_unlock(&ifmgd->mtx);
 		assoc_bss = true;
-	} else {
-		bool not_auth_yet = false;
-		struct ieee80211_work *tmp, *wk = NULL;
-
+	} else if (ifmgd->auth_data) {
+		ieee80211_destroy_auth_data(sdata, false);
 		mutex_unlock(&ifmgd->mtx);
-
-		mutex_lock(&local->mtx);
-		list_for_each_entry(tmp, &local->work_list, list) {
-			if (tmp->sdata != sdata)
-				continue;
-
-			if (tmp->type != IEEE80211_WORK_DIRECT_PROBE &&
-			    tmp->type != IEEE80211_WORK_AUTH &&
-			    tmp->type != IEEE80211_WORK_ASSOC &&
-			    tmp->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
-				continue;
-
-			if (memcmp(req->bssid, tmp->filter_ta, ETH_ALEN))
-				continue;
-
-			not_auth_yet = tmp->type == IEEE80211_WORK_DIRECT_PROBE;
-			list_del_rcu(&tmp->list);
-			synchronize_rcu();
-			wk = tmp;
-			break;
-		}
-		mutex_unlock(&local->mtx);
-
-		if (wk && wk->type == IEEE80211_WORK_ASSOC) {
-			/* clean up dummy sta & TX sync */
-			sta_info_destroy_addr(wk->sdata, wk->filter_ta);
-			if (wk->assoc.synced)
-				drv_finish_tx_sync(local, wk->sdata,
-						   wk->filter_ta,
-						   IEEE80211_TX_SYNC_ASSOC);
-		} else if (wk && wk->type == IEEE80211_WORK_AUTH) {
-			if (wk->probe_auth.synced)
-				drv_finish_tx_sync(local, wk->sdata,
-						   wk->filter_ta,
-						   IEEE80211_TX_SYNC_AUTH);
-		}
-		kfree(wk);
-
-		/*
-		 * If somebody requests authentication and we haven't
-		 * sent out an auth frame yet there's no need to send
-		 * out a deauth frame either. If the state was PROBE,
-		 * then this is the case. If it's AUTH we have sent a
-		 * frame, and if it's IDLE we have completed the auth
-		 * process already.
-		 */
-		if (not_auth_yet)
-			return 0;
+		return 0;
 	}
+	mutex_unlock(&ifmgd->mtx);
 
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
 	       sdata->name, req->bssid, req->reason_code);
--- a/net/mac80211/rx.c	2012-01-20 13:54:20.000000000 +0100
+++ b/net/mac80211/rx.c	2012-01-20 13:54:21.000000000 +0100
@@ -2488,14 +2488,9 @@ static ieee80211_rx_result debug_noinlin
 ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	ieee80211_rx_result rxs;
 	struct ieee80211_mgmt *mgmt = (void *)rx->skb->data;
 	__le16 stype;
 
-	rxs = ieee80211_work_rx_mgmt(rx->sdata, rx->skb);
-	if (rxs != RX_CONTINUE)
-		return rxs;
-
 	stype = mgmt->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE);
 
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
@@ -2504,10 +2499,13 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 		return RX_DROP_MONITOR;
 
 	switch (stype) {
+	case cpu_to_le16(IEEE80211_STYPE_AUTH):
 	case cpu_to_le16(IEEE80211_STYPE_BEACON):
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
 		/* process for all: mesh, mlme, ibss */
 		break;
+	case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
+	case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
 	case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
 	case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
 		if (is_multicast_ether_addr(mgmt->da) &&
@@ -2519,7 +2517,6 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 			return RX_DROP_MONITOR;
 		break;
 	case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
-	case cpu_to_le16(IEEE80211_STYPE_AUTH):
 		/* process only for ibss */
 		if (sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			return RX_DROP_MONITOR;
--- a/net/mac80211/work.c	2012-01-20 13:54:17.000000000 +0100
+++ b/net/mac80211/work.c	2012-01-20 13:54:21.000000000 +0100
@@ -27,16 +27,9 @@
 #include "rate.h"
 #include "driver-ops.h"
 
-#define IEEE80211_AUTH_TIMEOUT (HZ / 5)
-#define IEEE80211_AUTH_MAX_TRIES 3
-#define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
-#define IEEE80211_ASSOC_MAX_TRIES 3
-
 enum work_action {
-	WORK_ACT_MISMATCH,
 	WORK_ACT_NONE,
 	WORK_ACT_TIMEOUT,
-	WORK_ACT_DONE,
 };
 
 
@@ -71,465 +64,6 @@ void free_work(struct ieee80211_work *wk
 	kfree_rcu(wk, rcu_head);
 }
 
-static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
-				      struct ieee80211_supported_band *sband,
-				      u32 *rates)
-{
-	int i, j, count;
-	*rates = 0;
-	count = 0;
-	for (i = 0; i < supp_rates_len; i++) {
-		int rate = (supp_rates[i] & 0x7F) * 5;
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
-/* frame sending functions */
-
-static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb, const u8 *ht_info_ie,
-				struct ieee80211_supported_band *sband,
-				struct ieee80211_channel *channel,
-				enum ieee80211_smps_mode smps)
-{
-	struct ieee80211_ht_info *ht_info;
-	u8 *pos;
-	u32 flags = channel->flags;
-	u16 cap;
-	struct ieee80211_sta_ht_cap ht_cap;
-
-	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
-
-	if (!sband->ht_cap.ht_supported)
-		return;
-
-	if (!ht_info_ie)
-		return;
-
-	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
-		return;
-
-	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
-	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
-
-	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
-
-	/* determine capability flags */
-	cap = ht_cap.cap;
-
-	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
-	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
-		if (flags & IEEE80211_CHAN_NO_HT40PLUS) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-		break;
-	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
-		if (flags & IEEE80211_CHAN_NO_HT40MINUS) {
-			cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-		break;
-	}
-
-	/* set SM PS mode properly */
-	cap &= ~IEEE80211_HT_CAP_SM_PS;
-	switch (smps) {
-	case IEEE80211_SMPS_AUTOMATIC:
-	case IEEE80211_SMPS_NUM_MODES:
-		WARN_ON(1);
-	case IEEE80211_SMPS_OFF:
-		cap |= WLAN_HT_CAP_SM_PS_DISABLED <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	case IEEE80211_SMPS_STATIC:
-		cap |= WLAN_HT_CAP_SM_PS_STATIC <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	case IEEE80211_SMPS_DYNAMIC:
-		cap |= WLAN_HT_CAP_SM_PS_DYNAMIC <<
-			IEEE80211_HT_CAP_SM_PS_SHIFT;
-		break;
-	}
-
-	/* reserve and fill IE */
-	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	ieee80211_ie_build_ht_cap(pos, &ht_cap, cap);
-}
-
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_work *wk)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-	u8 *pos, qos_info;
-	size_t offset = 0, noffset;
-	int i, count, rates_len, supp_rates_len;
-	u16 capab;
-	struct ieee80211_supported_band *sband;
-	u32 rates = 0;
-
-	sband = local->hw.wiphy->bands[wk->chan->band];
-
-	if (wk->assoc.supp_rates_len) {
-		/*
-		 * Get all rates supported by the device and the AP as
-		 * some APs don't like getting a superset of their rates
-		 * in the association request (e.g. D-Link DAP 1353 in
-		 * b-only mode)...
-		 */
-		rates_len = ieee80211_compatible_rates(wk->assoc.supp_rates,
-						       wk->assoc.supp_rates_len,
-						       sband, &rates);
-	} else {
-		/*
-		 * In case AP not provide any supported rates information
-		 * before association, we send information element(s) with
-		 * all rates that we support.
-		 */
-		rates = ~0;
-		rates_len = sband->n_bitrates;
-	}
-
-	skb = alloc_skb(local->hw.extra_tx_headroom +
-			sizeof(*mgmt) + /* bit too much but doesn't matter */
-			2 + wk->assoc.ssid_len + /* SSID */
-			4 + rates_len + /* (extended) rates */
-			4 + /* power capability */
-			2 + 2 * sband->n_channels + /* supported channels */
-			2 + sizeof(struct ieee80211_ht_cap) + /* HT */
-			wk->ie_len + /* extra IEs */
-			9, /* WMM */
-			GFP_KERNEL);
-	if (!skb)
-		return;
-
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	capab = WLAN_CAPABILITY_ESS;
-
-	if (sband->band == IEEE80211_BAND_2GHZ) {
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
-		if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE))
-			capab |= WLAN_CAPABILITY_SHORT_PREAMBLE;
-	}
-
-	if (wk->assoc.capability & WLAN_CAPABILITY_PRIVACY)
-		capab |= WLAN_CAPABILITY_PRIVACY;
-
-	if ((wk->assoc.capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
-	    (local->hw.flags & IEEE80211_HW_SPECTRUM_MGMT))
-		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
-	memcpy(mgmt->da, wk->filter_ta, ETH_ALEN);
-	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
-	memcpy(mgmt->bssid, wk->filter_ta, ETH_ALEN);
-
-	if (!is_zero_ether_addr(wk->assoc.prev_bssid)) {
-		skb_put(skb, 10);
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_REASSOC_REQ);
-		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.reassoc_req.listen_interval =
-				cpu_to_le16(local->hw.conf.listen_interval);
-		memcpy(mgmt->u.reassoc_req.current_ap, wk->assoc.prev_bssid,
-		       ETH_ALEN);
-	} else {
-		skb_put(skb, 4);
-		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
-						  IEEE80211_STYPE_ASSOC_REQ);
-		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
-		mgmt->u.assoc_req.listen_interval =
-				cpu_to_le16(local->hw.conf.listen_interval);
-	}
-
-	/* SSID */
-	pos = skb_put(skb, 2 + wk->assoc.ssid_len);
-	*pos++ = WLAN_EID_SSID;
-	*pos++ = wk->assoc.ssid_len;
-	memcpy(pos, wk->assoc.ssid, wk->assoc.ssid_len);
-
-	/* add all rates which were marked to be used above */
-	supp_rates_len = rates_len;
-	if (supp_rates_len > 8)
-		supp_rates_len = 8;
-
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
-		*pos++ = wk->chan->max_power; /* max tx power */
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
-	/* if present, add any custom IEs that go before HT */
-	if (wk->ie_len && wk->ie) {
-		static const u8 before_ht[] = {
-			WLAN_EID_SSID,
-			WLAN_EID_SUPP_RATES,
-			WLAN_EID_EXT_SUPP_RATES,
-			WLAN_EID_PWR_CAPABILITY,
-			WLAN_EID_SUPPORTED_CHANNELS,
-			WLAN_EID_RSN,
-			WLAN_EID_QOS_CAPA,
-			WLAN_EID_RRM_ENABLED_CAPABILITIES,
-			WLAN_EID_MOBILITY_DOMAIN,
-			WLAN_EID_SUPPORTED_REGULATORY_CLASSES,
-		};
-		noffset = ieee80211_ie_split(wk->ie, wk->ie_len,
-					     before_ht, ARRAY_SIZE(before_ht),
-					     offset);
-		pos = skb_put(skb, noffset - offset);
-		memcpy(pos, wk->ie + offset, noffset - offset);
-		offset = noffset;
-	}
-
-	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
-	    local->hw.queues >= 4)
-		ieee80211_add_ht_ie(sdata, skb, wk->assoc.ht_information_ie,
-				    sband, wk->chan, wk->assoc.smps);
-
-	/* if present, add any custom non-vendor IEs that go after HT */
-	if (wk->ie_len && wk->ie) {
-		noffset = ieee80211_ie_split_vendor(wk->ie, wk->ie_len,
-						    offset);
-		pos = skb_put(skb, noffset - offset);
-		memcpy(pos, wk->ie + offset, noffset - offset);
-		offset = noffset;
-	}
-
-	if (wk->assoc.wmm_used && local->hw.queues >= 4) {
-		if (wk->assoc.uapsd_used) {
-			qos_info = local->uapsd_queues;
-			qos_info |= (local->uapsd_max_sp_len <<
-				     IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT);
-		} else {
-			qos_info = 0;
-		}
-
-		pos = skb_put(skb, 9);
-		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
-		*pos++ = 7; /* len */
-		*pos++ = 0x00; /* Microsoft OUI 00:50:F2 */
-		*pos++ = 0x50;
-		*pos++ = 0xf2;
-		*pos++ = 2; /* WME */
-		*pos++ = 0; /* WME info */
-		*pos++ = 1; /* WME ver */
-		*pos++ = qos_info;
-	}
-
-	/* add any remaining custom (i.e. vendor specific here) IEs */
-	if (wk->ie_len && wk->ie) {
-		noffset = wk->ie_len;
-		pos = skb_put(skb, noffset - offset);
-		memcpy(pos, wk->ie + offset, noffset - offset);
-	}
-
-	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
-}
-
-static void ieee80211_remove_auth_bss(struct ieee80211_local *local,
-				      struct ieee80211_work *wk)
-{
-	struct cfg80211_bss *cbss;
-	u16 capa_val = WLAN_CAPABILITY_ESS;
-
-	if (wk->probe_auth.privacy)
-		capa_val |= WLAN_CAPABILITY_PRIVACY;
-
-	cbss = cfg80211_get_bss(local->hw.wiphy, wk->chan, wk->filter_ta,
-				wk->probe_auth.ssid, wk->probe_auth.ssid_len,
-				WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
-				capa_val);
-	if (!cbss)
-		return;
-
-	cfg80211_unlink_bss(local->hw.wiphy, cbss);
-	cfg80211_put_bss(cbss);
-}
-
-static enum work_action __must_check
-ieee80211_direct_probe(struct ieee80211_work *wk)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-
-	if (!wk->probe_auth.synced) {
-		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
-				      IEEE80211_TX_SYNC_AUTH);
-		if (ret)
-			return WORK_ACT_TIMEOUT;
-	}
-	wk->probe_auth.synced = true;
-
-	wk->probe_auth.tries++;
-	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: direct probe to %pM timed out\n",
-		       sdata->name, wk->filter_ta);
-
-		/*
-		 * Most likely AP is not in the range so remove the
-		 * bss struct for that AP.
-		 */
-		ieee80211_remove_auth_bss(local, wk);
-
-		return WORK_ACT_TIMEOUT;
-	}
-
-	printk(KERN_DEBUG "%s: direct probe to %pM (try %d/%i)\n",
-	       sdata->name, wk->filter_ta, wk->probe_auth.tries,
-	       IEEE80211_AUTH_MAX_TRIES);
-
-	/*
-	 * Direct probe is sent to broadcast address as some APs
-	 * will not answer to direct packet in unassociated state.
-	 */
-	ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
-				 wk->probe_auth.ssid_len, NULL, 0,
-				 (u32) -1, true, false);
-
-	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-	run_again(local, wk->timeout);
-
-	return WORK_ACT_NONE;
-}
-
-
-static enum work_action __must_check
-ieee80211_authenticate(struct ieee80211_work *wk)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-
-	if (!wk->probe_auth.synced) {
-		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
-				      IEEE80211_TX_SYNC_AUTH);
-		if (ret)
-			return WORK_ACT_TIMEOUT;
-	}
-	wk->probe_auth.synced = true;
-
-	wk->probe_auth.tries++;
-	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: authentication with %pM"
-		       " timed out\n", sdata->name, wk->filter_ta);
-
-		/*
-		 * Most likely AP is not in the range so remove the
-		 * bss struct for that AP.
-		 */
-		ieee80211_remove_auth_bss(local, wk);
-
-		return WORK_ACT_TIMEOUT;
-	}
-
-	printk(KERN_DEBUG "%s: authenticate with %pM (try %d)\n",
-	       sdata->name, wk->filter_ta, wk->probe_auth.tries);
-
-	ieee80211_send_auth(sdata, 1, wk->probe_auth.algorithm, wk->ie,
-			    wk->ie_len, wk->filter_ta, wk->filter_ta, NULL, 0,
-			    0);
-	wk->probe_auth.transaction = 2;
-
-	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
-	run_again(local, wk->timeout);
-
-	return WORK_ACT_NONE;
-}
-
-static enum work_action __must_check
-ieee80211_associate(struct ieee80211_work *wk)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-
-	if (!wk->assoc.synced) {
-		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
-				      IEEE80211_TX_SYNC_ASSOC);
-		if (ret)
-			return WORK_ACT_TIMEOUT;
-	}
-	wk->assoc.synced = true;
-
-	wk->assoc.tries++;
-	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
-		printk(KERN_DEBUG "%s: association with %pM"
-		       " timed out\n",
-		       sdata->name, wk->filter_ta);
-
-		/*
-		 * Most likely AP is not in the range so remove the
-		 * bss struct for that AP.
-		 */
-		if (wk->assoc.bss)
-			cfg80211_unlink_bss(local->hw.wiphy, wk->assoc.bss);
-
-		return WORK_ACT_TIMEOUT;
-	}
-
-	printk(KERN_DEBUG "%s: associate with %pM (try %d)\n",
-	       sdata->name, wk->filter_ta, wk->assoc.tries);
-	ieee80211_send_assoc(sdata, wk);
-
-	wk->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
-	run_again(local, wk->timeout);
-
-	return WORK_ACT_NONE;
-}
-
 static enum work_action __must_check
 ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
 {
@@ -569,300 +103,6 @@ ieee80211_offchannel_tx(struct ieee80211
 	return WORK_ACT_TIMEOUT;
 }
 
-static enum work_action __must_check
-ieee80211_assoc_beacon_wait(struct ieee80211_work *wk)
-{
-	if (wk->started)
-		return WORK_ACT_TIMEOUT;
-
-	/*
-	 * Wait up to one beacon interval ...
-	 * should this be more if we miss one?
-	 */
-	printk(KERN_DEBUG "%s: waiting for beacon from %pM\n",
-	       wk->sdata->name, wk->filter_ta);
-	wk->timeout = TU_TO_EXP_TIME(wk->assoc.bss->beacon_interval);
-	return WORK_ACT_NONE;
-}
-
-static void ieee80211_auth_challenge(struct ieee80211_work *wk,
-				     struct ieee80211_mgmt *mgmt,
-				     size_t len)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	u8 *pos;
-	struct ieee802_11_elems elems;
-
-	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
-	if (!elems.challenge)
-		return;
-	ieee80211_send_auth(sdata, 3, wk->probe_auth.algorithm,
-			    elems.challenge - 2, elems.challenge_len + 2,
-			    wk->filter_ta, wk->filter_ta, wk->probe_auth.key,
-			    wk->probe_auth.key_len, wk->probe_auth.key_idx);
-	wk->probe_auth.transaction = 4;
-}
-
-static enum work_action __must_check
-ieee80211_rx_mgmt_auth(struct ieee80211_work *wk,
-		       struct ieee80211_mgmt *mgmt, size_t len)
-{
-	u16 auth_alg, auth_transaction, status_code;
-
-	if (wk->type != IEEE80211_WORK_AUTH)
-		return WORK_ACT_MISMATCH;
-
-	if (len < 24 + 6)
-		return WORK_ACT_NONE;
-
-	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
-	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
-	status_code = le16_to_cpu(mgmt->u.auth.status_code);
-
-	if (auth_alg != wk->probe_auth.algorithm ||
-	    auth_transaction != wk->probe_auth.transaction)
-		return WORK_ACT_NONE;
-
-	if (status_code != WLAN_STATUS_SUCCESS) {
-		printk(KERN_DEBUG "%s: %pM denied authentication (status %d)\n",
-		       wk->sdata->name, mgmt->sa, status_code);
-		return WORK_ACT_DONE;
-	}
-
-	switch (wk->probe_auth.algorithm) {
-	case WLAN_AUTH_OPEN:
-	case WLAN_AUTH_LEAP:
-	case WLAN_AUTH_FT:
-		break;
-	case WLAN_AUTH_SHARED_KEY:
-		if (wk->probe_auth.transaction != 4) {
-			ieee80211_auth_challenge(wk, mgmt, len);
-			/* need another frame */
-			return WORK_ACT_NONE;
-		}
-		break;
-	default:
-		WARN_ON(1);
-		return WORK_ACT_NONE;
-	}
-
-	printk(KERN_DEBUG "%s: authenticated\n", wk->sdata->name);
-	return WORK_ACT_DONE;
-}
-
-static enum work_action __must_check
-ieee80211_rx_mgmt_assoc_resp(struct ieee80211_work *wk,
-			     struct ieee80211_mgmt *mgmt, size_t len,
-			     bool reassoc)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-	u16 capab_info, status_code, aid;
-	struct ieee802_11_elems elems;
-	u8 *pos;
-
-	if (wk->type != IEEE80211_WORK_ASSOC)
-		return WORK_ACT_MISMATCH;
-
-	/*
-	 * AssocResp and ReassocResp have identical structure, so process both
-	 * of them in this function.
-	 */
-
-	if (len < 24 + 6)
-		return WORK_ACT_NONE;
-
-	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
-	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
-	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);
-
-	printk(KERN_DEBUG "%s: RX %sssocResp from %pM (capab=0x%x "
-	       "status=%d aid=%d)\n",
-	       sdata->name, reassoc ? "Rea" : "A", mgmt->sa,
-	       capab_info, status_code, (u16)(aid & ~(BIT(15) | BIT(14))));
-
-	pos = mgmt->u.assoc_resp.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *) mgmt), &elems);
-
-	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
-	    elems.timeout_int && elems.timeout_int_len == 5 &&
-	    elems.timeout_int[0] == WLAN_TIMEOUT_ASSOC_COMEBACK) {
-		u32 tu, ms;
-		tu = get_unaligned_le32(elems.timeout_int + 1);
-		ms = tu * 1024 / 1000;
-		printk(KERN_DEBUG "%s: %pM rejected association temporarily; "
-		       "comeback duration %u TU (%u ms)\n",
-		       sdata->name, mgmt->sa, tu, ms);
-		wk->timeout = jiffies + msecs_to_jiffies(ms);
-		if (ms > IEEE80211_ASSOC_TIMEOUT)
-			run_again(local, wk->timeout);
-		return WORK_ACT_NONE;
-	}
-
-	if (status_code != WLAN_STATUS_SUCCESS)
-		printk(KERN_DEBUG "%s: %pM denied association (code=%d)\n",
-		       sdata->name, mgmt->sa, status_code);
-	else
-		printk(KERN_DEBUG "%s: associated\n", sdata->name);
-
-	return WORK_ACT_DONE;
-}
-
-static enum work_action __must_check
-ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
-			     struct ieee80211_mgmt *mgmt, size_t len,
-			     struct ieee80211_rx_status *rx_status)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-	size_t baselen;
-
-	ASSERT_WORK_MTX(local);
-
-	if (wk->type != IEEE80211_WORK_DIRECT_PROBE)
-		return WORK_ACT_MISMATCH;
-
-	if (len < 24 + 12)
-		return WORK_ACT_NONE;
-
-	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
-	if (baselen > len)
-		return WORK_ACT_NONE;
-
-	printk(KERN_DEBUG "%s: direct probe responded\n", sdata->name);
-	return WORK_ACT_DONE;
-}
-
-static enum work_action __must_check
-ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
-			 struct ieee80211_mgmt *mgmt, size_t len)
-{
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
-
-	ASSERT_WORK_MTX(local);
-
-	if (wk->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
-		return WORK_ACT_MISMATCH;
-
-	if (len < 24 + 12)
-		return WORK_ACT_NONE;
-
-	printk(KERN_DEBUG "%s: beacon received\n", sdata->name);
-	return WORK_ACT_DONE;
-}
-
-static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
-					  struct sk_buff *skb)
-{
-	struct ieee80211_rx_status *rx_status;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_work *wk;
-	enum work_action rma = WORK_ACT_NONE;
-	u16 fc;
-
-	rx_status = (struct ieee80211_rx_status *) skb->cb;
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
-
-	mutex_lock(&local->mtx);
-
-	list_for_each_entry(wk, &local->work_list, list) {
-		const u8 *bssid = NULL;
-
-		switch (wk->type) {
-		case IEEE80211_WORK_DIRECT_PROBE:
-		case IEEE80211_WORK_AUTH:
-		case IEEE80211_WORK_ASSOC:
-		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
-			bssid = wk->filter_ta;
-			break;
-		default:
-			continue;
-		}
-
-		/*
-		 * Before queuing, we already verified mgmt->sa,
-		 * so this is needed just for matching.
-		 */
-		if (compare_ether_addr(bssid, mgmt->bssid))
-			continue;
-
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_BEACON:
-			rma = ieee80211_rx_mgmt_beacon(wk, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_PROBE_RESP:
-			rma = ieee80211_rx_mgmt_probe_resp(wk, mgmt, skb->len,
-							   rx_status);
-			break;
-		case IEEE80211_STYPE_AUTH:
-			rma = ieee80211_rx_mgmt_auth(wk, mgmt, skb->len);
-			break;
-		case IEEE80211_STYPE_ASSOC_RESP:
-			rma = ieee80211_rx_mgmt_assoc_resp(wk, mgmt,
-							   skb->len, false);
-			break;
-		case IEEE80211_STYPE_REASSOC_RESP:
-			rma = ieee80211_rx_mgmt_assoc_resp(wk, mgmt,
-							   skb->len, true);
-			break;
-		default:
-			WARN_ON(1);
-			rma = WORK_ACT_NONE;
-		}
-
-		/*
-		 * We've either received an unexpected frame, or we have
-		 * multiple work items and need to match the frame to the
-		 * right one.
-		 */
-		if (rma == WORK_ACT_MISMATCH)
-			continue;
-
-		/*
-		 * We've processed this frame for that work, so it can't
-		 * belong to another work struct.
-		 * NB: this is also required for correctness for 'rma'!
-		 */
-		break;
-	}
-
-	switch (rma) {
-	case WORK_ACT_MISMATCH:
-		/* ignore this unmatched frame */
-		break;
-	case WORK_ACT_NONE:
-		break;
-	case WORK_ACT_DONE:
-		list_del_rcu(&wk->list);
-		break;
-	default:
-		WARN(1, "unexpected: %d", rma);
-	}
-
-	mutex_unlock(&local->mtx);
-
-	if (rma != WORK_ACT_DONE)
-		goto out;
-
-	switch (wk->done(wk, skb)) {
-	case WORK_DONE_DESTROY:
-		free_work(wk);
-		break;
-	case WORK_DONE_REQUEUE:
-		synchronize_rcu();
-		wk->started = false; /* restart */
-		mutex_lock(&local->mtx);
-		list_add_tail(&wk->list, &local->work_list);
-		mutex_unlock(&local->mtx);
-	}
-
- out:
-	kfree_skb(skb);
-}
-
 static void ieee80211_work_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
@@ -877,7 +117,6 @@ static void ieee80211_work_work(struct w
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, work_work);
-	struct sk_buff *skb;
 	struct ieee80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum work_action rma;
@@ -893,10 +132,6 @@ static void ieee80211_work_work(struct w
 	if (WARN(local->suspended, "work scheduled while going to suspend\n"))
 		return;
 
-	/* first process frames to avoid timing out while a frame is pending */
-	while ((skb = skb_dequeue(&local->work_skb_queue)))
-		ieee80211_work_rx_queued_mgmt(local, skb);
-
 	mutex_lock(&local->mtx);
 
 	ieee80211_recalc_idle(local);
@@ -947,24 +182,12 @@ static void ieee80211_work_work(struct w
 		case IEEE80211_WORK_ABORT:
 			rma = WORK_ACT_TIMEOUT;
 			break;
-		case IEEE80211_WORK_DIRECT_PROBE:
-			rma = ieee80211_direct_probe(wk);
-			break;
-		case IEEE80211_WORK_AUTH:
-			rma = ieee80211_authenticate(wk);
-			break;
-		case IEEE80211_WORK_ASSOC:
-			rma = ieee80211_associate(wk);
-			break;
 		case IEEE80211_WORK_REMAIN_ON_CHANNEL:
 			rma = ieee80211_remain_on_channel_timeout(wk);
 			break;
 		case IEEE80211_WORK_OFFCHANNEL_TX:
 			rma = ieee80211_offchannel_tx(wk);
 			break;
-		case IEEE80211_WORK_ASSOC_BEACON_WAIT:
-			rma = ieee80211_assoc_beacon_wait(wk);
-			break;
 		}
 
 		wk->started = started;
@@ -1052,7 +275,6 @@ void ieee80211_work_init(struct ieee8021
 	setup_timer(&local->work_timer, ieee80211_work_timer,
 		    (unsigned long)local);
 	INIT_WORK(&local->work_work, ieee80211_work_work);
-	skb_queue_head_init(&local->work_skb_queue);
 }
 
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
@@ -1086,43 +308,6 @@ void ieee80211_work_purge(struct ieee802
 	mutex_unlock(&local->mtx);
 }
 
-ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
-					   struct sk_buff *skb)
-{
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_mgmt *mgmt;
-	struct ieee80211_work *wk;
-	u16 fc;
-
-	if (skb->len < 24)
-		return RX_DROP_MONITOR;
-
-	mgmt = (struct ieee80211_mgmt *) skb->data;
-	fc = le16_to_cpu(mgmt->frame_control);
-
-	list_for_each_entry_rcu(wk, &local->work_list, list) {
-		if (sdata != wk->sdata)
-			continue;
-		if (compare_ether_addr(wk->filter_ta, mgmt->sa))
-			continue;
-		if (compare_ether_addr(wk->filter_ta, mgmt->bssid))
-			continue;
-
-		switch (fc & IEEE80211_FCTL_STYPE) {
-		case IEEE80211_STYPE_AUTH:
-		case IEEE80211_STYPE_PROBE_RESP:
-		case IEEE80211_STYPE_ASSOC_RESP:
-		case IEEE80211_STYPE_REASSOC_RESP:
-		case IEEE80211_STYPE_BEACON:
-			skb_queue_tail(&local->work_skb_queue, skb);
-			ieee80211_queue_work(&local->hw, &local->work_work);
-			return RX_QUEUED;
-		}
-	}
-
-	return RX_CONTINUE;
-}
-
 static enum work_done_result ieee80211_remain_done(struct ieee80211_work *wk,
 						   struct sk_buff *skb)
 {
--- a/net/mac80211/Makefile	2012-01-20 13:54:09.000000000 +0100
+++ b/net/mac80211/Makefile	2012-01-20 13:54:21.000000000 +0100
@@ -9,7 +9,7 @@ mac80211-y := \
 	scan.o offchannel.o \
 	ht.o agg-tx.o agg-rx.o \
 	ibss.o \
-	mlme.o work.o \
+	work.o \
 	iface.o \
 	rate.o \
 	michael.o \
@@ -25,7 +25,7 @@ mac80211-y := \
 	wme.o \
 	event.o \
 	chan.o \
-	driver-trace.o
+	driver-trace.o mlme.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
--- a/net/mac80211/cfg.c	2012-01-20 13:54:17.000000000 +0100
+++ b/net/mac80211/cfg.c	2012-01-20 13:54:21.000000000 +0100
@@ -2018,7 +2018,7 @@ ieee80211_offchan_tx_done(struct ieee802
 	if (wk->offchan_tx.wait && !wk->offchan_tx.status)
 		cfg80211_mgmt_tx_status(wk->sdata->dev,
 					(unsigned long) wk->offchan_tx.frame,
-					wk->ie, wk->ie_len, false, GFP_KERNEL);
+					wk->data, wk->data_len, false, GFP_KERNEL);
 
 	return WORK_DONE_DESTROY;
 }
@@ -2169,8 +2169,8 @@ static int ieee80211_mgmt_tx(struct wiph
 	wk->done = ieee80211_offchan_tx_done;
 	wk->offchan_tx.frame = skb;
 	wk->offchan_tx.wait = wait;
-	wk->ie_len = len;
-	memcpy(wk->ie, buf, len);
+	wk->data_len = len;
+	memcpy(wk->data, buf, len);
 
 	ieee80211_add_work(wk);
 	return 0;
--- a/net/mac80211/iface.c	2012-01-20 13:54:16.000000000 +0100
+++ b/net/mac80211/iface.c	2012-01-20 13:54:21.000000000 +0100
@@ -1303,7 +1303,9 @@ u32 __ieee80211_recalc_idle(struct ieee8
 
 		/* do not count disabled managed interfaces */
 		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-		    !sdata->u.mgd.associated) {
+		    !sdata->u.mgd.associated &&
+		    !sdata->u.mgd.auth_data &&
+		    !sdata->u.mgd.assoc_data) {
 			sdata->vif.bss_conf.idle = true;
 			continue;
 		}
--- a/net/mac80211/main.c	2012-01-20 13:54:19.000000000 +0100
+++ b/net/mac80211/main.c	2012-01-20 13:54:21.000000000 +0100
@@ -198,15 +198,7 @@ void ieee80211_bss_info_change_notify(st
 		return;
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-		/*
-		 * While not associated, claim a BSSID of all-zeroes
-		 * so that drivers don't do any weird things with the
-		 * BSSID at that time.
-		 */
-		if (sdata->vif.bss_conf.assoc)
-			sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
-		else
-			sdata->vif.bss_conf.bssid = zero;
+		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 	else if (sdata->vif.type == NL80211_IFTYPE_AP)


