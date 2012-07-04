Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47424 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab2GDP7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 11:59:05 -0400
Received: by wgbdr13 with SMTP id dr13so7479472wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2012 08:59:03 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [RFC 4/4] mac80211: allow setting HT capabilities per vif
Date: Wed,  4 Jul 2012 18:58:50 +0300
Message-Id: <1341417530-9062-5-git-send-email-arik@wizery.com> (sfid-20120704_175911_673745_2344B353)
In-Reply-To: <1341417530-9062-1-git-send-email-arik@wizery.com>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an array of HT-cap pointers per band to the vif struct. When an HT-cap
is set in the vif, use it. Otherwise resort to the per-band HT cap in the
wiphy struct.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/cfg.c         |   11 +++++++++++
 net/mac80211/ht.c          |   19 +++++++++++--------
 net/mac80211/ibss.c        |   11 +++++++----
 net/mac80211/ieee80211_i.h |    6 +++++-
 net/mac80211/iface.c       |   10 +++++++---
 net/mac80211/main.c        |    2 +-
 net/mac80211/mesh.c        |    9 ++++++---
 net/mac80211/mlme.c        |   20 ++++++++++++++------
 net/mac80211/scan.c        |    5 +++--
 net/mac80211/util.c        |   31 ++++++++++++++++++++++++++-----
 11 files changed, 95 insertions(+), 33 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e3fa90c..2dc5b8e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -897,6 +897,8 @@ enum ieee80211_vif_flags {
  *	at runtime, mac80211 will never touch this field
  * @hw_queue: hardware queue for each AC
  * @cab_queue: content-after-beacon (DTIM beacon really) queue, AP mode only
+ * @ht_cap: per-band HT capabilities for this vif, used if non-NULL. These
+ *	need to be set when the interface is added.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *).
  */
@@ -911,6 +913,8 @@ struct ieee80211_vif {
 
 	u32 driver_flags;
 
+	struct ieee80211_sta_ht_cap *ht_cap[IEEE80211_NUM_BANDS];
+
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ccbe241..6a40a83 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2997,6 +2997,16 @@ static void ieee80211_set_wakeup(struct wiphy *wiphy, bool enabled)
 }
 #endif
 
+static struct ieee80211_sta_ht_cap *
+ieee80211_get_ht_cap(struct wiphy *wiphy,
+		     struct net_device *dev,
+		     enum ieee80211_band band)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return ieee80211_sdata_get_ht_cap(sdata, band);
+}
+
 struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3071,4 +3081,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_sset_count = ieee80211_get_et_sset_count,
 	.get_et_stats = ieee80211_get_et_stats,
 	.get_et_strings = ieee80211_get_et_strings,
+	.get_ht_cap = ieee80211_get_ht_cap,
 };
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 4b4538d..1a507a2 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -93,12 +93,14 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 {
 	u8 ampdu_info, tx_mcs_set_cap;
 	int i, max_tx_streams;
+	struct ieee80211_sta_ht_cap *local_ht_cap;
 
 	BUG_ON(!ht_cap);
 
 	memset(ht_cap, 0, sizeof(*ht_cap));
 
-	if (!ht_cap_ie || !sband->ht_cap.ht_supported)
+	local_ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
+	if (!ht_cap_ie || !local_ht_cap->ht_supported)
 		return;
 
 	ht_cap->ht_supported = true;
@@ -110,7 +112,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * we mask them out.
 	 */
 	ht_cap->cap = le16_to_cpu(ht_cap_ie->cap_info) &
-		(sband->ht_cap.cap |
+		(local_ht_cap->cap |
 		 ~(IEEE80211_HT_CAP_LDPC_CODING |
 		   IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 		   IEEE80211_HT_CAP_GRN_FLD |
@@ -121,9 +123,9 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 * The STBC bits are asymmetric -- if we don't have
 	 * TX then mask out the peer's RX and vice versa.
 	 */
-	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
+	if (!(local_ht_cap->cap & IEEE80211_HT_CAP_TX_STBC))
 		ht_cap->cap &= ~IEEE80211_HT_CAP_RX_STBC;
-	if (!(sband->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC))
+	if (!(local_ht_cap->cap & IEEE80211_HT_CAP_RX_STBC))
 		ht_cap->cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
 	ampdu_info = ht_cap_ie->ampdu_params_info;
@@ -133,7 +135,7 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 		(ampdu_info & IEEE80211_HT_AMPDU_PARM_DENSITY) >> 2;
 
 	/* own MCS TX capabilities */
-	tx_mcs_set_cap = sband->ht_cap.mcs.tx_params;
+	tx_mcs_set_cap = local_ht_cap->mcs.tx_params;
 
 	/* Copy peer MCS TX capabilities, the driver might need them. */
 	ht_cap->mcs.tx_params = ht_cap_ie->mcs.tx_params;
@@ -159,17 +161,18 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	 */
 	for (i = 0; i < max_tx_streams; i++)
 		ht_cap->mcs.rx_mask[i] =
-			sband->ht_cap.mcs.rx_mask[i] & ht_cap_ie->mcs.rx_mask[i];
+			local_ht_cap->mcs.rx_mask[i] &
+			ht_cap_ie->mcs.rx_mask[i];
 
 	if (tx_mcs_set_cap & IEEE80211_HT_MCS_TX_UNEQUAL_MODULATION)
 		for (i = IEEE80211_HT_MCS_UNEQUAL_MODULATION_START_BYTE;
 		     i < IEEE80211_HT_MCS_MASK_LEN; i++)
 			ht_cap->mcs.rx_mask[i] =
-				sband->ht_cap.mcs.rx_mask[i] &
+				local_ht_cap->mcs.rx_mask[i] &
 					ht_cap_ie->mcs.rx_mask[i];
 
 	/* handle MCS rate 32 too */
-	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
+	if (local_ht_cap->mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
 
 	/*
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 5746d62..7b215ff7 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -52,6 +52,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	enum nl80211_channel_type channel_type;
+	struct ieee80211_sta_ht_cap *local_ht_cap;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -155,19 +156,21 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	local_ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
+
 	/* add HT capability and information IEs */
-	if (channel_type && sband->ht_cap.ht_supported) {
+	if (channel_type && local_ht_cap->ht_supported) {
 		pos = skb_put(skb, 4 +
 				   sizeof(struct ieee80211_ht_cap) +
 				   sizeof(struct ieee80211_ht_operation));
-		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
-						sband->ht_cap.cap);
+		pos = ieee80211_ie_build_ht_cap(pos, local_ht_cap,
+						local_ht_cap->cap);
 		/*
 		 * Note: According to 802.11n-2009 9.13.3.1, HT Protection
 		 * field and RIFS Mode are reserved in IBSS mode, therefore
 		 * keep them at 0
 		 */
-		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
+		pos = ieee80211_ie_build_ht_oper(pos, local_ht_cap,
 						 chan, channel_type, 0);
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e28a5b1..b0d45b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1452,7 +1452,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx);
-int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+int ieee80211_build_preq_ies(struct ieee80211_sub_if_data *sdata, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
@@ -1491,11 +1491,15 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 			    struct sk_buff *skb, bool need_basic);
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 				struct sk_buff *skb, bool need_basic);
+struct ieee80211_sta_ht_cap *
+ieee80211_sdata_get_ht_cap(struct ieee80211_sub_if_data *sdata,
+			   enum ieee80211_band band);
 
 /* virtual monitor */
 int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
 void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
+
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index fbef7a1..10c22a8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1433,13 +1433,17 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		sband = local->hw.wiphy->bands[i];
 		sdata->rc_rateidx_mask[i] =
 			sband ? (1 << sband->n_bitrates) - 1 : 0;
-		if (sband)
+		if (sband) {
+			struct ieee80211_sta_ht_cap *local_ht_cap;
+			local_ht_cap = ieee80211_sdata_get_ht_cap(sdata,
+								  sband->band);
 			memcpy(sdata->rc_rateidx_mcs_mask[i],
-			       sband->ht_cap.mcs.rx_mask,
+			       local_ht_cap->mcs.rx_mask,
 			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
-		else
+		} else {
 			memset(sdata->rc_rateidx_mcs_mask[i], 0,
 			       sizeof(sdata->rc_rateidx_mcs_mask[i]));
+		}
 	}
 
 	ieee80211_set_default_queues(sdata);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c794101..0da0f8c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -749,7 +749,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
-		supp_ht = supp_ht || sband->ht_cap.ht_supported;
+		supp_ht = supp_ht || sband->ht_supported;
 		supp_vht = supp_vht || sband->vht_cap.vht_supported;
 	}
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 764593d..5ec05376 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -370,18 +370,20 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_ht_cap *ht_cap;
 	u8 *pos;
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
-	if (!sband->ht_cap.ht_supported ||
+	if (!sband->ht_supported ||
 	    local->_oper_channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
 		return -ENOMEM;
 
+	ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
-	ieee80211_ie_build_ht_cap(pos, &sband->ht_cap, sband->ht_cap.cap);
+	ieee80211_ie_build_ht_cap(pos, ht_cap, ht_cap->cap);
 
 	return 0;
 }
@@ -394,9 +396,10 @@ int mesh_add_ht_oper_ie(struct sk_buff *skb,
 	enum nl80211_channel_type channel_type = local->_oper_channel_type;
 	struct ieee80211_supported_band *sband =
 				local->hw.wiphy->bands[channel->band];
-	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
+	struct ieee80211_sta_ht_cap *ht_cap;
 	u8 *pos;
 
+	ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
 	if (!ht_cap->ht_supported || channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 4e53711..60978e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -268,9 +268,10 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 	u16 cap;
 	struct ieee80211_sta_ht_cap ht_cap;
 
-	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
+	memcpy(&ht_cap,
+	       ieee80211_sdata_get_ht_cap(sdata, sband->band),
+	       sizeof(ht_cap));
 
-	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
 	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
 
 	/* determine capability flags */
@@ -3013,6 +3014,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	const u8 *ht_oper_ie;
 	const struct ieee80211_ht_operation *ht_oper = NULL;
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_sta_ht_cap *local_ht_cap;
 
 	if (WARN_ON(!ifmgd->auth_data && !ifmgd->assoc_data))
 		return -EINVAL;
@@ -3035,10 +3037,11 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 
 	/* switch to the right channel */
 	sband = local->hw.wiphy->bands[cbss->channel->band];
+	local_ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
 
 	ifmgd->flags &= ~IEEE80211_STA_DISABLE_40MHZ;
 
-	if (sband->ht_cap.ht_supported) {
+	if (local_ht_cap->ht_supported) {
 		ht_oper_ie = cfg80211_find_ie(WLAN_EID_HT_OPERATION,
 					      cbss->information_elements,
 					      cbss->len_information_elements);
@@ -3070,7 +3073,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	if (ht_oper) {
 		channel_type = NL80211_CHAN_HT20;
 
-		if (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
+		if (local_ht_cap->cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) {
 			switch (ht_oper->ht_param &
 					IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 			case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
@@ -3260,6 +3263,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_supported_band *sband;
 	const u8 *ssidie, *ht_ie;
 	int i, err;
+	struct ieee80211_sta_ht_cap *local_ht_cap;
 
 	ssidie = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
 	if (!ssidie)
@@ -3321,8 +3325,12 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	/* Also disable HT if we don't support it or the AP doesn't use WMM */
 	sband = local->hw.wiphy->bands[req->bss->channel->band];
-	if (!sband->ht_cap.ht_supported ||
-	    local->hw.queues < IEEE80211_NUM_ACS || !bss->wmm_used) {
+	local_ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
+
+	/* Also disable HT if we don't support it or the AP doesn't use WMM */
+	if (!local_ht_cap->ht_supported ||
+	    local->hw.queues < IEEE80211_NUM_ACS ||
+	    !bss->wmm_used) {
 		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 		netdev_info(sdata->dev,
 			    "disabling HT as WMM/QoS is not supported\n");
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 379f178..94eaca9 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -264,7 +264,8 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 
 	local->hw_scan_req->n_channels = n_chans;
 
-	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
+	ielen = ieee80211_build_preq_ies(local->scan_sdata,
+					 (u8 *)local->hw_scan_req->ie,
 					 req->ie, req->ie_len, band,
 					 req->rates[band], 0);
 	local->hw_scan_req->ie_len = ielen;
@@ -939,7 +940,7 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 		}
 
 		local->sched_scan_ies.len[i] =
-			ieee80211_build_preq_ies(local,
+			ieee80211_build_preq_ies(sdata,
 						 local->sched_scan_ies.ie[i],
 						 req->ie, req->ie_len, i,
 						 (u32) -1, 0);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 5715e7b..787529b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -977,18 +977,38 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+struct ieee80211_sta_ht_cap *
+ieee80211_sdata_get_ht_cap(struct ieee80211_sub_if_data *sdata,
+			   enum ieee80211_band band)
+{
+	struct wiphy *wiphy = sdata->local->hw.wiphy;
+
+	if (WARN_ON(!wiphy->bands[band]))
+		return NULL;
+
+	if (sdata->vif.ht_cap[band]) {
+		/* the HT cap must be marked invalid in struct wiphy */
+		WARN_ON(!wiphy->bands[band]->ht_cap_invalid);
+		return sdata->vif.ht_cap[band];
+	}
+
+	return &wiphy->bands[band]->ht_cap;
+}
+
+int ieee80211_build_preq_ies(struct ieee80211_sub_if_data *sdata, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel)
 {
 	struct ieee80211_supported_band *sband;
+	struct ieee80211_local *local = sdata->local;
 	u8 *pos;
 	size_t offset = 0, noffset;
 	int supp_rates_len, i;
 	u8 rates[32];
 	int num_rates;
 	int ext_rates_len;
+	struct ieee80211_sta_ht_cap *local_ht_cap;
 
 	sband = local->hw.wiphy->bands[band];
 
@@ -1056,9 +1076,10 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 		offset = noffset;
 	}
 
-	if (sband->ht_cap.ht_supported)
-		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
-						sband->ht_cap.cap);
+	local_ht_cap = ieee80211_sdata_get_ht_cap(sdata, sband->band);
+	if (local_ht_cap->ht_supported)
+		pos = ieee80211_ie_build_ht_cap(pos, local_ht_cap,
+						local_ht_cap->cap);
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1108,7 +1129,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chan = ieee80211_frequency_to_channel(
 			local->hw.conf.channel->center_freq);
 
-	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
+	buf_len = ieee80211_build_preq_ies(sdata, buf, ie, ie_len,
 					   local->hw.conf.channel->band,
 					   ratemask, chan);
 
-- 
1.7.9.5

