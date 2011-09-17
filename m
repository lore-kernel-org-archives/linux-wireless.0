Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52171 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1IQWPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 18:15:34 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so2775517fxe.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 15:15:34 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Simon <an.alexsimon@googlemail.com>
Subject: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
Date: Sun, 18 Sep 2011 00:14:56 +0200
Message-Id: <c06e69fca577a9f162c3d69b4a7e7a212788ee7b.1316297595.git.an.alexsimon@googlemail.com> (sfid-20110918_001538_690790_298428CF)
In-Reply-To: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
In-Reply-To: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HT mode is set by iw (previous patchsets).
The interface is set into the specified HT mode.
HT mode and capabilities are announced in beacons.

If we add a station that uses HT also, the fastest matching HT mode will be used
for transmission. That means if we are using HT40+ and we add a station running
on HT40-, we would transfer at HT20.

If we join an IBSS with HT40, but the HT40 channel map or regdom blocks it, we
will fall back into HT20.

Allow frame aggregation to start in IBSS mode.

Signed-off-by: Alexander Simon <an.alexsimon@googlemail.com>
---
 net/mac80211/agg-rx.c      |    2 +
 net/mac80211/agg-tx.c      |    5 ++-
 net/mac80211/ht.c          |    2 +
 net/mac80211/ibss.c        |   88 ++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/rx.c          |    3 +-
 6 files changed, 88 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index e6cab51..89d882d 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -180,6 +180,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 3cef5a7..bedd702 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -81,6 +81,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
@@ -379,7 +381,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 2b9b52c..da1c432 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -199,6 +199,8 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_ADHOC)
+		memcpy(mgmt->bssid, sdata->u.ibss.bssid, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 836b275..1810f57 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -77,6 +77,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *bss;
 	u32 bss_change;
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
+	enum nl80211_channel_type channel_type;
 
 	lockdep_assert_held(&ifibss->mtx);
 
@@ -104,8 +105,16 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	local->oper_channel = chan;
-	WARN_ON(!ieee80211_set_channel_type(local, sdata, NL80211_CHAN_NO_HT));
+	channel_type = ifibss->channel_type;
+	if (channel_type > NL80211_CHAN_HT20 &&
+	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
+		channel_type = NL80211_CHAN_HT20;
+	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
+		/* can only fail due to HT40+/- mismatch */
+		channel_type = NL80211_CHAN_HT20;
+		WARN_ON(!ieee80211_set_channel_type(local, sdata,
+						    NL80211_CHAN_HT20));
+	}
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	sband = local->hw.wiphy->bands[chan->band];
@@ -171,6 +180,18 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		memcpy(skb_put(skb, ifibss->ie_len),
 		       ifibss->ie, ifibss->ie_len);
 
+	/* add HT capability and information IEs */
+	if (channel_type && sband->ht_cap.ht_supported) {
+		pos = skb_put(skb, 4 +
+				   sizeof(struct ieee80211_ht_cap) +
+				   sizeof(struct ieee80211_ht_info));
+		pos = ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+		pos = ieee80211_ie_build_ht_info(pos,
+						 &sband->ht_cap,
+						 chan,
+						 channel_type);
+	}
+
 	if (local->hw.queues >= 4) {
 		pos = skb_put(skb, 9);
 		*pos++ = WLAN_EID_VENDOR_SPECIFIC;
@@ -194,6 +215,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	bss_change |= BSS_CHANGED_BEACON;
 	bss_change |= BSS_CHANGED_BEACON_ENABLED;
 	bss_change |= BSS_CHANGED_BASIC_RATES;
+	bss_change |= BSS_CHANGED_HT;
 	bss_change |= BSS_CHANGED_IBSS;
 	sdata->vif.bss_conf.ibss_joined = true;
 	ieee80211_bss_info_change_notify(sdata, bss_change);
@@ -266,6 +288,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 	u64 beacon_timestamp, rx_timestamp;
 	u32 supp_rates = 0;
 	enum ieee80211_band band = rx_status->band;
+	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 
 	if (elems->ds_params && elems->ds_params_len == 1)
 		freq = ieee80211_channel_to_frequency(elems->ds_params[0],
@@ -275,7 +298,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 
 	channel = ieee80211_get_channel(local->hw.wiphy, freq);
 
-	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+	if (!channel ||
+	    channel->flags & (IEEE80211_CHAN_DISABLED ||
+			      IEEE80211_CHAN_NO_IBSS ||
+			      IEEE80211_CHAN_RADAR))
 		return;
 
 	if (sdata->vif.type == NL80211_IFTYPE_ADHOC &&
@@ -313,8 +339,41 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 						GFP_ATOMIC);
 		}
 
-		if (sta && elems->wmm_info)
-			set_sta_flags(sta, WLAN_STA_WME);
+		if (sta) {
+			if (elems->wmm_info)
+				set_sta_flags(sta, WLAN_STA_WME);
+
+			/* we both use HT */
+			if (elems->ht_info_elem && elems->ht_cap_elem &&
+			    sdata->u.ibss.channel_type) {
+				enum nl80211_channel_type channel_type =
+					ieee80211_ht_info_to_channel_type(
+							   elems->ht_info_elem);
+				struct ieee80211_sta_ht_cap sta_ht_cap_new;
+
+				/*
+				 * fall back to HT20 if we don't use or use
+				 * the other extension channel
+				 */
+				if (channel_type > NL80211_CHAN_HT20 &&
+				    channel_type != sdata->u.ibss.channel_type)
+					channel_type = NL80211_CHAN_HT20;
+
+				ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+						elems->ht_cap_elem,
+						&sta_ht_cap_new);
+				if (memcmp(&sta->sta.ht_cap, &sta_ht_cap_new,
+					   sizeof(sta_ht_cap_new))) {
+					memcpy(&sta->sta.ht_cap,
+					       &sta_ht_cap_new,
+					       sizeof(sta_ht_cap_new));
+					rate_control_rate_update(local, sband,
+							sta,
+							IEEE80211_RC_HT_CHANGED,
+							channel_type);
+				}
+			}
+		}
 
 		rcu_read_unlock();
 	}
@@ -896,10 +955,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *skb;
 
 	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
-			    36 /* bitrates */ +
-			    34 /* SSID */ +
-			    3  /* DS params */ +
-			    4  /* IBSS params */ +
+			    sizeof(struct ieee80211_hdr_3addr) +
+			    12 /* struct ieee80211_mgmt.u.beacon */ +
+			    2 + IEEE80211_MAX_SSID_LEN /* max SSID */ +
+			    2 + 8 /* max Supported Rates */ +
+			    3 /* max DS params */ +
+			    4 /* IBSS params */ +
+			    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
+			    2 + sizeof(struct ieee80211_ht_cap) +
+			    2 + sizeof(struct ieee80211_ht_info) +
 			    params->ie_len);
 	if (!skb)
 		return -ENOMEM;
@@ -920,13 +984,15 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 
 	sdata->u.ibss.channel = params->channel;
+	sdata->u.ibss.channel_type = params->channel_type;
 	sdata->u.ibss.fixed_channel = params->channel_fixed;
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
 		sdata->local->oper_channel = params->channel;
-		WARN_ON(!ieee80211_set_channel_type(sdata->local, sdata,
-						    NL80211_CHAN_NO_HT));
+		if (!ieee80211_set_channel_type(sdata->local, sdata,
+					       params->channel_type))
+			return -EINVAL;
 	}
 
 	if (params->ie) {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d6ff264..e9ec69b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -465,6 +465,7 @@ struct ieee80211_if_ibss {
 	u8 ssid_len, ie_len;
 	u8 *ie;
 	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
 
 	unsigned long ibss_join_req;
 	/* probe response/beacon for IBSS */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index db46601..51157df 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2163,7 +2163,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_ADHOC)
 			break;
 
 		/* verify action_code is present */
-- 
1.7.3.4

