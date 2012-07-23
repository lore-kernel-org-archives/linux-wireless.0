Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab2GWNaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 09:30:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC/RFT 5/6] mac80211: fix current vs. operating channel in preq/beacon
Date: Mon, 23 Jul 2012 15:30:10 +0200
Message-Id: <1343050211-499-6-git-send-email-johannes@sipsolutions.net> (sfid-20120723_153033_482394_86024A0E)
In-Reply-To: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
References: <1343050211-499-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When sending probe requests, e.g. during software scanning,
these will go out on the *current* channel, so their IEs
need to be built from the current channel. At other times,
e.g. for beacons or probe request templates, the IEs will
be used on the *operating* channel and using the current
channel instead might result in errors.

Add the appropriate parameters to respect the difference.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |   20 ++++++++++++++------
 net/mac80211/ieee80211_i.h |    7 +++++--
 net/mac80211/mesh_plink.c  |    6 ++++--
 net/mac80211/mlme.c        |    4 +++-
 net/mac80211/tx.c          |    6 +++---
 net/mac80211/util.c        |   27 +++++++++++++++------------
 6 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 095aa4c..e1fa824 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2669,6 +2669,7 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			       u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tdls_data *tf;
 
 	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
@@ -2688,8 +2689,10 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_req.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false);
-		ieee80211_add_ext_srates_ie(sdata, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false,
+					local->oper_channel->band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false,
+					    local->oper_channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
@@ -2702,8 +2705,10 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false);
-		ieee80211_add_ext_srates_ie(sdata, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false,
+					local->oper_channel->band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false,
+					    local->oper_channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
@@ -2741,6 +2746,7 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			   u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
 
 	mgmt = (void *)skb_put(skb, 24);
@@ -2763,8 +2769,10 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 		mgmt->u.action.u.tdls_discover_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
 
-		ieee80211_add_srates_ie(sdata, skb, false);
-		ieee80211_add_ext_srates_ie(sdata, skb, false);
+		ieee80211_add_srates_ie(sdata, skb, false,
+					local->oper_channel->band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false,
+					    local->oper_channel->band);
 		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 83c6d75..290000d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1460,6 +1460,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     u8 channel);
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst, u32 ratemask,
+					  struct ieee80211_channel *chan,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed);
@@ -1490,9 +1491,11 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 u8 *ieee80211_ie_build_vht_cap(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
 			       u32 cap);
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
-			    struct sk_buff *skb, bool need_basic);
+			    struct sk_buff *skb, bool need_basic,
+			    enum ieee80211_band band);
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb, bool need_basic);
+				struct sk_buff *skb, bool need_basic,
+				enum ieee80211_band band);
 
 /* channel management */
 enum ieee80211_chan_mode {
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4256859..d117c6a 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -258,8 +258,10 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
-		if (ieee80211_add_srates_ie(sdata, skb, true) ||
-		    ieee80211_add_ext_srates_ie(sdata, skb, true) ||
+		if (ieee80211_add_srates_ie(sdata, skb, true,
+					    local->oper_channel->band) ||
+		    ieee80211_add_ext_srates_ie(sdata, skb, true,
+						local->oper_channel->band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81d7b86..e80c325 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1647,7 +1647,9 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 		ssid_len = ssid[1];
 
 	skb = ieee80211_build_probe_req(sdata, cbss->bssid,
-					(u32) -1, ssid + 2, ssid_len,
+					(u32) -1,
+					sdata->local->oper_channel,
+					ssid + 2, ssid_len,
 					NULL, 0, true);
 
 	return skb;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index f50c06b..1d035f0 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2299,7 +2299,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct ieee80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	enum ieee80211_band band = local->oper_channel->band;
 	struct ieee80211_tx_rate_control txrc;
 
 	sband = local->hw.wiphy->bands[band];
@@ -2425,9 +2425,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		*pos++ = WLAN_EID_SSID;
 		*pos++ = 0x0;
 
-		if (ieee80211_add_srates_ie(sdata, skb, true) ||
+		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
-		    ieee80211_add_ext_srates_ie(sdata, skb, true) ||
+		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
 		    mesh_add_ht_oper_ie(skb, sdata) ||
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 69ede01..32ddcd2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1107,6 +1107,7 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 
 struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  u8 *dst, u32 ratemask,
+					  struct ieee80211_channel *chan,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len,
 					  bool directed)
@@ -1116,7 +1117,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_mgmt *mgmt;
 	size_t buf_len;
 	u8 *buf;
-	u8 chan;
+	u8 chan_no;
 
 	/* FIXME: come up with a proper value */
 	buf = kmalloc(200 + ie_len, GFP_KERNEL);
@@ -1129,14 +1130,12 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	 * badly-behaved APs don't respond when this parameter is included.
 	 */
 	if (directed)
-		chan = 0;
+		chan_no = 0;
 	else
-		chan = ieee80211_frequency_to_channel(
-			local->hw.conf.channel->center_freq);
+		chan_no = ieee80211_frequency_to_channel(chan->center_freq);
 
-	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
-					   local->hw.conf.channel->band,
-					   ratemask, chan);
+	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len, chan->band,
+					   ratemask, chan_no);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
 				     ssid, ssid_len,
@@ -1165,7 +1164,9 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 {
 	struct sk_buff *skb;
 
-	skb = ieee80211_build_probe_req(sdata, dst, ratemask, ssid, ssid_len,
+	skb = ieee80211_build_probe_req(sdata, dst, ratemask,
+					sdata->local->hw.conf.channel,
+					ssid, ssid_len,
 					ie, ie_len, directed);
 	if (skb) {
 		if (no_cck)
@@ -1820,7 +1821,8 @@ ieee80211_ht_oper_to_channel_type(struct ieee80211_ht_operation *ht_oper)
 }
 
 int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
-			    struct sk_buff *skb, bool need_basic)
+			    struct sk_buff *skb, bool need_basic,
+			    enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -1828,7 +1830,7 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 	u8 i, rates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[band];
 	rates = sband->n_bitrates;
 	if (rates > 8)
 		rates = 8;
@@ -1851,7 +1853,8 @@ int ieee80211_add_srates_ie(struct ieee80211_sub_if_data *sdata,
 }
 
 int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
-				struct sk_buff *skb, bool need_basic)
+				struct sk_buff *skb, bool need_basic,
+				enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -1859,7 +1862,7 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_sub_if_data *sdata,
 	u8 i, exrates, *pos;
 	u32 basic_rates = sdata->vif.bss_conf.basic_rates;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[band];
 	exrates = sband->n_bitrates;
 	if (exrates > 8)
 		exrates -= 8;
-- 
1.7.10.4

